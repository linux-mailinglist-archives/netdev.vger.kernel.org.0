Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7513B569E5C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiGGJPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiGGJPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:15:11 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE4A2B1A9;
        Thu,  7 Jul 2022 02:15:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nayzCz5xqWdgTl0YKxtqHIkqhuN3CdSkO3T1DDZDcqseqjydp3qfqVz/1zhMbNDkvode8gyWoWaB+4xfI+wkQj4mg1xx86drHWQLad0lXmapw3ss+s9tzWBmn9tZiOtG+iJTv2KQGL6SKotvWz5BcgjsGr7HLtMLU8DT6z1q0r0ag1GUjkmOVm6FCSAPqipC1mW88c20+QJGR2lBCb+u5v4PcbE2+6lNynxqDtUzgS5U9O2hre5MPT3p1B7GjRFktBuzVjDkbK99FaN+iibVZUtxdFFv2qRTiIgtak0/QoQXw7nlLLOI3hfoTtXe096OfQwbii/fFGW3PvGhIMHj5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIyqMkL0LFFo2qbLi3yvizNjxhFt/dxfOhl2B126ioM=;
 b=li6UMQouakXghLI+OYMXe/cRQog/qIy2nvUmoLZ9hlzBGhHQwAOXCb7WD2QsmEVEhimqaTsx5GbbNYxWsMUXSDHoNdU/kpqexmbiAfsfnb6mEiUdVEqzrF7vleWkjRpm+/lu9XvyE8vY1Odag033iTKDab1ZdNVFkjHeB8+kbWRtYYyQC39JdTtfHESsEus3Ghiw1zNj8VwDAEVuZgo2XMFLvFM2yqgf/Eg3JwJM/EUvdQqSeAlv0eH4S4zeHYhOQblaVMHN1V/7m9mYMR7mfS8XJn+adeSM1XEws5EXJ3WjxojJ8FuEQbU3kuAowHmYg/7/ss9E+MsqgUwUYaVJSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIyqMkL0LFFo2qbLi3yvizNjxhFt/dxfOhl2B126ioM=;
 b=bn5TX4EK9oxosje+PfhjBAZFhE1aXMPD6RMdFsYajYjGa6/xvrZ9jGhOnzlGgOwHdMTSY1Hkreh6bKZHPBChlT3RFftOopX0NvcNczoIGSzkRcLlitzzP4381vhyLNdyf8N9IUZNR7r93wk0dAXu2ovzgsSyGthDBq8j04plZ9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by HE1PR0402MB3595.eurprd04.prod.outlook.com (2603:10a6:7:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 09:15:07 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 7 Jul 2022
 09:15:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 1/4] dt-bindings: net: convert sff,sfp to dtschema
Date:   Thu,  7 Jul 2022 12:14:34 +0300
Message-Id: <20220707091437.446458-2-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e6d879ce-ad5c-4910-2b31-08da5ff92ef9
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3595:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+V4I+nU1LdFUEHmJt0212rfb1ACqHZlaWSKuk1dziTdkCfNlicM3Qw0nrCUQNFj6auUv01ZeimE7o3dFd5hNoATq5Nhtg/aT1SRqP+dMwc6XKbqt24wcTadlYa5vhXff+irFevp4zQWh5gempBJi8oT/6W5sAhiHmbYo13FEf4kPHPd4yfY4+KpLUr8/MOQv2nM4mz2UqbaORva9thfv77HJGymXmEcuPldfFFuWYoh0WsQo+YsY38h99LlW6tCGzKbztTJU8LN1UCVyTpnFAry6Uf5LZ5UoLtluJXEGPWYZ5Av8lKJ4njNqLxfU3bDrPZblqZt49UlsR3jnk0BdjfDjawNLMY7aprPO2Tj1dbl8Ij8tN5PKzGBEc+0T83vZisOFLaD4D9aOGd9NplJgvAXHwhuL3UGsVTppiAv553g+GxKwTDGwzyIOcRxswHGoPYkuyuB/87xD0s7mxYdrORKJcEdaWkLNVHsb6QXEdLsyB+lhvEUjTZphbG4HK99akgSVOtRmus2IsPjAUQ0wuVNn6yGkAoGBcKtDDCfNFLZIJXgL7GMXwKtyFg4o+En4BE8S6thF9bvwmtfWv6RQEtv2PM1Jga1PkH1xdGLu1PWYPmf+evl2jL9XhY3bw/D8q+0LXTG8eZhbLX+j/m12hOyWTJ6DCDr8I3eFygdjtWgxvoSQJ5M3yJ6bZ6anxJVUMKizrEpGsdgtxwYAZe3GM8AWlW1v/u0gvGG8aTBx/HuPJkIHLhVm059yh74KNM1G28HEiRBmSV48poBovYMcYZEzb0z9/CegqhSJ1ytYGvklR5RdPOzFl7xGQB2X6KekWbeafD3eaNN25W9kexQeN3CknfsDH/Y0y2YOED05ktvxZ2NeZW2agHIroT0IhkJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(316002)(83380400001)(186003)(26005)(36756003)(6512007)(66556008)(66476007)(6506007)(5660300002)(86362001)(2906002)(8676002)(4326008)(66946007)(1076003)(38350700002)(38100700002)(478600001)(6666004)(6486002)(44832011)(41300700001)(2616005)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HqOc6bVpJyX0B9CPiIer44T6ZFUHGS3qRCdOjMy/uAkNuspw9WbrTjH0Q037?=
 =?us-ascii?Q?vVWJJJZ6KRz5utiQhj3ZO86chEOpAn+HYXpGX+5kP1XXtXQ11QkQCxIkwpey?=
 =?us-ascii?Q?UONUVD80WrXjlUdt6+x52DAaL5T7mu89G5yDqdAoB+K6ZjjA3BT72SOV8o43?=
 =?us-ascii?Q?a/x994C6rpp1JtfwSvyHCbFKUE2PuqVKtK1UA+hbueHsIxCEgsFY9cIiNaE5?=
 =?us-ascii?Q?YeoIsgoJHgcOO1Vha++ZKoVfwmz/opsaG/cq05TKXXCcCpukGJaU+q2Rru7p?=
 =?us-ascii?Q?jV/Zp50KosQiVPtedYQgadnEEyguOva0JSd8abQjBc52kDAOjIov8GdjKnS/?=
 =?us-ascii?Q?lgkoIw7vKmlexx2ZBgeNnOENkFXD+JKivkCv/Oxp/ebi6d7QAU0MtqH7FTGJ?=
 =?us-ascii?Q?AVw4K4tAnieudKeW+B0MuUo6Ungu/sGV5GPv/0t/RQehkN134nk2VHJakxbd?=
 =?us-ascii?Q?+F7bNOrl/w6JWDpgULuWrn9w7C+/z772P3/JxbKwn505Rca4op6BIqlZlAU/?=
 =?us-ascii?Q?rJrEzGfvYK1RtlZ6dUG16XHey8rFxML4Nq6sC5jzk8LJ523ejHb8HyNgEmJf?=
 =?us-ascii?Q?EUDtzW9d5KRRFWgCMTUvq3Tk+u1c1th/owuU6m4MD+lLG4qXw5GHpSwurI+i?=
 =?us-ascii?Q?MsAU4bgOY1gSfvZwU1iJZs1N7pD/pNi+cedcLXdUMWr8FKSXy+LfmDysuXoN?=
 =?us-ascii?Q?Lzn2k2aU4Z1B9JszvX2dnsF4ix9ZSmqC+S5hdJXvW1YCZOyI2+DBK1lv2875?=
 =?us-ascii?Q?QRAJuTDd7htN1ZI/0i+ebbcexUMQ09HciDj5t55OOm02sv888uMYvzRr8eVF?=
 =?us-ascii?Q?fBOyu0fwbPf1YtvwGICjLSI0fsTKelG2KU173u3M/Pu60oC8J3h80ZPVMdQw?=
 =?us-ascii?Q?FRj34swH1bVnZf8PTA2AEJd06hi0MZ3pCtPVY3CVp+XHtIErWCX7S32CO+c4?=
 =?us-ascii?Q?zQyN+VYwsBGPZbgm/befWu35GsU7AD4LkJ2BVXAKLRsYPBkS810CTZgvD23I?=
 =?us-ascii?Q?M/FYj4A6AZe+fpIVSNG17jDFg8JQIiwsUDyZGdN9IQrhOLmBxTXT/mJhqGTa?=
 =?us-ascii?Q?J1278Ibo3wfxdnmI0L1U1xlIWVpe+luu8GrIGgnIegco0Ign6Jt4nFRlg8+9?=
 =?us-ascii?Q?y8l+qRJoN/5JFSfF/eYEb8z3b99PWIhNXUhk6t+krdCYCM81+Z/ZsHzzJeRt?=
 =?us-ascii?Q?kxro7ADkDamexghgRbNIG2nfxLpTApIElY1FtGz+qXlM5Y+fwme237y8AsGF?=
 =?us-ascii?Q?1Z7lBacXcHrhx2k7U/TnWwGPk8z+17W4+IfWgRdfTm37L1qSvifXl319lUP+?=
 =?us-ascii?Q?SMbQkQ9tay861+5WCq8sldOVZOemBlg/qocRuKVGOpEXwhrYJle3NCg9H3ig?=
 =?us-ascii?Q?wz6ffj9btzjDwU6oWYQXhIfA1BYaU/5+fL95dCsCbTOe2B9QE5u4jlFmnxBB?=
 =?us-ascii?Q?TsIFgX1A1GmDF/yFWnEoqQdznm2jTjDakUzwN5BtJSXSjcptFP5ry+wNqTpx?=
 =?us-ascii?Q?BTs+r2c6cCLoFZa///GUgge+hf0AK3xSCm3hBQ0JP8xt1SstqpWIGUNto/so?=
 =?us-ascii?Q?pu0M04ZkQTTz26SGpLVeZMFDFYaXiXY03nrcdeiY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d879ce-ad5c-4910-2b31-08da5ff92ef9
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 09:15:07.1405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tul1xM80xS0HSHcS1A8Uhszs0ZYMFTH5hdNf63d6VKywnOWH3yg/KB2AAbt4lt4wmghH5ZEtHr2gvoFb7Be2A==
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

Convert the sff,sfp.txt bindings to the DT schema format.
Also add the new path to the list of maintained files.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - used the -gpios suffix
 - restricted the use of some gpios if the compatible is sff,sff

Changes in v3:
 - moved the -gpios properties to be under properties and not
   pattern properties.

 .../devicetree/bindings/net/sff,sfp.txt       |  85 -----------
 .../devicetree/bindings/net/sff,sfp.yaml      | 142 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 143 insertions(+), 85 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
 create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
deleted file mode 100644
index 832139919f20..000000000000
--- a/Documentation/devicetree/bindings/net/sff,sfp.txt
+++ /dev/null
@@ -1,85 +0,0 @@
-Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
-Transceiver
-
-Required properties:
-
-- compatible : must be one of
-  "sff,sfp" for SFP modules
-  "sff,sff" for soldered down SFF modules
-
-- i2c-bus : phandle of an I2C bus controller for the SFP two wire serial
-  interface
-
-Optional Properties:
-
-- mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
-  module presence input gpio signal, active (module absent) high. Must
-  not be present for SFF modules
-
-- los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
-  Indication input gpio signal, active (signal lost) high
-
-- tx-fault-gpios : GPIO phandle and a specifier of the Module Transmitter
-  Fault input gpio signal, active (fault condition) high
-
-- tx-disable-gpios : GPIO phandle and a specifier of the Transmitter Disable
-  output gpio signal, active (Tx disable) high
-
-- rate-select0-gpios : GPIO phandle and a specifier of the Rx Signaling Rate
-  Select (AKA RS0) output gpio signal, low: low Rx rate, high: high Rx rate
-  Must not be present for SFF modules
-
-- rate-select1-gpios : GPIO phandle and a specifier of the Tx Signaling Rate
-  Select (AKA RS1) output gpio signal (SFP+ only), low: low Tx rate, high:
-  high Tx rate. Must not be present for SFF modules
-
-- maximum-power-milliwatt : Maximum module power consumption
-  Specifies the maximum power consumption allowable by a module in the
-  slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
-
-Example #1: Direct serdes to SFP connection
-
-sfp_eth3: sfp-eth3 {
-	compatible = "sff,sfp";
-	i2c-bus = <&sfp_1g_i2c>;
-	los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
-	mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
-	maximum-power-milliwatt = <1000>;
-	pinctrl-names = "default";
-	pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
-	tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
-	tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
-};
-
-&cps_emac3 {
-	phy-names = "comphy";
-	phys = <&cps_comphy5 0>;
-	sfp = <&sfp_eth3>;
-};
-
-Example #2: Serdes to PHY to SFP connection
-
-sfp_eth0: sfp-eth0 {
-	compatible = "sff,sfp";
-	i2c-bus = <&sfpp0_i2c>;
-	los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
-	mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
-	pinctrl-names = "default";
-	pinctrl-0 = <&cps_sfpp0_pins>;
-	tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
-	tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
-};
-
-p0_phy: ethernet-phy@0 {
-	compatible = "ethernet-phy-ieee802.3-c45";
-	pinctrl-names = "default";
-	pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
-	reg = <0>;
-	interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
-	sfp = <&sfp_eth0>;
-};
-
-&cpm_eth0 {
-	phy = <&p0_phy>;
-	phy-mode = "10gbase-kr";
-};
diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
new file mode 100644
index 000000000000..19cf88284295
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -0,0 +1,142 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/sff,sfp.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
+  Transceiver
+
+maintainers:
+  - Russell King <linux@armlinux.org.uk>
+
+properties:
+  compatible:
+    enum:
+      - sff,sfp  # for SFP modules
+      - sff,sff  # for soldered down SFF modules
+
+  i2c-bus:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      phandle of an I2C bus controller for the SFP two wire serial
+
+  maximum-power-milliwatt:
+    maxItems: 1
+    description:
+      Maximum module power consumption Specifies the maximum power consumption
+      allowable by a module in the slot, in milli-Watts. Presently, modules can
+      be up to 1W, 1.5W or 2W.
+
+  "mod-def0-gpios":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS) module
+      presence input gpio signal, active (module absent) high. Must not be
+      present for SFF modules
+
+  "los-gpios":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Receiver Loss of Signal Indication
+      input gpio signal, active (signal lost) high
+
+  "tx-fault-gpios":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Module Transmitter Fault input gpio
+      signal, active (fault condition) high
+
+  "tx-disable-gpios":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Transmitter Disable output gpio
+      signal, active (Tx disable) high
+
+  "rate-select0-gpios":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Rx Signaling Rate Select (AKA RS0)
+      output gpio signal, low - low Rx rate, high - high Rx rate Must not be
+      present for SFF modules
+
+  "rate-select1-gpios":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
+      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
+      not be present for SFF modules
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: sff,sff
+    then:
+      properties:
+        mod-def0-gpios: false
+        rate-select0-gpios: false
+        rate-select1-gpios: false
+
+required:
+  - compatible
+  - i2c-bus
+
+additionalProperties: false
+
+examples:
+  - | # Direct serdes to SFP connection
+    #include <dt-bindings/gpio/gpio.h>
+
+    sfp_eth3: sfp-eth3 {
+      compatible = "sff,sfp";
+      i2c-bus = <&sfp_1g_i2c>;
+      los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
+      mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
+      maximum-power-milliwatt = <1000>;
+      pinctrl-names = "default";
+      pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
+      tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
+      tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
+    };
+
+    cps_emac3 {
+      phy-names = "comphy";
+      phys = <&cps_comphy5 0>;
+      sfp = <&sfp_eth3>;
+    };
+
+  - | # Serdes to PHY to SFP connection
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    sfp_eth0: sfp-eth0 {
+      compatible = "sff,sfp";
+      i2c-bus = <&sfpp0_i2c>;
+      los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
+      mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
+      pinctrl-names = "default";
+      pinctrl-0 = <&cps_sfpp0_pins>;
+      tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
+      tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
+    };
+
+    mdio {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      p0_phy: ethernet-phy@0 {
+        compatible = "ethernet-phy-ieee802.3-c45";
+        pinctrl-names = "default";
+        pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
+        reg = <0>;
+        interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
+        sfp = <&sfp_eth0>;
+      };
+    };
+
+    cpm_eth0 {
+      phy = <&p0_phy>;
+      phy-mode = "10gbase-kr";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32c4708cdeb9..d495f6d7c2c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18109,6 +18109,7 @@ SFF/SFP/SFP+ MODULE SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/sff,sfp.yaml
 F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
 F:	include/linux/mdio/mdio-i2c.h
-- 
2.34.1

