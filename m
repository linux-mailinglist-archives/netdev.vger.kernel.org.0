Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E835457C07
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 08:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfF0GV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 02:21:26 -0400
Received: from mail-eopbgr710050.outbound.protection.outlook.com ([40.107.71.50]:21099
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbfF0GVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 02:21:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21xHAHNSRv1mPEANcQklv2kU8/U3gxNEUz2CqeUaAoY=;
 b=SsoQf5TZ9rNUXodsQayu2sISuEck6u3x0xAWo4u4ikqxqT0SIRSJ4SzvwbpYtRiwFXWCY12A21pPSP7zrZduxCzraukkRTnfu/v/7L4n+CponBHC5AYmexQph5eDzWb5raYzT7mvnnmU76Hqtuf3gvYwQc1PyjhfDD6jm/FlnpA=
Received: from DM6PR02CA0080.namprd02.prod.outlook.com (2603:10b6:5:1f4::21)
 by BL0PR02MB3729.namprd02.prod.outlook.com (2603:10b6:207:48::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Thu, 27 Jun
 2019 06:21:17 +0000
Received: from BL2NAM02FT015.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by DM6PR02CA0080.outlook.office365.com
 (2603:10b6:5:1f4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Thu, 27 Jun 2019 06:21:17 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT015.mail.protection.outlook.com (10.152.77.167) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2032.15
 via Frontend Transport; Thu, 27 Jun 2019 06:21:16 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:40866 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmV-0005e5-RJ; Wed, 26 Jun 2019 23:21:15 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmP-0007pI-MX; Wed, 26 Jun 2019 23:21:09 -0700
Received: from xsj-pvapsmtp01 (xsj-mail.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x5R6L9Q6000584;
        Wed, 26 Jun 2019 23:21:09 -0700
Received: from [172.23.37.92] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1hgNmN-0007mn-Tg; Wed, 26 Jun 2019 23:21:08 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        rafalo@cadence.com, andrei.pistirica@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH 1/2] net: macb: Add separate definition for PPM fraction
Date:   Thu, 27 Jun 2019 11:50:59 +0530
Message-Id: <1561616460-32439-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
References: <1561616460-32439-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(39860400002)(346002)(2980300002)(199004)(189003)(8676002)(2906002)(50466002)(478600001)(486006)(126002)(5660300002)(44832011)(356004)(6666004)(316002)(47776003)(50226002)(8936002)(106002)(14444005)(48376002)(63266004)(81156014)(36386004)(81166006)(77096007)(36756003)(186003)(2616005)(476003)(305945005)(26005)(107886003)(16586007)(51416003)(7696005)(4326008)(70206006)(76176011)(70586007)(426003)(336012)(11346002)(9786002)(446003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR02MB3729;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf726eb4-3a81-41c6-7acb-08d6fac7a9a9
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328);SRVR:BL0PR02MB3729;
X-MS-TrafficTypeDiagnostic: BL0PR02MB3729:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <BL0PR02MB372901F3A493BF947C0E5C8FC9FD0@BL0PR02MB3729.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 008184426E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Dqv3nLxq8ldOa7X5PxIYpfvQJi28cARsM8/4BEPWP8x4CC0qHP9VfMH0KCMaXbxLe5DzzGPk1jYGlMaZQD/uA69uxUbUzoqHi5Kf5DbZ+gUnUNBeIbYYh7cvy1AYonIRePK8rZk91Sr1xnHVINwHnBqOM5Jl669Ua/ogUe/8fFjPzeitZlpZCzhBAeV/J1ZUWGL24ynIlPbdKtVqYj/9PrwrDFwpyXZORTFfDDwNd/wKPRj2ydSUkj/PJgZhCvSWtN+QpiErCgypYUfrTbBTgthxEBtBaqphukeAKQwamv55eAgcmGfBh0/8Q+TQvEvh5+AkYV5CUw4tI0CxwZ5up14ZOsKWxT/lcVe/bp6vX75+qLjNSTDgVGy8gIoAoE5jBHAhIFp9A0VO3ihy5cFp76tobUG//fx81ZEfPZvlU38=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2019 06:21:16.9684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf726eb4-3a81-41c6-7acb-08d6fac7a9a9
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3729
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The scaled ppm parameter passed to _adjfine() contains a 16 bit
fraction. This just happens to be the same as SUBNSINCR_SIZE now.
Hence define this separately.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 drivers/net/ethernet/cadence/macb.h     | 3 +++
 drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 515bfd2..90bc70b 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -834,6 +834,9 @@ struct gem_tx_ts {
 /* limit RX checksum offload to TCP and UDP packets */
 #define GEM_RX_CSUM_CHECKED_MASK		2
 
+/* Scaled PPM fraction */
+#define PPM_FRACTION	16
+
 /* struct macb_tx_skb - data about an skb which is being transmitted
  * @skb: skb currently being transmitted, only set for the last buffer
  *       of the frame
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 0a8aca8..6276eac 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -135,7 +135,7 @@ static int gem_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	 * (temp / USEC_PER_SEC) + 0.5
 	 */
 	adj += (USEC_PER_SEC >> 1);
-	adj >>= GEM_SUBNSINCR_SIZE; /* remove fractions */
+	adj >>= PPM_FRACTION; /* remove fractions */
 	adj = div_u64(adj, USEC_PER_SEC);
 	adj = neg_adj ? (word - adj) : (word + adj);
 
-- 
2.7.4

