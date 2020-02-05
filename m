Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D94D1530E8
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgBEMii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:38:38 -0500
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:34752
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbgBEMih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 07:38:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUMwJOpnYo6Ygxf47pILjvp+HWHFRzOlOC788BOyZYWQqEdOpbassa+kZ8EaKBKN0E9WKQqnvQ23YY6tqkJ5f6Rs3QZT5B+DVC3pkQkkJHoGuvAwh25ap+KN9NA1dCqoO5wmbldywlDFjsyMuYl3K+L+Wivb3y+yH7mElSChGFrljtSPbnAL1M4RYKZR+PZ4Lvup9VDXV99lqth5nhT44YydUs+O4OYnloCpogroZ/QUOU+krUetbQu9pKju3U3c5QXsVpE7RW45cFgst3BaOs11SsRk5nuGPa6G7wUfjx7p00TFv8q977UE3AU8yfJu9H2V5M51zm5jtUlnE7tKwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVolbEsDBmrOiytV+26+1A7hbjQulAqJZqhdLWNdOOw=;
 b=PkZiqDRzX2YaGVV6/AxwH8XkbdZgiVE/N8SyTLRFuZNH8g9mX1mSxwX6FHwImNTzp7TRVhFv8FfIsBj9wq9Vm279iWzcO/A7RdevQGLQ8Hu4I8YRBGQepgT2DxHkRZhyapEfRU/VY/PZHRT9p2X/powzB40KRE4QJVmDK6PxBG9Ogx6kMQOXShgaR+AzzWrZj7KW25PfuSz1z5aIl+ann5no1oAgvdQdBIDggs1cB7RGyPYHphvnQbv4rlOz+38Whx84GXGJ2FRFCEVKSSYbi6f30XI4SnurtIoq1+qwswe2n0yYtUOHcFfRxz3EXlH7JMYB2FafNlsdsdsT+FUBAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVolbEsDBmrOiytV+26+1A7hbjQulAqJZqhdLWNdOOw=;
 b=U/3a0jo2W7KbjPLlJ36R5xMC1LaQQenywU0dW2zNbrIAKETQiyCoRfVYSGE7s/1qU+Vie1uSIBam8n161FM6nRHSutAETpViTwl7GMgnCOHY44XLPBHH5CrNpTVqH3/eJ/5gd5t4eDKSnt4opHTS2GXTrsTCWifrwS37xUD0G3E=
Received: from CH2PR02CA0016.namprd02.prod.outlook.com (2603:10b6:610:4e::26)
 by BN8PR02MB6003.namprd02.prod.outlook.com (2603:10b6:408:ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27; Wed, 5 Feb
 2020 12:38:34 +0000
Received: from CY1NAM02FT047.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::208) by CH2PR02CA0016.outlook.office365.com
 (2603:10b6:610:4e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend
 Transport; Wed, 5 Feb 2020 12:38:34 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT047.mail.protection.outlook.com (10.152.74.177) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2707.21
 via Frontend Transport; Wed, 5 Feb 2020 12:38:34 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJww-0001x0-0g; Wed, 05 Feb 2020 04:38:34 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwq-0007wV-Rz; Wed, 05 Feb 2020 04:38:28 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 015CcLMG009614;
        Wed, 5 Feb 2020 04:38:22 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwj-0007uq-Cb; Wed, 05 Feb 2020 04:38:21 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH v3 2/2] net: macb: Limit maximum GEM TX length in TSO
Date:   Wed,  5 Feb 2020 18:08:12 +0530
Message-Id: <1580906292-19445-3-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
References: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(136003)(396003)(199004)(189003)(356004)(8936002)(44832011)(36756003)(7696005)(6666004)(2906002)(81166006)(9786002)(426003)(107886003)(2616005)(8676002)(336012)(316002)(186003)(4326008)(26005)(81156014)(70206006)(70586007)(478600001)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR02MB6003;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdec6f6f-b789-4998-bb45-08d7aa3850c5
X-MS-TrafficTypeDiagnostic: BN8PR02MB6003:
X-Microsoft-Antispam-PRVS: <BN8PR02MB60033DA5C87816D3632DAA04C9020@BN8PR02MB6003.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0304E36CA3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9jwK8KQCsGLfPjtG/34oa9uA8+Rovx4rgz5tIEwonq7EX6VyJxGJqCbN2lb1rkBB0fua6OZ8D9Ra5OzSYyrXhpVUKP9yMtB1QTfUS/Nk6egauyFLh91jq+W++7qKNEGKzBuEKY9WjvVrBuZ1D/+e2Sg7RN6MFdy2wTGQduYlJpXtzVJDP0iWmPJxSFNkh05akbn304IJcOSfPKN7xO57KZHtyEOcUU8uPbWuorLpNOPNOkc6Z8i3Eq0Bg0yQQJ49gT7oC1W4sDi5BWpKSOfSrOOyR1vgiNKH91hSzU22ygLsecwAcuDK6/ftpiL3jicyvyLX+Kk34bJe7mY86zrGwId9eRYYXRwlODOe7UgrrJt71d6Y+RcWSKTBb/WJg487USbXHQNPhXls1s3Vq6oMBWQ29CDtx5eDabGz27oqFNAWorU3MVSQe/80xmOBkvm
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 12:38:34.4959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdec6f6f-b789-4998-bb45-08d7aa3850c5
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR02MB6003
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
v3:
Add comment
v2:
Use 0x3FC0 by default

 drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1131192..4508f0d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -73,7 +73,11 @@ struct sifive_fu540_macb_mgmt {
 /* Max length of transmit frame must be a multiple of 8 bytes */
 #define MACB_TX_LEN_ALIGN	8
 #define MACB_MAX_TX_LEN		((unsigned int)((1 << MACB_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
-#define GEM_MAX_TX_LEN		((unsigned int)((1 << GEM_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
+/* Limit maximum TX length as per Cadence TSO errata. This is to avoid a
+ * false amba_error in TX path from the DMA assuming there is not enough
+ * space in the SRAM (16KB) even when there is.
+ */
+#define GEM_MAX_TX_LEN		(unsigned int)(0x3FC0)
 
 #define GEM_MTU_MIN_SIZE	ETH_MIN_MTU
 #define MACB_NETIF_LSO		NETIF_F_TSO
-- 
2.7.4

