Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D250955ED19
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiF1S4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiF1S4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:56:44 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C38223162;
        Tue, 28 Jun 2022 11:56:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqN7rB7BIPOFY+Fvu6AUtjVOR8fr7fe/Qsdk5iO7YTtDZAW0POXeTf/JdyulYRX3iR8c0ZosW8dSfhbPomL0OmSuC3Rv9+5cdkppz9y2sTwE2WMTdKJWJhkMvDPn1c/23izm0gKax1T6ackE2XWExvuHVNQ7jyXviBoyqJYykr2q6vKnaeqh9x8wrU67hx/EU3kG502y3Yl+eQT0Dp+K49V4AzEsUx4Tgj2M6pv9B95yJqjL3/nIX0wOGS/8Kzi75Jn9eDCfT59g/45K/b6TwIg4/SHtD74CYfU2zqbcoACXAYx9enOBoCOENTfd6ZjKqxg4pWIxyIiER11YekgnEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3l87NCKmC3lHpy6qgcT58i3J7YE4SXFN4mYj1Ih/go=;
 b=TCcUqWVzcG+euGSNmeG0DIJ8Ovf848nT45j+nADn0+AXA+CGtRuGxUhxtxLFYMG6rizrUry+O6e8daCmiM8XGPOiDDwmTKZFnM+8r+KmuZSIREClJ+OB/2BDWn/jYOfHhelctIwIcwDo0BfybJlr3ArTuhcUEgpMaWlOWBnnOWZ1SZE+nPXaWfU0VJsdYDbyM/pn9Ldao3hR+D7/ip4/+v0HuI+1rQ/04c4dHOMt4L+xrwnRBI7KXtFR2yukv4JXhBGb+U+vZvWNfXtbY2fEEvJC/Pu82laIFs+prhwZEwjSiFH9fvi256kV0ynWR7hy7VbSgN30tiG7AgYKA5PRyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3l87NCKmC3lHpy6qgcT58i3J7YE4SXFN4mYj1Ih/go=;
 b=JNHdy5CeIfCI50hn68c9Vjp/c8Cz+Z+HN2T9axpE9eKzuhvSZiNMTo5JX1eTqtzehsZIupZzHyZTUKEWvv8GrP+qnV3TsF1OajPKBozr7qHT9lDadBE/Se1J11rzApiIVd1OcvamfIanMI6eIVhixK03pF4kKSlaw5BqKCXlr/M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0401MB2682.eurprd04.prod.outlook.com (2603:10a6:3:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 18:56:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 18:56:39 +0000
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
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61k/PWAgAAVjgCAABbTgIAAArIA
Date:   Tue, 28 Jun 2022 18:56:39 +0000
Message-ID: <20220628185638.dpm2w2rfc3xls7xd@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <20220628160809.marto7t6k24lneau@skbuf> <20220628172518.GA855398@euler>
 <20220628184659.sel4kfvrm2z6rwx6@skbuf>
In-Reply-To: <20220628184659.sel4kfvrm2z6rwx6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c20522e-a4c7-4a42-2511-08da5937eed9
x-ms-traffictypediagnostic: HE1PR0401MB2682:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yVih6t+D1zP80gSWaRYEj5EX5F5WpllEICd7quTxR825olmpvYQ0QZpOb7raWBkOVyZ9f7vu3wsGyWvEnjHg5zMKEu+WIDsp1Q6Q6i+heFgQ0Rruf/bbhYHOY0dBT11N9TSi7YsqtqFaSe49el1cvQqxv+PtgBKotOfz+Op/HPzBrCJtMl/9I+f4R/bVaDk+X6nKrkcTs8lQSGj3wgSZ93J/Lojk76kcJYfmJm8wCtL8gmFz8Iccavdzes1SSITVb6xGkCwRaL6d2wLnMES3YmeDrNnvxqo+JQN/BwA21RcqoAzEoKLw7Mb30S9swPyvsiX4H0qWjGmD6YHTx4ka2ayizmS/hhsdy+mMHDT1CVJjaI7ZDArUQ50wy1th1n5xkjmOelejbDZKG8Gq0TimXa4B07qM91HgYzw4x/KuOo1QWia7IHjF//CMWHqkr8h3X5+FjJ9xCn5SCvsaY59Pzd6/qg7Wwn4QSsU4hrA/my9dzqtQJ7m1avDXAVH/Fj7LgdYuvCn3ZKN/L6P7WfYTU4sNyybrbcW8NH4RMLPg1TVl9BRO8qQKbQ7BXtnZaXfsBN+1IihQ2MrYiT3PRehrB3YHlw1V7F1np3ew6/pl61x+Mwu8q+Fy2zFrjIUIHFja8LOBFWi7zfbKfLVkENwTbSCgZ2XNTaBh5utzJWXSyDUg1kJrPTuWPVzs5KfIUW51Xs+DSOt4OySfYJtphDfYzCvbncobRois6fo86MCqf29Rfcr2ig4qdsVvsYMijJJ0ojSHl/5f9qT1t2F1pM6JSaiUONvhTe8L0ZFjbpK0VZE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(136003)(396003)(39860400002)(376002)(83380400001)(6506007)(1076003)(33716001)(64756008)(478600001)(26005)(6512007)(186003)(6916009)(41300700001)(54906003)(6486002)(38070700005)(8676002)(9686003)(66476007)(66556008)(4744005)(44832011)(5660300002)(8936002)(38100700002)(316002)(76116006)(71200400001)(2906002)(4326008)(66946007)(66446008)(7416002)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rUwNXuqEfhF8ixGs2IU7TD4z8liBHEUZRKzXEiCvyn4lDxz2F/oITOZ966Uh?=
 =?us-ascii?Q?81o31foR/xMcQcdSJHi9xNBKdsLXVAcfCilA7Wdae8hUC4bHAopHo7uahnSO?=
 =?us-ascii?Q?T0sqZpw0fa5PhHxT/3m6bTOTufsoP8442anITx4RIt1lUmL9vLJPwSeu5E6M?=
 =?us-ascii?Q?t2NErf7gv8VZN+Ym5bHHyk+RsQjQbHvWwI/pUANiDsVkq9bKRgymXjZ3XSZ2?=
 =?us-ascii?Q?LPd8jrt9itJdrmdew/IFKHPAdN2Kx0/Fkc7zNfbphHwYHquKINsFJfyv2ok1?=
 =?us-ascii?Q?ADfN9tEf8g5ZFzUxL5p4t7+g76oHV6aEhfrggW9lboSdnEgLE6z7VL+b+vjZ?=
 =?us-ascii?Q?oWfbGWiywnKTdn4JdhJUdgULjRxGSYl1fOAq3Prv0zzcYeR6MGxoNLzyNVzd?=
 =?us-ascii?Q?zWnnjO5e27NIGsIe0yLap2SX4V5csUjbbZDAK3ZoSIMsy3YDxOumUuzMsLpf?=
 =?us-ascii?Q?dUNvl0CWvEzO3w0PGj/kLDm8tbwBrFM3eKds+7/zoL9oGLXMYe7CCCQhU8OV?=
 =?us-ascii?Q?XHCOp31cF9k+Mh2AQ4y6MgFezy45ac7xnz6DNUyfhGSZHRrLMfQZYbmQ9Kmr?=
 =?us-ascii?Q?N4FGi1DO63bJjGbOPCW5kiGF5Gt/0G2y39R54MVQs6GSdpAb6eePgABWzMrj?=
 =?us-ascii?Q?Vu7uIuhJUAHms36aHJYdFR7nVi9xZM1fBzbtVhNhR31Sb/gwXXaQ4s4kmUyi?=
 =?us-ascii?Q?0PG9j7auZRZCbnZachrSHChiOtKl9NiFwmqBp+buvCPGfEBSdevapDrlltf1?=
 =?us-ascii?Q?V8LAFKIYoRCyEGfZUQ4v2RqEB9U3+jz5rDrDrrwzSa5zuSPt/n7tcT721KHe?=
 =?us-ascii?Q?/zlUlvQs6XWJBfk8/SisPjlV5GsG26iSwNKWeV5YlF5rI9eq4l8udv0NDSYG?=
 =?us-ascii?Q?sQKSia06zZhcp9AyqiRK8z3n+dj142ZZzoXzlqtHy+oNLIX3Frv10paOU/6e?=
 =?us-ascii?Q?UCsZIkuehqZ5FSve62Ig3mSrzI6dgkAKMwW/QBnSorGlNBQ9l19xDFrMRbxg?=
 =?us-ascii?Q?j0p51rmL54+CUJ0ULf0y183PRKTCqLShFqftIZJWxMYW1Gfc/XpejlxBVIPM?=
 =?us-ascii?Q?x68MCkdZPW249WtK8POXKcZbzdT8iIHt4stiHxwEafnQUGzkFAko6aFK7YsR?=
 =?us-ascii?Q?ANj4OhxvKu/KncuKCBZq1PQ8OHT1n/dPfvnAwt8Agu3A0pDhcPF6xr7zQkFA?=
 =?us-ascii?Q?VyphuLpphZvDsBf04C7z7IXGAbLQXAXAsj3f6OrZ3f6hyX3M9koWbpnq1mZa?=
 =?us-ascii?Q?LSmYFl+KfJueS93BPCb/rQfel4aO+vFr9qMlUmL3nEVKkuCroKf/gaMKOfLQ?=
 =?us-ascii?Q?/C5fiam+M4vW8pi5DrSiDqVZdqKd8aOAeuJtbb1bBrO73PzUN50EIAG9jyz3?=
 =?us-ascii?Q?xECAchKuullkiyTDq/c2oKolkbrxFhnVYX02wSYspTa2hwuhOTrZJiSAknqV?=
 =?us-ascii?Q?4gRB1PhJyWcxdReUt+zKJLtzAo+7xzWcaMZWT5HqaCNNOeG0LcwAW+BFMNAK?=
 =?us-ascii?Q?boQ+YrHsxgG1BaqnsVxA1GSyh2kBNGbqj66EZSrNLbs1/0L1NAuBVtkyoCXi?=
 =?us-ascii?Q?rDZlzOQ8Pypyv9msBqZbfOl4NDaw7nfRFzuEPaGw/LroqsZKDYS1oyal9w9k?=
 =?us-ascii?Q?+g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17C0FE856701B54793A7A532F1F5F16B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c20522e-a4c7-4a42-2511-08da5937eed9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 18:56:39.1471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K0dpgdYUI0ExbkVyg+o6upnrs5YNEklIymSK5a1CTIRzKAqbsZGKVoGkXX0U3FL1tsmPzuopdFLGei5mKf9ppA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2682
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:46:59PM +0300, Vladimir Oltean wrote:
> I searched for 5 minutes or so, and I noticed regmap_attach_dev() and
> dev_get_regmap(), maybe those could be of help?

ah, I see I haven't really brought anything of value to the table,
dev_get_regmap() was discussed around v1 or so. I'll read the
discussions again in a couple of hours to remember what was wrong with
it such that you aren't using it anymore.=
