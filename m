Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC787486A80
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243345AbiAFT3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:29:49 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:32532 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243335AbiAFT3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497384; x=1673033384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JmaQ4scJHwdz6+kr1DL3wasatFQCLRfv7ESwyTdrz1k=;
  b=SjUwcUIn9uihwEeLNETR0eJkIrm9LZn6kiYxImQUt5vgSTjbrdWdNOjJ
   XlVlAjIoxELqLwSra4L6P42SfULbbYdOpEplDYhwuAEdf1YlQOIqgcLel
   ARJHnlvo+yAzG67PFIG2tZGvp2SVGJjMALqW5U+BRCI3hiMYNx/YmE8MG
   M=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="982817146"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 06 Jan 2022 19:29:37 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 4939342FE3;
        Thu,  6 Jan 2022 19:29:37 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:34 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:33 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:31 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V1 net-next 04/10] net: ena: Update LLQ header length in ena documentation
Date:   Thu, 6 Jan 2022 19:29:09 +0000
Message-ID: <20220106192915.22616-5-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106192915.22616-1-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LLQ entry length is 128 bytes. Therefore the maximum header in
the entry is calculated by:
tx_max_header_size =
LLQ_ENTRY_SIZE - DESCRIPTORS_NUM_BEFORE_HEADER * 16 =
128 - 2 * 16 = 96

This patch updates the documentation so that it states the correct
max header length.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 Documentation/networking/device_drivers/ethernet/amazon/ena.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 01b2a69b0cb0..8bcb173e0353 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -135,7 +135,7 @@ The ENA driver supports two Queue Operation modes for Tx SQs:
 
 - **Low Latency Queue (LLQ) mode or "push-mode":**
   In this mode the driver pushes the transmit descriptors and the
-  first 128 bytes of the packet directly to the ENA device memory
+  first 96 bytes of the packet directly to the ENA device memory
   space. The rest of the packet payload is fetched by the
   device. For this operation mode, the driver uses a dedicated PCI
   device memory BAR, which is mapped with write-combine capability.
-- 
2.32.0

