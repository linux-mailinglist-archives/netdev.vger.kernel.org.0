Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190525EB0DC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiIZTEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiIZTDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:41 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6B901A8;
        Mon, 26 Sep 2022 12:03:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEHLUNl/5/6pz/zRf12dQ6OcLEowFy3WcjEiLkJMAy5PY/Q51bUpcUJohibu3B6agrxniMoG6Hz1HQg94suFkF0Qnr/yBsTMoT1y1IqavVB6ixFKMKyqRgWHr46qiUesXNpU1ol14zPK2J/ng5/jK0/fwPK4LPDtYIFqdRLM/Iigd3gxi0d37WRPWftusXOQG7xSruSw/pXHTvAz4/yIAfOD2yKw2STcistZIGRGmEYnBs2yVcqdbJbCnrhYitwvoUU3UbWEp2duOHsU2i6MF/Zdk/vFE2q3QfoVt1g+58RqGOA539bjLmwglVfqLEwxcep7URAWdz7oHNkfP5M5Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EC1HcOO+5Q0+Ynms79IRZ/THE/qErU77+UZf5Lw4X3k=;
 b=hs65oOnNYDF2MYEjDO3r0dUD1n2+gujJkfMesCRURdHyocXTGohv6iYavDKBOIPdfLWinGpVTxJIIYu8g0lkjcmwDWPwA4sAmE9YYRBbl5ZHk+Gc49Qe9pHpQq21woBCzLmtOJDxlUeizAlBuXwDRyxvy6BB1ViPEHn9OPtf33AjT2GByaiPhKlA9BXoh83YmWmQFCgLJVBKW3nKpMrzDc/xLj4ESQWInPsx2eekD6vt1N+XxRl2FvbbqMpztNHxOU8pIvUnIZY4NXoVbw2wivzSSY2AlDb18mIuLCQLM+teXjTECzVWgLmCFEscyg4Cr56eY/ihqDChozBUng+Bng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EC1HcOO+5Q0+Ynms79IRZ/THE/qErU77+UZf5Lw4X3k=;
 b=XITKnWURe3faWh62TIC9z5HIyVYiyCAql9oG5JvjxyEO/DH+VOlNYCauwHNAwa4bYgxB4q1mSchkKAxdYPGFlhIuBqpL89WCMHCfeFgcQzK0QzkQCn/OdyMmpvf2SF8LXu5fKdXYQz9aG1HbGq3xrl9y0GXCve+T1l/jfEMsMxP2H7KHrwR2uUv3ZlGbRW4OzBR7lizapRFid9rYUnLZeUrXQ0GwXJm6FPYTcWPRyfQuWuVbMu3xkN+L1lAZuFz7OAxmrt6bxV+fulHI1HqpSuefEdRhEC6y3EfVk86LZGM9uYZKTLmYRoxeQlEp7NGS5zjIDfkvlUn3Ok8DuyXpSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:35 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 2/9] dt-bindings: net: Add Lynx PCS binding
Date:   Mon, 26 Sep 2022 15:03:14 -0400
Message-Id: <20220926190322.2889342-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: 88bf9dde-7e35-4bfd-5ae1-08da9ff1d034
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iyOWB9g4uhKlewq9J45v4u4ed6n0LUjl/GGP/LFkC7f/hz66YdlslxGsmd00DVPzwnpRW0CG6cnUp2FImabZHPEiJaQsR6JFAoZhgTeqfXFjF4HPJ9T1fZ16bMAjO1xjj/KWoqL3faAsOJzgym+pcP1UG1aU6LXgVnbnDxtZZuSsdFSl3OPQYqd6hpWzyNAIdwpo3BSoQLLHLwgc0H1hBBHfh3O178l76jJGEHbHdLfEpCpPq4XTobt19o99eZBHPxR7n+FHfYc3lIwmia2kYMm6hChM9rp6a4qBnw5Up+jE+ISqxZGWQ1KZdyDO+wryrMLh4YAZNCgqscTlrJBDW0pUSnW/eFdyNVaULVwmjoiQeiDcDhihmFoN0A0GBXB+SptJWiraerlWGjcn/991s2Ge8NgzIktF6dverZjlpkaFoFBFE0nLa4MigfgVt93ahxIgR8Yq7IUTXR1RrAo2DVwBF0FTdMw1uNNeCiYJJaoioeS8fNhFLIAaVcHUa7s1Z6fShA32AeP/6lbx3VD6dcbSY9CbfEJS8BqyO85XrsmYRgcA23OEpt1mM3p4vAqWn+/uDoCaCQBHK9c4bry3JQ/kEyX4Bw5Ockf/IXbh8jQ+Gf7VvBHQZ1Hy6xIvs5xUepRQ9o3QbL8aTpFbklKUa93SR4cltqQwze1eFf1taStqBD0k+lA8xq9CqFYjPngr/ITWFCNhtpxcf14tEpg7TnLBBu8qWSgV1HQ7SWbBjEBkYZLFGaMv/D9d5+MgcWdMuFhpHjgt5ois9eoeVn2AvDDVB3lPYwfG8bBkB+2bc1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(966005)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?88ztv/xSE9lLKhoRiLvcZ3cdkHsQ9cK0pLKRFZ9JXSgbgDfHIMTUS6FNGXWr?=
 =?us-ascii?Q?q1PVzeyCN4Umpyb9TvbBjJ5hipAfU4AXH8pvwALntNjuYPXvtIUaFs38ZMEf?=
 =?us-ascii?Q?pQ2vEBrzmrrDHGkYHFHMeTsAPxpNg3c7M2eCeoMLAXBe4ifkI3GlCYgZ72nR?=
 =?us-ascii?Q?vSqHOU5YW4ipibFOf0hTtYVrwWhN3SvX48HG+k4Na+VjO0NKde/vJHStS5ax?=
 =?us-ascii?Q?a/6FvNMi3O4jRapWbQSWCNVJGo8QTKqh9nYL/+XfnujjRkV4Nl6a9uIy9Ex3?=
 =?us-ascii?Q?LbO0895jHMXz0pujB5tryUydZMC4+uAxcMz/ZtAHCkX+fs6UH9ifNC/i5s9U?=
 =?us-ascii?Q?gS6IFgXaeuvwwhik8sPBH3093tjtQxrFiD1IVxoqE6TlnnaH4XgBxzCvNCqY?=
 =?us-ascii?Q?LCGTkVlBv4+iUQ7SatLqlVf6tDlGwmYSo4I5M1H+s6EDg4hclhyYbiO54X2I?=
 =?us-ascii?Q?Ih0UFBrRN7Grx5OeOAJZRWnJi6Ze8AGGfwehWVx4FKx5MOmmcf9KqF0HMJXp?=
 =?us-ascii?Q?dIWR8MIetcAxhr1y9lm9w7GaFFMVhE3zJ1/6NdYplnETPyreZ1bx80XWZKeA?=
 =?us-ascii?Q?FlSm995GNmMq78K+BJf+YfkAvUP+UhQO0xelx38qxlDOk8zQDkt1WFtY4vc3?=
 =?us-ascii?Q?LVE81yP5EeIWlZUbVLqyEHWgDV391fBGlyET8gh2AZmTXgTi6aoYHLJSZIoN?=
 =?us-ascii?Q?Z5wcCTBoIwOrMdqOaiNEEfCOcqp5XWN9BqvSwNYnzE2CMtfsAn7TQTfT5fak?=
 =?us-ascii?Q?Ri0e7HcC8xVJ8eMg3jh6LTTWj+2xKYDFi41QghPkZyTffBoMC79aRJ5IfqyX?=
 =?us-ascii?Q?vAKJNSTbumL3DpQzrbaSnhEhWQjsGDmK5a8iZFO1aPaBJRK9dPrkvaXRDqFE?=
 =?us-ascii?Q?vdMQ1HoRcpnJdKXHeqaHhe/sDyNsbivknzkT1RQ60Dkyk9IcxElSR8DazdP6?=
 =?us-ascii?Q?KjZmksLYTCC6TeTjLkFOWgqi6UJjYv3x0DdyLeVgJIyEk0kEL90ugyUt4WwY?=
 =?us-ascii?Q?Axp37nCxV/ss33VNb6YhzAO2tDBoEmFgXHSYxbSzy+C1ZBbP5ttg7G7Any6Y?=
 =?us-ascii?Q?KprZuUDRGUbvTw+A9dFxguBlJrXuZiByBBshgyhjA9l7drchda/4rAD91EqQ?=
 =?us-ascii?Q?5sIssprDA+1AQnF781qpQayP7zrgE5zMzlKPdoHik53X04+AaTOOMpbXWCap?=
 =?us-ascii?Q?FfMh0alhb1rN3p38cNng2HAOR18RnSqUHRWcCWBQ/h1z/K6VTW7Wx79MOBm+?=
 =?us-ascii?Q?ALIhcMSXxYA7EnfJprNUI8obavheyd04SxIfoGmTXRjsw+Im8WyTp74iZ17B?=
 =?us-ascii?Q?ORKh8feXTg6IBIaRoIl5u0xTmedwauZ+nmex5NW6QSmcoFeD0oLvFnp+5g/A?=
 =?us-ascii?Q?LT4Dto8yoVQg+S7+cgOK2xx5chlC97M71msuDz0JzpeGpWh9jBTVo2KCnepy?=
 =?us-ascii?Q?5qft0fgtARpQlmCrM0TIgBJSMh2E/xoaeqY4644PaEkDloWF63CVQkS6UvFN?=
 =?us-ascii?Q?iuuNm5qH6FSnHGijMYHSyw0fgU0mSVkCb/er2GF9LIiDM54hmtE9NM0g8pK2?=
 =?us-ascii?Q?bNRjJPBGG3XO3IepHlz1Z73g0EoEy/DqZy4pGiIlhtiOsi3FkTmFiyZnxSH3?=
 =?us-ascii?Q?zg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88bf9dde-7e35-4bfd-5ae1-08da9ff1d034
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:35.7560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39VKVqa7IPEHsZ+5CTQgWLw4oP8LZUp/2hSldO7HDQBT2eCcYCYvgpLI4QpsASqlRNj/MDqtIjgh/iAXJ7Fx5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This binding is fairly bare-bones for now, since the Lynx driver doesn't
parse any properties (or match based on the compatible). We just need it
in order to prevent the PCS nodes from having phy devices attached to
them. This is not really a problem, but it is a bit inefficient.

This binding is really for three separate PCSs (SGMII, QSGMII, and XFI).
However, the driver treats all of them the same. This works because the
SGMII and XFI devices typically use the same address, and the SerDes
driver (or RCW) muxes between them. The QSGMII PCSs have the same
register layout as the SGMII PCSs. To do things properly, we'd probably
do something like

	ethernet-pcs@0 {
		#pcs-cells = <1>;
		compatible = "fsl,lynx-pcs";
		reg = <0>, <1>, <2>, <3>;
	};

but that would add complexity, and we can describe the hardware just
fine using separate PCSs for now.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v5:
- New

 .../bindings/net/pcs/fsl,lynx-pcs.yaml        | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml

diff --git a/Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml b/Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
new file mode 100644
index 000000000000..fbedf696c555
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pcs/fsl,lynx-pcs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Lynx PCS
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+description: |
+  NXP Lynx 10G and 28G SerDes have Ethernet PCS devices which can be used as
+  protocol controllers. They are accessible over the Ethernet interface's MDIO
+  bus.
+
+properties:
+  compatible:
+    const: fsl,lynx-pcs
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    mdio-bus {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      qsgmii_pcs1: ethernet-pcs@1 {
+        compatible = "fsl,lynx-pcs";
+        reg = <1>;
+      };
+    };
-- 
2.35.1.1320.gc452695387.dirty

