Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAC128864B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgJIJqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:46:39 -0400
Received: from mail-eopbgr90095.outbound.protection.outlook.com ([40.107.9.95]:60122
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbgJIJqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:46:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPyVi6XBFpMDDCqLvhSPpK0Q++2QCyrM9UlY/onV8SobgW5+TW7K227CRMCKZtiE/JnvVWS13qlpHapXZqH+jqoQy08KW1DRLzHiHq6VQ6kAeDLQFFQoB+Fd+HrDpjBNZvVzfk+1N31fzQ0n5FOrCHnRXquLxkM6PC6DwfEF2Jp2AiMcV3mzENF8U976LMvSMYoqEmGspe6t7QiFDE01exfV6aR+wtJPt1C/lNX96+lK7ehpeZPst6P+MC9dOXnZW+Tl8L3UYHPsr0vkkpfOPSKWlhaR/K2+yTYJKfUipxclA0/M27GltjMK4xe1qoygsz8TPOD8oNPUDYdNnm7+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lU6cEeEW3sqYoPRiP+lNxeq6YN7kZJnegrqoM6fTu8I=;
 b=Erdl8+dg8CpLQ18FgCWOo8O82ddJ+FWjJ+cGdqktJgpOznt5NgFim9xnW+4NZ/l7ouXDfis9AsEPRzistBpuADu5x+C8nN6nYffylzf6ksZ6oRdvcAw0usmhFRbOh1aA50pQMgM/6oCLUsaDIwYLHMMoLZ/ex0QptvjR+G9pycF6ZuehZJ+y9S6bCVDuAETWadxrb7TdjPK1esBQG4pqQrGf/36BGziuM9idfnoUqv9wY3JBRuN1YWtigkSEYnCTDiXkOzcGKEeMDywgGA2p9stsDexpSyudk3KYe+fn3f+ZvTkY/fwP5VyagJb+3D+k8OG82zrJfVpN+sIJVKKt2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lU6cEeEW3sqYoPRiP+lNxeq6YN7kZJnegrqoM6fTu8I=;
 b=rVwAClGLpQU530dntO0p8B/WZ3d6ztgbvIiz/lWokZQCE2Ca2zJThuZSApu8mqz2cO4NBYOFPbDm04ZMpzvih6eQz4Rpn3R7f81AX5sPWemSkDbP/nwfPsOzXWP/7MQw2OUA7whsFIXhxbEh+RPwne7rX2p8rwPb95SD1G/Nr4A=
Received: from DB6PR0802CA0031.eurprd08.prod.outlook.com (2603:10a6:4:a3::17)
 by PR1PR07MB5097.eurprd07.prod.outlook.com (2603:10a6:102:1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Fri, 9 Oct
 2020 09:46:31 +0000
Received: from DB5EUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:a3:cafe::f) by DB6PR0802CA0031.outlook.office365.com
 (2603:10a6:4:a3::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend
 Transport; Fri, 9 Oct 2020 09:46:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.17)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.17; helo=fihe3nok0735.emea.nsn-net.net;
Received: from fihe3nok0735.emea.nsn-net.net (131.228.2.17) by
 DB5EUR03FT049.mail.protection.outlook.com (10.152.20.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23 via Frontend Transport; Fri, 9 Oct 2020 09:46:30 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0735.emea.nsn-net.net (GMO) with ESMTP id 0999k8bt018069;
        Fri, 9 Oct 2020 09:46:27 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] stating: octeon: Drop on uncorrectable alignment or FCS error
Date:   Fri,  9 Oct 2020 11:46:05 +0200
Message-Id: <20201009094605.1525-2-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20201009094605.1525-1-alexander.sverdlin@nokia.com>
References: <20201009094605.1525-1-alexander.sverdlin@nokia.com>
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 979a7b88-4376-442e-ae8b-08d86c383372
X-MS-TrafficTypeDiagnostic: PR1PR07MB5097:
X-Microsoft-Antispam-PRVS: <PR1PR07MB5097F1AB640C59E5976AE27D88080@PR1PR07MB5097.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAJ6imAmiFYhpdlVFNJ89QemEjqLSeaEbr1BRETf2SUB4zcyq4KXTZtX8WYebSxwBQmb7VqcYt/wFOI7CfZqpYjm1uU3wJA9a+YMxu6384djyg89VpYaYn4EtjevHb5SMTaYNfhOs5eLPVLP+a5EqhmgsoihcAYVe8hFWqB+NGwY0Vwpp05ec61adKu0keHPr4bj4QH/GcNGBkgeFOuHkp+LCULkPVfXhzFeM1J2PJqNjXvagxTmzf+So8KydvheV1XqL4mNRMsbCcyxmZ0gLGTDwaqNvLmJW0NtrYCzutQ9zb8PVn9HeABAo4GciGAlJvmQVrkRC3PaUFBPEgta6FGKo+rZW32BPpsXkJk5nPfjewnYYiGdj/HFEjkpBJU3XKtTSZxOB2tQwt8gVsEzzNqRCcM3QmdmPL8I1Zy9pVQCD1LqmJbw0r1ZJevDEKNS
X-Forefront-Antispam-Report: CIP:131.228.2.17;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0735.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(46966005)(70586007)(6666004)(8676002)(70206006)(5660300002)(47076004)(316002)(6916009)(83380400001)(336012)(54906003)(356005)(2616005)(81166007)(36756003)(86362001)(1076003)(478600001)(2906002)(82310400003)(82740400003)(34070700002)(4326008)(186003)(26005)(8936002);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 09:46:30.9087
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 979a7b88-4376-442e-ae8b-08d86c383372
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.17];Helo=[fihe3nok0735.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR07MB5097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Currently in case of alignment or FCS error if the packet cannot be
corrected it's still not dropped. Report the error properly and drop the
packet while making the code around a little bit more readable.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")

Change-Id: Ie1fadcc57cb5e221cf3e83c169b53a5533b8edff
---
 drivers/staging/octeon/ethernet-rx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 2c16230..b22f7be 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -69,14 +69,16 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
 	else
 		port = work->word1.cn38xx.ipprt;
 
-	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
+	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))
 		/*
 		 * Ignore length errors on min size packets. Some
 		 * equipment incorrectly pads packets to 64+4FCS
 		 * instead of 60+4FCS.  Note these packets still get
 		 * counted as frame errors.
 		 */
-	} else if (work->word2.snoip.err_code == 5 ||
+		return 0;
+
+	if (work->word2.snoip.err_code == 5 ||
 		   work->word2.snoip.err_code == 7) {
 		/*
 		 * We received a packet with either an alignment error
@@ -125,14 +127,12 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
 				return 1;
 			}
 		}
-	} else {
-		printk_ratelimited("Port %d receive error code %d, packet dropped\n",
-				   port, work->word2.snoip.err_code);
-		cvm_oct_free_work(work);
-		return 1;
 	}
 
-	return 0;
+	printk_ratelimited("Port %d receive error code %d, packet dropped\n",
+			   port, work->word2.snoip.err_code);
+	cvm_oct_free_work(work);
+	return 1;
 }
 
 static void copy_segments_to_skb(struct cvmx_wqe *work, struct sk_buff *skb)
-- 
2.10.2

