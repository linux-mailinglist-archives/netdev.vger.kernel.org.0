Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610AD2902B9
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406634AbgJPKTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:19:19 -0400
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:32052
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395274AbgJPKTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 06:19:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bV3UrmE8rX3xl58bnoYm2S5On39t5cxS4FfBhLBxLOKav+eEV5rM6wM79zUpjsAAISERBhKoxiWKrzzldwkF5HmWG/u8n+LZlGeNOF2muKu4HnhuSRo2Rt+rBOrwGcVaYQYIu02dexTUlPDXOaOA0569/8vIzq2jaoqxuTW/czSf49sBCF1nhWdZt4BNw8jhpwXXELRsmfZidQA52PigvfF4bHcqkmUcPU9H/5nb2h6Fqaqc5ZAeZAukFp5i7fnBNxIbmwBBetkiBESF0A8w0jwtyMpKeuWW8qVKpEuWszfn8jTb8U83q0QllatWV4jYysLIUUVU9wNA53eAFcJnWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqol1ShW0omzWy/q4kgXSBKGxtYQbXs8wKhWrb8yKKA=;
 b=V5Mz6RqtIR40/BM7TgAPYZjU8R5tCDGD24IjsteeaAmT2QwvtoMAlCjpUzbyDMTzxfn+A49ocJDOVuxteU3Gw3RxzXGpmGDTTd0sW/LX8+B8e1VNVrQhpbfzOAJNuyIGurcxqda5vdaXNhFMQ+qpgOHod65Ol+kH2zGkIQnqKTyY+wlny1LpyrevWYA5N1omZ1VOqvimPDq4Gz7HX/Y5Wo7FCoY3LflBfMqMCBQPg9kLS1HaDKt7+3EmTxIlQf4fTOdKWLqBuQjEJFIA4Ylo+sLLgRHMM7LvfV2MJsk3VCSdw6cpquNcGolwsqBZDYM7Gh2WHcqvBcK7IDMvx0DJdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.8) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqol1ShW0omzWy/q4kgXSBKGxtYQbXs8wKhWrb8yKKA=;
 b=MzEIN2aDpRWXvdCJOBgKVBjaWmyv1+s3ara61oyLZbC6KUFrkRwUdfRiAQWQwhTnlL+5LAYXf5RfhCoR1kPU2UA7ZNQE2FsIv+OXl7FxPS0kaFJ4CY9K3PcXRECE3Kh6uf3yq223zZiv+gTocSeoSG6DwqIPRuIgTo5peDxG7QY=
Received: from AM6P191CA0100.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::41)
 by PA4PR07MB7280.eurprd07.prod.outlook.com (2603:10a6:102:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.7; Fri, 16 Oct
 2020 10:19:13 +0000
Received: from VE1EUR03FT043.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::57) by AM6P191CA0100.outlook.office365.com
 (2603:10a6:209:8a::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend
 Transport; Fri, 16 Oct 2020 10:19:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.8)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.8 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.8; helo=fihe3nok0734.emea.nsn-net.net;
Received: from fihe3nok0734.emea.nsn-net.net (131.228.2.8) by
 VE1EUR03FT043.mail.protection.outlook.com (10.152.19.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 10:19:11 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0734.emea.nsn-net.net (GMO) with ESMTP id 09GAJ3nY002276;
        Fri, 16 Oct 2020 10:19:07 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2 net] staging: octeon: Drop on uncorrectable alignment or FCS error
Date:   Fri, 16 Oct 2020 12:18:58 +0200
Message-Id: <20201016101858.11374-2-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6d2f6f52-abaa-4f78-d4f2-08d871bcedfe
X-MS-TrafficTypeDiagnostic: PA4PR07MB7280:
X-Microsoft-Antispam-PRVS: <PA4PR07MB72805F97395CEE13D028B59C88030@PA4PR07MB7280.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXKE70XJRgxexgnneT3vGSOVnFm9ro9wUDk1XFu3L0anlXHp4WCyzeKJtOHha4TSNUgxuAtFV6AJruA2P8Sv+APCpyoUbYOGgxzZHNj5BMpqAxv/B+zHaflWpgYB+KJOBL8wIxi2vljg6cJY8pkZArcCgywOqePTqlLGCG5SmBme0VtQ0wzxzKuxH7zdaG/+Ef+OurrgZnMWvXbYljFrUbO8XCr5ItmxsdwYQftNALw70ZmLuwESehKkjhzLINvJRWaHnFaE2AXMz38hvAWlPAMKTnfzqDCBr1soDveJDe7MM7nIGEiTK0OPBjYTFN9yIL10dqoiEEM3KBNxu3KGHIrS3Ks/CYr9iiDV4DO2NDJw1x7+NQ15zytTuH1w36vosu+KbrmCTNNMDgkExmhz79VjtP0JdrjZwFyYm28NVXSBZKm2PJzOVj3YCsRpXmij
X-Forefront-Antispam-Report: CIP:131.228.2.8;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0734.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(46966005)(34020700004)(82740400003)(54906003)(478600001)(1076003)(81166007)(82310400003)(26005)(186003)(5660300002)(316002)(356005)(47076004)(86362001)(83380400001)(6916009)(336012)(2616005)(70206006)(70586007)(2906002)(8936002)(6666004)(4326008)(36756003)(8676002);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 10:19:11.5954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d2f6f52-abaa-4f78-d4f2-08d871bcedfe
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.8];Helo=[fihe3nok0734.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT043.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB7280
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
 drivers/staging/octeon/ethernet-rx.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

Changes in v2:
- whitespace alignment fix as suggested by Dan Carpenter
- fixed the logic to accept "corrected" packets (preambles 0xd, 0xd5)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 2c16230..9ebd665 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -69,15 +69,17 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
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
-		   work->word2.snoip.err_code == 7) {
+		return 0;
+
+	if (work->word2.snoip.err_code == 5 ||
+	    work->word2.snoip.err_code == 7) {
 		/*
 		 * We received a packet with either an alignment error
 		 * or a FCS error. This may be signalling that we are
@@ -108,7 +110,10 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
 				/* Port received 0xd5 preamble */
 				work->packet_ptr.s.addr += i + 1;
 				work->word1.len -= i + 5;
-			} else if ((*ptr & 0xf) == 0xd) {
+				return 0;
+			}
+
+			if ((*ptr & 0xf) == 0xd) {
 				/* Port received 0xd preamble */
 				work->packet_ptr.s.addr += i;
 				work->word1.len -= i + 4;
@@ -118,21 +123,20 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
 					    ((*(ptr + 1) & 0xf) << 4);
 					ptr++;
 				}
-			} else {
-				printk_ratelimited("Port %d unknown preamble, packet dropped\n",
-						   port);
-				cvm_oct_free_work(work);
-				return 1;
+				return 0;
 			}
+
+			printk_ratelimited("Port %d unknown preamble, packet dropped\n",
+					   port);
+			cvm_oct_free_work(work);
+			return 1;
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

