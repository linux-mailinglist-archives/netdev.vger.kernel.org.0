Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D330D3161D2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhBJJKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:10:46 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50142 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230450AbhBJJGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:06:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A902jd025696;
        Wed, 10 Feb 2021 01:05:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=x8eYnYYgsyVN1Xq2iHF/pbUVdbjIhH+Lj5UmBcebz+o=;
 b=KM1IOGNTtRP1TS5psbw3QmhLiLQTUn4X/FeXyIb34UX9bwjTrsuBYDvi1G6fzFLBi4gr
 zITbanJd5xG3mrbvnY30NopKkobl4A/LRqqolEFV6eTKiws6dI8Oc3Rfkb4JalvaJyZX
 YWRKpgLNcI7M+Gpty6CIT7jMDYE6nzewwUYJOqE3XZk+93TdO7e2EGdvQwVDDGNKD5u5
 6L2/U00421wAz8abRku8qJRDvJM8jkniB6xSDHVywJ13XYGJU34pOjInPnW6rXEo/RHr
 SmEYqWw860US2Z0yNe7od4fN509c+2Z7BHIJHTAw0vV8lXCqJWmVqQM5KrzGx3+cAaQr Gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrkdrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 01:05:27 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:05:26 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.50) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 10 Feb 2021 01:05:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDTSV6b9je8b46S0jG/bbBqF74QRNJSK17zPLXwD4Z31R7QTBbXG6qJYxTaWlqYK5fLo1nJWq3gu04tfqd4MLuvoLdaEBaKIOlT6BQnT7f3Tac8IRax4IhEOWYWVsaWkYu5BecKQsspwMPiGX2aSHx7lL661AQWKmVkLFyKgU9vA0MT3LotEfo6GSOgEsvJFUIa1l1wOVVLqf6ABrAOUlgxvxtdIj/f3s1KvS8fRe9nf9AtAC88lHNwJbJuErL0uUmaV4FDmZbzwoHx7qsLGmJuYGsvADzj0c2ixtgIjJsC98V3edErJ/C5GMLTVhNsuR0cu15MoncVh5uq0yvlc3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8eYnYYgsyVN1Xq2iHF/pbUVdbjIhH+Lj5UmBcebz+o=;
 b=gST0XItHm1pAQ/3PBAASphIGVi5lzfk+X3CbTydDMxDZxMrUMF/WbSsx4Pf6ZMyociZBAQ5N1NXjvzC8+N2QZWzMto8LIP3f2iGCpidRP+LRaMopUPc0cTT8rkLeVypOUsCRZFl1rJJSUJQfznvq7rwE3ktse7/dQSEw5SlUSGxHeXJQvjTPKUtYyjouwXI1J//6Ca/DN3EaLvvEAk3QlgzVJnXCXJMqm3BarukBDPrxbIEbfqX4WmQ4T2m3rPTQTaXAX69Ea67OS8qSVQALtkEj07xvS5P3jrXbN/0cLoL9kDRUPbhL9KCyeumhiLN/XKzrCDKdicGTEgI/Wgn7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8eYnYYgsyVN1Xq2iHF/pbUVdbjIhH+Lj5UmBcebz+o=;
 b=P7BVuJbBlJAMeLMtBMQ0MJcxHGzpofFQK1dEvtmfZlq5a46/Sz1/u9bot+K3cqTVYKcedlLzjpZ4djVVKfIyJOKaVEpkJDWctyQGx8oz7IWR4wYQuaUTMgZtmQlIPIhd4Elvov/S38gLxcOUOa7RM+CRzcOt+ZFOYwVKxTPHYOY=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1216.namprd18.prod.outlook.com (2603:10b6:320:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Wed, 10 Feb
 2021 09:05:24 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Wed, 10 Feb 2021
 09:05:24 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v11 net-next 15/15] net: mvpp2: add TX FC
 firmware check
Thread-Topic: [EXT] Re: [PATCH v11 net-next 15/15] net: mvpp2: add TX FC
 firmware check
Thread-Index: AQHW/sBBFbgpQQcn1kKFZbDyaw2oG6pQA9IAgAEWNfA=
Date:   Wed, 10 Feb 2021 09:05:24 +0000
Message-ID: <CO6PR18MB3873EB4FE57E1D35531AB5AFB08D9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
 <1612860151-12275-16-git-send-email-stefanc@marvell.com>
 <20210209162855.GQ1463@shell.armlinux.org.uk>
In-Reply-To: <20210209162855.GQ1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.78.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8872fd71-fc06-4c5f-b813-08d8cda3006e
x-ms-traffictypediagnostic: MWHPR18MB1216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB121691C9B6FD4612C2D5C229B08D9@MWHPR18MB1216.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2zAiDVOFctFqurRQuh8d8hI9R/hFVN9htjlCWL4YH73dIqOPdexCOt7sFmUgfEhR4MeH+E0DcXFks/SCrBXc1UWIYoRMpnZHpS4vnRuv5DZ5ECQtj8259YJ9RAxP+cLVTOELK3md6lavCKmI1qwd+39jE2UWY/9r9XjC1RxmG6qwUAotWYx76I1AxUYljvtCrYSju+qnbei+zdSXTekck0O2R7PYyJQH27rnQjgfdCZ4igXAdqpKkiVy0pZiaZay8HYC4xPDw8CAuesrFeGx0Xz8wnPNrxMaL2yBJlLOg1nty04zi1KsZTylgThEPKIrAkwhSwKbqjZGVngdOJXdhJ7lAg84XJMI4hE4p3kZIqfKW+R8XV30zaTtEJkiEzD5WtH+If75tWymWzRt2TeVbBzasMXWxtFvWo77rvHbPqm8nM9ZEbzBy4J5fIXgU4Oo/++9BMMSCqSdZWx6Zz3lH07Ipu13vdkaFjW0OFAnRDw1n/vsZaZKsJNURHsmB2axisqqs67mdTRwXk6MMbRYsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(136003)(346002)(86362001)(76116006)(478600001)(66476007)(66556008)(64756008)(66946007)(66446008)(83380400001)(55016002)(7416002)(6506007)(8936002)(186003)(8676002)(26005)(71200400001)(9686003)(316002)(4744005)(2906002)(5660300002)(6916009)(52536014)(4326008)(7696005)(33656002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3vBeowF7XLmDxLCuh5b8UPtkETEdM6zCsdpbZpFtFJr3BGtsiUfRSJe2Wee9?=
 =?us-ascii?Q?SZ6UD1njwNAG1qq6ts1JXPMx6rzYf9BIpVEguN76qaMI6x9RIpM1OJuMH2sS?=
 =?us-ascii?Q?2jOi2mOcecbB8Z42Yv8TiMRtrgDDX/cWSNhk2p9XzAjghR/ubaR7VZhgbEsw?=
 =?us-ascii?Q?g3yWa4KItI1wWyagZQrNX0KLSWnIeZ1eRFU2mVpQz2nBjJopDuE34Hx2qY2L?=
 =?us-ascii?Q?2OUk5uyFzquD86RSzy/131rca+kK5S1qsob1/4HmDqQChCiiV6P2KCpD2POp?=
 =?us-ascii?Q?nXwyg38SgUR2WxA8T4GiJ+VAFFvoZNooy6p14opWg4cqjkJF6gEjwI5VarTy?=
 =?us-ascii?Q?0ScZ2MEe6UyTFAccU7uK1GA0M8VFzOo5evC0HPoHAvTo6LIIe/NNqF4qb3nj?=
 =?us-ascii?Q?Jzv7HyVqjHRYu++wtk4NNNCDtATthJe+NuFaVtRrWNs4UCMhxDTvmaBqpbEi?=
 =?us-ascii?Q?8fFK8i4Dhs0m5TjEQzdvePTgsfLJCiYWgZG94z6O/ZizBWDziBUjUo16dLvU?=
 =?us-ascii?Q?bXueCbQ3VHLp+d5NbSQBc5l8lgP4Eh1Kr1UEYWgAo6ccprsigSRI47A5GZvi?=
 =?us-ascii?Q?4ijmgHCurVE4F7KL/cmOtEqIP8s/PycUUwkCIKMLXhQCgG8X8qQ0ovrX/dms?=
 =?us-ascii?Q?e3cTbnK8UjK4dkxbgY+ZaeihEKAS4d3q/+JgmgFI9XOQeqAiKrX4wxxY2C7c?=
 =?us-ascii?Q?eORUORQOfT0vqFJcNh4lQosuOYVtKchkYTIb4XCfyodqRWF5JlWFXyGrALkJ?=
 =?us-ascii?Q?7xM/46luk4bEbkc2Q5WxunX2A2/fxQpINoElihOpkEu4IW8oAPnt3bGt4imq?=
 =?us-ascii?Q?4MxmRndelWNUBmFj6ca2JfuQSswovoPCSX465YhsMeBy7tEW/U/sWp9temAu?=
 =?us-ascii?Q?zngHQLbVPIAg6tOWjt6gYNOUAaP26J6+rGQoyqrPQFdHK/vfwl+1XuVHoR5c?=
 =?us-ascii?Q?JtBwavVejfRMK+mjBd3Job4zNsXoldg+eL4mGlPLVEases/h1l7gUkB/+irQ?=
 =?us-ascii?Q?BDKwcjXAZGC5K3aSR2N9O04r+5tc1Uo1Zdf7Q34UVKHOMo2U2vkFkYjQNlfp?=
 =?us-ascii?Q?9fGl2wrjU66OgqoFirNuQCc1PIL4fIZfKJnp1rsCrWetKcnZ4Jt5Ym7/z585?=
 =?us-ascii?Q?OiK9gF7UTSRi1Kwwy/vg25P8uBiDaHAn/Q4Ru5u3lWSuV1Pe+AO11XImdf0f?=
 =?us-ascii?Q?5x7+KBdQ+bwKAzC9AryTwze+W2kE+qadX58CQkDod+l3gHQhXyp3PrIJcf56?=
 =?us-ascii?Q?WC3patLLxxeTmXyIfvZLpClzob/F1lGTvJ3G0KxejfG8xeW1/m7PFy/x4p33?=
 =?us-ascii?Q?xpg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8872fd71-fc06-4c5f-b813-08d8cda3006e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 09:05:24.2369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ReLtRws93AeRGMqbaglQ2oar46976EAz8Lnx+ae0AZrdtwhB/fVOlyyk33/6zBtzTvQnLxPkw/C7SdL8PTQW+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1216
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_02:2021-02-09,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  	if (priv->global_tx_fc && priv->hw_version !=3D MVPP21) {
> > -		val =3D mvpp2_cm3_read(priv, MSS_FC_COM_REG);
> > -		val |=3D FLOW_CONTROL_ENABLE_BIT;
> > -		mvpp2_cm3_write(priv, MSS_FC_COM_REG, val);
> > +		err =3D mvpp2_enable_global_fc(priv);
> > +		if (err) {
> > +			dev_warn(&pdev->dev, "CM3 firmware not running,
> version should be higher than 18.09 ");
> > +			dev_warn(&pdev->dev, "and chip revision B0\n");
> > +			dev_warn(&pdev->dev, "Flow control not
> supported\n");
>=20
> I would much rather this was:
>=20
> 			dev_warn(&pdev->dev, "Minimum of CM3 firmware
> 18.09 and chip revision B0 required for flow control\n");
>=20
> rather than trying to split it across several kernel messages.

I would repots v12 with this change soon.

Thanks,
Stefan.
