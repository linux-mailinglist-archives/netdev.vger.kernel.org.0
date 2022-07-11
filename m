Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553A4570444
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiGKN1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGKN1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:27:45 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABAB45079;
        Mon, 11 Jul 2022 06:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1j5uy5f8wiflV4VCQHv3qoI0BXajR4w7RaPLEAM1pa6F8T+mrfvSWGeuIMlQ2J256untcfDwX+a9C3793+Bg82KzEn2dl0TkQ8G2O17+iog3q/R5a+2jFf8eH7xx6O3L53aMHR5IcxR7tWJHMdCW2MFG27hoPY6OuCYQojHfckn3rfW8SBSmj7Iogq8nUak1iV1H09XlQBY9g0nOslhYlIp6PbuKDIiwsSd3tip7HiN21RNXKomt4NqOPK1uaqXDZZ7tJnljZzBXc0CWR0/uTneKwcCegzAt5o61NFRWZGn35BwZ8GyPvjzK8AN/UHff/u/XMsMC13PvenS8UTqtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVUrzmFRQIMF/yhjnTTC+IyI/gX7wC1pBDyXN6owt6I=;
 b=mL60tos7RXZxNiUfptLNZETg60XvmvZWT9wp1LIO7GFytDDsP+iZ2Wn1dlIucpdsI7HFJMB49ypZCqkkQ9XcHEoB4uovHHhE9+erXF8KzDo4mGbyZZVhyM9Gm62cCF/al6LCKzvzVb768zY4eAwbmGGSBxddtp3/KrJ7yvgCGzCuNXN4kuJ0/dtUMb+1xk+LJAeomYDbRYOaQrXO3GAyVShXA0aB4htBkdhMewJXK9OMB4LaUemnY+YMbrPb9kEHbGZFyOQTtYTvLMzZ1QgIU1rNlbNCGzL3vZ0Jg9bpVQRPQUmjlhlt1JvI2EfwrnfTSgRHFswzX76+2EDWonil2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVUrzmFRQIMF/yhjnTTC+IyI/gX7wC1pBDyXN6owt6I=;
 b=M9kCKJDwosjjOZWHZ3zIMouOqOCAHnoD4ZJ+3K9DGoB1v+YtFJFTtt/B9K3HVDearKQNtlX5RvtAkWIV2OEeBrv8zXyxY2wnTmE+0xlNNV6hiCmWj1e7AiZHtIWmtpmXlEyCdVGDBt3J+wGDLWlNdw3hG6MzXEq3SUtlRFIJt04=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7742.eurprd04.prod.outlook.com (2603:10a6:102:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 13:27:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 13:27:41 +0000
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
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 9/9] mfd: ocelot: add support for the vsc7512
 chip via spi
Thread-Topic: [PATCH v13 net-next 9/9] mfd: ocelot: add support for the
 vsc7512 chip via spi
Thread-Index: AQHYkLCPgEvqIBosNUe2nxXKVdr3Ka15MpsA
Date:   Mon, 11 Jul 2022 13:27:41 +0000
Message-ID: <20220711132740.q3ietozqgucdutqu@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220705204743.3224692-10-colin.foster@in-advantage.com>
In-Reply-To: <20220705204743.3224692-10-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56c47670-1d5c-4a27-34b2-08da634121e0
x-ms-traffictypediagnostic: PA4PR04MB7742:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pts8R1r9KCSXl8FF8OUi/6FMksXs67+UlgEEKKb17anyXwzQeJ7EZeRP4hqREimL6v7O1ztMHqWCRfRQayUmz1i873Ahj7+/j6Jey9bdEGVR4uKcnSb/PIIh4qfbyX/UbY1A6m1RCnOcLwdGmeMnALok9zUJlm5H4B68vQuMdg567oOdK7B918BC2yBWmUmzN16Zlf/27c6yUhzQhtVe1puZPGkYhkt5T/MFZtiYylyfw4EcuNGFHgxbiUjgfKc3qxiOIFwYnIjnI3wd4qhicdRHGKwVL0qid0REcb6n6b81YEleVWXncI7xK4Ce+nLFqAknjzxQSdzz6ahM3L4lFp+gwXFz1NP5ao8yJLkZkUDt73zf1GZS8+nTGqQoyolJYly5H2xra69lFPBF0jPnK8BWkLuCPEgPaC3JEvR1nM4mO20vdbiacRODpcZFlD24Ie8zpbWqqkzCe0wqdND5dCvm/rl2g0MxKafpbJKeKWHafgTKlSzehw9N+c5ppHU+Asw3Ryftn6/PdTHIG0tbNjyMyw5Fu/nZR2UUkJ3+XOzZEozhxhITWqJaSqwYgSg2fI87h+gxZhd4tQEhhzpdHcQF1bW0q2Hsfjg82h95nnKUGEPHqU6ZWZFfoIVIZuqhEMCbkLvbojo2X91fgT/GVdCCAY7xKjOBu9/rXiR2WebIETTJD1VvRkOMLiZb3+Mog/EcnoYVg9M68p1V4qBYjehhAQVMseG//6Q57G2Tmo0ajoqouOUaKhJyERZT7CjpnHd7NT7daPqpN17de4R3wOHuOZgasV94Nnc+orD8NGK7yAYhxhOszjalPGoJCvDC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(376002)(396003)(346002)(366004)(186003)(122000001)(33716001)(38100700002)(5660300002)(66556008)(66476007)(66446008)(64756008)(6916009)(76116006)(4326008)(66946007)(54906003)(316002)(86362001)(6506007)(8676002)(71200400001)(8936002)(2906002)(6486002)(478600001)(41300700001)(9686003)(6512007)(38070700005)(7416002)(1076003)(44832011)(4744005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hr86I2slcTDEhJxommxbnElsr63e9Xsm+8wEOWRCKMYTd/nZr8ioJ9u262RZ?=
 =?us-ascii?Q?rRZH7rE8r3k3FvgLYj5TwHlmXi/oK7NsFLH8CXKHKRoBrSCIwa5E7Xt8siEj?=
 =?us-ascii?Q?pX0cPnkdR2aXX+XKLJowWDLTEvvkOWKFhz8uv6PBFfR2yU1arbcm0LCK4z23?=
 =?us-ascii?Q?MPgqjOUasQ70TPj7UINGQDet1rv+Fw84Dv27sTIwMMCbkoatHCgzqxCtctCr?=
 =?us-ascii?Q?SMVIq9f0VLDeiv3RC1U4pvbVr3ZRgSNtqeI1cI/DNnXGsbNmO44RPo7riBCe?=
 =?us-ascii?Q?MDwstpC/ZqhvUzvx7xA00HfBLQdj8y/P2tBi31q1xqIMsAvkeXX7aFoo7ivb?=
 =?us-ascii?Q?4agAd3CtKWw949IXTx4XNkGukYBOpzMAn5LKE4q8a7GjC/ZIM/XV/QndGoFt?=
 =?us-ascii?Q?UBw8P0ykogkOm5A6mV5JRdhuL4tRVJY6c8Bt4B9zFTAPpkxzWiZLk78PxRVH?=
 =?us-ascii?Q?XP1I0X24+Io32No7PJbd7az2ds/YoFulTMxlwxWGEnowHdqQH5Vd40Qxaoco?=
 =?us-ascii?Q?/LnJqJfPF1/tr3zLJCptyIf3PxlsM9amEKXqZmkNtDs0j66TspuR4WOtyCRf?=
 =?us-ascii?Q?S82MZr4YRHwS3gQ53nO/gW3Z7Hh5EfMSEUu0zlrr297f7VHMYmj/g/k6VFc+?=
 =?us-ascii?Q?T8zgsJnsD0EClnU3e5CmviCyiikz7MjiwzVqiKa7bfN/OCYHw+O9VplmSbd9?=
 =?us-ascii?Q?yR9UP2BJgDDA4z29iRVVqwHKeKj4vfPvF3yJyXl1enzcDZud5/dxdnGTX2Pp?=
 =?us-ascii?Q?sApzr2kvsJ2dMpG2++pYdbupywT/q/fXuzozBTHY/mA1qB1HW8mVwZnoTOP3?=
 =?us-ascii?Q?6Nlia1sIxHrGwMQ5z25vgDMNtr3FswOvCl1S9bhN9mHXBaAtzm9NZKNJUSUG?=
 =?us-ascii?Q?iypIV+K5FyHEmYHHXekJc4NAILymjfNRo0yElhFURxRhnEO4m+JyyHALXgPf?=
 =?us-ascii?Q?rkEtjAXx14HO4AeuGZ98ex2BbdYVfnHSu19AemUoSUYnfPYubZFoYrP2M2x+?=
 =?us-ascii?Q?HDf/KpevTWSPgW7wOsSoRQdA6SZgGJcojORFjqREO8QA7vf4aRi2klPpg/KY?=
 =?us-ascii?Q?VNtW93Xv0Sc1/94uCVWcgwNUcWnRLsnPPci4T2LqbheoOnVQaatT99i7YRsV?=
 =?us-ascii?Q?bkCuUuaMX/CJHSsj+4klmZdZowmTugdzCsuhwLtB9sy8XVX+FdS++CaO4gSG?=
 =?us-ascii?Q?WMZ/Zhxwguilslwb9pwa8UmfsqP8JC11/zKTfKBd8RUYDj9f16YZL3fJm9gt?=
 =?us-ascii?Q?TERA/VKm1A4XGgCWCy+yrsfzU1egJG/enbf8mgEZxJRnJYc7/Sr6yuqTh9HO?=
 =?us-ascii?Q?XQgQG91iB33Dx62+pRKM6t9ouYTxkx9obTYVcMNM9lyFOQVBnoL1rZ4n6Lx+?=
 =?us-ascii?Q?A4Zm7mhzRU6n4L+zEVubuJ9k/++NqSd9tEhFt3zzJas0ru++Ii5ZDP1HRgEo?=
 =?us-ascii?Q?sO2mXpeyghHNcTVxTKsYluFGqFQWY97ePbqIu7g3SAyCj4x1ByVEgWfEmAuc?=
 =?us-ascii?Q?Ef8Fc0AC35I/wpoX4df/YovuGIrqQsQtxbKNhfgNc4EeexlCZQOTYQNmsPir?=
 =?us-ascii?Q?sMrtr+72gwCQDrtPfPxz/UxC5Vax6nFnR1BKTM9eeWjmfkNlYRAA6FNSpJWV?=
 =?us-ascii?Q?1A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C60D734D83E7F4C8E9C8155F35167FE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c47670-1d5c-4a27-34b2-08da634121e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 13:27:41.8399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RaS0/maP9V0KWKWIn6Hp4Dx1ptp/9mbzOWd9XxSIgYCdewPtMMWPyh932yBX5nDgg7iTgeLuNVPPoreVTdsYiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7742
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 01:47:43PM -0700, Colin Foster wrote:
> The VSC7512 is a networking chip that contains several peripherals. Many =
of
> these peripherals are currently supported by the VSC7513 and VSC7514 chip=
s,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
>=20
> Utilize the existing drivers by referencing the chip as an MFD. Add suppo=
rt
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
