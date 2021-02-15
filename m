Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BED531BEFF
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhBOQWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:22:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232159AbhBOQUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:20:20 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11FGEtoe021237;
        Mon, 15 Feb 2021 08:19:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=9z/groFo0K6MjJfh0oUWucxrf55RG8RdQXPgTBBl8PQ=;
 b=VA9wW6oQ1sZicR9qn5OgNOPz2ka1WneyNj6cwYy2t8WR8GoAwVesFsntyrTwTdRrNNAC
 1985R2l88GVvcfWuAR9B646Nw/RHCQHEvMxY3BAdCnPYqkSA3wJHuMpGI73Y0GHmFkx9
 vqSIeQvVAXKG19fbdCmmciqE/8/nWy2KcHdZTZDA1EI3yfmqlEbJGr1NyLyNn/2Ccfy5
 J0bukxdgf8pDq5233tiwJ/ZlXNMrvYueseCYDg1VuZmNWYNKd800J/dTblkU+/5ge4Fm
 eo7ifjgbWCNUiNInftQi53+8MuiL8/liwpyvAWCycxfdlkgL4DN27TBjJCDxquKf3ktg UQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vmqcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 08:19:22 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 08:19:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 08:19:21 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 15 Feb 2021 08:19:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXl2L4NGzpFEuukTdthTCx/AUaRv9BFhgxWyrB2AYU1MorkBS55UBWOSOGqART0EKOVSVx0yDN4x7+PYyG+H5qI4HMaPm02rd9W6Edz7xaYgf6l7Vk0u1rCEjXi5vfeis4FL3RoXhcF8j52x0VSofHvqnBosq09vxsYvYBOr2MbIwnZbiaNRX/meemncu7WwpqSuax05mTBaeVh9bgLcFxzJlkxuspBiUukiU6YnAjsMl3Z3zJHcsVGMhko3s0q0bAn7WVvqcvTlqSJp78RlcXBavuf0ow/YDfMn7IqnSdYokQIcWlkEDzNJvefXz8F8DatAxFMANPpOI5ZKDhKi5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z/groFo0K6MjJfh0oUWucxrf55RG8RdQXPgTBBl8PQ=;
 b=VWs6hhFfS8/Aa5T0TdvttBYuiKCzE41a/iuG0DY/DkisbCDPcxB7Hue9v0zbcGf8WZWywGSgaRavmtjbx9C2n7SFCA7j0ZRBx4amAK+wbIRGElWe1WSXAq39gT5cN5NXjOpGUtAIIEKyKJEQu1U66UnXAs64yLObpqHxW61kyyLd/k+614Mfn1R/Es0Wd/eVNSBfxNye33FBNrsKuGxFdgSPFOsnZMuM0QYURF/kyBLmmD5CqA/0tPBHvooRolOXLQ7LAOKLtscWyN9fW2GdPE0SE6RuDDpn83rWVqevZmvSHOe0fKlYJqo5l8yQxGlnFyfmu+YWjs7RwdHIORsD9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z/groFo0K6MjJfh0oUWucxrf55RG8RdQXPgTBBl8PQ=;
 b=qJOsj4PZdTIlbFuHWLaZILUnm1EWRE/fzGYn2cRzC/Yd8OJjsEYiGAYnXX00nIdrWxCpmnDpDfFPkWhr+EcFOpdzgCLJk0zeJ6eUtGcKuZXwDc5HRy7p5oaZ3lDpVKJj864Pk/oPTkPZhpkBTtffTkXUmx8mA191yTZiX+Zag2w=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3466.namprd18.prod.outlook.com (2603:10b6:303:58::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Mon, 15 Feb
 2021 16:19:19 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.042; Mon, 15 Feb 2021
 16:19:19 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        "Yan Markman" <ymarkman@marvell.com>
Subject: RE: [EXT] Re: Phylink flow control support on ports with MLO_AN_FIXED
 auto negotiation
Thread-Topic: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Thread-Index: AQHW98Hz4zCFeEGpzkiViEcs0nVd+apBpzoAgBRjHoCAA3KKEA==
Date:   Mon, 15 Feb 2021 16:19:19 +0000
Message-ID: <CO6PR18MB38732FD9F40B8956B019F719B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131111214.GB1463@shell.armlinux.org.uk>
 <20210131121950.GA1477@shell.armlinux.org.uk>
 <20210213113947.GD1477@shell.armlinux.org.uk>
In-Reply-To: <20210213113947.GD1477@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f111e5f-97f4-4a06-e7fe-08d8d1cd72b9
x-ms-traffictypediagnostic: MW3PR18MB3466:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3466E799E0237EE4B69F4142B0889@MW3PR18MB3466.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IECm0kJ7X3Vla2PJ0F+0E5EpawXOlekWDHmmmJyAJ3AtxuQKTjPdtbgPjLJoSJIQfBIi889KUSHZF+Gxbtnj6TuCiClYjNjlobzdMuX5f3vdCIeuRVE3qw6SRbhh+kg400uDFRBS8PDtJh6jHO8kTLwvnNbU8u/4+64U5YXafdyCD1CWpIoa6BwwFbdZoYufQLA3Wv54TcgXQJUyA+AM6JtOfbb9XqAMIQ66OYBXbmKy5k38fi+RBSA9+vjiY60GZo9wt24K3Hlk2tlM/gV9CqfN4s48gy8QOUcdRF0W6L+WPOpfjAZodPCB2JegNAwE0w1CHTMmKDE6cPhkHjaiOvCovEE62uID60wrxQlRIcKulw6cYBhKyNRIKXqibvJnjn1Z07j6bmX/N6EnCiiA07QtCJslndLWcv9M4hOGzANnlFcTxkwJiM3R0nv6oFo2ZKOLUbLMDfev811qEIGdYoIE9S7GMeQhzgQe4gRVNCgKbTDHFpVoq/wI4jPynWKleGb85S5jgQ3bkT9IoXB9l9ryypBkEH9768DYCm0F156jMprSrL5g+GwnUdVrvOV7DIJJZMJ2k3qipAR5p99UbOFcXS19w7AT1Cllzc8OPjw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(376002)(39850400004)(966005)(33656002)(19627235002)(8936002)(52536014)(6506007)(86362001)(107886003)(5660300002)(316002)(55016002)(9686003)(64756008)(478600001)(4326008)(66446008)(8676002)(76116006)(66476007)(66946007)(26005)(83380400001)(6916009)(186003)(54906003)(7696005)(71200400001)(66556008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2hbrDBSs+0tB6rzAdDQJbQGwTtRqqRd5/SdO9UhDZ4axNoxOi4JNosSfjRY4?=
 =?us-ascii?Q?r1oanLtf9a40LYVdkXgoiq3//Y0pkcv6Sha255vHahv35lrp0ZgundjeByOm?=
 =?us-ascii?Q?FFr4/E4fdsLudoC+P0+5wmqL8FtSXM8XevUhcH4kv93tSUquUa785+e7ilN3?=
 =?us-ascii?Q?U9xD9RP7Szm37a9a1N9KdMPPpu0jSgjd4MnpQ0ULXhP51tGk76s9Ib7gfvJu?=
 =?us-ascii?Q?5FeEFfYgAwypsaKMW5KwekDsEl8fS39oEwznGpo9PIcDpGkE0XErojyhxvYp?=
 =?us-ascii?Q?W9fuIJCNlO01hckrNGbDJc4RnTSNW/txkEbGGcbBKN8CryQRoBb58DkxD1KO?=
 =?us-ascii?Q?eMzpyDcISW74i/IRP89Huq+hw9X3rJ9kWCV7SbXxXJk5ExFhPsmWf5U+sHYG?=
 =?us-ascii?Q?rJwQP4ZhT8WGbCYRbL2fmlwiBgjXw37aX3Hci34IeHCc3tlFiRR4Ca5NKYDA?=
 =?us-ascii?Q?eefLX8/+4gqgxlDpiZ9YoEJRQe/Bn1LYP0idHeRrDW41aEQUtPN5Q9WNGRfS?=
 =?us-ascii?Q?S60zFx5iysR4avn0xnCZxyTe5AEArb/D+NmMZdseHW38Td9I7ZdrOHrKrIuE?=
 =?us-ascii?Q?b17U+xrLMQWBwZ/JwQou+Mz1CmA9WrypBq3AykQgJh35FlppxZRZIq54vr4m?=
 =?us-ascii?Q?s0AJ/35Zwu3SS4CgAezzixXrl7JxXfyLB5SHYsMNNhoJkVFO7EvDDbdrGF2L?=
 =?us-ascii?Q?bAFZcwKFfCRgw29pw2sThX8sUicHk1mqd6OJl/3Me6murrhaPrnhMkbYv/kO?=
 =?us-ascii?Q?vfjy3i8Az6ZXiNVMXkt2l/ifrp6mPEPgEdnZfUx1hgOaOmjqPFefR40OyCGN?=
 =?us-ascii?Q?hrD72Tk8PfXdsxCdZz86rMegLjlWbO9xpmQZS0UBIT0OQg4/m4M9jyiAOVf4?=
 =?us-ascii?Q?PNOFlu0hbBf5WbfBajxBlMdZSho37EWlZsBuJso5tlHhJ1y7g9QK/JdPJpi6?=
 =?us-ascii?Q?bgCfVbxL9tx6xp4crcUgA3eTgWLHWAGYzLQrL3q6CYZyqJ0Ulg3did0ZFhIH?=
 =?us-ascii?Q?gED7lTm2rC8yp9DRIRLsv/+zTkXOZEDaXkL4BBvmkw320AVYIod8fS6dKsjd?=
 =?us-ascii?Q?OtU/l13RLstCM3kgoPIYvNtvnh1hAEnvyxNaYQO+O69KtNrDpE8oLbH8t+jn?=
 =?us-ascii?Q?eMRhb0TZmU9Nrb4jRgl+t9oa1SH7DCnOJIv0izPmdn4A4JA6CIF2vl+R27l7?=
 =?us-ascii?Q?7nx4DHS5BIS+WaBkAZcAfP0jvIFsKhggfKlJiIOIb+tSKuPpjFqbXBQZz1jy?=
 =?us-ascii?Q?H2r8CKaffgwTfu29LGQn07D2uh2FOPCB/CoUZ3hrOoWX0lrOBVUr8wfpP2M0?=
 =?us-ascii?Q?Sx0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f111e5f-97f4-4a06-e7fe-08d8d1cd72b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2021 16:19:19.5375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S4kBUkuxZxDy4IwJh4P1ZgLn+zuw2/D+A5rPtE60Mg0fjwTZI4G4/U3KVie4Iyof9AX4XSFnv+juyUY8lzMrUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3466
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_11:2021-02-12,2021-02-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I discussed it with Andrew earlier last year, and his response was:
> > >
> > >  DT configuration of pause for fixed link probably is sufficient. I
> > > don't  remember it ever been really discussed for DSA. It was a
> > > Melanox  discussion about limiting pause for the CPU. So I think it
> > > is safe to  not implement ethtool -A, at least until somebody has a
> > > real use case  for it.
> > >
> > > So I chose not to support it - no point supporting features that
> > > people aren't using. If you have a "real use case" then it can be add=
ed.
> >
> > This patch may be sufficient - I haven't fully considered all the
> > implications of changing this though.
>=20
> Did you try this patch? What's the outcome?

For me patch worked as expected.

Thanks,
Stefan.=20

> >
> >  drivers/net/phy/phylink.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 7e0fdc17c8ee..2ee0d4dcf9a5 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -673,7 +673,6 @@ static void phylink_resolve(struct work_struct *w)
> >  		switch (pl->cur_link_an_mode) {
> >  		case MLO_AN_PHY:
> >  			link_state =3D pl->phy_state;
> > -			phylink_apply_manual_flow(pl, &link_state);
> >  			mac_config =3D link_state.link;
> >  			break;
> >
> > @@ -698,11 +697,12 @@ static void phylink_resolve(struct work_struct
> *w)
> >  				link_state.pause =3D pl->phy_state.pause;
> >  				mac_config =3D true;
> >  			}
> > -			phylink_apply_manual_flow(pl, &link_state);
> >  			break;
> >  		}
> >  	}
> >
> > +	phylink_apply_manual_flow(pl, &link_state);
> > +
> >  	if (mac_config) {
> >  		if (link_state.interface !=3D pl->link_config.interface) {
> >  			/* The interface has changed, force the link down
> and @@ -1639,9
> > +1639,6 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
> >
> >  	ASSERT_RTNL();
> >
> > -	if (pl->cur_link_an_mode =3D=3D MLO_AN_FIXED)
> > -		return -EOPNOTSUPP;
> > -
> >  	if (!phylink_test(pl->supported, Pause) &&
> >  	    !phylink_test(pl->supported, Asym_Pause))
> >  		return -EOPNOTSUPP;
> > @@ -1684,7 +1681,7 @@ int phylink_ethtool_set_pauseparam(struct
> phylink *pl,
> >  	/* Update our in-band advertisement, triggering a renegotiation if
> >  	 * the advertisement changed.
> >  	 */
> > -	if (!pl->phydev)
> > +	if (!pl->phydev && pl->cur_link_an_mode !=3D MLO_AN_FIXED)
> >  		phylink_change_inband_advert(pl);
> >
> >  	mutex_unlock(&pl->state_mutex);
> >
> > --
> > RMK's Patch system:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__www.armlinux.org.
> >
> uk_developer_patches_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DDDQ
> 3dKwkTIxK
> >
> Al6_Bs7GMx4zhJArrXKN2mDMOXGh7lg&m=3DbLvAkwDrYioAER_dvXEqutiRiU
> W57bKfscMh
> > 71TGDxw&s=3Dp5jgFDs7cxtpIE9LZ3ogOahGzpuKjG4PHOcPF6qXnXI&e=3D
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
>=20
> --
> RMK's Patch system: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__www.armlinux.org.uk_developer_patches_&d=3DDwIBAg&c=3DnKjWec2b6
> R0mOyPaz7xtfQ&r=3DDDQ3dKwkTIxKAl6_Bs7GMx4zhJArrXKN2mDMOXGh7lg&
> m=3DbLvAkwDrYioAER_dvXEqutiRiUW57bKfscMh71TGDxw&s=3Dp5jgFDs7cxtpIE9
> LZ3ogOahGzpuKjG4PHOcPF6qXnXI&e=3D
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
