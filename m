Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E07592745
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 03:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiHOA5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiHOA5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:57:04 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2126.outbound.protection.outlook.com [40.107.100.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD6EBF5A;
        Sun, 14 Aug 2022 17:56:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NA6L21VfGXC96uQSVhpOYO4T572TjiquNTJk3J9XNdMwavuayuVl9bwaFy+QXOKu067HP76enkoRnkzzIC1PhAPPgyGnm2SwXz5FpysVywQQUU7LllOAmrf94ZvkACgg4qOM9GKnM9zB5ItXDBZ4Kqlgb5/bCtexlV0q1ywtE0lW+0Lsworj9vp1SZvj7eTk6GlJn37wac5z7TqH8pjVnJkpEvDtEZ33s5+k/JcQbW2xlAcjnJnzaBJTHFE83347dX0xo9fvi5kA3IGdWMg2dyvO1iDAO7018K+pfEizEw0AZF3T/4yLrhZaZ+yHu4hXxDJP8jpYGHAGHm4+RCDwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ugWM/t7mNaTvEKz3aMsWhD90NlTeDCnSdjabF2ck04=;
 b=Xlzfvl9py1nCdde+WrFLCVBdKCRIMw2XleKUYS4qQtECa80X3+YEUR/0fuHI11Tsxoj1Iv7mTxk/7cyiyxNTRAwpBJLjN5CrPo80qBBrbNT9aya1TQ+vYx3owlOCM2KTqj1xETw1B+RO+rEztjjHeGBRFtIziXx0QkZclrNqVWYMp9U26xjclzwAG4z/aIGp6MTwR2ZlCjkYTU1Lz3my6bzkZRfnAcdSbsb2xIsWmYyqXSHKa+ucAwArZO/VO5qgOFfDiL2GbNtwdLfILmjP58ClVtavqP4aPJPs17VeRXJ/z2kO7PlUyxSBCZAp8XRfOe/rBHRu0amvR6DL2DEJWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ugWM/t7mNaTvEKz3aMsWhD90NlTeDCnSdjabF2ck04=;
 b=fQmPh2siA1v2U+5pthe0cPWMB9jDzm79AB2dy4jl5od0UqfdKYDathDAOK/5rcUa372ROAEQtHAVyCuSB2a4dN69SAK3BMvo4rBcOf58gWjHjtha7pJzjEWRtrQBmBe8tcSz5KlKEhqE+9a8JUy000Ib4eYtZWPvXIIod1nKu68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB3862.namprd10.prod.outlook.com
 (2603:10b6:610:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 00:56:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:17 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v16 mfd 7/8] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Sun, 14 Aug 2022 17:55:52 -0700
Message-Id: <20220815005553.1450359-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815005553.1450359-1-colin.foster@in-advantage.com>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8344b628-faa8-4814-b28b-08da7e58f57e
X-MS-TrafficTypeDiagnostic: CH2PR10MB3862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osxo359Z7zalW8o6+q5V43v/wMMhNYUiQXizN+Oo74Vj/LnPL1YCXQ0Eczo9Np0gby29a9s/xwFisCfTKmU6vZ3CAXhl9lXoMpZ5Y5a4+316SD5c7B+7e3TnzYGZZivHZmp0Q7I9IZRR9doKBMFd4RWXA91W2vCOuGZCDoKicZ/Kcem8eHFHGsctnTxmU63TFaCwbURG1NBG4JYGuCxF4OiZ9+yzuhrRPYHeHuKWVVHgEse6cQCBpAPD4WYwVD93uNIXOx1JeaIEbhlvUsFHmTB1LrkoREemhfKc1EO5rwCTii80RTAqZLduXN3WAhaoig1qbvSjAW8VgDMdtvKKpWrF3RvKs1UOp3E08pFhkb+oBxi0yKWsQHPuW/MmXySrAEfWviX0Mstf+WsJUR9DuRgzAt7H57Xo4HZejTgJfWDcrYa+spYsnM59HvIehLRdMeGC+rhSXm077Y8rLyZVQamVeBrTX2J9KeNVRsB4nlPO4ipbonAp2VJWTrQ9E4DOarJ3yHosXnzP4B4otrAmegLS2/6ZjuOSmpKhxuW747Ulobugh8T5F5TOqCCRQwzd78WGcysNwase9hDwCZyLn2TTUrnqUaqOJkq4ekjU6x99Zv19rMAwjKI5u0D9hbOHekFKdiMIjg7uOq/HFGmXNqmDvD+nn5KGChG7WVbxbjYbKpMVsrh3GJ1J83ZOW7J7CGJzD529Ansug8PLDOg9IBaYqJ38s8KXT7QXW+cN2Rd1LqDEwlPoMNGtYdxAxytfo3kjNeH6m6YgW2bRzqbSYX4tvlz7eGnMySCqiiO06ax9htF0ZHa6gaEJPav2uTKS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(396003)(136003)(346002)(376002)(1076003)(54906003)(41300700001)(52116002)(2616005)(6666004)(86362001)(186003)(6506007)(26005)(36756003)(6512007)(316002)(83380400001)(4326008)(66946007)(66556008)(66476007)(2906002)(478600001)(6486002)(5660300002)(966005)(44832011)(8676002)(7416002)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p8LRwHXZinfG7VWe84zdTL4DYCW/wR1hJk9KJHXY12pw3UAIWkthcOdMuojU?=
 =?us-ascii?Q?rcCnpEFfTN0M5fJd4e0VateqkI+NHSAAf8oXbWlYpy3PnHH3PeroQc0+38OR?=
 =?us-ascii?Q?Lp+kHSkMWqvijTLsCd0iyKUrs4rDVj5Jdb5Wq1fWDvNUWGAa8jH3GXRBfF/K?=
 =?us-ascii?Q?v6QOatGV4zwILgo5XDSJK725psYZ86pQ8kSRzekJ5O+zCes8KbuqxjWm+EEN?=
 =?us-ascii?Q?WGLgh5rjPE3Igbpbn5LexD4++9/nd0Ss8Mq4kCZA1jn9kPfnkXJPW3Pz4n3U?=
 =?us-ascii?Q?NC/6WnMFq+MGipeGsxjZYHXJmilSCrHU/U2M4NeRiroq4qS7GxPWSIkfxumX?=
 =?us-ascii?Q?o4V2GultH6DNNefjbVMOpo3V2TWoDM/LC2ClIO/LciR9XJYK3QQML9SPhb71?=
 =?us-ascii?Q?Q5zhic2jJDqP9hjU1mfblywEopBJsuM2O2Ve5JxNO/4l708t9MQE0YWuQ3OZ?=
 =?us-ascii?Q?b99XaluFMi01inulzT9Y8FLF1OoVMlZvGKwLFY7p4UARnFmKwP8i7IXxnjVm?=
 =?us-ascii?Q?8Ym3hzu4fUTxBJVuFnoHA22hFWpTTmDyDarQ8OrV+cBOEswcbu9dJ8FxL3fd?=
 =?us-ascii?Q?zIhlW4G0TF6r74FoxzZOmmRXF1pbtfhth/xhAoFyP+HjbAqU2zk2q/JdgVaT?=
 =?us-ascii?Q?sFpuzU2W95nNpKSvlJ8hggaGzSk1dj6G52y0PTOpb0nzof6mUdoJ1jiApsP6?=
 =?us-ascii?Q?/v8W4k1OIFYHKbMihkOTmjEgaBO/yckWvrfLBu01oc/crNh83MBToDGHBj5q?=
 =?us-ascii?Q?Ay8NkIAcqRjcAH8cxYgkDeqbAu0taIgPR6+yNPd9bgpeeVVfDHDAkeiBqaXa?=
 =?us-ascii?Q?5koU44LvaV/cCnJm03FIDLpv3z8p6YXpnETkC/1i+QIrC4KawuR2kImpAFMy?=
 =?us-ascii?Q?fNibuLKrXByP2ZAw8cJ+E9g7M+PMxsU1GkrUAohYpZBr9ItZlKFYyOI/xxmZ?=
 =?us-ascii?Q?/FA/yFoLA55yjxZMKURzrPB/EjJ5EDXecFWSVOT+4VvNgs/vDKwpXY5lP3OT?=
 =?us-ascii?Q?VwR/Aeo+j3gepw7+jNWV7WCDtHtCaNUIYcvxJpKGQMhvzQVs9rMMvsnM85Yq?=
 =?us-ascii?Q?LVqMLJkV043rH/IsEYA+BEcM5VLrWlqBxlMeov/5ceiOgwmFFoNTf4r1WtxV?=
 =?us-ascii?Q?/ijUTQ0vVfwBfIl7xO7FSJuTpalZRutU4pEQRhmCGv3Dj8vyrC+22MKhpWNt?=
 =?us-ascii?Q?uNRIrUqtI9aiVq/NQ1kqyrPdW4p8bRqmnFo3Tj8QPNOHRRF35kT+XVXpXknt?=
 =?us-ascii?Q?wq7/KQcc9S7AHyr5UoCxEHRA1PQ8t2bLKgoxGv3c4N6SxRGMU4RzAh9Tdvi5?=
 =?us-ascii?Q?9glJjKRPm4OYeDtro3EQC3FRYT2qBEOUkh5I9kvikZmEKc6/Gzpa2FQxXvYo?=
 =?us-ascii?Q?c93wc5CMnwBCRypGecvRrZ+mbRXMwRpnhyeSREf23dSpOl4TMD6XdyzgWQc9?=
 =?us-ascii?Q?hJtz7k2K1Gv3Jum1dM0QoLPHAkoKhj1g/kiRNWRI2MqlGQwWXKaCIiCfz+pB?=
 =?us-ascii?Q?yQWOM9FaiR+lSx2YiPMRiuLxUeFMfk+vBQvcl8gYuyCoORfjJxUJakTVSNmW?=
 =?us-ascii?Q?Cf7KUrz1+R9eK2zkuYwHlJeTJJuUHIf1loxFKdO+Gm9Vzc8xdpd9ar5/ZcA2?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8344b628-faa8-4814-b28b-08da7e58f57e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:16.9164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWxUMt1jSBGHzMKzoztWPL+q0Qsg8771x9jSkNR6H+xoJ6UCVHMPCChwqHwdAqZdSt9agUJxLxFYwFZYq5NIv2FtAfPCF3CfWeraiZ1B1TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3862
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
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

(No changes since v14)

v14
    * Add Vladimir Reviewed tag

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
index e0732e9f9090..a5df3b0b9601 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14744,6 +14744,7 @@ F:	tools/testing/selftests/drivers/net/ocelot/*
 OCELOT EXTERNAL SWITCH CONTROL
 M:	Colin Foster <colin.foster@in-advantage.com>
 S:	Supported
+F:	Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 F:	include/linux/mfd/ocelot.h
 
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
-- 
2.25.1

