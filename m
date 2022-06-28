Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6734755ECEE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiF1SrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiF1SrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:47:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2089.outbound.protection.outlook.com [40.107.22.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0297240B6;
        Tue, 28 Jun 2022 11:47:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvMxE1eCjWpJkeEdHYA6w5qpm0TgBYzpsXREcqypQT1hXdGHdd72M55Z909MXc5LFK65Wro4zVu2BYWbV7fg9KFOEGdrlWcoNaGrqOFPud1eDED8kiQIIl/0EEUxQplctYV7xJnkpZi4lGPk96pB41cpwfS2aWwplokNvh3Z+2nrwKGp9D0ASQDv/tdasCuihpCheKYY0Wxovp4vG0BFSO9s3wQX89uOKfSdoM0HbOP/hjyWwJZrv6b65Ixl04seH95CdldFcZQygUuUfwobvqC8QwdaBpJ6n4jJnxnDq/Z9uJGdHWYjfL0wt0/kPSrqn4L/+RYPej5+wOzWuEzEOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lzu+njo7ln3KGMl32L6EMluaSDtILYCGIt0+ktJGyEY=;
 b=g2IHY0IN7qwMkMIGvAqLQvaLGpEOrNFTN7GZv01+8f6WVs/BUNobnH0+6wI4CEC/qQDi7VTdsWmJsSPKuxUq5PoSk4WwLrnAhUg6yXJBkToeSHymhZFdWnL17p/p3rObY9NQVuSXHcIH+scrJ6RREYodnyzxd0YrmfEBajAA4Du9auayQ6Fj6dKSEcL8jIZ3jdhCnp8lKuVzudMJFLVfVYed30z/g8Hv8Qe/BXopmsX3pwajXQerdsLVc0CEAwRpKaTxnD9tQULwchDmBvUDFsD5FpyLqlLjtXZDy48DFVFXRINdd3YVTfJpXQX35DAMmhSRpRtV7xShrDwwJr6TEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lzu+njo7ln3KGMl32L6EMluaSDtILYCGIt0+ktJGyEY=;
 b=D6m8ak6QWE3go7oSQYGkiR7z3Oss+9wSX90A5wMs0i8xFe44kNYXHNF9jCrSSWE1ON2md+gIE8AltpRZASMIk2OlSKj/Q5/YRvxMgmwUeceMf2PeYJv/v+Se5Th1rT58/QG9tGeoeh+iWyVOsGXHaxG50Hx1lYtTHv9GJylBEOE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8794.eurprd04.prod.outlook.com (2603:10a6:20b:409::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 18:47:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 18:47:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Topic: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgA==
Date:   Tue, 28 Jun 2022 18:47:00 +0000
Message-ID: <20220628184659.sel4kfvrm2z6rwx6@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf> <20220628172518.GA855398@euler>
In-Reply-To: <20220628172518.GA855398@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05eb3449-b1d4-4b38-b8a4-08da593695f2
x-ms-traffictypediagnostic: AM9PR04MB8794:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LKD7ZZ04iXqxRNnmkup744W6p1p0Q5QE1l88hA8jiigR2aeuVG5BvjREv7bIWbpSrGs0gtLmZIyI7MphnEPYmWrZoiONS8YTHeuhLmFDs79ujVn509m3Nju0/s6RiAW9bUvLQcPXlV4jws7+fbV5ZtCbg5fwPJy1YEiLxP/AZSOn434hL2Ys7qTymkfnKJVF7IcFQyw9zh9HLV1fgNtdAjbsP9dZbPWVPxZwJieLz8Uo6gaLB/anGnbDp59zy4p+H2eKA9I07EuQiJ18HNL1wUcfiQcVd4YFjMZBScwq7xV0yhBiIB0l55B69/BsDFjjG0P0UUe8aMtrYJ4xP17Kd5yvnqSYOUy8UOxw+ZuLNaEXBbTr7NcrEhvQvNd1rXumzPGUfUF8TgsgUNSe0CC2ABBd55C2xkXyUfSwiV1LGETn9K48oAQm8nHZ6dyzaXmSqkHTXdrzNu8bsNA7umuZVtCoSwEsWrNB+3EBHSyoqTDq410Mpz0mwS9iqCRFbtXEkkevaFXT5hXrbGoKnejEA1ZOne+Z1/wedRQ4IOt9qj2hKfzJJy487pVwnZtkLod1wEmYyT/nCyQAt+5WLCofWw20xPTphuUYED1w90kWqSIvwjvLpUqFWoV+ZNjU5dk34zo04xG8Wsxj5nGdlYbZU6MJzQbV/+YXc/cxkhog7w8xuZqOQJFYMhTj3X3GAV2dJGTUVLM5EHkFRMRUvAzuKehRkZp/ytbzlcIDucq0o9Gd4CV0WjG10/Bz7aHOLGX6ZZI2MuTg+wqGkVnILmA5LAoMGCXlHQGv6NJJjJn9two=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(6916009)(54906003)(1076003)(2906002)(122000001)(5660300002)(41300700001)(316002)(38100700002)(66476007)(86362001)(33716001)(66446008)(6512007)(8676002)(76116006)(6486002)(4326008)(64756008)(9686003)(91956017)(71200400001)(7416002)(6506007)(186003)(66556008)(478600001)(66946007)(38070700005)(44832011)(8936002)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3m3ryMlExp0HVeey6FHK+3QjPgcBYKQlWKTnbadkbQrIp9vsteKxb8p0S5nd?=
 =?us-ascii?Q?oFs5272nyVLFSm4fffgwgf5hBleNBP7sgo61wikh94PNdibbGKBzkRzWaub7?=
 =?us-ascii?Q?zhDQRBbW07fOUm/AkhGPYv5BZzGSO2semIhvwHyBYPnewUcClhZkxQ7cyWEq?=
 =?us-ascii?Q?2ZTIsFVD3Pbo92v7LMfHLkwCS0NAh1tW0ZxvrwXyGaMiGXXMu6xvnUJEqCvo?=
 =?us-ascii?Q?dUYvMWXqMQuZYO7LLvy3oZRHC9del1RefZ0aAU9JXYCwyiT0rd3zNbhTsEpn?=
 =?us-ascii?Q?RJCnfRbUj/hfZLl1qr0qWR+InaJ0WLA9iJqrSbx+4FGmkYTTwGyJcUD1Lz7R?=
 =?us-ascii?Q?J91QKB7UszvywsGKxwOyizej7sCcISVJelwwD49CrWoUWcyEA6zw7OJ2KwOA?=
 =?us-ascii?Q?eS5brIwdt2c3tllhNN9C4MpbBIQUceXz1xFzerANdpR4MWzHiiXypG7YS8Q0?=
 =?us-ascii?Q?6SharhMuQ/63MWEyiF3XVUHfQi0DL0hR5LsVXYVCV6U9u8vO/8i+KcR9jWPT?=
 =?us-ascii?Q?LbU1gEw5uBQzrGyrimL6rP/ziP25iy6jg0BTbs+xWJmNDxtrCIP57Ay6TTwU?=
 =?us-ascii?Q?syvmFtcAdKla8uCo9nZu79o4uu3+DAlmON5INrVfu5tGpJ6AbhPUjfQpthuA?=
 =?us-ascii?Q?h4Oz/5zXil4x8YCuy9Z5maPdGQPpZUTlSg45lpd2CMazX2PQt4lRMjm/E/HT?=
 =?us-ascii?Q?PNEVIqPfObu/5XZbzK5rQQ6NlKMzrmsV9ZaL+8CKGJE3+x6BIhnSjSkTF9qv?=
 =?us-ascii?Q?Pg09JdoRpYxxYQgek6uZlg8l5f0F3TKmem0YJyddb0K+GCH2oIYgeel7oaGw?=
 =?us-ascii?Q?adTFsNv4duAuNl+hifWM4HCU0ao+JrcmVs0aE/nD+9jLo5ToKthdtxLDLma5?=
 =?us-ascii?Q?JgAUOleqrwsG+tfP9iT8UwiTeL61vgHkP0ImwjAYjRdyiYD86ZO52zCb5YtP?=
 =?us-ascii?Q?tpp5+LQZBokIY2FyaxwByJdMtl/oZb3DO3PrzqB3JAHOyYj9yIwhh2kELLkw?=
 =?us-ascii?Q?VN8+XJoNrPD1dRpKPeV9UZ4LcBfOOPJfr2QU4QwJn/hikDXq0CWWQFwig8M5?=
 =?us-ascii?Q?XZnoX+lDhtkheUpWuLDf1magEn2OnGqDKCQqW++R+/5FAsQDVMJchO1CCPf6?=
 =?us-ascii?Q?Ngo4DDQMD8WjVg7qMwRaKzNWT/6Dd3fCuSGW4TPVHpjHeNOBgF2yw6CYgFNc?=
 =?us-ascii?Q?WLLFgudtZMl01qTrBibafKNkKfiFc0DBSyL1IC4dx/CacqUKJyfX/C/tNyEW?=
 =?us-ascii?Q?SqQ3uvKFdX1BuqEg253UUJHgvwqd21UvGUtlQKA2YlVwmA12vsk919mvvBEE?=
 =?us-ascii?Q?Hk+pTnWZBbl0HqsZ6xF2LZXIueLPoU/LXuwcNucEBY1EOzSnve9j1VY2FeaN?=
 =?us-ascii?Q?Siwu5jc2QenN5WOt+CWrJA47bT5YGWxvFD7aMVKrsv5yzEBkkycEwqoBl9ni?=
 =?us-ascii?Q?8Q/4JAtQ3/KYg6IcEfBZF9Q5YbPHog12HpgSJWubrGe9r8GVu1IcC4Ca44BJ?=
 =?us-ascii?Q?UPPbSrSFspodGfVxDj+VadQN7Fyyy7RGcxaVXRQGHm8SN34V8bJEvgzxv9u9?=
 =?us-ascii?Q?wgUVtfdvAFV4b1NznFzrRjy+11rU2JUOMDejFrDvpvsjSWQlkF0YOUaxfef8?=
 =?us-ascii?Q?Zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2327441FD0397D46B5F66ECDB2B1976D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05eb3449-b1d4-4b38-b8a4-08da593695f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 18:47:00.5008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WBX1CU2sCjI1wRJ5Ve6tKT6WNPp89mRemfi3j8VUjNUW+UFUH5OgrY3WpXngmz1vLyS3NhxAkD4YP7oi4RxcwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8794
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 10:25:18AM -0700, Colin Foster wrote:
> > struct regmap *
> > ocelot_regmap_from_resource(struct platform_device *pdev,
> > 			    unsigned int index,
> > 			    const struct regmap_config *config)
> > {
> > 	struct regmap *map;
> >=20
> > 	map =3D ocelot_regmap_from_resource_optional(pdev, index, config);
> > 	return map ? : ERR_PTR(-ENOENT);
> > }
> >=20
> > I hope I didn't get something wrong, this is all code written within th=
e
> > email client, so it is obviously not compiled/tested....
>=20
> Yep - I definitely get the point. And thanks for the review.
>=20
> The other (bigger?) issue is around how this MFD can be loaded as a
> module. Right now it is pretty straightforward to say
> #if IS_ENABLED(CONFIG_MFD_OCELOT). Theres a level of nuance if
> CONFIG_MFD_OCELOT=3Dm while the child devices are compiled in
> (CONFIG_PINCTRL_MICROCHIP_SGPIO=3Dy for example). It still feels like thi=
s
> code belongs somewhere in platform / resource / device / mfd...?
>=20
> It might be perfectly valid to have multiple SGPIO controllers - one
> local and one remote / SPI. But without the CONFIG_MFD_OCELOT module
> loaded, I don't think the SGPIO module would work.
>=20
> This patch set deals with the issue by setting MFD_OCELOT to a boolean -
> but in the long run I think a module makes sense. I admittedly haven't
> spent enough time researching (bashing my head against the wall) this,
> but this seems like a good opportunity to at least express that I'm
> expecting to have to deal with this issue soon. I met with Alexandre at
> ELC this past week, and he said Arnd (both added to CC) might be a good
> resource - but again I'd like to do a little more searching before
> throwing it over the wall.

Well, that's quite a different ball game. It sounds like what you want
is to have a dynamic list of regmap providers for a device, and when a
device probes, to not depend on all the modules of all the possible
providers being inserted at that particular time. Which makes sense,
and I agree it's something that should be handled by the kernel core if
you don't want the sgpio code to directly call symbols exported by the
ocelot mfd core.

I searched for 5 minutes or so, and I noticed regmap_attach_dev() and
dev_get_regmap(), maybe those could be of help? I'm not completely sure
about the mechanics of it all, but what I'm searching for is something
through which the mfd core could attach a regmap to a platform device
through devres before calling platform_device_add(), such that the
driver can use it (or manually fall back to an MMIO regmap) via
dev_get_regmap().=
