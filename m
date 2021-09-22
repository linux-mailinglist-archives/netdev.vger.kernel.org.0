Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89364152DE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbhIVVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:32:51 -0400
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:27635
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238086AbhIVVcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 17:32:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJzLVp1fM8dgvxCJGNjjAm66CT5OAC/a4ZQhhwRWvd25VPSEJxMCbrirm5GGOKja6oeaHfHHeRXZjzSLatPkDQ2aIpZFHX95aF1qMljGyav+BfxcKGy6IWVPzu6XKsF1zJUX38FR6tcE7+018M4l1OMJ+jOXs2QMisC/KkM1Yfi8+Ewnc3fv/9xg4VhnzQ2vpI8np6L5D/TSkJQjAqOUWXqmVEvASq5LsvnFDizxkGw9R6Zs6vVaMeEe6CmyXXkleFtIdDaj2xM9aiv9QibDPkJRTM+ob+jQ4uDJmBhNTGgmqnJuzgWjUHnNpp5L7iLVRK5XBVMoHDj9AR0cg1+zJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=DgeFJzt/e0+iU8w1Wj/uGpjQeDzfrP/JlDS/qEiHe5k=;
 b=PgMJj8Wl5NJuxOdbCCDWfR0bc6AcGO5p3upIxbfaxmbuli6PuXVxSFqNqfUmnRqjW0TESfXWBziOMfw9OCYrKnj8cdYSIXxtRUs1XFmNmknl29UC/tDGBgQ9FVH4/KvHZ3Cc3YAD04Fa3/hmmsyuzW/3IJ8mMIsyLUi7XuNZTNsEeogA1N65XuYN/iuNipT07YqzRZylVyEjo7jr9nH6pUpLrkSdHIPVq+G/MvJPoEFmfU0DXToC/Du/G/bFsKlMnA92sdZ5Up+UW9u20FjiadRfNawFnq4vHgS2x/wtigVnhTEUlmmNrfHHDwpsgI99E/PuZG7fBacpnWKhZ1Wbyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgeFJzt/e0+iU8w1Wj/uGpjQeDzfrP/JlDS/qEiHe5k=;
 b=e6ojudtKOt8/e9xShFOzlxqzb513oh7KaaCzFFtGqJAz0tbSr8BbkW4pa0pst1+ge3w+B49OmVLRqNgGMC5JlxhFz1481YVstBQVZwMzHxx1jCjF8fHNMfi3zaXAE+m9iEK5fJYomyg2oTkVrGnC2w4eqV6ADIfYznLA9BNgHs8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 22 Sep
 2021 21:31:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 21:31:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Thread-Topic: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Thread-Index: AQHXr93LG5LHnXhXOUKrZr2QV4Zp96uwkB2AgAACgAA=
Date:   Wed, 22 Sep 2021 21:31:17 +0000
Message-ID: <20210922213116.7wlvnjfeqjltiecs@skbuf>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
 <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
In-Reply-To: <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 475ab158-69fc-46bf-9fbc-08d97e10502c
x-ms-traffictypediagnostic: VI1PR04MB7104:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB71045AE10697D4DCB5503F6EE0A29@VI1PR04MB7104.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hx1rhWgG2ll8DIANA55LhkKUSr2W72LcDLoHKLnZJxw5CNmtJxMs5O2S6L0sxCsPljqmHKDZcWQVJz//KIBQ6/1Kwt4Em923gdhIu0i5P8finqcy9UgGjg3kNBkRnOOeuUcKpmPU4utvqeJqYATCP3t7J2C3uLBzivEuC21zMBqvRCkxWuOunhGocisflu/KkJyCv2hGwVjYvd1xBFbIoSRL65q4ZU9OlDsQ3w76qbeh4wsGdWfMYT0SLvX0rwiZZsXmSascSl45V1JgAwkQVANikii0tOpATa36P2Cv/TD3dycSe1VpLAX1KuGEuwKNxYi3QUzV0RldVfjPIqiRNP32cNHVpPghFdzpJA2eqd/0jw0ZR3JgbXISPIR+IjZYW/O3sEMLXxFypiQA/FSDuNvJCRZAckFzMQr1+OIMvLjRPRoaiNvtri+u2BQ/8dRp8/s5+M7z6hc8ArhbJUWzpTvn9xOTEY7MPj3Zj2wNAI+LBUMnLl+GwA9D/FQE6Cy2NcAqA9Bi6LNfrIS0YsUG6wocEczojZEgrNbk3eexDUk6nQ6H0o9hpd7jwWS1Y04UcZeytklFXT7uf2Z9TXKDKoVbFll58/XE6KztWQzSOlBtqc2YpfojHbD7rI04pLjzbP4EjraHqs1JIBmBljlNvnpfbiiyBCNVy0jwzQrX+CozNeuWG6P/eiqqH27e1gY6H2LP/nmPy5WnpHO26ifecStSpf9nzTSe5wTPJIZE8sI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(66946007)(91956017)(76116006)(54906003)(38070700005)(83380400001)(6916009)(66476007)(4326008)(66556008)(6486002)(66446008)(26005)(64756008)(7416002)(71200400001)(122000001)(6512007)(8936002)(9686003)(2906002)(6506007)(508600001)(38100700002)(5660300002)(1076003)(44832011)(186003)(316002)(8676002)(33716001)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jwae9iMGr3str0h4kjaBZPZMDp33PrmWF02GekZMZwqRaDarsK0EMbRIDrqh?=
 =?us-ascii?Q?C9/DEJg7lGqc6wolLoBmG+kyfox2w0NOdJ5elqLGocGIAAjhMj15wWHAVeb0?=
 =?us-ascii?Q?ZZvj+P3IZqZdmMGWZxEZYInXDna9WJCUgkoXoOTVMKqZV0UIFz7LsRe4cvpn?=
 =?us-ascii?Q?L/xQjiRsuorJXJuS2aSwS+wZrPph70vm0aEehVJifW4i7sb9J9LzBSRjAM9T?=
 =?us-ascii?Q?Tv9VaVzGpV9AzGP63XkO9XABL//WHAMWmboIMHXPwjbENcSJHAx94oIAWOv0?=
 =?us-ascii?Q?nxzmP2MIWGfteZxmHHAUsKtTuG/o6RAjOPDBqFZipcW66qiwfHWMcBcXeXaV?=
 =?us-ascii?Q?B7hdMP6hWEGc4Kh0pXzHKKE50llLbFRvx1Y0/HjVZLgy3ZjoW3mIaLtotJqT?=
 =?us-ascii?Q?4xqeqTtRyii3+RuNJZo6GD2Mr1MoCKiVWZanmvdCBV/4Z4UofVuKj5UmOyEl?=
 =?us-ascii?Q?cs5vlGXRcSwkxZnla2eWkdVKBsnpusIU4JPaoeYQCZis7E7X4bQtV6XXeSWL?=
 =?us-ascii?Q?dwejMr2tFpRocdxPLvdlKTGmRg9DXE3FwRCoUjBR18LwteaAh9QVDj9KRw0m?=
 =?us-ascii?Q?XF97jbVBczmPjYHvSK/LaguHDZOJuXhQflV1jQhjrWWNM9Lb473oZAGbwp3e?=
 =?us-ascii?Q?+/XM2O6JBIiNR6LN1hBFxdwO9LOFTsPr0VUklwIFDKqih3vnlEf5Eo5pTOy5?=
 =?us-ascii?Q?pHEoAuFcV5LUVmA2R4IcR2zBhf7kvXaZ3Zjtx+Rkv5/qJ0lsCkBs4j8eSTZt?=
 =?us-ascii?Q?v5qol5s3hZ46+EoAOBK2xaQ+GO1TTowX6SszVL5dKB1onqrCyur74flHW+1o?=
 =?us-ascii?Q?pDRLKzwol5mf6Y15B7dILb1sW6ZUkk8XHDuJ/2KgGmiArR4GQ2VcJjz3j1Ht?=
 =?us-ascii?Q?LmP9/a2JSBo4Po6nnBLXDAAO2sNoW1o0bMeINy4/FvF9Y9C4Uvq9gUlrSNQZ?=
 =?us-ascii?Q?p+bjIz3XYMjCf/CpqWRg6JDYuIa0dyboTyWFewJsuTOTRHIi/TPyP0ZrMfiz?=
 =?us-ascii?Q?wU08JFnwtho/pDeAwEbc27u+aKqd7AftiuoWYn2G9LJf1zvJRcqJCL5X6Tv6?=
 =?us-ascii?Q?pLhUhv+CQc65JahqXl+1iM4MQkvkFi7vzQiZ0uHgwBXZOmKvgi0adSf5/tQA?=
 =?us-ascii?Q?TcwLL91t8/nMenbosfdfjnuxH2/SM9eOZzltvvvM0p7ne/dpJSJzURBjGCq5?=
 =?us-ascii?Q?8TzRT6wv9aO/R1l9UjrbDGC+sIsZRBYaiJDMCE2zxO1rSwjRsfVuDAWx8Jar?=
 =?us-ascii?Q?LiI/7N2NArXH6JGCk0qzVAVqnmbc5GbUemlKjfqJWtY4g/UN/W9PUBMPErfW?=
 =?us-ascii?Q?pvXEEv5tUVP222KHmOjHmBX/wFpm8CzEpnb84P310T7rqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB3E1EC959C5DC4E96FB2AACAC8374AE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475ab158-69fc-46bf-9fbc-08d97e10502c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 21:31:17.7794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtAXrMpzuWagbU4SrzPh8/W3onhuJkvtiO47TPyLK2FbqMMhYVcat/h7MJVXIYjs9OGGyE/UZnh5FTvMI7BwzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 10:22:19PM +0100, Russell King (Oracle) wrote:
> On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote:
> > +static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
> > +					      struct phy_device *phy,
> > +					      unsigned int mode)
> > +{
> > +	int ret;
> > +
> > +	ret =3D phy_validate_inband_aneg(phy, pl->link_interface);
> > +	if (ret =3D=3D PHY_INBAND_ANEG_UNKNOWN) {
> > +		phylink_dbg(pl,
> > +			    "PHY driver does not report in-band autoneg capability, assumin=
g %s\n",
> > +			    phylink_autoneg_inband(mode) ? "true" : "false");
> > +
> > +		return mode;
> > +	}
> > +
> > +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
> > +		phylink_err(pl,
> > +			    "Requested in-band autoneg but driver does not support this, di=
sabling it.\n");
>=20
> If we add support to the BCM84881 driver to work with
> phy_validate_inband_aneg(), then this will always return
> PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
> this will always produce this "error". It is not an error in the
> SFP case, but it is if firmware is misconfigured.
>=20
> So, this needs better handling - we should not be issuing an error-
> level kernel message for something that is "normal".

Is this better?

		phylink_printk(phy_on_sfp(phy) ? KERN_DEBUG : KERN_ERR, pl,
			       "Requested in-band autoneg but driver does not support this, disa=
bling it.\n");=
