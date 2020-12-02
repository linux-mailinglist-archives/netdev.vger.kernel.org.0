Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610842CC7DC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgLBUdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:33:13 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:3309 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgLBUdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606941191; x=1638477191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OT2Fetwz5YeBn0JhFixPRL5++J1V2T4nghyiPlaLAb8=;
  b=vxEYYgltXk8RgxJrrM9Qs7J+WLLYgiUbm4zd/DxSGxGRCWPPRRTong+R
   Rh873y9q2xl0+IOJgC/uWFJAIMS5Gk+ibN/eEb0nIpYVjKI0ir7+p8rUR
   KYFXca3aSuiOjoQI/oD/KAdl2Zj5unT6J0K2Xw/lmOEyy3BzLMVDZNo/F
   4=;
X-IronPort-AV: E=Sophos;i="5.78,387,1599523200"; 
   d="scan'208";a="67271831"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 02 Dec 2020 20:04:34 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 00156A1F62;
        Wed,  2 Dec 2020 20:04:02 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:03:47 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:03:47 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.23) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Dec 2020 20:03:44 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Ido Segev <idose@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V3 net-next 3/9] net: ena: add explicit casting to variables
Date:   Wed, 2 Dec 2020 22:03:24 +0200
Message-ID: <1606939410-26718-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
References: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
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

