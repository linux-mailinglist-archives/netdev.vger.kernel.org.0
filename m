Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377365F133C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiI3UKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiI3UJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:09:57 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04F82FFD4;
        Fri, 30 Sep 2022 13:09:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2CZ7Skjhl2yNAdcwoKWF1XMdoSfPO6RupNbd/XBQ/sooqB75//6tog7yEx5i8QBdQnAcJaeqVsCFjtNTDeZUGQKiEYUlxFAj4czcB9Lqcke/XewrMF3RdkPhtrw0ZC56PRfbRFXErV4pLW9qvprak147l8CtiL1sobchUui5Gt5JBSfiA9T222H7HBpB5aTz/QJUAIb3N9J8ZdHIrWf6fhK+c8Q63pN9/nXf8qEY8DEWxMSkpMUF4qXJp4dtFlBCyYFJCDjNS1uQ0xhK3yPeBsiiNksQSQnwcYVytfTppWPWtOeIFnxfghakWiQ40nMQ/RcGeuzhd8Nv7GqDlb+NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXjLqwWMpV2XpC7fLGy5gkAmQLz7kjCf3t5/IDdyekg=;
 b=GEKKSfDC1wgOF5hf7c31OKcVbOhrZB5V2V54k9bgMqyx3CaoXUpuhcjf5xOib7To2YpsZXiQfF/keUAvutwlOvIjIWGfaF5KH9dhF/CnnpTJYQdDTV2/VKzbVMakjEJk8UvDp0vJeYwUPIxOeWMRGK3Z9GyOoMyBmP+CSjoDhi61vySSj20MToclg91AJpDlvhV/cneoYFcYlYMG9KcClHOzmS0QF+Gb8NrI6KybPbgTy5LHDz8gczRFQakAYauHak8ga6mbS9u49Gdf+zJsq+9FVQkLYKLCeK1uKyHa5BHPRPoQPMD/GwTPH2NdGt5KP0pip/1d0lJtVlepCiG1mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXjLqwWMpV2XpC7fLGy5gkAmQLz7kjCf3t5/IDdyekg=;
 b=S0EXexkR7gozFnVOSAUEwtjuVurQbPTijOZyQO03IlrYPnArIGp6YtAD5XKShWrWnlUTYGtYjeSXQgPnoKDx9eGU1YOvjH9Ytng/anLOP8EMR7g/xAdaiTREpA9lg0v85+vdj291Ku1SwCTwI4G1CLhVA1KAsIpc0ckQ63rrSSMSyEoCZ5jAMMKfbQK0FOhRiwt7E45VjP7v3Yf3kMPvZdzpiqa+Q8GWK2MDxmeHfyhbZ2+WM+YOtSAXyQeNM+TdMsUWhh8Sl0f7Erw38k24a2roPzJDzjduA2QAL54K8ANPvUQUg7lEXqOEEKqM+5MhuFVjl5247ZG30ZMOp0eg0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:09:49 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:09:49 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v6 1/9] dt-bindings: net: Expand pcs-handle to an array
Date:   Fri, 30 Sep 2022 16:09:25 -0400
Message-Id: <20220930200933.4111249-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: f3f05b0c-421b-4bbb-daea-08daa31fba2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fHlprHe/KE9vtRbLTLac4q2HTmMGg+Go5YzME30kNApyyI5SVYzLXioY2+JFDjr4Ob/mWWuaVpXO/puuZsrLehd+t+JS4mvCX7aFEtRib5z4e4EOPLCpciVsBIY6btydZzz2c40OK8eruv6+pd3e/O52lZOfPzdWxh3jdju4Nn+QWRUOqITHBRERUg6YIB/S1mfRxH5DRHbuqJBDrsaAZOW97HGijk9+qLK274LG8KdZ2Zwvfs0pJBez3DuTvQaXRJkNlI1u1i0NvyRXdbEobL8VQOj2toeomIRgMhNggQU2HxzjE8qOHAGORXa/fqEmfqO5eaxF4C+zCGep12C823giwQSI7erQ7yXN/hFAxvkU2o464QMZZRxuk4+fdnBRz9zq88TKF19vZYm6HSdFRIUWLGxVDfcWWtbYutEoPJGSPvkyXGi1TOYDl68i0rgkMpEhmtxAd3zsG/VT2RhU1X/NdohyPUdUXi34HiWTYcwl11rRhggkuArSMjVw+BFIPRBe5SkqZCKBgaUv+OOf8eZKTvjppN9wX/nXTaOJpB8pFmVMFPUd3uHgn4rO6h3ICaBi+9ArMDle2v2hNYvvyqMwpxE5UkVs8voB4JGf3W0vJKDkn2JbwcOpm7ejcL3Et1MTmA1ma3ZtpdledAOQy9W69jKD1zufh9/qS9sN4w94MGzF91Z3OoKi2L9WyBxmZKb4No+zNMl2ud9IMfbCsBqvuC8Q3iDpVbEnrg1tUZ/m8W4kCmQ4AgHwRCkt54n1vTMyzHMkLG6ppVuTu0/F3HB9GkBBT5TERSDSm1aqaoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(966005)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gLSdFyfSkBAU/E21cP9rWqTRm+3Yz7lenHMSk1UpMJ1Xrrv3+qb7qgcr26jB?=
 =?us-ascii?Q?66naE7300vzdJchUnH5RzcP9xK05lZQVp7tQ2p1F7vOyBqgnwgnICopBXxZh?=
 =?us-ascii?Q?JnLN8iI4c9pE5/2GFcaign3kFdPsZSxPaDB1HENaUM3nH+qgkv2szOPLMA8h?=
 =?us-ascii?Q?/ZTy9lXTApZxnkzivrtJcOhNEW1WckX7szZx7YzvxU6TDU94NfXF71fWcldg?=
 =?us-ascii?Q?MkHIgY2Winx2zMkT6Px5wEohO5VZKTmijD53w0+Xyxsin12mhbWp9V1UckK6?=
 =?us-ascii?Q?Al1gWKXYgaWXbK9/RG4nUyTdcr09Ma4WOzqv+dtmu4ss/a05OYflPgT+We9Q?=
 =?us-ascii?Q?CTkuLd3oCACoYI0ht248xKSZSqJhWNqnnmN7bVn0+SI7hcNyrmA2/wHU6hyd?=
 =?us-ascii?Q?prAyPmcckW8r1Ew6XxjJrJp+coD4Y8RTn2hpU42nJ+xGSjfap67u/3LxX0o1?=
 =?us-ascii?Q?QJPk2DmSQL9dX8c+ZQMlktOaON6Zv3hVuusqisPXQso623Mg9D34sHjGP0cK?=
 =?us-ascii?Q?X/4INViTEMaHjfgNU+9cZsgwzqTJAX+1K9/XJ96enUgZQFmaCLakATkcVUS6?=
 =?us-ascii?Q?8pH5B/OiakqOKbyuXh0RznjGOi3m3++gOeWf3PS407FpJ8U73uvSAIH551tV?=
 =?us-ascii?Q?+PpgxtSB9vJzfYlxPr/JKaU/K8xkH+U6D6cDE/I9lz2nPEvdD8l0ycqIcACT?=
 =?us-ascii?Q?dnxffMUrJExzUrZQAjteXQ3sl1e3G/lnm2fOAQdKKEeqVtcdHGR1HDZwF3Ys?=
 =?us-ascii?Q?CgqD2r8hkhM5VsDMhs0bqji7lRaFQmfEzty79lgngSSR69ay1Ha57lMVftLS?=
 =?us-ascii?Q?Hvgmi7ufX5AetcpJ21qF02qWtvaP2J0aKAfCLBwYxNv6Orc9/uo8c+Fj7/sk?=
 =?us-ascii?Q?rHpS9+bP6pQqNfFIIwIwi7DEmntSHN1iP9Hmuquxmhg+5L3ebyT7OC5LswLl?=
 =?us-ascii?Q?ErFemDBvHv3D3sM07fkdKB1wZMVf2e5iSJeU69q0XwM5RsuzQZSJ+gVCErCw?=
 =?us-ascii?Q?wHdzgjyBZk13rS2MG/pcGRO8pdmIDrVjasPo954Stq1qIhJh4IuXAz9oz+0e?=
 =?us-ascii?Q?hnuuuZdJPsNdm/4oCLx9xLFt/tBOMCEZLbaKXI2mDbEZW9OO4LH+24TOxpES?=
 =?us-ascii?Q?12vYbHtz1lnIPr+jqSqvnRsGuwkLXKjQPj+X8SfH1G/OlONT67un4bJafc9Q?=
 =?us-ascii?Q?9ml3s0ghVGW96zTMD1GGccBjyXsSLS9aI2FduOnMTaO8e1rvLVDyxwHVYE1n?=
 =?us-ascii?Q?hsMDny902vqTXoYOo8uknz9zLTEHlRFcWHiGRywlxQwzJjQVsQoCdCl/4ybs?=
 =?us-ascii?Q?/NnQzCMDwtfuFUUsexUbtX7B8PFveqzhj73BK4kiYTvH6xntxIgFfw6G991z?=
 =?us-ascii?Q?EiP5uqykwdUOZX2mvhGehzXhNQSPDl4htQfPpv5w3V27lBn4HSWyQkz2nj0e?=
 =?us-ascii?Q?3edRh3CtdhB+lFA8pfJHshQJqAKQOw9QI7naN43+GI03FGJpOcp2VZoOQ0km?=
 =?us-ascii?Q?ptcHTpVOWg2NBr7k3v3fHVpu7ubsLvGRZdijaeUJamct7Kn4gg3vQWJjePT0?=
 =?us-ascii?Q?dxLHyy/Mqyw0Uxh1i1qvppU9gECebf2YVH2eU2dFLKKCcIxshibE2s4I3OiM?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3f05b0c-421b-4bbb-daea-08daa31fba2c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:09:49.0724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7ATmW9qE6+M9re+ssfqZZWQp54KJ+2IyMpOOuaCl2tIEYnybayTOP0x7GaN1oz7zzu6CvuAOBYuxBscpZCToA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

Changes in v6:
- Remove unnecessary $ref from renesas,rzn1-a5psw
- Remove unnecessary type from pcs-handle-names
- Add maxItems to pcs-handle

Changes in v4:
- Use pcs-handle-names instead of pcs-names, as discussed

Changes in v3:
- New

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml          |  2 +-
 .../devicetree/bindings/net/ethernet-controller.yaml  | 11 ++++++++++-
 .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml   |  2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 7ca9c19a157c..0a0d62b6c00e 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -74,10 +74,10 @@ properties:
 
         properties:
           pcs-handle:
+            maxItems: 1
             description:
               phandle pointing to a PCS sub-node compatible with
               renesas,rzn1-miic.yaml#
-            $ref: /schemas/types.yaml#/definitions/phandle
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4b3c590fcebf..3aef506fa158 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -108,11 +108,17 @@ properties:
     $ref: "#/properties/phy-connection-type"
 
   pcs-handle:
-    $ref: /schemas/types.yaml#/definitions/phandle
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
     description:
       Specifies a reference to a node representing a PCS PHY device on a MDIO
       bus to link with an external PHY (phy-handle) if exists.
 
+  pcs-handle-names:
+    description:
+      The name of each PCS in pcs-handle.
+
   phy-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
@@ -216,6 +222,9 @@ properties:
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

