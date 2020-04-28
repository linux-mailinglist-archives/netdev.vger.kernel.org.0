Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA96E1BB774
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgD1H1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:25063 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgD1H1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058865; x=1619594865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mAvHU2ojTTur1PSw64NTF05adIU5J6yj6S/1l3hNaps=;
  b=TdIUM1wVf69prPHzSXCZthd6yYCZT9H+sH3fK1Ya34vYTKSTzXP1ET2/
   m1aXUFTB4EFf21F0cZ6RSj9p34NyX28EUiaN0t6Hz5Pp/AXVlHJNR/0Cu
   +JRu1gXPS2RXadExZpeWFM6bVVpqAPpu+2HH3+HYupMbk+TrEIVyMgzek
   0=;
IronPort-SDR: AMQZh4+Qm/rR7s0A5JDj6nJnPxAq9KzblvNqZORdw3XfHtKkRTeOorGnceZ0lFUxZ0nBG3C93o
 ZzPQCRrzKd3Q==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="27727666"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 28 Apr 2020 07:27:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 1A89EA063D;
        Tue, 28 Apr 2020 07:27:32 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6527581DF2; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: [PATCH V2 net-next 09/13] net: ena: implement ena_com_get_admin_polling_mode()
Date:   Tue, 28 Apr 2020 07:27:22 +0000
Message-ID: <20200428072726.22247-10-sameehj@amazon.com>
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

From: Arthur Kiyanovski <akiyano@amazon.com>

Before this commit there was a function prototype named
ena_com_get_ena_admin_polling_mode() that was never implemented.

This commit:
1. Changes the name of the function by removing the redundant double "ena_" in it.
2. Adds an implementation to the function.
3. Fixes a typo in the description of the function.

Signed-off-by: Igor Chauskin <igorch@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 5 +++++
 drivers/net/ethernet/amazon/ena/ena_com.h | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index b51bf62af11b..b1ce95717de9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1659,6 +1659,11 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling)
 	ena_dev->admin_queue.polling = polling;
 }
 
+bool ena_com_get_admin_polling_mode(struct ena_com_dev *ena_dev)
+{
+	return ena_dev->admin_queue.polling;
+}
+
 void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
 					 bool polling)
 {
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index e2e2fd1dc820..94986cdc0b1a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -501,7 +501,7 @@ bool ena_com_get_admin_running_state(struct ena_com_dev *ena_dev);
  */
 void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
 
-/* ena_com_set_admin_polling_mode - Get the admin completion queue polling mode
+/* ena_com_get_admin_polling_mode - Get the admin completion queue polling mode
  * @ena_dev: ENA communication layer struct
  *
  * Get the admin completion mode.
@@ -511,7 +511,7 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
  *
  * @return state
  */
-bool ena_com_get_ena_admin_polling_mode(struct ena_com_dev *ena_dev);
+bool ena_com_get_admin_polling_mode(struct ena_com_dev *ena_dev);
 
 /* ena_com_set_admin_auto_polling_mode - Enable autoswitch to polling mode
  * @ena_dev: ENA communication layer struct
-- 
2.24.1.AMZN

