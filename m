Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37014613350
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiJaKLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJaKLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:11:11 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D359D7D;
        Mon, 31 Oct 2022 03:11:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DalvXIfppGsCkRirEKbLGihgxtPfo4B/CI+k1+v+Hja/QhyUlMdkal3lzZEf0hqviUYxYcGZBwpenB9N187E0re3fVOoFiol98cmaPvlv9MnIWAOBwlMe4FqWuTGluVJF0OVLrHBuC78gguohvSZrzmT+ObRsfvyCPU7i33ghA4cKySXuwyl/XjITPqOL17nDZbbrkPl3mOHvDkbLXC+bCvqhTDrARDBnM9QdY4cL6LxDzsY7Qt2kt+ZvSkMXQzIu0Vm0xsQROSqlmx6hPa6Q4tFC3Yx8E4xZEe16kQqPt3h/oQs/BDEKQl9mJbrQtFWDdlLPL81kUc9X/D+R+9mXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIQ3gPRjrAFlgRmfd9pee8dI4y08EChZdBVtzk2TQOs=;
 b=UHQohnOJTSieNO3YISdu+jeZO9vQXqXeWaujn1R1wUBG6rpnmi8QpzS/Cn6m7L7cN63tr82XqDFW3EvD4IYr4PolIvotudE+hIqbeGiOYRERdxdkLIPKf1wF5pMp/iS9GlOQ6bhsiEPkLzOlc86l5nyb4Q/a6OppMXWGDWmgSe5DexajTkJG3WQLSLvudjjAHeRG5WgwEXRa0AhIY+tabw/0CkXt1NaHfp9Jf/haqyQ+nuKeRyOS02qCNFxLr5kgayNBbFiQ7Nk+ps5d+yYcatnUt287U0m2ipgu3ORRrKPYXPO3jxdS8FehUUO+8N4exkecyVolWSYNdR9OSC08OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIQ3gPRjrAFlgRmfd9pee8dI4y08EChZdBVtzk2TQOs=;
 b=LBuJLalUjX8ZF/M96ZvygyyMNwp6Z4ls93fxjO6rNNNY2i+L6ZzpmuqK8PQyIBFj+EqKHghhwA1aJdl3XK3J/UPBZEVb5+gbxPShxgv6XMrxPOzGxD2O1cTCPsymw0+9JXXG6tuRUfjCOlYLxvuJJrMfXj+KLuZuGE9oCeLvqbpw/VXp7LDyKSGQp/bTheG6ezN/cH02yRMVeVRn83VFsBiV0oFduBZaKOUE4buN/T1Yd3q0Blc5/FXwoMzB1AdBzsRAGLZoFUvFbwuHfPAMJfjlRO840P5ASKq7biwhaUI+v+Sm3+KLXvMhr1GwhNeZLQv6YjfqQsef/r3zpev4Bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by VE1PR04MB7261.eurprd04.prod.outlook.com (2603:10a6:800:1a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 10:11:07 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963%7]) with mapi id 15.20.5746.028; Mon, 31 Oct 2022
 10:11:07 +0000
From:   Chester Lin <clin@suse.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>,
        Ondrej Spacek <ondrej.spacek@nxp.com>,
        Ghennadi Procopciuc <Ghennadi.Procopciuc@nxp.com>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org, s32@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 0/5] Add GMAC support for S32 SoC family
Date:   Mon, 31 Oct 2022 18:10:47 +0800
Message-Id: <20221031101052.14956-1-clin@suse.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0199.jpnprd01.prod.outlook.com
 (2603:1096:404:29::19) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|VE1PR04MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b195687-2530-4c00-a951-08dabb283a34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YbLhmO3JihayK/2Adp8H4nv+sZ8JwnFRCJ4SJE2qGq1uX9dOrmMyab1e3BfeUj8Bv1caozAEqku0jim6q1WZjzlGG9/opNqR1u2K29M82dusKaHm3F5Rl4nfYOF63oYVz6b5FQQnFpE4/bh1AxKZFPvcZpT5mJdKwkLm6MdtiEeyiaCK9IVbUJixQPwLCPQxKF6bHipXCD8SF2/YmIJMsXc1BelBBEfYnmg2Kvm49Gq5GWPyMUVXmtyCjVuaVF5HxX1kJIYUNcXKUJZ7QzL3gi+UKmvvKSl+WGQ4gz6Pn76l/3337w7HVEFyfikRXsXuOlvZu60zKSzCrFkchjN1ASN6wuDVbVYIh9lsY4yJpBmVvRLXPLv6YKoG6LRY0+LQouKSpffj43tAHGOouqtUt0rqunm3ZF2SxVcRX0J6EnRue7vvtqlPInAYP0utxbD6E/Wml+tQodmqM5lJPdV2R/Ud44x6u4Lk1DSIiptKfAteGZmWWm21fDwSZ7WYji4bwlEv2+HjVzKAPlZyqDneXdOkH9OxXf8m/pBwA6xYZIltFjkJSj1L2HizACKV0dy/1/6ce9rGWrgbHsJyKaphTzmyAgpccgNHyQLPPrCG0WVjHgtAUmyxXXlnGt7neVtSXNLXGJ71gJ4XISvNBY1+gDcdV2MMkQVOiJ/d2mGHpkcqOn6NP3djlr+r9PoVpapGJml17rAkhLShr5ddp/v194eWz9WMBq8GHvegNSzCl0eEJSVoCPHP4QNpMbEXHF4bbyJ/lemevSxLonmN1JIZlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39850400004)(376002)(366004)(346002)(451199015)(6486002)(107886003)(966005)(478600001)(66899015)(110136005)(54906003)(316002)(6666004)(86362001)(8676002)(6506007)(4326008)(66476007)(66946007)(66556008)(2906002)(26005)(38100700002)(41300700001)(6512007)(2616005)(186003)(1076003)(83380400001)(8936002)(921005)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WAwGOjTk87zztHpGrINmD1Mk4/tkaSbI2PwTENy+xhrdZbtN+7ZEUGWF32E0?=
 =?us-ascii?Q?iAIZCdKHKSZUUVBt0w0XY5KsKMYvtg5cpIsX3g9U1eaAL9KMbSw2b6BHFhyG?=
 =?us-ascii?Q?31GV2ZF7dhO00jcSt/N1LWRtMRDbDm9Mp+mhJPLxI8VbCaP/b7VB4Qa/kXpd?=
 =?us-ascii?Q?Jhh7KZi5ljONtC1UGtADfiqlqv0l792saY4tPeqYvz0DtMivE/mhLgryD6DL?=
 =?us-ascii?Q?Fom5ueKbgtkTnBPJYeb8jT8r3Scqevnwod370GDNqU8yPwFvisnVymunPH2U?=
 =?us-ascii?Q?6jlgvULqNvjZimZAju5ZawY3YTXk0YNv6Pl+sFZnNQRP4jPjUw/x03XlDt9p?=
 =?us-ascii?Q?xhCvMhXNWAwNyiyYi/VhpGzEJREOIwYvL+gcz/KpgqVMyav4JDdCS8Clfevf?=
 =?us-ascii?Q?8WYxdJ5qRlUT6swSL/dPQsub6dtqxunN5AmykYuTEpq8TqWk7j0iZ4lRZhxs?=
 =?us-ascii?Q?HjIqHACPzYWwDbL9AxsyY49xWYG5epbco8TjQY+kSkjzgfMAQ8xjqwbt3z7Y?=
 =?us-ascii?Q?IhKrLwHKHVUAes3xGkU5bG2UR/HcYHHDjfl49LCusGpSSGLcRSY9KtKC1W+P?=
 =?us-ascii?Q?gEaTq7YF4mn9/wQoEFg/NIfGzC3HR298C3if61R0Gc0H3ViAVsKBIUFoSiVt?=
 =?us-ascii?Q?XZwfL0bPjAXd145iCJ/4bcRiHrRjq2i8chge87Xrruqh9BbkWUjIpcxQbd+a?=
 =?us-ascii?Q?2Pg9xsrWXDNU4+dTaazFmq1OpF6CzrBnt40M35UmC1E8tILL1HGv/Qx3/p1a?=
 =?us-ascii?Q?W0303sqH9eC8bQIVCFFsnbQTtzaZT1DGqDm/kBXNpbtXbvJI4IjTrvdwnnV2?=
 =?us-ascii?Q?zizUBPtMvVgcwySXCekwReRwMa+LDQmNZAiyapHV1BUk6I1BXsVmvGohdRwQ?=
 =?us-ascii?Q?yiuTfnWFV32eQFxNGBqtuaUL0wJ3FO6cwhfIUj5Pu+zXiVh4xBWULIAhsrev?=
 =?us-ascii?Q?Bn4faMI3y9tmAmQlt3vJwwPe5OK1S0xbKRdJokXt+n5TzaQ03Q1RNYmB3Don?=
 =?us-ascii?Q?5iMc322G7ZcDmo/TNe4lpguvcEFvhuouXBGArxzLH+xXf1cN3ukg23EVGU3+?=
 =?us-ascii?Q?mM+RzqfR7ukyJkg0xbXRP/AKAa2UrMzxKgYsFjszH9MRkWCsvxI76s/fq9hp?=
 =?us-ascii?Q?LNCcbv1fW/d7+DY0d6KwvzGFld9RuXVLAixluEVhHCDtdTBWR+/BBuEmWW6G?=
 =?us-ascii?Q?YW//pS9FxXgI2F53WLYJBY88FsYqefq7wvAaJwm7l0NLDNmkoriNxd2hOBiv?=
 =?us-ascii?Q?vP8pftCsvU8Wo3AlWuaJzCF4mm/29KFT7fJXkwDp898g2HXvaqZEO9ZB/yXc?=
 =?us-ascii?Q?W6MOHvWe+1OI8A79GcUpqaPeMWgytXZmMaIm/pJ79N6yjVdrcG+gOJdx9/Qh?=
 =?us-ascii?Q?4A4N7+iaqCFOqd8+Ws6gwJYB+PhHp1ZgQTIFmYYHCxjEesWrAHurArXAoxwA?=
 =?us-ascii?Q?DpS8Tq70BmKDkjG0xYX3xn8nDBgx1tm/T6GMA4xm3JiwgtMkXfXabMAtozKt?=
 =?us-ascii?Q?7RDzifZ1Q22lVl1S7gQ93t+hcUlus3SiTydFRBbTMbt25mvheFE6ZsGSdLAm?=
 =?us-ascii?Q?thIGnxCzlI/CjqOJ5I8=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b195687-2530-4c00-a951-08dabb283a34
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:11:07.6899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0oOojdLGcpzE0AO97WJ53rqsqQvKjGjRoWtQ7lit4ypWkJIUCtWGX2UEb3GxGu/B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Here I want to introduce a new patch series, which aims to support GMAC
functions on S32 SoCs, such as S32G2. This series is originally from NXP's
implementation on CodeAurora[1] and it will be required by upstream kernel
to configure platform settings at the DWMAC glue layer before activating
the DWMAC core on different S32G boards. In this patchset I also introduce
more register fields needed by S32 SoCs, such as higher CSR clock ranges
and cache coherency settings. For more information please see NXP's
GMACSUBSYS Reference Manual[2].

Currently, the whole architecture relies on FDTs offered by ATF[3] on
CodeAurora to keep the flexibility of handling multiple S32 platforms since
now S32 clks can be triggered via the ARM SCMI clock protocol and clk IDs/
settings can vary according to different board designs. To ensure that the
driver can work properly, the dt-binding schemas in this patchset is still
required as a reference.

Thanks,
Chester

[1] https://source.codeaurora.org/external/autobsps32/linux/tree/drivers/net/ethernet/stmicro/stmmac?h=bsp34.0-5.10.120-rt
[2] https://www.nxp.com/webapp/Download?colCode=GMACSUBSYSRM
[3] https://source.codeaurora.org/external/autobsps32/arm-trusted-firmware/tag/?h=bsp34.0-2.5

Chester Lin (5):
  dt-bindings: net: snps, dwmac: add NXP S32CC support
  dt-bindings: net: add schema for NXP S32CC dwmac glue driver
  net: stmmac: Add CSR clock 500Mhz/800Mhz support
  net: stmmac: Add AXI4 ACE control support
  net: stmmac: Add NXP S32 SoC family support

 .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |   5 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |  13 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +
 .../net/ethernet/stmicro/stmmac/dwmac-s32cc.c | 318 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  10 +
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   7 +
 include/linux/stmmac.h                        |   9 +
 11 files changed, 516 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-s32cc.c

-- 
2.37.3

