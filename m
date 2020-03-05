Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84A417A870
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 16:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCEPDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 10:03:53 -0500
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:64193
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbgCEPDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 10:03:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9AvXO0W88OVjIWloIKVuy9ohf7ZGl2j+Wk7MFfkzfsn/vLUpACBxKNTz/a7CO1E94JG6pkkZj/2eQdnZU763QTpA3eBwYM/kU3XLi+I32ODLEgPOPsEjqR1j4jRQQ/TTtfYH8SH2GBVHAt2nZ36cCvqHa+7CKZn7fN0L6DwRfCwcjyw9rjw1TymwBslwKtJTWQkjkv4XfbzutuiK54WeolHup9SWakw8mp+3THw+Mo9MPiuykvpw8TU3iptkMk3b1PGBSqiqe2sMJwsbwrfXsuXzGb4XmkxGYynPbeE/HsKMNYGWcW3Gp4bgrcYeHnm3Wy91qXrE3wD0LfeEpbjKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsIREIH9xhTaGZl/5SETZTRcQeal+SGabMkL2FXJgcI=;
 b=doDyXM7W0i5qdg66pbe72CdDufopbGE5WcTZqboEace7DNS/9tCSXdXRHDxTQgfWX89njQDX0wrizXNbiZXuL5frFPd8GWYbVpI/xn71qVMY53QV3p/Cv96bDrmtk8ObcLqvqdziuTvXcxZj4uzbQCTT1HbDKLTKVsVdItNouDvoQXxO0C/ymq0+RnyduqmzoS+AUA8R+G6FGXZnjdkB4F0ezfxrE4qlkkubrEEQ+fTy/tQtZgQD5eWltptRiJZAze0zW+H+sSc+JFicrzvsPneYNPDpm+Vn+Q3+wYH0it04vnabwHBKrzwK/gCRFRzvo0PVIUsLho8MiGlJ5vsXsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsIREIH9xhTaGZl/5SETZTRcQeal+SGabMkL2FXJgcI=;
 b=kqNRqWnpTWa/BkGwF7nT0prVqIMoUNc7OvvWygAyGcGzFvil2e98IHDuLvNg3PImQFViDhH3v1I8/ClPsf6dd5CD9i31FwRk/EixwZ05+K8Ow/Jbmzk3eiuEdrXOlz7II2NxBhmX20gya0idiuYEGEL2UL9+E9L0oU4dJT+XPYc=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5658.eurprd04.prod.outlook.com (20.179.12.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Thu, 5 Mar 2020 15:03:49 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 15:03:49 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] fsl/fman: Use random MAC address when none is given
Thread-Topic: [PATCH v2] fsl/fman: Use random MAC address when none is given
Thread-Index: AQHV8upqMdASorYsmEyNbtgVJDAXMKg5/8gwgAAUj4CAAABUkA==
Date:   Thu, 5 Mar 2020 15:03:48 +0000
Message-ID: <DB8PR04MB698558D9D5AB177E65D32B66ECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200305123414.5010-1-s.hauer@pengutronix.de>
 <DB8PR04MB6985F8A2EB05F426F2CF8C0AECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200305144809.GW3335@pengutronix.de>
In-Reply-To: <20200305144809.GW3335@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eda8b4f1-6473-42b8-fc9c-08d7c11668ec
x-ms-traffictypediagnostic: DB8PR04MB5658:
x-microsoft-antispam-prvs: <DB8PR04MB5658837A67093FAC29EF99BCECE20@DB8PR04MB5658.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(189003)(199004)(9686003)(5660300002)(55016002)(44832011)(4326008)(6916009)(66446008)(66946007)(53546011)(52536014)(186003)(7696005)(66476007)(66556008)(26005)(6506007)(64756008)(76116006)(8936002)(33656002)(45080400002)(478600001)(966005)(8676002)(81166006)(81156014)(86362001)(2906002)(316002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5658;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f+KtRWD/RcxXg2Mqoo4gleLvWA7359Urgl++NgstTKYSZfl0u9pdXWdwL8NpS5qUu3wL/mb/C1tlIuJ5OUgzb4pE1UrN0D3uEcal6RBriZyn0wlMN5F0i0ZY511c7GqoYOPmryId+NyTlW2w2rEwoCXLYHdv24t9FKndXPD7VBjSz2LNCT6tWnmZq8I7koaMrmc7c9PM6j6qcPxtDM6vPIf5XmB81v/XXJrDWhtZQCMnA66pn3NFf43n+QZ9VympabFG86VuitZQBHMNCQLhoerbqeWzj9YtKiS5ega/NjK4+edJaUrx/vfi0YHmcIRmIQUBRFzwVD+GFUwDom/GaIuE4Pg2k3Zh0EAuLOjrRDIkw6HqSL/vkvnJ8AIXaIgELlxqWe6O+5yqLeBJzVe5FT5JmngRbJ5datO9QWbi7ffvWiCaVii77F+Nnna5evFzwOs7ryUdlzoT/Pr3JKBqD/NmxpLnG2urufs/ZxcL9F/lAY7Q/w0itx8Ojeykkf3JF7XJ0Kch9pOug5CvUivXTw==
x-ms-exchange-antispam-messagedata: oH3dZWTFxDKfeKdDSL7lQv9gdJPT1ZLGE1apPK+GDRFCkpwXoOazjTmlalYHk2SU6LZ96VzAm++lZ124MyFyDhD04wzY6RWmvFRtti2g1DUR2qpM27scL1FL+m4nIyq49BsNyqNQ459kxE20RNK0IA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda8b4f1-6473-42b8-fc9c-08d7c11668ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 15:03:48.9131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8IIwXGT0elunJugjYwi6QDKs7gr9H/gYhPF5fL+8IvU9gp2b4nkrGuGvqjwikCcsIAyKjzIMQC4igyhVlvWQWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5658
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Thursday, March 5, 2020 4:48 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH v2] fsl/fman: Use random MAC address when none is
> given
>=20
> On Thu, Mar 05, 2020 at 01:38:01PM +0000, Madalin Bucur wrote:
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Thursday, March 5, 2020 2:34 PM
> > > To: netdev@vger.kernel.org
> > > Cc: Madalin Bucur <madalin.bucur@nxp.com>; Sascha Hauer
> > > <s.hauer@pengutronix.de>
> > > Subject: [PATCH v2] fsl/fman: Use random MAC address when none is
> given
> > >
> > > There's no need to fail probing when no MAC address is given in the
> > > device tree, just use a random MAC address.
> > >
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > ---
> > >
> > > Changes since v1:
> > > - Remove printing of permanent MAC address
> > >
> > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 11 +++++++++--
> > >  drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
> > >  drivers/net/ethernet/freescale/fman/mac.c        | 10 ++--------
> > >  3 files changed, 11 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > index fd93d542f497..fc117eab788d 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > @@ -233,8 +233,15 @@ static int dpaa_netdev_init(struct net_device
> > > *net_dev,
> > >  	net_dev->features |=3D net_dev->hw_features;
> > >  	net_dev->vlan_features =3D net_dev->features;
> > >
> > > -	memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> > > -	memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> > > +	if (is_valid_ether_addr(mac_addr)) {
> > > +		dev_info(dev, "FMan MAC address: %pM\n", mac_addr);
> > > +		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> > > +		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> > > +	} else {
> > > +		eth_hw_addr_random(net_dev);
> > > +		dev_info(dev, "Using random MAC address: %pM\n",
> > > +			 net_dev->dev_addr);
> > > +	}
> >
> > To make the HW MAC aware of the new random address you set in the
> dpaa_eth,
> > you also need to call mac_dev->change_addr() after
> eth_hw_addr_random(), like
> > it's done in dpaa_set_mac_address():
> >
> >         err =3D mac_dev->change_addr(mac_dev->fman_mac,
> >                                    (enet_addr_t *)net_dev->dev_addr);
> >
> > This will write the new MAC address in the MAC HW registers.
>=20
> Ok, I see.
>=20
> So when I call mac_dev->change_addr() here in dpaa_netdev_init() it
> means I can remove all the code setting the MAC address in hardware
> before this point, right?

It's not an issue if you just write it here for the random address and leav=
e
the previous functionality in place. Do you have a board to validate your
changes?

> Sascha
>=20
> --
> Pengutronix e.K.                           |
> |
> Steuerwalder Str. 21                       |
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fwww.pe=
ng
> utronix.de%2F&amp;data=3D02%7C01%7Cmadalin.bucur%40nxp.com%7C4b8758309899=
45
> 006ae908d7c11439bc%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637190164
> 922597543&amp;sdata=3D48VF83dAoB1m5B3I0jQIf0KwhO9au4gJVIieGqt1G8c%3D&amp;=
re
> served=3D0  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0
> |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555
> |
