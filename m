Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1C21CBE7
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgGLWgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:36:55 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53825 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgGLWgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594593415; x=1626129415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=I1EXQH9CiUyWUydEvxILKN+0gD3ihJKndMwqfT1zaqg=;
  b=i5HmqudL3Dp9xDcYfPZ3ycCs+aq/k9Ft5wDEHu1fg5Pppkz8fAq+V0K3
   rg6QZhrKAr7jTHYUxwWEiQN6VBR5whAOAy+hqLQq826VMOfV0wH0+BKgm
   HqQc+pVZcLSMVzc3NqMhXcqeCusvEr4+Q/uwRGSE6u0NPGAcf0oBPYPjH
   s=;
IronPort-SDR: 4lPWZzB6KBTqr1DZcrWDy9XSr7AToYoHmt5RkIjk4Lk3T5Li+AIc32SnZhEmK13kPiYYPuLlnW
 cydzUoyNe2gQ==
X-IronPort-AV: E=Sophos;i="5.75,345,1589241600"; 
   d="scan'208";a="59141412"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Jul 2020 22:36:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 8EBE0A057B;
        Sun, 12 Jul 2020 22:36:52 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:38 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:38 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.5) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 22:36:33 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 4/7] net: ena: cosmetic: change ena_com_stats_admin stats to u64
Date:   Mon, 13 Jul 2020 01:36:08 +0300
Message-ID: <1594593371-14045-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
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
2.23.1

