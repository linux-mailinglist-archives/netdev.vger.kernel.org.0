Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD93829232E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJSH5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:57:49 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:15008
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727420AbgJSH5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:57:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+TzNQCOgHALn3pWRNJLp9nl3ezGxJX87VdToM8C4CeBAm2BTLj761OU/fTzypDX5mieTSIdxfsWfElM0FkBdGfutvUDahMbI3SyRhX9mF4ZhydQzzkSARpT/OmCq8GrbJ3g03mCtdVbN1lrRc5m/6PAnAWFiBD9Xxy2PNCz6T8Ybe2SF8bfVzN/JRFVuZHfx9jy4nqF9dbsW9H3DqR/TCjosp5f8AubDdn3iEBIV1/7xjRydTx4vTPhEMAGPWuRhcj+QUNAT+bT87EEW2dZYPyIsihjPp5bsdixHUw8xpzukPmDmdGumSM6AyhqryeQtNMk3AzhOt/c3EbIlodWgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=H6AhT8Ubk4Mq1jdhTzUiECmSuZDEdsnl+3k+sey6BhUGauFbhaVzt2MejQA2BDKZN1Lyus6MquzaHTKTnibO0DmJIbF+R5esZ/La8WVjUs3YR3I8ye5npjUiDCpqkkMpyM+OVLsqEJEFxKcOZT64TjIYeziyT07ikMgkhQrNCAQj3v91ZcCqG0Okdr5elm4M8N7+H3zYEvEMiprQqBzRqHc8J6nf+5maiBbzrP8wod4a8xXbU35w84/N3DBKfuY1VVFm09felJOczNqV+/AsLD4Y/TjxeT9zz2oonojsLItTN7qxYpO4dffVgAKQffHeo5cfWaYRpsXeo+kU2HPAyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=fnihOAR2ulATD1fDp+KPtGUQxvduQH0zp5EV7emwEqouftmKkX+2BwfDw98ZjZJsr5uv0B9ysZG75SHI7660ZDvNDbdf+85PiPgW5XWZA8SuGB9uXnQI12YUgXThN8A+IkXEQ1kGzAHFdrl9nA2x6iVfwnMm5Pq8fZu7jSys5PM=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 07:57:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:57:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/8] dt-bindings: can: flexcan: fix fsl,clk-source property
Date:   Mon, 19 Oct 2020 23:57:31 +0800
Message-Id: <20201019155737.26577-3-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 912f7800-04f6-4164-67af-08d87404a9d5
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7430FD6DA800EB735A31FC58E61E0@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5+aoeiw3rKaaW6ZHl/ABKXvZ5G9Wb1fC2qQG+hBbj5XkQhUgYTRmM0EXyo1e1/e4siu9aF4HkaGB5kLjaJ6iuPSHMPMv6ntoQK6Xcrlu8ABrKm46qHrOLPkjfbNUNZX7Cizt7FojL3IUt81bWCnKN7XnH3Ic1qRONT+lNRwlm44GmYNwvP6rUb7BEfVp7B8kooR30/jvY+PlqTHiACYB2W89Iz8H+7YPpaGK8mAvYYfjBIhahH+6wFvMnDIw6oJysW1yx5SiR2N/Y042AKpJMdDkXl9OjaGgxy1laZ+JI+azRRiwczLr7lFwyQ3WTE6Tny7xhH07NpvSDtTfPE+s4V05mBLXbjvlPcGHilW/TOppjfA/rYPzEsZdAI6lYIA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(1076003)(6666004)(4744005)(2906002)(4326008)(956004)(2616005)(316002)(5660300002)(52116002)(36756003)(8676002)(8936002)(6512007)(6486002)(6506007)(16526019)(26005)(186003)(86362001)(66946007)(66556008)(478600001)(66476007)(83380400001)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CiR71sKNxe8ayBoohkXrnjYVZ/L9fDGULe18LY3JdBrFPkjKyRFnYbLDqZQLo0g5WOd6XxhKz2hoo0p2Zm5VG/rSni/u2EaY+xCJz8ihraeHMqBWGb3jFzekuA0Scw94wOQZ4YC/nljbkNHjW3lKipXaNNqK8esnHLiekRIl630DgD+Xee34dqvIuAY56sktdaazvTHNBKjiRRVjm0aX53q9Hc+PmfrNmQMuUrMSGprTwlpgLBWJI/QMyqd+NaF+P0fLzYTqTeIFodDSiRxk3nwCgFSBuxwCdWIc+TKkXMvBN2Yjss82QDtdcH7PQhaXNiTo3jyFyt+qFxWHI90Wik5bdUv9Abo+9L+o+BWtggRrFeSgldERlz2aHvwitBejSGTFjNm/fswxxAAEB9syoDUj3inKPRMQa9vp3AFZ9xx21Kzq6ETYUDy9GWRkFDUXXdJBnbKagrHudIIQtBjYBt9bBDjitBCTx5flxORM5PbRXHzeN1pCkzepExv7Rkg3nKH09l+tkY2K81x/HxxWVlZj7hNcHT2/Tn62gB46XPn9GC9dz8aaqUduxJeGoP7vdMu15nu29V5sJxEgP/c0rQq5clbcJqcHDf5wTQ01KIlf7LA8AunADD8PnPbwROX1i1bcK/xdcMm8KyVmJzFgYA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912f7800-04f6-4164-67af-08d87404a9d5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:57:45.4615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQEi8vVG71v6Ub5sJ/ksFCd0dah7lJsDtQfYOHGDSuncTOJqI/5s7sM2TiyRl4Yi5Q5d8Qbk4GzzNW247ic8wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
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

