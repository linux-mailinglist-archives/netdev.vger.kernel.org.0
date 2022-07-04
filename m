Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6D05657A8
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiGDNqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiGDNq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:46:29 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8249F2711;
        Mon,  4 Jul 2022 06:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy/LZ+g5unv7tYK6JBQ4vIkSBwcuXjZmasnPw5GAJJfM9KRHttFhQ0KVJXVk/ifQQgbcshg+Koeh8y07aO3INq2NAvVcS9STksVVnkGy9S/VHtyr1aI/3ayL3nONJIIyAPIYF0M7zzF/vmcFamPO9XRburn7A62Qh57yEYiOPH0S9/RVqZFL9eqrUWtSZYssbJ5WZgh2CHn0x2ZVYOqAgX0uJPDFP5K3MXFLUBcEzfHcKXiQQDkEKQdoLAtRf4L4eYxkqYj1AOVitfW5j8iAm7981FkTQfE7pTZQBBsVnWFt6hzGkjp+sHYUuHYEIxSxYzV0EJjRK8HR5T9uNzFUaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgU2rC+Vlb1slWks38dR15NVowO/dWr3lfWHeT1M35A=;
 b=Ll16JN5jDjgow0NTXqtY1iWwPHNyHISRhABtDKwRrI37wK4T3Rx7d8kpUDhP6kETUoMQGpWyyXx7hwibt8A5YeYMaJKjXvzyo0bdkayF7GvgROHVSOdFqI4+kkc3qjlcaDjKXdwF1lcVk5cjWvIvAVwPoX3GPeVZz5uvOguAVuoofx7XELDTOGW+ZKdETlGsW3dUiHCfyGJYhRUZbxH8TU0F9+FrXNfHgZJMl7GQJCmHDECM6QOhNCAqrjWVM0Vm43MMw1TQ1l4Atz+SPm0IGYxNKsECG+VbasjyeqitwGz0S61rxloIETjiZ0FcHh5gTpLFRWbzFBL9+yygaTX4Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgU2rC+Vlb1slWks38dR15NVowO/dWr3lfWHeT1M35A=;
 b=Ox2GKiSGIlNdl14ivJt6xoD227kBNi/XiO6w23mzFrmouckdSi3XbdD2iKsvb0APFyQlyL2KFHrMCSkrzd0ro0G9q1Bcn4RzCZeFCEiGoSMR5BwSeHftaoHVJevwe03SVRoqUsp0q9hyd9y811YkTDzjHdAWhZJFTbTeKu1QHWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB7887.eurprd04.prod.outlook.com (2603:10a6:102:c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 13:46:26 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Mon, 4 Jul 2022
 13:46:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 2/4] dt-bindings: net: sff,sfp: rename example dt nodes to be more generic
Date:   Mon,  4 Jul 2022 16:46:02 +0300
Message-Id: <20220704134604.13626-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704134604.13626-1-ioana.ciornei@nxp.com>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::20) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bee783eb-cafb-4b80-26a7-08da5dc39749
X-MS-TrafficTypeDiagnostic: PA4PR04MB7887:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sWdgXWmLs3yVkzvpflVs4VstNdS9ZTslcZ5U3eMD9ZgiQnO+7cL5OlA/dONhO9CuJKwpLWbYSCcQBJoE2KEKv/3xtasC9pU36653TXR6iW7Dr+JqnuTp3V8XAxhwSHO/+C0O/2qN7F5lttIyGFwzXtof10o+jpAZwTu0fpL45kWtF/ZnN5WqhJ1+4/6IMD1VrejP0zHT56r+nG8/XCSWJHRsl23UL8JEP4Cuw6csC93nN+PdJI3ZbOvR7dHo28WeVaMiMDLQ7IHSYx4MMWoOLfoTG79cAK4zTANnmCkCeD69z7WPvxlJcOUd6BVxTrTT8C4nUXE2OdbsN0aMkLbAFPXF9XGz5vTWXPYyhjPrX9oF0rYzc1TNokSBDK/m0i+6Fsb5yCq8oO88Boy88/svjcSQrWBWG8ZppJlyt2yAjLTQ5BGUL5k6+ew0FdlBMspiUFhs89BHHAzIAWDms9moR+rQKV8ffspICnchOGf/tgjV3+CFwqbnsH6/LmFDXwwtVjf7gsN4mqbVlNZesv3cfKnPasYpWdXWlFH0StSYtUl0aTWxAk1YFO0cEkdpnhhaEKlfV3M6a2cPOdI5FIu0+wt8VFBldeIUhVhClegRFHG5itw+g0/mtfivY25U+DS/YuOnJmABN0e5CWqcChQ0OjbUEiIhCAkVMQuZdbkv3yJ1OSvEg4orxfhj48Mes2xbiwKtns5CN3wjnshI4Bj4y1PzC0PwoC2fOz56tZ7ez56Mjg6Xw1o/imPB3zbqeKLfSw6JnjXNN3dR+VU7PlcInJRJ9+NoTxLA+yHwxK/rbIoDiEl5Y7wey60GscKb0tmROMpzCEsvGpuPAFeoNbr1mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(1076003)(4326008)(66476007)(86362001)(66556008)(8676002)(8936002)(66946007)(6512007)(2616005)(38350700002)(38100700002)(316002)(52116002)(6666004)(41300700001)(6506007)(26005)(44832011)(186003)(478600001)(36756003)(2906002)(83380400001)(5660300002)(6486002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KCSLhJ0TuGdjjWWwwyzqdFIGQ1oCAd0KaBEaVmR0AjwQWWdNLRe0ESYqdQky?=
 =?us-ascii?Q?KareqGoAj3q+hZUOxZlJ4RM/+b6nvp7b25Xr4gYnX8ykk8fw17fArw6lZl8t?=
 =?us-ascii?Q?yBEvRjVBsJH0f9ewSsJZxD0nEhiZfs6MBgRJpWNYMhjlARxBroosEDxb4ya0?=
 =?us-ascii?Q?4I7+q3JtSo0EbYwIRj0yzsgjHvpx4lDiu709fxHO7WYtcKhmBwWbWxAzWbFR?=
 =?us-ascii?Q?6n60VNx+JIeIVs71fcmb0EOLTndpV7PRA3/h+yUaY+f/Umx4KQJ08YZpGjdV?=
 =?us-ascii?Q?NgJhiPl24NKpVGjaknX6jRG+DvUsUxrnsDrnZWPfy3Pr1n5tM/3QPSC1Tcbf?=
 =?us-ascii?Q?5Tz6dsU+Niv7ikzXKa3+4LE+EdkjfYkkUFtB/wlgYlXQlxkQUwG3u9YRt9Ec?=
 =?us-ascii?Q?+eYDeoebntocfuhi2Xa0JK/BdRNivcgXzLuHyS+XqKfIAVOYMq2yderVaX6h?=
 =?us-ascii?Q?qApQ6yq6EJrTkPg5zwXBJHeVaAsJoLj34GRGfDsa9M0q/7qvICG52mLMnMHP?=
 =?us-ascii?Q?y4cBElXWxAhEsOQOlabiSi7pT5wqTAdT/IRJng6Zy/pmpcO+UOPn+InGHR3s?=
 =?us-ascii?Q?RIQVOECGNPT6DCEqF0FMiVMxhtI1RfPzx2pa2sPpz4Ygz56s37S17VLApI5I?=
 =?us-ascii?Q?NfFwGKLZeNXFH5reZY/AG2jh+r11qgMHDWT6j4x+RQ6Q5oXnamj/QMPa1G/0?=
 =?us-ascii?Q?NZOJG5ExBLRPCqbpMl1Fm8Pd83o5B4bfUqi0WHLWd+YmpYnIfEEfJV7e15tT?=
 =?us-ascii?Q?FpoeprXFDHIDMNjb2AG9cjanWIkshUwGsGjKO7RIN9uGHQ3p+RZEVxR3Cfr5?=
 =?us-ascii?Q?fasGbdpHCEjVdCK542f3JHEuETtPpIyNBdo7+WKzOaUTqRTPSPZg6EDtomET?=
 =?us-ascii?Q?MhCaM4bfiQ56F10v8fCXST7dolgF5SK2HH7nlcu+ib+luOkq2ciLUhbSQEV7?=
 =?us-ascii?Q?ndO5OpgjFmKrtE2qzCKXWIKY4KAzDcSf0B/RTGiZsh8yXky662vA47aZZNZy?=
 =?us-ascii?Q?m/hmnxMav88+f1z8SDH42IALK2MNlFKrPD3duMzROn58qT2zuvCJIUrhENcv?=
 =?us-ascii?Q?78jjvrp0c3D/oCbR2h2vzih8CHjJTwvhdirQeuB3ikW52Xan2NEjy0eMB3QV?=
 =?us-ascii?Q?fjRpEoDVmLXP57+gUiUDVId/F8CIaJfPRsoBeDLXNxONZKzJLctw7pwW7Jdq?=
 =?us-ascii?Q?eI8QEabMY443VPKy5BR9zMMLh+3JCvB9sg8B7hZRwrUnCs55soosxA6IVbwe?=
 =?us-ascii?Q?jOsDHE+4NLgoMZsMHsn9MV7Xk2jLkntOhGrH42CMu/gaCXTjj3lT62Y+1jto?=
 =?us-ascii?Q?+Gw4aAwbzrYEoTJUKM8ULk9Zkshk6K4Ygby8nT26FSvyO4IFboAYIL/z2g/6?=
 =?us-ascii?Q?VvYOGunvlTqCG19NyPHz14X1feGRqh58W+KdODtMbuyXo3mQViESm4VCUCvY?=
 =?us-ascii?Q?0jg6IpShso50onjrrQHICQMMuzNfhjxSipqb+GKYprPXae7SGQgCeoPIetVW?=
 =?us-ascii?Q?t15LN5l4fK4ujYjWrDPyFdLMcg8Y6qyvotOnn1UunlPMBb/+OBKkTeeJAoj9?=
 =?us-ascii?Q?1ZLnH3BunsHnAf/JdQWFkfyI4pZYuAUy4TTpsCoc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bee783eb-cafb-4b80-26a7-08da5dc39749
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 13:46:26.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlFqO3zUISMpmS4BCrC/tzFIR9JRtGeA8StgMRW29if7bE3H3TRp8kR2GT3OVg5hfijMHg2rOpjrAgYIFTHngw==
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

Rename the dt nodes shown in the sff,sfp.yaml examples so that they are
generic and not really tied to a specific platform.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch

 .../devicetree/bindings/net/sff,sfp.yaml       | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
index 86f3ed2546d9..e309395ea7e7 100644
--- a/Documentation/devicetree/bindings/net/sff,sfp.yaml
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -90,7 +90,7 @@ examples:
   - | # Direct serdes to SFP connection
     #include <dt-bindings/gpio/gpio.h>
 
-    sfp_eth3: sfp-eth3 {
+    sfp1: sfp {
       compatible = "sff,sfp";
       i2c-bus = <&sfp_1g_i2c>;
       los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
@@ -102,19 +102,19 @@ examples:
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
@@ -127,17 +127,17 @@ examples:
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
2.17.1

