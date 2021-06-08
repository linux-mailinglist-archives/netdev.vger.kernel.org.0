Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3A39ECDC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhFHDR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:17:59 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:63118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230323AbhFHDR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:17:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAeieoNHeSI5fr8ixlQUbff5lIqMKSzWSVHvUA2QfZNHSfBH88Bb6xdgTVGmfQl+2lrWxGGVNblraLLpo/e506/y951kV8ZY5yvO90n33EOLoSuRMsvOv+DhQPcvInp9FZcgGy6D7xx6LCWoTUpjebRhp3RlRGTHVz+w/Lq6yjr9KStwRPRGt9hTjblfWp1yL2gqFbMqYXE438L3p6NlLb5fH/WFARU5QGvwVtFjfqUjVWX4brmWWylXs7XX98+81lAjbnreCdjimhm8RpqDDKKrORDThmseIHxiMjP/R0eECMiajfqgd7QnUBIPx9FpGhdnAzFN/uKZf9wnS7O+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaYqkzm4P19ziRi8fv7+VmzJN9sAJMVtGVmAXkEY6Io=;
 b=QyiuLZCeWqogfa2+uz11UUcGJMfQnCwyzALVJWBICjmMwFs+irH9sjvVAKGnr2NJMl8hk5mJ3WJgvrnuIutIrcUtsMAE6hTWym3DPwvDK5kRIv+E9copGDwyvNpAG3fCpwxxq+hjZvwutF2vCQzuND66aj5yTVFsKJxN0Rprc7CkHinOSqCV3hJ5XlwGHiL/rDWwZS57j1OFnmElKLWcj1j5bGKR5a16qPQSrNzT0gp6yIXkPESvxogFI7ca+dhhzf30/4V8uyBj3MYTLp8lKzsAc6z0CF+U2QjnQ4ZddxZGbrUBCxb0NXU60FAFVe2CHEZXJ4BsD77Z0302FVs8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaYqkzm4P19ziRi8fv7+VmzJN9sAJMVtGVmAXkEY6Io=;
 b=Ywy2jxfnSVyWJc5HwT6tOIIxvxqgM5aOzmZmZvt7Wqx+U7sfgyh7PMNL5JY8IkxJWxhYO4Yce9wf+zKkLPZkwvG9Cny0NLkiPHOU1g/OabbbeRvHuyHCe/+VmAINX3TdUUyNhAPCrTuiwlJroBDrYIoQ1F3yE/a4uh9gCypt6WM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:16:03 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:16:03 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 net-next 1/4] dt-bindings: net: add dt binding for realtek rtl82xx phy
Date:   Tue,  8 Jun 2021 11:15:32 +0800
Message-Id: <20210608031535.3651-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24 via Frontend Transport; Tue, 8 Jun 2021 03:16:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac39bc98-6675-499c-ed97-08d92a2bbf93
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB613971EC6820F9331AD2182BE6379@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awBEU+Vl3OBEG8FomnX2yAH4AsJAKI0maSWjTf3pGW8o76eWekqRymmwjnf7zq50HfVDfezI036mYq1Knkl6UWvspGlVO0Hsie44uBTC5SJYAuEMqasDDXO7LAUW8i9KBVc90tRVEdlLrBO6+8NHhqHVyndsQoHAPaYooVwFhC1EviKdMo7PAT2/sIoccgbtaHaewzB/alXvY5XSI6UmnExzoV8PZiL0awE3CJGtcXMzjEhTFWOg/OMq9H/6K6y2A7/7nFm5bgTxlkL2oLUxq4xVqbnc7063zP5T393xFPaEIxtUe0+Rs3zwpKqKD/Zc2aqX/JhSBwku8OVJ85VIUE9FZTTPFNSE7QALEy3Vh/0T1N//C1LyUBqgtwU9MukaFve3VjnC5VFSVEjl87Hp9bdCX6fzV6NGd0g45ADZW+PsWKe8S5jApaDSTaqE2VLaWfln0qW3j5+rc6mTPgn8XOryK6EVaMeVTDgDkK/y/zW1m4IXdob4PIWY06sywphG0jp0NJ25K6p5TZYwkOzJcphpT118yuWuFFzp3rh2PD9QQfdJUHl8RV1BLXyeG+p6udpG8Rp4ZWI2Fe9nw5KxMx0TJXZOVzBOZQCbOgeqqC9phGTZWbQQ6bLDmrloSzYmixS28XVwEsHw/tFtawaGIhoR4lN945ZsdGDJvTdxL1ZAtAFdghfwNVbXYMrkmkU8QbeFp8ikUbeBiBrV1QBcRx8XyucbF/mkTFQLOZinlnK61/b04HVlD9o+DDFTehg8RFb+Fk41IjQgS0bcEcL69WYeibvTokcQXJJr4x1e6C36x0Igtv1Zg1HsNmQnfcxNI4LXZuLRFfkB/mP+YhF5K4BJe2qHWNwpzRgjxka5VZ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(66476007)(66556008)(8676002)(5660300002)(66946007)(38100700002)(83380400001)(38350700002)(36756003)(6666004)(1076003)(8936002)(6506007)(6512007)(86362001)(52116002)(16526019)(6486002)(26005)(966005)(7416002)(186003)(956004)(4326008)(2906002)(478600001)(316002)(2616005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?AziPqbMUMpc02sqdq/2X/rr+suA0nHNGYorZmwfOoNrHdEu4/n02Au+dCCq/?=
 =?us-ascii?Q?8EK/e9VHVzWvMXUuMSyn/fFEGwDd1qlMxKTrkdjldRWKnGTr49nBLKwSMI3u?=
 =?us-ascii?Q?RrIyFlAlyfH/pQztXBFnLMHJ9WQc/s2VNIgU2iyHUp0FhmgScZhQ2Fqt2sCu?=
 =?us-ascii?Q?+3Bf2e8bI7wHtazHkiL9rTbS9R6rTlPCc13LQ4s2I3vySjaroIoZm4Te/6zS?=
 =?us-ascii?Q?UBIOrJzRkhBx5k4WXrgXhSEwqh9qZiYN/5Es0uxz8EviILJQydmHhxRYM0VI?=
 =?us-ascii?Q?CH8Td5i0kaIsXiDR+ltJCCUBJH+w19OdRL1KXX7VW/OJ0WUArObAk3jQex96?=
 =?us-ascii?Q?n7DzPr37ZbaYnLklnJ+sid0Pd7ljtMbK2EybCTESAw1AuyfNoVujPq/j8kUc?=
 =?us-ascii?Q?04D9v72rKIv28G8OqBPTDQxLHYDXwUg6293IxMNMh59NJkib+F7i+F4OyxWY?=
 =?us-ascii?Q?1IFcfwdcTLeAugPCPFZBeTFMBmUp/j6yE4FSNkqbDYDMFcaeWiXV3dIwkS0Z?=
 =?us-ascii?Q?ayiqpoaiI1MKLXgXE9/54pQGE5WPiHeO4HAAX9cQZKbAjRM+aq/d/fex/u7H?=
 =?us-ascii?Q?4ssF6TFcZsbk/mSKgG2qEpjkEK41rGCPBR+Fkket1VDz45FNpORvFxURgY2n?=
 =?us-ascii?Q?KHM1TNMN+DI19QBAW5yjLLVEtzAfGtc1//ViQPrm8FuttRIQjlFJy7GDb4Fw?=
 =?us-ascii?Q?5MI+KllVRLoD7sK2439SfjfiufD2dgrK0/1dEQgUTCV9zGS4KlfYsitDWXZO?=
 =?us-ascii?Q?XZdbfDoJScvNQY4sPLmm5FqF5fpMMJJmH1VZ9P6pToQUVmudYYXzczl12/N3?=
 =?us-ascii?Q?95xcQDOQflY+0uI4SY9H4HDI+17SDgjdH5jwd3AKzMpjY/DJJEqj7dO3ZUxL?=
 =?us-ascii?Q?ra6BfOik9fPN2L7zI/6e8uKZ7Ocvm2E3WxO3i7x2AFWaJCY0FegFywdcjkB1?=
 =?us-ascii?Q?Uc2R0zsfxyhYRaieXnVbzGQngEHpy7R6PC/m/wcOK9xtxiNlsrZ+BPH8lp2U?=
 =?us-ascii?Q?RFMAWs+o9pRzB/Ag/ty/7tQzT0gZDTZEL6qCuUy9FMgFdTkfersDZuHZqsvd?=
 =?us-ascii?Q?T3uC8kaF2p6g7qs1rWflV8oiIjYSG/iZp7oL8iizCMvgEoFT4dTgKWhm7dul?=
 =?us-ascii?Q?yOE9f6j1tsr8Z/l7nG8qvUW44Iw+ynwU12SGXLBtD2K03LwfENUK0JIFOnM5?=
 =?us-ascii?Q?wIaJLeHMOdds4Tcp92e2kXhLS0HMl4ogul4H/Oi494Y8N2Di2aWIKcG4O7hP?=
 =?us-ascii?Q?aGyjApcWCgh6oODIvjcEKC82jhs88G/rVyy/AGKuv6QXw1ce3Coy2CsjpqFO?=
 =?us-ascii?Q?VEpxqFYilGNiEq+0X7WwsqoX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac39bc98-6675-499c-ed97-08d92a2bbf93
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:16:03.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8d/f682Exli2rpZDD00grYONwpwWQG05Y5fvUMFVwnyrzI7qAgqdQgP1ZnQ2q1I6BMG39sBCXXVgxfqj/TPMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding for realtek rtl82xx phy.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../bindings/net/realtek,rtl82xx.yaml         | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
new file mode 100644
index 000000000000..bb94a2388520
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: GPL-2.0+
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/realtek,rtl82xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Realtek RTL82xx PHY
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Heiner Kallweit <hkallweit1@gmail.com>
+
+description:
+  Bindings for Realtek RTL82xx PHYs
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  realtek,clkout-disable:
+    type: boolean
+    description:
+      Disable CLKOUT clock, CLKOUT clock default is enabled after hardware reset.
+
+
+  realtek,aldps-enable:
+    type: boolean
+    description:
+      Enable ALDPS mode, ALDPS mode default is disabled after hardware reset.
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethphy1: ethernet-phy@1 {
+                reg = <1>;
+                realtek,clkout-disable;
+                realtek,aldps-enable;
+        };
+    };
-- 
2.17.1

