Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13FC55DA5E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243842AbiF1ITX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244077AbiF1IS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4440D2DA9B;
        Tue, 28 Jun 2022 01:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mht/eR+8f6t9pZy5qwavlBAEOIglrG+8XakRc7H2Z3/MQaofndVQJrxbQ0tnwlmylDGj7qWkMYSvVKsEqTpd4zqgAba9xMIN6sAXmAfMnISPg+i50kHBbnc+h1x4Rc+c4yo3RyDJI1UN3HjbnO329s8efNofgWrzhbmZEpmTz8s2rVPMUD9cLXwOPzdop37NJp0qwq1FqMc5/1DI3X3IZxwnlHDsqbQWs3Qq2wrZQVZ18kDsCx/U3nfWiLk+z7n4ASN3px+jGUA80b/yOwMw7D+DZdhVBswJ+5F4MZoZUE/ptDwPSJkcYzVDk4DAF6sioQNF48Rczp6vPdsIpuu5Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogd+QtW4TygX6Q3fiIyP3gis61BGSlgqWzvGDAhi4UY=;
 b=L7euVp8iOpKt95FecYluCj16Im2Zp5DZ8wwb4hovervWG/F1KuQunQVgBllpwBr5qBEHn7za4/4E+6tW9/3zZKdEjDHoi2vMwDLkNzuR0sg/vsHLzJ0Ioevuu1sfzosE7Tf9pwGsE9IKC8pxzWFe8meXYXAtOQtlVT1JClorIJpdH+aEO192ky4nNjYQV5CRtdpuTV8j0Qvd1R7sPZ12feAiRREXPZBICKjkN7hKsYjgd6ts97zmIZdIXTgFzhvmPOaIaGpJYkPJDZ4VYzrY3FFwrYVb/v/WO1wE8oF2NWx2ORbwhNpJojSkqEAJb67cO/vJYJj5vXeRpDqzNPjThg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ogd+QtW4TygX6Q3fiIyP3gis61BGSlgqWzvGDAhi4UY=;
 b=zcMf20N4OgbcJt2BoZFtdgu+F7WYSvmHyB7mYWfNaV7MfiB0no3HrmD+TWZIPpWbjgJ2HEm4qkdrQZf2P8S1ZXCU1Y1zeAtDR1ErLEVHRvCV1nvAma3J807gd2KmAbnDrePyIiWXFOxOuV+tVLfxU/07n7hhUkYkcmKfGBnXn2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:30 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v11 net-next 8/9] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Tue, 28 Jun 2022 01:17:08 -0700
Message-Id: <20220628081709.829811-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb52a2e3-2df5-4304-98fb-08da58dea51c
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDonm/Cvqv+AjBmorbSu5cBnnQcw+F3HYEHkyrypyxPtvO+m6kl2w9NhcgyaGebCdw+clnsrotjlQrgFZ7a4dh5JotopirUjXdO6KqaGUpplnnch3gvydN5YBnfF8NRISjxz84iUxM0BA2gOQ+IzpkznIBDCzPCnNKiAHtBc994KJfrPXWOB5/xaGPq2oQNKdwGr2bYGLYzDQC0vJDhoGxXBVsKO+4aZuAQRFedI46SSbcAad5iloVqgzXSiT2W1hO+XZ2hlqnEXyJZxxrunIvMWPoxPEjgPBSrhBus8qnWXxvxPcOBPA0f3bEiJd5rVGYT4BU+v7OqosB/K6S4tFzRUQHguzKdqlW2hpVzlFMzs43oS2jAihG4/ALZIgXRXG0T6WA1iG/PdioaA6RlMJDPqWqRs0MCPmo/bTidM4DZC64NsMfdHuGp1aAyRBlEUGUUslWIwRfR1J0viGmtgPyxi/CSt61o10SnPm+aum2OM4BRUTGryMgDPLd+RCdHb/z5C3W9jpaZdY5X4awCg6bS68Bkf45552tLaHTY8XmboBdo7JWb0TndN0uac5ifeC6/mLQeCDRKPXZ68IFP1SIuXaMlXuYKXeNY8EX2McKLNiUHHbUpkXZ3L4TOycdWOSH00SCGGB7UT3aQcXcYAWp1WgizalePrwYk54XRID5yZv/53fL97URAxweeIBWOpoZPYB0U99ScsRvzthZ9bjXBx6xbM3lIQCYdYBBB7B+DJJhlgnnNAzUkeD+qBi/KZFjU2bCJwloKAW53ZkN6typJg9fD9Jx8v1UjGWX/LDcbKtrEPYDBWOoJ2XxOOYYYX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(966005)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RzLOB1sC1DwTQE3fe3ccqaVYLpmIUbn9nR+n/nxcwb6USpZivOhqAMOmvY7x?=
 =?us-ascii?Q?aPICC7491RxVNI+zB9jIpVuTL9UDJCL3F/6yF4JAmcFHRhxEzb1BguNhHwar?=
 =?us-ascii?Q?tt6QHqqLXDxyTOthNqH0GiXhu+8oiBupmj1jgcRqCZMtmG3j3cvKp0kgHvSP?=
 =?us-ascii?Q?05fd9ofwdHzZaLRGYkKpRvQ6gOAgdY6w9w2K8cYN1nn3V4Z/9eJBe7Ufy36p?=
 =?us-ascii?Q?00ze3s+jPHJhPPvClBKf1sTbVHa9pskTCZdpWmRD6aS7RHqIrfDywNfAFVNz?=
 =?us-ascii?Q?oJdezHshLHRRE/QUtOs82imSgBgUHWyv5eGhouNzYEsTrTnityf6T4QS9sCP?=
 =?us-ascii?Q?crL90K1gpFjBbcvTZTj9hvB9lF23AinYqcx/LxL2N6WoboSP6uVPwrt3OR9g?=
 =?us-ascii?Q?UqBh7eGXNt5ckdwGeNnpYlkpAIkJw5ig4IDbjDNaLp2cQzLyQHVK1srIU8oa?=
 =?us-ascii?Q?fs1pgT+TSQXh1rtz4YgbO12uSeZnQGXgSxeuKwPMl+zp+SFIhD2qqfXU2B3x?=
 =?us-ascii?Q?JaYjVDgeyb1QZ1A15ezKmX2HIqoRxb1sLS16TsrJsA31QHjKclTbL3GCzOoo?=
 =?us-ascii?Q?G++brtYzX3gVp2E0lyM/Vmn25LROQaMa4yfI+Fp3g0+ILmu68DQ8+SW2ivWq?=
 =?us-ascii?Q?yqZmd7W7DhwnUaxS6ncc3cICYm9X48E3k0e/cfD1v36XSmMy7hBWBaJsc0yL?=
 =?us-ascii?Q?3ZsaufyJyGbR3ZtE4lW1ofypQ1i8Ec0CR67ZP1gOtWTvF1Mq1wT8KAI2Ec4K?=
 =?us-ascii?Q?6wed7RwHqNesT9AvcnNQILC1YMBHAz745wrAChgAxm3ig9B/Gh9njFyJZV0p?=
 =?us-ascii?Q?L5hn79E7Q4MfEgZKdBE5U9+oqrg0B1Ye8UQxYPfqe4tR7yLTqOmHGhiA6XsY?=
 =?us-ascii?Q?AcqKe5asAgPLg1JFg8ale5KLgcWADEL3zI8D6ifS4IhJzwiIzBfSFU/BGSd0?=
 =?us-ascii?Q?WFLoND6fZYJtyxsJVnJdQmetMOucyCv1nXS9rxL79xdRliOTy397US3/X6O+?=
 =?us-ascii?Q?zNpzDGH9PqCvrehnpeia1B5QZe//3avDVL4hEEhjVLq1CV8Macu9wKuv/ly3?=
 =?us-ascii?Q?I5nl3R6Jmy/RLyZF7cQ6p5NBAzFXx1hCT6qzHdTBxIUNksejzDTtJCMORamg?=
 =?us-ascii?Q?LCC2RpPIwl4Lj70SpBblpb19EOwzjhGv1TLL5zBM3CSkZLaw0yR49FipQTci?=
 =?us-ascii?Q?1pEeq5gEQuNdlfxOu7qHXgQ/xC0XPNa6V0TaiEfSP3/T9Gk92BLI4NzfQss6?=
 =?us-ascii?Q?gvx6/970AUN+JSRUhV9sTDGzYkCAC6Q0rp2fQHOE4LPm7eebVipdQQjSagEO?=
 =?us-ascii?Q?Krrg++KM5DHmpbIFVXrJ9217GBtUIOiqVco7vYjMbBVM7MIumY989gwsVYYc?=
 =?us-ascii?Q?W+shMpMUtI1duBiCpQCdcpuxms2A2oBT8bcM2ndRrOeWkOq0mPmfVY38Jsfu?=
 =?us-ascii?Q?84ayjOAmD84KGko9m3lmeaRGoJMshlKX3yvMcEih3dbd6HxPd+dScZ3ldDCW?=
 =?us-ascii?Q?mBGO1/OFs0eeu1ji0FACbeMl9ZLUKN3of75nA3JrWCdr1W8Quj86RFn/zVVM?=
 =?us-ascii?Q?/2WJef5UxDNw12pcNsF15xfP5kJ+2tFZU9DvQteG0x255bYJq0t5fINo3di5?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb52a2e3-2df5-4304-98fb-08da58dea51c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:30.4007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRSdq16v7D+2NkDbHvluxVaNmBa75p+oT4IJhhQeR2m7ImSuvyum1FNX7FcPI8BJ/VmTiuwhVvef2qRO5mbtvAEe5Sn13B3YrTyz5pMWZ4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
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
index 000000000000..24fab9f5e319
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
+      - mscc,vsc7512-spi
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
+        switch@0 {
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
index 4d9ccec78f18..03eba7fd2141 100644
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

