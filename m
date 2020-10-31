Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5DE2A1467
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 10:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJaJIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 05:08:01 -0400
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:4768
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726424AbgJaJIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqHWvcwWh1aCbpKWqodvbr0CQ9aiSzJ1OYrMpTuyppOdxFncXhUJCVqkeZE86Sw8fU//zHUDzWZw1s1B0nl/W8kHCYnx7+mpVdLWcjjcIwsS5I3pwjxiQtDRrgIqGAeEyVnebyl3mcn5qPbfdwXXKipH93LTXnVKA3zPs0ei5KENSqHD5hNEsxUb0x1M1wMQ2o7JlZ7zNlO6P3E9OG5yBf4kGWxbN3e2elyhTkELCQg/GinT65sLPaWfvN8wGPntSz/7//6Ohs5/Km3jw36a4E6Uqz/4VTCTJnbGcxDJBKvPRy88DKbNkPpTEz5LXa6xeStxStAgcDdm0IA4URb84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SeoTq5I7xb24Xh3mH6VzaPebxy3W5Ti/2lZbpmuFJM=;
 b=KvvzmNZSBBrlmzG26PmaMOblFxyN8ZzJLw6gSyIbKxtFXaVYngxTCnp/5d24HkmB5oJtF5ObcDRDtQhjMRrzuPgboPNcdildFC4z/x8ax8m8jFX+IlthkJQlMye9+b5zMzKZlvfimJm2iJh+6KnJhVfXXhTADgZhGPOs5b49GwirvLtPIeVjc2oueUHGXPDfQmkVIH1I/VDPms3eDhJNm3WAGPBYnVR3LAlbhbUf0Un/ufXPxIAIPfntyiQeQlPFM6NcqA2xx7ZEXM3TPHbZrSaR7Ub6+y7PWS4B9OjWvUNagcXi8YFvm2YIkyTgw/k5bNGkNKb41oMWmtOOrONlkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SeoTq5I7xb24Xh3mH6VzaPebxy3W5Ti/2lZbpmuFJM=;
 b=j7RVQG2bNrxX8knKLJXVo7b5++MAM4tPkGlmyHMQYBlHT9KiWq58zmVJ38C/d6dndu0XXybV0oRTPzo00Pk9AbWEOyB3sbRWVYvXLlsj/CZOEtqjwOd39VvbT73KdU2Na11KAUrowZxUTS9bMQ5/Ld+brjez6QqteiFKBv7IDU8=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5344.eurprd04.prod.outlook.com (2603:10a6:803:4b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sat, 31 Oct
 2020 09:07:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 09:07:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a member
 of struct ocelot_multicast
Thread-Topic: [PATCH net-next 4/5] net: mscc: ocelot: make entry_type a member
 of struct ocelot_multicast
Thread-Index: AQHWrZsfTNJok4x350yal8NLoCn43Kmw67eAgACDsYA=
Date:   Sat, 31 Oct 2020 09:07:52 +0000
Message-ID: <20201031090751.6olljapbivitzf6k@skbuf>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
 <20201029022738.722794-5-vladimir.oltean@nxp.com>
 <20201030181631.20692b43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030181631.20692b43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 044617a7-6948-46cb-de67-08d87d7c7290
x-ms-traffictypediagnostic: VI1PR04MB5344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5344222A4608179EDA7E3382E0120@VI1PR04MB5344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xowKTDR0EUc3/iMY8a4kNfGgU63142Cc3diYe1becf3R0j9KGZDTd4+StAbzcXxwmhjk2g4hxQlT7BFEfSslgTg/Q5iyqeEEwjFiyN8YX0rqXhjpP7ozfP1jEcjJtmP1pcSb1dCePEn3IkdMFe5VwsrPbkmXFL5oE8lyoNw2Tm5lAOGfgvhs19v+mT5RfH1rbf7p5GAV2TUZxGJvgVxrgg55RG2iW7yLmYSGEtCyS97pxliGQFCfU2TwsjZi/n85y6vvcLWKGgSBHsNeo1Me8UUtzlKUY5p7bMbZ7COo7FtREaJvRhG9UeJV3KotTULb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39850400004)(376002)(396003)(346002)(366004)(136003)(54906003)(71200400001)(66946007)(86362001)(9686003)(316002)(26005)(4744005)(44832011)(33716001)(5660300002)(66446008)(1076003)(66476007)(6512007)(64756008)(66556008)(4326008)(2906002)(6506007)(478600001)(76116006)(8936002)(6916009)(186003)(8676002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: EpcmHwR2DM0FV0GITIuJF2fJgAn+FiZ0Hq7rismaYU1XiZhu/QFfVJitNbQ8f4cMCzq0o6WvnN6pQVAr5mUIjQfYZFAXK+6al7AufxKSzhJTqk/WNUGVLOVNwLEs62JuPRRs6nHpz8WWyq1Sqt8puZSGF91X49W4pK8H7aMdoVHpcmLasWxC+IpWnUjHlseQnE9LK5OJ7O2Y/80i/N/syP/Os9kIFQv78PnnH10s6NBjw+BTBTULqZ8xrWuqegwMznVzalUmajr0ZlLrpOyM29QSezGi8DaPgKKBluCcoCoH2x1XL7SwzRgH4X4QWXTpcPReg6614/fBIWeZE2zMTisPWC0zQXkaEyFRsDHUm6MX785W5zR1tcwYXHyajffnfOt3STCPI6oJopHrGDv+0rC47Q0Sb26XEXAFI7chX0M6e77bOv/YaZ5t8/qlc5gh9RL/Ky7QyykX9/3sJIhjSA/3pkW9j4mZFjN7ooBYoH1XVmnf6g3TweWEj3FZl7y4EUmWbmsb00N32Jwy0UK4fblpt7ufPyI8IdRHGTJHSLdxF4NN5Jt9Z3STDoFxYYHVO6TtlLv8z1q1kle3EcsUeBR7RUSYv8mwOqJLh/urO4nFyluNAKZ+htUruWY211JMXl0LIt74no//atZoTG+hCw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A40216A11434064FA283526767F1F8C2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044617a7-6948-46cb-de67-08d87d7c7290
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2020 09:07:52.3459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YF4sbcOH1UCXj3TLrbT5NsnF2Kh9yva84LOhFgYXLK5PjRj1B5+M3NsXnpW3Ucatw4CLatTTutGHwhf49NgwmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 06:16:31PM -0700, Jakub Kicinski wrote:
> On Thu, 29 Oct 2020 04:27:37 +0200 Vladimir Oltean wrote:
> > +		mc =3D devm_kzalloc(ocelot->dev, sizeof(*mc), GFP_KERNEL);
> > +		if (!mc)
> > +			return -ENOMEM;
> > +
> > +		mc->entry_type =3D ocelot_classify_mdb(mdb->addr);
> > +		ether_addr_copy(mc->addr, mdb->addr);
> > +		mc->vid =3D vid;
> > +
> > +		pgid =3D ocelot_mdb_get_pgid(ocelot, mc);
> > =20
> >  		if (pgid < 0) {
> >  			dev_err(ocelot->dev,
> > @@ -1038,24 +1044,19 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, =
int port,
> >  			return -ENOSPC;
> >  		}
>=20
> Transitionally leaking mc here on pgid < 0

Is it a real leakage if it's allocated with devm though? At some point
it's still going to be freed. Nonetheless I agree there's still a lot of
work to do. Maybe I didn't choose the best moment to concentrate on a
new feature, should have focused on cleanup more beforehand, including a
change from devm to plain allocation/free of resources.=
