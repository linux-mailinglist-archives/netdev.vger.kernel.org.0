Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719F21B39D4
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgDVIQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:34 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:48073 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgDVIQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543393; x=1619079393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rv1boim1V/W2R7MmrerwQvYtSdIJCmL2YhBO6TycCs0=;
  b=jFSmVOmYvWJEYg1neB2S4C91OgUH50mERlBqPlbN+f7oSRpGKE5smNwn
   akp/inFgpVU+dnrajozux7ldusNUc1IyFEL/FMKtPooXbkeqX//yKc9n+
   bJp0iRyiSC0JRtVdWBZK+CqUCNTdBsNXnknt5wDzGMUDIMEZduzNEU1jq
   g=;
IronPort-SDR: 9lME4D/D54UBg7kqf6q0sFloFLmDC2zWfC3NrCnSLEziB+fzALftkZ4sgEp4nj1nNh4Cyl8zlS
 Aw39UWZO9DeQ==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="30371237"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Apr 2020 08:16:33 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 0CB87A1B59;
        Wed, 22 Apr 2020 08:16:32 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 8138F81D1C; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net-next 10/13] net: ena: use SHUTDOWN as reset reason when closing interface
Date:   Wed, 22 Apr 2020 08:16:25 +0000
Message-ID: <20200422081628.8103-11-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
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

