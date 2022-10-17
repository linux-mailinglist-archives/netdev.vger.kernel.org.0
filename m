Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3223F60194C
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiJQUXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJQUXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:09 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EA912629;
        Mon, 17 Oct 2022 13:23:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnha654+c2wg3FVpcB7pOr3BHcmSKe5ueGeYctt45EcbfKkgGV6Xu8bjOxqT023rFOOCu8zJb/Pno6lh/htO0Hrvy8QWkK4ea2sHVGC7rgRZFoYL9lnWXK1YKV4Z5gMu36hmnfiAH9A7dI5lvD38JjyTiyMz0rMPaCfQ2rsCx6fsKlEwj1iX6JUcmOE4qs4IsXukKI7TpQTlnazZMhhokL2oCy82qryZmQO2io/ex95faVTMq1VwfhHGQ1bgr/pu+jMryDIBGYSsSiz3AEkihbDnU8qEamAe+K6SBcDxLLtlLuAf2lTI55QgnRFEU1Egdhah7ankVz1GgxbwGnGZ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5C2mgYaqyU3zLTMSIkqkhNLz06t8lV/qE5qd5Sc4rGs=;
 b=RZPgiqiWjGznsuHbYdvbakLgSXvOMSDITjw4uuOtQKvAnWYuxPn79sHdeo6Pru/r5Y+IifjGdVP7ySyVrCUtCAj9D3F6uoWM5fure2Ky7hGIkkxJalhbRXO3VZUQ7dOeb1eQpJ1ehrBWhp/O0wJfnnDrU0aG7aMY+l94pbdmqGpxahzOceydntBIwljuDylcCKoEoH0yKFDpkpPTU77SB5e+b+nbGBbqS7TarDtHg/FKvG7vFBUTW4mdC/muP8JLIErbVCAmTzi54L1oyxDm26rPfWhOWp4pD+8+xpuU4EdpYoLqI/HGmFyjvaiZaDRQoP41OJNo0BA8RymTsnAsbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C2mgYaqyU3zLTMSIkqkhNLz06t8lV/qE5qd5Sc4rGs=;
 b=JFhiEQHB/N9gTLjQcJk2rWykLxpOuNLY381zuXmfT/SMICuRu7duiO7jCGZd/agQsv3HbsHrD0T5GTZYBoiK8O0+2xE4PfaafyJ4VSPkhExVM9XD6NpiXYLG+erkEhHLNo2o6jiGPwgTuH55kBommu8J+qkcGYeeo2DT5m46hi3IIqb8WMLI1uPdhspxCtsJ9mKrRo6fvP3tuqj6gVwuBPPlHk2X1ZLHyZYcT6SpmgYCDKo1PtJvMiOPpDof+sLjtxuH0J+ExdUrD+QcmMyP2h9TfOCrDQKTANShfF9ADWWHETf5XMd1lAQ1PcavoUsfweATNwiSdaQWl2nXjMzo7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB9510.eurprd03.prod.outlook.com (2603:10a6:20b:5a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 20:23:05 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v7 01/10] dt-bindings: net: Expand pcs-handle to an array
Date:   Mon, 17 Oct 2022 16:22:32 -0400
Message-Id: <20221017202241.1741671-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: 48e59519-1cbd-4552-0733-08dab07d658a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKD4eIR3RAx+OPP2JJEs1fj1p+AM3vLiP3wwqRMBhY8qvDvWgC8esn72SSo1rFRb3khB91lyYKC6pSRhwTjhNz01Q9voyDMT4+j4rYb7/0WwgG9sFzJz8iNEfJwGz1A44jfMVOt5KLuGQ0pJPzVzbOni7tiRWVBnrnT2hhJyR4VV3zvh7+J0sTCLbH29BPBJTH64NbI8iD+JXdmWS8AozOkKKwPWJ+Imz+YvWRSNtKavLwD+CpVeh+GrdM84LN1F6+9f8fD3ar+iJ1HZ/LBb5zmjByyJucLhuetggm96guZEIpRn9giWEsktcoQpCaeSJWJOZ+fpmF0GoRvXdEvZpBoU9Q/zma9f0q5rVUpHOXBy0+lFtZsC1vXYKstI7iZL7ZnIamNI3bE7fAL6mM2nx2uhstzdFX3+Pp17hZTIBFcbBWwWMGN2La0XamEVRuPIYCZGoKytDT1e1kXKq9D48rznmC1MoUfqaxEQT7Ti0ePKUWMHTc0KSi00Oz9aMxDJZDdJ6FJPnFVHL361Ut09JVDIdB415fRZfiiC06gdEj4eHrOHLeakQO4rpX+1/ajyHLlG154BO71i17HOV4L4zeS3wyOaFN629R1Gppklocw8tidW6qEp7D2B+tihjditxD7WcCtf8ALhwq9TVBl152VLe0tnZ6kIjeog5VbTvTuDQfJNCeDauA5MnM9GoGXsLqUIn/3x7y9Dn8hEmWxUq0HNbIhcWo1z7wgxi+uIo4iefEKiawvdbPVoAZGqqBAASKY3vtVowJLaMubaeTHcQ5COgT2IoxHNAg9mHmo4E9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39850400004)(346002)(376002)(396003)(136003)(451199015)(4326008)(66946007)(86362001)(8936002)(5660300002)(8676002)(38100700002)(66556008)(66476007)(83380400001)(110136005)(54906003)(1076003)(2616005)(2906002)(316002)(6506007)(36756003)(26005)(6512007)(186003)(7416002)(6666004)(38350700002)(44832011)(966005)(478600001)(41300700001)(6486002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1VDP1KvSZF/x8CBwp5VimAINxh2yYFy8qAhXu6mQvt/1B0/c4m/9O29RBVih?=
 =?us-ascii?Q?F6js4iKWDOF+VHLSum6JCKdMzvWt6/qHUAbVoXqm75B3zyyaaW8Z0B1THV+R?=
 =?us-ascii?Q?w88Ki3fZTaz/N4LilggMIacnmDFvQ04lurpdZYtGVxRTOryWn4AeCzMQZOHY?=
 =?us-ascii?Q?6I2AjF/d9q1WafU7uwEX27rwEl9hjWe4UeawZMKmj/oyU8cJ+i8MAMH4emX6?=
 =?us-ascii?Q?4o2ZS2QGOQTxkDSFskBuvmkEPYEhaHnEoL40+j2msr396d6hs6WpMwzmU7jL?=
 =?us-ascii?Q?IFuGr6vK3FzznXbHbHMkQIgdUXUhipvy0j8KA7gE3WQHOSGu/vYZ2rlOw0BE?=
 =?us-ascii?Q?yWXqlq8be4VE9+k6M8fpz2YD2mLJ4Oifu77Lw8QYaGk8Zt0k+P9d1HLwPz8b?=
 =?us-ascii?Q?i+eF3u1LaM/Zmq/V8uSrxMmnOZii9tj0+d+sQGZbVsL7ixh8kzz0DWLz+2h+?=
 =?us-ascii?Q?1ECRUfUiW2Xcf5JEICQUBdhwT0U2zUNgjGpa19iQlos6YmbfpP8swt2RZ8gE?=
 =?us-ascii?Q?KowORMhnlvehNFwiAG/j3ujNZuzj8ur+r9dxrG9C6ljghrS0gmsmpxZubRIO?=
 =?us-ascii?Q?Ab8tQpwLswCHjbP/ohuRg58MLLJvi67A2zXLhTjSPEg6PVyrmHj3QKYRZOWu?=
 =?us-ascii?Q?x1E9mIbRfakBVJ+7cwb3dr9ZMpBbKheQs7mEwLtdUYFR27NcXLhiTqB+UnVQ?=
 =?us-ascii?Q?lhYqhUBbaNIwcmnZs+YEKHfZFuvAH5Aoj2KqOHYQ4H3WA92N021FCRrSayFm?=
 =?us-ascii?Q?2668qxMP5fWRRR3C1nKxun2OT5gayOrKg2MUM7v4s4gPnEr+NoKaO0SZUiXn?=
 =?us-ascii?Q?lSrrXS3r1RbPgrU/eo6fgfLQhPVD7iI9jHMxWXwg10D1CPt5yrn5R8v72Dcc?=
 =?us-ascii?Q?PK+TauM+nk+mGXi1e/DduIbetDZ8jNP+dZlGBicRD1rY+00cO1qOBHQCfb2Z?=
 =?us-ascii?Q?J5sXdlpBOde/ykJIrbwmZiUShV7zDi5iCxV1bSJc6vwsGv32ncJC0Jvd1M/Z?=
 =?us-ascii?Q?Gs6wfMLS/HEwsR0e9IRaUOaMvkH5eElHvSYAhJp8x9quwW6N37jHviYQwbhb?=
 =?us-ascii?Q?yU5kFH3AW+G3qhWYPMLqcmzeuRSSe1pj+MeOn+4z70jhkvCB+DCZyUipBfD+?=
 =?us-ascii?Q?X2y77mVWjaQ+vdei/H5uvM1WZx4qSyLiu2WSrbPU6WXFyEprw5SO1refL8hV?=
 =?us-ascii?Q?SHNZyRXYSEPHtlBc1nb1WFLFc7fZUU9bcL3dlgIYPYFk9AHmhlSh8ojt+Zu9?=
 =?us-ascii?Q?3OmtA1UCY48zDIw713CvVnOl5q9O/pcXvNrAMSMgKLL7ub34Ec0CyHCsgAyN?=
 =?us-ascii?Q?vVMVK7yOJ2SSHqRzSMN/lS0ckLubGU/iKBozMeyT6Xq/UR+Srg/UcTmCI7yh?=
 =?us-ascii?Q?a686hzpQQQP108JxdIzG/epvyETwjgWp3C23LNf5KU8YBYqN2uxQ4TgusnF2?=
 =?us-ascii?Q?+0uGuhnCMkorM1AEp+6gJYKteje/nmSWHP3LKStJro2ZM/J5A2uFj5gTGYuR?=
 =?us-ascii?Q?E2aL5WF7M3H0AT7xTzbfyGVCmamrFWrD7JCfMoymrxaiMCPIqaSBCokqI8Bl?=
 =?us-ascii?Q?dWcXVowIFhqTp9I/7lA17eAnY2VQ5NzWpv4ewnX60O3OQ6kq4T3icMD3M3aj?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e59519-1cbd-4552-0733-08dab07d658a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:04.9479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWmesjVTTh9QNDhOdujVyUAUr8+CHSJ/bcoIxRCeT1+kvu3J5P03bW8/mr8HA0xUIKDJ1SyQW+awjZIg1s7O0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9510
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
Reviewed-by: Rob Herring <robh@kernel.org>
---
This was previously submitted as [1]. I expect to update this series
more, so I have moved it here. Changes from that version include:
- Add maxItems to existing bindings
- Add a dependency from pcs-names to pcs-handle.

[1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/

(no changes since v6)

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

