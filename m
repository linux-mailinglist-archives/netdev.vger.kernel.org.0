Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09CB1B78E5
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgDXPJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:09:01 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:15013
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726717AbgDXPJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 11:09:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAEZJ9hbXUZTyXYuFIA4YI+1txjrL11RKaZhf75SR2zxrm6MNMpa4sC+XxRFwI814pUHp4tUTvTac3QYJPrhjeFnZTRvtf/kVE3cBxEZMXPEtQMSo7IUuwGA98jbuqhrJffbS7fDmHNovQs9Za+zBFCLzpc0DxPuEBBjFN4FFI/JeisPKB6ujMuDShjAfwM8ShDs5jY5vdVD8mpNCgaav3tZJUfQutD79UjVOzEe9Dqxf4u9oEzYEtFJ0lizygkf7mPkUBjF/Y20J+eE8oy7IQMv1o7H3VEdwEKPK7n/gmn8+d3jDbcvS49gkd/Oqkh+1UgwV8SEJjvbGKpBIpCP/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcmdYoItqsgDsZXuX1MUqCoZ753HnGfMuiNlb9Ku0hI=;
 b=DPRC5MeaehbkNvHE4PZWaHwiibChrL3H5DZlIK1CS4Chgg+XJ8VU0F9HpmC9rpMjYm8gZifZnb/iTQhvUgOuKJDBBFMP2gY3NVowLQ0k2r8D5yYJA6cPQxRiePFdE9SPKg/wphh90uKSGqgOFAG8sdZHckESupK3uDSZrKsx4rvsFKdPAM6cWzwb9JBst1ITvwkmSYbeirnOFDCUQAR+ksLn290hVtSUU13vB3KeLC+dH60NsMwguiqK/A2dBLhzI0P+GQ4VBm1aD2iEaZWlsNCFDeSFQ6NFMZ+D3fVK4RGPphx3BWv0ilNcfvosst/Vbojx0lN02bW0FazRblQwoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcmdYoItqsgDsZXuX1MUqCoZ753HnGfMuiNlb9Ku0hI=;
 b=Z0u3R1T4RPqPC7BuAhA4C/nj6URv/NnEaCG4uzUBMOQrful0zfLva8lpqU/pDJKOJu19qO1p4FKcvFQV/W5D+nKn8VZlqSippyrmGdWLeo3J7whBNK5iA6yksITn4jZoV3YYJF8vixKSL0FXm+qlssFqg1Um+Vmqk5thgX+XT3s=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5619.eurprd04.prod.outlook.com (2603:10a6:208:12d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 15:08:56 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 15:08:55 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr
 driver support
Thread-Topic: [EXT] Re: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr
 driver support
Thread-Index: AdYaRAr6OuhHlsgtRe2hojICsYdYXAABIF2AAAATOTA=
Date:   Fri, 24 Apr 2020 15:08:55 +0000
Message-ID: <AM0PR04MB54435DFD9870FA66C01E07CEFBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <AM0PR04MB5443BCFEC71B6903BE6EFE02FBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <20200424145635.GB1088354@lunn.ch>
In-Reply-To: <20200424145635.GB1088354@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
x-originating-ip: [89.136.167.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 03aa4ed1-59e5-41c2-311a-08d7e8616882
x-ms-traffictypediagnostic: AM0PR04MB5619:|AM0PR04MB5619:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5619F7B241A6727436740278FBD00@AM0PR04MB5619.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03838E948C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(71200400001)(76116006)(6916009)(54906003)(316002)(4326008)(7416002)(33656002)(66446008)(55016002)(26005)(52536014)(5660300002)(66556008)(86362001)(8676002)(2906002)(66476007)(9686003)(64756008)(6506007)(7696005)(81156014)(186003)(478600001)(66946007)(44832011)(8936002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4qiio20lWhiMq9Ae/5+0//RyBj7RJCBZMKL/pChvMJsYmdkMWGNvgp5C9/IkDlc/+w8tpgWVLV5KAssuvVoIvmgqB9ZJTvP4pvnO0nQGxNvlHPqlrNhN4A9xsxvezhJm6lhKmJZuBB8H5WdNAaP1jfkfGOIu/hSIJvhkH6yW1tLpJ/UJfgwb6aIcFw+vk2MbdDk/a5YIbhMIPj0VIxXvY/EIRHdwNHJJt8EDND1BNo5fYdc1aHn1/+h8BPw2+2sK5iUb6zwCJ8Ovab/Nddh6zcAvlaADwGxAcTKEnY/VNuOiCcjCuVi9ZllX9EMvszmoMPdDLUNs1CcyKdb04x1glG27IWLlq7jQFMaTY7dZLuXwtkoBBiKSrEo0TjzagZ0miXpX9voy1R5+H7E82DVRSw0vKO/9LaPWJOKuUKxQQA5E0bfY+x+rzLigz4KGI2CB
x-ms-exchange-antispam-messagedata: nIqYFuRA+/9eyKGFJSsEfb//Ev+ydmwR04/G91BgES3UNyqDMlleFQKizpIHsaHnp9NlxR23GihTK3JZDzy/1ig2WqSMWt2OH/cDbmgAg8YgjdXVZ1rPnEdXP1UcJPflAn0xyA8ZS3jxNFO1ZW4K5w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03aa4ed1-59e5-41c2-311a-08d7e8616882
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2020 15:08:55.7479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OOr4ckC2fh9cu/GZe408/dMh8ZezdzFuqu91XUh14rG/arlX61WzCpqA6rvDQJzpcTCStGV1carC9uoZ6DOOWPwv5+FZDET8ZdfG83jzzsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5619
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 > Caution: EXT Email
>=20
> On Fri, Apr 24, 2020 at 02:39:54PM +0000, Florinel Iordache wrote:
> > > > +/* Backplane custom logging */
> > > > +#define bpdev_fn(fn)                                              =
   \
> > > > +void bpdev_##fn(struct phy_device *phydev, char *fmt, ...)        =
   \
> > > > +{                                                                 =
   \
> > > > +     struct va_format vaf =3D {                                   =
     \
> > > > +             .fmt =3D fmt,                                        =
     \
> > > > +     };                                                           =
   \
> > > > +     va_list args;                                                =
   \
> > > > +     va_start(args, fmt);                                         =
   \
> > > > +     vaf.va =3D &args;                                            =
     \
> > > > +     if (!phydev->attached_dev)                                   =
   \
> > > > +             dev_##fn(&phydev->mdio.dev, "%pV", &vaf);            =
   \
> > > > +     else                                                         =
   \
> > > > +             dev_##fn(&phydev->mdio.dev, "%s: %pV",               =
   \
> > > > +                     netdev_name(phydev->attached_dev), &vaf);    =
   \
> > > > +     va_end(args);                                                =
   \
> > > > +}
> > > > +
> > > > +bpdev_fn(err)
> > > > +EXPORT_SYMBOL(bpdev_err);
> > > > +
> > > > +bpdev_fn(warn)
> > > > +EXPORT_SYMBOL(bpdev_warn);
> > > > +
> > > > +bpdev_fn(info)
> > > > +EXPORT_SYMBOL(bpdev_info);
> > > > +
> > > > +bpdev_fn(dbg)
> > > > +EXPORT_SYMBOL(bpdev_dbg);
> > >
> > > Didn't i say something about just using phydev_{err|warn|info|dbg}?
> > >
> > >        Andrew
> >
> > Hi Andrew,
> >
> > I used this custom logging in order to be able to add any kind of usefu=
l
> information we might need to all prints (err/warn/info/dbg).
> > For example all these bpdev_ functions are equivalent with phydev_ but =
only in
> the case when there is no attached device: phydev->attached_dev =3D=3D NU=
LL.
> > Otherwise, if there is a device attached, then we also want to add its =
name to
> all these prints in order to know to which device the information refers =
to.
> > For example in this case the print looks like this:
> > [   50.853515] backplane_qoriq 8c13000:00: eth1: 10gbase-kr link traine=
d, Tx
> equalization: C(-1)=3D0x0, C(0)=3D0x29, C(+1)=3D0x5
> > This is very useful because we can see very easy to which interface
> > the information printed is related to: in this case the link was traine=
d for
> interface: eth1 This information (the name of attached device: eth1) is n=
ot
> printed by phydev_ functions.
> > I'm sorry I have not explained all this earlier, the first time when yo=
u asked
> about it.
>=20
> So why not argue that the phydev_* functions should be extended to includ=
e this
> information? Is this extra information only valuable for link training, o=
r for
> anything a PHY does? If the core does not do something, fix the core, rat=
her
> than work around it in your driver.
>=20
>      Andrew

I think this is a very good idea: I think this extension would be useful fo=
r all PHYs not only for link training.=20
Its purpose is only more user friendly prints and I needed this feature for=
 backplane debugging.
But since I am not responsible for the PHY core, I made this workaround onl=
y in backplane driver.
If this small improvement could be done for all PHYs then I think this woul=
d be an added value from user friendliness perspective.=20
Thank you.
Florin.
