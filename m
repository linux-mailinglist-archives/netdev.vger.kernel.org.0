Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E71A2A94DC
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgKFK4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:56:16 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:41045
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbgKFK4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 05:56:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMtpVy8sUM3xhH5tHdh6+IwfjHF0k64KtLo+Oms3aXxTl5SxKAMTUoaCRsSzw8Ed6JPjq4+EadHH6HpxpyxEm8yi30WMPCvJseaNLPpISUTLZWlvbY7MiDt90gnMkoiLACZ/QSQhflD1wd0EfQJAW3rOsXfK1PqFuX4W+kMHGW/LzAJnJtCzDoh8JzJ8GM1e5BtFz/APgdGck+7NdUgjMJAiTycZxL7dcshoVd8YaPQwWvsFXSZNsEXeT8WEJxtk+J2jnjge1/IUFIVmpsI8gI+Esv/8zPjnSHex+mQQrQEAsevmVJFqDsOPCu7gFTIrpJSHQj7r0QUlGil17X898Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uj4A6W8vep2pIgkutgCP/+sslLVgakRW1SEl5RE6QXw=;
 b=R3z/AuCkvhVPXcIlwu3LO0Dkj7ND9pbDk36ZNPe4Z6w8W1fto8oba8z0OnortC7Ltg+sG+TtPmTFxVIqtXkNgyrgupFYyGWmoa5sXWuk2O4uJmmmsSPcdtT+/rdxYy94B9LBiuUWJPhMrJ74mMCt2eS62senomN1biGqyXTqOUxPLjpooG5Lt+uEWlQuwxIjcF51ZNkU6HENvQw7pkGbw/NvBlUC2g765KYcY44366Q3l0ZVUEeyRN8cVX7m3YdttGoNT6N1FvUgkDEh8X6jZP6HOvv1cD/eavUXw9bqt+q2guQwbYd0+Ap2q7ceY4E+1p0jL2MdBZCLeQCs2D+XBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uj4A6W8vep2pIgkutgCP/+sslLVgakRW1SEl5RE6QXw=;
 b=HsQWKyyyrN6Ox7iaY7vHRd3Z/Y/KEmMalqfLQ42cVi4fa3LxPhuVfKzIjHMl3xBgcW0yyjRPEOX2tvyyIjdIgPCAHA5D/w3IO91tEAM/5S11E9vAhkr+kpyCoAlvgo02ypUBT3uFFSUGnMil/hEDOrX9Fg5xkFJxdbrXdGU50yU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 10:56:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 10:56:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 1/5] dt-bindings: can: flexcan: fix fsl,clk-source property
Date:   Fri,  6 Nov 2020 18:56:23 +0800
Message-Id: <20201106105627.31061-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
References: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 10:56:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64b7a180-483b-4367-76d7-08d882429031
X-MS-TrafficTypeDiagnostic: DB7PR04MB4282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4282DF7596A908CD6C171800E6ED0@DB7PR04MB4282.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lPPomWSz8UvqtpetDZiYCsb1fanSzPMvoNtrm6BkiiO1/hvZmrFjzEnJ3SlA6KqAhXJyTm8CBbUwLrkfRtSM7lVk6gjvKxjRaMHW8zVmDFYO5cbY/BDXtYKjvl+uFh2fgKKWkXeYgX90gQ/9qdC4WRkCEbmsdeAeHjRW6lLTQwGCTIayVFQP9ON7r+B9YST/QAqS83jSVXXTk3JEmYgEkta1zeFANsBW+tvDRlt828uGwoIdlbjZmc6lFiI/YYIDV3SabfRYP/paPzEjlnXi+ODUbR9w7BFjuMu9cI+ZsNHfg0Qh04CXrXjewXpQ0oYPCiWOR1ARJGJQ4Jsa7WPZkdET3Mz3LwAo5wYOnwHRAGtj+44FXhRMyEFOFTUOqqU0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6486002)(5660300002)(478600001)(6666004)(26005)(4326008)(83380400001)(6506007)(956004)(36756003)(66476007)(66946007)(8676002)(69590400008)(52116002)(6512007)(86362001)(186003)(1076003)(2906002)(2616005)(8936002)(16526019)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kH9+VVmT6uAnPfdz+jzIWE9ed2WXFXYgpLQ0IAjGqcMTOd3SWiQTAYcJrAIZUfLC47WDwYTF9YSUHnU+wAxY6gCsUWnkp902tg25vXJQwsVkszXsy1tX0n2R3XNxG/fWeZ6fBxp4NOmUzpkRkaXVz1sYyyEFIkwpZbbjLQv8P8zgOrE1547D0m8RW3vilZEZP3RmWiOZ/lvK5b1+sTB6NYKh21W6DmucmU5CJoNByJnpTbmDAFTrBeVzUChOsJ/Zy0tw3wnXWM0ZtmdSNkikb/kh+kfgyOOjpRMVHtWyNo4tPX/+bdfXBlYoSA0s0r/7zdfIRp81flcYQe29S2M8XDM2TnXgnbVMHDOOgY2mODt7VyB0aESUGU3aOZ4gBIyvJVMmB34qOGIokcVulSVBpjVTS/NFtG3qMSbZcpSwkpm33m+ES2OepedA6pdibQ2ygD7wOHBqUAYhbLhzEEcm3n7t/SiEa1M7cw8MILA0gubAKhG/x0nYI9RWHJVDoneLI6onSLiY79jpjjZ9qg1VI8TADJHN4VraH8d0ugHOQw7oTnlykmvE3QwmwLKejRv6Sfz1AM0BBzkncu59FENxrt5J+OoS181X6LB38mo3o0tUI6FXYfbXH6N109mPQrmi+y7nddwK+Cdp53n0Ao7gcg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b7a180-483b-4367-76d7-08d882429031
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 10:56:07.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVvnjnMJUWVHS+FEFhLEmTUtpk8cowopQMVDqBdbBiMWgun+fDpXkIkXJDOw27YFT0JiTFGM08WKsMcgflcD2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct fsl,clk-source example since flexcan driver uses "of_property_read_u8"
to get this property.

Fixes: 9d733992772d ("dt-bindings: can: flexcan: add PE clock source property to device tree")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 43df15ba8fa4..8f4db883e16b 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -95,7 +95,7 @@ properties:
       by default.
       0: clock source 0 (oscillator clock)
       1: clock source 1 (peripheral clock)
-    $ref: /schemas/types.yaml#/definitions/uint32
+    $ref: /schemas/types.yaml#/definitions/uint8
     default: 1
     minimum: 0
     maximum: 1
@@ -120,7 +120,7 @@ examples:
         interrupts = <48 0x2>;
         interrupt-parent = <&mpic>;
         clock-frequency = <200000000>;
-        fsl,clk-source = <0>;
+        fsl,clk-source = /bits/ 8 <0>;
     };
   - |
     #include <dt-bindings/interrupt-controller/irq.h>
-- 
2.17.1

