Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328315657A7
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiGDNqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiGDNq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:46:28 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564D2271F;
        Mon,  4 Jul 2022 06:46:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd/scuRrR4nckZb53o5geMtMS0bgjulXAlpYoPpBeG9YjznT5vo5ezRmHi3oI6YxlufOQLp8G2CHjzk/mGuk4E8H5EVf5xOcej+hLzptWH6zc6rokvY3AmwHRWBIQcm4z1zIc5bwZEM6Mtcok0VZgm8w4a2Y0sHh4tk8Y2XQnG1Ca7+tv0DGJnvAm/LThALTRsQTqJNDNUmdVOup80Y49fqy0NTzQWsW+kLxhIlUp5b6uhXJrWy7h+i4HF86aVjfmpLWjVHkwlYdkhg+BI0q2f7r40isrqKOY9bp4LtAV9BPUHjZHCGdaUe/KrWITREw6RfAimVeJ77sjlPViRQxcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CdgqY2GUSOfcTZoX9EnWPtU8xHS6k7EAicMP1xcu30=;
 b=mNtKe0SyC5jUrs41oEleuPeHEIUQWwU744amBN9QhhSpRnuVaDx/pgg5AGTlcAY2uow+0ZSWIBcHtaiS/J0DBuqRO3bh2NLHkDlCkCY/mnTmmoEnR+ZFuwu3BICia2X0JVqwFtAjShRn2FtSgHsQCA2mG9z6ESgT1kNBCSKDNt80FqO2vKs05vz01yjHQjZTKgMTCPTAflULqUVtOTm9MQdTVpfg+smKM8E0UUGgFVLIqoQFG2NagXPnfivWaItajCQ/+5rlGCA4i7QZcyMIy5ut9vsju3MibKcR6ZUErkgWjGHZ5V/L52c79A+HRg3Ed8aZGahk174qDaUbRizdIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CdgqY2GUSOfcTZoX9EnWPtU8xHS6k7EAicMP1xcu30=;
 b=Q1OAAhs7OryJuDBQ6hV0SFQcP69hLKwazTrSKaAfJ3Crmpc4WLdE48ipOFEJfbz+JyzmggoyKmCTkbxTLTzp+yRbMCqMA2VIdVWMWc480J4zU/Nqqyglf5fcLhxP0DOsYMXyXtEmj7/RE84rjweStKA/SmrkKiElombpF01dthg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB7887.eurprd04.prod.outlook.com (2603:10a6:102:c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 13:46:25 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Mon, 4 Jul 2022
 13:46:25 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 1/4] dt-bindings: net: convert sff,sfp to dtschema
Date:   Mon,  4 Jul 2022 16:46:01 +0300
Message-Id: <20220704134604.13626-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220704134604.13626-1-ioana.ciornei@nxp.com>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::20) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb3e06ce-e549-43f0-e158-08da5dc39682
X-MS-TrafficTypeDiagnostic: PA4PR04MB7887:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJOl0FOoY5QnQ2qAvI9ymzWGUXd5kUQcmK3XyYTbe6XV/FLgIHvfQI3zrlq5Mt57isnBGKYgP/n9iCepab8wsqmpg28/xv4n8ORIk7bSROuY14AHrL5BenlH4rZh7Sfncn9ZC056EwnqbT82/6G8+T2l5RRuU+srN5XYNJKU6Ln9rX6LkuesdJ2Wv1UyeIDSp1kavsMie2/nxM3Y48dVq+BviCYzQdjn2hvGZDqF8YfDmRGyZ5qErQfQ+K123vm7PAalcpjsclyqfKzKc1WQm0RfjjFMpNYWNBzZYjIubsBfe9J/N6omyjjdy4d3RL2bhqJ/cX8e7dQsCLhfRhg6kRF+TrifvxRhIUwsVtueTtqjP6xUGiJfwfQoig+4LCbizNPqk3SeTBjtAzNlSnMapWRDneBXosOs+5RrlQEEF/jDaxQoAfVAEjCHBIbGVDPFTS9GOYrSHqBja9FnK08+2hysPxMjplO6FtINTYZYo9XexOVuZmnjUwcmtNTx9guGJhezl193m/oxE1xBm7cPB/Z3a87+OA6z8b8Unr5ypcU2kqyVzUjxhZU/FU26sRtxDes+V8Z3nTpNp+uudg+SJ9vH+VXrsq411q3BUjAdywItL4e2T4XTJ0T7RdQM3mg/+y++Dzq/ngsxnSips3/Y0JLCJYiSF9UgTYwjFnrB3QuZT9hdqrQ+aSl/tWyQOmIESS0gRXobwg2HH6GE0QadrQKZoFXWj8sjhYuQA9q4/9FzFEhqu+TQ91QU7bJBdIsZFUD3e+5JZbQITKh4/Wau5BmrI1Oimo1v6tRGAKmtIXnnWy5Bag8oeasnYE8/hWuV9bfmxsIRBYPjhVA3xRP5GpUBS7DvwtmmZ3L1IF3t6JDwBpeWis6HXWBlNmxQouA5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(1076003)(4326008)(66476007)(86362001)(66556008)(8676002)(8936002)(66946007)(6512007)(2616005)(38350700002)(38100700002)(316002)(52116002)(6666004)(41300700001)(6506007)(26005)(44832011)(186003)(478600001)(36756003)(2906002)(83380400001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uOtHg/oSv1T3I+eo12aUXSqBFHv5EuLOGS3Y8Uo2R4o1IXSbPi1YSyCi9oD1?=
 =?us-ascii?Q?YLDxAEoxpYO1CG93wQS6GJ3r1yo9Me9RoBqEsDE/3EcjJWWssFjaaMqiyVV+?=
 =?us-ascii?Q?Jplk/ktYLn73x85LpbTq67t8vkb7Ov7W3K6F3gd6rk5UUsEmmwK03/I231rC?=
 =?us-ascii?Q?FbCDVsvaUIjAlm25GxEIrrd/+0VNRoYvfdW9gd6/4WXJrnJDsxidr5nGLand?=
 =?us-ascii?Q?iZ6XyQwgjacKyDG/tPdHf3KWwUJ4tVZYX/Jf6JNvp+vEigVmt7VaV14IqQnI?=
 =?us-ascii?Q?02yRYaaPo8ONuZNx0BWWU609Almblcm0tmh8E3c+6MfEET6RwUhndsn7sfgI?=
 =?us-ascii?Q?cARNiSHf8I5NrFKeUgwU5cr2oFwL05hd37Oy4Dp+9V4tUw/YoGBWY4oSlnCa?=
 =?us-ascii?Q?ynY0jOmeqiGeYCxehp0egx8opjNCHrG3YP2WbBLmcgkEgMvLHwXeGOBdDKAB?=
 =?us-ascii?Q?Qrwrw+HkH0i1Qx/Zz+e5wpmVaxjcrKX/nVor5AjGr8s0BrYfmoFfZae4janQ?=
 =?us-ascii?Q?nvwuSBVqCI1MY/cKDGydbOnRJHJ8pF9US98RR3Z83zCTVd+MTa23bnao0CrK?=
 =?us-ascii?Q?FjdYOZYRXTXzfNkGCiD9p8gQOHcsU8qGswJRHe5jlotjULM0i81CoJsryIzz?=
 =?us-ascii?Q?VSnHyPbFY5CgeueP6oFZ7PnCjuljbTRfAmd0GzXjhpE5IIBzuw6ZfH0EUXia?=
 =?us-ascii?Q?2+XK/abKy2uGnrTf2IQaugdJXmRhWSb/r1Un/9YY7twBTUSnrrPqGfd59u8f?=
 =?us-ascii?Q?Oi+/tVdC2P/AYvBLpPUcGkelys26hmQZoXMJJVJWrc4IzRdB5e5JMdW12lF0?=
 =?us-ascii?Q?4Y4PbHbF8MdbMXlRYd33MH7pqsWFnvcSx6IbGSZWuWgl/6+MIMLQmBmtjVqs?=
 =?us-ascii?Q?jID7pvo3K4VwRGNkyhqnVGzq9J+QCGwWm0V6eK1AxJDLgHz4CsQj5jtULRpW?=
 =?us-ascii?Q?vOuq840l86Arhf06AV9g05nXxXfAcB9XO7e0nGEjct8UAekWdl/JvHLfCOVU?=
 =?us-ascii?Q?8RrWZP9wzmU/GxUWhsFmGxbqSpaXY5ODZhlkeEKZbO6h2onx/x+pY2Z04Z5N?=
 =?us-ascii?Q?9T4JJNFKKofommaYE+5dYvZA3/fz+ErF/DvmBsITAiUA0GPGdq3vMzFxiBrO?=
 =?us-ascii?Q?OUWlqP0OAM/0OeYPKmMh22gRz/AfqqoRBkQZspvNykDXT6kezP0VZ8QBOrq1?=
 =?us-ascii?Q?UFYN3IRu2v8mZYDH6YRnexVPL4llRJ0eYrN8vG0zgRy72tAtqlLJJrAv6sdf?=
 =?us-ascii?Q?NAVLdp4xQEQ5VAoZfmF2cUGWzH6172rXo2tO+795tFGqDw4dEtDq3gvJcRgi?=
 =?us-ascii?Q?W5CLI1JpZJB+ZoHWggLgGG+owWjGXnxKnqn/VsExlMIZ8jXAvSM5urCrp+VD?=
 =?us-ascii?Q?v+SGQ98C1dtHIUv2W7detXbJiNEvMjyu1u5vR3auZuMSIYjr7EBJSeWr+HdC?=
 =?us-ascii?Q?3rgD9u8wabHSi6Bd+Ug+gg/fAvm/E6/qeWpqtmYSO6aua7iPuLn/FydTQnis?=
 =?us-ascii?Q?j3frPTWVehfp+xW4kzazgs71Q81xNqLs3Spz8UtngSPiZWcy42+OV8epe8fu?=
 =?us-ascii?Q?Pnn2sx/vYIER5/xIZKz3vLZE0Ubztc8DTDkR2nem?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3e06ce-e549-43f0-e158-08da5dc39682
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 13:46:25.5601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qB39SdZFTEWfjaapS04Og49PktXbZqQyZCZ8OtGswR17ESyJXBlQrR9bbeZHNTQFgh4WHxuTcQtVWmPTcryalA==
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

Convert the sff,sfp.txt bindings to the DT schema format.
Also add the new path to the list of maintained files.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - used the -gpios suffix
 - restricted the use of some gpios if the compatible is sff,sff

 .../devicetree/bindings/net/sff,sfp.txt       |  85 -----------
 .../devicetree/bindings/net/sff,sfp.yaml      | 143 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 144 insertions(+), 85 deletions(-)
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
index 000000000000..86f3ed2546d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -0,0 +1,143 @@
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
+patternProperties:
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
index 28108e4fdb8f..8677878603fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18110,6 +18110,7 @@ SFF/SFP/SFP+ MODULE SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/sff,sfp.yaml
 F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
 F:	include/linux/mdio/mdio-i2c.h
-- 
2.17.1

