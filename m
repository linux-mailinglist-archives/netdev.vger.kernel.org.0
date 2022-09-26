Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3175EB0C7
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIZTD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiIZTDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304458E478;
        Mon, 26 Sep 2022 12:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ts8vKHLPxBHwDVID0SojiznEuvbjyYNLn44FJnhiipPsghdhvcFgvwjsrQbymP/0sYEjk85akpX7BwVjyZ64zZzNDVsRPD0zaSNw2MxnGdF4zVn3uLuAaS1A87HIoJO6sVWOP8AV4sldoxn5HGA9oHw/fH1S8iloxrP0FDJscBy1OF0Et1crB/nbGuCbYDnK5ymda3ov3lGMpPjd7Fk5r8HhmSXGsSWI1zio9Jthq6F2mqrTtE4oNSkSYh+hEcsBZP5S86j6OEuaNv05M5fmrOuS/zWVNaA3VAf+42/lU8jU0H/fyQfjnaqN8g6Xvv3FxBcc5fLY49/jrVKZ+LdqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4M7eczcS+e9um+t3nZNA/QXokzeVzTi2NBrV+ZwouM=;
 b=J8qFRGR0Tr6FDYfLF+Tuv07NglUJmYcGkjHDWWnCA/0fs15ndYeB731gAEh3Ve/xjNWhkb3QkajH1hs0eQTuz8JpAL0ei8nFQtBEEEHkBhSwufkhhgVw3OGD8x8STy06gWsZowebErFCHIN4SgHs3RPbR8XT4NeZuEvMGLWxrIkXmAXHSxgGk/PcVGVvymD1XGouCro5tY2l3p+37FsouKt0Oh0zZ9rT+W+R8S8lantqm+y1hYh63H15JAtZwcLcMJQXvpN/cHddY53PzJ0rkXmc6i5dme89m6/1/O/QdmTmLWKD4aj1vn0aKMZjxHQdVEcwQqxwsxYn3ihwmMDHeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4M7eczcS+e9um+t3nZNA/QXokzeVzTi2NBrV+ZwouM=;
 b=u8j4N65ozrq7OyrZ25yTh38p5MGYys16xeMgLqKkoeCH9dlOYfY8281sE+MApHQ/Isl6s0sTP3d2kQktLibhf+DXvnzG5fL4sv7D513GfqhUwWNtpJ9bKeYJHPZIZn8e+K+fhTlxt504Ti+nTtcHv3t5dJ2kzLzROahfo2C9C32VcmZkEJB2PBySIArNUMB2he1GYbQWgX5AuEU9ydvXB72tUZLVSgXVzR1h/sG8Uca6c6SwfoZXpX7vht1Bclr9z8Wc18tFrIkEpUEXmCV/wdhScOLLJgHABS8AmZkViTStlt9fMEn4LDOE0QwTeiX7f6SgshgsV1MyE3OJd/zOrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:34 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 1/9] dt-bindings: net: Expand pcs-handle to an array
Date:   Mon, 26 Sep 2022 15:03:13 -0400
Message-Id: <20220926190322.2889342-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: bad2c1a7-b22a-43c3-ccdd-08da9ff1cf3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ttHLCdrlNmA0hrnOC/JTk+VgE+yq7nwc5MStaBLo37J7Mw2qvFAeMUBiZ3s5tQjfi5V+cqXBvGWo8Skk0S4LAHABnYnDoiIhEFtu/LvlcCUVt42K+xer8rF55MMsrcZmAOOPWCErLqVTFDc34XsfrScY0eA0557+VR0dSjsademhAO4aOLbBgIjz7XdKljbni9EmUZD58RASMntXxgUHDhb0qG1NXA46z5dRqJJ/kSoUr0j6Ef/r5e5I/tMScWVpfv1G5CXcdJ91UYbhkMfGDZ34aXZDEUfTyA9MgDkY5CK9n38JXG68ESLRK0Pk5M3i2BiIKMX5LdaLjMgHFl5Hf0az0kkWp+XSfAPSM4HtGwVa0UgPn8YlKxtGg8csifcumWGzLbsm/mo597/TTkKvVzT+6FPctjoE0zjf3Fc04OK4p0wezBg0QfVTCV6fbMf/9VwXGfw16ryfr5p3xc26i3dKPz2SltneXF04dCVyk2j0e7x2ICek73ITOy9IxBpxFsTQMryH7JQwuBiIbr6jBQkeWVxsMsPzE9zK5nsExfPwWp7VOZdh6ExvZ99Dlb2xE+0kMFfdnW2GlZxXoZf3tpgVwqOczl1Giritgi4YF9cNhI/uVdqDhuKiND7gU9+cJvGz9CnJBk1ZyNB6U4Cwb8nwbm9XMyl2PH9wHAIndT7l5FsQFcqILVqDnMR5WsTDMjFkjGHZZ0kE4tftdZlyoYsrmPBNQiYclB0qb1Uv6MkeGgwKKX+dxyevQD70Oatqbh3tcliDZIi1HBHkJPIbaaGjQS1HXGyjNm4T7dYZZKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(966005)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mmCJa41i/+n40OBX5h9opRzBKojbs3sJZd8+/1xK/Ci0WZzVk0v2i+dmcPOO?=
 =?us-ascii?Q?djdqRB2mT0zPtjwp9M7N/2P/SvoQGdBIxQvScmAaBgB9iZnyn2MsjPHRVr/K?=
 =?us-ascii?Q?LlmbCt6OF88bnLif0+WpUmFOFdNNCu5/F6vLRNO4CBMy+iUHj3Zm/60TvVv0?=
 =?us-ascii?Q?F51ccHNMQlVIY/9lAnPr6eam2qvbfAl1Ow8ceB48V68nH/zsszuPk8MBzY9P?=
 =?us-ascii?Q?FgbSjSRvTem4XUI/hpCTsZnR4SwrAyQ4AxnRsbc7EHMdbE02GoGL2yE8ZQKt?=
 =?us-ascii?Q?dYDsWFtoBwXRXLuHfpImXXlRn4XQ9ALg++tSneuC42y7lUFBsje3ZQEsQDhV?=
 =?us-ascii?Q?soTGdY8lgrHKGBQbbmP7gI5oThvbjiwesUI6QSCX2uZrc4zDgJLasVP0EGJu?=
 =?us-ascii?Q?YzUwG9LYsmRLovsDadPTq7n8ikrGFM9JF/gsNHIV2OuLJGaTQerNwRL90RfR?=
 =?us-ascii?Q?3i/Xg4odagKLnWJsYAxklA43ylQ724EbtQfzsCMM2H6t055sfUF1l+tXtb2l?=
 =?us-ascii?Q?08Cp4oFnTBUm9x9tA8+ouUhcTRuUQZDFQrGEa2xPb3hnsfVIaq5YopBZeb4v?=
 =?us-ascii?Q?sC/TvhPvScORD6N4909prQV5Qzc+++kmO+qncVkrOG/Q1J/pHcjO8/PElTAI?=
 =?us-ascii?Q?7w9cxJO9J9xM9agsVaBOPJhkiGcvZ+Y1mexfs/E+yzHQx+QB2GanKQdi/Kvr?=
 =?us-ascii?Q?NVVlTg1Y/l4klmXiAS5e0RZ7uUBM66IzDdP03HhJJ3PwkZUphq4dOfo6m/wR?=
 =?us-ascii?Q?UI7znk96VsMeiEm+8T1lZsrfmRczQGaXkT3xtyTFVhViEPFV7LOv2ghRhh0L?=
 =?us-ascii?Q?KULaKNsb7M4sD+m7sRssxnZxxSEpjT1nDGK+jOcgXBf3sBpe13Btf53iEwrP?=
 =?us-ascii?Q?wdQ+YAiKGXm5PjQV2FYYFJWGo5IofTM4/RXiunwckUsujxoDFvJkBALCfHGM?=
 =?us-ascii?Q?K0oghhr4FXdlFyy8vBZYlNxY2uO1Txzd4biJ1QYaNV/ps+WJw1IiMML5BuwO?=
 =?us-ascii?Q?rZzjr8+EwiVkhY79y+aRHxzliK3kSkDffKn4BaPBjVkOz2rRzcXyvGYlLfe7?=
 =?us-ascii?Q?RGzH1INA5SQ4Mp+6pnboQ42Kz71c2AV+x0IKfgD5x/cVOcKaB2MaJ1kap0F+?=
 =?us-ascii?Q?/2pmeSDrYZWcW07tEdPP5W4t8Mf8c5Q/iN89jDJxtH8PmHK0dbo4qD8RlP/1?=
 =?us-ascii?Q?cqOZJMn3Hy0v9jLjiyK/QCwy80ZztzM3lppqNLMaNLIkzj5ZUDZBLcFNne5F?=
 =?us-ascii?Q?WwNoevzLzS6MuU3EvJ5AEjKTiH8cXRxlvotaziKQfph2LdhX1D9UjGeKloaI?=
 =?us-ascii?Q?JsJek+79zJhVkQ+NhSKE82GX9bIOlx7NNsKreog02hQHCaj/NiO1WtnAsONg?=
 =?us-ascii?Q?um3KJ6Jojp5AtIFkfgOhLzFMMSM9Dt6AqeD505ummpjUwy34G3iC+4lCC7U1?=
 =?us-ascii?Q?8uv0dHFK/f3ryHk9p2T13SrQ6sYzjMJTTDJq+GV9fTTzPvN+sn3wHTvWC8Sw?=
 =?us-ascii?Q?oesEj+jud9CbhaJSjlI+7NWNvFyE4caCAU782KbWZSS3r19VbbZ2g43BEq5c?=
 =?us-ascii?Q?zZVIQ1t5P5fGjRNsxLL9pyEu7JOCwkq5dzGsukVN6155mj7jCpCz3dJCIQ/F?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad2c1a7-b22a-43c3-ccdd-08da9ff1cf3e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:34.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNsBowhKug77TZGZu22oCWiUnfWteXc3raGzhaE72b5Sqrynz4cch3oJBYQhHvcA2HL4N21PbxPYlFBLbx4l8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows multiple phandles to be specified for pcs-handle, such as
when multiple PCSs are present for a single MAC. To differentiate
between them, also add a pcs-handle-names property.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This was previously submitted as [1]. I expect to update this series
more, so I have moved it here. Changes from that version include:
- Add maxItems to existing bindings
- Add a dependency from pcs-names to pcs-handle.

[1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/

(no changes since v4)

Changes in v4:
- Use pcs-handle-names instead of pcs-names, as discussed

Changes in v3:
- New

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml           |  1 +
 .../devicetree/bindings/net/ethernet-controller.yaml   | 10 +++++++++-
 .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml    |  2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 7ca9c19a157c..a53552ee1d0e 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -74,6 +74,7 @@ properties:
 
         properties:
           pcs-handle:
+            maxItems: 1
             description:
               phandle pointing to a PCS sub-node compatible with
               renesas,rzn1-miic.yaml#
diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4b3c590fcebf..5bb2ec2963cf 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -108,11 +108,16 @@ properties:
     $ref: "#/properties/phy-connection-type"
 
   pcs-handle:
-    $ref: /schemas/types.yaml#/definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle-array
     description:
       Specifies a reference to a node representing a PCS PHY device on a MDIO
       bus to link with an external PHY (phy-handle) if exists.
 
+  pcs-handle-names:
+    $ref: /schemas/types.yaml#/definitions/string-array
+    description:
+      The name of each PCS in pcs-handle.
+
   phy-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
@@ -216,6 +221,9 @@ properties:
         required:
           - speed
 
+dependencies:
+  pcs-handle-names: [pcs-handle]
+
 allOf:
   - if:
       properties:
diff --git a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
index 7f620a71a972..600240281e8c 100644
--- a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
@@ -31,7 +31,7 @@ properties:
   phy-mode: true
 
   pcs-handle:
-    $ref: /schemas/types.yaml#/definitions/phandle
+    maxItems: 1
     description:
       A reference to a node representing a PCS PHY device found on
       the internal MDIO bus.
-- 
2.35.1.1320.gc452695387.dirty

