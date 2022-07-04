Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8945657AD
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiGDNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbiGDNqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:46:30 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D8B271F;
        Mon,  4 Jul 2022 06:46:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBAaGh+m5pOGtFgNr2alwyVaPvbgbXTVd0d+qNhe+EOnDmkU2c21qvq7ETsNeTWUzITTGqWUUjqXqePT4Uf1Wkh6FoGQzEMGBGaq6o56vIE36L1QprtQH9EX110OREJc76oPcJwFe2sgFF4uu5+2OwTn/l7cO5QQDZ7TtX9GlZuM2HUkqwNGY8RaIeQnVsHnJBBhR1JsdQ1m+wpABt3k6PPXc6tIwxy2sN2GUfrMcKaGMnlFoJ0RTqlsdzyvxnVczzodax3g0WTI/NZA9fO2WK02xcPTqZ14cLnsf2KpAMpZL0vmgDQITwE6N/gxOEn4BP+URiry6hAaN2N5AOrZwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cyqQlN0jbBi7m8+P8myzBM1xD9tIwqm0x92RHu3ODJ4=;
 b=TFzj803zSRYwCyYY6Elmh4KK8dyi+vri70iuQY0Qk6vo6JzokllAaVAP6A4X97LtZlwnCcT9G7qnSF3hMLRHjGdWHTb0aEcNzjfWQLa02KJJfor7Amfr2NY6P1dOpE8arOEf8LQjiK7A/ysDPgVeS7wAbtyi2Szd7S/oi/P2LX15YHboviSsqoR95c3MLu8x/U/ZZklRch+17PYWKw9TTvY1OtKIpGYLXhOUWaC4vFTF3JFpDha7UJXjf/NYhViv+DjY+51s1rkc34IUarJ+MC2Z1GTXNw62ZBl6DV+X9301Jn3eDNhli5htzqJ1rchHpi3BA5rKUjQk/9+41+T5tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyqQlN0jbBi7m8+P8myzBM1xD9tIwqm0x92RHu3ODJ4=;
 b=iXO9df3gK+UEaoEm+Q0d/OKWhU/QqMYW+zjbfoamXVGxNkar3n2I/qMe+tB/dRaDF4Ju1vN61K88tU/Kqdp7e1J4V3IK+k2jENhsGMCbAOPCrcbqG1S5BEM8ZGk5zTspwTS1c1jSdOnOo8vLzL2sg117oX9GGzg+w1gLUAda7XY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB7887.eurprd04.prod.outlook.com (2603:10a6:102:c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 13:46:28 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Mon, 4 Jul 2022
 13:46:28 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 3/4] arch: arm64: dts: lx2160a-clearfog-itx: rename the sfp GPIO properties
Date:   Mon,  4 Jul 2022 16:46:03 +0300
Message-Id: <20220704134604.13626-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704134604.13626-1-ioana.ciornei@nxp.com>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::20) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d206bcf-2e2d-4c1b-9921-08da5dc39811
X-MS-TrafficTypeDiagnostic: PA4PR04MB7887:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbkTH82Ygd6j16UOcmEUnvmoCSfKjiOOifwgEy5QqKc22Y75Tm/AE0IcE8jIG6nVzcFu8w1rmlp9712pv6m8qoevbAdp6zfVtltUPV7UtOG9LPl7LrkX0+hmq9Tdv5Vx+OvleGNwh2bTig99ROybut6YUq3Y1cUVFid+m2bCfKdWL15KQpGWeyrs6YtfJ26NatnktlNBIc1zvA6HQGFMnYl5uYkJDf8bSY5DYom1VVIHDbJ3n7C5mLQ6TTEDFqVNlSogdprRpIbwFAt7VoJSucWBEsYtwF2+xdybV5yVjynBzqPMcVyNcF23g89+nFI0bPMzfE/QdMe0j0bHyzE2g6jkT3FA5sumzW8+FRIny63bzUgemnw+ty305p6UAqLn5p63VKjEahnDSFaxAu57riAJYWYUlEdK6CNC/VGPMOxxLXgRgLqjwxedKC7uMCRPd+CdxlA0zyezi42wn5lfRa1M46Xre1LsK5kDFg2QMwO255OLssHcLlrAT0uCZZOzAgIEjFf8twuW0YXDEul1JgGiCBlB3AZCph+UZnFuzAwwrv85cXxMBEjSHcCqYRkKEG5VycmwSW2QrlRqQjcZ5zqxoZ1TrXSMtfF1lLCUU+Db4QTn4eQEIT2h/4HY27vjMr4tW5cDJkJejhBBOcmII2BL5Di4xr5gWj9pCiORj6TsCiFjvdp5RlbMhof8qxgUKnI+mQ2oi+X+b0gghi5Q8hYkSC7mIrPgMvkFGhnTnLmMFr1IAfnSSIA4c8LT9cweVAIeKaeqtBhw79km7Qk4+RJHxAQ8itm7wB8w+0k/kT7PDk0r821PR46EJsL8g90l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(1076003)(4326008)(66476007)(86362001)(66556008)(8676002)(8936002)(66946007)(6512007)(2616005)(38350700002)(38100700002)(316002)(52116002)(6666004)(41300700001)(6506007)(26005)(44832011)(186003)(478600001)(36756003)(2906002)(83380400001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qvUs8cmZBtAPmRc2ICunctxaO2wxlW9d//W2d++LfKb8uwResrhy0DP8o1zK?=
 =?us-ascii?Q?mm3wWfVGVHxVOkk477vgtTE5CZFQy0VsD6lxffv5DSGIe1Kc2PIptxMyiZ7p?=
 =?us-ascii?Q?AuaG5KrnAhTHvjyFCQZt5mG8UArgTq7cuQ1EeDrqcz/+fUWVA8ZFbS0phuUv?=
 =?us-ascii?Q?XnmMyTQCRKWqAS9TZnuT14YKQvsgLEn7acibRX+XVK9sb6OBBe36RANSCNL9?=
 =?us-ascii?Q?DWDwCwkKnXVR7HaAhga5eX8/38G3hkP2Ubhjm4QgZLKk9IV8JNvkfvJrHb8A?=
 =?us-ascii?Q?WR/knIEZ+Tmg9smkcqwTG80qEnlzYJVqq364hj7WrObi6i784I9rdLFHJjNx?=
 =?us-ascii?Q?CwIfRLhtyJsklLI/RMOPyqKvq9SHxtEN82T6/Dn8fsQEZ79JHBEzcuKz4yJc?=
 =?us-ascii?Q?wXbXpI+EVGFkfqP7xH/EX0/MN5wsffo5Hd4TfHDSW0ujIk6FQLcxlBES528i?=
 =?us-ascii?Q?KhXN6PYKanLTR0Jfy0thhfxmOi7DfbqXQ7cy5L7vxNq+t4MOgR30Sn5QO+SB?=
 =?us-ascii?Q?MdA2igSj9iJqXJZoyxmkLZXQUGekgH7B1JWfi9Ru5IoI9QVQQN0aVl7EHx2t?=
 =?us-ascii?Q?ka9nFgou8mHCCQ5dP4fozu2cK6lc31kwiEWUX8z8ON/Ind65GluDUu97BznR?=
 =?us-ascii?Q?U5nQwzkGwJJ22nd/SanWDSodzKRN+qIsyFNDKBwPrJkgwdYeQwlZmgowVnz/?=
 =?us-ascii?Q?Trbp2P+/jXS5K2cQsrrl4k3hc3NI9SL5Mmex/UVP4xF6GJveLZ+2VsBcKluG?=
 =?us-ascii?Q?SLDZ+FisczA+38RUUAeq/YGapSWOwMRKHPyBIGXIMxH9G4n6+cK09CAAc8MJ?=
 =?us-ascii?Q?1n+0r2/nUCNkbyFb0w+0w605yssmxP4oBXUoXedmSYToORmg32uZeueo/jS9?=
 =?us-ascii?Q?xgqrUZkW047UCa3WATdQScdNMZ85hTSNoyODc0BPM861zC9QDWxWhEWsLMwz?=
 =?us-ascii?Q?IHIQ6UxQ54G8BglaQsE27ZArZII9lHh2XicxQVHB5FxQgI/3aqZ+1pj9EG5Q?=
 =?us-ascii?Q?CLXDOkspCBWirjN0oHIjA9NsUnaf5lsW2SBoTgSe2fUp5ZK6DnOivr23yKU+?=
 =?us-ascii?Q?R4JxAhub3yNT+82xRG6B/HDiHvn47rj9eY5A/Uco/yBl7bz8CJZPOe6YhfUP?=
 =?us-ascii?Q?wOMM231JaYjXuAn2iIqBNY+shlao4KMR/D5Tw0zfxN8ue7pfDcbrdnQ2W1WR?=
 =?us-ascii?Q?gYnc5eyoK/fQERYDJuHuxqUD/SL7uVuQxycdj7eHu+3keDsgIs/neOokmwRs?=
 =?us-ascii?Q?9391LHOiVheOLJ1DlFFknaVybx28JKvAxwb7buig+273aJ42aKEAUMZ0CnrR?=
 =?us-ascii?Q?WaiYZJxnL3WXQ3L8V9fnzjvLcHaTajg4Olh4jJlpQFSLwGNOukDQecSifpmZ?=
 =?us-ascii?Q?mbG7DptLG7AM0xMaL2eb9nHIUktGlMZ4Uk84HX6ecBJfjslDXKjZFk9jkz/T?=
 =?us-ascii?Q?QXbR79VhN5zAkVP04IO16Bd885tqXyMw3/aw8oep+lcI9yquzgD4v03JIlKZ?=
 =?us-ascii?Q?Za2Lj7uJAJ39mAmFmVLi4EZIJAhFWnppq0l2mc9/IRjX2ZRAlkDwL1RBxHS4?=
 =?us-ascii?Q?MMTQ2bBwZ3rukrs+1kgpXi5EzHzt3ZDYWxctspO+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d206bcf-2e2d-4c1b-9921-08da5dc39811
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 13:46:28.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tiKp94XWmPSmAVQQLHD4tniXm3eULf7DReKYR29M0PnAYcc99mUgShVX4h7s2zNc7MP3rgPGK95YhEyEvxFeKw==
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

Rename the 'mod-def0-gpio' property to 'mod-def0-gpios' so that we use
the preferred -gpios suffix. Also, with this change the dtb_check will
not complain when trying to verify the DTS against the sff,sfp.yaml
binding.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch

 .../boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi      | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 41702e7386e3..a7dcbecc1f41 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -34,28 +34,28 @@
 	sfp0: sfp-0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp0_i2c>;
-		mod-def0-gpio = <&gpio2 0 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 0 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 
 	sfp1: sfp-1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp1_i2c>;
-		mod-def0-gpio = <&gpio2 9 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 9 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 
 	sfp2: sfp-2 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp2_i2c>;
-		mod-def0-gpio = <&gpio2 10 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 
 	sfp3: sfp-3 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp3_i2c>;
-		mod-def0-gpio = <&gpio2 11 GPIO_ACTIVE_LOW>;
+		mod-def0-gpios = <&gpio2 11 GPIO_ACTIVE_LOW>;
 		maximum-power-milliwatt = <2000>;
 	};
 };
-- 
2.17.1

