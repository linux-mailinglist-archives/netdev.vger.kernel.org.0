Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABAA58B5F7
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiHFOMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiHFOMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:12:05 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F24212096;
        Sat,  6 Aug 2022 07:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=houmruaJVZ+Y2Lla0L7dAiGoCMIs0wS+iMVOdeo1WN4xK7oOMVbXbDIVsTfYNiQMahcMgNEWzhgXheRXQvn1HPCelcoNK2zKOeifXa3mqpNAK440n47/orl3RgRhMYkBvlWRBxxuXj/1x29XQD9VdVV4Roa+Tvigx+pnnQVSKLZfIEf+VDojlvA5oqlTioNeAFVCZik38ZvN27os1NEotoUUk5cymRdZ7B5G3ZWeuZgDgVCLjopDMukuAfKCykwV8NM2FP7ICsjBbNYK7t26FK+LdIWKNjHMPzlWtVv0bsb2FTmEFg2sXUeodexuQTVYfe6ZO/q3qrdmFkE04fk4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLB0ALklhWhudqqN7mFyWYKYjsDTi0BMiKKl+PmQ06Q=;
 b=QSXnPBhNEKY6v7lAw0MlYTZq6JaKPn890UqKz2ZpO+JHd2UihvGfBBjRy1LeNj+nOkQ4man/uOPFfTCBGmcZgAmjDGETJpGjb1jFb8o7hT6YF2HZ3ucXc2QlcpMv2kIh/T8Ob4KaakQWCQat4x1cBR7zf8ZSa7e7b8iw4a3zkJZGHfzVPuV7e3B+Ee+edWdmIN7CTcz6rFn5DX4Xl2jZUle2HWfLSaKBTLivr5hXrjRj6llndtjdjU+pP3QxiBhVNG2BJYbBgXmFU6dPT9ZBFz5DDlnQo7TT9sGfhP3Ay2K9U1IiSW9cVThTFSr6FN8AxNj2J+Yud6PKFEpDQW72QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLB0ALklhWhudqqN7mFyWYKYjsDTi0BMiKKl+PmQ06Q=;
 b=qdQpTMqOTA5jmMxgV7/7LkNZGzsF9MksVQMiwzQBpXSgeFNOUJMwyk0GnowNAVQu9DnaELdZigZNV5pljEoEmGKt0KSsc1R62s0AxkSEA2LxxvCf+7UoiYKhZKVm1CzsLn56PwNSxPwBFI12AivQj2tR64RcxUDYvVYrqaQrFa4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>
Subject: [RFC PATCH v3 net-next 10/10] net: dsa: make phylink-related OF properties mandatory on DSA and CPU ports
Date:   Sat,  6 Aug 2022 17:10:59 +0300
Message-Id: <20220806141059.2498226-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0802CA0016.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e09fc8d-a28a-4afb-a119-08da77b59b4b
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0JiILupFTMMqLYP5InGfaG23V3XsgbiEI2EMOW0F1t38g6GqXXBGxQHjqp51zvEv6kXWKuR/cYB+O2tqjkL7yPENGbykumhjFWnr3ulHXGtX0AvgTS9Og7Zpvwr40B7HAN+pHLVL2wnMzfJZwXaOGVFX+h7rt7S9plb12o71ppIjKiH1POOio/BLJA6LiJCl/u7oLKeooa8Ajk/gcXmip/qWnYHYGIiHVJhKfj/F2qkHqoi6JEdMF2q1rUYzXY5NWXeLJ+aVR8hmSRQOqIuY+5QaBGeR4VuQ4R3EKHQbxDxnjZCkCVbU63MqG/aECUIdk/pNZcJe91y5Y7vK/6JsQMX9uIEA7E+Ezi2V2b+9MkiHh87NHVRyytbT6gU28tzuaJvQuRbFxp4RVIzdoNzOtyxm9WsA95r0FgMVF6B3AK/YISjmBxAgIOq23yMfl+hAzQJpFUqen8C+KJaDNkCkR6uscMSV5+8bK2WzynrSktgy57C6CRpX21RLSVoHGA2R6ZkTTUoZNdu0PqOTzNG31FSptqhGWEahsGRh4tY5WpkoX3DavZZci6XIuRsdPmqXTg+0CwMwavOZdaBOcLNpuMwVeIssaB2tAkAWbT7EmZ7DsQxD5YUctrvS7aizFuMMSlmQ5YGF4rHaJiTIVk7X7s5TvgTtkN1a0S5RFhDrR3wvjAuT8gRVoKlq3UtLUknVnPhFvxn73KXFYNjPTBy4KFZgf8V9XLp5J93oMuNxlGGkK64Fgji0yGnWDy3RahaN43Wg1CRq12kGAFmSRcY2n6tkwSyOgH8pdLXx2b3nGuVJFfDDe5eTblobyxKBsFsm/Ki1cXnCDnccbGxSxCilhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(66574015)(5660300002)(30864003)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(52116002)(966005)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmJRMmlGaEtzUzNkVFRYSmxLbkQ2bzdVRGF5UkJFZVpob1pJKzYxMTEyQjhM?=
 =?utf-8?B?OTJWQndMSkk0RUxKdjJFTkdLUVBXbThoVDFDeU1aOURKNkxPRys3cm8yNWVm?=
 =?utf-8?B?UWFXSGk0UmIxSUMvdEorOTBMMlowZ0pKanNZREl2and0ejZ6cml6RWNySTda?=
 =?utf-8?B?UWdtUkZDOFRkMlJ1dW9CUEJ1NmZ5YS9ndkNlbHBmUjZIN013K2pKZDIybi8y?=
 =?utf-8?B?Q2JUZndja1c2RVVHY3dFL3ZWZnFPeXFBa2ZXTGtFQWVvYURkdThMUU9mTE10?=
 =?utf-8?B?cko5QmRvSTcvK0lCRkZuVE01NFVOdGR6VXhxT0Q3bEl2SzhHWS92S2lDUFFr?=
 =?utf-8?B?bjZ1YXcwUnljVE5FWEhNTUlCU0djNTJmaTJYZXFCcFJ3cjhZa24xRGRONEVT?=
 =?utf-8?B?Ujc2bHI2QmtzeDg0R1M1YzdpYkhBM29qNjByeHl3dTBicG13K3hTT1FOTG9z?=
 =?utf-8?B?NUgrRkttbU5DajBndjIzb1ZaV2Z2ek5kNVhmYWxMMUFTVDVuVlhKV05jR0ZR?=
 =?utf-8?B?RVNzZ1oyWVRkalN1b3FtQi9VbURXa0k4WFgva3RwSlhqMVI3WC8zMTVKdUtY?=
 =?utf-8?B?VUdiRXNFTGIxeFhpRUZiUGpWZmdXT1pYS0lxUUlLa3E0cUF2SFNDaVNXMlVn?=
 =?utf-8?B?YkgxYWRMV1lzd2RId1EwSG9rdXh6VDNDa25EUWZreUNFcnpXckFTLzJNRG4v?=
 =?utf-8?B?Wk94dFpBdmpqWGxXSXk4aUFYckVDUm1xckNJZGxIcWJQWXBTYk9mSSt6VzJG?=
 =?utf-8?B?b09pRWc3aGRBblJ6Rm9PTEtickhOSTZSeHA2aWkrSE11V2xkZ0hMS3VDajcv?=
 =?utf-8?B?VXpSVE9hNUF1UHhTMXN1R0ZPU0piUEJKVkcvUy9HNjVySmR4a090ZWtSYlg5?=
 =?utf-8?B?WWxTb1Uzcm1DczNjTnBIMUFVUzBEbUl4TUJyMCs1TVR1MVVyNm16V3pCOVlD?=
 =?utf-8?B?MmxTdHEwMWlHeXN1YjNsWHR6N3NyK2N4bXJTaXF1aThrTGpRWldDN0xBRE9m?=
 =?utf-8?B?ejZMQVhvWE5kWkNWUnB1US9MNXBCaXp5cSt3clBRQXhodGVOeWpFRVFIT1k0?=
 =?utf-8?B?dS90NTV1Vzl4cnVaWnhMRWhTYi85d1J5VTdqS2lWUWR2M3JORkw2QzJiSDEv?=
 =?utf-8?B?elZDd1pTY1lqZDdFNENtRHk1Nm0xaHNiNEFCTFZhSXpGN05GZWRNTEZBTDVP?=
 =?utf-8?B?VVlIWHJPRVdIR0trcGFxRDBKS2loWTFvSEFvUE1BQUpmUWtJeW1qRnlidjMv?=
 =?utf-8?B?OEkvOXpiYmN5SVh5VlBYVVdBK2phM0pXNTYyaGZwd2tNM0oxKzBOcm5nT0NT?=
 =?utf-8?B?UHo4ZGllcGJaTnRJQkxSdDJRZC82bFVYbC8xcnBrWXFyWFp3alZBbTNWb0V5?=
 =?utf-8?B?amlGaUVPVVhya0QrSkNNRmFHSE5DRFhmaVA3RnFZdCtML2hSR2RvTk1tUm9k?=
 =?utf-8?B?cFZBRkJwVEExekpTUkd6M0s1RVVqM0s4SkhBc1p0UmNnZDJ2MEc0NnRsc1pj?=
 =?utf-8?B?YWllS21XT2sxbEdGcGU2QkhlUDBDVGdacnoxZ1dmUnc0d0xBc3dyeFc5eVp0?=
 =?utf-8?B?d2Npd00vUng2MUVzRlRxWjAwNXh4SGwreWNSeFU1VWNIN2xHVHJaUXhhakxt?=
 =?utf-8?B?cXgwVm1LUjdMS0VJdkIyNjFMM0hKYTJIa3AweFN1RkJvbE1tZmpmUmszN2dQ?=
 =?utf-8?B?SUVyaHFhdDNsZFU0Y09DTEZiR3hGUzRiOXZBdXZ1MWtwSHBMM3ZYNXY3OTdF?=
 =?utf-8?B?dXd1S2lKOTFLTEtocjl4QjQvRTFNYnAvQVdlRDhBM2xsM2JXd3lIeFpiUVhC?=
 =?utf-8?B?TzRCays5QTNZcFEyQllZcFdBYlVUZzZSVmU1NnlNRGxsR21ONkxXV1dQeTF3?=
 =?utf-8?B?VnZ4REppczlJQnVPTmFjVE1OMGp4dWxuWWVqdzNIVk5obzE0VDdWb0lXbWc3?=
 =?utf-8?B?eHdKLzJzRElUUU50b0NRdHRiUGt2L0dwVm9KRzlTYkVFem1vaWZQN1JHY3VE?=
 =?utf-8?B?UWl4OEpHY2hidTgzS28rYjdmZEFYUENlS2ZBQlJ4ekl1ckdrQlpyc3FiRU1s?=
 =?utf-8?B?S240blYwWFJyU1hYT3ZFMklsRmJzaHdoUUZ5aHRadGNhYlJOSWJKYjdSSUtF?=
 =?utf-8?B?U1NJYUZKSGsxZTBJcm1TV0ozSDdoQTI2NkVjNEhOU0pxcUZSNzBhN2hiVkdV?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e09fc8d-a28a-4afb-a119-08da77b59b4b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:50.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9NknGy75kr84zidI1UfRmXBNTrcNFaoajjZwaNJo6R085fb8fDpVhpTLYU4b7FXsRWa153dOEXtd4N9PMOrsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Early DSA drivers were kind of simplistic in that they assumed a fairly
narrow hardware layout. User ports would have integrated PHYs at an
internal MDIO address that is derivable from the port number, and shared
(DSA and CPU) ports would have an MII-style (serial or parallel)
connection to another MAC. Phylib and then phylink were used to drive
the internal PHYs, and this needed little to no description through the
platform data structures. Bringing up the shared ports at the maximum
supported link speed was the responsibility of the drivers.

As a result of this, when these early drivers were converted from
platform data to the new DSA OF bindings, there was no link information
translated into the first DT bindings.

https://lore.kernel.org/all/YtXFtTsf++AeDm1l@lunn.ch/

Later, phylink was adopted for shared ports as well, and today we have a
workaround in place, introduced by commit a20f997010c4 ("net: dsa: Don't
instantiate phylink for CPU/DSA ports unless needed"). There, DSA checks
for the presence of phy-handle/fixed-link/managed OF properties, and if
missing, phylink registration would be skipped. This is because phylink
is optional for some drivers (the shared ports already work without it),
but the process of starting to register a port with phylink is
irreversible: if phylink_create() fails to find the fwnode properties it
needs, it bails out and it leaves the ports inoperational (because
phylink expects ports to be initially down, so DSA necessarily takes
them down, and doesn't know how to put them back up again).

DSA being a common framework, new drivers opt into this workaround
willy-nilly, but the ideal behavior from the DSA core's side would have
been to not interfere with phylink's process of failing at all. This
isn't possible because of regression concerns with pre-phylink DT blobs,
but at least DSA should put a stop to the proliferation of more of such
cases that rely on the workaround to skip phylink registration, and
sanitize the environment that new drivers work in.

To that end, create a list of compatible strings for which the
workaround is preserved, and don't apply the workaround for any drivers
outside that list (this includes new drivers).

In some cases, we make the assumption that even existing drivers don't
rely on DSA's workaround, and we do this by looking at the device trees
in which they appear. We can't fully know what is the situation with
downstream DT blobs, but we can guess the overall trend by studying the
DT blobs that were submitted upstream. If there are upstream blobs that
have lacking descriptions, we take it as very likely that there are many
more downstream blobs that do so too. If all upstream blobs have
complete descriptions, we take that as a hint that the driver is a
candidate for strict validation (considering that most bindings are
copy-pasted). If there are no upstream DT blobs, we take the
conservative route of skipping validation, unless the driver maintainer
instructs us otherwise.

The driver situation is as follows:

ar9331
~~~~~~

    compatible strings:
    - qca,ar9331-switch

    1 occurrence in mainline device trees, part of SoC dtsi
    (arch/mips/boot/dts/qca/ar9331.dtsi), description is not problematic.

    Verdict: opt into validation.

b53
~~~

    compatible strings:
    - brcm,bcm5325
    - brcm,bcm53115
    - brcm,bcm53125
    - brcm,bcm53128
    - brcm,bcm5365
    - brcm,bcm5389
    - brcm,bcm5395
    - brcm,bcm5397
    - brcm,bcm5398

    - brcm,bcm53010-srab
    - brcm,bcm53011-srab
    - brcm,bcm53012-srab
    - brcm,bcm53018-srab
    - brcm,bcm53019-srab
    - brcm,bcm5301x-srab
    - brcm,bcm11360-srab
    - brcm,bcm58522-srab
    - brcm,bcm58525-srab
    - brcm,bcm58535-srab
    - brcm,bcm58622-srab
    - brcm,bcm58623-srab
    - brcm,bcm58625-srab
    - brcm,bcm88312-srab
    - brcm,cygnus-srab
    - brcm,nsp-srab
    - brcm,omega-srab

    - brcm,bcm3384-switch
    - brcm,bcm6328-switch
    - brcm,bcm6368-switch
    - brcm,bcm63xx-switch

    I've found at least these mainline DT blobs with problems:

    arch/arm/boot/dts/bcm47094-linksys-panamera.dts
    - lacks phy-mode
    arch/arm/boot/dts/bcm47189-tenda-ac9.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
    arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
    arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
    arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
    arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
    arch/arm/boot/dts/bcm953012er.dts
    arch/arm/boot/dts/bcm4708-netgear-r6250.dts
    arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
    arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
    arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm53016-meraki-mr32.dts
    - lacks phy-mode

    Verdict: opt all switches out of strict validation.

bcm_sf2
~~~~~~~

    compatible strings:
    - brcm,bcm4908-switch
    - brcm,bcm7445-switch-v4.0
    - brcm,bcm7278-switch-v4.0
    - brcm,bcm7278-switch-v4.8

    A single occurrence in mainline
    (arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi), part of a SoC
    dtsi, valid description. Florian Fainelli explains that most of the
    bcm_sf2 device trees lack a full description for the internal IMP
    ports.

    Verdict: opt the BCM4908 into strict validation, and opt out the
    rest. Note that even though BCM4908 has strict DT bindings, it still
    does not register with phylink on the IMP port due to it implementing
    ->adjust_link().

hellcreek
~~~~~~~~~

    compatible strings:
    - hirschmann,hellcreek-de1soc-r1

    No occurrence in mainline device trees. Kurt Kanzenbach confirms
    that the downstream device tree lacks phy-mode and fixed link, and
    needs work.

    Verdict: opt out of validation.

lan9303
~~~~~~~

    compatible strings:
    - smsc,lan9303-mdio
    - smsc,lan9303-i2c

    1 occurrence in mainline device trees:
    arch/arm/boot/dts/imx53-kp-hsc.dts
    - no phy-mode, no fixed-link

    Verdict: opt out of validation.

lantiq_gswip
~~~~~~~~~~~~

    compatible strings:
    - lantiq,xrx200-gswip
    - lantiq,xrx300-gswip
    - lantiq,xrx330-gswip

    No occurrences in mainline device trees. Martin Blumenstingl
    confirms that the downstream OpenWrt device trees lack a proper
    fixed-link and need work, and that the incomplete description can
    even be seen in the example from
    Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt.

    Verdict: opt out of validation.

microchip ksz
~~~~~~~~~~~~~

    compatible strings:
    - microchip,ksz8765
    - microchip,ksz8794
    - microchip,ksz8795
    - microchip,ksz8863
    - microchip,ksz8873
    - microchip,ksz9477
    - microchip,ksz9897
    - microchip,ksz9893
    - microchip,ksz9563
    - microchip,ksz8563
    - microchip,ksz9567
    - microchip,lan9370
    - microchip,lan9371
    - microchip,lan9372
    - microchip,lan9373
    - microchip,lan9374

    5 occurrences in mainline device trees, all descriptions are valid.
    But we had a snafu for the ksz8795 and ksz9477 drivers where the
    phy-mode property would be expected to be located directly under the
    'switch' node rather than under a port OF node. It was fixed by
    commit edecfa98f602 ("net: dsa: microchip: look for phy-mode in port
    nodes"). The driver still has compatibility with the old DT blobs.
    The lan937x support was added later than the above snafu was fixed,
    and even though it has support for the broken DT blobs by virtue of
    sharing a common probing function, I'll take it that its DT blobs
    are correct.

    Verdict: opt lan937x into validation, and the others out.

mt7530
~~~~~~

    compatible strings
    - mediatek,mt7621
    - mediatek,mt7530
    - mediatek,mt7531

    Multiple occurrences in mainline device trees, one is part of an SoC
    dtsi (arch/mips/boot/dts/ralink/mt7621.dtsi), all descriptions are fine.

    Verdict: opt into strict validation.

mv88e6060
~~~~~~~~~

    compatible string:
    - marvell,mv88e6060

    no occurrences in mainline, nobody knows anybody who uses it.

    Verdict: opt out of strict validation.

mv88e6xxx
~~~~~~~~~

    compatible strings:
    - marvell,mv88e6085
    - marvell,mv88e6190
    - marvell,mv88e6250

    Device trees that have incomplete descriptions of CPU or DSA ports:
    arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi
    - lacks phy-mode
    arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-spb4.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-cfu1.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
    - lacks phy-mode on CPU port, fixed-link on DSA ports
    arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
    - lacks phy-mode on CPU port
    arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
    - lacks phy-mode
    arch/arm/boot/dts/vf610-zii-scu4-aib.dts
    - lacks fixed-link on xgmii DSA ports and/or in-band-status on
      2500base-x DSA ports, and phy-mode on CPU port
    arch/arm/boot/dts/imx6qdl-gw5904.dtsi
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-dir665.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-rd88f6281.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/orion5x-netgear-wnr854t.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/armada-388-clearfog.dts
    - lacks phy-mode
    arch/arm/boot/dts/armada-xp-linksys-mamba.dts
    - lacks phy-mode
    arch/arm/boot/dts/armada-385-linksys.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/imx6q-b450v3.dts
    arch/arm/boot/dts/imx6q-b850v3.dts
    - has a phy-handle but not a phy-mode?
    arch/arm/boot/dts/armada-370-rd.dts
    - lacks phy-mode
    arch/arm/boot/dts/kirkwood-linksys-viper.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx51-zii-rdu1.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx51-zii-scu2-mezz.dts
    - lacks phy-mode
    arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi
    - lacks phy-mode
    arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts
    - lacks phy-mode and fixed-link

    Verdict: opt out of validation.

ocelot
~~~~~~

    compatible strings:
    - mscc,vsc9953-switch
    - felix (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi) is a PCI
      device, has no compatible string

    2 occurrences in mainline, both are part of SoC dtsi and complete.

    Verdict: opt into strict validation.

qca8k
~~~~~

    compatible strings:
    - qca,qca8327
    - qca,qca8328
    - qca,qca8334
    - qca,qca8337

    5 occurrences in mainline device trees, none of the descriptions are
    problematic.

    Verdict: opt into validation.

realtek
~~~~~~~

    compatible strings:
    - realtek,rtl8366rb
    - realtek,rtl8365mb

    2 occurrences in mainline, both descriptions are fine, additionally
    rtl8365mb.c has a comment "The device tree firmware should also
    specify the link partner of the extension port - either via a
    fixed-link or other phy-handle."

    Verdict: opt into validation.

rzn1_a5psw
~~~~~~~~~~

    compatible strings:
    - renesas,rzn1-a5psw

    One single occurrence, part of SoC dtsi
    (arch/arm/boot/dts/r9a06g032.dtsi), description is fine.

    Verdict: opt into validation.

sja1105
~~~~~~~

    Driver already validates its port OF nodes in
    sja1105_parse_ports_node().

    Verdict: opt into validation.

vsc73xx
~~~~~~~

    compatible strings:
    - vitesse,vsc7385
    - vitesse,vsc7388
    - vitesse,vsc7395
    - vitesse,vsc7398

    2 occurrences in mainline device trees, both descriptions are fine.

    Verdict: opt into validation.

xrs700x
~~~~~~~

    compatible strings:
    - arrow,xrs7003e
    - arrow,xrs7003f
    - arrow,xrs7004e
    - arrow,xrs7004f

    no occurrences in mainline, we don't know.

    Verdict: opt out of strict validation.

Because there is a pattern where newly added switches reuse existing
drivers more often than introducing new ones, I've opted for deciding
who gets to opt into the workaround based on an OF compatible match
table in the DSA core. The alternative would have been to add another
boolean property to struct dsa_switch, like configure_vlan_while_not_filtering.
But this avoids situations where sometimes driver maintainers obfuscate
what goes on by sharing a common probing function, and therefore making
new switches inherit old quirks.

Side note, we also warn about missing properties for drivers that rely
on the workaround. This isn't an indication that we'll break
compatibility with those DT blobs any time soon, but is rather done to
raise awareness about the change, for future DT blob authors.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Acked-by: Alvin Šipraga <alsi@bang-olufsen.dk> # realtek
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: print warnings even for drivers skipping phylink registration,
        move code placement
v2->v3: reword commit message

 net/dsa/port.c | 175 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 5 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4b6139bff217..c07a7c69d5e0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1650,22 +1650,187 @@ static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
+/* During the initial DSA driver migration to OF, port nodes were sometimes
+ * added to device trees with no indication of how they should operate from a
+ * link management perspective (phy-handle, fixed-link, etc). Additionally, the
+ * phy-mode may be absent. The interpretation of these port OF nodes depends on
+ * their type.
+ *
+ * User ports with no phy-handle or fixed-link are expected to connect to an
+ * internal PHY located on the ds->slave_mii_bus at an MDIO address equal to
+ * the port number. This description is still actively supported.
+ *
+ * Shared (CPU and DSA) ports with no phy-handle or fixed-link are expected to
+ * operate at the maximum speed that their phy-mode is capable of. If the
+ * phy-mode is absent, they are expected to operate using the phy-mode
+ * supported by the port that gives the highest link speed. It is unspecified
+ * if the port should use flow control or not, half duplex or full duplex, or
+ * if the phy-mode is a SERDES link, whether in-band autoneg is expected to be
+ * enabled or not.
+ *
+ * In the latter case of shared ports, omitting the link management description
+ * from the firmware node is deprecated and strongly discouraged. DSA uses
+ * phylink, which rejects the firmware nodes of these ports for lacking
+ * required properties.
+ *
+ * For switches in this table, DSA will skip enforcing validation and will
+ * later omit registering a phylink instance for the shared ports, if they lack
+ * a fixed-link, a phy-handle, or a managed = "in-band-status" property.
+ * It becomes the responsibility of the driver to ensure that these ports
+ * operate at the maximum speed (whatever this means) and will interoperate
+ * with the DSA master or other cascade port, since phylink methods will not be
+ * invoked for them.
+ *
+ * If you are considering expanding this table for newly introduced switches,
+ * think again. It is OK to remove switches from this table if there aren't DT
+ * blobs in circulation which rely on defaulting the shared ports.
+ */
+static const char * const dsa_switches_dont_enforce_validation[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_XRS700X)
+	"arrow,xrs7003e",
+	"arrow,xrs7003f",
+	"arrow,xrs7004e",
+	"arrow,xrs7004f",
+#endif
+#if IS_ENABLED(CONFIG_B53)
+	"brcm,bcm5325",
+	"brcm,bcm53115",
+	"brcm,bcm53125",
+	"brcm,bcm53128",
+	"brcm,bcm5365",
+	"brcm,bcm5389",
+	"brcm,bcm5395",
+	"brcm,bcm5397",
+	"brcm,bcm5398",
+	"brcm,bcm53010-srab",
+	"brcm,bcm53011-srab",
+	"brcm,bcm53012-srab",
+	"brcm,bcm53018-srab",
+	"brcm,bcm53019-srab",
+	"brcm,bcm5301x-srab",
+	"brcm,bcm11360-srab",
+	"brcm,bcm58522-srab",
+	"brcm,bcm58525-srab",
+	"brcm,bcm58535-srab",
+	"brcm,bcm58622-srab",
+	"brcm,bcm58623-srab",
+	"brcm,bcm58625-srab",
+	"brcm,bcm88312-srab",
+	"brcm,cygnus-srab",
+	"brcm,nsp-srab",
+	"brcm,omega-srab",
+	"brcm,bcm3384-switch",
+	"brcm,bcm6328-switch",
+	"brcm,bcm6368-switch",
+	"brcm,bcm63xx-switch",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_BCM_SF2)
+	"brcm,bcm7445-switch-v4.0",
+	"brcm,bcm7278-switch-v4.0",
+	"brcm,bcm7278-switch-v4.8",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK)
+	"hirschmann,hellcreek-de1soc-r1",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_LANTIQ_GSWIP)
+	"lantiq,xrx200-gswip",
+	"lantiq,xrx300-gswip",
+	"lantiq,xrx330-gswip",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MV88E6060)
+	"marvell,mv88e6060",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MV88E6XXX)
+	"marvell,mv88e6085",
+	"marvell,mv88e6190",
+	"marvell,mv88e6250",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)
+	"microchip,ksz8765",
+	"microchip,ksz8794",
+	"microchip,ksz8795",
+	"microchip,ksz8863",
+	"microchip,ksz8873",
+	"microchip,ksz9477",
+	"microchip,ksz9897",
+	"microchip,ksz9893",
+	"microchip,ksz9563",
+	"microchip,ksz8563",
+	"microchip,ksz9567",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_MDIO)
+	"smsc,lan9303-mdio",
+#endif
+#if IS_ENABLED(CONFIG_NET_DSA_SMSC_LAN9303_I2C)
+	"smsc,lan9303-i2c",
+#endif
+	NULL,
+};
+
+static void dsa_shared_port_validate_of(struct dsa_port *dp,
+					bool *missing_phy_mode,
+					bool *missing_link_description)
+{
+	struct device_node *dn = dp->dn, *phy_np;
+	struct dsa_switch *ds = dp->ds;
+	phy_interface_t mode;
+
+	*missing_phy_mode = false;
+	*missing_link_description = false;
+
+	if (of_get_phy_mode(dn, &mode)) {
+		*missing_phy_mode = true;
+		dev_err(ds->dev,
+			"OF node %pOF of %s port %d lacks the required \"phy-mode\" property\n",
+			dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+	}
+
+	/* Note: of_phy_is_fixed_link() also returns true for
+	 * managed = "in-band-status"
+	 */
+	if (of_phy_is_fixed_link(dn))
+		return;
+
+	phy_np = of_parse_phandle(dn, "phy-handle", 0);
+	if (phy_np) {
+		of_node_put(phy_np);
+		return;
+	}
+
+	*missing_link_description = true;
+
+	dev_err(ds->dev,
+		"OF node %pOF of %s port %d lacks the required \"phy-handle\", \"fixed-link\" or \"managed\" properties\n",
+		dn, dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+}
+
 int dsa_shared_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	struct device_node *phy_np;
+	bool missing_link_description;
+	bool missing_phy_mode;
 	int port = dp->index;
 
+	dsa_shared_port_validate_of(dp, &missing_phy_mode,
+				    &missing_link_description);
+
+	if ((missing_phy_mode || missing_link_description) &&
+	    !of_device_compatible_match(ds->dev->of_node,
+					dsa_switches_dont_enforce_validation))
+		return -EINVAL;
+
 	if (!ds->ops->adjust_link) {
-		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
+		if (missing_link_description) {
+			dev_warn(ds->dev,
+				 "Skipping phylink registration for %s port %d\n",
+				 dsa_port_is_cpu(dp) ? "CPU" : "DSA", dp->index);
+		} else {
 			if (ds->ops->phylink_mac_link_down)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
-			of_node_put(phy_np);
+
 			return dsa_shared_port_phylink_register(dp);
 		}
-		of_node_put(phy_np);
 		return 0;
 	}
 
-- 
2.34.1

