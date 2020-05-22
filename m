Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647981DE2B0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgEVJMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:25 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13276 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgEVJMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138744; x=1621674744;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=zlvGxf8gB9Jua3jM6wE/EaOzCQCImutALB+wTGWPH6I=;
  b=FxhdNyPqqgVxLEoruu6Ukf0HEtNM2UPFXFLK8WPBDM3H6PO5LhuFVio8
   dKdk2pXbMQcOBpw1zs8hP5VDhs1uo3xX7pjZ3DNvZA3phzHqyQHvW8iql
   t0lrsw501oJiceoq+Qcs9H1a3sQe8Niwy06asQUIpThPQDIKYunBh8+S8
   U=;
IronPort-SDR: UMX5eS7BUI6cQD/6+SFhSxc8YasSaPaxF3pawRS+3aNhKzDOeWdQTqu/Y/mrkrvCuDgWHkpzMM
 3sJOwVLb/5cg==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="45268795"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 May 2020 09:12:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 269432823F7;
        Fri, 22 May 2020 09:12:22 +0000 (UTC)
Received: from EX13D02UWB004.ant.amazon.com (10.43.161.11) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB004.ant.amazon.com (10.43.161.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:06 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:12:01 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 11/14] net: ena: cosmetic: code reorderings
Date:   Fri, 22 May 2020 12:09:02 +0300
Message-ID: <1590138545-501-12-git-send-email-akiyano@amazon.com>
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

1. Reorder sanity checks in get_comp_ctxt() to make more sense
2. Reorder variables in ena_com_fill_hash_function() and
   ena_calc_io_queue_size() in reverse christmas tree.
3. Move around member initializations.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    | 17 +++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  5 ++---
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index a513d71576bd..bf3465e5a2e7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -200,17 +200,17 @@ static void comp_ctxt_release(struct ena_com_admin_queue *queue,
 static struct ena_comp_ctx *get_comp_ctxt(struct ena_com_admin_queue *queue,
 					  u16 command_id, bool capture)
 {
-	if (unlikely(!queue->comp_ctx)) {
-		pr_err("Completion context is NULL\n");
-		return NULL;
-	}
-
 	if (unlikely(command_id >= queue->q_depth)) {
 		pr_err("command id is larger than the queue size. cmd_id: %u queue size %d\n",
 		       command_id, queue->q_depth);
 		return NULL;
 	}
 
+	if (unlikely(!queue->comp_ctx)) {
+		pr_err("Completion context is NULL\n");
+		return NULL;
+	}
+
 	if (unlikely(queue->comp_ctx[command_id].occupied && capture)) {
 		pr_err("Completion context is occupied\n");
 		return NULL;
@@ -2266,13 +2266,14 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 			       enum ena_admin_hash_functions func,
 			       const u8 *key, u16 key_len, u32 init_val)
 {
-	struct ena_rss *rss = &ena_dev->rss;
+	struct ena_admin_feature_rss_flow_hash_control *hash_key;
 	struct ena_admin_get_feat_resp get_resp;
-	struct ena_admin_feature_rss_flow_hash_control *hash_key =
-		rss->hash_key;
 	enum ena_admin_hash_functions old_func;
+	struct ena_rss *rss = &ena_dev->rss;
 	int rc;
 
+	hash_key = rss->hash_key;
+
 	/* Make sure size is a mult of DWs */
 	if (unlikely(key_len & 0x3))
 		return -EINVAL;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 148d13cdd1bf..313e65b17492 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4121,8 +4121,8 @@ static int ena_calc_io_queue_size(struct ena_calc_queue_size_ctx *ctx)
  */
 static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_calc_queue_size_ctx calc_queue_ctx = { 0 };
+	struct ena_com_dev_get_features_ctx get_feat_ctx;
 	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
 	struct ena_adapter *adapter;
@@ -4233,12 +4233,11 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	adapter->num_io_queues = max_num_io_queues;
 	adapter->max_num_io_queues = max_num_io_queues;
+	adapter->last_monitored_tx_qid = 0;
 
 	adapter->xdp_first_ring = 0;
 	adapter->xdp_num_queues = 0;
 
-	adapter->last_monitored_tx_qid = 0;
-
 	adapter->rx_copybreak = ENA_DEFAULT_RX_COPYBREAK;
 	adapter->wd_state = wd_state;
 
-- 
2.23.1

