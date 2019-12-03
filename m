Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B1310FC41
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 12:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLCLNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 06:13:04 -0500
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:33749
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbfLCLNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 06:13:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDy9tLy7htd0iLVXI2nT9Vth/iCryBSluBWLsixPNi+UZFvr6O+zOySpaUIo+e+AhV5sQzyatDJXaWLkGG5RhYjnmEYtQ+Ttg+l7aKuQMWRlxsGOukJ53COOpWYKZHIRfqE6nn3uoBWlsVh0iv8NobP25a7jDrVp0DCbVtwIn7n2SpbZ11jdpebP2m4OJ5Yq4lAdrv/DixUq6rvmr0lO2EXE9U32T+Zp+LqYktJ+FbWw+VHn87VhTPApwzYgx4c+8qJWZodgdP41oFxSwa3C9/+MaZzWDrqJ8m5QpmXu7wZZj03tX86v+u4JeM/FNVHFvnlB3Av1r7M/LFgoiYy3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PghPG/WOgHq98k92wlVS7DW6YKMERHO0oIyNnO2uaA=;
 b=TtSFwO0KcKLPlP6qasl4UP4WUGbE9h0tXXX97EtW1dfHXES0WpOi1cWyL7Oa6A02ub37LA0RQN04nEhWU9beflMTrdk9kDTsp1wmpV6leI5p1xnkSxGoo16zELwkOjDfc5UDCkSmrNLw6NoYG3H5QiZpvTt4kmN16mwKS/UsSk+VYnCVkK3/Uh0Lnunzv1tIzj8+DaNLYyeHiDDwuVJFV8t3DPC/+t9HlpnbR3fCMkywlp7a+YzqNYPOrTC6EOpFroKbbyHoyBH1c5PYFDwz54iPRc28f41BfKxeEFpIqsrevIqWfjuSy6EfqQWqIGtYvKG5lAAM08+hlztr/JVzCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PghPG/WOgHq98k92wlVS7DW6YKMERHO0oIyNnO2uaA=;
 b=QpzpqVUBUv4BEDyty4KTJ+99ZojXHwtsycHBvOjjsrBaO2lYYTXptTL5qtk8hhHr+/WFcscKNwMQvwhrAMiYogt+s1E7PQFWNWZnNCIJ4JjuwlWjGkEkJ5pM8b+Qx+PebIheubE+D/bpGPlNbe5GJ+G96e5GluyoRO7QP7uH+wM=
Received: from BL0PR02CA0038.namprd02.prod.outlook.com (2603:10b6:207:3d::15)
 by CH2PR02MB7094.namprd02.prod.outlook.com (2603:10b6:610:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.20; Tue, 3 Dec
 2019 11:12:21 +0000
Received: from SN1NAM02FT035.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by BL0PR02CA0038.outlook.office365.com
 (2603:10b6:207:3d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Tue, 3 Dec 2019 11:12:21 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT035.mail.protection.outlook.com (10.152.72.145) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2474.17
 via Frontend Transport; Tue, 3 Dec 2019 11:12:20 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1ic66O-0005t0-4A; Tue, 03 Dec 2019 03:12:20 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1ic66J-0007xX-1J; Tue, 03 Dec 2019 03:12:15 -0800
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xB3BC8WU020864;
        Tue, 3 Dec 2019 03:12:08 -0800
Received: from [10.140.6.6] (helo=xhdappanad40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1ic66B-0007vg-OO; Tue, 03 Dec 2019 03:12:08 -0800
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        michal.simek@xilinx.com, appanad@xilinx.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, nagasure@xilinx.com,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH] can: xilinx_can: Fix missing Rx can packets on CANFD2.0
Date:   Tue,  3 Dec 2019 16:42:02 +0530
Message-Id: <1575371522-3030-1-git-send-email-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(346002)(199004)(189003)(36386004)(50226002)(8936002)(16586007)(36756003)(6636002)(6666004)(356004)(50466002)(9786002)(48376002)(106002)(316002)(478600001)(81166006)(336012)(8676002)(5660300002)(2906002)(81156014)(107886003)(305945005)(7696005)(51416003)(26005)(44832011)(70586007)(2616005)(70206006)(4326008)(186003)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB7094;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5815e2f4-ba1c-49b6-4dda-08d777e1aa86
X-MS-TrafficTypeDiagnostic: CH2PR02MB7094:
X-Microsoft-Antispam-PRVS: <CH2PR02MB7094D457DDAB7D19FE2AD217AF420@CH2PR02MB7094.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 02408926C4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJPM9Fm0KNS6qC8b+01O6F6qY4VxviFR/2limORUHztSQkFx12ZGPfyyAfesAQPsD2+dnrmjIo6dxt9CkBtTH+nIPUZV8dBJ9cBS4jU2xoii9l2pnhoL2wGmaTO8hPT+7slezajU/sRS2D0quHeLwlYfOLngrrZTIyfPIbiJ6A1lQINgkHjIac9SOCns3uWxlB2Q5aVU0EaR4NImBl0t96/BGq2pk4qwzZkLA+XIt3C7p4Dv8CtaAOVToA8boT/Ih3u//1Gn7KP9PihVMMFzCERkfWT/mgRjvhlTdt/FSCWkq5ZCeU6qsrEslTHIFv/BFMrszRdPNW9NydCjjNkEjPhZy9WCTVFjSlatr7b7DLOP01ZhEdWWDmM249JBgNQHWleF62qyzTZpYwNDnJ3QaDVn1gHuw0sO/4H52vKxVJgJ2raaDXhqk7ZBHBdH1Mlj
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 11:12:20.7369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5815e2f4-ba1c-49b6-4dda-08d777e1aa86
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CANFD2.0 core uses BRAM for storing acceptance filter ID(AFID) and MASK
(AFMASK)registers. So by default AFID and AFMASK registers contain random
data. Due to random data, not able to receive all CAN ids.

Initializing AFID and AFMASK registers with Zero before enabling
acceptance filter to receive all packets irrespective of ID and Mask.

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Reviewed-by: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
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

