Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A548510FD7D
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 13:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfLCMRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 07:17:42 -0500
Received: from mail-eopbgr740085.outbound.protection.outlook.com ([40.107.74.85]:35990
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725907AbfLCMRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 07:17:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPiacHwhjhyvwDrf47lgcbGWyduJgalPV9KwSO2ZixMkfaneKt5zHGKimwPuevLasvONOj73kass1M6qMXYk8mAvyTlQSj1ZtU1WlU6yKQ1B8d6HBAroDKtxr4SNuY2cbT++PFDUACZoO0bLToiy9dBR7WIo8o6vEwZRoqNgYL3Gupa7JHFz+T+OumMzRSRNvzKNw68HsP+amA/KvsPiRMZmtuQYnaGBp87Qnb0df+kVJCCtBkBsoSoVCmwLCcrk++0LEeDtGlF0KI2QyliXcJ+mSjZza2Uv08HKUHXmMkLLgfc6FT5BLF0UbPPWktZCRdERQQgypTLBnyWPbZXEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bC/DBH+Fsqt9IFQLULfciwewb1aPMv738DvhiWhzDc=;
 b=T88Avg77KjzAIBM4cBJPONjs96Jb0sIaidGbs1zamOvnG0Jyr2+gk6SivAV/Tpoqm9hebE/Yj42mqkYL1m2noPbAXDWRocVrv7/UOVfWNyL/7tYqb61UVbAZ9RaDZYCgqUOZPhIdUGataVCaAQVIaBMXODO/d48jkmN3BJlE0KyiSzaxGMrhCd6eeG2iHab0eKmbImxQ5N0/bfzj5iy0mucFW7oETUjLhrz4fFK4VLlxIaN3cAlYEIMS59XVqdtb/j0HdGtNOZz8NGJrHQXlBWIWQofOW210KLSUoCeQOJUy0rblAZCXQ2YQTsV5CAuLHBazrXEnA9OPHqAdk1Ur9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bC/DBH+Fsqt9IFQLULfciwewb1aPMv738DvhiWhzDc=;
 b=qtgHH97nrT07HFCbnV/BMWld+yBjCNd98uTd/Eb6adfiZ7rlli3tGEyLxUrgxXpCG5fZn7vuLg8EQZv7T/2hIqcrl4yJEoSHxMWcvFw0veZ/H9YmA+XQXB5VlpwUsbhb9GP4mN4F/JL8SGY6EVB8nCMIEz6+hBUbMHlgPf40s+M=
Received: from SN6PR02CA0009.namprd02.prod.outlook.com (2603:10b6:805:a2::22)
 by DM6PR02MB4779.namprd02.prod.outlook.com (2603:10b6:5:16::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.22; Tue, 3 Dec
 2019 12:16:56 +0000
Received: from CY1NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by SN6PR02CA0009.outlook.office365.com
 (2603:10b6:805:a2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.18 via Frontend
 Transport; Tue, 3 Dec 2019 12:16:56 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT014.mail.protection.outlook.com (10.152.75.142) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Tue, 3 Dec 2019 12:16:55 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1ic76t-0006qd-EU; Tue, 03 Dec 2019 04:16:55 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1ic76o-0006DO-Aw; Tue, 03 Dec 2019 04:16:50 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xB3CGfvb025018;
        Tue, 3 Dec 2019 04:16:41 -0800
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1ic76f-0006CV-4p; Tue, 03 Dec 2019 04:16:41 -0800
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com, appanad@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, nagasure@xilinx.com,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V2] can: xilinx_can: Fix missing Rx can packets on CANFD2.0
Date:   Tue,  3 Dec 2019 17:46:36 +0530
Message-Id: <1575375396-3403-1-git-send-email-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(136003)(189003)(199004)(356004)(7696005)(70586007)(51416003)(50226002)(81156014)(336012)(5660300002)(316002)(6666004)(186003)(2616005)(26005)(8676002)(16586007)(70206006)(8936002)(81166006)(426003)(305945005)(44832011)(107886003)(106002)(9786002)(6636002)(48376002)(4326008)(50466002)(36756003)(36386004)(2906002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB4779;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21c6aa24-7193-491a-6511-08d777eab051
X-MS-TrafficTypeDiagnostic: DM6PR02MB4779:
X-Microsoft-Antispam-PRVS: <DM6PR02MB47793B736800DA643558DD81AF420@DM6PR02MB4779.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 02408926C4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iyq/kJnNGjkrPIa/KQlIA5eAf/mtyN3JvzqXwIGkN8HQbir3StVJRrlZ7FOzkcTFWPMwisL6yIKWqK/ewdLTt2alirq0lkv19QYtGbYZzG5lAnD1fAqUyaFEfp6bma0RLT6zxu2rOPjnKAAB4UMhHrn+K4kKuTWqikyu4Tmvlesz1EE/JlwSpPrIBGMMs7qBJg0j9ldRZ3J8sB/1ds5XgQhlcXfYbGbwg/1801EDfND3+S6iwBuqxLIATIJtxCuDYNlUh9DGkL4AsiFrSqY9lCsd9uritcWCCEC5l8JoXudCVj0xY77j33fawCPvMbTbxqJ5JfcPiDqQ5e93Hn3Rr+A/s7BkSN+V8frJVWc/M8qwB5Bg74FFM3FKKvUpJZEsrU4NQlNT0bku9+xdXdwWkDag2Gkw2TVGojl571gnUZz7yb/VNTS1MFWT3Kj47xKY
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 12:16:55.9090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c6aa24-7193-491a-6511-08d777eab051
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CANFD2.0 core uses BRAM for storing acceptance filter ID(AFID) and MASK
(AFMASK)registers. So by default AFID and AFMASK registers contain random
data. Due to random data, we are not able to receive all CAN ids.

Initializing AFID and AFMASK registers with Zero before enabling
acceptance filter to receive all packets irrespective of ID and Mask.

Fixes: 0db9071353a0 ("can: xilinx: add can 2.0 support")
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 464af939cd8a..c1dbab8c896d 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -60,6 +60,8 @@ enum xcan_reg {
 	XCAN_TXMSG_BASE_OFFSET	= 0x0100, /* TX Message Space */
 	XCAN_RXMSG_BASE_OFFSET	= 0x1100, /* RX Message Space */
 	XCAN_RXMSG_2_BASE_OFFSET	= 0x2100, /* RX Message Space */
+	XCAN_AFR_2_MASK_OFFSET	= 0x0A00, /* Acceptance Filter MASK */
+	XCAN_AFR_2_ID_OFFSET	= 0x0A04, /* Acceptance Filter ID */
 };
 
 #define XCAN_FRAME_ID_OFFSET(frame_base)	((frame_base) + 0x00)
@@ -1809,6 +1811,11 @@ static int xcan_probe(struct platform_device *pdev)
 
 	pm_runtime_put(&pdev->dev);
 
+	if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
+		priv->write_reg(priv, XCAN_AFR_2_ID_OFFSET, 0x00000000);
+		priv->write_reg(priv, XCAN_AFR_2_MASK_OFFSET, 0x00000000);
+	}
+
 	netdev_dbg(ndev, "reg_base=0x%p irq=%d clock=%d, tx buffers: actual %d, using %d\n",
 		   priv->reg_base, ndev->irq, priv->can.clock.freq,
 		   hw_tx_max, priv->tx_max);
-- 
2.7.4

