Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3211506C4
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 14:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgBCNSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 08:18:22 -0500
Received: from mail-eopbgr750077.outbound.protection.outlook.com ([40.107.75.77]:2478
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727358AbgBCNSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 08:18:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhGBZMIZGOcl156g7T17ZYJ2kYQN/3XV/vR+AJJMAmx4Ew1XeAC8iXNyEkPJv5EFjcaDwOLLXfgN7fE4wAoWaeSyT1umXtQrHj6/6L2duqPYDX5JMRAu4B2NFfo3+rTyc5QRk1qcLkbz36uFK1JSn7Vto0m4A5sSg/HkUN2Nu4+Z6YsWpSkJOTeA4AFrLD3QCICon9L24J1moCs8iEpbVCh1tilgOLUs2DaaaLnjT3VYGTpeqjmTNBmQO0iuLsbIlsG9bPqByecgBoXoTlKX4euL6qrTpRMoTvi3VfCjT0q3kwZ+Qh0LNcOIQi+yVCI5Glgfvl202HkXaewMn8FmbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P87ZOiQn4QqnpAITcE/bN7GI+tVlmise4JjWEaatQjI=;
 b=kplts0WvrfXHn/S8mCpMN2P0BUcsL8XpCBoWWnlJtC47u3Ymbq1o7GTOKyCiQLoFXCQ40wmHV4hyh21meKdgn9wD8n44JG3VzUp2p5KP/oKdZvP4ShmI24e4TAl33kViKqs0TUKfUn1W7z80Bc/pi3orIPwsF0hP3s8+otU9SYTiLWEt8iBqV7eoRc3LpXqHPdXWjceiEjGU8xMVj12YmhL7SGjzlJXNSetb04stCGcVuv2oIKWoS1oPEyUwpt4Au7xABPVEH1T1pq/AzZn+H+rOMZyhJy1sgP5UDOFeixs5BIETR7G0unDrnowNi7gYr87fMOFfJZFCSf64DAgFpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P87ZOiQn4QqnpAITcE/bN7GI+tVlmise4JjWEaatQjI=;
 b=TjY2yDaJE3JZUhU9M5GVilz2ZWbg3+P+AImChrkQIhkr23kae3LLC8AW+apMe9geVrDViMXZeBOo7brc/29dZrlcQvVrg7FS/bY5asHw4imzEJZVzZbawUYciVXqOup/Gyk0Ksn5eABYVlLM8opfpdAVZ6cgrmFKIVpNCB9kT50=
Received: from DM6PR02CA0101.namprd02.prod.outlook.com (2603:10b6:5:1f4::42)
 by BN6PR02MB3265.namprd02.prod.outlook.com (2603:10b6:405:62::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29; Mon, 3 Feb
 2020 13:18:19 +0000
Received: from BL2NAM02FT043.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::203) by DM6PR02CA0101.outlook.office365.com
 (2603:10b6:5:1f4::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend
 Transport; Mon, 3 Feb 2020 13:18:18 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT043.mail.protection.outlook.com (10.152.77.95) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Mon, 3 Feb 2020 13:18:18 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcI-0003Fg-0y; Mon, 03 Feb 2020 05:18:18 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcC-0002w8-T8; Mon, 03 Feb 2020 05:18:12 -0800
Received: from xsj-pvapsmtp01 (smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 013DIBY8003814;
        Mon, 3 Feb 2020 05:18:12 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1iybcB-0002t1-Cz; Mon, 03 Feb 2020 05:18:11 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH v2 2/2] net: macb: Limit maximum GEM TX length in TSO
Date:   Mon,  3 Feb 2020 18:48:02 +0530
Message-Id: <1580735882-7429-3-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
References: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(189003)(199004)(36756003)(6666004)(356004)(44832011)(426003)(2616005)(5660300002)(7696005)(336012)(70586007)(70206006)(186003)(26005)(4326008)(107886003)(316002)(2906002)(478600001)(8936002)(9786002)(8676002)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB3265;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a1cf9ce-d2ec-4a8a-828a-08d7a8ab8909
X-MS-TrafficTypeDiagnostic: BN6PR02MB3265:
X-Microsoft-Antispam-PRVS: <BN6PR02MB3265A2588F0E5CC9E932CBBEC9000@BN6PR02MB3265.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0302D4F392
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: deKy75hinOzLTttYd9v7+YX2dfFdrWGsLVF8bIaaZR/o88KU2w4CfaX1rFmTi3yNN+cJY5Zo0mhGfjwYzqf0JuL735xntg831O/ST5/RU2yrjyjKFngLxKZX4ja7FX2VH0QP971vN19ccJJwQpiFEBaSId3dLeoTqs6OL6kDwpqjF85ZExuQNE9Sag+cdF35olqGs1Zj4eX/L7WCy7mwsZ1weLVY7BdXueldJdzoWiKTP1Y+kQ+9aCZtZHNUi4jgY7lJR2bHZ6gGhoC6S7rlwFnX3jsCuCRzhYCQf/NV15cs/6GM2IAP3i8IGNLs6375qZD+77q3rBAfxIRFfkC9nBlg0wMimmy1+ERMFiTb/9WxFNBAW6kRqXHfebv2eZrNbWcyV94JhZEG55+mGZEoGD3qCr6yZ3b0hr6XqD53RljsZS5C+S2ukYp42Zon4IAW
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 13:18:18.6418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1cf9ce-d2ec-4a8a-828a-08d7a8ab8909
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB3265
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GEM_MAX_TX_LEN currently resolves to 0x3FF8 for any IP version supporting
TSO with full 14bits of length field in payload descriptor. But an IP
errata causes false amba_error (bit 6 of ISR) when length in payload
descriptors is specified above 16387. The error occurs because the DMA
falsely concludes that there is not enough space in SRAM for incoming
payload. These errors were observed continuously under stress of large
packets using iperf on a version where SRAM was 16K for each queue. This
errata will be documented shortly and affects all versions since TSO
functionality was added. Hence limit the max length to 0x3FC0 (rounded).

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
v2:
Use 0x3FC0 by default

 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 2e418b8..cca321c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -73,7 +73,7 @@ struct sifive_fu540_macb_mgmt {
 /* Max length of transmit frame must be a multiple of 8 bytes */
 #define MACB_TX_LEN_ALIGN	8
 #define MACB_MAX_TX_LEN		((unsigned int)((1 << MACB_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
-#define GEM_MAX_TX_LEN		((unsigned int)((1 << GEM_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
+#define GEM_MAX_TX_LEN		(unsigned int)(0x3FC0)
 
 #define GEM_MTU_MIN_SIZE	ETH_MIN_MTU
 #define MACB_NETIF_LSO		NETIF_F_TSO
-- 
2.7.4

