Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EF01BB770
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgD1H1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:36 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11676 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgD1H1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058855; x=1619594855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rv1boim1V/W2R7MmrerwQvYtSdIJCmL2YhBO6TycCs0=;
  b=B2QAx/avyQdC+r50gECE3F5kVPePUIaNso+pKs5PldhDp4iFWMeUKqoh
   l/qI8rJ/IWjaJ5prem6gJiL3mEmrtsON8XOWKH7/KJJ5feaUAqX2A+bI9
   679kmAcibkDs7HlwwSo0z0tr2KXYyhZAIyoqHMITUbKBbcY+5Ump6/K2E
   Y=;
IronPort-SDR: 3x3ZIvvnOrf+wNnRiKsk3u4au/v/3B0pQTUlk9xmcZxKuJXbqej0KWAzKAbUqgSjMsUTItrrvW
 FMz3o4Pw1rRQ==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="31563064"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Apr 2020 07:27:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 5116FA18D0;
        Tue, 28 Apr 2020 07:27:32 +0000 (UTC)
Received: from EX13d09UWC002.ant.amazon.com (10.43.162.102) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC002.ant.amazon.com (10.43.162.102) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6843581DFF; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V2 net-next 10/13] net: ena: use SHUTDOWN as reset reason when closing interface
Date:   Tue, 28 Apr 2020 07:27:23 +0000
Message-ID: <20200428072726.22247-11-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200428072726.22247-1-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
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

