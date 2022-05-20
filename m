Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5643352E635
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346394AbiETHYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237685AbiETHYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:24:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3514ACB8;
        Fri, 20 May 2022 00:24:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J31dPySAm1usdQXBQOqe84Y1vrhfPPGoofpsNH9WO5G0w48VFVZbTIQSUS2ucpPWOV6D1RDSyCyBpfbnKFc9nzgTwm4QL+sMoghmrULO+T67J0gTO0GYExWnPUOSUJiEZh+2k1xBrBkjlva7aDsDxdC0TYPVUgppFofn+kDF6xfb13QVWUM62yvNJOWOGUwlirNXWOdSHPD4NrX2HFzxkyawq9I/YmkTGv0nasGHgnru4IFYjJx5047jQll5OACSzZIWPCWdIUmc8d6XJAMJ4BYqL3MvspSE48EvQNscks4BlrY71n0SSHMcwAD0rVNir5IIRulJnCk4L0+W/srEoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3DycxYIac+I8QNf1P6Whv/9H90n249Yuceex7Y61iQ=;
 b=kAWjCk0iF0AJKGNYMqEbtSzfLltfhu55i4lmdg0xdDzRX++L6rBK9UEBV1Ii8Py0MNGpZjS2CUIfNMDxrT5TN6etvpbbC2qNeXhoiBnzdZt1Lsg5Y0N801E0AjUy7OZGIvBsevbk6gDZIp2/7UMsHFXCGGMo8fJ4CMY0Uq9FNM1Q/n8DtE1p0GvNifr0sNwlo+x4z3p7SNDh92xlfByPbE3ag2hD65iK/qavHbc/lxrxRxZ8EKcpRfZVQFVC4a9/9pHChqUTLJAUqd1x+0Fii8n1IRLCF7zRdEF1Cn6djnE4ZcG7p6NvvvJBLJSyCMvCiWNkXKIUgp1FCBccAOWNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3DycxYIac+I8QNf1P6Whv/9H90n249Yuceex7Y61iQ=;
 b=TDo7S4ZSht5lnJrb0THTAlv9CCPN5KTxCRMF6ZaPXWdqhsKTfTkS4vZ1ix9kT4Fd1OLaZDLSel3bIQr1pPmimo1DA+x8QPccQnnCwWWWg489yGb98nWIoYTd/MR7LS9y4zJfI4yT6Zm/pJPFH19gqa7bAzW7h1eA5ViqrlhK/3I=
Received: from BN6PR20CA0070.namprd20.prod.outlook.com (2603:10b6:404:151::32)
 by BYAPR02MB5541.namprd02.prod.outlook.com (2603:10b6:a03:a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 07:24:44 +0000
Received: from BN1NAM02FT007.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::10) by BN6PR20CA0070.outlook.office365.com
 (2603:10b6:404:151::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17 via Frontend
 Transport; Fri, 20 May 2022 07:24:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT007.mail.protection.outlook.com (10.13.3.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Fri, 20 May 2022 07:24:43 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 20 May 2022 00:24:42 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 20 May 2022 00:24:42 -0700
Envelope-to: git@amd.com,
 harini.katakam@amd.com,
 michal.simek@amd.com,
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
Received: from [172.23.64.5] (port=57868 helo=xhdvnc105.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nrx06-0002JA-M2; Fri, 20 May 2022 00:24:42 -0700
Received: by xhdvnc105.xilinx.com (Postfix, from userid 13245)
        id E0C7860553; Fri, 20 May 2022 12:54:41 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <harini.katakam@amd.com>,
        <michal.simek@amd.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <git@amd.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next] dt-bindings: net: xilinx: document xilinx emaclite driver binding
Date:   Fri, 20 May 2022 12:54:33 +0530
Message-ID: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0330f094-bb2c-4b14-f64b-08da3a31cfaf
X-MS-TrafficTypeDiagnostic: BYAPR02MB5541:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB554108731B5986300DF37D6EC7D39@BYAPR02MB5541.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T0RZh6dzwPybrTAD9KJx2IVSKGtuAbvwSSS1r/ewHEztydpFfsUCwZ/r1JahJMw3Cl8xhEytt3G7A6hm8YXUFe2CCHjIIY0LrKDNlpW0FMZiybL3pd5fInS4gxqi1O44+YGGR8t5tUPz8gWaPmgR4H7IWCEwzO0GO/x+n4Ajqu4dvEg3cPQMUF/i9KBw+MnpK3Tz1f+B+mYag3NLzBMGnyM0OcDloUXgS9mNDGn6FXBThF0hSlU9Tkb+aw+a1kAcnBDFfJqF0SIr1kgsYGAB+cJhurEZj8qYPdbyzV+JNil02lJd82IrH+9IpggmunqGSOmf/Td9DaWcPzoSTf+lrI1htccmLRTjLmuLOgQESuAphaFubk5RvlJ6vgp0/eSsxMDRV2pRYSRisPLNlwud9Lcdc7LC2stVIiF78dyBEEXTmtPZ1k+jiO6Hy/SKwsFXUXYUI8rRbfV0Yxvael/NbI6m/E3PoXrSUh9wqCitrwkZAyItox3LtBRbxHP3Tz2QiMQAU2gnV/DTtoTwo3665auhKl8kJwu2c2iSU2E8TLac/8wrcMU5G8CIuTBgU8N3CDMhZwnVf7mWtbkzwLKxhzYeiYhhNNg27EveeALNyxc494cqUu/nytmSNXJur51hnexwiXvHXCJ2VDriYs/narYaE3PC7z2uLghyi9s8xm+BscA62XgXvldvuuhNojswlh4ba9BaYQERBxuJF5Xl1Ikhp0hOdX5Dk+DSyzGvOFXBjWPkGoK+UdJ0XErenlrFtwkJGDCynFX0/iBUq2hHaIIOQbH2wbyIk0VrBSCEfdI=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(5660300002)(42186006)(83170400001)(186003)(7636003)(508600001)(8936002)(4326008)(110136005)(8676002)(70206006)(70586007)(54906003)(316002)(42882007)(36756003)(6636002)(26005)(966005)(336012)(6666004)(2616005)(36860700001)(2906002)(356005)(7416002)(40460700003)(82310400005)(47076005)(6266002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 07:24:43.7164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0330f094-bb2c-4b14-f64b-08da3a31cfaf
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT007.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5541
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic description for the xilinx emaclite driver DT bindings.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
Changes since RFC:
- Add ethernet-controller yaml reference.
- 4 space indent for DTS example.
---
 .../bindings/net/xlnx,emaclite.yaml           | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml

diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
new file mode 100644
index 000000000000..6105122ad583
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
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+maintainers:
+  - Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
+  - Harini Katakam <harini.katakam@amd.com>
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
+        interrupt-parent = <&axi_intc_1>;
+        interrupts = <1 0>;
+        local-mac-address = [00 0a 35 00 00 00];
+        phy-handle = <&phy0>;
+        reg = <0x40e00000 0x10000>;
+        xlnx,rx-ping-pong;
+        xlnx,tx-ping-pong;
+    };
-- 
2.25.1

