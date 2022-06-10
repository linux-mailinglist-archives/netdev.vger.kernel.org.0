Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E7C546E5C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350821AbiFJUZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243403AbiFJUZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:25:04 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D1530F6FB;
        Fri, 10 Jun 2022 13:23:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bw7JccKv1Y9s4LZkKj2FoDYbbC98P0E6B9W1IONkluiO66m8Ad4sdRcBNjySjngrEPjjAmYIWY9Dg4TnlTmTes+FSbkxzR/OXGFethDVA1PC4dqcjL+X3Od7gH104czd3vYNwj3DRoJlhS18SIy4ETSvDt4J3Ao+ddbciQDfHXgXYOdUkzxnwpGfauIO0ceTDrHZfurYXoCKX2OuUfAZ+Lvjw5rcGloM+qLEg9zDdC4pmlLk3Se5avwGxZf/6J7blxVU8g/0yMWlsY3/6jWIH9+BAdMXsiKvVpyICJjowNw/UdAUkfdSNCo1fKvuMXqqOhTNQ5v6vZtaNufrjyVkAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TxUElxae3D5rFWa+9Bc7GEjNNlZ/Nwh0pZeDVBhKjA=;
 b=kABDT7bGkr2CyOWi651fYvI1qOz+/HPVA9kGFeGyDfDc4ic7hyv5qxGm85UglI2J4xpcTNMg0P5XZ6jrseNIk/JcmIW9S9E9Dc9cDH8o1Vk+ZELSAxI2oK2YOaQFcijj6l1jyzu0n4QXV0mYCIZKc42wiIIhUpel350+ygd2WO17IgbOWNpXo1eoRvLMAvzYCYAGa8WicCvB1Xl/hggy7M5wbG79Hb1iURPn5RD0voYNVmFgJ1wpmIM3b2vbKT8uwu71Eoey4v73mYCz4AAg/Qf2nDNbgPbbqxZ+iDtzcPh2c0P2m3NQJb5n7KwHJ9oITXdwHbwdIXZ+3XQQGum9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TxUElxae3D5rFWa+9Bc7GEjNNlZ/Nwh0pZeDVBhKjA=;
 b=tglPBofd5dUpMoTlcUz4vYVKJjLoGTj6lRpHbj7LCAADO+nuhKQbz1OOL2Pl8F1LOpW616eGRf5+MZsm12i1crVtCqgxa0+FU7wGFRKgl4eEKHCuS4Hzqbrt+4iGAaliLHAfwLrVBUfcEN3xIDGfulxo3ajoU3lNGJRBzbpK0PU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:50 +0000
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
Subject: [PATCH v10 net-next 6/7] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Fri, 10 Jun 2022 13:23:29 -0700
Message-Id: <20220610202330.799510-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca206aa0-55ea-4158-98d1-08da4b1f2147
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1629EA5FB34CC9A33AB1058AA4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWBK7S4JiNp9SDV7qHpncagKk3c69gH36QLUKlXuXQM8PCKGXfU64JNz2uwg5hx/HwzIFzk7Ve6D0+m6KOgWsZdFcVd8tToWaR2mA83Y1fuWkwWk7gE+MThCSyLIpoT99DXMv7jILQhIEUqkAODdw/lDjullQFF6k5a7Nea2qqznjpBnv/YA2M1c0ABFky5phjpv+EmrYXd1TgGzDv43PFVQ2GzB3AIW2n89+36WH9h4SuHfEoIR3B6++dWsFJx+Xk4iJLUIsdFActsrbZo1W/zdwwnCxg8SKmy+cb9TjbOeEx7tl37GCtrL6M0nTI8/ChzqGsQL4DniHt34R/R4g6vDJnHruhOeJAnfNWnCIUofz2PELL3b+makBDOrqi6wnZ7ZVG8/DfVU2jVMBCptQUvlJQBsFr9pmjtilE+uLHa2nOZycDBe7uix+dkcQcbbyG6L+vMX6yCNS6l5OwKgaVSwe8Sgsa59mihYGjCyBv9AUGrUoVfciI+Oo9xwFts4wDmMGYjKYvGAAn9buEAmiW5OG8XmDFj6VbfjDb4N/icCpiHW68B+2nWRLSxpFQ40VJXjivO0RPSbUSGiMGcYbyB3Et/fg6IpzhNq3v2FFXqp6HS/EvnCARHalokxJr0OzXuBL89EqtJDhbu68119iK6iV0K8meolbP/vy0ACMjZ1X/uacPtSap8Lzm0bVHZzv9YAmPwvV3ecu2PL3OYc7gYbUpAihKMIJhmM7T5lL4EmDjWxFZIpUTkyxT35OrRO9y1SMv1XUyEsVFuKNUJ/Qyzixn+LBEcCleT1pndC9ug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(966005)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQPm//7OrYwJbRBuKftmHa3SWhBZCmXbfTcWNqT07OsaS2E8rKLqUFDNHBIc?=
 =?us-ascii?Q?j92JArCyEjElfrQ26suSXDLudjcRfunL4rf28DtyphuwIMEBBsGt8tAtpPk5?=
 =?us-ascii?Q?dszGgDnN+AQv5nHOFbBwhHOQ8u4wibIuEsMrg8Tq/qQr+5c0hvo66LLj7nkV?=
 =?us-ascii?Q?PJ05nRhyTgNeAYYem4TEQPNLB4EfM0msXQY4LfJZodZKlwNj16npyJR4HrMg?=
 =?us-ascii?Q?VxKe4y6z3z/jR2nYEnfmkpjz7l1nedguTQ8HznZAfbI02SMbU608rmVVoHD8?=
 =?us-ascii?Q?VZQ4SYhHwM3aEc9oHjTvECq/K1kWSpgGoTdK2dZV9kZWvQjZHWjyHf77cCBT?=
 =?us-ascii?Q?yz6O/CjiUNQCd0QTygUGXwOx7UeRrfpJjh+MWyt6w8lR+7p/IPf0pDLKAYn0?=
 =?us-ascii?Q?mOWGUVSj0F/QCQTvYZTWTWCRrfVn/1eGCLotX4Ju2vXWfVtbWIeyYQD7z1P7?=
 =?us-ascii?Q?S5lTIgw5+rPjDYXm46JA/wFrgZXoIICUtFv/OSM4ROOEJmfE89OJonpkc022?=
 =?us-ascii?Q?NedZmXCT9pBpt4xmGqE8/h/8eIEpX4G1a0rcUD4An0oxhaP0SZumrjYrYS4a?=
 =?us-ascii?Q?xMlbWeq9buTB0KljwfRDApL1G2s2Md9fZOFNTX3mnoiSVKpt4DVQYNBFFuZV?=
 =?us-ascii?Q?UjdAoIblh+2YukK9pLtDUV+Nj/plV1+ih3X9pIZt31IKd4dV0JHeVdy01Q74?=
 =?us-ascii?Q?DA0XyUxXG02Hz7WyoOqWS2WeeBT9VFecCBKSt4vihLr4GDxkkpuzRzJigamV?=
 =?us-ascii?Q?jjQjZJPcN6+HqdiBaZVIqKG+D2PUbgRLiB2lskGmJsUPTuA0/6mP4Ab7gUG/?=
 =?us-ascii?Q?ptaZ0Q+L1XkHAiNNYyyYxx2OHYL4xZEXJWBkNWydH/fjVKuCoJhbqbHUd2cv?=
 =?us-ascii?Q?CwGrF8kje2YBdRjsU9mruST1weZyQvLNPJWaxgvOjAwx2WQRRfIAxZ4Fcokf?=
 =?us-ascii?Q?6GNmO+tlh/fjBqrOj9WjK9Kc7oCKNYgnUjMqOFVbDdCxnm9Ji1Ga7Uxe0GJe?=
 =?us-ascii?Q?VRALD2blaVOgola7JOiNCBm09TEadX1xOoocqPgzqfL1q7et/16nJDHGpzu6?=
 =?us-ascii?Q?TEuOr631Juhb3+4dUKXorMPTAk+y9iBIxjmuf8/JChqnjOtRZrpchVw3txca?=
 =?us-ascii?Q?/iZKp9BPaxd28ZtyEcC9k17EP46uSeUxxXADpN1j1yTl4Ho7fAF6MAorRt8i?=
 =?us-ascii?Q?h3S+mWeItAEoaFNfgyBUwByohmBkJK/z2fm+SBaYy2bzeE53HHiYavB5fmfq?=
 =?us-ascii?Q?txU4s2PJTUQKlfmOMtC1VOeQ9DaQDlEQv8aaxzCUvjRcjeuMO6/S0tGNFBmZ?=
 =?us-ascii?Q?G+oVu7UEA+JRn3MFMFQM6wsoiAm3fYFW9qrpeppqouZmb6+PBowHotZ69fsp?=
 =?us-ascii?Q?rbIHDfeDzD3dxw3Q70dvlZwgOODCHEgCYs9j0QnWMFZqB79EIzLkTzNhMlXv?=
 =?us-ascii?Q?yxrk/e1eIEkhuWxEuYD0OFJIXKVcJaCoX5Zq8SO0gPuEZr0cgMoIAl+hmCI5?=
 =?us-ascii?Q?HHLB7+JWABQaBoDJHJFIsFAlrOPw7LkpDhukprgQRRERn8YjI+E+rjpKtd84?=
 =?us-ascii?Q?18IAMjgk03Z0iM2m2s8/i1oJ4U05QNkelAnuvvQ/EVwO+i0AFw+n0VuRTsje?=
 =?us-ascii?Q?PqptE0eX5BzJeyfksAfiU3824Pcb1SJP7pX2Mg3l2NBXaEwJ7h/ZyMcMrUVE?=
 =?us-ascii?Q?PFsgY1maynCbMr2uVfEvoYT7AyAYVIZbMoYt0XRxTbJIdUtxQ8OvA+63psre?=
 =?us-ascii?Q?9AfkB81mAnmQbBP0YNXBbJ9QwCCOICl9gWcPLJLXggH7fu5o51Dr?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca206aa0-55ea-4158-98d1-08da4b1f2147
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:50.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZjg6I/hS0P3izRNzoBVxg7ALScMvKXZUtqwefLcA5OAwugaDQ5WWKfKXq14Q+O4XFJvBkXQo3Vn6YlsDp7hgtun948bC0SLC0Hh1x9RWmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 000000000000..e298ca8d616d
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
+    const: 0
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
+    spi0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ocelot-chip@0 {
+            compatible = "mscc,vsc7512-spi";
+            spi-max-frequency = <2500000>;
+            reg = <0>;
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            mdio0: mdio@7107009c {
+                compatible = "mscc,ocelot-miim";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x7107009c>;
+
+                sw_phy0: ethernet-phy@0 {
+                    reg = <0x0>;
+                };
+            };
+
+            mdio1: mdio@710700c0 {
+                compatible = "mscc,ocelot-miim";
+                pinctrl-names = "default";
+                pinctrl-0 = <&miim1_pins>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+                reg = <0x710700c0>;
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
+                reg = <0x71070034>;
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
+            sgpio: gpio@710700f8 {
+                compatible = "mscc,ocelot-sgpio";
+                #address-cells = <1>;
+                #size-cells = <0>;
+                bus-frequency = <12500000>;
+                clocks = <&ocelot_clock>;
+                microchip,sgpio-port-ranges = <0 15>;
+                pinctrl-names = "default";
+                pinctrl-0 = <&sgpio_pins>;
+                reg = <0x710700f8>;
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
index 91b4151c5ad1..119fb4207ba3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14355,6 +14355,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
 OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
+F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
-- 
2.25.1

