Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07F0546C03
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350294AbiFJR50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350258AbiFJR5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6294044A0A;
        Fri, 10 Jun 2022 10:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icYZK2alTjR6+MqOcfXf/hRB12JltMUJKg/8+rnYMdNEVZTgf/OCIoVSI91wWRUQGpudb2TKy2n3N6RxEmxNcOQTLB5GtuIYpj5eL6+KDGlCpKh5ZTNxtFHJUXsEyr28LWEnyidkhjV/MbVzASc9Hp/krmdGtem+mMqiv/OYtokBeLOBJLl0h8RFfMDdGf8Z9hn6ChALZGO72bBVXkV0KhUdAgznOK4gU9wKz8wSwoOncZgzxogk6ftZROnNXs7FvluPYw+utUVnfhHbhqNn4i6yfC05G+FfMBhmcGTkeDzGYLGwxv6vUb+6+ZJWGcZcjM2bSj+pMY0zWYtN1goGHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TxUElxae3D5rFWa+9Bc7GEjNNlZ/Nwh0pZeDVBhKjA=;
 b=ZTRqYMOhfo5JNHrGnQG0odJwGPar6XJCTb2HlgxniIh369uv4q8ziJBY5kOnmIZD4THT2Og4YoB47DjZuXuWpL3qiIx6Y6YagpefnPRSko7x4UaK7yceFQJdq4QdWfcuIiNsa9ezlSdNi93+XoFznKlPH+rJuGC9k+S3YcU+0MtjGaoAPUc/zcEzr9L+8cs86expX4YHvtNGrMMyJGQMMhMx903qluMdPylZ1h/6V1DbAv/bjQfMdF92z9fPQHlUrxrHTMuhMnjLiWNmbwf4zq6AFVQTOeSpT4aDQbl9HCYVWazhF1fFlPXM9XchEhTUuv3iw5tbxTxWSMyAtkdmeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TxUElxae3D5rFWa+9Bc7GEjNNlZ/Nwh0pZeDVBhKjA=;
 b=ZGoHZUItbCUHNrvjyl6mu0gq3sCdI2l7OlEFEAysK5CGj1ljrTcgyVUUEp/N6dEXPxESASShTOd58uC1uc8eH5MBWQtHN/2Pacpqunl7I1UlycBXy1KNMP7WLyezWq6V9i4j9tC1kdtfK9PYul5vKj62a5ZqB5z8Ik8iqPoEpPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:10 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:10 +0000
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
Subject: [PATCH v9 net-next 6/7] dt-bindings: mfd: ocelot: add bindings for VSC7512
Date:   Fri, 10 Jun 2022 10:56:54 -0700
Message-Id: <20220610175655.776153-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610175655.776153-1-colin.foster@in-advantage.com>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c15ccba7-07ad-45e8-07ef-08da4b0aa3f3
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33562F1ADC5EBADBE3887B28A4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZkGWSdrytd0WUDHZDgtaVsZ8DXRlXQ4eBE+OZTNG1Vg7cxMB+jeaUV2hN4mZiQQUk/qd0GbHSn5JICm9McRAcs/o0Ct1Uzu4v0AyUbkY6hRbOwKJeP9JzPNHKB+JpBK1AG/ItVyN1WUo7E6Mb3wZZM0uyrWgZAbCbIHn/OVxFRCV1VXQTg65TOHFTuXcfb26gjuC3NLE1TK2W7eivr6c1Dc1vrQgOKhwWWd5blicbAxGdlSPloXd9AANa9La7cgUtnN8OlXcvVmb2aUIJhcxkzAC5sP8uhoemBtXNHPtCEAYbgtVGtH9HC03SO4vChrQHfJe59g1ZNaILRAjwXu3eMvedI0u7Uti3zp2b4CTsD4CK5GVZAykJhBpeg7QtRO0o8y/8epsiW0SssvbW7abdsjGml2+rsfOhAi5jzEH5q75vs0ho1lRIu1mWMCidxwtVUoDAJWHejtsIC9+h2JSdSVqcM4JsfuCQLM0+VPS81lfgY33WwnOzxCtjarjP5PGSDj+bmGjWsOy5TXQGe6cjf/mLUsCqWhWN2qKieuxjj76iXtJWyjO0vkT45va65LdMW/pNgy2An7/FK0AOJZ0ZVdf53chu4ITUqeIAWgHppvS2VJZnPnlTcTcNIcmJsCXPBgiTFbPOz7Gb4JCFGxdKAu7Rvx8HjIJE7gbZS0F6+gStIVdeldum3pyL10BiQKKtn1BlnG+ESW6Z5xp5TSXU2bCWgj+c6IV/oKeLGTuV3OXIzdOuYMDlVDhgrh0dS97EsVTTlY6HtYdqTFheYIB/NqO6hELezwwSJ4qTx1Juo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(966005)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(83380400001)(2906002)(38350700002)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GByXxcuJtZ4Om35pqpjErwcNAKck/Ca0Uu4Wf9QSbtll/Su2jqqpTX5tBVwa?=
 =?us-ascii?Q?xZ+2/lXqgVKodCpYZ+GXX+t2SRZh+oD8UEPwX3kjdHDcCf972tjl7mvufsVt?=
 =?us-ascii?Q?2/a+FYOvDFKrZ0WY9eH0cpO6lPg2m3+hOFPgik8HFwbYJB77OqfpWBVZZ8P0?=
 =?us-ascii?Q?/Tig70BPXF78M1b6d3YYo5FMm1joZQbpcRta6YgOSEhk8myo9O3QjwxGL8aD?=
 =?us-ascii?Q?wRRQbbsJKyB+AKkolxxI42se7VlxjhwD15/kk4zDfhk8O06CydDO5Hp4WUAA?=
 =?us-ascii?Q?MAqt2UeirksaBrErR7xzhpJigvGoLNEwfrTyNxb2QvfeVo9VC7xF6W/iTGHK?=
 =?us-ascii?Q?L0M/rWwELqsW5TkeE3wHuULjWcxqR+uh7FaQF8mZs0nPfBGf9reS0oY62wLN?=
 =?us-ascii?Q?lxHNC0jVEQYL49ZmSuV6G2YcDHoid8xmxNzEtrP4t1fCGJnm7YMdbBGC80cZ?=
 =?us-ascii?Q?RO2YWF5UZLeunxfLqcBTjnGB5cJD1Thc/kK4L1z1M1FfgdgzZDK1ifzXv+m6?=
 =?us-ascii?Q?bUnFr6GgRFJEId1mFWnXMfBdFE90fkUA1TEgmmyKa8ZNej8qy/ItHuwMLBD8?=
 =?us-ascii?Q?zaqr+mmUuHA79+rgyqu6O32iEUFgbPioe0mw5iD2qRziGkIVzjgQqVZRS8VH?=
 =?us-ascii?Q?v1RjtzR3vACw2wmh3ysWCFWAwdK8yYtpctFNPJpEgKAgBzGRa4RcHYGN2omj?=
 =?us-ascii?Q?5bLPUQ5hgMRup+zsdRtO6c6zXEVhyY2PHfmqkidnnOlmdrkl38rpeFO94hWy?=
 =?us-ascii?Q?F1lp77BMacbbdsXhWx1W6JqEZcjNLhe2i2YA1FsmHLuI4AYEBpcYArv24++8?=
 =?us-ascii?Q?x1kFoMnExlPYpLC10sLyP+ZTxIq790g8YBhvq82VWyNjZOLKZNK1tZSjZSLZ?=
 =?us-ascii?Q?2W58Ve0emeX4llxXtiUTm82QG1G88skinFyUKRTXVj96zBqS7JONK8EzXj0n?=
 =?us-ascii?Q?79aoxwAh1U1g3MP8hRxCMKTuud783PkpBCMaMw1rcB8BmNfT/ec9BFxitJfT?=
 =?us-ascii?Q?ZME6cokNG4sPgCR0729O12A9rmBxPGdHG29wUMz2IeZCh/K/+IjHiGInAjNP?=
 =?us-ascii?Q?EPfgxST4Jc4JVG3qShYfolQfzSxCjMTz2oCyWDSE/I8Mv/hbyuamfi9VrCs/?=
 =?us-ascii?Q?JDHh6WcOmFO+eG3DWuyk73A22gA3RCpQYd0XSfaFUVn1ZPufPwkm0kZinf17?=
 =?us-ascii?Q?ihsgoMQEB+bMhYqZ95bkFY0TUN9XKLF0qPRkjgT9VlvcTeUZbR2FANR7uVCg?=
 =?us-ascii?Q?TPl+Yo2nmah/raCmrlJWbboE6Gj8MuIiejndER00pjcM4Bxg/zTRp7kb2uAj?=
 =?us-ascii?Q?fiKGu5uHMz7HLs7H29/OD/iOaPEY7E9L4TkcOSrfv/1mEhWqfJnGwH5ISuQ3?=
 =?us-ascii?Q?JJ0fhPep0HXKNbBfe//gB4ViwlJThZ61LLt/MDVnSy4CzU/BdQTsm2v8aCou?=
 =?us-ascii?Q?NSHcN8e9OZygDPo7iTSX7MFl3wxUT8nOvP0qn6M0I4a7EZVD8H0ttgs4cIEz?=
 =?us-ascii?Q?/tPqQEVlruSXaeX+uW/p7vRynRvZ4TNVWjQGw/zdeqizN4LetTxaqpsJ6YAG?=
 =?us-ascii?Q?vSCuVzN+6+asgzJllEyhw81E4zjwbq/SXx7ifdFdSqEuOv/oGIHZLULIxy5Y?=
 =?us-ascii?Q?f7iA51Mqk2Xeyt2PD1BbrPC6e1zu1QY9zXJSglbCIe8HxQwWO9SmiLPJALV1?=
 =?us-ascii?Q?0GnLq0e5OwwcVoKwGEptHmx3pxGXVGT6HNiGzWcW7ejX/mU6VwUI6fAVPmaV?=
 =?us-ascii?Q?ujjYQKAh+Kpmt7b9Se1Jl4WF9RnsoOXGGbY1M5aK8iyHDwk/WQsx?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c15ccba7-07ad-45e8-07ef-08da4b0aa3f3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:10.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/3Jf7s58mXRPB9qYRKPR4BIoUSQQLpzmFsY758CdoFIXRhGxvkigaZM4SAE+z96WwzoYmaIC+WOrXepFFor+CMB1srv7IpiF3SOTGMekD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
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

