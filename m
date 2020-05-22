Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4897C1DE2AF
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgEVJMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:19 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:37898 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgEVJMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138738; x=1621674738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=BzYgylYU3tapZQQfjpZbfRvk6xkKM2YwiCthmhGd2Cc=;
  b=ndYGaZ2ecNy/MkZWkF0jnBlirXCUknbyp/tSG0SKj8rIYJFpW+5cxer6
   ZZDRNTTSSe6XjCS1HFXKXjoZ2gb5/uq7BXOEc1w1eoHCuLCPsC56holl5
   hq0aky3O3BFcQQnVkWc98SoKu34brLus0+cS/elrVNChiOu96bv9Okhs3
   I=;
IronPort-SDR: qeSK8OAvjAsT0zt5LatJSFt42fducVNDzY662Dl5FZUSXkdEiXUp7ehLZzSRz3uAIBorCBXDZ2
 Co4H6MdNZ9XQ==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="31793543"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 May 2020 09:12:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 3F1E4A2853;
        Fri, 22 May 2020 09:12:02 +0000 (UTC)
Received: from EX13D02UWB002.ant.amazon.com (10.43.161.160) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB002.ant.amazon.com (10.43.161.160) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:45 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:41 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 07/14] net: ena: cosmetic: set queue sizes to u32 for consistency
Date:   Fri, 22 May 2020 12:08:58 +0300
Message-ID: <1590138545-501-8-git-send-email-akiyano@amazon.com>
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

