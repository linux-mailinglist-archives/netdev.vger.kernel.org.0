Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927152C4B13
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgKYWwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:52:32 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:2189 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgKYWwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:52:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606344751; x=1637880751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=aKwQFZ+sZo5wxNL24zhilgpE5sVBnqRmAQAnuXC4udQ=;
  b=CwpGrq6rt89uUm+0olSRvFDvzf20M0xhA8DHlznbIZUn6C0FtYrHJ3gI
   +U0oxzmYRNX90DJxCBnHEtmMW8g+b5qqjGMQ1qfdxUKLAFwXzzMq9IetN
   Ufi45d+cy/xWSAcsmI2DWLQG99CBwjz/dgOL0F248Pjz+ZKCPxnip+N0S
   s=;
X-IronPort-AV: E=Sophos;i="5.78,370,1599523200"; 
   d="scan'208";a="99281230"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 25 Nov 2020 22:52:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 2E14FA1D86;
        Wed, 25 Nov 2020 22:52:23 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:10 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:10 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.33) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 25 Nov 2020 22:52:05 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Ido Segev <idose@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V1 net-next 3/9] net: ena: add explicit casting to variables
Date:   Thu, 26 Nov 2020 00:51:42 +0200
Message-ID: <1606344708-11100-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
References: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This patch adds explicit casting to some implicit conversions in the ena
driver. The implicit conversions fail some of our static checkers that
search for accidental conversions in our driver.
Adding this cast won't affect the end results, and would sooth the
checkers.

Signed-off-by: Ido Segev <idose@amazon.com>
Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index e168edf3c930..7910d8e68a99 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1369,7 +1369,7 @@ int ena_com_execute_admin_command(struct ena_com_admin_queue *admin_queue,
 				   "Failed to submit command [%ld]\n",
 				   PTR_ERR(comp_ctx));
 
-		return PTR_ERR(comp_ctx);
+		return (int)PTR_ERR(comp_ctx);
 	}
 
 	ret = ena_com_wait_and_process_admin_cq(comp_ctx, admin_queue);
@@ -1595,7 +1595,7 @@ int ena_com_set_aenq_config(struct ena_com_dev *ena_dev, u32 groups_flag)
 int ena_com_get_dma_width(struct ena_com_dev *ena_dev)
 {
 	u32 caps = ena_com_reg_bar_read32(ena_dev, ENA_REGS_CAPS_OFF);
-	int width;
+	u32 width;
 
 	if (unlikely(caps == ENA_MMIO_READ_TIMEOUT)) {
 		netdev_err(ena_dev->net_device, "Reg read timeout occurred\n");
@@ -2266,7 +2266,7 @@ int ena_com_set_dev_mtu(struct ena_com_dev *ena_dev, int mtu)
 	cmd.aq_common_descriptor.opcode = ENA_ADMIN_SET_FEATURE;
 	cmd.aq_common_descriptor.flags = 0;
 	cmd.feat_common.feature_id = ENA_ADMIN_MTU;
-	cmd.u.mtu.mtu = mtu;
+	cmd.u.mtu.mtu = (u32)mtu;
 
 	ret = ena_com_execute_admin_command(admin_queue,
 					    (struct ena_admin_aq_entry *)&cmd,
@@ -2689,7 +2689,7 @@ int ena_com_indirect_table_set(struct ena_com_dev *ena_dev)
 		return ret;
 	}
 
-	cmd.control_buffer.length = (1ULL << rss->tbl_log_size) *
+	cmd.control_buffer.length = (u32)(1ULL << rss->tbl_log_size) *
 		sizeof(struct ena_admin_rss_ind_table_entry);
 
 	ret = ena_com_execute_admin_command(admin_queue,
@@ -2712,7 +2712,7 @@ int ena_com_indirect_table_get(struct ena_com_dev *ena_dev, u32 *ind_tbl)
 	u32 tbl_size;
 	int i, rc;
 
-	tbl_size = (1ULL << rss->tbl_log_size) *
+	tbl_size = (u32)(1ULL << rss->tbl_log_size) *
 		sizeof(struct ena_admin_rss_ind_table_entry);
 
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
-- 
2.23.3

