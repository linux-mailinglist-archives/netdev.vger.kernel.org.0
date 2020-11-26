Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6812C5D76
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 22:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387635AbgKZVUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 16:20:44 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:41062 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgKZVUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 16:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606425642; x=1637961642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OT2Fetwz5YeBn0JhFixPRL5++J1V2T4nghyiPlaLAb8=;
  b=vZOKn1HCjpL/zyzq2uy80bPNzCzxpOU5t0TLAZZAHWy6KJmu6MAW5EqI
   b/EmT/kVbulBjctDfgeLx8NGWd1eGukcgpNCwzskXK/HAifud+nHmku/j
   KADM7a57vEw22tlK4OM7QubW59kgq1FwVPI9X9ds9ULjD1l93QGaI2czo
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,373,1599523200"; 
   d="scan'208";a="91291299"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 26 Nov 2020 21:20:36 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id AA470141606;
        Thu, 26 Nov 2020 21:20:36 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:35 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 26 Nov 2020 21:20:35 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.20) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 26 Nov 2020 21:20:31 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Ido Segev <idose@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [RFC PATCH V2 net-next 3/9] net: ena: add explicit casting to variables
Date:   Thu, 26 Nov 2020 23:20:11 +0200
Message-ID: <1606425617-13112-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
References: <1606425617-13112-1-git-send-email-akiyano@amazon.com>
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

