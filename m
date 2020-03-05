Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E368217AB15
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgCERBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:01:54 -0500
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:65412
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725990AbgCERBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:01:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRIfMOQy4RcUkpBxiFdu3Le8aPXd+r7xv/uliBNXvFD7SnG5oOK13u6OWVvUURC/haquT5oZM8pc12yeDn0wE7i8t1bKXBnylXyu04gf8vKzvdWmfFma1UZcfesWWGg422CKJtd8J8NotWtQOkeV9QhJ4UoeT2CRedkli/tRqUdmtIaGopXaUQIN4E/tVEdVwO9xnmKajlR+VNY0UWfeQHk0BPYjmZkBcbavH570s1HDTMe3OLFMqEJ6u6TJCCC6XZCmA01poTAnJtIIG/eUF26Q2Kkm3ls/nwsXjqtd8JkKYDFAGM4ZSYWCUNTZw5DaWxAxGBTnXb1xpep9zWvUIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/CkiS/rddZM78WOTmJGVvjyQwYHQk/pqBxzfsLNPtw=;
 b=VJQEhHptxFyYHJzdRdBbd+ZLqVaVJ2Nr104llOTSB3F+N8saWvK7ZhpOoA5+qxPg9Wc8dkVlxAXuDABzCw4yu4TK8hx2fiV4haMwbQ7GU/FzHtU8dkmIcsVFHoBLF5R6qahZYzheMTVzm0goQ9wKPILJpWDXZ/9Sr/FS8YaSiK/Z6ayB3qSgwaAQXqgJBE9zRtG/0p9gEQ4nnE79k6+wIReP+8nOAOWbLug/RHKtG/pSOICc6kwQqZm6ckzWzwC1kts287l1e7HES2Itj+Iv8uHVV5cYTZJ2syHZMutC4an5m1dmajPjRABT6mk4bL1f8CS6qB8kuPMuxzCco1gu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/CkiS/rddZM78WOTmJGVvjyQwYHQk/pqBxzfsLNPtw=;
 b=XN4pBBf8jnvbBXlXfC0mXQuWHsg7h2zYlZ/3UpxY7Lwh1kNC7x+t8YMnD/+Vun40f7IUcAo0101Nzud/5VtPTR+xXY+gfTqJAAwjFx8QkjicTOUC9R+B4GTpTRairpq1l1W60HTOxJK+5WgrMAUUkjD1mj63dnLuxWkbpJnvT4Q=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6347.eurprd04.prod.outlook.com (20.179.249.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Thu, 5 Mar 2020 17:01:46 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Thu, 5 Mar 2020
 17:01:46 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] fsl/fman: Use random MAC address when none is given
Thread-Topic: [PATCH v2] fsl/fman: Use random MAC address when none is given
Thread-Index: AQHV8upqMdASorYsmEyNbtgVJDAXMKg5/8gwgAAUj4CAAABUkIAADP8AgAAYARA=
Date:   Thu, 5 Mar 2020 17:01:46 +0000
Message-ID: <DB8PR04MB6985C93B234BE22BDB4E30FFECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200305123414.5010-1-s.hauer@pengutronix.de>
 <DB8PR04MB6985F8A2EB05F426F2CF8C0AECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200305144809.GW3335@pengutronix.de>
 <DB8PR04MB698558D9D5AB177E65D32B66ECE20@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200305153550.GX3335@pengutronix.de>
In-Reply-To: <20200305153550.GX3335@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 96c99a5f-fda8-4207-eeeb-08d7c126e399
x-ms-traffictypediagnostic: DB8PR04MB6347:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-microsoft-antispam-prvs: <DB8PR04MB6347DDB6924F5A7C35B69EE2ADE20@DB8PR04MB6347.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(2906002)(5660300002)(186003)(4326008)(26005)(55016002)(33656002)(71200400001)(9686003)(52536014)(7696005)(316002)(6506007)(81156014)(86362001)(66556008)(64756008)(66446008)(66946007)(81166006)(8676002)(66476007)(8936002)(76116006)(6916009)(53546011)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6347;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ThjfwiyTz6aHZMQNv3HwC6poM+WZ6OZvuvLHZUCChkCg+XUH7BriTWUdJCJ/j86Zu3CYCjbE9sqb8TeJ6qkM3EaiDDhZgHCnAOSB8SUGN29WQuwx+umk2pqrGrNwhIavNMcQjGDkKTXK7OqgMKwUBci7z0hbY2bCliWb7uI673P65zRbqCdV+3028dyCaA/HMIE6i4wi+B6nPumo/0dF8ZwU/yKoKm+9ZnRQlRPIlUn8D4xAmjloux2Et08O+jDVpO5lU3bETKbS6CnLQ29BeTtUfIv9XEpb3cHkKMWspxByrb9h66XWlLp4iF0AgbZcI/NC3afpGOu+BcghnbCwf8QFO7td4BghJWlWqba+nLvWEdezkpWu+mG7jYfFjU79YpOlXI3X3hnyaBF/BpC1cmI+CfK6dicUOduOqV5V1HLetPpRWzYE8anAM2qUbALO
x-ms-exchange-antispam-messagedata: nLCwWJzQBt7FFNENCMwfTl5y3U8SLeJWqTXN1LoZHNzQlw4XB3M4TlcfK0Rg0J07IVao8uvXVxW1pWKP4U4/y6xfww1/QOlN8LIZ2bUwMUtXb1mmU8VnNyEe8za+beKI+eIaFjIyKPRfRIhRYPlwcA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c99a5f-fda8-4207-eeeb-08d7c126e399
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 17:01:46.6454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +QHeBBobHNGODCcj3pgR7dXCPwMX/ocdp+CWbOu3TQnOjongr/WHKeNmUT5iIPtS8UGD1drbzlDOuwTPFehurg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6347
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Sascha Hauer
> Sent: Thursday, March 5, 2020 5:36 PM
> To: Madalin Bucur <madalin.bucur@nxp.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: [PATCH v2] fsl/fman: Use random MAC address when none is
> given
>=20
> On Thu, Mar 05, 2020 at 03:03:48PM +0000, Madalin Bucur wrote:
> > > -----Original Message-----
> > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > Sent: Thursday, March 5, 2020 4:48 PM
> > > To: Madalin Bucur <madalin.bucur@nxp.com>
> > > Cc: netdev@vger.kernel.org
> > > Subject: Re: [PATCH v2] fsl/fman: Use random MAC address when none is
> > > given
> > >
> > > On Thu, Mar 05, 2020 at 01:38:01PM +0000, Madalin Bucur wrote:
> > > > > -----Original Message-----
> > > > > From: Sascha Hauer <s.hauer@pengutronix.de>
> > > > > Sent: Thursday, March 5, 2020 2:34 PM
> > > > > To: netdev@vger.kernel.org
> > > > > Cc: Madalin Bucur <madalin.bucur@nxp.com>; Sascha Hauer
> > > > > <s.hauer@pengutronix.de>
> > > > > Subject: [PATCH v2] fsl/fman: Use random MAC address when none is
> > > given
> > > > >
> > > > > There's no need to fail probing when no MAC address is given in
> the
> > > > > device tree, just use a random MAC address.
> > > > >
> > > > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > > > ---
> > > > >
> > > > > Changes since v1:
> > > > > - Remove printing of permanent MAC address
> > > > >
> > > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 11 +++++++++-
> -
> > > > >  drivers/net/ethernet/freescale/fman/fman_memac.c |  4 ----
> > > > >  drivers/net/ethernet/freescale/fman/mac.c        | 10 ++--------
> > > > >  3 files changed, 11 insertions(+), 14 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > > index fd93d542f497..fc117eab788d 100644
> > > > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > > @@ -233,8 +233,15 @@ static int dpaa_netdev_init(struct
> net_device
> > > > > *net_dev,
> > > > >  	net_dev->features |=3D net_dev->hw_features;
> > > > >  	net_dev->vlan_features =3D net_dev->features;
> > > > >
> > > > > -	memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
> > > > > -	memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> > > > > +	if (is_valid_ether_addr(mac_addr)) {
> > > > > +		dev_info(dev, "FMan MAC address: %pM\n", mac_addr);
> > > > > +		memcpy(net_dev->perm_addr, mac_addr, net_dev-
> >addr_len);
> > > > > +		memcpy(net_dev->dev_addr, mac_addr, net_dev->addr_len);
> > > > > +	} else {
> > > > > +		eth_hw_addr_random(net_dev);
> > > > > +		dev_info(dev, "Using random MAC address: %pM\n",
> > > > > +			 net_dev->dev_addr);
> > > > > +	}
> > > >
> > > > To make the HW MAC aware of the new random address you set in the
> > > dpaa_eth,
> > > > you also need to call mac_dev->change_addr() after
> > > eth_hw_addr_random(), like
> > > > it's done in dpaa_set_mac_address():
> > > >
> > > >         err =3D mac_dev->change_addr(mac_dev->fman_mac,
> > > >                                    (enet_addr_t *)net_dev-
> >dev_addr);
> > > >
> > > > This will write the new MAC address in the MAC HW registers.
> > >
> > > Ok, I see.
> > >
> > > So when I call mac_dev->change_addr() here in dpaa_netdev_init() it
> > > means I can remove all the code setting the MAC address in hardware
> > > before this point, right?
> >
> > It's not an issue if you just write it here for the random address and
> leave
> > the previous functionality in place.
>=20
> No, it's not. It's only that the code becomes rather useless once we
> overwrite the MAC address here anyway.
>=20
> > Do you have a board to validate your changes?
>=20
> I have a LS1046a based board, yes.
>=20
> Sascha

I'll send a v3 addressing all MAC types.
