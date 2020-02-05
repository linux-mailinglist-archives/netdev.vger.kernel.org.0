Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04011530E9
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 13:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgBEMim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 07:38:42 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:44960
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbgBEMii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 07:38:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0yVRTqhXShY0YR9y3zK+TIvZJVlLd/6tFpAZwj49zEm1Y6jKZfG27lciMA1BTJO9wZ5GZQpCn6PVqpqdNMH06XO4mf7Iyn+FtJN6MHsHDW1JYlald/VdOdCfS6/UIYUha9aTluZkWFq7UN72lRsEj7fTb/N/LiMhQz/geo1j8y+osZ9cScFYp5w609Asvm1q7I7t43ZrLG57fQbMqsmAhWYBcVcA/jr4BIlEldZlI9uMkGcHSX1Twmj+IZkTmcw84+Kwn2uDy4LMCnel67nRQmaQk2NufLFD6Ah79Fue91Oe2SRwKAc/+MQOZQKp6q/ZRf2EMGb7FBrTYvx8RpFtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sQOQ8oH3Z+5kY81LdrvY3w2f/X3BIcMm4TAFHcQhlA=;
 b=TVxpeHP/nj2TMm94cH9sF98DLw/1S9pBZS3+vJvavLLFW65hcOgoMfOj8GXownha+IgJrZHWnLCYHZOHsqqFFzAF0TfFPe58j2QKgYsIcKEQ05c8lQorUxMwVgdK9Z6KL868pmjNKdA6PXi9ZQImkLKFAmlFNiT6/Kd6HOChCFxzIMkxbKfTcfJQBhfgAqy1pAOu4JEIt/hmq5X1Sj5hTFeVHZNtOnH11YtsdlbnOuexBF5YD7Pb7SbOJUoMaxNUMya5aPGxDrPMHRl52rDAHCjS/CNyRF0XT4ztikP8jSVazYmPksZG0qQHAZvQyUxI8pvBHWBncC9EN+uHHu8Vmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sQOQ8oH3Z+5kY81LdrvY3w2f/X3BIcMm4TAFHcQhlA=;
 b=DtYKDhcKBs2yTOr0NoyUbz9pqmQ9zcUQaUBOT35PRYwD6xtyMh9zApvLcz++afOASlNHePwDc7ADo+KzwYJQknSOoPuT3YzoKjYmTUwqbFSY4nGDpqrHykWLDndCmdl1EBnm2ybpyl8+DcOkI9YkbUaUGQKMri1ywXkRLc0Oczw=
Received: from BL0PR02CA0135.namprd02.prod.outlook.com (2603:10b6:208:35::40)
 by CH2PR02MB6198.namprd02.prod.outlook.com (2603:10b6:610:b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21; Wed, 5 Feb
 2020 12:38:35 +0000
Received: from CY1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BL0PR02CA0135.outlook.office365.com
 (2603:10b6:208:35::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend
 Transport; Wed, 5 Feb 2020 12:38:34 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT016.mail.protection.outlook.com (10.152.75.164) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2707.21
 via Frontend Transport; Wed, 5 Feb 2020 12:38:34 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwv-0001wz-VP; Wed, 05 Feb 2020 04:38:33 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwq-0007wV-QZ; Wed, 05 Feb 2020 04:38:28 -0800
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 015CcJKp009596;
        Wed, 5 Feb 2020 04:38:19 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1izJwg-0007uq-Jg; Wed, 05 Feb 2020 04:38:19 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH v3 1/2] net: macb: Remove unnecessary alignment check for TSO
Date:   Wed,  5 Feb 2020 18:08:11 +0530
Message-Id: <1580906292-19445-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
References: <1580906292-19445-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(199004)(189003)(8936002)(2616005)(336012)(4326008)(107886003)(81156014)(8676002)(81166006)(2906002)(9786002)(6666004)(356004)(5660300002)(70206006)(70586007)(36756003)(426003)(186003)(44832011)(26005)(498600001)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6198;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dea4f69-4c15-486c-d65e-08d7aa3850bb
X-MS-TrafficTypeDiagnostic: CH2PR02MB6198:
X-Microsoft-Antispam-PRVS: <CH2PR02MB6198E665F5AD0166DD0443EDC9020@CH2PR02MB6198.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0304E36CA3
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ta9ACKe2R/8USjw9bf6P9RMmWgrLI59dI92PRMtvpZ/mupNqDVbi6ENLBeWx2CI4hf6g4GM+HmbQDt8UVDiM8aASPzBXsiazPwgQaTJIsTckvOG0h7I+/ATJPBJ2yjzGfMdcu9ZkOyXMtrhPPczVjG1iTQ75+ulaSGyYdLXKrCw64tRVzTH6xN71wRyHEFiX3Oge71HWzMAqe4jE1uuX3pHYK/X4n78LZJYTdgYR5x2ZvxweA9SJrrAkSUa6Lr8kzk/bq7j4HiXp4vAyVqlXgo9pReESHt6Gb+CWtVGZi8/rERIomU/R+GMJj//Dp7c4U25ooMs6gCDRdw1zaRMr0h6DwCq5xikD53M9Osdryez2PvJb1pdIfOt1T+/GeGKX7tr2bv+V+jtWKZ9L3059hewliPPjv94h005byap4ImsqhTTeLz2akWvLjZqmbcUC
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2020 12:38:34.4301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dea4f69-4c15-486c-d65e-08d7aa3850bb
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IP TSO implementation does NOT require the length to be a
multiple of 8. That is only a requirement for UFO as per IP
documentation. Hence, exit macb_features_check function in the
beginning if the protocol is not UDP. Only when it is UDP,
proceed further to the alignment checks. Update comments to
reflect the same. Also remove dead code checking for protocol
TCP when calculating header length.

Fixes: 1629dd4f763c ("cadence: Add LSO support.")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
v3:
Update comments and commit message
Remove dead code checking for TCP
v2:
Added Fixes tag

 drivers/net/ethernet/cadence/macb_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7a2fe63..1131192 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1791,16 +1791,14 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 
 	/* Validate LSO compatibility */
 
-	/* there is only one buffer */
-	if (!skb_is_nonlinear(skb))
+	/* there is only one buffer or protocol is not UDP */
+	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
 		return features;
 
 	/* length of header */
 	hdrlen = skb_transport_offset(skb);
-	if (ip_hdr(skb)->protocol == IPPROTO_TCP)
-		hdrlen += tcp_hdrlen(skb);
 
-	/* For LSO:
+	/* For UFO only:
 	 * When software supplies two or more payload buffers all payload buffers
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */
-- 
2.7.4

