Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2D5252CF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356596AbiELQkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356588AbiELQkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:40:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2059.outbound.protection.outlook.com [40.107.102.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418C268229;
        Thu, 12 May 2022 09:40:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVdS1t0B/09BtnZf11DMMnjXImCrgiOfj8M3nNiHgF2sxyCaYo2X3VcI+65oMCPaobFTovxIH9j0B063teNXN8JJCTReFHWHWj8pwf5nfbNU1su8HB6qoVDMenIwKJa3P2OUhJ+8a/R+5DLenIJL2Fg/zgxlXFvL8vLHFjQiRVN8y+ILLMFesEhfzWmVFo9MGJpG8z+ba9xNaK2Lyt3+E4iL63LiYB0b2B7ScTf6f7G68FRh0012sBubhQRoSi5Xrb7Q31+0Xkt+I9iiipEfef6ZvJgoUJbS42gfxMSS8d5F3uI1LD7Kk8QWe+9hsS3NsCM2NsZdSUqXy9Wt6brQgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQzYd9RjaqU/NU1wzmH7zJP9qrcEQw8w+KK2aq0qNZw=;
 b=lqlWLlf//fXVkXMfkfRNdm8OsJpBOFS/DZvG0TVc/OkgMArn7r0DISlaWhxQCGHA5KAfpC45aX/ZRSEKQA+jf4l+oaxkWaslGOqSW+/oRULF8laYfh/S0RLhBwPidyyISkpnbJtZhxBv7xRIXEkIURCFjYYdz4zTywImWw4HQDyiAErRK2HYMWlb8uDSnsK8M+C8M/MW0um0W683LxkdUrawkjEWwknWtsyZHzwoxJpxfH0Qk1UmMQrck7AfAhrW5AbKtsuj4Ce3hllrejZm/VnXIzdBZd6j0ctNiXxjN5bEQLwKaDpC4NcxDHkLtBBhdJaAANiKZiXYRIPJW7en6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQzYd9RjaqU/NU1wzmH7zJP9qrcEQw8w+KK2aq0qNZw=;
 b=IlFhSOPx8yQ1EUIzXJwOe+tr9/6EbMfPpTMK5PtI/HV4vdnDni4VxdRKgKHvvL7OvPkY+KuNYQ2Hf4TLTZI/nl2+lp5zjbw0sx8UP10eRavzO3a3UR/udHuvnNBdohpM7CfHg4HIAdsLGFrQKuXiKpIt6RAMj9/gnAkls+u/Lok=
Received: from SA9PR13CA0058.namprd13.prod.outlook.com (2603:10b6:806:22::33)
 by CY5PR02MB8872.namprd02.prod.outlook.com (2603:10b6:930:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Thu, 12 May
 2022 16:40:13 +0000
Received: from SN1NAM02FT0018.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:22:cafe::10) by SA9PR13CA0058.outlook.office365.com
 (2603:10b6:806:22::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Thu, 12 May 2022 16:40:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0018.mail.protection.outlook.com (10.97.5.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 16:40:12 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 12 May 2022 09:40:11 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 12 May 2022 09:40:10 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 pabeni@redhat.com,
 devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.5] (port=50785 helo=xhdvnc105.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1npBrG-000ELL-Cc; Thu, 12 May 2022 09:40:10 -0700
Received: by xhdvnc105.xilinx.com (Postfix, from userid 13245)
        id 970C960519; Thu, 12 May 2022 22:10:09 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <harini.katakam@xilinx.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [RFC net-next] dt-bindings: net: xilinx: document xilinx emaclite driver binding
Date:   Thu, 12 May 2022 22:09:56 +0530
Message-ID: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16b27781-3122-4cb1-b298-08da343615fc
X-MS-TrafficTypeDiagnostic: CY5PR02MB8872:EE_
X-Microsoft-Antispam-PRVS: <CY5PR02MB887274AA18AB64E8E60D2F45C7CB9@CY5PR02MB8872.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SjtrqDDvJ7XEsWl2aDPoD2AXRCuVjwSpxof700scfJfny5F68kVzVUXQhN5xSHs4kT1XPxEF7mO2Ypp/z/oULHSybqNqlPnrKjF4KTGq4tZG2tIrAnOxyGK4ejJnreu+7Ra5+vxFdQl+HQ3xQZ7LD7dtUgSndIoOamLq4/MRyzGAZx2RjbThAG3iwz1wbyS0qHsgR7GFa9b7BKJz4wGmVUwVtsnGPofggKoqmIKk4IWcvRgGei1pZHcEn+dfgw3wvr2WWDbUu0XpQ6Y/w7eCYDzwB6YIZebxo5KHb9bRONIEjt7XEbJiH6ZmKpz6BeuEpm8VWtupTto96JqDDRWPyWpZG9nsUxUzo/Eb9OKUKMiokk9YOurZasc208Z4Z2bIwgKR7Xie95NtpY+u7AMqFLKAKcgsdEZuBzJEWtKYakHqDeToh4cLb985no9umvpWheIJybYYGtbmfNZQIuU65GoyzlharDgiu/Zju6QhNPyCU95CpNpzuIbt+HJzrQrQpth2/hUa5qX/lRlZlOezcunepYPrL0OuDB7NDPwhgNbkh4drP5Ss0GBwaNJwEZ6EzML9u2Nol7pEKS51/JqS+SdLP0oIyJ90yeNLOlLSN+5c/xZqLgBkwsAIrKxeaUkePGWvzU2vv1AfkDwFVJyV/mzn5uunWCJX6WcMk6aYAJQEwKa/CyLg69VuP5xwfhPKHzVw3Yapca+S0fPV8S69dqi9asUTn2YuSRGmwxwg4VAncZtUpOMOHiKYYXUkxzQu3y1P5yfzs9QoHhJYGzBoeEi1kBkQtDSkbuCxxmd0yKhlJSaI7vdT8n1WBkh7WZfNlY3X6yCBAyz0KblSjPNAw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(5660300002)(8936002)(107886003)(26005)(966005)(2616005)(6266002)(186003)(47076005)(426003)(2906002)(42186006)(36756003)(316002)(336012)(54906003)(82310400005)(6636002)(4326008)(36860700001)(8676002)(6666004)(40460700003)(70586007)(110136005)(70206006)(508600001)(356005)(7636003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 16:40:12.7169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b27781-3122-4cb1-b298-08da343615fc
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0018.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR02MB8872
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic description for the xilinx emaclite driver DT bindings.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 .../bindings/net/xlnx,emaclite.yaml           | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml

diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
new file mode 100644
index 000000000000..a3e2a0e89b24
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xlnx,emaclite.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Xilinx Emaclite Ethernet controller
+
+maintainers:
+  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
+  - Harini Katakam <harini.katakam@xilinx.com>
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
+            compatible = "xlnx,xps-ethernetlite-3.00.a";
+            interrupt-parent = <&axi_intc_1>;
+            interrupts = <1 0>;
+            local-mac-address = [00 0a 35 00 00 00];
+            phy-handle = <&phy0>;
+            reg = <0x40e00000 0x10000>;
+            xlnx,rx-ping-pong;
+            xlnx,tx-ping-pong;
+    };
-- 
2.25.1

