Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4042C6879
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 16:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgK0PLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 10:11:14 -0500
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:44043
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729486AbgK0PLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 10:11:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H23bjh3CEbwBeSzFW3Wz4pJBTjOKgNlUYivHle/9kTdrEfOkOFtabfZyeflIIluUN/NkxTYPWa0zizFR7JGviwkbYJbWx7i7/qvIT/4CdTjcmepRheXP6x/vw7O1PHBuE61koJboM+4i8ph9iAHyGjWX0RqYhDaGEZk8xeuIlqpGub7RRAbwjVandLC6tvlDpcy5ujYyZCWsK8DGfuBoo2Vt964nIOt5ajUV1Tn0GONiMgeEG8UIcc5bOH44PHNSzn48Edz29jERMcGMQCn3lCfREiP3ncZu20m0IhTgwRqpACAjnPd4Dt+2fZtQjCLKS9kDBzOY1iYhI553R3yjsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SiEvg7PoFQ6GXU9brqsbuBpHZNdJ5Ha5P2npYkbkkM=;
 b=irEYxHshm/AaZCw8rJYKy8BdSaB1dcmptlozxYP789Rj3mMSPAaTG35aKWmZDVSqxNY4MfabE/NJCbL+vSZh8NqdUkMGGiaioWvVrprGJbYHutUh/4ezCgkRrdEhIyand2P1EkxGw39O5+ome1/YZqmOiWHhzQ8glbbM64DaPyTRp7uVpgh/TdFDMGplJLqJhOY6lUGGWMTZ3JxzajX8+KsIPRLA9q8YK/vfJTZmV2zW5ZP27nsqR8m9eDhZyTHoYvaAyjvmep7Oua24lEKLP2URm4v6rZXYIkcoPYmtJG+MH3koYJot1cO8ytpWLXKcXVme+XBWSGeg462Hakc5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6SiEvg7PoFQ6GXU9brqsbuBpHZNdJ5Ha5P2npYkbkkM=;
 b=W6rt+l/y+hzuj5jAHzwfDCyVK2cHXA7lG9rioit53xD9q4JnYAObLPq65TTTGkKMR71Ttm3DtOJsFUsK3PXSQ8Ef9Vj8jJs4roC0G35ZuycrQqUJ+S5IIT7C7BGL2fesWpJmFcavjO1Ae9Z68VFwMnDZ0rez+OYGwWg3oBcoZjw=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB7103.eurprd04.prod.outlook.com
 (2603:10a6:800:123::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.21; Fri, 27 Nov
 2020 15:11:10 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3589.028; Fri, 27 Nov 2020
 15:11:09 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v1] net: phy: micrel: fix interrupt handling
Thread-Topic: [PATCH v1] net: phy: micrel: fix interrupt handling
Thread-Index: AQHWxLnwF6akl2sqgUyUFwR7MFquNKncDoWAgAAHFQA=
Date:   Fri, 27 Nov 2020 15:11:08 +0000
Message-ID: <20201127151106.y34rmjc6xysbv2re@skbuf>
References: <20201127123621.31234-1-o.rempel@pengutronix.de>
 <20201127144545.GO2073444@lunn.ch>
In-Reply-To: <20201127144545.GO2073444@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1d45395-fb09-40e2-0d65-08d892e6ab8b
x-ms-traffictypediagnostic: VI1PR04MB7103:
x-microsoft-antispam-prvs: <VI1PR04MB710391B05FDD101A63757FF3E0F80@VI1PR04MB7103.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KopvRVmSzVz0JZopBu9TX5nQkwCG1ziKhWe+0eLYkSxChP0xxx5DOAn3zmPkFrC4kIuh2lbJ6nDGYfadThqZgM8IM1m9rQlhYvgDFQunQCOynS+S/hoRMZNX402CXiwt0ADKqavX6YFq5XR+tac1Y8xCM7MK7nVrbxRyJY3d6rQPtnFOeXnOovizwI0++m7oNNYDtYefchiHALF7VWDk2UCcwU0kUG7g9xjRlTGI0kPScvWGIzE8sgwjsiIfqWnVJlQhmbGLrPUF/15NNmxLJA9fnSui7YMSmVO6B3/vmThamups6PYq2OSgpsOIIRaaAQjD2OnNSS+Fq+H2EijAFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(136003)(39860400002)(346002)(376002)(396003)(86362001)(76116006)(66476007)(186003)(64756008)(66556008)(66446008)(4744005)(8936002)(8676002)(1076003)(4326008)(54906003)(6916009)(6486002)(5660300002)(66946007)(33716001)(6506007)(2906002)(26005)(6512007)(44832011)(71200400001)(316002)(9686003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3ufPRr0q9rHz/sZunRuJ0KzHoIGfC9hQKt5AUEZQBckDD27qjCywxQO6GNGt?=
 =?us-ascii?Q?BKw+dJ7HlB5+PuKZlBa6RQBjkkvTYHr16wuOn6hoqJUv8sNioRMaDVuXBM+R?=
 =?us-ascii?Q?BlLiyN2dLmmI0J4XKSbnEhIMgyaRL/9fGv4kEsr2DoBIfbCw1Rruyxxdwd/w?=
 =?us-ascii?Q?YImozOwPXBjkCBn4rH87R4sk+CgZtVq9hjfcgrNpNoEko7fUFcz7KhvyxIMA?=
 =?us-ascii?Q?q85rlmg027LC/4d0CgiBu5kmLoW7oi7XwDZpiYJZYjHp7koOHL4K+SraQxUq?=
 =?us-ascii?Q?El7zlse2iReKE9wbB65BWL2qGandoarQjLASkmwIhI7by2vd3C4cSwyKoSaF?=
 =?us-ascii?Q?3HZAlus3+9ukLz8KkmDcY1IHeSVOyq83DZBgw7wdQYFUo/82DIKgQol1pjca?=
 =?us-ascii?Q?sed60rpwgub8frJh5NiB5zsAqSh84ey1Sp/Egw3NtC3pfWahmht+L4PDCxoN?=
 =?us-ascii?Q?avf+Gv0Pt0s5sPeZAFcf+ZEioFUnecsHvaXoYCy2IKaedu7DKf3LLMy9Fmax?=
 =?us-ascii?Q?TC77xZ9Fn4ZWKSiqavvTdsQhthhvnxUEm0+59UOFyRV0miwrjrQlWLC8oS2M?=
 =?us-ascii?Q?T+xuPd4dF6Am1cZ+I5zhP85FvMZSMpKnM+26iWebmKCvcyyqn4zwZYBTUN7w?=
 =?us-ascii?Q?f/sWRgoEwqwhb1YMAQiCfHley5yw4L+njuWqZzRw3/0wfGPMWI2iyTAUlsZj?=
 =?us-ascii?Q?S0GMFtgz/j53GkCLrpEch2orhZbA5yyVjat30j87LQDhuhMTyHPSLiYs+SdO?=
 =?us-ascii?Q?fZnBrO/EBNrE5sxGZKrCuldAcGyxXPKyhX0YcABs+ZLEIc0KaXOO9kfmbrLN?=
 =?us-ascii?Q?Ids/2Tm1sgCKzsC873mV3Yek9peKATviLj5bMorcVtVY3CwgU4sO1wvXDSUh?=
 =?us-ascii?Q?6d3lJy2EcRgL3vgcACi9zyRKJ7JjwWRbXZ+zz5QPPC29+cy+gLIBEcjkOw/Q?=
 =?us-ascii?Q?E9uTELeubg3hkupzsGcujQNdDN10pcXgUikjzUcq1wlYFdVHlwqkyx3SUjJf?=
 =?us-ascii?Q?Ijk8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9865C61E87C6154BBA98DC5D80FAC6ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d45395-fb09-40e2-0d65-08d892e6ab8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2020 15:11:08.9996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gNPjEkskeHiw6FwrP9z50iuJEw5kgRmj2QfrW2fS00D1JZb9CBXYEfh3CGFGGRmBVOyHHim8F67/u9NF8dbEbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7103
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 03:45:45PM +0100, Andrew Lunn wrote:
> On Fri, Nov 27, 2020 at 01:36:21PM +0100, Oleksij Rempel wrote:
> > After migration to the shared interrupt support, the KSZ8031 PHY with
> > enabled interrupt support was not able to notify about link status
> > change.
> >=20
> > Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_inter=
rupt() callback")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> I took a quick look at all the other patches like this. I did not spot
> any other missing the !
>=20
>     Andrew

Uhh, really sorry for this!

Thanks for double checking.

Ioana
