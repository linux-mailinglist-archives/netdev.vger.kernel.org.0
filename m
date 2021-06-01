Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6F2396FD4
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhFAJG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:06:29 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:14338
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232869AbhFAJG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:06:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsDe4D1hnXlZtAtJ994OCXMCFveKJCAiuj33S2JrFRD4FUNhmEtASVdwJkDyRUxoTRuZgYQKaHySYbMktJ2yiPyP7CGbg9eVg9HO+Lz5k+vNTEo7Fak7lp4iGdl3uD1LOdGcCA9GjNRvrUBbU1BlMsNNcDTnodumPikbPDCbRMvrqOYYyqDqrBJOIjeEdwNmgIfo56JewR4NHAntx3cBL+l6Ya80Om2oa8gJKKC0RqGAU6ymtAOyH/tH+zy26TqdtL/YkQRiqonqGB0Id4AUSj9xmmUbH2p9Vqdgh7PP58nWmjPUxVGLk3McwsPBmsx+Rt5Nw06Gr/tmdKaa+mvkTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dGscamxW94pejGU8uYX1kY6ueXgQKjhfHie2Hm/V98=;
 b=i9BmC70dXXcaupnv6BgGRKwn6IslAJPwW0pFWsXs85nT4FZG4Z1jyxXIxAdl0kz5pKd/sCb32TRjZ0r5Wv05TzIoLbSx5Cc4Vw6ISx31a/4itGtX9Y5rnJPeMCbGk2nZ74oIYTQve2q5seifQy1dQtbR+CDhmgFtlM+EbVSUe5A9LFSgr9SaUbN8nWZ4/C/qtJYF/CQ5SLtkEM7WIzWCQR7wbC4pPX8ClaOM1yxzkokEk9+u9Qj2HLJbpqxjxCjb9ftFzZKIHvRmy1WcpsgoTY5bAn3bAqUB2AAR91clb5hSDgdyZxQvUJDyrFA6c2ZLHmvTKnGj6GGrLvbhHzugFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dGscamxW94pejGU8uYX1kY6ueXgQKjhfHie2Hm/V98=;
 b=TDuHretkE/6fKoM+IO+JaN4QAg/PS1TvS4XlQ0Rl61EbjcKf6pAw7PCnkp2TbY4/yFdmrVeh1+Yq9XFWltVgAJWDVja8VGbA4yXMnNZP4HdcbbbOqEMdCKoQ1os3oFH2I0vA3NphdX/rLotAosdZvMCxTFaKGc7fRSqsRTxae5s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 09:04:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 09:04:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] dt-bindings: net: add dt binding for realtek rtl82xx phy
Date:   Tue,  1 Jun 2021 17:04:05 +0800
Message-Id: <20210601090408.22025-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 09:04:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a0f8320-2e7e-49b9-337f-08d924dc4bd2
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6795BE6F688904F43C328EC4E63E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzjxrXaxmNY3nYnvoBR+U1O6paEtRbqU/QG/qKkJQQXGwoxB8AG2vSd0rhn9gb95DX9JmCQCTLJb86IIHmvOiMBsmq16Qu7/hG+sln1sSfwe/w0svP8/I8tU4DpEL+ArOzyp1mQILU+9pKK52lnUODcglPwNJrZlAZLWUwASbzwIiMLkhUDEEj+2Ip2SaeKQX5hSkVRZqJkC8cvcjnSfTPXky+i7ZQHRdpAmdFtKMkoxyy4a1738bSTc68y7TseEsg5rSXvKHVBtdU9NwICnXst0zmltVjld/aLM/a2al/tR4shh6LRLRChcoEdTCC8kpSd/eqQko0UOOr+6sv7YRlDORUSanxwpRgfdb9vFhPALotncErsTbAf0icgIoLLcjbjsbXIPRCXwpqK/KQmth2OctnxFbFWSj9loa6l6z52WW8xwVhBTG9SvtWYjoBDQCRUUBdygts1futf9gyBl3yyrK5vo7AX+914NKOthhz9FW3mcZvv3cp2u3A77sYeblIUJNZ6p8bVTySNaI5rMwyRzrmmpxHsDnIvhlAFuo4v5X+tR9ADjv2oasV+xXXhwzskKKHWp3FzjBidQ6tX0Z4NegTnsY3URNR7xb6BDFFVc8+mctNbUVWJh/dof+QnREyuj4o/bgu9/7diOZGbpF3AJPmCA60yqkrScgSfBSrg2YyzJCKARWBDPhdkBWoLaeRHiu3C/tuL85rULgk/CUd/g58SNiBukFlA3oQnGqkhIJy6KlAPKGDjs1BAetAvSgWBWldnHYQsZTVHBcq7xyeyH28UPoK5OJ9tPLCp47U0UAAPpWPoDsB01kgKoKZj/hOfmVgyEz3VuQLu5AcV5hB+SXstaBbyJYACpLU9e43Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39850400004)(396003)(136003)(66946007)(38350700002)(966005)(8936002)(478600001)(6666004)(36756003)(2616005)(52116002)(6506007)(2906002)(316002)(86362001)(16526019)(6486002)(186003)(956004)(38100700002)(5660300002)(6512007)(83380400001)(26005)(1076003)(66556008)(7416002)(8676002)(4326008)(66476007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GkKNejmIMJdo/V+q+rpdrQuOdCsFrl4bO1iEisbJUJ/twBSAVdJlaIpnVz3A?=
 =?us-ascii?Q?YuMvFsMHtdwROC/Q28lmWToztY5Z2Va3XnI6TeHyD64KdxCR89QJ86xWsVcG?=
 =?us-ascii?Q?x8PWTqg5YTeVvwoDNr4mH5/8IVkZ50BNc1wnXOMgpCOvd0ee4iGuCZ0IhMrq?=
 =?us-ascii?Q?QSG0qS/3l4wIeeZqreu6sPUJ7XSxRP8BPO/3LeQMXeBAYIIYeB2sEUVfY3mD?=
 =?us-ascii?Q?yQyA47AMDEkBjFDN+sAuhLPoAhwMgTbZcfIhuaTpf2dPKL4durNEgd5PW0vt?=
 =?us-ascii?Q?Lt+cMMV+RrxuX0AaK2ZvjDB0aIh+r9otMNvaNe0ni8Rdq2LK/a2TdOUQGiDB?=
 =?us-ascii?Q?NOJHqD2z9UimIe0GrjSwiQSn8iIpfOedoCRn8CwbgnoEtzFDEOBXzouZTgSb?=
 =?us-ascii?Q?YTT+22JhMO9/4zytYq7gEYub+NKIxdZYyXd9PH4CSimN5eTGazp6Xasv5NfX?=
 =?us-ascii?Q?S4kEKAe1SaEH6S3ajM6YVGZpg8A/CnWOH6fjgRVauBjHsvYzmzhwr434YLhm?=
 =?us-ascii?Q?6XsCM4Cl8nlUbGWrWNs6TDOTMVKcTK+JAcqTqKHXjWCqyYzVW4FymEekrCPH?=
 =?us-ascii?Q?rs/iy2yosr7ottA/Kpj6kRRuaGd8CALvc/1fkNZ+xeiA2dakw19Of/lLsWVG?=
 =?us-ascii?Q?Gu6rfUgeFVNG56+DDg+A7q+kh1BhOgwLhtFnzqdcZckrukm3lSOfhH//LQJL?=
 =?us-ascii?Q?d/2Rp/n0mR5TY6lgUxLm0KlXt1ZG39RBiEhwDAvWhA6ez/GjlbHTs72LDF69?=
 =?us-ascii?Q?4zlqQJZ6zOVL+CI6+vZcxxazjiUfaiQo1wxA4N/dAV06aBcFdBQvKcCRCadM?=
 =?us-ascii?Q?N2PPL8kEWpoRsDBHdeW1cbDEdKvC9oDCLi+kuZaCvpOFXRWfnAbDdYxzNkEJ?=
 =?us-ascii?Q?77PJWoq77aBFpT9BNS5cGZAIZ/8SkKUkr1b7GVjEE4Z2fvSOOIIpUsONXUdC?=
 =?us-ascii?Q?EpVDUq6gXOcNcrGczJprqCWPovc/+gsx6TZ+9z+/FYvEWEBgDFTM0X8tQirf?=
 =?us-ascii?Q?6lmVJptPAZH9uhpRdssq2XLgorch0pkJaK19M+JmQtRWYPjQQYAJ6s7glJr0?=
 =?us-ascii?Q?C1IO50q2hSsQK0YDtq20ytmaOy5SNtUd11rhzNWsU61X/vVhPb2O4isOdeT9?=
 =?us-ascii?Q?kKf9Jmhc7HDKl2+1/LUY4roa6jVAxlE+g1x+uQOHDqenCpO3hkCKSUXsmFPp?=
 =?us-ascii?Q?VUZTQkfVCku4KMiLltgqBozReuk/kMz7ly7GA7dmiYbJtp5H4BlrAoq2Z+D4?=
 =?us-ascii?Q?zhagjLO9sYpnxISQT1AprRBmihdJy+gxjhwLEmO0zHR39Gm4fL+rVtyo+Yz+?=
 =?us-ascii?Q?1Tka/KQ07gOXy15kDflNav2r?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a0f8320-2e7e-49b9-337f-08d924dc4bd2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 09:04:43.4999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzJkEgex3iF6psNGGN0sHamMlzO2UD1lG6B66p9StVxOChSwZ/hTTb7cjmZfpZ1sroA9z2Lhy/Ngmbbc62MWig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding for realtek rtl82xx phy.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../bindings/net/realtek,rtl82xx.yaml         | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
new file mode 100644
index 000000000000..0075c06e39bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
@@ -0,0 +1,42 @@
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
+  rtl821x,clkout-disable:
+    description: Disable CLKOUT clock.
+    type: boolean
+
+  rtl821x,aldps-disable:
+    description: Disable ALDPS mode.
+    type: boolean
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
+                rtl821x,clkout-disable;
+                rtl821x,aldps-disable;
+        };
+    };
-- 
2.17.1

