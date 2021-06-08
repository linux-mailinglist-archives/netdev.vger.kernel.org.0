Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7645539EC92
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFHDDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:03:30 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:52448
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231296AbhFHDD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:03:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkOqTheoa2fkkKvEWjTVzU1pdo+hrPqKckugBtL6LL5gAh88XOYVI1xso7l2+fz3Cox+6ai3xDeek9ndOOdZHxaw8il1lKdz/quVQ6d+E2j/BMXxgdZRiJY5Xcqkn890yuuuPxcWaQQBm7hl+1+FDOf8eO9FKbm8ebevYk54NeCfZFaScC2wPVf4DZ8btxhYS8KqOPkDocOsGklVBHRNYN+aghH3aPxFlKSJVShJACdz7ouV0xH+IO6tysXtr/IsVE6RGxhb3yClntMGHeE9co1pI8vpgeDGqXJlXq3YYlbRj4WmxKjeK9g02psM2qIVgeaza0XUM5aj2gaMsHoy+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaYqkzm4P19ziRi8fv7+VmzJN9sAJMVtGVmAXkEY6Io=;
 b=O1AhWMlSu/U4oP4+A/UCzvwbut4IpmAqKDi6HECB+pYBb9WHOqj8He5nrashl9y1Bw3I2aoUuBAM0bPN44dT7NjYrnPtpWZZX+nfBuLJyA2+uA1smmZjiM7P/aILLtfj3mqDEUdAn3MNlq87tH7VExffurGRZuDOLh83NLJhMcMt1+3cP7PHoJ9zUWz+W3aTxY13/Aw/Cf5IjEICRipQfrCZVmya7s+nl4KtKQsUd8sz5gqsr6LWCIrmKB6wggvGv4jmZWv6qQmKZPu5sBdqqyZpCvSzLFk25cQVqRWdS/bj2uHh1mCPPy5Y6tqdhKUvu1Pn4KJkewZ9thI2nFZcfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaYqkzm4P19ziRi8fv7+VmzJN9sAJMVtGVmAXkEY6Io=;
 b=nioEKcIzQvdOts3FD9oX1Gai19MAHTCvswMv2Z91CRN9n1UFGVA8amZFQ4mxn9DBlT9ofNrbP1abEgUqrcodm4DMGkkG/7xmavL7vVTTzgwpZfSczGL4/7+4iOxd7f95NZtWE7hTDyvcQwvHwdA7c9zD/VdOvFNAioPWBTe9iME=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Tue, 8 Jun
 2021 03:01:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:01:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 1/4] dt-bindings: net: add dt binding for realtek rtl82xx phy
Date:   Tue,  8 Jun 2021 11:00:31 +0800
Message-Id: <20210608030034.3113-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
References: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0151.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:01:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a28906b8-17a7-4a42-c5e1-08d92a29b814
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB29045ABFF30840DF11C5EA7BE6379@DB6PR0402MB2904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJcVCzw7iz322Rw3rdxBQc2D5qNpG5Q9uqQPQ5uWnBv+Dzj2s2w7lqBp+4qQFxPi2o2qjodYhrdvdfmeKXpnip4HV60CT8rmSHhwRALoV+JHL3lSoBMBxkx90I3E753VuV6Cwth3YAdrflK5IsKxnaxtmWxTaeHGUW+FS3L6lh34K/QnNBxekc33uqhBtr03rFGF6bhlVx+OtSwA2sH6JIA9Ys4Op26IBNRbjQBHl/JfsW/h5m3Tsb5K+vufSFh1Wgwbtxe4zW0wVMIZW1lZfo0+kBsNW9f1rpqGwP+9IBYO3y04//KKTxHLIZDIIVZn4REYkDVxGOlL5VTei9hemDoybNPU0+kBuxF8DCJqE6XQxPV5sBJe6NAGgEiAgvLAPx1yhDvk2PgzcWzpKs6puRUNMA5as96uP9qJuJ8TNlWJz4OhcvJt+WiqGuNSlF3jys6QTe+CLj6q75/VgMhgm2mYQpA4zro9Z4VGBcR89JZRC+idOfwUO5LtQHShgJW9r1iTVacaEixwWNdTT0IVaWSdnPh7XTcN848oz0DLBJpL0aHaVXXpvm755eQ6OZnk9gzD7cJlnvyR9fEQX2kvjAzyTHLYle3PwF7bflm3we3ZtD5ssJy8ZA+r6zJN/aHbu18J50sT6CGjNMBlz686NYixuNw/GqEb4pztki34e3Yw+0cjinjcD0a76WoMQ5ivuCVrQZdHkDvTQk6YgrwzJfRKkTMSmRr4ELEgp/GkX7WUsLNbEnBGCbGJz3FJ5a3XppqpkzfWBXYWgk3f9WppgV1PrfLyVj+8updUZUGjSoKZ/LvOdCKhi+6KVjWzooaObtui3+UncElz6azKoBw7m/OZ+vWndYDMj7vnzZhTd94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(83380400001)(6666004)(38350700002)(86362001)(7416002)(6486002)(52116002)(16526019)(6512007)(6506007)(38100700002)(4326008)(2906002)(66476007)(66556008)(8936002)(956004)(316002)(66946007)(5660300002)(8676002)(186003)(966005)(26005)(2616005)(1076003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gOaKXsSflt1rhIlQNysuCc5vvZ36hJ9z6dYJyJ8yBttJg5IxynwvkwtrCIqK?=
 =?us-ascii?Q?EsYiAUD6ekidvAptw7sNxUHrkVFZQ6FJwWxpQGAS/qvTTeLewq+8AG9MNeAv?=
 =?us-ascii?Q?0fsHzvXhr7W6L0duuF1MZXOEC6b6YYF8iulyL/3+pCkens2jB1FUyXcU/Zd9?=
 =?us-ascii?Q?rkV2AB+I4d+UzXLfPaxhq9JkAa5l6QC5ndjrqSnJqlqlLdkAKbiQJkBQ6HEg?=
 =?us-ascii?Q?NJDSZlv+xI8x2hfsNEQQNRm6SJScf/NFNA/XOT6AOQKK/8WrFJ7p7TAtFz4R?=
 =?us-ascii?Q?ncf6n4QzaQWRvroqhdYiF+e56u1veELmh3m3O3CwvRuw/gIjLaw2QZm9+XfL?=
 =?us-ascii?Q?YSboVxThA7DSA2K1R/WXv+Wnxs683DQDcAO9Zvy5b3QbuKFn9gLA1kfRCctu?=
 =?us-ascii?Q?wDIafS+Z18ugS4gIgVBCarvpdEEzNHts/8ZdF6kB6O3DPyEGKwzcFaRsNt6C?=
 =?us-ascii?Q?Fk150SOrsXtmYr2teX8iHNNI7o0gkHIe9n15UHTedmYNlcmjoHuwkmxy53JZ?=
 =?us-ascii?Q?HLC+9bsYjiqMC3umK25wszN3yB0fN8G0H/UFkbn5nwdwiH1/t5HvSKrImS9j?=
 =?us-ascii?Q?xT87uBKbL7nIyItWK+JjfyhXxMyt9pCvQ6k6FDH4PU4D8fP7aH/w/bniHX08?=
 =?us-ascii?Q?conxUgW9T9oI1nY6yUaBclhgP4UZihk9FBTub8uPxk9h4FszaelrWUdkZpy3?=
 =?us-ascii?Q?nL0ae1f4d0hkjsJ37Uy7NUyagACk/f0Kw4EUR3FsrSkM8Hbvkd2m6TTDtccV?=
 =?us-ascii?Q?cuDGlC62YR/xcbz2cgrULgkLtqY4mLL2dxKm4HZv7sVuDsl9HqQySnpcQZHL?=
 =?us-ascii?Q?zGnxjp8jE2jE8PthaEbYlsqDD7Xz8cu+VUXTU09FNVkOixQVvFpmqLLU+Olm?=
 =?us-ascii?Q?+eghfseCGTvr3uRa6XnRdMM0truSYYg/+jEzrWlew1Faq7XuDHWpAbt21ikx?=
 =?us-ascii?Q?BzkdinA43YWB4z/CUlH7375UIYFkbGjGY8hWwotwW6HmtyoNUbvyYLcLy6ie?=
 =?us-ascii?Q?7mJlIW7XaoVS1Nae71syx+mzZ7AHe/ewTjZ2GT3+nT2amWYbHlZXCz+GKy0U?=
 =?us-ascii?Q?/t3aGkJgR0dyyHtMnCMJCzamo6vklL9xVBHp5b72MlpKXAA9lbLbkViVMBai?=
 =?us-ascii?Q?ZfGn/fB2+PK10+TMf1HM1FffSa0G4lkVlEA7jLWWaao6zOJjgGt19GbODqfY?=
 =?us-ascii?Q?iZHbVFYQ/9n5tfITwJ5a6qeSDCPiRO6tggFjKx35U6g4VW2wuPigAErtKh8g?=
 =?us-ascii?Q?Y0Fz9Asq0YwDxNCq5WQnOQ4X2EduLTxdLR/SQtNjv56qPNWCb0sAJ9VmsSmt?=
 =?us-ascii?Q?WRPgi/eGVm6i0W4E8d6C6MNc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28906b8-17a7-4a42-c5e1-08d92a29b814
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:01:32.1753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDz7VK2opnur7U8p24xtTsMtqvniWCQ8h8FGrNM2/9DEQi86/mVX1e/kg2lCd9gg8Mlu9MRzVVNCfU9EF53cEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
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

