Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586AF4ADE30
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382927AbiBHQVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242890AbiBHQVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:21:13 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E47C061576;
        Tue,  8 Feb 2022 08:21:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgfE+bYbFTTsxBr9nepR/X8C6jsiioi/2wVztZDTFBbK1JR5Yp8skm5RXGwjigdGlEsDxuHjWNuh54XIpYxhoWXwx1gV75RmwJfKWMFKOsUY6+iGLwbFbonYLzeup8bHwD16AjEkGJMSBH1a9VVXSXZpOziypOLVckCe8dVaj3Dmre32EzfXmR1MxDDhhfZsz/FFNS5Qj8MUikncteMYix5efyN8ZdT7ybqDMccLmUmL/ee/WKKOq2JMqK7naOqisX2qH8H7QNuFNi5rM7w0s6wK462Uzzzx1MDf5iIFZUQIJkRPmh9kMA0DfclDLZIJVYlsItON3153OwTYKu3JSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KV77AyTYrq1N3BVVXWddRdBtpYm6pxa59m07DcnRDkI=;
 b=TsNKswBdl85+sg7VlnG0ckhQz/6emv7yszVhjVA+mzYm4U/L8MZz8RGHDg+Bajjf90Hl5RhohRnIyNF+ZGp4xarKw5sWpwk04bK4Y7bLlXJmZ8LKhtCvRcv/qQvMWcTgxULu1ZCIe6NzkkQyWarJsLqVxJUV3dZ8cnH8o0WK+31bpGhUjmLRslIbJQLucIhxG48gpxolgVweHfK918LuQCGS3f8S2KUrAbQWRbs3nyzy/WtettQF79KKtphm+WNud84Dqqn6lJIbwiziff0eW4BXSDOMNvgHMYOo6tOG+9jF8tlmGB8n6Hhbx6QMwGArcW1d1Mzk+dFsQY/sSOL7rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KV77AyTYrq1N3BVVXWddRdBtpYm6pxa59m07DcnRDkI=;
 b=BTjlklLRxQrW0hdLRDiKzLS2/VsaFyosEMsTILXpqF0ajFMtknhL0+558kUAHFdW1ej4TET6jYMpjFCWJ6FKw7+tIhH3+De28rBlhDWJduQIrdiGE7pCkUT+uSu9m2ug038CPV2GAMhRxaZWcDpZmO6e3v/QMuZf83E/4UaGiKM=
Received: from BN9PR03CA0987.namprd03.prod.outlook.com (2603:10b6:408:109::32)
 by BY5PR02MB6180.namprd02.prod.outlook.com (2603:10b6:a03:1fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 8 Feb
 2022 16:21:10 +0000
Received: from BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::41) by BN9PR03CA0987.outlook.office365.com
 (2603:10b6:408:109::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 16:21:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT031.mail.protection.outlook.com (10.13.2.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 16:21:09 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 8 Feb 2022 08:21:02 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 8 Feb 2022 08:21:02 -0800
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [172.23.66.193] (port=57446 helo=xhdsneeli40u.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nHTEj-0007jF-Dk; Tue, 08 Feb 2022 08:21:01 -0800
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <michal.simek@xilinx.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Date:   Tue, 8 Feb 2022 21:50:53 +0530
Message-ID: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47bc9d20-cab7-4cee-0889-08d9eb1f047c
X-MS-TrafficTypeDiagnostic: BY5PR02MB6180:EE_
X-Microsoft-Antispam-PRVS: <BY5PR02MB6180E94838D4D4856FF9416BAF2D9@BY5PR02MB6180.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKCsIs7f0v+QjhgdFrHuJcD6lYk5o62m93I48Qx27bsrgVorn9XRkcuUSljDqbdQAnabDbXmS/VGCd7iQu8VmhMJmk6ZRcylhTUbDWFzOrmtMY46vBaMB7YCNTjsAn2JoHzxW5msQ4L30XhfvEKCzeWx3cxnhBoqg1TYiFxt4+uXUYwMZdnuZVhH5tm+lrZ+Ws4E658kIo9mBx6l5mL/Q0KYv/bcRaSfGxLTvF7uNdTAR6kNFpdNIj04dXnLeEzxhl5SRwPAmsizRENmRw+pU+P2iI1k/IltuuTkn3cIiRo/BQyot7psFoyJdAmmq5v0z/nBs+1Wo5tpoQcxS0FUwyEQipWzvYPbDjIFOrL8dOnoZA+Dq37Z5v8XtTQ1VNzLACUygxqX/9ZrI7yK/Zt/EUky1qCpGMsboJOS9RwNgbi95P+PKPvNf01cdu8WuAKT6PzkXhOJZsHGHjN1EtePkFz/eopxNvTR2nI6EcRzV7q00dLb7+Qy2Xa8XZ+O4g2aCuuXeN1VU1Qg6OsBkPyYD7L690qtxCFKk4V9ds+2gxh+jVbasCSdy1GcvFIeGKTmHHxvgWLsEp0/R0sU8rZ68IfX+0KkN3TkSatCKuzDalTl8g3OZtPOq5OzdhUL67bhBgwc2ubcGwGzv9uRt8IcrpdL/owKN/m6jMaPXJ0Rofk=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(316002)(508600001)(54906003)(7696005)(6666004)(36756003)(110136005)(82310400004)(107886003)(186003)(26005)(426003)(336012)(8676002)(2906002)(47076005)(8936002)(4326008)(1076003)(2616005)(70586007)(36860700001)(5660300002)(356005)(9786002)(70206006)(83380400001)(4744005)(44832011)(7636003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:21:09.9980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bc9d20-cab7-4cee-0889-08d9eb1f047c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6180
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add check for NAPI poll function to avoid enabling interrupts
with out completing the NAPI call.

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 1674b561c9a2..e562c5ab1149 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1215,10 +1215,11 @@ static int xcan_rx_poll(struct napi_struct *napi, int quota)
 	}
 
 	if (work_done < quota) {
-		napi_complete_done(napi, work_done);
-		ier = priv->read_reg(priv, XCAN_IER_OFFSET);
-		ier |= xcan_rx_int_mask(priv);
-		priv->write_reg(priv, XCAN_IER_OFFSET, ier);
+		if (napi_complete_done(napi, work_done)) {
+			ier = priv->read_reg(priv, XCAN_IER_OFFSET);
+			ier |= xcan_rx_int_mask(priv);
+			priv->write_reg(priv, XCAN_IER_OFFSET, ier);
+		}
 	}
 	return work_done;
 }
-- 
2.17.1

