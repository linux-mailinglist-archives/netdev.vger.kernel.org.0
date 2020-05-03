Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FF51C2B03
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgECJwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:32 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:17577 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbgECJw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499549; x=1620035549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rv1boim1V/W2R7MmrerwQvYtSdIJCmL2YhBO6TycCs0=;
  b=u/g9ggdCiDqA1BaBhQM0AoiHWyJTUkWOoB+h6IeAeVOx9I0OH2lbgHUW
   tFbUMdYguOOR0HiNxcrESUxVmTDRHloGxScPZ4liea7SmoMyvIP8JSr+b
   1TekN6BzCXjH6KXrvMZh6kTRkvDr8CCN8fXywqeEfVa2kqyF9N9SDZVzW
   Y=;
IronPort-SDR: WZ5db8/M9I0HEdAASrxtnUYDEFstEkc4bXT8k/PFr577vI5fXe6XM6gKKS5fInrv7P3QH7/mCC
 zjsxrwGL1/jA==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="42280417"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 May 2020 09:52:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id D6845A06A8;
        Sun,  3 May 2020 09:52:24 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 85AC581F28; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V3 net-next 10/12] net: ena: use SHUTDOWN as reset reason when closing interface
Date:   Sun, 3 May 2020 09:52:19 +0000
Message-ID: <20200503095221.6408-11-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200503095221.6408-1-sameehj@amazon.com>
References: <20200503095221.6408-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The 'ENA_REGS_RESET_SHUTDOWN' enum indicates a normal driver
shutdown / removal procedure.

Also, a comment is added to one of the reset reason assignments for
code clarity.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 517681319a57..2818965427e9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3439,6 +3439,7 @@ static void ena_destroy_device(struct ena_adapter *adapter, bool graceful)
 
 	ena_com_mmio_reg_read_request_destroy(ena_dev);
 
+	/* return reset reason to default value */
 	adapter->reset_reason = ENA_REGS_RESET_NORMAL;
 
 	clear_bit(ENA_FLAG_TRIGGER_RESET, &adapter->flags);
@@ -4362,6 +4363,7 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 	cancel_work_sync(&adapter->reset_task);
 
 	rtnl_lock(); /* lock released inside the below if-else block */
+	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
 	ena_destroy_device(adapter, true);
 	if (shutdown) {
 		netif_device_detach(netdev);
-- 
2.24.1.AMZN

