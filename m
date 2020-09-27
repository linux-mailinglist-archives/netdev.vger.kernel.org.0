Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CFA279F7D
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 10:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbgI0IID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 04:08:03 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:61957
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730443AbgI0IIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 04:08:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J62KWlkeVy7ZVO4yD9F7Y27Kn0sLOAFp62mk5fi53j915+TOtzDJAjS0MmNPjBsNhg5yUs66iMSAttSOsDL6UzmArsuZRQok1gW5X+KveUDxkJmcw26KyLUazteK4zrfCpeoMuromjDAHjOaAutklM9UDwVUa23ut9WQICGyFtSQyCyA6jAewj10YoGWQuKWbQ+lOaMn+wt7iH8L1r209Wd6boobDXAxrcTYZDZIgVRM3H6go+JO76dpuo5IS+IwHG0JiLe0Hi/smMSB2/NxA0KJrrpYAjnPlLXnVOXbsFsqTzL9sT/CL3ikGtgJN2lI1tQDO/GjazWEwxUNA2uddA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej+1gnBp+qQBj2X8daX2RaX/DdI0Ozkbv5W6apkIYJM=;
 b=clEOh7xZUuxyHPtSqmkX0+wOFBG7QMfEPeYSF9WCI0VVkwB3rWZpUpf+0+HfagmEkx5LtrcYGXT+Rdgi7ypm/CwQJS/rJaV1+cTTw3XlvsfGc7mVlzFQDlbfJqNMt3fUYPd4r65GWoo0hu/Y+MxXsCzvxt9Dzgi65xVbLtmPDFW4t2oHn0PffvQYEaZaUu/mZoLrC0HdyZcwhuGaoXBDgKbSebKTRKBLqyv5k64BP7dEw9+m6GowUVhOZnqu/TW7Xe7S05vz0yHoDst0sfNbQVTydCxKLxti0nc3KeYq8FaVAluvQK47cq7FBPGh3dzBe6PSjYIO8+m3ZodE4l+UBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej+1gnBp+qQBj2X8daX2RaX/DdI0Ozkbv5W6apkIYJM=;
 b=F2kMQwE1iK5yzOuxfUVFyJe+wF0bSZ59ETN/Xef67iATXPSqhqA9nEfqFVa4grkyP4pE5RLeouGsSNx9wm31cfnuu77wrixxo+8c/wFNh1qMdxAi9uAasdGtDUGAp0gezxgXG4KaICVUItYDPOphNWsBZIn8wJ67a3L2ckDzd/g=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4953.eurprd04.prod.outlook.com (2603:10a6:10:13::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Sun, 27 Sep
 2020 08:07:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 08:07:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH V2 2/3] can: flexcan: add flexcan driver for i.MX8MP
Date:   Mon, 28 Sep 2020 00:08:00 +0800
Message-Id: <20200927160801.28569-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
References: <20200927160801.28569-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0012.apcprd04.prod.outlook.com
 (2603:1096:3:1::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0401CA0012.apcprd04.prod.outlook.com (2603:1096:3:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Sun, 27 Sep 2020 08:07:55 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a7ce6ba-7610-4614-0a84-08d862bc715a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4953:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4953099884248845B8CDA896E6340@DB7PR04MB4953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfLTEPBkMntausi+6W2ceK0GdXYQBAl6kIddXimnmocOOpi+c6heM+t7l+LyoqIPxwYNNWsVDNDA71lR73FGXjI+39x3brBY5ugWaR6mxm2Zlg28g61UaXWCUS2bCV5Sk9aS8VTHkhCD9Ap6ESOBhi6ZV5ns3jphavcTN9g50TeeCrlYM+a0iOku1C98r6lB/qMsbVTuEC6Ru0dQSgo9EHIerSJ+sLT5yP7lX6QJr5MLFjtZ2utRzEz8JssyprSn32PtW/60+vhuTNi/wdCLiLf3n6zj5aCeRt0fHeBR688XmEMXNE7XK8DQ/WRPvq0+IjKBQ4eg5FkcNZ+/OIhnctDHyLylIAPCxz84t1NSubxshT+qgx9BrXnOt56ZC/rux+bIMhjA9onQBdmMIYPBewBHcjCrQcpNuYVqSuDhB+JHFGJPDWI1juqGbLpNngVR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39850400004)(366004)(396003)(4326008)(2616005)(2906002)(69590400008)(66556008)(66946007)(66476007)(5660300002)(16526019)(36756003)(186003)(26005)(6512007)(83380400001)(86362001)(6506007)(8676002)(6486002)(478600001)(8936002)(52116002)(6666004)(1076003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YtE8do+rMHyV6DztbnD7yWGFO7Ku55OtrCwQy9GYazvieRjQeLP3/H5tAV9TDwlz9nG8kyeUoET4bMr9/mbml44zhMzTqI7Yyiuh4pma8rWDF5PoLYpTq2KKjbce+oSAxjBKEU2UtPQrpF1L0CBOjSrV0KRNAxbv45isWQvTNk/l+eiA9BZV6aLq8d8V5dgsynJLEMeGILJzg8kW2fBV/zHygN5gCjBMZe+l9YxVP15x1PC9vth7Kwbg6nldWH4Gknom2aADb6cGCHdmTnSR7E/extFVg2WVl0m0dRG/x05dGv6gX61kjhcUyXpsDPNSrmKcV1BAZxdN5twjOFfJhrgNSJbKgCYBXwItl1pwGi8D35WIa3Ye4PuZpssz1mXPpJSlRVXsmfUk+9Y1zRWhesfs4ZjhLSeqlphR0zRG9MJoBTddLjW4CFr2HuCbfE3TmrGjRJjgrPY8Y4E+YwCinu9CzCmkAJmigT8EFX+ePYKONmdjN0jups1QPBT+NQHZu1ScWOhPLVzTGjqDT1C++g8bFQ4eou6Sv+w6DRE/Nq6BfchOyVUpv8ZnM9g/RaiCAw0vFA+lN+gJzb/UwVPE5LvvP7RGwy4FcoWnRNb8OZKevKFTd8rjqhQAfyd9z1D+mvdd1z1MXObJB3iC47rlYQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7ce6ba-7610-4614-0a84-08d862bc715a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2020 08:07:56.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wtlg22OnY1hP0Ovc/eoHFd/LDg79myKKyTz5cggsTgwcMLjTjQSMHmTfK2lig62XKAKFemcB1cdR3EBLabfNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flexcan driver for i.MX8MP, which supports CAN FD and ECC.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* sort the order of the quirks by their value.
---
 drivers/net/can/flexcan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index aca0fc40ae9b..4844dbf77c9c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -214,6 +214,7 @@
  *   MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no
  *   MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no
  *   MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes
+ *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
  * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
@@ -410,6 +411,13 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 		FLEXCAN_QUIRK_SUPPORT_FD,
 };
 
+static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
+	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
+		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_SUPPORT_FD,
+};
+
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
@@ -1912,6 +1920,7 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx8qm-flexcan", .data = &fsl_imx8qm_devtype_data, },
+	{ .compatible = "fsl,imx8mp-flexcan", .data = &fsl_imx8mp_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,imx53-flexcan", .data = &fsl_imx25_devtype_data, },
-- 
2.17.1

