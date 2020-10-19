Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E253B292337
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgJSH6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:58:08 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:63976
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728435AbgJSH6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:58:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVlfz92XjB+LRQ9HwO7jwxAR1ikaLfG5WiPxHnfPj2ZVk5JGPoSIQ1ZjXTRk4wZmKbyLIiiw5LD2FPDxmb5AA07cBjl0jpUzEG6jw6RSv9q6mmRgG64uCmqG/Tlimp6/3WYAuTvQ3uhepuevFhDrHLLaVAO2kzvpkouAboMkyXzFCnd84Ex4Vd6RDnnBY92LKYzYTo7P8w40vJE0RlFCiz/+74EQSuD2NPegUAXojtGfHBnJt0shPlChb0Uu9w1ce4SEHNemDkPCeMcczWXu0+1OCfrd4nPnCA15FM5UXtQKKNLntsGYpcQgMMV9VUfOfeg/v9Lro1VbvXaQw8wffg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkDwRQQnDsJ6l4YhI6BNKWr2jPI/N3rQnuj4f1bPETo=;
 b=Za5kHCr2eyEyr6BCG5YwPT84jNISzIrz+NK1Cj3VPNpaJjtKnQoOrRxqpU3oyXtp/3fT6Uzc/Pg0LXbHCpBWsRqMKd9i2x4+9Uez8M+UFecEUFe76tB4lTWdirMdU6Kd2qJblEbxXRGaEP7JuKzwdz3FDrad00ozo8uX8nA8qgpZIe0uKlM4gGXy9/5B4G2ANwmwrbH+64886q8KuB2sTm96RPTyiw3wd/zQDVVjHpI4GXlSZBP8YnoVaKJb/JoMS14CCAIqDSyPh9Fzbajde8+7VbIjzYZweDO0b4ysCBb+sGXEVsUY/V9bXbBwqJp60Ui4T5TNQj11wAZbOlEhBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IkDwRQQnDsJ6l4YhI6BNKWr2jPI/N3rQnuj4f1bPETo=;
 b=A9j85VmGmZkVgF1b/KPo8+tWb65MhtI5iAaUJvORDj9Vp31AZllBBbprsymQJLaVVMzUYGjBG+wIPLSxu0XKM7r2VMg9eO/YnuSF/MaSlz//eX9zRVFrFz2yoQffVZ2vibXpeM/TbSBmV87Le9pQDfEMtBUVNqZ1g93WlwIfRSI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3963.eurprd04.prod.outlook.com (2603:10a6:5:1c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 19 Oct
 2020 07:58:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:58:02 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 6/8] dt-bindings: can: flexcan: add fsl,scu-index property to indicate a resource
Date:   Mon, 19 Oct 2020 23:57:35 +0800
Message-Id: <20201019155737.26577-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bd2224a-c682-465c-806c-08d87404b428
X-MS-TrafficTypeDiagnostic: DB7PR04MB3963:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB3963A2BA503678CCF135C7D4E61E0@DB7PR04MB3963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJlwXF7QrYfa30TCzhZfaJRYXFy1dKvmEeV+TkvQcNo5uUQcuTa6XL/aNc2pgEDuezAtvLp2Gz2KZv53VkFEJ9AAY1NHlByu9MRHbaQdvW7R8H0ZXcoKAnEnelydsV35VyWDpHj+MXkYLdhuloB/4+3/QsZR/Tff32+cLNdptRHMtI/l040XP1VLKn8ts8YWPU5rTCuArqvIRbd2+y3eeMnAOplcK3DZci5gj4b8feEJfq8JIEXBocF22nNQ7DoA8gESnFsl+T1Sj4UWsnPFtjqxhloDBZgrncKe4tAqvHhVBRou964chow8AiVMRFoHLA+GdVpcKXfMk8fo3MjRnQBhvNMh7rPrAtyQ0Oa59NW2aCEpx3ATUZsQDTsYerN7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(69590400008)(86362001)(6512007)(478600001)(2906002)(316002)(5660300002)(36756003)(1076003)(83380400001)(186003)(16526019)(956004)(2616005)(8676002)(8936002)(26005)(66556008)(66946007)(66476007)(6486002)(52116002)(6666004)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J898xXImeU0DnUbLgyCBquzYSWy4a60kKjdx/evZfRdqortK7FBjiPfvfwcrDKyfqT8vTMOnmGIcnPT3zeAWl75eCei3dsKWCYC9C8G/LD5uzFjoCGsxRp096Nwyb+KN6LTJ6Jk4+CYQdNVSHfv6NfVjY2sw7s0sr0VAbIvbtIZ3IBolA9wAphc6dKv1nPHAkUmdllsrBnoycv882X6Pz8aGUALyCKe5SJ/JYeOaJIzQxERbXB6xhKaegDrLRDrNcC5qtnw3l8RCX7GhlRRjyj61gDQXm0nZJvZOU3hIqD+RhVHk4q6fxeUVTY0ufAQwjtxdBx3LsKmaUtD/F/MTNCZvyWEDgPbiNTkHad5wNBRI+BDdcRFQVj52OzeaiEqOulz2nqOFVrfnoy4f5NYpn5zj8vDqZ0REY6DUJiJ+r3TXbEC0qUs1isv9xsNe632Q1mP9xS4X6Z+SmMPA9NhwcijBxJzsswgByvtEzs3pztNw4wpdWZGjUAa+5RFMHDLFd+o1qzHZpnkxST4hzG86iTpvIY1t3rt4EddTbMyTK/iMoCaO4Vu6xneCWGKB1Y4FpZiDn9Ygc23pB+KdaopixBIC87Nq5qpEIBKeSISbUACpvIKUPHUDxF4mCcpTK7mawsRayhqo4kwH+hxiYICMog==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd2224a-c682-465c-806c-08d87404b428
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:58:02.8201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgcro7nkZz3+wzMB59cBTye7+dWR6bwGEzmEzVPkS+M6DFP51PItSeuKdCEN1E+XfvzoWfMO62TOXQCX84oCWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SoCs with SCU support, need setup stop mode via SCU firmware,
so this property can help indicate a resource in SCU firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index 6af67f5e581c..38a7da4fef3f 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -43,6 +43,11 @@ Optional properties:
 		  0: clock source 0 (oscillator clock)
 		  1: clock source 1 (peripheral clock)
 
+- fsl,scu-index: The scu index of CAN instance.
+                 For SoCs with SCU support, need setup stop mode via SCU firmware,
+                 so this property can help indicate a resource. It supports up to
+                 3 CAN instances now, so the value should be 0, 1, or 2.
+
 - wakeup-source: enable CAN remote wakeup
 
 Example:
@@ -54,4 +59,5 @@ Example:
 		interrupt-parent = <&mpic>;
 		clock-frequency = <200000000>; // filled in by bootloader
 		fsl,clk-source = /bits/ 8 <0>; // select clock source 0 for PE
+		fsl,scu-index = /bits/ 8 <1>; // the second CAN instance
 	};
-- 
2.17.1

