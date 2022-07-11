Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238A05707EA
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiGKQFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiGKQFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:05:44 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D48354CB7;
        Mon, 11 Jul 2022 09:05:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYdzCGV62SxTbnokAm+QRy9ywPsEWaqVFCrpQHkgZLPczLZitxByhKFS3yHbJgNEY1kewBb/cDuzdjOsICgnx1t2vKKDGybon8ZK0BU+f80g3oJ2jwAgZoExoSuDuDQcwNJD2Uuy3RVRh1lE91N01N1aXORHO9xpk5y6PTWEJ9PpjUsIv62AASiGCOQvMH13hAWElmtYz5VWVz9xPJDN6TikPRpCq0GLeAsurGJ4lrLU0/jVkqQzbUfUDwdb69FkryT6dwsWeZrUZdwwCxVMYrK6WT5veJxn7x48A3VmfWmPjZloKP1VzZFXqjSZK9JXivxYFg8dEPDKTGcTwdWZaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LcnwVsgd68nk/gEc8qJoiEfvKm3rTwm/wMiG9OkwjIQ=;
 b=bT4212Ml5TJ88ZQIxfQHDcKffaCemkITmMcsz2uKicEDNsaNBy4yCDMFN4bvs5KuDJGqNKd6qothd4aBmvFBXOWBGugSUqU5MxFGdPSEa0ZVLT9d9zvF8nao20MDqLsksLlHENGQjI0Rko2DHnoQP+G4Qitoh+25t7MEP3rvmfNyLhbpVNqdJLhjAF0ekgYL3wvveOJDRMcvQExGY2ns7Pgo/Jp51mw71WkrlELgfOLJ7dTBkmguiVEYO/1Iv+nByEiGwgUzDnIrlR4D4AvQW64lwmW/rYolAPZc0ciBME66rwkmfHUQKLSW2KsZPh0y5Gx+hB8G1H6Ew52J3CbPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LcnwVsgd68nk/gEc8qJoiEfvKm3rTwm/wMiG9OkwjIQ=;
 b=bgNrb08VZyaQaye1f9fNhvbrW+1DWUG01zHeMpBvpikgzSYbOC6M3T7h2RBr7WqvGRGp/mzvIQlBwt/ec2MSRhtkAVs4D988JgeSljtxZmdVO6YVNsS89HdQq8jTL/3itKl2uD641KqSLXX3L9Ml4iKH3F2U3wyaP+wcVc6J3nTk4zlDlEuCBj79/7114oEHoWTaix0zW9I5L8OnVchO/4uy1SYdMwk+viA65OlKbV/g1+RQwa13UHb+0+VkiYp5zOfbyH0S1szRz0JzGgQDw00XaCxqscbkZAEhGlfADX0G66tndG/uBhFjmtTTXamhEwD3peJqEb3jT6TlahS1hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [RFC PATCH net-next 1/9] dt-bindings: net: Add lynx PCS
Date:   Mon, 11 Jul 2022 12:05:11 -0400
Message-Id: <20220711160519.741990-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f06916b0-9490-4a59-9b36-08da635733dd
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5Nz715TGdXbDYqS+1Oa3iLnx9jafzcJPQCBjuiwk5IcUbTWznT3lw08kpdqfgDK8hNJhKzwefLKImj8d3hICptYm2oD3YtAGNC8UnzswtLERmGy+oLx0zP2UxFdZVlEBToJohBh9eO91/Aj8ET2wO9cdYgCr9svCRVaISLZa0ZnhReftMMN/v8Tb/wiWrT97J8N/NrjOwhuZ3Qhj2g+70Ucub6BvQCq4HE+BiBqOuegWAke/FX4E4kotezJlOhB9zckJT0k5EarzfbCkcQ3U5iUUL/tkD5ijvA/8gLtAvaK7957S+ShZCBVDJxRB7U26kHyUXtRitt9jwxit2b7gf9peXaeVzfNVABjZ/6m46ViTSqXpMSp29VqkYCNlhDcEDLiXJKxR6sXfg+zHBcqMaVBVL+k8CIjgxmBEiD25O/LFTfm1NM3OPBTftradkc6MpdigcEkv6PkVCWSPmrW2hJBDz61/wnOPswaZx7trvtpmgXKVvlMlwUDZiISmww7UD2ZlQT9iV9TLwTvDovnD181k6qf1P5JK01PN/rBIgQkcX8xFtb/nO8VQ1000IstOASqy+s6nh4bNcAjbARsuKryUHf3EevIbz/YT9ggXhPGlaaNKL2CAQ1hxiNW+gpTqBk59k9P0yUvpUz3zC0EHtAI79xfaIs9b8qdEKJK6mAHBW7Oohu9biYVoOq6L/oFHO5kZyUZ8BhyutMv8Ww4HKxevYAsTnDJ1MaJigJKO8awVo/enBgwmyL3LIZXwFyV8CCqMIRgTMBb3ohmgqusfJSJ1c4BfZArON07NLeXdLflPtwfvZ7/ERXIlYBT2xLU7PsRven0N31V2s6v16Y+sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(966005)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DLr10dTaqy4iwbnQhjticB1EgbyH5NllLNZDMsSoBcGlxztQRIxyZ8eTYRA0?=
 =?us-ascii?Q?UumNab0q+XYfnl62hJ/RQi1jiFouwul7YNPtqJPYj5TQssBTonJaz7zblkD3?=
 =?us-ascii?Q?qTb/DqN4kbMZCrV53HbfkwRqN1P9bmglorSH5imtk+O9rjMVhZ57kb8SuIXT?=
 =?us-ascii?Q?Ys87bSD9qC4Y0n1ODYKNVuU7bSQd6Fvecq91ZihW63A4eXaa8wsR8eFfCffB?=
 =?us-ascii?Q?2KxaDbOsOX7UHuojJfkkYphJT/x0LpM1P8mYHsIhujTRhOZkrlk0SraXJrbv?=
 =?us-ascii?Q?Iajzi4DXdKdCM2xrF8P/qqXCc3iQoVJ6ukGaOrwBSDFpv2bm9k1boFdJd6Dp?=
 =?us-ascii?Q?7BgS5rTyu4oCW9++lL6wxIcwwxTYJcYzwBQm/Fqp6DRMgJAxp4cyRMBj7y+M?=
 =?us-ascii?Q?gqBDdB4+OANIhBGaEGDLHuNcVgkbbZEniIHTr35KF8q870oh90SfHTFmW9g2?=
 =?us-ascii?Q?rCnRvahCdkkaX0fZmiD6JYYpPpvQcplcKnAuh/AhRhfnrQ8DFwNuth8Wr164?=
 =?us-ascii?Q?G4qNzmZ/aCz8MUv6SPQCQi7FurJg5BMLu4JGnG3mL/0O8TQ79gOSsTnlFApl?=
 =?us-ascii?Q?18TpYRZPoZhB17HjTQ8Bw/O+HfNqHpYvSrnMgZR656Q4++RwORiOuc3jZIYJ?=
 =?us-ascii?Q?tMAZCmrgGcFqYoFvuacIvEPAChH5+1FDN+vWifojXzLpHEWSBYMg5k70LAga?=
 =?us-ascii?Q?QB9miMzFtSFSZ+TjYyg/jOvkOW7DFv0w2Acp5JrKdQ/HS7+foagPVt91td1i?=
 =?us-ascii?Q?0syOv+Q6btloEXRa9JDqxrnFHsJSq1umf10DUwS0/TTKtq14JSfU0OpX3lbk?=
 =?us-ascii?Q?QADKt06rs6DG14bjshrGsU8NnJ2iiUCMrG/crNP9ov7SfV+BoQyoUnDng4lw?=
 =?us-ascii?Q?lbrv13l227hswXEn8dwnLuLJU3Lcxv4WBeG3CD2hGflBe5p99rzcuo0ESdYs?=
 =?us-ascii?Q?dbzw75Nv2p53iiNYYz9bZn/VAFqnohLXrhnUNljzbrS8LW05+ZHdqscXLdD9?=
 =?us-ascii?Q?c+eaz/Xb9/0ZLT8C+astd8we4/mnBkhwsU3blQiUEj683Qdd+eEPYy/NZ5W/?=
 =?us-ascii?Q?g2TQ7i67QahIxJ8FnokQ5toCdewYXsVC9ZztTBFMbKMrCuFo7E8qeKrif2kz?=
 =?us-ascii?Q?enWDKxugYaGxGqy+ijl01Q9A3lEgkITUgBD2zh7gR1xoklulNb2ZpfwlVbGF?=
 =?us-ascii?Q?tV69cbcdK4L67lD9LCMjqDWdkfs3iV5fl6as7snxafLMI3AH9D8+/SDRogfn?=
 =?us-ascii?Q?H1+I/qk3PPqotsKs2KqhAZ++umWrw4vqlyQJRODQk/g9jCNseOYNfnSZt9Cd?=
 =?us-ascii?Q?3wdO0f42C+CcGN8k0VHR1TEHe51lv9q74dtaxAAywN4kn8zocI3p4Vv5Gxm/?=
 =?us-ascii?Q?K6MLrUcEiUc6hI6hraTAhMqa0FLYR2q6BM+dsds+fhfrXdS0U3ExFC5ob3Q0?=
 =?us-ascii?Q?ZpXI2CrEScaB4GomhQn8e/TgeSYXBFBlmgBOY7rgRLRpHlp82usKXoRkyy/9?=
 =?us-ascii?Q?1kjXRiZB9MBgqUj6OaUirJ3Chvpe52dAlclp9MzDKpfe+0qw6GH6znxXmkKb?=
 =?us-ascii?Q?t3o7QvJ/ZjXG5eBndHfPQegGW8GT79Mf4EQB5WFFm43chumjZ8gE82FC2EI6?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06916b0-9490-4a59-9b36-08da635733dd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:41.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7Z8r+ARAx9V+HLX7k0kFiMqXqfAFhRIXKYJlpZPlUpv1gZQ66TC8cVqkWKEHiBZIaa5Cs/TbX6a0QFX7IpXwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bindings for the PCS half of the Lynx 10g/28g SerDes drivers.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../devicetree/bindings/net/fsl,lynx-pcs.yaml | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml

diff --git a/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
new file mode 100644
index 000000000000..49dee66ab679
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/fsl,lynx-pcs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Lynx 10g/28g PCS
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+description: |
+  Lynx SerDes devices may contain several Ethernet protocol controllers. These
+  controllers convert between (X)GMII and a variety of high-speed interfaces
+  (SGMII, 10GBase-R, QSGMII, etc). Unlike the SerDes itself, the PCSs are
+  accessed over an internal MDIO bus.
+
+properties:
+  compatible:
+    const: fsl,lynx-pcs
+
+  reg:
+    maxItems: 1
+
+  phys:
+    description: A reference to the SerDes lane(s)
+    maxItems: 1
+
+  phy-names:
+    const: serdes
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio-bus {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      ethernet-pcs@1 {
+        compatible = "fsl,lynx-pcs";
+        reg = <0x1>;
+      };
+    };
-- 
2.35.1.1320.gc452695387.dirty

