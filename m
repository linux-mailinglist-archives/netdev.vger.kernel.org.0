Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674FB487DA4
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiAGUYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:06 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:34026 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiAGUYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587046; x=1673123046;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QzbfCNmNZlnk4k8sOJRMyNi5fIyMKRSbvzjNBXONh2w=;
  b=YvzkGyoeWb/l77bjuXuzl3v8pQGxOpayaekpa1LHwTwj/6Yrxkn17SR0
   1qKxgu5vPAU/5kYpcl1RwYO0KGgIhRhccv1SFRdSS2CMu7yNWhfXFJDAp
   e2zAX0JkoEgEDLJeTV/6LKahwbOzrB/4X5XshS8NC4YJAzMydX96kut/K
   A=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="185624855"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 07 Jan 2022 20:23:53 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1box-d-74e80b3c.us-east-1.amazon.com (Postfix) with ESMTPS id 7F04086319;
        Fri,  7 Jan 2022 20:23:51 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:23:50 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:23:50 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:23:49 +0000
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
Subject: [PATCH V2 net-next 00/10] ENA: capabilities field and cosmetic changes
Date:   Fri, 7 Jan 2022 20:23:36 +0000
Message-ID: <20220107202346.3522-1-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


V2 Changes
----------
Fixed "mixing different enum types" warning in patch
10/10 "net: ena: Extract recurring driver reset code into a function"


Original Cover Letter
---------------------
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
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  24 ++--
 7 files changed, 95 insertions(+), 102 deletions(-)

-- 
2.32.0

