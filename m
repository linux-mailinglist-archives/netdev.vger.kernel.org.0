Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7668576944
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiGOWAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiGOWAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:00:21 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50072.outbound.protection.outlook.com [40.107.5.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377014B0F6;
        Fri, 15 Jul 2022 15:00:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRs+pga8Oqjs6yYdcG7HXgdFadqxAnsfHma+EWRKmg3nst6f70w7YIYtvpu7Bj3h/NqPpsuyQaZc60k6JMjmqCjpMAQrx985xmtKCxVKfjr69/iqxzgB98i1HXgV8+E3w0lio7K5i1sF0kejp6xggud68wgMPdlS6V70835xuXHj6WYc6GNKhvQ89eZ9sD5lK8ntmYK7BJyshvtayhHTHDVF0JhDFWbhkwkgIWyozjUXT09b/mUrdssSl7VuYvq392DmVEosXykVcz5yS9HoDqIV1mmB65s70Q56cgYk+pkmVI1yTBhTE05a1I+mm2CsegZ9qamoTDu+GfZL9ntACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGRZp8xi5T9B/fugG8PjeWl7roGT65YGvH/GFXawhLc=;
 b=G2KURUbz/TFqe6L/SNBIpie9x3i5GiqrhpH6b0ZDOwEuB0Lz22sVwy/i37OW7KRxBo84RpvE4eIy4LtD7S/Ejx3LgjGGAvUsQvadmPPm3XXjVBXWovgy8a1y/qi73ArdMzoLgIKYGLOkrMCughppl23ghC0TEuSNGGKpgIdwl0ikTyVtsPmLL78PHkuyy0NKbPB3NFBh1QxruGGuAqNg+aJ/HvvG8JwacRtbhI+vs7RnlFNylDLoA5z9LnoHl39rF3NCHN9qh1ZVa1hECm4M+DAJQBsorNTcQhQTyhMreaPfR+InSA1xmDK/fWPCUrLSgU6BAh98MAfbDQIUvKCfkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGRZp8xi5T9B/fugG8PjeWl7roGT65YGvH/GFXawhLc=;
 b=DW989nTOpubiIZsAkKqWpKRLCnJOMEQrHKVWF8Xt36sgghrRzQIkgN39hWpoD7WjMhwH7pdGOIXLMRM2S7LADFMM2WRGNBdTTPSDinyVoJ9K46dDT3jwgr50NvcKlYQ3HTtwUiRzHp4s0xHfFF97xjeQ0F7SSG8Y1RkNZ2JcM+VO/3neUjls3WSm5VVP8E3jH4bEFDhFI7vfDGFjKy/D55AvxYjJhS9NZeJjJxH8OXRHvNLVkfQlE4A7CgArAfyJNoonm+ngJZTCC+rlt4gPVyJtM+ClznV9NijURmYgpO21MPxIsEgtsJ1idaOyav7UBigFj9SdyLAfz7LQySOL0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:15 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:15 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 02/47] dt-bindings: net: Expand pcs-handle to an array
Date:   Fri, 15 Jul 2022 17:59:09 -0400
Message-Id: <20220715215954.1449214-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cafd906d-7a0b-4148-5b17-08da66ad65ce
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TmD+8+9FkU5QUkMqNJ5NlZi8ukxKxQA0RceNznVIZfVVLPshAe8QZwc0tt2+E9GxPMeJYOJTdEBMHgADS+qPsWPevJG/1rU90sZEFzvxHhJ3MI9jv3ujeLOzVFxvclGFOUD0tvLngsFW7o5W/iWJAo2LHYYoT13klzHEEl6Lvg+BEtCCME2y5m7DYJFjd9B0tCh187duK389pvIGlNiNmokjURTNfavl0YVM6s831Jf8aOO0NFqtyPCaA3MS/bZMKez753GN6Z2b5g7XEOhZqe+9EGTut+bk/jkxd70RpVb2sj2ctIRuCAppho35USKat0ksVGjnHN5aLuhIh3Qh7vP56rTjah9fM1V8oSrjGNbIoFv14+lYOG4WsyYDrMHcPtwnFycpiufwtiAJxSluWvgXoHhHXYKBVJD3cMe0NwJ8zOQ9JdDncSwZz+8GYWOoxYosivf+3x7N8XbAhainNY8VhiWBv1/RvXQa9fuZwnwVk87xWF/+M2GiXVf6VttJdNhH+IjmYc2ikGTVSyOiYU8zJcbxPno66OUtaCRbBpqn/IkQ9PXfW8egm3JMUEDRflRAAi1ZzLTm0uja2FUqop9Gn7wjchX5KHgn3zfq9WDVi1OlNgps8xxKhQMnGg8iDwOkDFgxg/EvybHqAzSsFBO+lPpysE7HCK07SiWKDrubsMsUeo17XqXIQfl56pJLKu7lmPmdSGTEjIzSoNVZtAgkLjPJDvssfJmtbQoIq+nzcKqy60qPQRDnFWtYZAkfJpB81Es0y7akov5f00LoXV1J3VybHXgRvrp/tSJ/MEqLjNYgiJNDkNAXL0Pa3GOXtd9iSgX4GbkHX2hsg6er0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(107886003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(966005)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wGrDAder7szXKoIW0ysq9At+db5PyNo4BRDpiGALmgeCp8f6qBWFp/m7joFD?=
 =?us-ascii?Q?tI0noRJjF2SNFkksV/ssTcuXcpZJTUHAIEafHPTz/gpSlK71dvYhFS9kpi2D?=
 =?us-ascii?Q?QwwmvvFz61994bLpBguh8NrT1jQ6ntQocMkUWHu931+MBzYwctpgAGNhrKW0?=
 =?us-ascii?Q?rPtdP1zyafephOL1s6Kw0VtQ0TjWSubF0hEgUWJChsrF2/Z8BtO/Pr9piqUg?=
 =?us-ascii?Q?cFPs+ZH9f/6aiiKhNzhhOVpHgyiIn4HjguI0l8vonHEVoNG1pvDB3T43dF4d?=
 =?us-ascii?Q?EI9Y+Arf5bjIduvGjtWPip1Ci3hxgzlc2wWybDAAM2q+jpVVFMW74+G4SYb0?=
 =?us-ascii?Q?BHZjeW5UNRR+ogTjU8mWM5DVHDZ1Rdd9cxmfZ3m5HOAhw8gITbpAzzSg+2WL?=
 =?us-ascii?Q?o+P+feApU+5XGwclDcn35rcP8zXD0yYJJ5rhFgg+RnjiNDuIt5YXyMYbp1P5?=
 =?us-ascii?Q?uEC3ggS1hVUHGyBpvDRdb7NSxna2jmJ1tGl4TCz/l6pj8iklFlr0yUoZqEBQ?=
 =?us-ascii?Q?Fxa1AjGfy7fWoRvKM+GX4pi0I96RgwNIrB9c0/8HO+FCFz1/OIZm6PAmikM7?=
 =?us-ascii?Q?YcJE77gxuDteM2mEyjO3/xKSUYN/qbrcqM/nLSQXNMjK0WO2KRlkGuJm68Io?=
 =?us-ascii?Q?KmQNfW9WeVGhJxOrVyVu4bRXjKMSrL1cZ0sKeJ9bRQU95nXpIbDTfuuZt7be?=
 =?us-ascii?Q?v2VwVxTwzWyHfSWHm/IRrJu488tM1lknKGz8mzjionwhYVW90ng4uBqv+RWd?=
 =?us-ascii?Q?RdRGOLMxHrspz9n4Bl0RSBVd4+5s+e93ACAe+nUCCEzfemKmLl1fv+2p5NtA?=
 =?us-ascii?Q?iSJdfBHGWwjI2giSGo/O9BI+ybsBEtPAa0T//rqIBBICRgUygVHd1uEhJF7n?=
 =?us-ascii?Q?pCWHDGoO3bD5rHU0nuGORqMilhZHQ7TJHEKIN8P1a6EnUFZemiwMenzvX2xs?=
 =?us-ascii?Q?oanraM4Rn/Y2RIKcsnjhdCRgMAOSDYSqVK+zq7IlZ37qinR/vrpVpR1uHD7E?=
 =?us-ascii?Q?iE+4gTUtyp0y5ZBHNq2UvIorQ5U9eczqyNo0005CvKdj78bEw9epjc6Sul1M?=
 =?us-ascii?Q?3bM8KmWS7bLJh5vOcugvJw4tZvhweKGQHUIQHCgwSg+hwQF5N9UOwk25mw1+?=
 =?us-ascii?Q?0IX9bKWlj2wnraAM+LFL+wu0pT0ZvukzG2bkhtJgiB5j0XfPrlh10LBxh0Rq?=
 =?us-ascii?Q?FSYFgTMjKhoZcyC0nl+etS4ieJGrsQSHRm9zyYeS116kEMtulg93iKufqffH?=
 =?us-ascii?Q?QCtTfuIIiwsh/HnAKr2ynYvskRtXxrXe6GUAbzBFL0ACkb5utODnz3krTV6S?=
 =?us-ascii?Q?tHS+XuLGUOEs/q+EzeBK68KfBSHFdZ1NIXEo/QizdPWEMAEw2XjMXO9QipPV?=
 =?us-ascii?Q?AUgdQ612QCQm5TJGBJUoZfy25LjdT7n29a9uV3kCsRllFriLWXxv4lYMrghk?=
 =?us-ascii?Q?oY5WEkNN3efieNSu6ijOmPWo/FqBjGyhW6U0vzzzIgs4Ni3wcA5XHXhVKmqJ?=
 =?us-ascii?Q?Qsy0wSbNg5Xg71qbTt4z/D/D6jdl1Fot2VjlujnVvv1Tj5KVgtw9j2ubNhM0?=
 =?us-ascii?Q?3gLhys3AkfQZd2feC7yjnOE2047J25MEvHcJHWQwMj8QlZJIOFCemX9rTxWK?=
 =?us-ascii?Q?og=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cafd906d-7a0b-4148-5b17-08da66ad65ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:15.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MILqSzg8n4Nw3O90oniB8DqzxfhGbY75Nna3sRuMylhX2c107GzuIDzNpRxqn1c90S8Rj3UBaqsm+9SYh3Mggg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
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
between them, also add a pcs-names property.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This was previously submitted as [1]. I expect to update this series
more, so I have moved it here. Changes from that version include:
- Add maxItems to existing bindings
- Add a depenendency from pcs-names to pcs-handle.

[1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/

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
index 56d9aca8c954..0eb1f3bd6f92 100644
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
 
+  pcs-names:
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
+  pcs-names: [pcs-handle]
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

