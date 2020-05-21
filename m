Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231091DD6B7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgEUTJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:30 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32043 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730136AbgEUTJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088169; x=1621624169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2tKKxOsrdSMOcoibs8xBEDtEP66ISqrA+uA6UZYz0ZI=;
  b=BsA5ybzoi0kIGcADj5xlvH1jd9TwAVAFgz04PzksGxCn5V/Od/V52Qiu
   WASNiOFnER4yGH+qpA5q3THnf1R/AExPsXE2QhdkpsCchLTBrFP4IIZNf
   iNIBtQslsRV9aaqMCHKmkRaSfeqcis3gRj4SCLfxkGjPMaYIKKMz4yYPZ
   g=;
IronPort-SDR: 2EjAnKYiuH0Qqu3okpZNFzLU+DWz7TcgD0eDgHXFoqOtul3dau0gwia+ewxosfJvqcfgRvtnHD
 dgpqfvCttSug==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="31706444"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 May 2020 19:09:17 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 7CE67A119D;
        Thu, 21 May 2020 19:09:16 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:48 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:48 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:45 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Shai Brandes <shaibran@amazon.com>
Subject: [PATCH V1 net-next 03/15] net: ena: use explicit variable size for clarity
Date:   Thu, 21 May 2020 22:08:22 +0300
Message-ID: <1590088114-381-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Use u64 instead of unsigned long long for clarity

Signed-off-by: Shai Brandes <shaibran@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index b51bf62af11b..02780f9fa586 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2003,7 +2003,7 @@ void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
 	struct ena_admin_aenq_entry *aenq_e;
 	struct ena_admin_aenq_common_desc *aenq_common;
 	struct ena_com_aenq *aenq  = &dev->aenq;
-	unsigned long long timestamp;
+	u64 timestamp;
 	ena_aenq_handler handler_cb;
 	u16 masked_head, processed = 0;
 	u8 phase;
@@ -2021,9 +2021,8 @@ void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
 		 */
 		dma_rmb();
 
-		timestamp =
-			(unsigned long long)aenq_common->timestamp_low |
-			((unsigned long long)aenq_common->timestamp_high << 32);
+		timestamp = (u64)aenq_common->timestamp_low |
+			    ((u64)aenq_common->timestamp_high << 32);
 		pr_debug("AENQ! Group[%x] Syndrom[%x] timestamp: [%llus]\n",
 			 aenq_common->group, aenq_common->syndrom, timestamp);
 
-- 
2.23.1

