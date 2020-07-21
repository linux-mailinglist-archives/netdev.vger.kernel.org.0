Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7B22811C
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgGUNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:39:13 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:45123 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgGUNjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338753; x=1626874753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=aV+cx+hQ/zyaFEXUvRVkrbeG0C3Vnen5QaW8dROhyV8=;
  b=D0Y7Omt+/5AgQ2C7b9H7mIjyGx+BqpwwPviKStows8RiPttzeqR3HkPD
   sZ27oDpwYO/c4P9epMkOWZPajXA/cCvyEx6PytbOikO0tqDkvUdoH3yLj
   iYf9alsgv/AeKbsYO/xOokvvVLvZJm5bOnbCvIRiIhIoXmWF7IOxb4GgB
   M=;
IronPort-SDR: rGKCdslLhDlCQeMCmfIVVj7pMpSEXUBjxfcmIP906DpFL4lzURbSmeDSeQR5M/UzG5B2VEQCI/
 +ikCblNHFG8w==
X-IronPort-AV: E=Sophos;i="5.75,378,1589241600"; 
   d="scan'208";a="44633563"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jul 2020 13:39:12 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 7D3BCA229A;
        Tue, 21 Jul 2020 13:39:11 +0000 (UTC)
Received: from EX13d09UWA001.ant.amazon.com (10.43.160.247) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:49 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA001.ant.amazon.com (10.43.160.247) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:49 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:38:44 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 4/8] net: ena: cosmetic: change ena_com_stats_admin stats to u64
Date:   Tue, 21 Jul 2020 16:38:07 +0300
Message-ID: <1595338691-3130-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

The size of the admin statistics in ena_com_stats_admin is changed
from 32bit to 64bit so to align with the sizes of the other statistics
in the driver (i.e. rx_stats, tx_stats and ena_stats_dev).

This is done as part of an effort to create a unified API to read
statistics.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.h     | 10 +++++-----
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index bc187adf54e4..4c98f6f07882 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -230,11 +230,11 @@ struct ena_com_admin_sq {
 };
 
 struct ena_com_stats_admin {
-	u32 aborted_cmd;
-	u32 submitted_cmd;
-	u32 completed_cmd;
-	u32 out_of_space;
-	u32 no_completion;
+	u64 aborted_cmd;
+	u64 submitted_cmd;
+	u64 completed_cmd;
+	u64 out_of_space;
+	u64 no_completion;
 };
 
 struct ena_com_admin_queue {
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index e340b65af08c..430275bc0d04 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -164,13 +164,13 @@ static void ena_queue_stats(struct ena_adapter *adapter, u64 **data)
 static void ena_dev_admin_queue_stats(struct ena_adapter *adapter, u64 **data)
 {
 	const struct ena_stats *ena_stats;
-	u32 *ptr;
+	u64 *ptr;
 	int i;
 
 	for (i = 0; i < ENA_STATS_ARRAY_ENA_COM; i++) {
 		ena_stats = &ena_stats_ena_com_strings[i];
 
-		ptr = (u32 *)((uintptr_t)&adapter->ena_dev->admin_queue.stats +
+		ptr = (u64 *)((uintptr_t)&adapter->ena_dev->admin_queue.stats +
 			(uintptr_t)ena_stats->stat_offset);
 
 		*(*data)++ = *ptr;
-- 
2.23.3

