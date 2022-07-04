Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBEE5657B1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiGDNqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbiGDNqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:46:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57332BDA;
        Mon,  4 Jul 2022 06:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4FIVl617dV07ICYAOC93OmAzNFzuBvQJ2TI7Cz0dnpDnciXuuYgsAL849yEISfq9pTjLtYF4Z7jPjjjMQ5UTLuGO/4eAmmQhAKTalGy/e4Jz19PGASHLzPvyeJ8yLC4gmJQ5ltS4s58+mjv9JH/WtiGgmA7+p7EurNPMi04K/GRRXKgxbmGrbLLdWuTYqilIe/oT1OrC5c8Y1SijKNFDsbEQ+eiBWQ06PBCcu+J/U/xHWutlLMmu1c6vGziA9ll0AvCifGHA6JSI7qdMbqwSrUGWYOR2GmTckzIt/RXZqmspu0g6bEOfygpCJgLFXimELJX8pGqKHeWVsezem0ccA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lwsuakEZGJEzp76XIVLoPtD1TJHBnJFKeA6aTHHmSE=;
 b=jF/VEgPB6IqsJosAOH3eltus5e6LncS8LZIZdMfTd7BpxgUpvVawoSkxMqONxg0OiNaX0seWipfCTBUSKrbrjGU9xZGosuBhaXL9r0Cj1QMcAU+wLk5fKQR4Y/XIN3N0JtJeDrd7e6vwES5so19+fyqTRazI5bINQLHwYuIAJRwYmJ3VL1lWH4yRFxLy2VV8FLW7Av0NishwblNLa8o0qMMwJHZJJNZ9oXU9lF5lfE5SO0W4vrGdVTDz6JPVtdlS4ZrYHB7PniTSEh1d5LWjz32i1OyUTLLoY050o0/40o52Zg0Ww1INkYkJ+dOnnLtRuvM+LRSm8ZYiEcSBVKA5vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lwsuakEZGJEzp76XIVLoPtD1TJHBnJFKeA6aTHHmSE=;
 b=kFUm2+yDU/jjQ3KRVEpH6itaDWYZSF8gjW6ILNMyDMVtIhVds0CGgVjK2vHql8eMVxQrlprZsm4amo3ikfJ9271F9x8Ir6i7fJXWcivXXzPl9TSjyCOI+fRTAQ/HNbS6w/Vo5UbEwNrgr+VCw/p80mRfxULZXI2TMP/eQJV7Moo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB7887.eurprd04.prod.outlook.com (2603:10a6:102:c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 13:46:29 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Mon, 4 Jul 2022
 13:46:29 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 4/4] arch: arm64: dts: marvell: rename the sfp GPIO properties
Date:   Mon,  4 Jul 2022 16:46:04 +0300
Message-Id: <20220704134604.13626-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704134604.13626-1-ioana.ciornei@nxp.com>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::20) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dee67a91-6323-40b7-84e8-08da5dc398cb
X-MS-TrafficTypeDiagnostic: PA4PR04MB7887:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ti13p5+uSNlYHBx1CiJ5KaqMJ+Zp5LdyTTZwNUm/WK+L9rBxqkWxLSqLQwHoMjbb69/fRvh+Px9ofQDyWEx0WS2txTcgLvfzBWSJsXckH1+7mKNGjr/voTyeRYnOctReb4a3k7qsFSkmB82zKPcbm696bbiFWReJXRvB4pux4KQpDEVoMmFEJU8REWJn1m/FM1wxpaAIGydpg8hUWMotvscjIJyEcLOg262lOCmf1mxDFTD2oWyNHs/YBADty/CbYlZ8emMnBAIYU+RlQdk9PSI8UEeUlNpTAIEbdwLvsRsH+qTopp12Ukkerv3CbgCfInGw0M0s3Z+lz4QYUcC/MuQvq8OmS6LCmAwT4uEi3s6YZ3+s1Pqbkot5k+L+NZ6rhTyUOOSvHY9X15uoCEGEdV/smS+88/eSTWeKG9OqhC1RIn+gAOiUuhCYNRkcghLHUfKPWhVEW3Xl4zMHR00xPcRXAptqfvsRQTAK2OIJwpy7ns8rnzt6gO5STIZLxVQPbOfvFM4oF3hsPn5weTBdp2WZZ9vISMhn/qx9NWYaadGi6LlSJg8KnAzdb7uFG3/tQBYm37FhOD7x52T7QAnKd3x+zxWmJNoRbJExKKZauZdgDfl8EvED5c929WNdstdedl79WZNtl5AK2AFgimqFvJvC5E1ZeitEzgmAxC4tM+W2H98WxfFrX1SmHyoaysMGKveVivJw2cyB+V5gUpS7fGzuuxTHV2FrqNMFc7HgV5oFVUDomGXTAPXWxhl1SOe9vuFUYKVa/IAgtF45CpMI7qSFXSvq9EctoMMlaZ+VWjMdLmtipC02pyvJkcGI7eM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(1076003)(4326008)(66476007)(86362001)(66556008)(8676002)(8936002)(66946007)(6512007)(2616005)(38350700002)(38100700002)(316002)(52116002)(6666004)(41300700001)(6506007)(26005)(44832011)(186003)(478600001)(36756003)(2906002)(83380400001)(5660300002)(30864003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AyoalOzcheMpdXuk7yeIfRcF2g5HD/8XM34+3qj/RM1+m73IqgGP/vBYtb21?=
 =?us-ascii?Q?qBsraW0k5E/D2UGwEXFQZdkTj3UXy/+DGtifkj7zkXxPeu7ajM4+x5uVyK9c?=
 =?us-ascii?Q?gdSwQ+k11/ozn3iyyOWQJ6csp6jdExjAqXW6x3N4jjHmUUXcRN6xqp2mlVGL?=
 =?us-ascii?Q?m0unNzUw05jyYCYSO2H1WWDchO5tio3DFugjjrsiYii36Dsq6qCvC8H2i2c8?=
 =?us-ascii?Q?V8EatEl/vsq7jXHZRe+sie+PSnyMqQWh8YZlzt9XfqjvIQ1uKTrtylDMxjwQ?=
 =?us-ascii?Q?owlxoSw35E4EKg9cCQH7p6f42sAR+4WyC/a59KGE1nTSDBwa7xyaN26sWtBc?=
 =?us-ascii?Q?ann8YAExIFwgjjC4ZEArooZsO4hN250dZL5j/8yLbJCqHHksg3uWhQy9UFvc?=
 =?us-ascii?Q?t3U5UqB4zP/DLHgZ85d7k53H8fsv9ooWMepJt9hM4irlHhEjJQi5AqD0qRE3?=
 =?us-ascii?Q?h/PhJpA4sTQNG3Z6oCsAQ4ZT/DZZ5Hd1zwSrmS5uFEh4kDaucFeobLk5/WIX?=
 =?us-ascii?Q?O+6Famj6LYiXbuU+swvlwMqjkCJhWJHUo8gY8rXKPLTRG9qqd0knpv++ojXw?=
 =?us-ascii?Q?fBWt8IuxgmDodtWnAS/UzYJf4GnNzBXaPGNh7ys6o5VvlPd+QXkxqSnQTX8z?=
 =?us-ascii?Q?QPzivjBcTLwT1/NHbLCyQc1je51LlpqKIgnXKhoK22ze+ln/lpTd/7+gBDY3?=
 =?us-ascii?Q?s081M6HvC7RshnNdm/mDU++rsJmw0RY8Ip1B5Jz3P/fTqhQJcThthUkVKg7X?=
 =?us-ascii?Q?Dl1DotdCHN1Nvaof/9KlJEHnz0BgINRC5gfpl5ujye1jIwnZTt0mW4wBqxgQ?=
 =?us-ascii?Q?bJ+2KWWoU/6ddoZ2SeOeVQShddOafA2wR/CXydEaJHC/u1j9whFG9U3LYWp6?=
 =?us-ascii?Q?jcRZgkXGNJZWcwvkho/LKkJbeYGIjsF8mcJPRW5P+C7ONmL3P6+Q065cpGml?=
 =?us-ascii?Q?aBHozi8aF3p2hGBufmF8DHMZwhu+umrC0kdgtyUKYiPVIHuM7b903J6RNpsr?=
 =?us-ascii?Q?ofNzp964yfbnkRqn444bbvmB123YUGg0kr/AWdvOGqqaZp19lKFw3srqwQ/x?=
 =?us-ascii?Q?ZadH2/2XPHtWhCf0RRAYsiTyv2DOBppui1WYtiHzFnzzSMQhi7LtL9CMapsL?=
 =?us-ascii?Q?kI3FyB1cipcOlyHEEyphwPqlgGcI6aui4wsvhT+m83G56Y8isK1Q4gByxnBz?=
 =?us-ascii?Q?cdAYBm0Tvif5Z7ztrzVkQcDjbes69ZVzZ2eiPH/f5qz/j+zHH1x54iVe4WcN?=
 =?us-ascii?Q?FLWEK0kiApCFkVlbl64Hr93OUHrfWpXFImZvErXFYzlOJHNi/vAFrQuEZkjC?=
 =?us-ascii?Q?rHQzNqWXYODvv4LMnxTiJObaf0yYeS6DXBa74FJwM0/kSN10RCelPsewfYmH?=
 =?us-ascii?Q?yDiLcoJEhOWjlzx+hXCkvKJ0gJRWTtcSxZrJ5ZLMEgaKnPomsrhXDLkFRuAz?=
 =?us-ascii?Q?Tz8LT75zvqcDsPBvKHQ5DhIfogfrSN18tc2yrFvriKFZI3mnqWBPVHYb3CTU?=
 =?us-ascii?Q?CZ4/cTt4V46J7nIDhpG7EWIQ2n7lO+8EdIuq+HTHEhV5a2py6+44yF60mJbU?=
 =?us-ascii?Q?507a+0mN6m4JfrivbQSwkToIxy5q7A8OIFCj62H3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee67a91-6323-40b7-84e8-08da5dc398cb
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 13:46:29.2639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IV031A2QM0iIq88MULxYDEESYVZJke9oXE4lcoHhpLqV2ST3bJRc4goa1hpVvJY2DWXJrswof9X0WdkB6VnNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7887
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the GPIO related sfp properties to include the preffered -gpios
suffix. Also, with this change the dtb_check will no longer complain
when trying to verify the DTS against the sff,sfp.yaml binding.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch

 .../dts/marvell/armada-3720-turris-mox.dts    | 10 ++++----
 .../boot/dts/marvell/armada-3720-uDPU.dts     | 16 ++++++-------
 .../boot/dts/marvell/armada-7040-mochabin.dts | 16 ++++++-------
 .../marvell/armada-8040-clearfog-gt-8k.dts    |  4 ++--
 .../boot/dts/marvell/armada-8040-mcbin.dtsi   | 24 +++++++++----------
 .../dts/marvell/armada-8040-puzzle-m801.dts   | 16 ++++++-------
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi   |  6 ++---
 arch/arm64/boot/dts/marvell/cn9130-db.dtsi    |  8 +++----
 arch/arm64/boot/dts/marvell/cn9131-db.dtsi    |  8 +++----
 arch/arm64/boot/dts/marvell/cn9132-db.dtsi    |  8 +++----
 10 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index caf9c8529fca..cbf75ddd6857 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -100,11 +100,11 @@
 	sfp: sfp {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c0>;
-		los-gpio = <&moxtet_sfp 0 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&moxtet_sfp 1 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&moxtet_sfp 2 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&moxtet_sfp 4 GPIO_ACTIVE_HIGH>;
-		rate-select0-gpio = <&moxtet_sfp 5 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&moxtet_sfp 0 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&moxtet_sfp 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&moxtet_sfp 2 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&moxtet_sfp 4 GPIO_ACTIVE_HIGH>;
+		rate-select0-gpios = <&moxtet_sfp 5 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 
 		/* enabled by U-Boot if SFP module is present */
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
index a35317d24d6c..b20c8e7d923b 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
@@ -65,20 +65,20 @@
 	sfp_eth0: sfp-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c0>;
-		los-gpio = <&gpiosb 2 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&gpiosb 3 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&gpiosb 4 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&gpiosb 5 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&gpiosb 2 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&gpiosb 4 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&gpiosb 5 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 
 	sfp_eth1: sfp-eth1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c1>;
-		los-gpio = <&gpiosb 7 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&gpiosb 8 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&gpiosb 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&gpiosb 10 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&gpiosb 7 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&gpiosb 8 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&gpiosb 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&gpiosb 10 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 };
diff --git a/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts b/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
index 39a8e5e99d79..5f6ed735e31a 100644
--- a/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
@@ -34,20 +34,20 @@
 	sfp_eth0: sfp-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c1>;
-		los-gpio = <&sfp_gpio 3 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfp_gpio 2 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfp_gpio 1 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfp_gpio 3 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfp_gpio 2 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfp_gpio 1 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
 	};
 
 	/* SFP 1G */
 	sfp_eth2: sfp-eth2 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c0>;
-		los-gpio = <&sfp_gpio 7 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfp_gpio 6 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfp_gpio 5 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfp_gpio 7 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfp_gpio 6 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfp_gpio 5 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index 871f84b4a6ed..079c2745070a 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -64,8 +64,8 @@
 	sfp_cp0_eth0: sfp-cp0-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c1>;
-		mod-def0-gpio = <&cp0_gpio2 17 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp0_gpio2 17 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp0_sfp_present_pins &cp1_sfp_tx_disable_pins>;
 		maximum-power-milliwatt = <2000>;
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
index 779cf167c33e..33c179838e24 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
@@ -65,10 +65,10 @@
 		/* CON15,16 - CPM lane 4 */
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpp0_i2c>;
-		los-gpio = <&cp1_gpio1 28 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp1_gpio1 27 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp1_gpio1 28 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp1_gpio1 27 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp1_sfpp0_pins>;
 		maximum-power-milliwatt = <2000>;
@@ -78,10 +78,10 @@
 		/* CON17,18 - CPS lane 4 */
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpp1_i2c>;
-		los-gpio = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp1_gpio1 11 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 10 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_gpio2 30 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp1_gpio1 11 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 10 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_gpio2 30 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp1_sfpp1_pins &cp0_sfpp1_pins>;
 		maximum-power-milliwatt = <2000>;
@@ -91,10 +91,10 @@
 		/* CON13,14 - CPS lane 5 */
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp_1g_i2c>;
-		los-gpio = <&cp0_gpio2 22 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp0_gpio2 21 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 24 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_gpio2 19 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp0_gpio2 22 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp0_gpio2 21 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 24 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_gpio2 19 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp0_sfp_1g_pins &cp1_sfp_1g_pins>;
 		maximum-power-milliwatt = <2000>;
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts b/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
index 74bed79e4f5e..72e9b0f671a9 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
@@ -67,20 +67,20 @@
 	sfp_cp0_eth0: sfp-cp0-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpplus0_i2c>;
-		los-gpio = <&sfpplus_gpio 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfpplus_gpio 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfpplus_gpio 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfpplus_gpio 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfpplus_gpio 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfpplus_gpio 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 
 	sfp_cp1_eth0: sfp-cp1-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpplus1_i2c>;
-		los-gpio = <&sfpplus_gpio 3 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfpplus_gpio 2 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfpplus_gpio 1 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfpplus_gpio 3 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfpplus_gpio 2 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfpplus_gpio 1 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 
diff --git a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
index 1acd746284dc..8e4ec243fb8f 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
@@ -78,9 +78,9 @@
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c1>;
 		mod-def0-gpios = <&expander0 3 GPIO_ACTIVE_LOW>;
-		los-gpio = <&expander0 15 GPIO_ACTIVE_HIGH>;
-		tx-disable-gpio = <&expander0 2 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_gpio1 24 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&expander0 15 GPIO_ACTIVE_HIGH>;
+		tx-disable-gpios = <&expander0 2 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_gpio1 24 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 		status = "okay";
 	};
diff --git a/arch/arm64/boot/dts/marvell/cn9130-db.dtsi b/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
index 7e20987253a3..85d7ce13e70a 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
@@ -90,10 +90,10 @@
 	cp0_sfp_eth0: sfp-eth@0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_sfpp0_i2c>;
-		los-gpio = <&cp0_module_expander1 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp0_module_expander1 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp0_module_expander1 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_module_expander1 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp0_module_expander1 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp0_module_expander1 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp0_module_expander1 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_module_expander1 8 GPIO_ACTIVE_HIGH>;
 		/*
 		 * SFP cages are unconnected on early PCBs because of an the I2C
 		 * lanes not being connected. Prevent the port for being
diff --git a/arch/arm64/boot/dts/marvell/cn9131-db.dtsi b/arch/arm64/boot/dts/marvell/cn9131-db.dtsi
index b7fc241a228c..ff8422fae31b 100644
--- a/arch/arm64/boot/dts/marvell/cn9131-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9131-db.dtsi
@@ -37,10 +37,10 @@
 	cp1_sfp_eth1: sfp-eth1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp1_i2c0>;
-		los-gpio = <&cp1_gpio1 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp1_gpio1 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp1_gpio1 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp1_gpio1 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp1_sfp_pins>;
 		/*
diff --git a/arch/arm64/boot/dts/marvell/cn9132-db.dtsi b/arch/arm64/boot/dts/marvell/cn9132-db.dtsi
index 3f1795fb4fe7..512a4fa2861e 100644
--- a/arch/arm64/boot/dts/marvell/cn9132-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9132-db.dtsi
@@ -57,10 +57,10 @@
 	cp2_sfp_eth0: sfp-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp2_sfpp0_i2c>;
-		los-gpio = <&cp2_module_expander1 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp2_module_expander1 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp2_module_expander1 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp2_module_expander1 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp2_module_expander1 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp2_module_expander1 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp2_module_expander1 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp2_module_expander1 8 GPIO_ACTIVE_HIGH>;
 		/*
 		 * SFP cages are unconnected on early PCBs because of an the I2C
 		 * lanes not being connected. Prevent the port for being
-- 
2.17.1

