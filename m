Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8CC4D9B50
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 13:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348352AbiCOMfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 08:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240188AbiCOMfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 08:35:07 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140080.outbound.protection.outlook.com [40.107.14.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780176331;
        Tue, 15 Mar 2022 05:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jauMWT8rSowqv5LbRAGGFTz3h1tp604JYb5ypLdVYWTSSFYwN0T4hAMaZFZv2kH1B3LiWgkqM3ZZsVzHOJYLZVI6Rk6hXs8GQf7KTjHwtCajOO2yv+QV2iJQmHo6SasXxOOUHVtXR+yXilE2yof5CdNExc79ymClCmk5+1xa9zN547Lb9bNJVFVnQ8oFyu8Twg3DsxD2XHvZJdM9TPc5GRCXQy9Lgw5GJjaTa+RUrsQwGs/6UR8LDESoQiLxGMT3e/GhKm0CB1vnjOHcTY06Aq/nU1H29ofRxnMtkin9x9XpCTUsKuRib2YSYlOfVxBcPbBl1U4db87jh9eO9rF2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeQPgoyVdLBRVS6O55Pdj87hjwaEfbO188RniGhuyQI=;
 b=Ks1diVErjsVRguNskaTrOy4LxiJxeyun33Jtm8Gfp2HzC9R/Ixra6eYq4xypRThIH2ICYlraaLzPRzrvMVCylQti+O0OCIGwKS0yDkGASxspovt8vCHyJG2M2wmU9O2qs7pgSFXb3e+EC443YDu/UavWCajK92ukXWc/QulnJhMGJy7H8ig4qokDFgWvhYp8Penx101pAdJNGLPSDJU1TCtyB2GIhpFxQRYMWrz4iXOC8iXf1j0ep3CCHP6L+I/d3Gv+I68cmU0jEOhkEHFPc5F0NJ5mAaLlv0zr8BzkQEwcrGKNTLixlk3Q4ZFj/r3B25qUYVfLJKwE9RJK2sT41Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeQPgoyVdLBRVS6O55Pdj87hjwaEfbO188RniGhuyQI=;
 b=CPyAmNgJDIInvR0+4OKyU6hJIAWg9jLfzEZ3xx0MtfJMQ9qmkSJqNuYEOWNBvG5ZEkEbsQsusV2cKZbxHuK40hqeRf+Idri6PuINa5jypUHpTjvOtQtlfzNLnCQJ5mzYLqitp5S/GTjtXQjBLmaqbYJkmlngPCrDUVTc8fqoG2I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR0402MB3504.eurprd04.prod.outlook.com (2603:10a6:803:8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Tue, 15 Mar
 2022 12:33:51 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5081.014; Tue, 15 Mar 2022
 12:33:51 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, robh+dt@kernel.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Date:   Tue, 15 Mar 2022 14:33:15 +0200
Message-Id: <20220315123315.233963-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR04CA0084.eurprd04.prod.outlook.com
 (2603:10a6:20b:48b::26) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c48b493b-6edd-4ca0-889d-08da06800fa9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3504C610445E68C7BC48806BE0109@VI1PR0402MB3504.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: orMX73d5uVn4gPXFhvL7UaHTREts5ZtCltLMKAkhINX8hj5xuLXZM5LCFKC+Yx+tU4soRow+4Ngm/qApfuXXsd/xHIlIz+yolqItjReUhp05XQRmEWJruuiquA+eg6Fb7k/We/YTs4JhR/1B5Uiq4RXu4xxPymn6FxVw/XCVXE1wS3OPf3tAFe71CIS7wtI8iuMp18n0WW7s+u2ZCQKokek2OTLQEsB6RQrrnW57TiZ94f7gn/OYjMvRF3mMZvk25DgJNBLxBsQfH2knfnF8Is8w7JXUtfSEnNU9RyYLEEC69UsG1d+lW3NEWYMm/F2wgToXS7otFlZGBroplLETmm1y/u7uJ31/RaJDxRI11rAWLZoxuOO5upRYENFsqEJeefb2LtCW9xz3KHOn/dV5DaaK9tsPvLx/Xfw7ozGKQ/8rzt/S2r3aXjW0Mwsa3epGaSKoIydvXXVtqu3Uhe9GWGXrDWFl5spVBDoG3pkcM9CDpyteezuaLm0uUyU7EkdRByvUjdYrBfj9qfsBai5a/dEmON6Kj+ofmPgG5J7Qb5CbZOnzSu/YYgd4xOwJms7XWVir9vmcTIQyV/GniqSqqc4zzJbu+ovqBx8+BtTwKjvQzDqM9B5J+fQJOfZURRPVmnAxK52jFxf5kTvr2Hlv/bFLhIqCCLKe/zBHKEI3VGFZlrcBm1lqUAP3i2WUo/JNglea1tr7Vh7ODGlQ6V7l24u4YVydlMWY5RIaF6pH5ViGtrCgfUiChFU+JEI11PBTEvAQQ0tbrTOWDJ5UTSalqI41FUj+8qhP75LCYsZCRHE0BKuJQ2rRAKj9yOB7OIXRe99vLIR0W+fKQwg3UQoAiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(38100700002)(83380400001)(6666004)(86362001)(66946007)(66556008)(36756003)(4326008)(66476007)(6486002)(38350700002)(52116002)(2616005)(1076003)(6506007)(186003)(26005)(8936002)(498600001)(44832011)(6512007)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+dAyt2WEf84u/16gnd6hfP5AQVLpCzL8vi5kITvE6CfvC6BgaIWEXXu7MIPh?=
 =?us-ascii?Q?W5ZQTpZXpweCWUbs+5UHqx5S8Lwc8VvMCUMDeKCdSFUKbNqJ/vSsvJZSwAX8?=
 =?us-ascii?Q?4hXkQXAG7vXTjW3Z1uAMm2+CQYuG4XEIaxQQQsbnmByN5+KgvXgwdGOVcCVk?=
 =?us-ascii?Q?uSZqAOF7P8QdEbMhzu8eml8eD9SZ6F1DwbXmJgcfy+YQmYx+kILm6/6U0fzk?=
 =?us-ascii?Q?bHvToc5rq0PUOeIyJ9wsBAwkVkTFU21ML8jrwHTyWrluYWhEmOML2HqJ0ZhV?=
 =?us-ascii?Q?0KPCEKfTcJCYilP7ROdU3WOPiBjjmcEDaA8O7rF7gsK8k/V7NJ7Z9jbhu6oV?=
 =?us-ascii?Q?CgkgSI8/nIC+SXdSznzDhgLfRW2h7i0HOdb+E3hWVj0TKLftMY7GERFrJrfS?=
 =?us-ascii?Q?UEZuxADOIFiC7zMDwCfjgSKI4pcGgY9PajxTmRvLyW0BcM+GNbMxkbnMn9fl?=
 =?us-ascii?Q?/TXSFWut0ePAnqzS4LtuRpLJ1vwGWFP+lqdG2Q/7ajl6SiNMY29OzIaVC/PC?=
 =?us-ascii?Q?HODTuFR9Am3jdxECJBhvRqDyFktjmwmo7lBPq3TNY9QprLDcsEeOLtXMyFtX?=
 =?us-ascii?Q?zCwl5pA2UJqhGCs0t9bGWcS/v2cX0mhJKgS5YdtPfDsHQrFWoHqoITi5zm4E?=
 =?us-ascii?Q?lvckeHASlbnHnFTXAX0r5HbH8gP/5V9ojPOA4xI0Qq5p9+YriQU+HUt+rnmB?=
 =?us-ascii?Q?mvhrykKeK+ehsX1TkKOYJVuyX6pXzwopy24R7wJPPCMOxx4vWP/QR7YkZjRx?=
 =?us-ascii?Q?t+VKfFsS/ES0gWIz0UzakXqwGDa2xuo2M/V03/Y8Dm9NMrfygm5L0S0UiBSx?=
 =?us-ascii?Q?rRYonkAJGw/PzCbNaMjDkKlfmBUdli0IwLKmf/++jN8DjbQwKOIS8HGaR5aS?=
 =?us-ascii?Q?GPrT43n7AS5KjoyY28LnsWh2mUw7/KlD3QFFnkSMBQ6rk9GAX3gn3F9KugUs?=
 =?us-ascii?Q?w0yygLl9gHh7/TyxQGySbE8zPUuv7ym2/bLmF3TcBRvTJATCTTnOtrTvNplk?=
 =?us-ascii?Q?q2NIx4FeHkyYMcWXbQakb+mn2Scecwb8y2uklYxrLPijoCTrawQy4+Wodjz+?=
 =?us-ascii?Q?AmtEl8Pai5eFU5Q86erkiJxhg7EEFf9NuKtxb8tuIdjS4yGCrmvULY++tDlq?=
 =?us-ascii?Q?4KaWFsRfFbgHi6pTFpD8nLLnjjNRRo6LttoOlCoi/2fru8dGHp4X97jzengt?=
 =?us-ascii?Q?TGd0DggBnStDcwMOlqndH2uR3oBgzXcV6v4wDPBsePUMJaw5ITe3HbbRcJP+?=
 =?us-ascii?Q?Ek2u9+1Db9T+VYnAYds6qP3mK3h8EAXNQxLmLGH4BWmWVGZr910KuRVDzJnS?=
 =?us-ascii?Q?2GH0qRp1c7u1LZ2Lf+yjIfGGgbh1wY6bZdOpbw0WZMkkWV4+CqMibNOOrJpa?=
 =?us-ascii?Q?haj4wiAKWrZwU25raK0ajQGqARZj24Q3+E3dproJ+cC/kGP0+cRjCBWHtiDR?=
 =?us-ascii?Q?N87Yt+m1DjWo3bzl9IpXcZgwajKf3WuVRyN6VsyKgsCSiFHQJmByKg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c48b493b-6edd-4ca0-889d-08da06800fa9
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 12:33:51.6414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POyR3ln+hHNJSdg/g7Hw6bTJBGGjd1bvlb/yTLBIKGM9m4jwKjHjTU+qmCGYb+nD/H0tBnveIoh74fctukTT0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3504
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../devicetree/bindings/net/sff,sfp.txt       |  85 ------------
 .../devicetree/bindings/net/sff,sfp.yaml      | 130 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 3 files changed, 131 insertions(+), 85 deletions(-)
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
index 000000000000..bceeff5ccedb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -0,0 +1,130 @@
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
+  "mod-def0-gpio(s)?":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS) module
+      presence input gpio signal, active (module absent) high. Must not be
+      present for SFF modules
+
+  "los-gpio(s)?":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Receiver Loss of Signal Indication
+      input gpio signal, active (signal lost) high
+
+  "tx-fault-gpio(s)?":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Module Transmitter Fault input gpio
+      signal, active (fault condition) high
+
+  "tx-disable-gpio(s)?":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Transmitter Disable output gpio
+      signal, active (Tx disable) high
+
+  "rate-select0-gpio(s)?":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Rx Signaling Rate Select (AKA RS0)
+      output gpio signal, low - low Rx rate, high - high Rx rate Must not be
+      present for SFF modules
+
+  "rate-select1-gpio(s)?":
+    maxItems: 1
+    description:
+      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
+      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
+      not be present for SFF modules
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
index 1397a6b039fb..6da4872b4efb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17498,6 +17498,7 @@ SFF/SFP/SFP+ MODULE SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/sff,sfp.yaml
 F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
 F:	include/linux/mdio/mdio-i2c.h
-- 
2.33.1

