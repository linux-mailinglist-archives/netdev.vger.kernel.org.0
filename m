Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F1258A170
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbiHDTrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiHDTrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:47:33 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75776BD58;
        Thu,  4 Aug 2022 12:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfaVS2WdU0G5MNEsY8JZu+LDiozGu5O6LoGbkBC14mFMnaD0lUtbg2tgNTyixrBD2I+0F2XOLQg2jYKpMRPb8Dn7mCQHWzampZ5YYoEFjnw03ZY5HKeALkhFD723a5TO6zwzsv5pSYbxH4YR01mf5vLC0UmzShhz9qLjB2XEOsZg2q2bVluC11mfFg7sjBG/3afGkYQGAsJM+OBnGfiVv0VXhjs99PSGfJViYoIcN1u8/fkKJCLtKto6TsSWaWYKEgL9XqhbAhUBCi5zXH3yv4tKCkvleX4ZzW5PUtDkdr6Xx2sdy2s9PMQ0GvGT5yRzWeAUKbnnwtk7hWg8YZdtog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PvYpyeGEApRf6wgsniB+2Kn88leNN797NcDENY5oAo=;
 b=TtlRx6Qc1NNVQeB6kjVkF2C7b5YbJIw/oC0TdARqworb8hsUUECgctsI1AwRZydi2pHywGw7kzoqMl3n60Jc1SEYk/qKRkdQoToylpBtSqeW0WLcLqFNnOmIg6GKkebHs1tWGT9RoieAXtOSRwWUM5Qjyzy/ABDY9ss/knOdmaf/XAcoFQykypx/LL3GUEc92qq74O6BeDXSF8PyZAegVjoJSUYwhQz3K3LJSuBF7lWKHO6GphxfJWYywFKMTm+3qwtyuaW2eCWDKVcBYIX81JYhWorbblsEtSOnupH133vjHa10BTmziCMhSMYkulVhfopfeFRb2PJQZrIrIzwBig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PvYpyeGEApRf6wgsniB+2Kn88leNN797NcDENY5oAo=;
 b=tZXk7OyOgC4KUjbFIsB0YJJOiRxmUZaOh2YejJQziKDKKnxP2x6MGQ30qSo1GUqcaV8y69kadM0UA4rMkPThyHcc7Z21Fw1C04NklI2EzOyJRE82e9UGuonELSefKeba7GgXFNKbBah+JZrqzzXDwRwFsBHr3rWKANXmrezX1Kd6jsJFR5uBh96AwaWP9MbdNBTglDLFX0djrCT+xkcJafJNyQBogBaEISuYhoNFloV2RZTTRMMjAUAmgB/3aUYr21N8quKUGy2UXWB23y3qknAPEUdHZLtJy6W6Ax/5TPhsmp96HN5Horv4dbLa2fR480E18wf2eL11V0+s5JEx/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:26 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 1/8] dt-bindings: net: Expand pcs-handle to an array
Date:   Thu,  4 Aug 2022 15:46:58 -0400
Message-Id: <20220804194705.459670-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10db851f-9e2d-40e5-821b-08da76522855
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9mP0mWqkZbc4aNwHKbJLCbbkR6EhSGZud+UMhgrKf/9PIOY1suazMIH5+srPJQDJvUGv6NdnTXnp+8wodOQqkVKUc2ghokdesCcL/F7BhmgLrJtgzIDkIBjmNWuDFVXav8LQZAzdoxI7JV1vYmXrZ1pgMLKGdDI4kYFtxNUGcxbeq0h3wZOir5dXZaD04jZg2VfDXZbDMa13OuQPRfycUcEps2fMXf3nTB2fh0NM4j6TemP/iV8GnLV2KSXCNkKPUuvQg8oPJi0tOhZJNgEdnQ4gXMLth5tK3U059AZCkMZST4SfiyUGr3B+b1D8D1jLSVW0+YXxSPvKWkjSKKbwISYLZYliz5FJ0pCCI/4xjHaXwDhlbPi8ry2jUocgYuqRPBi4XfQCEg1S+dkW/EuhClpdUo8gd+Muiqgxho50Qtwcx5KvJDhk75tDb23uvmh6St1bhJCxUvxCHjbW0iwf5XWYbPCJgUFtqGENlI1jcdCX6Upes00STktFtUWHz+ab6eK258fb0Pz16EfEYfTPTm9dwdblifuuq4PcTLoU9Fsj8LARg1zaMn0LwjP4NJGKbHdpMDKA3z9pK/3wWdE/TsQmqjVDGBBBsf987FrhNXjnR/n3fl/ing+wAIiIq94Sy6PKJxRMFNdXACWvVV1hiBqT81yVdGPX6q86NSssEbub5CnFj3IrEtE0aHsmi1fyU4NENfXkxm4lreb929n9k0XhpIdU7AyS/sEbuVEZT/0Ck5Vj3taBTQROmS15C3HiDQwyZHstvcBi0vuYlqjxCmo2ubIREiRjHNPWJIvnoUOX3VeeqGOcIlmGiIc5qIFoon/qeZr4cJiiB1N+yS+0xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(107886003)(966005)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5DAHHz3NjA3zAIUgV3/Pq3B3AhppbZ6V8VwinIF1Sf74k7ibXDyxZPN7wdvQ?=
 =?us-ascii?Q?NOlJXeJTEzjtnUXX+4BRvouxtfBRaUH8q4MYE1WvqEpj6OxbxWTJA6my+O0w?=
 =?us-ascii?Q?8wHBQNLzL5Zs2REhzfVNcTtlyCmDVRtPReGIoXhkz7J3OfA8PemNhYso+rTl?=
 =?us-ascii?Q?QZ+TZW5j+aH59vNpy9PlWDJOiSW5ZRDrCPFIyAsLKrEGzEHiKAnpephBYHU1?=
 =?us-ascii?Q?/sNqqGj8buddg2c7AUV/sSvw128nqqAmcYWDgETBmrSwhztEHw5y/Ny8n/hq?=
 =?us-ascii?Q?G3l9IsoBKt+N2/TR07ibK2IC5kQN2PhJ+Mo+1AM7UFIgG+Uegnsa3vmYqFuh?=
 =?us-ascii?Q?7QjpdakjhvXfF/SorUZyAbG/ZrvgHvEAywL4YvV4xcVXAJvHxvYeSwC8rjIw?=
 =?us-ascii?Q?tNRlWCYeMsR/PjFJVz0Tm/RRv49cOqD5qcHijfKRZzCnqoHY+Y9jaLo1GRfz?=
 =?us-ascii?Q?ihBUDqxqhJP5vDf7GfnaZxrbCAtN3aoOVV8Q9MQv1rLSNYVm8q9yLIg3xzF0?=
 =?us-ascii?Q?p/bjOmPiae7rOyNPn+Jqpyn+QcDoMVunFcSnYywAkPnvMV4Ng6KjwjGvvtoi?=
 =?us-ascii?Q?bY0LxBdPF9jtuUpgDXUG31YLg26HlFfm6igU0T8OvYBIOCiye9xm81CHuQjn?=
 =?us-ascii?Q?6GJom4IuhHQX6/bmO8x0111+K4l///CfyDsYJq+ewrpBpQ7gCsEqfb2OjMlT?=
 =?us-ascii?Q?HgMlueSv93qKq149NiI1kaPnX1tsX48fnw7AZhT8GetI2MTGCxuhIyobb0yH?=
 =?us-ascii?Q?2SsXbRrd6i/Lk/Q5P6j8f5qxN27CZu5SFfev3xGtE4wYtiMkyYs5hnWLzbf9?=
 =?us-ascii?Q?BTLGZKuZP/nL7J/0i+aas696tzvj+VsQyXfTeoR6BwJqh2dJ5A0pDm0tkt9a?=
 =?us-ascii?Q?Mc6U0LohSEciP18m4a7MWQXmXTA2yDui/myNXqVvkDbkI2g8ofENRWYOW6bm?=
 =?us-ascii?Q?8wiLCxuleT/rJYpdZ2S16bY3uc9NGh+BtZtnT+xkul+Za0MMktKSuUP7if6t?=
 =?us-ascii?Q?dkmGd14Wgqqo+HkLPrjRz75Kn0lgAUeCHenybqE5K1BkNvfbA1bG/e1saIh6?=
 =?us-ascii?Q?QCw7ifkvxTNncj3tdYyarNr7U+MC4rDI5jfYpTUZneXFIfklSrfFYNs5b1e7?=
 =?us-ascii?Q?mFo/4bnlWUYXBc63eYLxf6wlvAkE6Yiz/RqlzGOHY3r/QpMZIuoc3bMnxrWF?=
 =?us-ascii?Q?ncOvEXelxhbd1QSJJLM5RjagM5rOi0OA8rmt/vcAN3NmfrXT7RrRdL4YI8MN?=
 =?us-ascii?Q?JFddipvcXOd2OETBW7aJq6gGkU7JqOmO8HMRFKz/gk1UliRcSp3Y6pL3vz2W?=
 =?us-ascii?Q?0uTjQxzUsj3HYUzCl0PyBTGbetHTUuY8qdwGFy5d5evKDKpj8BaYlTNhNWkK?=
 =?us-ascii?Q?Eqg5vo24sBhxOTpdmvuNWQpHMhHWGRSdmLmIn4tyMJ3BJi9ZJ/iv0emZpGZ+?=
 =?us-ascii?Q?raFJ8ApEpoaT6fVi3czP+MluhgbMFMKpHJ7WLpHoRP/Dlig4PRZMMbJ7/J3m?=
 =?us-ascii?Q?AXi2zQLFNZUKBpcuElierQmuo3bmSzLjmAiFiytQIpQoYogKttk5VigwMpZT?=
 =?us-ascii?Q?yM/yXJKt2VncZCa8A4TEYHnH4vFHxlARpB6wswW2N4tC6C2xwJoSKCjZWA56?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10db851f-9e2d-40e5-821b-08da76522855
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:26.3841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldQIRXX3nMPQSTmvdH0ZAb2XK3eo+LphDapUAtP/p9R28esmUVLyCC2TFAIQpT7poKX5SUa5i4McUhijWKp3bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
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
- Add a depenendency from pcs-names to pcs-handle.

[1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/

Changes in v4:
- Use pcs-handle-names instead of pcs-names, as discussed

Changes in v3:
- New

 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml           |  1 +
 .../devicetree/bindings/net/ethernet-controller.yaml   | 10 +++++++++-
 .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml    |  2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 4d428f5ad044..b87574549df3 100644
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
index 56d9aca8c954..bc4c0b060a4f 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -107,11 +107,16 @@ properties:
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
@@ -220,6 +225,9 @@ properties:
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

