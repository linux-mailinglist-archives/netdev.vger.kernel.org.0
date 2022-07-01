Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DC05639F3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiGAT1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiGAT0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:38 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2118.outbound.protection.outlook.com [40.107.100.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DD645066;
        Fri,  1 Jul 2022 12:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0F16NPdnwSetez7DF4C0YOaZpS53I5lqd62NcgxKqtyDmWtU1CUPN0XFJdIBteXNI0jsrlOcQiKQd0793aWWq9D/LauD6v1H5WPpy24UiKBVcpsV9Qk1PH6ntaTswW/KFLgRh2tyFdrDy6yZgS6SPaaAo7rmDcf9ZmShr2rZAkJyNA4NppMsEXxF5xOJVP/6MgwfmGzV7qRxRfkxJvzL6NacMP2TETNmfgzM/fQgtCFKSBu3RiLxvBF6WMYaK+VeMDRjN4eyeJ+CIIEfKNS8OymoejXPgc//ab5mmcXcT6lQPALoxsU3Sd61cy6kaDxOSozNn4LSM7Q0CH19EoL5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BSmGThszg6xLfiUZTdK8//1F7SXvnoxwrOqKYbxAhNQ=;
 b=cEK5xufBibmzQZQ0NS4e0ZmvthvfA82TOJ+s5gx0ZZbSEvjGG/vZn/NYItsq/E1mRZ5TI3SP1yI6EtDFK7vZndWK6PKpvjULB2TPkjYfI/DBSmd9Py35+Te+UJ1DwT8QF9yw61O/VTlr3CzMBg88coA2uCNLUbVB0SSV/cuIQ2C2vXKeN4tSJwyc5KJTUwYJEZ/mM+Dq7HpO5MKU3L+z+xf3sbydgr1JHHs+r3G+LQPBWwg3kucw+ebKFkYIuv+giuAXmlP6IpchQ9h/3g3u1gBw4lC4Cf92/qsUicSfqywM9V+2f1bM00GWjEAQ41FFQlzs4PePx5IwUXOyooXzIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BSmGThszg6xLfiUZTdK8//1F7SXvnoxwrOqKYbxAhNQ=;
 b=h2Tpw8VV8QzGEZAiQk4pXDTXO+Mf7aDDt4K99T7//7N9W7tai74y8k5BwWj2sAGtVJm8IOVChPCrjRLMMoHlCFzJ2dJw5ddzg5u78wq4SjDu33MZew3EbOzmL2DVxbhnvKVx4kPA4D2eHzw8LR9yvJEnAAGuTIeeYeqypZi+qFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:24 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
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
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 8/9] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Fri,  1 Jul 2022 12:26:08 -0700
Message-Id: <20220701192609.3970317-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae1d78b1-40b2-4319-1899-08da5b97960f
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +0Qou8tZHmwpfmXYH88r8ORbmCJQV1nJDqS+185C5Ni4tFedavRO4Qkm/SZGU+OowKcaZQFeUM8zeq0LzPBLCCI5s3qWZlqdXhVhYH+psDmzMlm+fvN3s2B2sSYPpUCHU7v257epiAXIfASiRWbePA08FrIJxM1duFhEbNCK7we8nPFeWxlQND0Vs/8vZuKgJ668ccxJCyVWxkyDdAtVxBIrHLZ1quNPLzN8sYpKm4e1TWn37oW2GDPuQv8pZLwlyoFOx+pMwfMr1VWChvuHuM+7jhu1CbusqM/9z/Ftclgj8oseu2TW1jjMATiuU6jjd8jVm7xeFHWcFgaJRo4eebCu06y2FAYlaenup5TqefcStLKjMjFHTL10YyFsnGn2vHeQIKRpCydzc/bOcYmzwR5hkGvdzq2clAzmFr1O5wobw2CXx6i97FCRpzMGIg4OHfQ0X1prI9h6IVMOR0uSb3GL2bZtKg5cVOo22+rSuV1pOAKbQzc1O3ICGvacJmWEP3NAHsaAr5a6KTkSfiktheEV8QMQPDRYzEB49sP6+K6JgWL8QQQ5CjnQhpfXlD0Wm22g6oB8Bm4jGxs/Bj6VRt5meKzaZofjATPKEobWgW035BuGoKVGYohm+t3g4odwAkBi6fqiXhx5aMmb1xrw1XsdO+wkqhjUqiTtw3Rvtl3aS0XfZoqxrgO1SQiNlO+uNcANmpOYOStemyYsEYTNoafFTyRNGPqAR6LVvKa6NLwW/BwgFzvPwtHXirh04g634+0/nhHd7WU6Spb03xZRJmtifrqU2TICq80Nb598SS8wXdzuHm82sZgkvVQn5R0jmKN0xMzJKlqnIDSlHboaiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(966005)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LRoQMGlmfjf0kc4huxQLCLEq4wef/kJgvB5bTsDLcpT749bMkI4MUz2bPZql?=
 =?us-ascii?Q?O4XBWaD94GpzBwJYQf8dylEm/6OBi0eFaNfbW+02+HMVhMwI49ygikVz19IS?=
 =?us-ascii?Q?7PgmF1rXlj8h4pu4KzM2NNDNOrzfCd+4Z0IEf62h5qxQ5mvpFSJzreypv7iA?=
 =?us-ascii?Q?pHdrQw17EdBqm2oOINC2etQIfho6rKDfUB+kS7GmqdW61r9DpMwNcpYsyBZZ?=
 =?us-ascii?Q?Qh1Dpz8jAw9mVP7Y0w1aJkG/XAaEhrG1dY9NrcC1xegtvK8FvayyYf5aUBTZ?=
 =?us-ascii?Q?B4cwyCEEUukIg/jYdGNf7pxzelyb+IkK+wh2csNVcNIdhRyJWJYRDdR1+lYv?=
 =?us-ascii?Q?qvci80fo+zXLtcWlGqoBtoH68fJzlO41LXJee5NwLtJtKNd+FgAMlTFhpsdm?=
 =?us-ascii?Q?h6opJR7nq1WZS+AtEXL8B9qByyQsQgNw/oGrSJp84NSxlO1/ND/o1GwyiUdW?=
 =?us-ascii?Q?hcQog+ckuTZwAJ/xLsrv+R0y96xoJe4To4Hebr1gP4Abr0hS2dOpqrmHJqXf?=
 =?us-ascii?Q?14wOMN8v0/saiqxXE7rIV0U7NGxFvy2wJTFezhtf3uZeTivmePHkeVKuwvWT?=
 =?us-ascii?Q?bBFnKsEHpYklFZnWT7TDgL21icOih3vvVpPG2PrCXk5Rn2oUruUNYg9pH1BH?=
 =?us-ascii?Q?YZgr9c1NEUEN5TDErMlU7WyB/GMTEVUWslqPa3FD+dDrH0iPG8lRvZGtRPbV?=
 =?us-ascii?Q?DVt0uEJd0sufqxJCz9DRww6OAoGmuCwbxbE2BT/cVhkdjkJz+NOwznddrB1t?=
 =?us-ascii?Q?UfFyCmGXv9AP808wGyXrh0+/WLZ2dHyMQHsj/Hc7wVKxrQODs4YNcR+Z4oGD?=
 =?us-ascii?Q?2ZeykfXxlPp5gMerqZA8lDXUYrk1+s26Z74PQkAFxNsEHf0itU4+u6H7JkzE?=
 =?us-ascii?Q?ar8GhKgERaUZnRE/+CERfUZl8PIn9D4m8cK+HB5X6JfwC/ECm/zqBhUYKpid?=
 =?us-ascii?Q?SoPjV1Oo0Jqmzm2uv4iPNZUdaKCr8KaQzaVqgmMCGtzuktZIXIZqTr7LVvzc?=
 =?us-ascii?Q?VxSRc+yHkrBrWzNU7ptMmSK7m6zlMEC5DuiuhII0/lYieImpck1zjIsO5q9a?=
 =?us-ascii?Q?FPx0j/uTFfFqJ22pl+nwjvIk+SjoqXCCiPlryvqT2Ki5q+V3J/nhcO/rqH0k?=
 =?us-ascii?Q?7/64+pANJY0XSNwb/7ookUk5Vebxkc5+Xe/8QZIulzp+tzBls4YAF5zEEwH7?=
 =?us-ascii?Q?E0LNvlGHX6xcLbHgbkHaTlhDSveqbzBc/gSIYXTYG23SCKkHpsEbFrdRz2fA?=
 =?us-ascii?Q?OAxZi3bc+WH+NErqf5vvqquA6ciEoKeipsga1+oUgQgEuKs2k/uAkM644v3Z?=
 =?us-ascii?Q?w6XnBCLk4x94UPFc/rv7YMwHo3pnswUR3lkchNHBs2zPJoJBXJ7h3YX9JoHE?=
 =?us-ascii?Q?AP5bfXDgaDOVEj6GK4F8M+zOt+wGE2xNVFgkbHKBtjxVlEJNoY/i1mN/oxOg?=
 =?us-ascii?Q?LUlTdSUy4l39J6M10InN0FSXTv0DDRNRGF166Dl6h/aXEXaYLkObXeKd56WQ?=
 =?us-ascii?Q?ZxpLDVLG7/m6Zj3Ya8rofzekdsbt62rN9MhA/MNfls2Yz+AoY6g8KaW9MDBk?=
 =?us-ascii?Q?extc8FUso7uPTneJRlkV1jzt3H/lpoiD8bCT5JMftsVRXrLTR4CrSqYG3/yl?=
 =?us-ascii?Q?KTocP542rWbRPYLwaV4ses4=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1d78b1-40b2-4319-1899-08da5b97960f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:24.3982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jyoe7RJahrWX4fy/FQF7X4oYhjp9mMZ+FDZWWAsYdn7Q79AizoMxeDb5iVRqdhCT6rMdNn+FiKCJqkhzm/0FruknrZwbJ8V9XJeiBSSLCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for SPI-controlled Ocelot chips, specifically the
VSC7512.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 .../devicetree/bindings/mfd/mscc,ocelot.yaml  | 160 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml

diff --git a/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
new file mode 100644
index 000000000000..8bf45a5673a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
@@ -0,0 +1,160 @@
+# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/mfd/mscc,ocelot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ocelot Externally-Controlled Ethernet Switch
+
+maintainers:
+  - Colin Foster <colin.foster@in-advantage.com>
+
+description: |
+  The Ocelot ethernet switch family contains chips that have an internal CPU
+  (VSC7513, VSC7514) and chips that don't (VSC7511, VSC7512). All switches have
+  the option to be controlled externally, which is the purpose of this driver.
+
+  The switch family is a multi-port networking switch that supports many
+  interfaces. Additionally, the device can perform pin control, MDIO buses, and
+  external GPIO expanders.
+
+properties:
+  compatible:
+    enum:
+      - mscc,vsc7512
+
+  reg:
+    maxItems: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 1
+
+  spi-max-frequency:
+    maxItems: 1
+
+patternProperties:
+  "^pinctrl@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/pinctrl/mscc,ocelot-pinctrl.yaml
+
+  "^gpio@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/pinctrl/microchip,sparx5-sgpio.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,ocelot-sgpio
+
+  "^mdio@[0-9a-f]+$":
+    type: object
+    $ref: /schemas/net/mscc,miim.yaml
+    properties:
+      compatible:
+        enum:
+          - mscc,ocelot-miim
+
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
+  - spi-max-frequency
+
+additionalProperties: false
+
+examples:
+  - |
+    ocelot_clock: ocelot-clock {
+          compatible = "fixed-clock";
+          #clock-cells = <0>;
+          clock-frequency = <125000000>;
+      };
+
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        soc@0 {
+            compatible = "mscc,vsc7512";
+            spi-max-frequency = <2500000>;
+            reg = <0>;
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            mdio@7107009c {
+                compatible = "mscc,ocelot-miim";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x7107009c 0x24>;
+
+                sw_phy0: ethernet-phy@0 {
+                    reg = <0x0>;
+                };
+            };
+
+            mdio@710700c0 {
+                compatible = "mscc,ocelot-miim";
+                pinctrl-names = "default";
+                pinctrl-0 = <&miim1_pins>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x710700c0 0x24>;
+
+                sw_phy4: ethernet-phy@4 {
+                    reg = <0x4>;
+                };
+            };
+
+            gpio: pinctrl@71070034 {
+                compatible = "mscc,ocelot-pinctrl";
+                gpio-controller;
+                #gpio-cells = <2>;
+                gpio-ranges = <&gpio 0 0 22>;
+                reg = <0x71070034 0x6c>;
+
+                sgpio_pins: sgpio-pins {
+                    pins = "GPIO_0", "GPIO_1", "GPIO_2", "GPIO_3";
+                    function = "sg0";
+                };
+
+                miim1_pins: miim1-pins {
+                    pins = "GPIO_14", "GPIO_15";
+                    function = "miim";
+                };
+            };
+
+            gpio@710700f8 {
+                compatible = "mscc,ocelot-sgpio";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                bus-frequency = <12500000>;
+                clocks = <&ocelot_clock>;
+                microchip,sgpio-port-ranges = <0 15>;
+                pinctrl-names = "default";
+                pinctrl-0 = <&sgpio_pins>;
+                reg = <0x710700f8 0x100>;
+
+                sgpio_in0: gpio@0 {
+                    compatible = "microchip,sparx5-sgpio-bank";
+                    reg = <0>;
+                    gpio-controller;
+                    #gpio-cells = <3>;
+                    ngpios = <64>;
+                };
+
+                sgpio_out1: gpio@1 {
+                    compatible = "microchip,sparx5-sgpio-bank";
+                    reg = <1>;
+                    gpio-controller;
+                    #gpio-cells = <3>;
+                    ngpios = <64>;
+                };
+            };
+        };
+    };
+
+...
+
diff --git a/MAINTAINERS b/MAINTAINERS
index c2f61ed1b730..a67828cbda20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14416,6 +14416,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
 OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
+F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
-- 
2.25.1

