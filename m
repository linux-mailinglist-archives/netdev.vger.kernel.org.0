Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6517D1DE2B5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgEVJMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:38 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:37966 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgEVJMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138756; x=1621674756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=SzvN4MrRV/cbJv6Garj8C2RO7FtiRJSOKEh/g29PvUE=;
  b=tkmiZ8gYpfSW+ZF9bf+3WCOtofAuyKMiUrTxL+2sCfpgemC194n+WKPt
   RwbpNZcyIjJPqESlcPUYUkY2Ym5vCh+whroVHF8Rd6y4p52IVjUMUbu9e
   0amNcFSJOhvj85skw7qleFvSaVZ4BCN0wH28h2nYPaNGHB9MIwx/YxWqL
   E=;
IronPort-SDR: ThslYJIJxZskwfFoH+ycSHGUJsTkBM2WOkghCFZ5A3qX7KhydYeD7ap23+FoEaK9akd4I6fDNq
 NBeb2cTkDWNA==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="31793713"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 09:12:35 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id C4B09A25B1;
        Fri, 22 May 2020 09:12:34 +0000 (UTC)
Received: from EX13D02UWB001.ant.amazon.com (10.43.161.240) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB001.ant.amazon.com (10.43.161.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:15 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:12:11 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 13/14] net: ena: cosmetic: minor code changes
Date:   Fri, 22 May 2020 12:09:04 +0300
Message-ID: <1590138545-501-14-git-send-email-akiyano@amazon.com>
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
index a014f514c069..ec8ea25e988d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -584,10 +584,10 @@ int ena_com_add_single_rx_desc(struct ena_com_io_sq *io_sq,
 
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

