Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0395B5F86EE
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJHSyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJHSxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:53:19 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C179240558;
        Sat,  8 Oct 2022 11:52:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4ETW4afVnC8Ij9vC+PlSqBJP7fZcNYlbzLafyFweSQXFgfgIK4nylS+2ceqSvClBMmgByPs1hc+FSS9nyrHLimxlu76uvGfVU6sgIaIV73TUe65j7LUHFNkP0hetED1hRqlBKOslAbfYGX0XYj3i0qSLEnLMULmvze3HdDdiW+XwdkCFfq/CT4YZZJBH12HqTpcop3wVuCj0jI+z5w8iSZUS7+3JuRU2jtAQIIzvpUAbK9tgsRw88aKpZI0hUiBM44VGiQw2kjV6Hxh3DnKXSbsPbatfibQLld3+tM/8CABsQD9Tc9z25cj2zV6ISRyUm5ay7VRJuEfdupxTt1dlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26VpA92xAKD+cZaWdvqccDDCM9JYs2eQYIi+bHfkP4c=;
 b=gNFCbRH+As2RPjOuxQ60BEpP0uA7YngCxuJw5LSYCodWC9f66R9goEUDPYf6l1uBBnSQH0rzhe4JrYz4d2Hjs3IMmZ9IIclfZnSbFF8gKvUR+DbAnWZ2DxXose4iNPu3QW6xltEeTS46xB33XLr+iq/CkwTM4bVy7Opxe407mP47tPkb1hDe7qhDGrVOf39qIx1brHTlkNHERQU1ZQIy92JVms6ofmFnTUaQCPMPSKnbkT3y1ElKtPF2aCffCeJXjrZcpgTOq5Dnm9/sRxn4IN/GJsGFk8TwgFk9YQP0EXsAyn2MVeRGTP3XcYbR7QnDeHR2ci5YigvntuZJ8h3F3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=26VpA92xAKD+cZaWdvqccDDCM9JYs2eQYIi+bHfkP4c=;
 b=iHbPAj+QigyODurN4xMpTiP0TgyjGw+dWXUO/32QkFL0tFaGwKUPlFMBoBb7fNKY6DMYxw4sL7QenBFoxgB67i0pq4LA1mV6SIUBHz3Lnf70ZKjvp84vp+ofLwHTkYAITAI1CcTdpQ5Giwt6E22KGNpPfZycCrGQmZZT499Ihxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:12 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:12 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 15/17] dt-bindings: net: dsa: ocelot: add ocelot-ext documentation
Date:   Sat,  8 Oct 2022 11:51:50 -0700
Message-Id: <20221008185152.2411007-16-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: dc4dd732-f0ed-4596-ac51-08daa95e3579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqq18M3GayiX79Qla//LYEVQsSYSBVYisaDDvTEhd8ydOCqgMvi46F8YhdtOzKUpKsvGJHBW2yxLtHeogmfs5UPm+twTZZ/IUoV4I7lv6AT1L/JefAGcXcIORJ36yr+No4pf7xhdJepRjKIz2p15I3PXG1F61D0Emep9Nc4vxnk58/auSYHEyVpw8CDHx8V6Hhi9mDAd6sJ7ogd1r+hKLfcJF0yDcb1BOCYrHYfMg8GdMsLHfJoHWTfATjaXmz5QZUaWBEZvgCJuiiONd0yK63A9vW7Jjm+p4nGMmNdyANeEQDI/DwH+jzYw85rkpd7jc4KraZadyLgLuY6wuOrUZ9ccilQuVwwVz2n/6qQRi+4JSVxB/I+EYKYucYwzVhGan8sShb2uknQ4FoiwFNfdnU+fpaEcFPpeM2GSOOSiP1AC3eC8rnA0I9owj8Lrcr9OeEDsQzwDndU4GMpWENIhpwtAZrJpXid0oWH4iKQEELDnfIdkbg1pjpT7BSnz1IGXSaFvu3ZvIAEieIvufqCM2ngoywEhPEYkr/JC9vc8XAP9G6g5mUQdiTV2QrMkgQt/204n6Zl+E+hcTZA3d1nUGldvPN0oUpm7oUkZz/qd+AR48sEs2pCYqIk1MA3eYtJqQ4yoQop10yp6lgZElgJnwbv0aP4cHpyLfITapMCsn/7BLC+NA0Xa51qp2TgiKlRDO1WARkASHKVtOd2AZ412ZmfW8gsjZbVsisEl1wvPwL+10MfFaK5UXlTiyW+donNs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?264/04ooVpybNpOpN11XVRdCfoTJAI1l+Vb3gO9GWjxhjapL8EuAUTMQ9x34?=
 =?us-ascii?Q?iDqTgeaiuRHN4FjWGW3S+b49SX8NDAs5iOZKN6lj9Rg8XBlxMSZASawBY618?=
 =?us-ascii?Q?F10y4fDO+fD7a16WUP3yEvzjuAZPO8umqRDS2A/k26ierIPud4w5E3U4UJLn?=
 =?us-ascii?Q?kMmOVJFS9x1HekSyLqfyK+SmPgmzHQbAOtchaWCo37L0sE2jBNVKrRB/dAq1?=
 =?us-ascii?Q?vYZfyF99aWDORjkNsLZiJv4AWQ9Lo/rtVoYbcbECDdDrU2+N1W+LD5uVsh7P?=
 =?us-ascii?Q?sodFOI7hCOmW1aPRj+dUSLp/A7bX4F8cfDleR1z8JwjUM7dvxlKfcp7uqVnu?=
 =?us-ascii?Q?BumPWiY/Uz28g2gChdyet/RKU4mhZSi8tl+GEQtZW2/cdsfLB7nmoRT1LGsr?=
 =?us-ascii?Q?117LFCIYRZNb5uT2kIESGHYSiWFb3P3+UZp03q3aQSUvACg8uml3qHqFbjWQ?=
 =?us-ascii?Q?jUEoYWAns4vVgdTRWj984Z3e8TS3jHWEHGJBEbnL1yuWl2DSbVde8WZxKT7P?=
 =?us-ascii?Q?LbVqFn5oJyvYbcSv2BfQVETN4WGgrKYGheBaWNYSuzhykSxE9Vz38j5/AEGW?=
 =?us-ascii?Q?Z/ntMREYPoFnHNztgoZLZeEyRyDfCuzVhOz625QUCEG7l2mY00RKdeheDr9f?=
 =?us-ascii?Q?c/Klr0wDqLPvHQwT4sM7jehHQRzh8ZDpmMIfpSfsjY/yvS7x2f2HyluyuYn2?=
 =?us-ascii?Q?Hqs2XdJTpo1ZqtONJ/SpePMiK1OOq4WR9DPvdzjtXRa+M3LLSnD9QKuvxs+0?=
 =?us-ascii?Q?Mlrq2bqh3pDmXjT64/5K73yFfny9JYEsd5PMddvz/s6RZsnZTChT8rxIfvxw?=
 =?us-ascii?Q?7aJnv1how2fU9EKJN2VjEK3RiNZb3L5JEqIchg7X6vTseOHScYcJTbsuCuzR?=
 =?us-ascii?Q?RQAhYSX/IdktjLH/UY/ieTtBHmVMFgf2a9kIZq1eAQl235owj8oTsmWtwv5y?=
 =?us-ascii?Q?kDqxWWoNrBQG6Xq1Trsj74nW0lZq6myhf5hLVgP2o0uKK/LJGskxlCZUFHS7?=
 =?us-ascii?Q?93dgVxm5Zjodp28WR88EjYuNODgJvymE10qC3l87nCYzA6+84ZSNdiRqLQIp?=
 =?us-ascii?Q?rIHvEuvmVUhHoEGegfqMczepda9RmqN4PxHhB6dLhUWxlD7VnVLjsK2uNXpl?=
 =?us-ascii?Q?IEtev0uHEnSA7zaaMBB2uQ2rfiO7BwMqzbjh+StcQ+qgSTLhYVql5z1sbtgq?=
 =?us-ascii?Q?+/Hx0wT7UF1kInnGymaAZsVnV3sIX5Dlwm+ncAYJslLJN/t6Knib6E1ZfOQl?=
 =?us-ascii?Q?hLbm/HhEm3Opr1Wt9OZm5pPGKBJStOZd9bx5p3JXdY8u1WBL2p1dlMSAWhIG?=
 =?us-ascii?Q?I6MYFuT7lTh9JVcdMcAinVzCPMHKfqn1ERlK2LCtu7/1/XEhrqsB46EqZ8rN?=
 =?us-ascii?Q?+Kja6tfYg1yD0pVGAznSEnNfaY6+zvPsw9XeOWoWt6RV2XtfVbJtB/vz3VvT?=
 =?us-ascii?Q?k12uUSCYRhQnUBjEX/CiVSH0Je3X2wXmAy7j0nUygxKgUJ6yByHliV8bePhH?=
 =?us-ascii?Q?z7F37Ebfw0IkLjseGgo3hSl8XMdgPyeYErNV16PKwuyefa8UEqKoUzSv4NN+?=
 =?us-ascii?Q?hR9F0RGsC9IHvKXkYLuMRkYE26Kt7OwzMEmVXpoL6iy8Izhbms6rSFndvb29?=
 =?us-ascii?Q?sdPqM64Q/0VUt96kjezfzcU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4dd732-f0ed-4596-ac51-08daa95e3579
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:11.7095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWKfRcM3ANODeWvHEUEc2YBKxhzTA1kzhn3qnQsVrVYHYmb6Yr1HnY1vuqMC0ALL8iDItyu7vGIrACtFjz3Te9DjFF0+2JF9I6LYB9ECS84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-ext driver is another sub-device of the Ocelot / Felix driver
system. It requires a register array similar to the VSC7514 and has
different ports layout than existing devices.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * Add documentation for all supported modes (qsgmii / sgmii)
    * /s/7412/7512
    * Changes to match the VSC7514 device tree, including:
      - Replace ethernet-switch@0 to ethernet-switch@71010000
      - Add all reg / reg-names entries
    * Add example entries for ports 4-7, which requires phy-ocelot-serdes.h
    * Add the last sentence to the commit description, which replaces
      the phrase "which currently supports the four internal copper
      phys"
    * Remove "spi {" node from the documentation
    * Remove "cpu" label from port 0
    * Add "soc { reg = <0 0>;" to fix dt_binding_check warning

v3
    * Remove "currently supported" verbage
        The Seville and Felix 9959 all list their supported modes following
        the sentence "The following PHY interface types are supported".
        During V2, I had used "currently supported" to suggest more interface
        modes are around the corner, though this had raised questions.

        The suggestion was to drop the entire sentence. I did leave the
        modified sentence there because it exactly matches the other two
        supported products.

v2
    * New patch

---
 .../bindings/net/dsa/mscc,ocelot.yaml         | 112 ++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..8a73fc9dbcaa 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -54,9 +54,24 @@ description: |
       - phy-mode = "1000base-x": on ports 0, 1, 2, 3
       - phy-mode = "2500base-x": on ports 0, 1, 2, 3
 
+  VSC7512 (Ocelot-Ext):
+
+    The Ocelot family consists of four devices, the VSC7511, VSC7512, VSC7513,
+    and the VSC7514. The VSC7513 and VSC7514 both have an internal MIPS
+    processor that natively support Linux. Additionally, all four devices
+    support control over external interfaces, SPI and PCIe. The Ocelot-Ext
+    driver is for the external control portion.
+
+    The following PHY interface types are supported:
+
+      - phy-mode = "internal": on ports 0, 1, 2, 3
+      - phy-mode = "sgmii": on ports 4, 5, 7, 8, 9, 10
+      - phy-mode = "qsgmii": on ports 4, 5, 6, 7, 8, 10
+
 properties:
   compatible:
     enum:
+      - mscc,vsc7512-switch
       - mscc,vsc9953-switch
       - pci1957,eef0
 
@@ -258,3 +273,100 @@ examples:
             };
         };
     };
+  # Ocelot-ext VSC7512
+  - |
+    #include <dt-bindings/phy/phy-ocelot-serdes.h>
+
+    soc@0 {
+        compatible = "mscc,vsc7512";
+        #address-cells = <1>;
+        #size-cells = <1>;
+        reg = <0 0>;
+
+        ethernet-switch@0 {
+            compatible = "mscc,vsc7512-switch";
+            reg = <0x71010000 0x00010000>,
+                  <0x71030000 0x00010000>,
+                  <0x71080000 0x00000100>,
+                  <0x710e0000 0x00010000>,
+                  <0x711e0000 0x00000100>,
+                  <0x711f0000 0x00000100>,
+                  <0x71200000 0x00000100>,
+                  <0x71210000 0x00000100>,
+                  <0x71220000 0x00000100>,
+                  <0x71230000 0x00000100>,
+                  <0x71240000 0x00000100>,
+                  <0x71250000 0x00000100>,
+                  <0x71260000 0x00000100>,
+                  <0x71270000 0x00000100>,
+                  <0x71280000 0x00000100>,
+                  <0x71800000 0x00080000>,
+                  <0x71880000 0x00010000>,
+                  <0x71040000 0x00010000>,
+                  <0x71050000 0x00010000>,
+                  <0x71060000 0x00010000>;
+            reg-names = "sys", "rew", "qs", "ptp", "port0", "port1",
+                        "port2", "port3", "port4", "port5", "port6",
+                        "port7", "port8", "port9", "port10", "qsys",
+                        "ana", "s0", "s1", "s2";
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                port@0 {
+                    reg = <0>;
+                    ethernet = <&mac_sw>;
+                    phy-handle = <&phy0>;
+                    phy-mode = "internal";
+                };
+
+                port@1 {
+                    reg = <1>;
+                    label = "swp1";
+                    phy-mode = "internal";
+                    phy-handle = <&phy1>;
+                };
+
+                port@2 {
+                    reg = <2>;
+                    phy-mode = "internal";
+                    phy-handle = <&phy2>;
+                };
+
+                port@3 {
+                    reg = <3>;
+                    phy-mode = "internal";
+                    phy-handle = <&phy3>;
+                };
+
+                port@4 {
+                    reg = <4>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy4>;
+                    phys = <&serdes 4 SERDES6G(0)>;
+                };
+
+                port@5 {
+                    reg = <5>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy5>;
+                    phys = <&serdes 5 SERDES6G(0)>;
+                };
+
+                port@6 {
+                    reg = <6>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy6>;
+                    phys = <&serdes 6 SERDES6G(0)>;
+                };
+
+                port@7 {
+                    reg = <7>;
+                    phy-mode = "qsgmii";
+                    phy-handle = <&phy7>;
+                    phys = <&serdes 7 SERDES6G(0)>;
+                };
+            };
+        };
+    };
-- 
2.25.1

