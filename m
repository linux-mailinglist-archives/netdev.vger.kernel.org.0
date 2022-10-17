Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BFB601952
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiJQUXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiJQUXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:22 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3734F678;
        Mon, 17 Oct 2022 13:23:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGbOp+XhqiflH6ryfLNnSoaycNYCkB5XMlF12XZQg9x+yiy/9PmiEadmVsuV+kSlDkNIKxFwS4IXJXSBVqHixuOrkFEjHU+eeb26/zwN1MWqAD4or52r/9UUmaZRw01vRzh/Gu80uq3tqxfjyoj4TkQWOqPf6rfUoeeq3BG4wPwLPqd9qogyCFNYbXpfVo9lpbOeqed4MBNBGIMaZsW2Yu6ORudYCZKZqe009awEWR0wMpxFeJwSAeSFgdzrbnxuA9shlVSjhtSjr56ulHBrZyr4i0V6P4frXSAUUPIlhBSvjFKvCbqN2czyVK7I8Xiw2RmvFcrn7OurueUnp+49Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OiB6zoWB32H0EkrMl3eZ7akSCrZvMfmnm7jIt71Dpkw=;
 b=Viwx6orPvQEFFgtskKZuVWkzj9+QzNUbwYSJbtzwZqbv5ORzCqqvLM2S9RAFjwyVsfa8GEto8WaaSLnonVv/hOjNO2pVOs9zbGGHL5bXuLoReY3v61apnQwdTyvMBNeYMHzGCsIjIMMN/MjHBu89K/OX3Tq6j65EVNYXqMyBcOUXfpbw9LeEp7Xls4V2sEtBY64wqpIcHYVDCbQ8Wpjuc/7UXx8EsZFm85r1lNz/+EPK1fB/gjL3ImUycw8gkgxU612sD5A/nz/IP8xVaRoCKzIWzJJsXSDZrGU48ggpyHZ9UU92SSntkuVnlUIGNvKt4SQ0RDdiH6367T4CoyTbgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiB6zoWB32H0EkrMl3eZ7akSCrZvMfmnm7jIt71Dpkw=;
 b=VbPTxe6bddIsDUjW7PCFLYY+Vz7SlZO3kctIbrGJLR1NJyop47bfdCS4y8D4XIw6hFyH9NguE1ORtqLXOlnsbpxKxuGmZRhL0jsmeAixg7mLqXnE+fsPI8NC5I4zPkdU/MyCyhIo/lE6cRE3a1hujW9Bee3MDFzRvuM41xTXfIeickFrNsh0VKZ7hMViGwxZOOiFpedPxxjjLO7vV6QvUKd9f6RxdDgzigusV2L7+yrvTjPN17WJ1m1F36byjhh88yHm7ZQIOtkqZ1BRfqF8OG13RHIhXjkPEybxX1H9EdLyCLy/Ylst3wsxoly1feKjP9vEjKtU3UU5nkc6mLoTNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6761.eurprd03.prod.outlook.com (2603:10a6:10:1f4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 20:23:09 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:09 +0000
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
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v7 02/10] dt-bindings: net: Add Lynx PCS binding
Date:   Mon, 17 Oct 2022 16:22:33 -0400
Message-Id: <20221017202241.1741671-3-sean.anderson@seco.com>
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
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DBBPR03MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: e31ec7b4-e7c5-4363-ee57-08dab07d6846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONfDpIFwvOSb5ZPvz/rb30m/7vwIciGXP6KjYCMcHKn5DQCZ065vgTtA7J+WwEiVCeYpSaplEMPud1B4HrEz7egV27uPhaCAcIc1Pa/ylsA791xCSajb9JncMBz+sPz0Z/cANwaP1YxUR4ShkXlZeHwp3j1iR6nA2yt3LvefI9hcbvVSsCfImHijsfnKEsyLcrkMYsAl9YsmOUviRcE/rHCl2ikFXitICxKZ2rwpxJn0k7lER2PtDjpOd7iNwUmAKV7cwJICgYALfqk0Elk0syOQPics37rnTKZ3Sz7bgAdeM1Se+3+TWSKtJ3N+mLwA0L+f0jNqyY1mdNo3Mv0LWIAPl86JGp+DL5yJFBPlP7ayGVCJXS0HPAayh8MyZ4d1Crgi+djL1x6PTJN8ChELB+viGYieAEU5p+ffVCxY+bFr6wgTmQv+MUlPfQQL0OUyDKBYkAQYFUVRtbR1yFSd1/zn0qGuGEF3pdnsHw787mEi9+QPLhTXEsk6VFAiQ4iqDme2tmjm+cbMOXONfK66kqmLjFwxkIJW7vzzCnWzMbCZk24rFAKHdlRu7v5cWBBD9M2d2wau4wTML7b666m37aPVrmOblcrYTp74NR2wpBirW0awqJkOxpD15MW/L/wEeyPbHDcpu981/tTAZcfeUCb+7TOiI8uiBoTEVw6HoKrE1wPpVKpcdrynM86gNV/3hEhK6RwooiEPb1CiOhowFp+RL7UzjmbPXCMfvpr30mS321j+X5KpUR06PZ27EaWwoRJasaccbOLJxR+zedff2Cmgf98MAOwNWgxsNoYDKY8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39850400004)(376002)(346002)(451199015)(2906002)(5660300002)(7416002)(66946007)(66556008)(4326008)(110136005)(54906003)(8676002)(316002)(36756003)(478600001)(6666004)(966005)(6506007)(8936002)(41300700001)(6486002)(38350700002)(6512007)(83380400001)(26005)(44832011)(52116002)(66476007)(38100700002)(1076003)(186003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sZj8JCyzj4r2ufVpHwQYUCRBMaZbDUHGlE9K9znQ40wM7buZFHGqtZTw1E2i?=
 =?us-ascii?Q?jZEcNGADUjyQKLBchN0KSEVDQbIDTdMv/S6m+et/aQgwHuh+NlpeiwX34yYP?=
 =?us-ascii?Q?lZ+7Dj3ZwefwRIk44avaDVLI400S8VM37fwvNY++1JhZWT9ulvQuHrcbJM9V?=
 =?us-ascii?Q?gqj5sCCLgI1Y3Z0ayhKiO3PKhU1NlnPXrsKO9MI83Zw/tzu6u20mnof3eKEZ?=
 =?us-ascii?Q?kyhNsGwPZExtTfcDSmZnKQYUyB27fTN3Gtmhf2QjC14G19RbG8Hep5KBraEI?=
 =?us-ascii?Q?6T10uj2QmnoiV1tf8clZYdg2Y9V2cyA1P3iIjrvvRuvRebxUQisWLytvm/Zt?=
 =?us-ascii?Q?R5OdS3aJnqD4IdPsKimvY3mozxSb0ARSUItMseSWYn6pLrav9bg8RmG0Ydb9?=
 =?us-ascii?Q?EnXnB5Np8krOKG+aU3htc0yt4qzY2MxJdyxUjaSklzmfvcmhB29h4mqxbUv4?=
 =?us-ascii?Q?Ldk7D9qB7fVjnD87ay0JJXF4cmYv+3h35aso7ldByMsFA9oeAjhnKnqsQ53w?=
 =?us-ascii?Q?vZPh/9U1Xuix9C39ezAF/TdRwDqqqazZvwmiztmZp9UySJGnoyEyeGSX3QRq?=
 =?us-ascii?Q?KQRK5aXV6A+ht9xcnvcIqK8BqYH+L3g90rwlfEv0Tf7b8wqTY7e+NuBnEfsb?=
 =?us-ascii?Q?tFKWXMVRmLoATOxVesik8ORtpS2Y4AS8qejfr55NCN171L++17jyKDqn13iW?=
 =?us-ascii?Q?/7X78zvoMhv7p1L+SRXYzqpK0PVe6tWa0AJxgtwk2EJg0hSJxFwaXZKw6H2+?=
 =?us-ascii?Q?/DyipZqRmW8qdYXrWWiFJEBqUJQ4jQPMAXEWhmiHsD7Pb6l9EblQ8RJRePbo?=
 =?us-ascii?Q?nqagElHrb1773nger0uhynq8JrBJqOEJaNm9UoftYGzuCPhijFMp/EBgFHK/?=
 =?us-ascii?Q?c8AKPZtacTyiutl36B8Wuza1bacziHuH5fbSw6Sw2ePs43/lzEn/xykA9976?=
 =?us-ascii?Q?fINKnMdOWHrh1vArAQ65IyFHMm5tyVEiZx1Qt97+xMsPrUlEpxRXSSoIU6UX?=
 =?us-ascii?Q?Swa40HgpbYrO5z78HuoboiIzZdKz/iY84fmIXsNG0EQ7G6GhGkkUEQBU0U55?=
 =?us-ascii?Q?1zmjnsxCQ2QyXJlCpaB1ms22eUQ7Frm+NWxhvXKkV9PZRi5D2WIpidghqFIb?=
 =?us-ascii?Q?3veA3HB6Tpql6RE025XIKEUNLwsBAvIkB0HrhG4/V/X5wfb1h/hqn/p+sLEp?=
 =?us-ascii?Q?RKipUocPdTO3l69E0DN0hNyzWVX7NATq2hUNS+mlYEOjT5UsI8twvQmQftf9?=
 =?us-ascii?Q?AzE1D4aEprJ2da5Ek4YFhfp+ouuG5u56K6CmpzPrcOhJapTRaskk1LtUiftF?=
 =?us-ascii?Q?puq6ng1A0u2jkOY/AoZkZNc3QafNo7yc9j8kNwzGCJgoJUSLr7Svz3D+xRNm?=
 =?us-ascii?Q?Sf+r9oBGzuMfu1fqnhMmcdExHjxY3pYpRtdDwMDDlCJVN7HlFc1ktkMAw703?=
 =?us-ascii?Q?7VIXqlOovU7KUEtm9ruE2bNXRLXakuc7o8rajkN7VRB3ThQsKsODxWFY1UGy?=
 =?us-ascii?Q?dz+E0sNxeLZ6feaNg+LZwmLs6na0eIk/smF0vVSmN008Leuaz1WdC5Nsm/UZ?=
 =?us-ascii?Q?aK3XZjSqUQnewamAzG3jtZJn/S1BFCLvONSKdAisoK5SGJiuMaTSYxcmCFUa?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31ec7b4-e7c5-4363-ee57-08dab07d6846
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:09.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzqSBp8TU79w3S3cEHtQWAmlgLyaeskk+rdx1iD8uSHghvDKWk3bFzR6EyEoNSls0k4qv0LjxzAw/a3u/SZvLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6761
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Rob Herring <robh@kernel.org>
---

(no changes since v5)

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

