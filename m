Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A41DD6BC
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgEUTJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:53 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13580 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbgEUTJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088190; x=1621624190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=BzYgylYU3tapZQQfjpZbfRvk6xkKM2YwiCthmhGd2Cc=;
  b=mR069Dj007UHsUrlSSYmouqBDz/5Xs+ZZNDh50vzt2s3T5PaHCicZStd
   JDtwiZSWMzC78KvFnSu2qUuYKdnGhEkOL4iIJk8B3Z1ciA2YkLpKB096i
   PRYORsm4jcMZFOxneOwYRTnvAaJIU8uXdCSQY/uImd9eusE55bkuTk2Tt
   4=;
IronPort-SDR: Iu3WdvpOH1RHsVODxk7k56t0iZxjUj9ZfecXCKczrMoRQs9k8PV2BlxLiqnW/cc5QOh5ASinUN
 EJqBZ/hfzvpw==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="31646400"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 May 2020 19:09:34 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 3BBEFA17DF;
        Thu, 21 May 2020 19:09:33 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:04 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:09:01 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 08/15] net: ena: cosmetic: set queue sizes to u32 for consistency
Date:   Thu, 21 May 2020 22:08:27 +0300
Message-ID: <1590088114-381-9-git-send-email-akiyano@amazon.com>
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

Make all types of variables that convey the number and sizeof queues to
be u32, for consistency with the API between the driver and device via
ena_admin_defs.h:ena_admin_get_feat_resp.max_queue_ext fields. Current
code sometimes uses int and there are multiple assignments between these
variables with different types.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index c3cbe48b353e..0999fe3310fb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3832,11 +3832,11 @@ static void ena_timer_service(struct timer_list *t)
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 }
 
-static int ena_calc_max_io_queue_num(struct pci_dev *pdev,
+static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 				     struct ena_com_dev *ena_dev,
 				     struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
-	int io_tx_sq_num, io_tx_cq_num, io_rx_num, max_num_io_queues;
+	u32 io_tx_sq_num, io_tx_cq_num, io_rx_num, max_num_io_queues;
 
 	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
 		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
-- 
2.23.1

