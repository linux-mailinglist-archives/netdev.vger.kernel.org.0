Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4612947D5
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440482AbgJUFYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:09 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:29223
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407293AbgJUFYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIXj1Y2J2vf2NN6QlF7XBMMY9ziG6XtqN2uv9C+fqT0CwGOHQ1tCSW+GZvvYKamT2ZIj9r4BU7qk86Djmrvs+a5jw+3XTQ/VVXiyWXyrULzf5bvTkFYys/zN/1tyI2Din2VPbjEGpjDwReDot5WIRjmQDBbl8axtaXjwFoNLLD8BTbFXakMMqywjM6W6NCMpuupMzIC/DUcFkSyQY/lKBhhHIwOcpgUZEO+6nYvBRLRs4VTCIPaetC4O8+NepkVECqRPQQ9wpknwp8DEwOCNjxMQVzk+W2gJnYJvVBo7qK0oheyvyiNS3nWZoYkNwSPwnyjgVpqeyhH14W6MbP/+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=nGiTVJjDVBWp19QPJymzCGRUIj/wrmAZyg51J+IAebVO7BOlt/0v2n/Voz0/XW+j8kDCAZEs1taL6o18PKaYetOQBEHxz3DFRYe0A4O938afHQZ09aRS2aBi8RAzRPnXPW/jWiYIPZyV8GKmhC593p2xcUF0K17bTsKR/PdL3/j2kfWUDMzCM7zAvbdYoxGFZgbc/VEgwg6FurrlD7hWPmyfAlxl3l+y/BAtRnhUH/Qz5wM5mTwcwN+EHhRu0VIR/uqpNDX4Sr+ECM38DvZGirFH4JBF8KeM5JiF2EMxzj38T2MvI+55ToEtqekG4L0JnwtFl5DPDf/4WYJgUDl/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=XvYpFWzgG83IT0SQCKCuK9VkNSU+5gRzY4+OkLxlcbwM2YDBXHfvRAcdvR0Q+YtZxQwLY8yduA6bWcrTuzXvv2B0/e176vxU34vuIjr8JxJH7ShAXyCnc50MowXazlQ0ygkv6HTbXmA+0TN/Xj6WDSaCQjLMM6tV7CY9hasWP78=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:24:02 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:24:02 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 2/6] dt-bindings: can: flexcan: fix fsl,clk-source property
Date:   Wed, 21 Oct 2020 13:24:33 +0800
Message-Id: <20201021052437.3763-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:23:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0ecd4e5-e6dc-4cb6-1784-08d875818573
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2726E11AE887EA289E378F42E61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iwZ4rNyZEyIE/7GE3CYJ2vhxWqXnRNQtgsSIdER8FDeW5ogPFA+fMZev+3y+L8vvpqL/nELPQKYUzImzIeUDgmV4bzD4yTx0GLk4McSsj2oNPVVZlMBooSfgP/Dvha9j8MlJKhk9FC+pzWioBhaj528fBM4IT+SaI44R5/AuPBHWsbzwMT/Ab+U8l7QwttwpY/PB8EJiuvJWan9Spu02djYM6DHUjk8lqAIJVOXJgaAZMEZqDo/RyEEqiR0k325ZlSzZg5tbAPXgPDeFI4cj9UkWM5JT8JAf1E0CgeyiUG2voSz2XaPagQ3nRCalj8otJ59yMQoD0KmNsW2fdPsnya8sdZLX3kpXv01ivKo1S0MK1owzuwCLKq5zFgbsMAz5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(83380400001)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(4744005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KtCrcwvtGE+ywyE7ly80yEOTWBtDK8mBHZcaft1TZ3yh+XQwLSpMKYS7TvbY6/l8ReCBGJyj8aqAv8jG18YdV6TqG9azkLm4D+N2U+KCI1neXRriIfNKS9OkSqn3u08MPl73u5Sr1FYvscURUaiwfac1EVBoQm9a08kBKLAhVqpCB+Gs0xAahp5LM4fpvyw+8WEMLV86ao9gzbRYQuZv2WF6ijxMLdt1oA05pFv7kHGYS6Q4+maPrb7SSQWOkuePyzypx22Ds27Vnr2OAZWTpSVFKDObHztdRRfxzDlqlAx9R9M35Q1DaNNHrssJrzwgPlRTiGKZq2/GkvtxywBUd99kwahrOaMrweNB+NKj6A+Tt/K2DqG+6noZTOfgMWgu4/rUC30S0kTf/5SRuRD1D8GkGvDAFZfkncZsm72rakZNfIAGetgBIQdCt+Y8s0lG2EJEa+Yd1gLvHDkeuP6Cq0fDiYcw4+TRla6idVjZMJaAwRsGg3euHflXDKO6NgPHhcDKdYX84UG8SckZWRYVaiOvgACxpp3nJ+w8QGW+HLNL2ha4c7zwJ3N7MNXSe0MRdUOpTnHzQGW7yddHZQDXHChAQhLrwOY+NBqqoazuyKB6MkY2cDAq5cl5FC8GzRs9twocHjQontP/efJxsrwqEQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ecd4e5-e6dc-4cb6-1784-08d875818573
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:24:02.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gd0dk1ItqUmv9cRJs9Pgo8A0SeDh6RsIR0UVgHSZTgG1Gi0z2Wn+lguWI4dacOTcvTuD3FGCWFdvWvOxrWnsAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct fsl,clk-source example since flexcan driver uses "of_property_read_u8"
to get this property.

Fixes: 9d733992772d ("dt-bindings: can: flexcan: add PE clock source property to device tree")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index e10b6eb955e1..6af67f5e581c 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -53,5 +53,5 @@ Example:
 		interrupts = <48 0x2>;
 		interrupt-parent = <&mpic>;
 		clock-frequency = <200000000>; // filled in by bootloader
-		fsl,clk-source = <0>; // select clock source 0 for PE
+		fsl,clk-source = /bits/ 8 <0>; // select clock source 0 for PE
 	};
-- 
2.17.1

