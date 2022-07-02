Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E345564164
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiGBQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiGBQRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:17:41 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2129.outbound.protection.outlook.com [40.107.100.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2CBF5BE;
        Sat,  2 Jul 2022 09:17:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ex7RhQhYaBbD1r9GGWlFtcsUa1/XuQiNzMh2fmAHnIMNSbi3gBOTu50EoWpu8F9SVxbRri6F5AFlzZf/40jMboPdxPpG1tPo5s/1rv5BbdAFPDLdEa8fV3ZqYcAuCw4Oln1iIkcxv71gOogn904Sbx4CMAwrtr0X+1QjgtR0dAr0Xlbk4opRZOYAbTseN4t7M/Y6WiSiLLvY6qCo0a2mj9nvwf5NfIKz6tsFIIzGALmhDGWxEfPVh+3ouIdv7LEbryYyfYjiO6HpgLbhcCqr3Zgc4xO2yXLLyxygynfB2t6gQxQgv7B2YyXoAZVivpfwBrxB2SV9u8XALl8M2ZXVoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIhyJZhl84avOBIIMSV+fsCO1aOj1pQtNmH4FseARIo=;
 b=CGbPeVRklWKnl5k6XF/QHAg5L+Xxv0DqlIi9oU3dt9iRORKirgaWYUrb8ZhkLDKb3J5K/m2pJI88aZ37+t29EqTQMKFp45DZSTCUPlOgn/JfcLxS9+xW1kaPRR9wDbQY3es2XUHpgJ8Ia/K/fuknbDTp1lpwIaNsaV4V3l8ISfWUtelJcrF+qpEpESPCVoEQbYeVXDbsJy0IfCevxANQ4fJDsYPlpxPryY9iyMyppl++R8epUqAz5+2CkmkY9DwEIGiJGawqI95yDjvSaOVsSagfrFcMPqAqnoH8YcaGPXZJwtjQdkMFbc14shTRCDA4oc7hjp6z/46IexygbokiGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIhyJZhl84avOBIIMSV+fsCO1aOj1pQtNmH4FseARIo=;
 b=q2BDD7gU9ZMcCL3jzqBJ0lpwyCyhxQewL4xG+c2R5VhdR0MlphBCm3QjZGpgJVcHySrOrQpnQZExAhv7Fmlttr4+dvcLJi9YEPMRh0kBZUWHTPp/Bnsh7XRIJ8rA/h11zl2wESEGjXw6YqomHNSc27j0/sfwJ48EsiYZvMiZ/io=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN8PR10MB3716.namprd10.prod.outlook.com
 (2603:10b6:408:b2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Sat, 2 Jul
 2022 16:17:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Sat, 2 Jul 2022
 16:17:35 +0000
Date:   Sat, 2 Jul 2022 09:17:29 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
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
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <20220702161729.GA4028148@euler>
References: <20220628195654.GE855398@euler>
 <20220629175305.4pugpbmf5ezeemx3@skbuf>
 <20220629203905.GA932353@euler>
 <20220629230805.klgcklovkkunn5cm@skbuf>
 <20220629235435.GA992734@euler>
 <20220630131155.hs7jzehiyw7tpf5f@skbuf>
 <20220630200951.GB2152027@euler>
 <20220701162126.wbembm47snbggxwv@skbuf>
 <20220701171831.GA3327062@euler>
 <20220702124205.53fqq65b24im2ilv@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220702124205.53fqq65b24im2ilv@skbuf>
X-ClientProxiedBy: MW4PR04CA0318.namprd04.prod.outlook.com
 (2603:10b6:303:82::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bc4d3b8-865c-4b20-7f6c-08da5c466000
X-MS-TrafficTypeDiagnostic: BN8PR10MB3716:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beUFL3rltP1kkDuXm86vrgvR8HBw0T1jjB3XehWl5mblBQfU1iMpfeBo0KCbky5wSZK0iYyKKrgGuL1OpVdNXoVX3/0vahJizdnDm0HRMSKmQh8HwljKYsFbmlz+m747j/dK6B7S0TAqenaUhPi0tAYmTEe4D+ffgly+udKABQH5gx3IOjAbt8ApC2/XnGTY9UFOzwRTal98McKe06NQCzoKFqW9y2F+fcGOKJO1C1sUIGCvhpe30VVpdna5muQX+UHM8ZiXKSHU1ucdnW2NYBsq56Oq3rMQLAjC5sPre0OPl81yJSK4WFFs1ylbxpriIr64kKfvmP4SQFv46xebDX6QOErPx9/LARq1M1OpO2YhQxFFndpkaEhuFXMtLg6Yrv1zMJdWTj2x417e1LbJ6CrScv3gQb+4eF8u+mJHactcG3Pe8Lxl/w511jKG4xPG8TrVWopnC6Kd9Z4xGvbaIzb2rW/80lgMXnMY6XMj8Q4ot1uoZC5HOyDT9raZPG3nd5HxwEeWjmtBz1jUNnRpD4/YGShNrMVFr/i4QQmqmdeELg4avPAYKUHaXfBTiRKoSfvVh9UeSKkMUPjpoMc8naY0T6+HuLx3BdcbHtJK3ve97tbUa/qzIojH1DwSLP1Pm+1y+nf2KbwJPBZ8AzP8HmGP7zpUO6D2pxHHknMW3rTMl0semqUM5gAR258hm6cCDOxu/fEEcINSe/JpJh3rRwJc3r0bx8Q8CKFdWZYvnAxff/nbni2fGU5sDrXkEyUIN2LBobQ1sXNCIt7OzSmF1o5AWxfIah5aQtp/oZyQrBE8ew3HJ04i4h2ZCZPR7vu4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(39830400003)(136003)(376002)(346002)(396003)(33656002)(54906003)(316002)(6916009)(86362001)(2906002)(7416002)(44832011)(8936002)(5660300002)(33716001)(66476007)(8676002)(38100700002)(38350700002)(66946007)(4326008)(66556008)(26005)(6506007)(41300700001)(6666004)(186003)(478600001)(9686003)(6486002)(52116002)(1076003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BFUbPdGnPni8QNKZ3UO66L4tOODxkgs3bcogzANoYK8lDNhNpFRoufbhgNEA?=
 =?us-ascii?Q?SLkRCjOVgDepXN0PGFRIK56ovJPhloC9tQOrUXppnuI4j25ZdxdswOxfMLZY?=
 =?us-ascii?Q?uAZrZFo2q1A000KKnzzbOCEsaqbHaGxzGAXUazc2A4DKk9sK5Ttm0Sy5vpg7?=
 =?us-ascii?Q?oGyzXqVuXw9rbi5KocaDtIabBAQTwLRBh0puyrbeWZVNBB70v5Ye0jWC4wUY?=
 =?us-ascii?Q?gb2YrW8ZMEJBgAH8LgzQjanb0pnpHu5Muh6F9jrXpkFN3/rDNnF1lHqsSrtA?=
 =?us-ascii?Q?SdKaiqUVMa+/niZlfqH1JQ/Cjw3EM+fZ/dJt72u0K0p480dK7fKBHl8/ZMlF?=
 =?us-ascii?Q?NSErQcZeZwITdn4ncZ8gk+KI4ozusogiqyz3LbsFTuGrr+cQIiT3Ewjny97u?=
 =?us-ascii?Q?PEvgxtDAFn2t0IJbHCj6BieXoVdqZ0boS9uGXI1HEgV/OiJJVF1gy1Mmbj3P?=
 =?us-ascii?Q?aIDcBWguH9YId78nNUy4URluUwBMtpoN3YHEr/a0hxvfZvbM53PPVKSD/+t/?=
 =?us-ascii?Q?TjyzUzFxH4qOh9whL9Qfalnqu39Y9IwhtJrOdQ1VJLEqwnEz02bjJaXlyxq6?=
 =?us-ascii?Q?bw7wxNVXkxmjh13RiHdNAs5ccGdh397OUcqgovbyFqzob/8yWByD01AkuRJM?=
 =?us-ascii?Q?ZMkxTsiH3TRYQyaog3ZEKXJAZmEi96in+5HxjU5t2qhfxWhRfUElBvjxGJSj?=
 =?us-ascii?Q?2Y+0JySq63uaELu/5t1AxWYjfbRU6EVLqvrH5xTYrwYEiAmQ+R3NCBYUw9rk?=
 =?us-ascii?Q?Dx5Rk3WQmng+RhOBPpHG/J393qQcW/muIoQDvjCvtQP2/oCi0WinjxanvEn/?=
 =?us-ascii?Q?3qpVPLXrx92J6QVompdZ+LJsdKqC3ZM0TRLr08zWeyLSAZ5DAshyeBymOCHU?=
 =?us-ascii?Q?Oyhlozbkf2TOp0+sn2Fx7F/wCQx2vuJiy/SP4StJ+lH6qTyJI3J1RNW3bYuI?=
 =?us-ascii?Q?JwrJXdxmcWU1qKy6GTlAIi9JMOfj3ko882WkKiGT+KrkqoTYr2EcTPEYWWDC?=
 =?us-ascii?Q?ZNdpg0ji93CjNP2od8/SA6etzft2q2GjWUqWxl3MvMVLZvSXGpf1kYorP82X?=
 =?us-ascii?Q?rvfEeUg+U2FqxfgDzXIX+helFAkFsu+hklFvXK+phbU/qMPC02CdXBAVI4rQ?=
 =?us-ascii?Q?d+RYgbvsInFqt5Qr8V/LJQQtRnguyORPvSAqTNzWLVtQjGfN4LnpZM2begMD?=
 =?us-ascii?Q?IxGLrLUb9rqQzj7L+OyRyXLxu6tfatXp16fY5DrtB+iaKa71EidkkhiKWpAc?=
 =?us-ascii?Q?KXYOgyJpAw4C9+4oq3W91wHxTVwNXIY+J1FNm3cs1svXHhbXGdfjZxmJYEWQ?=
 =?us-ascii?Q?AK4c4CYgbjwnYqJoCFwbX/Cb3DrluvW9RZrpsHlo8LbonCCAjkrvoW+eu/Lw?=
 =?us-ascii?Q?41KTRCA7CSRirab9kiwYcjpMuQ4I0j1KSzqC4xTCqYdMtaOtOdG+ySs6S42c?=
 =?us-ascii?Q?oqJZM1aoZeviDkLFcTjrxst8vjZyUUZpNmsNTLsfCmCyVXvn3oUmX4njtBBw?=
 =?us-ascii?Q?/6Cv8ch6pw+Q/gV46j3/7b7RPwhwnZFRaf3Q/lso4JF42EE/WN47iyU9xG6g?=
 =?us-ascii?Q?hmKPX+cT2CZSUAnRlXAS6HKvU9O4tR3+lxmrnHu02t+7TzOepIMFrMUNcgd/?=
 =?us-ascii?Q?Ub4imUHCsjGsdIGnUtXWaoc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc4d3b8-865c-4b20-7f6c-08da5c466000
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 16:17:35.6801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDt8OcrHpzCUUju4upkVpezSJvgifwTnG88LMyDJ73aHGFaLNFsjYVUtdnhWi1sS7JMQgCUHKFFB/qMBGNZI1BKj9rpxlB75mzdx52s2Du8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3716
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 12:42:06PM +0000, Vladimir Oltean wrote:
> On Fri, Jul 01, 2022 at 10:18:31AM -0700, Colin Foster wrote:
> > While I have your ear: do I need to check for dev->parent == NULL before
> > calling dev_get_regmap? I see find_dr will call
> > (dev->parent)->devres_head... but specifically "does every device have a
> > valid parent?"
> 
> While the technical answer is "no", the practical answer is "pretty much".
> Platform devices sit at least on the "platform" bus created in drivers/base/platform.c,
> and they are reparented to the "platform_bus" struct device named "platform"
> within platform_device_add(), if they don't have a parent.
> 
> Additionally, for MMIO-controlled platform devices in Ocelot, these have
> as parent a platform device probed by the drivers/bus/simple-pm-bus.c
> driver on the "ahb@70000000" simple-bus OF node. That simple-bus
> platform device has as parent the "platform_bus" device mentioned above.
> 
> So it's a pretty long way to the top in the device hierarchy, I wouldn't
> concern myself too much with checking for NULL, unless you intend to
> call dev_get_regmap() on a parent's parent's parent, or things like that.

Thanks for the info. I have the NULL check in there, since I followed
the code and didn't see anything in device initialization that always
initializes parent. Maybe a default initializer would be
dev->parent = dev;

> 
> > > > }
> > > > 
> > > > So now there's no need for #if (CONFIG_MFD_OCELOT) - it can just remain
> > > > an inline helper function. And so long as ocelot_core_init does this:
> > > > 
> > > > static void ocelot_core_try_add_regmap(struct device *dev,
> > > >                                        const struct resource *res)
> > > > {
> > > >         if (!dev_get_regmap(dev, res->name)) {
> > > >                 ocelot_spi_init_regmap(dev, res);
> > > >         }
> > > > }
> > > > 
> > > > static void ocelot_core_try_add_regmaps(struct device *dev,
> > > >                                         const struct mfd_cell *cell)
> > > > {
> > > >         int i;
> > > > 
> > > >         for (i = 0; i < cell->num_resources; i++) {
> > > >                 ocelot_core_try_add_regmap(dev, &cell->resources[i]);
> > > >         }
> > > > }
> > > > 
> > > > int ocelot_core_init(struct device *dev)
> > > > {
> > > >         int i, ndevs;
> > > > 
> > > >         ndevs = ARRAY_SIZE(vsc7512_devs);
> > > > 
> > > >         for (i = 0; i < ndevs; i++)
> > > >                 ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
> > > 
> > > Dumb question, why just "try"?
> > 
> > Because of this conditional:
> > > >         if (!dev_get_regmap(dev, res->name)) {
> > Don't add it if it is already there.
> 
> Hmm. So that's because you add regmaps iterating by the resource table
> of each device. What if you keep a single resource table for regmap
> creation purposes, and the device resource tables as separate?

That would work - though it seems like it might be adding extra info
that isn't necessary. I'll take a look.

> 
> > This might get interesting... The soc uses the HSIO regmap by way of
> > syscon. Among other things, drivers/phy/mscc/phy-ocelot-serdes.c. If
> > dev->parent has all the regmaps, what role does syscon play?
> > 
> > But that's a problem for another day...
> 
> Interesting question. I think part of the reason why syscon exists is to
> not have OF nodes with overlapping address regions. In that sense, its
> need does not go away here - I expect the layout of OF nodes beneath the
> ocelot SPI device to be the same as their AHB variants. But in terms of
> driver implementation, I don't know. Even if the OF nodes for your MFD
> functions will contain all the regs that their AHB variants do, I'd
> personally still be inclined to also hardcode those as resources in the
> ocelot mfd parent driver and use those - case in which the OF regs will
> more or less exist just as a formality. Maybe because the HSIO syscon is
> already compatible with "simple-mfd", devices beneath it should just
> probe. I haven't studied how syscon_node_to_regmap() behaves when the
> syscon itself is probed as a MFD function. If that "just works", then
> the phy-ocelot-serdes.c driver might not need to be modified.

That'd be nice! When I looked into it a few months ago I came to the
conclusion that I'd need to implement "mscc,ocelot-hsio" but maybe
there's something I missed.
