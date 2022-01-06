Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2D1486A7C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243325AbiAFT3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:29:36 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:33093 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243311AbiAFT3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641497375; x=1673033375;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GdZcw3+JrUQ4X9rIgCUpu3fmJVXpnc1HaLbOsnws5fQ=;
  b=CkpK4UEjwB2Nk2J/hGFZAEeQw9dq0aEu97IraooOioWrCm2w+qhQ1zly
   FJlHKkHtZa1M9Par9+7JUtWkNl3spaa49fSz1FaMhUyQw/zsytR1XMr/R
   D3o62fD9Yt7f7M0qVq8Y6WGqRP+TZ6Pjuhh2u4b29IXEXiSw2/5QlMfRi
   0=;
X-IronPort-AV: E=Sophos;i="5.88,267,1635206400"; 
   d="scan'208";a="53260780"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-1cb212d9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Jan 2022 19:29:22 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-1cb212d9.us-west-2.amazon.com (Postfix) with ESMTPS id A8171C09B1;
        Thu,  6 Jan 2022 19:29:21 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:20 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 6 Jan 2022 19:29:19 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Thu, 6 Jan 2022 19:29:17 +0000
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
Subject: [PATCH V1 net-next 00/10] ENA: capabilities field and cosmetic
Date:   Thu, 6 Jan 2022 19:29:05 +0000
Message-ID: <20220106192915.22616-1-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new capabilities bitmask field to get indication of
capabilities supported by the device. Use the capabilities
field to query the device for ENI stats support.

Other patches are cosmetic changes like fixing readme
mistakes, removing unused variables etc...

Arthur Kiyanovski (10):
  net: ena: Change return value of ena_calc_io_queue_size() to void
  net: ena: Add capabilities field with support for ENI stats capability
  net: ena: Change ENI stats support check to use capabilities field
  net: ena: Update LLQ header length in ena documentation
  net: ena: Remove redundant return code check
  net: ena: Move reset completion print to the reset function
  net: ena: Remove ena_calc_queue_size_ctx struct
  net: ena: Add debug prints for invalid req_id resets
  net: ena: Change the name of bad_csum variable
  net: ena: Extract recurring driver reset code into a function

 .../device_drivers/ethernet/amazon/ena.rst    |   2 +-
 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  10 +-
 drivers/net/ethernet/amazon/ena/ena_com.c     |   8 ++
 drivers/net/ethernet/amazon/ena/ena_com.h     |  13 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  15 ++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 125 +++++++-----------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  23 ++--
 7 files changed, 94 insertions(+), 102 deletions(-)

-- 
2.32.0

