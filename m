Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E671DE2A6
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgEVJLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:11:50 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:2582 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEVJLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:11:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138710; x=1621674710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=2tKKxOsrdSMOcoibs8xBEDtEP66ISqrA+uA6UZYz0ZI=;
  b=ISWkv6Zre620pqkahBP/qMOZzqWtSf5WJpXx5DchoS/uRiyQe6tH02zI
   GuJHwf0HLSCc/CdJ8VjicJqJHFOogwHGwdWXOvnE2ousNBjKUHcYnQfVe
   QjetFeXa7TNKwqAFjEMgwGIBZhuG7PvRiXovVpIGo17S10KiGN7gud0B7
   o=;
IronPort-SDR: z4BX6PYR50GN6uxbwQ+bplSB9Yd0oMotwZFSDCTmct4PxjGREieSJ9qKKGgbgNRaR3oDqYfLZ+
 2pLR2KfRgHvQ==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="46699271"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 22 May 2020 09:11:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 25427A2166;
        Fri, 22 May 2020 09:11:46 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:26 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:22 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Shai Brandes <shaibran@amazon.com>
Subject: [PATCH V2 net-next 03/14] net: ena: use explicit variable size for clarity
Date:   Fri, 22 May 2020 12:08:54 +0300
Message-ID: <1590138545-501-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
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

