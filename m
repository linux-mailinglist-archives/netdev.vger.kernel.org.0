Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1044423
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbfFMQfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:35:04 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:7350
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730740AbfFMHqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 03:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXNSbaK7JGte3IFO3cRP0pGO3Drm7EDpvjPz4/s5wiU=;
 b=Be0/8fmQsin4gjIIRhgYDLYzOMbn53rdUsyTCSaVXvsgtPHgoKSpwpx/xkQaRswj2hTM+DPg5D5wY0658OBZV40L5e2SIv6K1waFThnCIe7nzkXDHJI7ie70axGOoueNszokpR2kTqBDFhKcyuZSwhG1HKs0De3tdYSNEe87ius=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2782.eurprd04.prod.outlook.com (10.175.24.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 07:45:59 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 07:45:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Thread-Topic: [PATCH] net: phylink: set the autoneg state in
 phylink_phy_change
Thread-Index: AQHVIbKP9yXQ7A3ipUiyPT36szP9naaZMu3w
Date:   Thu, 13 Jun 2019 07:45:59 +0000
Message-ID: <VI1PR0402MB280044028DE01C06D4A1FEECE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
In-Reply-To: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0f94dcc-9a60-40cc-4840-08d6efd32d0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2782;
x-ms-traffictypediagnostic: VI1PR0402MB2782:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB2782B51B9F0124129A75F647E0EF0@VI1PR0402MB2782.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(396003)(376002)(346002)(136003)(199004)(189003)(73956011)(229853002)(6116002)(74316002)(8676002)(66946007)(81156014)(66556008)(66476007)(2501003)(66446008)(76116006)(7736002)(3846002)(305945005)(64756008)(25786009)(81166006)(8936002)(5660300002)(33656002)(966005)(6436002)(52536014)(478600001)(53936002)(6246003)(6306002)(55016002)(9686003)(68736007)(4326008)(2906002)(14454004)(316002)(110136005)(102836004)(446003)(26005)(7696005)(76176011)(6506007)(14444005)(186003)(256004)(11346002)(486006)(99286004)(476003)(44832011)(86362001)(2201001)(71190400001)(66066001)(71200400001)(6606295002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2782;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dCMnCUqP9b1p/ZDmE+f+3XCEe5vQHRtA8YcEiw6z1y/VJr2Li0BKTVezyNvpBTlSLJ6osQvVM4wd3HPWgO7H3PSWqamh6tyxbnTqLmg0EvNVYHD6pnlJOiRM1rU4KLYJug7dvxbzM2vsZNIGPPoEh8KT2xcd/rUVZmJBjM+NeyEQukjkNesXj7jRUl0TS2xZeIeiiug3CjQ3ygJA9t3owH5nt2bjwXV9jPzW+QgsKcPiHbGOaQ1psuHYjVogRIp+PeQUJ3xHqOZNCP8EE0ytjHDGg1ISEeNQMnUEDzXBQfOqq5fgef/JiPcTGsz8ZuTDvUK+7Y4w9CmkfkMwv8tlUNv1v9RRWEjH6xQLkZM4kHRZJI9UtP4zU0u2cB9VjxSn04tcvO2FLIOF9bgpQv7OCyuRW2PACoqm02DABIsNL3I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f94dcc-9a60-40cc-4840-08d6efd32d0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 07:45:59.1219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2782
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] net: phylink: set the autoneg state in phylink_phy_chang=
e
>=20
> The phy_state field of phylink should carry only valid information especi=
ally
> when this can be passed to the .mac_config callback.
> Update the an_enabled field with the autoneg state in the phylink_phy_cha=
nge
> function.
>=20
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/phy/phylink.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c index
> 5d0af041b8f9..dd1feb7b5472 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -688,6 +688,7 @@ static void phylink_phy_change(struct phy_device
> *phydev, bool up,
>  		pl->phy_state.pause |=3D MLO_PAUSE_ASYM;
>  	pl->phy_state.interface =3D phydev->interface;
>  	pl->phy_state.link =3D up;
> +	pl->phy_state.an_enabled =3D phydev->autoneg;
>  	mutex_unlock(&pl->state_mutex);
>=20
>  	phylink_run_resolve(pl);
> --
> 1.9.1

Unfortunately, I am not able to find this patch on any netdev list archive.

One other interesting thing that I noticed is that both netdev and the linu=
x-kernel list received the last message around '12 Jun 2019 21:15'. [1][2]
I am just trying to see if there is a problem on my side or something else.

--
Ioana

[1] https://marc.info/?l=3Dlinux-netdev&m=3D156037411432212&w=3D2
[2] https://marc.info/?l=3Dlinux-kernel&m=3D156037415432226&w=3D2

