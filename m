Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA1014EBF3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgAaLsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:48:17 -0500
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:4256
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728442AbgAaLsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:48:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPY5EH3qdfATz+jlKetfqL9mQy75t5lkAbw0mgm4T4jm0ICOWVDtrJbSaFT66yDce9WyMDnIicIcov+36I+xIR5ErIv1/B/G1p5J+gJ/j8YCHlA8vez7TOjsHo40gJ00sf68DOMnA0+PwmyBqwSRSLbRroqqaNULgiK/RcOd6rNvP3yA/21NnojxUWj4BXovzDP3xUAQKivso25VNClHHG9wtZf8iY6uYdB3kZR4TLis3lUFX0WvbiGNlctBrK/hwL7b03lce5ml8Eeopp7/oHZvHp8ZJDKBKdpPB/YAvi9B+/OYUqJfAq90gE21ssw9yJnMmPd7m1CidHwPqkgXuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auJpoj+XQ/2W7uDSB/weHG8Z/SeOluHv2B1ra2HsIek=;
 b=GR9ZfBWNHwHNQTfnvGUvoVp2zah8vGZrV+nDkPeQjF2r8g4aMfmiXXLUj07bMOugfrhbnpqfE4h0QKpH1VB6poS9HykSqPdLfPHYhDVYJPRmTKbv9GwxiIZHJ39DZ5/8inALkoK1F3ruSeQ0H4XXaVSU01+dV+et1kzinrfpbDOGJGWBJAYjNaK1H39LCArxQC2xJEM6aGLjeTHURp+6X6dDQeK2MOdRcajWNdZsE1z5qDi59Xe9bqQRXbHqV4iGfT2RI+TzHuHx+gFp/AN7GhOT+gEpXwMG76OkT5vkh9jdWJ6D1PdQ7nDeKtxc9/fN2u8A8kNg+8g4JnYbpSkzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auJpoj+XQ/2W7uDSB/weHG8Z/SeOluHv2B1ra2HsIek=;
 b=mp1tysg3+34FmXVaTONm/cR8O0eP6URIKFvszhWp6+8tw8512GBa22TGOZ4K9LQNVv6oyGnm2jlc3mvBB0osDxRcAP1riOaLbdDJJzGIqDUpTnyTyu1mTCoLXX9jR4xlc6Als2nXNkJTxrofE2h6ce0kpgGt3ufQDIUdy6HH5Kc=
Received: from DM6PR02CA0094.namprd02.prod.outlook.com (2603:10b6:5:1f4::35)
 by BYAPR02MB4821.namprd02.prod.outlook.com (2603:10b6:a03:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.23; Fri, 31 Jan
 2020 11:48:12 +0000
Received: from CY1NAM02FT017.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::206) by DM6PR02CA0094.outlook.office365.com
 (2603:10b6:5:1f4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend
 Transport; Fri, 31 Jan 2020 11:48:12 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT017.mail.protection.outlook.com (10.152.75.181) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 11:48:12 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmS-0006bN-0U; Fri, 31 Jan 2020 03:48:12 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmM-0004pp-Rq; Fri, 31 Jan 2020 03:48:06 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VBm57D012170;
        Fri, 31 Jan 2020 03:48:05 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmL-0004os-F7; Fri, 31 Jan 2020 03:48:05 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id A70F9100116; Fri, 31 Jan 2020 17:18:04 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v3 -next 4/4] net: emaclite: Fix restricted cast warning of sparse
Date:   Fri, 31 Jan 2020 17:17:50 +0530
Message-Id: <1580471270-16262-5-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--3.791-7.0-31-1
X-imss-scan-details: No--3.791-7.0-31-1;No--3.791-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(428003)(249900001)(189003)(199004)(26005)(36756003)(336012)(356004)(450100002)(8676002)(6266002)(81156014)(498600001)(107886003)(6666004)(81166006)(5660300002)(70206006)(82310400001)(2616005)(4326008)(2906002)(8936002)(42882007)(42186006)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB4821;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;MX:0;A:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8ac2a02-7dcb-41e1-cdfe-08d7a6437365
X-MS-TrafficTypeDiagnostic: BYAPR02MB4821:
X-Microsoft-Antispam-PRVS: <BYAPR02MB4821F690A85A0C48AEBAE175D5070@BYAPR02MB4821.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 17EWvnv7t4Z4Wcq7feIxAdJJs9jDUuXm9GbqsZjju78Jt8Bmf0ZVl5f/wDrWZmhUmEmd9+YMU81IYB0Jlg/JJckTTOG72r/etEdWgpDr1C6WPnE/a9+ui9cezXt7gO+VVvPcBZ7NndwUp90BrpckcWUh+1ib+w1A/bEGbbc9Hd8yqq4xtzbSjGBBzT1dL1fi/qeXU9O83xsUIVINHwxbqSO5IOiTWkwnLPtuQ7no9LotGG8/RIE6gTz1YDEN9rbPJP1d/KW1voaZTt/JTaFqb4JUvxO35xK+J/pNnyevr6HKaenSDP6/rAPIfMyp9c5SrxPHR/l5tAklO5MB8xK7OoY/psv1Vvw3BGHB+b9u6okalyvrutNTrwaThLASwP2O0RhtTYARwhiuO+rufazdB2v/vRsHSW0KPXcG6/hwVBR/9+K7GqhNMHjUlCnMkdH8
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 11:48:12.4775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ac2a02-7dcb-41e1-cdfe-08d7a6437365
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4821
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly cast xemaclite_readl return value when it's passed to ntohl.
Fixes below reported sparse warnings:

xilinx_emaclite.c:411:24: sparse: sparse: cast to restricted __be32
xilinx_emaclite.c:420:36: sparse: sparse: cast to restricted __be32

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 96e9d21..3273d4f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -408,7 +408,8 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 
 	/* Get the protocol type of the ethernet frame that arrived
 	 */
-	proto_type = ((ntohl(xemaclite_readl(addr + XEL_HEADER_OFFSET +
+	proto_type = ((ntohl((__force __be32)xemaclite_readl(addr +
+			XEL_HEADER_OFFSET +
 			XEL_RXBUFF_OFFSET)) >> XEL_HEADER_SHIFT) &
 			XEL_RPLR_LENGTH_MASK);
 
@@ -417,7 +418,7 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 	 */
 	if (proto_type > ETH_DATA_LEN) {
 		if (proto_type == ETH_P_IP) {
-			length = ((ntohl(xemaclite_readl(addr +
+			length = ((ntohl((__force __be32)xemaclite_readl(addr +
 					XEL_HEADER_IP_LENGTH_OFFSET +
 					XEL_RXBUFF_OFFSET)) >>
 					XEL_HEADER_SHIFT) &
-- 
2.7.4

