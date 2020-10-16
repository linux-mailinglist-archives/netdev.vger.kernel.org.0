Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999E62907D2
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409647AbgJPO4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:56:47 -0400
Received: from mail-eopbgr80123.outbound.protection.outlook.com ([40.107.8.123]:24458
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407141AbgJPO4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 10:56:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKf/r6tqR3lKb+4WsBAB1UUHpFrtFDFw5/8VqkdaSspxdZoTOMxCegPNshnNvi3Nn9fEkjPWOiRYve6wBJF2HkbogBArHl+QkrUhKC6kDlUzqIm5GeL07eXQJW0xuVtM/Sgt8fgkI27LVylAqDF1GaJ1JXoppAFZPxfSk68rRO87PW1AjvzSmBnkBanSjQucFmSZx4cbkw+qHDiCv+6gxwDyEwLk37sjaYgg+sVnqPCjqx8DmTJbsiT+Py3jcvbBI6gpFt7A+zU+MZZW2WvjRe2wvuWkw/V9SY/hwJJ/dJkvH/x++sDT+byvlL2x7mS5DU8gTiPhCudVCO12jkaEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gn80hTt4wkFtcaw1bRct++EEUBksmsC4y5wKuKULwL8=;
 b=nZlti2qAm4e3MM3ecsPDB+bEDYnQL7ZrXbdrHAbzOTxhNjx/efesrxe+tP3H6uktBNnIfA9jpmpMf9Dj+4d06rqosULteBEyGxO/1tNnJixfkpVk5AoMTE44vfeZGmI6B9+5KDv/ufQQay/zw0rmKIHQAyIDw6kkYO8I+YW531/my+RDqmwdLJgoCZuZMPsP09W3rq/rfWgYUoW5u+UR5JTgkBQ77zCZoj931aJJwmtwdRHtJ2pgWNDqDvRcipbVRpDHcD63LELUGHhByIPfCFlHRhp0yOlOf5zlfClPAtGwC8I2TJrsQywoTfX5tDBZtBGsS2TbRVWZpQRo/Ol0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.8) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nokia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nokia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gn80hTt4wkFtcaw1bRct++EEUBksmsC4y5wKuKULwL8=;
 b=Q+WQRIg7CsVjOeinpPqLWLpZ/kWQkYBfosgdkSHPJTIN8y7oahDTODiZD0qTQa2YTgrN0N6ptVM+dEK4Cz4HARNsBqifYgQ4IoFNO+lKhbRIeHEWMNGvIGzUhzfm0GCvQWtqb/VTLE2mlrumb+J2Ha6tLq7wuCQ+L+Mq+KAhBrU=
Received: from MR2P264CA0098.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::14)
 by AM6PR0702MB3622.eurprd07.prod.outlook.com (2603:10a6:209:f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Fri, 16 Oct
 2020 14:56:41 +0000
Received: from VE1EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:33:cafe::9d) by MR2P264CA0098.outlook.office365.com
 (2603:10a6:500:33::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend
 Transport; Fri, 16 Oct 2020 14:56:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.8)
 smtp.mailfrom=nokia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.8 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.8; helo=fihe3nok0734.emea.nsn-net.net;
Received: from fihe3nok0734.emea.nsn-net.net (131.228.2.8) by
 VE1EUR03FT005.mail.protection.outlook.com (10.152.18.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 14:56:41 +0000
Received: from ulegcparamis.emea.nsn-net.net (ulegcparamis.emea.nsn-net.net [10.151.74.146])
        by fihe3nok0734.emea.nsn-net.net (GMO) with ESMTP id 09GEuaJ9003230;
        Fri, 16 Oct 2020 14:56:36 GMT
From:   Alexander A Sverdlin <alexander.sverdlin@nokia.com>
To:     devel@driverdev.osuosl.org
Cc:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v3 net] staging: octeon: Drop on uncorrectable alignment or FCS error
Date:   Fri, 16 Oct 2020 16:56:30 +0200
Message-Id: <20201016145630.41852-1-alexander.sverdlin@nokia.com>
X-Mailer: git-send-email 2.10.2
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: a0e6df54-312a-4495-19eb-08d871e3b12f
X-MS-TrafficTypeDiagnostic: AM6PR0702MB3622:
X-Microsoft-Antispam-PRVS: <AM6PR0702MB3622940D0C21BA87B79EBD0B88030@AM6PR0702MB3622.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 74gPu6Pc3RhKCR0x6UkEGc/60h9z3KkKbeCTFXfM9gnJkbk8Ml1+86a5fJT2rY2IqySWFU1KeBS1O5ilQ/fAqMaaht8dTQQ2/HGRjZ7vfhIlwGS/6bpXqF+m2AQkATHjFcxnnPyzydSFPaCpCndMgrws0cPcHoHJyeIGFSgclkgkCSorH8eL625jfQRQ5Wu5lwfdWYiMv8qDvRmYTHxBijDs2M49d5PccV3iEWHRFd/nzhxAjY5oDaRjverySOjrQTvPP6CLrIo2LaL+zNPiU84VjemsfRmsm4wGlSkpLBudwbh47h/uFhQ21ylLwWGFghqoygpUOeocP0I2CGXrhEaVQFNNOZSHa6r1RZHVxgeccZ4lXPiyamhp6zdHfGQd2CiRfqxDWzP1nKnST5LRNO8dvqJJmo9DWE6jYa+l+yeERxOxHbzLNKftHHjale8a
X-Forefront-Antispam-Report: CIP:131.228.2.8;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe3nok0734.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(46966005)(5660300002)(82740400003)(356005)(36756003)(2906002)(8676002)(47076004)(81166007)(8936002)(54906003)(82310400003)(70206006)(26005)(336012)(186003)(1076003)(34020700004)(86362001)(4326008)(70586007)(316002)(2616005)(83380400001)(6916009)(6666004)(478600001);DIR:OUT;SFP:1102;
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 14:56:41.6014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e6df54-312a-4495-19eb-08d871e3b12f
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.8];Helo=[fihe3nok0734.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0702MB3622
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Currently in case of alignment or FCS error if the packet cannot be
corrected it's still not dropped. Report the error properly and drop the
packet while making the code around a little bit more readable.

Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/staging/octeon/ethernet-rx.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

Changes in v3:
- Removed Change-Id tag
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

