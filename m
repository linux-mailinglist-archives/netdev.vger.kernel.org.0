Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01732421722
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbhJDTRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:47 -0400
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:55525
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238501AbhJDTRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGC8264jgEkkgBtrFWqKryk9wttea7ANKl4pxOg+UxpxYoDXmugIXThaJpxyp+EPKXxsucMy71Dw3OIsjCusAyL7d1CLvB2Ujgsd1gNoWDl6pmyVShJDNq4j9BDWG6LKXAgyvaR4gO2ws9XRGGdPdM2KPhAk3vbWNnUslqsL+RF7PjnbYWl3uYbHCOLuG1BzVNvXZLoF+452zPUSZLu1KxhjzUnjKySPnBEwuRKXEn24/o79WsQRw26jvUKpqgRXMcWEgxy7Dy+pBkR0xHIer51n4xb/sMd2u12kYVnoX2meqOR3B7lLNYlgqLi6t0855f1fOh1I7aMLEAGJYfITRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9UlkUu6sxJFXBIxo3jZuwWY1oxP/LYIeHhe83CUWic=;
 b=P8NteS0acuSPhwwEjlJSRBJVI/0DQorrtqw4lWGXrgoVVwg5a8x7SXjbOqynVil177KRnSEILCMbNPdPXM1AZL4zdaAQX+pbASxOzN63WKitz3d9gUge3AQ5hejCE8PbkFFmYKBTLlz+qRLiOVS1CLuYm9nWLoqhIQP5jWCMXux+YybEwQs/XY3+PobYllqKgI4iqs3PqppKyN8FDCjc+SQ3hZ+656siNus6KO+37HXvO3MgQyn9skGScF/MAEoVFe86lQJ8oiGtwsq7nL+THS9w2RuKtcF1NfmWf2EcJYJb1Lqmf63DfeqJVjKSE0iKh6cl/P3YXiH6PSEJaNtYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9UlkUu6sxJFXBIxo3jZuwWY1oxP/LYIeHhe83CUWic=;
 b=sgnWL/R/1K5hblIIQFI746lHLNESk9aAAn4IrHVk4kJ1XGqmNnCaYdK42vXfcXXTAvXv6bqg5Hidjp6liId12bKsKxLzZYLvQTDk7bffiEL8n25oDeJ5vaWsKpFAtRGFgde/PJf7l2PzhRQImG1OLK2t9pJgZvPCGLIQ74BHwcc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:50 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:50 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [RFC net-next PATCH 02/16] dt-bindings: net: Add binding for Xilinx PCS
Date:   Mon,  4 Oct 2021 15:15:13 -0400
Message-Id: <20211004191527.1610759-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5778b41-6ec6-4122-5118-08d9876b6072
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB743461D8355B9544BE8EDFC596AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3KaFzLR6x5stWllMcAygW4xopQ4LhduUiXQUJqBcdAs09PSECv2LXVQEtttw3bh/iw1wf7HZbzRJFjNsIqQsus7sWnqAnm1wf9bQb3lwV6MDVc0raeKDnBXilkA1RUP3y9VaDsB0Yl3XOFv4G0R7kuqXaXcPjKqtkSxIdMaAI78loIbqP/39WEF22cM3aqrXl96hnJ0U+sJ+FoCi73hHn9/RID+ooaWqkdfawuac9o5+ZRNyuG8X6WMooZdqlo1VbdCFyY/5qYGS9Qa92RogBnhtlaqTr8hjt0BWo3TEn0EhkR26/YomqbBY/QMCBVxktOABjA6n9U8CgFoAhJ8GApmQTgSU3UhSQw+9rN3hL80u6/XyFUZv4QeUyy+7UUTNcZxXf6GXztK/gMwYx5dnykLC7k+NVuqOQ3r9M9FeWbFca+S/nvB5nvgjCUwx/j6lTVhbUI0Z0Pmkk88pFIiX2w3ampgvFuza5baftbW4IebfoYS49d/xaj23kv53KvZPB1LdHRk6i1D6QRIQ2hvqzVzreGONJwP9yPylvcjdJlMFvK4MYuSLIWt+vquFL2RAQ44+iLk7mOMgL1FwFwSXH0qxan/IM56r7dOg8y/s8fXBv+h5dW6jzLlhVBAUcaynBP0kAMTdNgVchcBqyJOmmqPTgwPBYsBx2+o4Gu1uEe3bX4SmZNC5WYx/B8STzlt0ciifPDJ/aWK+y+4/xgs17i9yehtvVLZZuUQh7W2xMNh2uz73rskr4xvSU0TJxR0Ejh5+5nydDIPuRiVch4nc6o4gZfAcX0Yv95YFke9KN2A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(966005)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(7416002)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/rapiSpOwr3F8Y/BspyboF+V+nl9G4QVH+kNj+LFdptPOllesv62JK7EGXxq?=
 =?us-ascii?Q?2XmxBg1gC6zzzkBDdNuvbEDLMzayszg1GsRI83z9PlxIygXckL3PmqQinB+3?=
 =?us-ascii?Q?Rpl3bE1M4ACquVIDBxGOcv0SU7l0N2mKTzIFnqu949sLqGComhL4kttsQZMj?=
 =?us-ascii?Q?URLgts0uI/JP1NnSFmrOi2LMq3SWBiQBZRE+kn3qjb6tRoE30rI0dRbabsmk?=
 =?us-ascii?Q?I5GvKfMByaK2yYM0UmYdMb7vmtyC5q8vZ0bpIj45cYaNr+F9QgRVsYh+qkT8?=
 =?us-ascii?Q?5bJhTDLec55DsMlPQmUKTulFQbgM1It4YXHlFe/emmorIK4H8cjDmKKdquUH?=
 =?us-ascii?Q?GyFjI7MEh+hIlvyv7McHIUdGc5NlNe42mHU2Xx/oaCQZAHnHfwrTq/TD3joQ?=
 =?us-ascii?Q?Ue8HNNzCC3YF7diuii8HGci61DVFmDJP+Pkt3ObP9O/pbzkLQYBLbn9SpIDr?=
 =?us-ascii?Q?gM/JT8eG9ZT0XzijdA/LPdjTx79MBOeLvnPJ8VBrbfgtpXeBFWmoYhEAzc2N?=
 =?us-ascii?Q?EvY0kvGw23JClq0ajLUKrqEWsRBh/gWUm0dMFTAQzjkGQ6Pf7Z8ds+fKRgZT?=
 =?us-ascii?Q?Y40O/b+fNGP/kPevQaeGSR+SzMcineVRPH8OI4LJD6hHTnEC1ophHrcp2Cew?=
 =?us-ascii?Q?OuodCyF95FAfG0rWgHrMdIoKl6MOV5Irkg8OBoQ4fKazdluvH9uGTeWB+gu0?=
 =?us-ascii?Q?2IzuONkV8xAgDg54BuxWePJG2HokW8KC/EtqcObqW3WsxAGDd9BaEkiOHxzc?=
 =?us-ascii?Q?OX+RKFaNb2ebByVhb7uYiRlsGtapHHBPUSsxB4axxTkVv9FFBuf5Pyj8qLnv?=
 =?us-ascii?Q?9g/KewKTtxpWdnNyqZvfxn4zq/D2uosAVuw0GjqewX/nttfScqUkOs/IOJUc?=
 =?us-ascii?Q?fxyvYxJrs8/zrRdSi/hj5+PT8RMTjFatoDwOHOlhapR7Qv1VPbg1fYXKOOaX?=
 =?us-ascii?Q?XW9JXZuhlSQ/LgC9mrwdnj00OO0XwPLncNk7EoP+Zcl/U49+i1KeyXcxfOCT?=
 =?us-ascii?Q?6i0DZuDPcoqYUP7VvZe6EM4+73FgmbUr0B5stYnOFDcHH+k6rNRhXVDuYjrj?=
 =?us-ascii?Q?Kg2KveHWZ2c4yr+V4zxUtsbAnawGd0XstA5S09F+nZsqhQkzhx3JJPhIzdrn?=
 =?us-ascii?Q?/xtZ9plyMcfcKCMG3VitxvaaKcnE3Fywox3rFuJfF6VkZ6STYFTstKPT8OPA?=
 =?us-ascii?Q?KaoVRt8MmfF6dqcE/iRhd8BJ38AK6BY0U94fv64TKEg+3OgDmXO5MJHatr0k?=
 =?us-ascii?Q?fFQ7uJUwvdKAT075Te7P9MPOqZLvnc3ViwnKSiov20/epaPKem2NfL54xFxf?=
 =?us-ascii?Q?IuNS6NRkm4XY02a9x2Q1LZMu?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5778b41-6ec6-4122-5118-08d9876b6072
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:50.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MQpZJf4zouuU9jbiSIXKBsImwZOZbFfg0QS8PbtfeOC2pwHSmV98P3ZJm0TCJfCkZegrxdAhxMugww9q2DNzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a binding for the Xilinx 1G/2.5G Ethernet PCS/PMA or SGMII
LogiCORE IP. This device is a soft device typically used to adapt between
GMII and SGMII or 1000BASE-X (in combination with a suitable SERDES). The
standard property is roughly analogous to the interface property of
ethernet controllers, except that it has an additional value used to
indicate that dynamic switching is supported. Note that switching is
supported only between SGMII and 1000BASE-X, and only if the appropriate
parameter is set when the device is synthesized. The property name was
chosen to align with the terminology in the datasheet. I also considered
"mdi", but that is a bit of a misnomer in the case of SGMII.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../devicetree/bindings/net/xilinx,pcs.yaml   | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/xilinx,pcs.yaml

diff --git a/Documentation/devicetree/bindings/net/xilinx,pcs.yaml b/Documentation/devicetree/bindings/net/xilinx,pcs.yaml
new file mode 100644
index 000000000000..43750dcb4b11
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/xilinx,pcs.yaml
@@ -0,0 +1,83 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/xilinx,pcs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Xilinx 1G/2.5G Ethernet PCS/PMA or SGMII LogiCORE IP
+
+maintainers:
+  - Sean Anderson <sean.anderson@seco.com>
+
+description:
+  This is a soft device which converts between GMII and SGMII, 2.5G SGMII,
+  1000BASE-X, or 2500BASE-X. It may have an attached SERDES, or may talk
+  directly to LVDS.
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+properties:
+  compatible:
+    contains:
+      const:
+        - xilinx,pcs-16.2
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+    items:
+      - description: The reference clock for the PMD, which is typically a
+                     SERDES but may be a direct interface to LVDS I/Os.
+                     Depending on your setup, this may be the gtrefclk, refclk,
+                     or clk125m signal.
+
+  clock-names:
+    const: refclk
+
+  resets:
+    maxItems: 1
+
+  reset-names:
+    const: pcs
+
+  standard:
+    description:
+      The interface standard that the PCS supports. The sgmii/1000base-x
+      setting indicates that the PCS supports dynamically switching between
+      SGMII and 1000BASE-X.
+    enum:
+      - sgmii
+      - 1000base-x
+      - sgmii/1000base-x
+      - 2500base-x
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - standard
+
+additionalProperties: false
+
+examples:
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        pcs0: ethernet-pcs@0 {
+            compatible = "xlnx,pcs-16.2";
+            reg = <0>;
+            clocks = <&si570>;
+            clock-names = "refclk";
+            resets = <&pcs_reset 1>;
+            reset-names = "pcs";
+            standard = "sgmii/1000base-x";
+        };
+    };
-- 
2.25.1

