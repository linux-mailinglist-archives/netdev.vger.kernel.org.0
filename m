Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCEF55E6E9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347856AbiF1Pdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 11:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348423AbiF1PdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:33:25 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140073.outbound.protection.outlook.com [40.107.14.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA8D1EEE1;
        Tue, 28 Jun 2022 08:33:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/XXHhejpHiLzL4YHQp8C+1Yc6//naHzMSiew0GaEjfh+BDwie+XmItCzYF/SnGCgXrsZ3UMUzMbPfJ2CjtrYQVcvpiEZmM+cT0yy9WC7mrVvYzN1p4uIA7rhv1UjI8bvv3ao3mWs2e3CtbaajYlwSLW9qX6jhXiqS186f1x2bORwTI1qAD0xce2YP6WgCi0vNanoZnGnYUI/dj6V3vt9IGZvwCN/4vpB9DABCeX/s47wIwkLwQlMecdcCPrsZ2tqR2LbkiGJUFK8VRojXBf7NVSl4pIss+CoiUWhmmbZGrIeUPVCRqS+ErXZJK74IVKNVlHBIVRb1a9Kz8omhyWPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di75XbfP9RwB6qzbud3+eS61e41dgw+MoM/b9DFLxGI=;
 b=XTJFqtieNczzGYL1x/dyMcc2oLTxOfnL8r5x+25IXw16l5UCKbImK8S5GWLnGf9gN4Vm8NjsFEc6LrfjBXYef5O6SLUhgZxnuJGlCGw6k3p4g6bj0y6TZ+IpcZRU4LgC70gEwWufCpXm1U47RFT1/oogoTSlb4AqDEI2XEJrgWvwydMa4nACTbOrwq27J1xfAHEjHrfZrdJ11BLtM1Vz9KRzfwpRse6U+0ne/5/OynQ5TChk6bB6ANksWA4ysko+N0SGq5rCGn5jOh6YQhceylFlcZH6GJx3V0qmIDl8GdwJZ56jEQw9R0oi3pNpEFby4yUZ5b6JRplDlGnLfEtmsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di75XbfP9RwB6qzbud3+eS61e41dgw+MoM/b9DFLxGI=;
 b=gbtDdoYiBlqNk8qw8gFUho8sWozsfSk0lbjMlOyjwA3xwhbGBCCn5SdV0F/O7IaR99xiU0zfheQFmOVF4Iy7MfKQUYSSDXMuNqojt4xdujX6vngooZnJm57NBGPebD1C2wtn9PRQVIGro7QCszZ1+9hKj9xbo/Us7wkujQe9GXo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5361.eurprd04.prod.outlook.com (2603:10a6:208:115::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 15:33:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 15:33:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Topic: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Thread-Index: AQHYiseGTWpqx8Siq0u0vYqv+P3KI61kxcMAgAAteAA=
Date:   Tue, 28 Jun 2022 15:33:21 +0000
Message-ID: <20220628153320.jrgofeemytyidbot@skbuf>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-2-colin.foster@in-advantage.com>
 <CAHp75VevH4LODkF4AELH=E5tQRZZ8LjbWN62sA14PydLMeDRgA@mail.gmail.com>
In-Reply-To: <CAHp75VevH4LODkF4AELH=E5tQRZZ8LjbWN62sA14PydLMeDRgA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54013e20-8fb6-4315-f5d0-08da591b8872
x-ms-traffictypediagnostic: AM0PR04MB5361:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SBpCpvDd/XFTFLQDOi43lhNV9+ZrEem+rXu7NQPjXoJo83g82W+TKA72HVuwgARAaTzwom9QPXEvS91reJQBOThicv36/eOFQSyRnNWe7ZR6hU2wQ+5f8clspVOcdlp9THMeD3ckc/O3u6XhI+GVuhagOvGOkrTwmHzu8/hWaHNWjlBVfjBKRMYL40/4x+daEvGPya4z3f6F4MT46tieG1ELAlw96mRX29cBkSbsQ/V3CFppAyyVYCk9tXR5Mptet5s+rkZqbeWffctkSyUmr1nE+OiPE8IRpBGvb3HOF6nxLFdHlVjT1lwe8TdOb7EMC6kUIYSsKwLhmiELHAmzBvSpEBS06lD+jwoRv33daOZwS/4hfoyGr+xz/mMUzbFaYP+NS4KMADKEyjXuI0RyxDHJ3/wWvqUTiP9TIpgooUAqg3ep2EdMJPSgjVwJTCZ/O6XovDj+EDBiz4QD7FlEUcwPpCSWcNoEjPJomdewpzwiuGFLIVLR2EeGXoqhDh5r01HZTGLC/28g+znV7MnnhnZLDnMV1i+PYfFyoGPlmjJacI3er9Ar+MrBcNoslbAHT3bK5JkxCoO8nok9uj6EQUkd28+pOSNHhq8J6Glbo5zsygPqDl3CUafvuHn0jOdpkBTODm2vjjzCuS1JsEIxZhjPaalPSZMO7mNrpU6kXzWRykTNmbgh+StzR8OMlgaDft+V14bbTsHX7sKX74v0S+VK1yyeWgqK6NKn6PxFuLouAJx50d4lfmsZb2SW/O9G6Q0lvlg5HlOEj3r5SJ6PqhS8wWW67d002E3j6kfyp10=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(376002)(396003)(39860400002)(366004)(66446008)(8936002)(5660300002)(4326008)(76116006)(64756008)(8676002)(66556008)(44832011)(6506007)(7416002)(83380400001)(66946007)(122000001)(38100700002)(66476007)(6486002)(86362001)(54906003)(38070700005)(6916009)(71200400001)(1076003)(186003)(478600001)(9686003)(6512007)(33716001)(316002)(26005)(3716004)(2906002)(41300700001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v4qqOa8Po030KK9gw/QnYsOkNo4JnXZyzB9ceOGz/cl7eOFtcywXt4NgPt1K?=
 =?us-ascii?Q?EGBVdxjUFv8KKDdXJbrrXi9bRUAdtUg+JTCJ/RaN5ac0ixbrndtMGeZFFuIv?=
 =?us-ascii?Q?2ckD8y12oRF4x6gvXhNtvnvlVvLkQEg/0duMpnMXOidaf5fIepJVTUP7eW7O?=
 =?us-ascii?Q?WZMRv1Jk55570loDhWJ0mzrWxYWWy3O7B4aeTXTKSWBWznBaEMgUraBC0BP4?=
 =?us-ascii?Q?c+R2tV9tv4TgQQri4RxeWMAvrJRdpjPsm2k701LHgrfNpX++2XNH1JC/5CU6?=
 =?us-ascii?Q?5S4dutKLK9DZfE5+6am/wJn0bP31in2/rxI2YJ6ZNNSPo5C42hDa8q3Pu1vw?=
 =?us-ascii?Q?2m/g/QBQZ6ThMwEBtl67k4beX7kNMkU4SCAaykqOE4vx+nNsgIJXnN4hapbX?=
 =?us-ascii?Q?ieXbZYC7gLaH3Q0VTVYL1NIPVGE0sJ8UlHPyLByWbYO2HYP1vPxzZ5LOa84j?=
 =?us-ascii?Q?3YwDZOlJi2PTKbbqQOJYvLnUDXk/7+Yi1SgaPgyuBgSPasTCpt+bEzfKc3Qx?=
 =?us-ascii?Q?pQ3kOwiCn9F5h7QzIBryrjzs1fP9li6oI4TXoo4xrFxkSYfJdNvsoyqX9JNq?=
 =?us-ascii?Q?pupl6pK/8XPvtmgaqXdVnM92+Gdus5uSloAuWUAIFz6+jWaBeKHu3u2dGHsd?=
 =?us-ascii?Q?dAJ5LDDMK/3EYphaDUTkTyQRn234y6ry6GxnYG5ViByum6373a3cAjQaMB/w?=
 =?us-ascii?Q?LSqlYQo9//635TumnUJ0+kYGz824R087sLT2IsMgHc2piFCk+fHvWf46obHV?=
 =?us-ascii?Q?ud527dyCDaBq6x9pZYnbYMt9QJToddSuzx561/boy3L8slw3Kzq9tkztd/m9?=
 =?us-ascii?Q?Ph0DAdOLqbiFuyh91UgAZM+I1pVOtkNKuNdXGLoR71/OASXMmMu24riPGZQo?=
 =?us-ascii?Q?hMaIEMH9Fan0E7+D83k7yiVVlmBB3nRWnFgoT2bklO3YSZmZ5CFMEy11fXf8?=
 =?us-ascii?Q?miffauSW+t+Y4OZti9IEtfpmpGdzz/zUvUoXQb4wKVeVsBRr5oj69BNBOnwc?=
 =?us-ascii?Q?phT0wGeez/HzfuQG9OQBmAM6/E0NDp4WGkIHwK/cFe8DsPr+Qkk3qaoq8xMQ?=
 =?us-ascii?Q?mHHIkXGPhe7vm1QrEBcMBiJbNluEFkEm2KqX6d0qHbmNTz8+5Ys3LJCvBfdU?=
 =?us-ascii?Q?Sd7pVUoGpy+JC989N9ttck14ejk/woU77Bkn4Mbx0r38fE6l9jRKhSgVAZW6?=
 =?us-ascii?Q?bhyJtoZFDr0aGY9X44o0A6FHm9bFyasil4Iop2TNXHG6BfuuvasOdJ0T2kC8?=
 =?us-ascii?Q?ukAVj9kvMct1HBtrSX7tqTP5HiJ9uDMu6aWxfeNkWyspPMQ2WaesyFhGW2ZB?=
 =?us-ascii?Q?2YQcvd3wEayOnO22CKe2AlnMkFCmjPOjds4SlaaVTTKktxA2zeIYRRq+6nI3?=
 =?us-ascii?Q?yXz5yKCOPpN73J9CvDMXhW0HOPRIgjN7GfVqZ6SMmbQ3p2BjmugAods6OUEL?=
 =?us-ascii?Q?Q//o5lEbW9pQNwXRQn1qIDagYQl6F7DuON+c22d+3gnYvoVchv+z094e8rRt?=
 =?us-ascii?Q?KlL3FC4UtmKWbrCkQU2g6glk3piBIaDmBqZeSGiutYjUs/M1hJqJPnkPwqHI?=
 =?us-ascii?Q?28/7RWfzYuXkHoryLzEy9qp4wry3pYXoi2bP8YFQFWgPqHuJ2IOb0xgObmct?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A348D1C53E6944E8700E13E18AC9A96@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54013e20-8fb6-4315-f5d0-08da591b8872
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2022 15:33:21.4102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O+ycLldjxriBRl9aaKcOzLJdNXfGchmcLzM4TUEVjNChM04DQAvdwjCQxOWpkseHNpMbkNEqxD5cf1oXPrIK/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5361
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 02:50:36PM +0200, Andy Shevchenko wrote:
> On Tue, Jun 28, 2022 at 10:17 AM Colin Foster
> <colin.foster@in-advantage.com> wrote:
> >
> > Several ocelot-related modules are designed for MMIO / regmaps. As such=
,
> > they often use a combination of devm_platform_get_and_ioremap_resource =
and
> > devm_regmap_init_mmio.
> >
> > Operating in an MFD might be different, in that it could be memory mapp=
ed,
> > or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_=
REG
> > instead of IORESOURCE_MEM becomes necessary.
> >
> > When this happens, there's redundant logic that needs to be implemented=
 in
> > every driver. In order to avoid this redundancy, utilize a single funct=
ion
> > that, if the MFD scenario is enabled, will perform this fallback logic.
>=20
> > +       regs =3D devm_platform_get_and_ioremap_resource(pdev, index, &r=
es);
> > +
> > +       if (!res)
> > +               return ERR_PTR(-ENOENT);
>=20
> This needs a comment why the original error code from devm_ call above
> is not good here.

I think what is really needed is an _optional() variant of
ocelot_platform_init_regmap_from_resource(), which just returns NULL on
missing resource and doesn't ioremap anything. It can be easily open
coded, i.e. instead of creating devm_platform_get_and_ioremap_resource_opti=
onal(),
we could just call platform_get_resource() and devm_ioremap_resource()
individually.=
