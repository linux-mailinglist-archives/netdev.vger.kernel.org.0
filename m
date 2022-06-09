Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308E9545281
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiFIQyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244387AbiFIQyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:54:20 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30585583A7;
        Thu,  9 Jun 2022 09:54:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuRJshWeThNpPQeFnS5vpEz0tSznNOSeTMbq1Pj0QqMJE634i/wcTkaV5xXCmGbsFdVJQuLwKHDxCQsG4AeDRIwm6VznfxorRiV66QknSMjE8Y4j/2PFtQH6sJzdgeBvRVOsFhF/BNfA9khc2vnktuSnqCbe6sBLB5MI88Y0RMfXQVtFgT6unXWlHJYfSWkhoi4I5cqgnWj++OyJAIWR5PZZD+hPRtrupX3hyfXSj6lh+vsn/XGcBpkqoK8qC6+5/V5qwUVkhN4THrkJN2pJKfgj/k0fXfL4n2a/bdgOH4zjNOurBy5INbnalvale5aUUSITXUjJJ8HKnP7i5MGbGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIEoztxhPArcJ85fWSUy6xel7/OS3ir7tY0wPrcbbw8=;
 b=D6zBhr6prJauoEtKFwU4BkU5/cpiEpiZPysEanym6DvWvB2y9TJdcDOVfDjpsOJVT6k7JL+H2I3uujIqE775APcLWlWW/QWBRaxYKR7plGMjlLpbj1yxxh8FkHlL1Us1aerGUKp9x605c2D3Z023aoEubUUQsEmbflWuaJGJtOv1wdOD/fqTtFPVzyx5pDTGAvFwE+JU/aoaOHA62+9zi4FGLysyZE1iowzey7onAjKBmxbaFh2j0VnGn+H2W6OgZzTDQAru4tul2WJkmzgoa/RgTkdBYq79/a+GAoVlH5yp48E82uugh6yDrF+CEQOh/dV0F8ReKpDgRxp9hJwuwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIEoztxhPArcJ85fWSUy6xel7/OS3ir7tY0wPrcbbw8=;
 b=Zt7IhL5bqjzolbpY51y6xhGT+omp2qx4Mb/DC2cdqdgJF170YpcqFmpJLt9LJLnSVGs8kkFWpsRG+de/rwXQbx5lWqVyD2F57HZWsnD1uXDfegCjFisEkpz6JVOSDY0IyG9Z0gaO1ZxzeajOaoCCzi5K5X5tU1qHI47rqmENPHI=
Received: from SN6PR08CA0019.namprd08.prod.outlook.com (2603:10b6:805:66::32)
 by BYAPR02MB5525.namprd02.prod.outlook.com (2603:10b6:a03:a0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Thu, 9 Jun
 2022 16:54:17 +0000
Received: from SN1NAM02FT0028.eop-nam02.prod.protection.outlook.com
 (2603:10b6:805:66:cafe::9b) by SN6PR08CA0019.outlook.office365.com
 (2603:10b6:805:66::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Thu, 9 Jun 2022 16:54:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0028.mail.protection.outlook.com (10.97.4.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Thu, 9 Jun 2022 16:54:16 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Jun 2022 09:54:14 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 9 Jun 2022 09:54:14 -0700
Envelope-to: git@amd.com,
 harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 pabeni@redhat.com,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=39938 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nzLQD-0007yV-UW; Thu, 09 Jun 2022 09:54:14 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 299F51054B2; Thu,  9 Jun 2022 22:24:13 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <harini.katakam@amd.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <git@amd.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH v2 net-next] dt-bindings: net: xilinx: document xilinx emaclite driver binding
Date:   Thu, 9 Jun 2022 22:23:35 +0530
Message-ID: <1654793615-21290-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c682bf5-f878-4293-ad6b-08da4a38b07c
X-MS-TrafficTypeDiagnostic: BYAPR02MB5525:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB55259E6B099934A7DBC32152C7A79@BYAPR02MB5525.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sz3+evSfwxz5kXz8HJQJmzjSPju1b+dTj3HybgohObM0pLouBQ2xCa38pVwYFCYOMiPPAkahv8bbwlp3jE8HloRFAcIci745jNGFtUxyV9YldhTT/LD227KcnUFp8KGovZ/x/ux8zdSaIFwzZEFMgxUARCxskkxF0LFIOGlSHWT7V4++NHWsy0+yXeqIXAnC5V4jTZZaeZIwiPKGfRW+Hg7+OGBkHcwBuNQ61UIUoRu0pi8mftXykRR5Plx1dX+eK9Cm4jtQEjFRCAolTnExVwceIjvEWz0bX4MPTU2i0ifXzjp/LsR1PNCYiu41qm7qUpkrvxejsUuMpyDmvqau/dxEeW0ISzLz9hLGTDsSzz4pJtFQ9TZv2sNqfNtyW2yH1k1hoEVYeQwZGVwzuO/S/0NNW+kq8z3DyGw0ROWA3bkOp9Ms1cxRFFS45UtKgd3UYjkTCzwuITX5NIUa32WMnz1LS+F0Y7PoeYVEBv2vXe9NOICnUMOEF2gBmpAqf6yBt/19Ve4eAcf4hpjEPtxuc/y37QA/7zA3JFvI1ATkcSawyjejhCwAbYJpsdGyMHRGH+X4zOoQsX0ZP0Lm6lgmbdWoVTr725eZnFk/ipGKqihvkwrFPPSgPbHymrbS5W0pc3gBJ6imuWHK9GR0l8Xb8vlpb/qrpBrXUEgIqzXeX+7TO44ITliItwCemiIIK20V9ZoJTHchKWBoSFOaS+7/ynvvMscbS4V24C6C+iV7XNMcn5/r81vFfeIsV6GpZL+639Q/KiBOO+efHNFTwsF14PAXpeODCFrME6u0ewlSkH0jo4V+SLn+vtHNLicqayc/o06jyJ3uvkxciQNs7GstyQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(83170400001)(42882007)(47076005)(336012)(8936002)(7416002)(8676002)(70206006)(4326008)(26005)(6266002)(2616005)(186003)(6636002)(82310400005)(40460700003)(36756003)(70586007)(54906003)(110136005)(36860700001)(2906002)(966005)(6666004)(42186006)(316002)(356005)(7636003)(508600001)(5660300002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 16:54:16.5150
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c682bf5-f878-4293-ad6b-08da4a38b07c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0028.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5525
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic description for the xilinx emaclite driver DT bindings.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
Changes since v1:
- Move ethernet-controller.yaml reference after maintainers.
- Drop interrupt second cell in example node.
- Set local-mac-address to all 0s in example node.
- Put the reg after compatible in DTS code.

Changes since RFC:
- Add ethernet-controller yaml reference.
- 4 space indent for DTS example.
---
 .../bindings/net/xlnx,emaclite.yaml           | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml

diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
new file mode 100644
index 000000000000..92d8ade988f6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xlnx,emaclite.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Xilinx Emaclite Ethernet controller
+
+maintainers:
+  - Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
+  - Harini Katakam <harini.katakam@amd.com>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    enum:
+      - xlnx,opb-ethernetlite-1.01.a
+      - xlnx,opb-ethernetlite-1.01.b
+      - xlnx,xps-ethernetlite-1.00.a
+      - xlnx,xps-ethernetlite-2.00.a
+      - xlnx,xps-ethernetlite-2.01.a
+      - xlnx,xps-ethernetlite-3.00.a
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  phy-handle: true
+
+  local-mac-address: true
+
+  xlnx,tx-ping-pong:
+    type: boolean
+    description: hardware supports tx ping pong buffer.
+
+  xlnx,rx-ping-pong:
+    type: boolean
+    description: hardware supports rx ping pong buffer.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - phy-handle
+
+additionalProperties: false
+
+examples:
+  - |
+    axi_ethernetlite_1: ethernet@40e00000 {
+        compatible = "xlnx,xps-ethernetlite-3.00.a";
+        reg = <0x40e00000 0x10000>;
+        interrupt-parent = <&axi_intc_1>;
+        interrupts = <1>;
+        local-mac-address = [00 00 00 00 00 00];
+        phy-handle = <&phy0>;
+        xlnx,rx-ping-pong;
+        xlnx,tx-ping-pong;
+    };
-- 
2.25.1

