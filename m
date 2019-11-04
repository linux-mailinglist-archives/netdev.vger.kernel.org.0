Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A924BEDF6C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 12:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDL7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 06:59:07 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:29639 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKDL7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 06:59:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1572868746; x=1604404746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rjVP3LL18mK9Hsw2nDp1wiarQRljfWax3caBurTMu7o=;
  b=EwGHyVpP43tCsh/omObJHP1fHI+bdxNU+w5LWInqvFZZuFlfDeQuzixB
   4TRhXOcMt7aLyFPHI4kYx08mZPj61Ius2Q+dNvKKdv5hHctZnD/E7bvp4
   nm8iRtJayM8GahsQ28ax/T9bkEEPpGfv9oGwk1rIeljXMTpLxsCCihkE2
   E=;
IronPort-SDR: auWPcOqgmSecrcAFcdbm0YguRYEfPSnXlXQIAobYTHDFzYo5fsHsqnGqE8ivwk214VoETW/Ygd
 TaK6ld2j0U5g==
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 04 Nov 2019 11:59:05 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id C5778A1DD5;
        Mon,  4 Nov 2019 11:59:04 +0000 (UTC)
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 4 Nov 2019 11:59:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 4 Nov 2019 11:59:02 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.87) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 4 Nov 2019 11:58:59 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>
Subject: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt moderation interval
Date:   Mon, 4 Nov 2019 13:58:48 +0200
Message-ID: <1572868728-5211-3-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
References: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Current default non-adaptive tx interrupt moderation interval is 196 us.
This commit sets it to 0, which is much more sensible as a default value.
It can be modified using ethtool -C.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 7c941eba0bc9..164c45c04867 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -72,7 +72,7 @@
 /*****************************************************************************/
 /* ENA adaptive interrupt moderation settings */
 
-#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		196
+#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		0
 #define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
 #define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
 
-- 
2.17.1

