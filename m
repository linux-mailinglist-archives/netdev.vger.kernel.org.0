Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C448569E61
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiGGJPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiGGJPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:15:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8438A2B193;
        Thu,  7 Jul 2022 02:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OfdJxS0ZTrig8jDbqUVAvj4CMdSbLs6B3MMHRB548uOZIHyhkcyH+1RRQ/mYe6ww4DlCbwy8X4b85GqeYp5xhBdm8WRq/bljpulMjAoW5kH7PkIixp55J4uWunwQPU5QQKflvrucvtF/Tg7iuip98O5tp51g7kwFdZDcuP+8BBhqCsAKwn9VgPonGf44bioDJrrAUH/wPd9+cvB5iuuMZBCM09P7mpMbvLLfYZvHTsRcBzu7qMMWBq9ii6fkGZ1ki7tuZ89hzA57s5WSktw9TYn+m8nfDcCLwd4A0m5Y0dciFGSQQoQZLZhg0pXTuUy7fQcG8SCOBQir7miL1vc81w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVNhfvD1GSOnfeq6HKFHoIiEw6NTOs1LaH7D1mG0qJo=;
 b=LXXOGp8+AoeQfXW2WrRW14n9BEyF5BvGMxbjHatm7+KXxm8SiAAA5Iq9s/lCLrNbkaFrb/sj6X7suuKELDLEU4QMcQxrHXfepLYEO2rkJveYCYXFP4yjSjFfP1nBJTCPZl1cmiRCuYnxTVWGW7BcG/UefoIwztHPUKaS9OpEorgHZGdB4dIuQM+Zf9MCoVbb0b4DFHrYF78PXM/S75cPi0Iy3DSZOGP9T5QGCstzcgTWAfn/6tnGtJVVd+U3MIlKUY7l7m1jN91JPlFuxDNYdX4BPos7o0BGPVrYjeXG2l+w455GOV7xQ0YZqh+fl9EfYLZ00RUhgktLWt82WRe7/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVNhfvD1GSOnfeq6HKFHoIiEw6NTOs1LaH7D1mG0qJo=;
 b=AU0pKp5Q8Tm+810vR7JcT1RFYRONYjhESmF2YnhtGbUealZEGMhxT7kyV/7wl2VQGgPdZu0b6HiqPWHpmBHiEG8f+qlzNqrcSZlRVyRlK0MTiTrTjlABDvQE6lzpWGTO8ej6w7sQ4V/GmMFYsXrZefBkJHul7v5ZCy7qCsv0EZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by HE1PR0402MB3595.eurprd04.prod.outlook.com (2603:10a6:7:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 09:15:08 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 7 Jul 2022
 09:15:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 2/4] dt-bindings: net: sff,sfp: rename example dt nodes to be more generic
Date:   Thu,  7 Jul 2022 12:14:35 +0300
Message-Id: <20220707091437.446458-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707091437.446458-1-ioana.ciornei@nxp.com>
References: <20220707091437.446458-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0125.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6d4cf60-a0be-48af-1731-08da5ff92fd7
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3595:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOlCZJZYvNeWLAoFvdLeH5gmW1BlYIQ7CBXm9RCh1N7mpOAuLch50GfNxZcmgMn4QpgdHXg1sIVM8ugT4UssEGZDj6aMQs0TUhmF8nfviuOLfTfN+uS4RibnbUqPQX22DMPy3zYB5Kp1cbpJHw7RDfxq9+ZMlc2pbFTxFPKXxuNlonK9o2BylugqzyIFbCtcU/uz/OeuSTO16bWQ86WChn8a7GuHCXoLVo4N9TSbZUAF4iPMG2UyRr87qMRK3PlGn7RgArhA86T09IJvP4p2rwwlWqmYNewnNkDA/4eQkafLwBrtVG92iwQR1PPmRcym853P7cAQH8NC5VMCXDsYC+T3LX+gY85xBMdbddPL3ra/rkGqZdo7g96F0GFsd4ryLjnE1UDDC5nekd/XdV0uA5JJwAFJ5RD2W9vQzmLcknzmF4j2boQWF98ALBTMcIAF4YjXZZj3ldZihe1lmX3ObKseX9WMGx4lnuxTlzcJBxjsEoTu+eUet3pozu33k2gfjfMg5vltfKDro2N/UnuqhiKez5tdpMc4BQ3X7snFA8i9q+KekSJwhGVJHg5LqhIuRp4yDGGwqUcaYG9OrTUA2TQMM0G7C0riOKNDwyxti0SpBwsOrahPEnP1uepTXW1RgmfEziPDL0wkl+c1ak2C+i13P7TEvpk7i2cYAdXmK07UwVrkn8brJvAq51pQ8guwvIL7W6+HdwLHbFenAGSLhZg24RRQOZfY2J8SX3hNXuZ4STUG//JW2zRYdaeeJbe1dWivMma7bxWWMpB5ao4ZdiIpB40BeVTSbKdX+vTDrdowTi3ohqYkUpqv4orcKAn/BIg/NP67sARva2QrjJ/pFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(316002)(54906003)(83380400001)(186003)(26005)(36756003)(6512007)(66556008)(66476007)(6506007)(5660300002)(86362001)(2906002)(8676002)(4326008)(66946007)(1076003)(38350700002)(38100700002)(478600001)(6666004)(6486002)(44832011)(41300700001)(2616005)(52116002)(8936002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beyaKu/Qva7OUQX+Y9nknBWhig4pfshHamHJXVOI7aOMG5x/th3o5zsy1++O?=
 =?us-ascii?Q?mTRPGzXoiBFo7UocFLo8NHfzcyHcpAEYakteeVotAbzDv3gjEXxsGuYp5O4Z?=
 =?us-ascii?Q?qRV3LBQ4SyztOlJRWbhP3FbNaqdRR75IlJ8uanuezSJYsKeGyWTfI14ba7VI?=
 =?us-ascii?Q?c3Cg3YLKc6RqX0Gsc0gUXFL3Hmmz4ep5wbrgB8j/pYjFISxI4u4uxhlfG2rZ?=
 =?us-ascii?Q?Ixwu5qug3qo3q+wu0ue9hHdybOGZZ4SZnYLJ/SFVvTw8GKpmkp6RjgIHblxI?=
 =?us-ascii?Q?CRh90cpGCTlvSi2wDcxIOUiwJBHDeDbcMCWlAmCKJVJ8uai+/dMnYv94qijZ?=
 =?us-ascii?Q?W1lQ7tPeGj8zCzq6MBHbMQxUP45eD6k1/j5Zqg8ZbSHP+E3aQugpiDZer8FN?=
 =?us-ascii?Q?iap4ZwKZuFBpb4GVfwHT+PlXsmgzE9sFkArDBNrNPcvvueVu49V5QW+jmETz?=
 =?us-ascii?Q?wYWn9a4j+xy2To66m5Wvp+UwBR3HOwTtGL9314DdqWEuACfpR8r4NQ8/kzDe?=
 =?us-ascii?Q?WMP9Bg9/1n4mxAT5/Zw/DaaBHxsmHcBYPg1V4C9nIZEjXfrMps+jic/nzFnx?=
 =?us-ascii?Q?5FEN0XmDijg279TbNp4R5Gb9gTVN585r2pHEKd7oDLeFneboMijauiXBZoky?=
 =?us-ascii?Q?cx2+k5R9P+gdjUlioMOWfSBeLtom+xhM4g3+u+BhE6OJsexNjsTP9I805Xp3?=
 =?us-ascii?Q?WVQeAe6s1qc6JSZYuVF/R/vVRxtuj7XEN26jSeU0sf9CwSqABlB7MynLKDBC?=
 =?us-ascii?Q?i31r82nAYwZdnDp3HiOBIN0SUTRw2z7xQ+zLkc+/5BNzx8yCiN9+ns7BSuwi?=
 =?us-ascii?Q?vQ46xzH/ErC+5wRHJumQGgPcQAENxXEwATYtnflehiYGCvtvE4Hy28osC/P/?=
 =?us-ascii?Q?OTbbEi4nDqvHYfQ4OrRbtFscuL32B+OJXY68BZIoWzhUuRCBMX2eHbIX6yl+?=
 =?us-ascii?Q?pgFMPJucqlNJCzMuFdFxlihVYF8JG1voJ8AvpGQvExiODr0iTsDX6TvMfAs/?=
 =?us-ascii?Q?WS3oM5kQc9MWEM72r2zofCYhjd399A4QsNgpRAJGjrQLMSgnF+bl/78lkLCb?=
 =?us-ascii?Q?piWO8V9Bjyb9QmRiZXsN8mSW6oyd8ubtUnSAMTWGAqFL0ZYUGDZTXftZ2Oxx?=
 =?us-ascii?Q?pSUsxRluV9+tqwrIX0s7APrhW+D+ptJCa1CNM2K25cpoXwsI36O1yY6VXqzo?=
 =?us-ascii?Q?KQfR1r/FUbsthuKTJBClQKRciF7e/7R8UTHpk2fsH4NAeTCf3Y13vpiA/1V2?=
 =?us-ascii?Q?HG8wSwhNRVLLODtRvu40J41VkZQKqdLxRTbZ1+IP/jIluNmIJTXMHhhQGZ+a?=
 =?us-ascii?Q?xmJu6xQs3ZHWXrtCDPSznwNDjCL/rpGS1XlMwAt9F1ScVeLslGBJGup9qrBN?=
 =?us-ascii?Q?4k1eDdErGtULSdlSGXNuGLPtc3LILY+Ca0rjUplUtKNsEUNP7wGDDFpEIV75?=
 =?us-ascii?Q?cz6D73CXd6TA4Qmdx9+3f4iCzmYcnUPpC9Y+LTeMlcLpEqJFLnngqlXDqhin?=
 =?us-ascii?Q?ro0vixFfJLjVemXwDCUpvYZSxgNlAZeG3mMBnqdjmHXScTVXobJyY8TFdODa?=
 =?us-ascii?Q?G0UJ1BfHjOEKQN9NKV5Ls2n9jNtHdUJ8Zlnox5f3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d4cf60-a0be-48af-1731-08da5ff92fd7
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 09:15:08.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDeR00u2atXYwZYWpfTyy3havPqKn8YDeCpGs2/X7H13WA1HuHrAfyqREwBHjlIL67D2Zusp4yWAlwmcpNbrTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3595
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the dt nodes shown in the sff,sfp.yaml examples so that they are
generic and not really tied to a specific platform.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
Changes in v2:
 - new patch
Changes in v3:
 - none

 .../devicetree/bindings/net/sff,sfp.yaml       | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
index 19cf88284295..06c66ab81c01 100644
--- a/Documentation/devicetree/bindings/net/sff,sfp.yaml
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -89,7 +89,7 @@ examples:
   - | # Direct serdes to SFP connection
     #include <dt-bindings/gpio/gpio.h>
 
-    sfp_eth3: sfp-eth3 {
+    sfp1: sfp {
       compatible = "sff,sfp";
       i2c-bus = <&sfp_1g_i2c>;
       los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
@@ -101,19 +101,19 @@ examples:
       tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
     };
 
-    cps_emac3 {
+    ethernet {
       phy-names = "comphy";
       phys = <&cps_comphy5 0>;
-      sfp = <&sfp_eth3>;
+      sfp = <&sfp1>;
     };
 
   - | # Serdes to PHY to SFP connection
     #include <dt-bindings/gpio/gpio.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
-    sfp_eth0: sfp-eth0 {
+    sfp2: sfp {
       compatible = "sff,sfp";
-      i2c-bus = <&sfpp0_i2c>;
+      i2c-bus = <&sfp_i2c>;
       los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
       mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
       pinctrl-names = "default";
@@ -126,17 +126,17 @@ examples:
       #address-cells = <1>;
       #size-cells = <0>;
 
-      p0_phy: ethernet-phy@0 {
+      phy: ethernet-phy@0 {
         compatible = "ethernet-phy-ieee802.3-c45";
         pinctrl-names = "default";
         pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
         reg = <0>;
         interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
-        sfp = <&sfp_eth0>;
+        sfp = <&sfp2>;
       };
     };
 
-    cpm_eth0 {
-      phy = <&p0_phy>;
+    ethernet {
+      phy = <&phy>;
       phy-mode = "10gbase-kr";
     };
-- 
2.34.1

