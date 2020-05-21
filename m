Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84BB1DD6BE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgEUTJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:53 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:20175 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgEUTJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088192; x=1621624192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Qnm4ya6GepcdKuHaOYcEIGzRr0+KPF93Iv48BWhZvb0=;
  b=EEe8zJiWWyUQScI7z7nySJEVyXHbBSIEHTmx1A+juhKQ4hE+o4+l2Li4
   p7wIJvJnqFshAsSnL/rHlk4tH0/mn6oUBq4BfgsyiUIujZtjro7QgHdab
   7rRjBe+1zMKRybzxh17EpiVBzKzWAIF5In76OLDzSYyQcXCmOgmr1uIV6
   0=;
IronPort-SDR: YsTfqtII4tC7jmoLyU5X8sZHfEoQH/SvcfQGtGNvyS7cGvexwP8iK877//Qv+lG/2sOFTxtVMW
 xcX5uC/9+kBQ==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="36851169"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 May 2020 19:09:52 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id AF885A1799;
        Thu, 21 May 2020 19:09:51 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:25 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:09:22 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 14/15] net: ena: cosmetic: minor code changes
Date:   Thu, 21 May 2020 22:08:33 +0300
Message-ID: <1590088114-381-15-git-send-email-akiyano@amazon.com>
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

1. Use BIT macro instead of shift operator for code clarity
2. Replace multiple flag assignments to a single assignment of multiple
   flags in ena_com_add_single_rx_desc()
3. Move ENA_HASH_KEY_SIZE from ena_netdev.h to ena_com.h

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     | 2 +-
 drivers/net/ethernet/amazon/ena/ena_com.h     | 2 ++
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 8 ++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 2 --
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index bf3465e5a2e7..4b1dbedbe921 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2285,7 +2285,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 	if (unlikely(rc))
 		return rc;
 
-	if (!((1 << func) & get_resp.u.flow_hash_func.supported_func)) {
+	if (!(BIT(func) & get_resp.u.flow_hash_func.supported_func)) {
 		pr_err("Flow hash function %d isn't supported\n", func);
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index bd65ae205f8d..325c9a5f677b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -77,6 +77,8 @@
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS 0
 #define ENA_DEFAULT_INTR_DELAY_RESOLUTION 1
 
+#define ENA_HASH_KEY_SIZE 40
+
 #define ENA_HW_HINTS_NO_TIMEOUT	0xFFFF
 
 #define ENA_FEATURE_MAX_QUEUE_EXT_VER 1
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index f0b90e1551a3..cb6bce101c3b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -598,10 +598,10 @@ int ena_com_add_single_rx_desc(struct ena_com_io_sq *io_sq,
 
 	desc->length = ena_buf->len;
 
-	desc->ctrl = ENA_ETH_IO_RX_DESC_FIRST_MASK;
-	desc->ctrl |= ENA_ETH_IO_RX_DESC_LAST_MASK;
-	desc->ctrl |= io_sq->phase & ENA_ETH_IO_RX_DESC_PHASE_MASK;
-	desc->ctrl |= ENA_ETH_IO_RX_DESC_COMP_REQ_MASK;
+	desc->ctrl = ENA_ETH_IO_RX_DESC_FIRST_MASK |
+		ENA_ETH_IO_RX_DESC_LAST_MASK |
+		(io_sq->phase & ENA_ETH_IO_RX_DESC_PHASE_MASK) |
+		ENA_ETH_IO_RX_DESC_COMP_REQ_MASK;
 
 	desc->req_id = req_id;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 5320b916a36b..9b3948c7e8a0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -98,8 +98,6 @@
 #define ENA_RX_RSS_TABLE_LOG_SIZE  7
 #define ENA_RX_RSS_TABLE_SIZE	(1 << ENA_RX_RSS_TABLE_LOG_SIZE)
 
-#define ENA_HASH_KEY_SIZE	40
-
 /* The number of tx packet completions that will be handled each NAPI poll
  * cycle is ring_size / ENA_TX_POLL_BUDGET_DIVIDER.
  */
-- 
2.23.1

