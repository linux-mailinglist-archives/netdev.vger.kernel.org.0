Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F18B14EA9B
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 11:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgAaK14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 05:27:56 -0500
Received: from mail-mw2nam12on2082.outbound.protection.outlook.com ([40.107.244.82]:6045
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728071AbgAaK1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 05:27:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJVJ/GI08Y/H90HjKcwZ7PDzlIfVe42SdWtzAiKsxpIXthTuxa4ztamhSOYZIUye0HPWp0mDbNrfYya2a1LRMGB+n8l+aw2UG4yz0/GlRJlU+Cche1knpfSIPttC2Loxo86h7gqt1+1vxf2dCRvrGBAnqa8nDHsDcTP22chPgCxoJmUOCjs/6UjdHMBYcDK7KEraD/kkSYOrBoz0e8b1ydFv+xddmS1J9o0z4XTLENJGQaUyPLQKIrAcsJqyDxyy7doLcduwMttnpB2fqqk97wFq+sxgZPPkuuyZnEEdShvINucL69B1A3fiMuQkZUfuhtSCRp/rqbdqfCsE7eqquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXa/a1UOGlzhCQFaL21hg574FCemBEOlp4DEFMkKLfU=;
 b=kUe35TQlxmYbm+HQVnab1SI3hjKyFhC5t2CPGriz3lX3Zq639gwoBvgiyZmwcTYNOIEFPPQhD2lyeAvNH6KsBj1N6zuULdETTZlQU/1FckzNv09PCZM3Hk+QZcJdCeCDoB2jJW9w9ys9WGlh8ikrAWFpve8Wtny3HVkxBMDGAF32EpZgCBYCuJPI6E/aLboBcMI4yZRGMH5ckUz+cyzXzSYPMWUZ5cXXgESYPeiA+/jyIyN840/CaVtbDourrxk46sjVedYJpm/FheB32qBJwn2Cr83EanWGGSPNabAKtNMhM0ZYeKc7plfNOEy7qiBJHApViA85KbOkCN4ckauySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXa/a1UOGlzhCQFaL21hg574FCemBEOlp4DEFMkKLfU=;
 b=AypjIULUQi7DqcZZKH0eMXMzbMVIlSVfKnT/biclTI5AhmA21EgLVyrutbH9ojoFRW8qh1HTMhNFlW1s3gjB/RFRMswuBeeBx6Ygv7NfwvrMBG/cxporhOHvvUPddAjGLpTK5UvxskIRZ5mZ9Rc8fl5PHuxzjju6HsuDM/rXO+A=
Received: from CH2PR02CA0006.namprd02.prod.outlook.com (2603:10b6:610:4e::16)
 by BL0PR02MB5635.namprd02.prod.outlook.com (2603:10b6:208:82::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19; Fri, 31 Jan
 2020 10:27:52 +0000
Received: from SN1NAM02FT051.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::205) by CH2PR02CA0006.outlook.office365.com
 (2603:10b6:610:4e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27 via Frontend
 Transport; Fri, 31 Jan 2020 10:27:52 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT051.mail.protection.outlook.com (10.152.73.103) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 10:27:51 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWh-0003vA-CF; Fri, 31 Jan 2020 02:27:51 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWc-0007is-8d; Fri, 31 Jan 2020 02:27:46 -0800
Received: from xsj-pvapsmtp01 (mailman.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VARiGU028033;
        Fri, 31 Jan 2020 02:27:44 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWZ-0007h3-IN; Fri, 31 Jan 2020 02:27:43 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH 2/2] net: macb: Limit maximum GEM TX length in TSO
Date:   Fri, 31 Jan 2020 15:57:35 +0530
Message-Id: <1580466455-27288-3-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
References: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(199004)(189003)(81156014)(81166006)(8936002)(70206006)(70586007)(7696005)(4326008)(36756003)(107886003)(478600001)(6666004)(356004)(2616005)(336012)(426003)(44832011)(186003)(26005)(2906002)(9786002)(316002)(8676002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB5635;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfbfc652-2846-430c-3f50-08d7a6383a0c
X-MS-TrafficTypeDiagnostic: BL0PR02MB5635:
X-Microsoft-Antispam-PRVS: <BL0PR02MB563578258F59CFAF0DC377B4C9070@BL0PR02MB5635.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2BXFJU7LsOCYoOLb3FsQsAwHnTqkwTf5R0O1a1f/vYyBuROPezJn4/BUyCUeKQyTBYXnEQSww6QVtqDQiLF7NvZN0/57iTDdillWmwoddUxOh3fRyyK8RKFLYU1VjK1Mu/pSNF5h5wgZPWc9ilBMGmhFosES1ej8iEnXvl5lOFpWCQeVXLCESZT92k2dUdAoI3tTQ1acjpOIpOHP4aGBk2jkzuH2a4nDuCGm8G2CVJETdWjuB3HRBAuADTWEHu56GfDqzgEXDdLwm/dxrYhRSkoUxlMp9Z9TRQWOj31Vr76sYghpYBFQhFfxz2Fdtvb3RVrSmj5YoU4/fEUPt2opp7nX/Kpq659yFyxm0+3ZQkyaKGhdmM7weEpzZgm4nP3Kp6yDM+LBmXypV4gYnxFLibh531thZM2mMakPXY/MQvX+/Y6x+Iq/i+188MxZTF2
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 10:27:51.7344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfbfc652-2846-430c-3f50-08d7a6383a0c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5635
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
 drivers/net/ethernet/cadence/macb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 2e418b8..994fe67 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -74,6 +74,7 @@ struct sifive_fu540_macb_mgmt {
 #define MACB_TX_LEN_ALIGN	8
 #define MACB_MAX_TX_LEN		((unsigned int)((1 << MACB_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
 #define GEM_MAX_TX_LEN		((unsigned int)((1 << GEM_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
+#define GEM_MAX_TX_LEN_ERRATA	(unsigned int)(0x3FC0)
 
 #define GEM_MTU_MIN_SIZE	ETH_MIN_MTU
 #define MACB_NETIF_LSO		NETIF_F_TSO
@@ -3640,7 +3641,7 @@ static int macb_init(struct platform_device *pdev)
 
 	/* setup appropriated routines according to adapter type */
 	if (macb_is_gem(bp)) {
-		bp->max_tx_length = GEM_MAX_TX_LEN;
+		bp->max_tx_length = min(GEM_MAX_TX_LEN, GEM_MAX_TX_LEN_ERRATA);
 		bp->macbgem_ops.mog_alloc_rx_buffers = gem_alloc_rx_buffers;
 		bp->macbgem_ops.mog_free_rx_buffers = gem_free_rx_buffers;
 		bp->macbgem_ops.mog_init_rings = gem_init_rings;
-- 
2.7.4

