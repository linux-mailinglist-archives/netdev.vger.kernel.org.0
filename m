Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0333E2CEDD4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgLDMMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:12:33 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:38431 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730195AbgLDMMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083950; x=1638619950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OT2Fetwz5YeBn0JhFixPRL5++J1V2T4nghyiPlaLAb8=;
  b=G0v9aUH1vKNzIWDte6LZCbJRBec+GLo8H7E/rwM0KcT2uyxz6z/Ii5pT
   QdkzvjD1sywX0KefV1lcgrqhsBadzpqnayLqdHLSYvzMmvRY5N82Uw64I
   B3BpLEWXHgxSiv7RjB0Kmw+CJgzsbA/z/ff411/5WoEWt+8xOuD0WfBfZ
   0=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="67327444"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 04 Dec 2020 12:11:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id 89436A2271;
        Fri,  4 Dec 2020 12:11:42 +0000 (UTC)
Received: from EX13D02UWC001.ant.amazon.com (10.43.162.243) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC001.ant.amazon.com (10.43.162.243) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:37 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:11:32 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Ido Segev <idose@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V4 net-next 3/9] net: ena: add explicit casting to variables
Date:   Fri, 4 Dec 2020 14:11:09 +0200
Message-ID: <1607083875-32134-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
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
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
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

