Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB263B3E5
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 13:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbfFJLTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 07:19:32 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:23677 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388504AbfFJLTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 07:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560165571; x=1591701571;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=itQXS235Om063timwmBnvJOp+rNNpxug+hXxGoeAvp8=;
  b=CX/FrHKtmzQWCq612TYkNilub+CxnfpoDCzlq49V2fH4YPKGeamUM9gK
   na3Sr2c27NVdgwNRfh73Brzi8Ci6o23gJ3dxOdNoR5oaG17rGgW8Q9tBH
   I1YWsVKqzj6T6jGbYFR3XDf63ZhtTYhk/xIxC/aErAKaq37vTd8XGTkMB
   4=;
X-IronPort-AV: E=Sophos;i="5.60,575,1549929600"; 
   d="scan'208";a="809513971"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Jun 2019 11:19:24 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 5F7F6A1E63;
        Mon, 10 Jun 2019 11:19:24 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:24 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 11:19:23 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 10 Jun 2019 11:19:20 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 0/6] Support for dynamic queue size changes
Date:   Mon, 10 Jun 2019 14:19:12 +0300
Message-ID: <20190610111918.21397-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset introduces the following:
* add new admin command for supporting different queue size for Tx/Rx
* add support for Tx/Rx queues size modification through ethtool
* allow queues allocation backoff when low on memory
* update driver version

Difference from v1:
* Changed ena_update_queue_sizes() signature to use u32 instead of int
  type for the size arguments. [patch 5/6]

Arthur Kiyanovski (1):
  net: ena: add MAX_QUEUES_EXT get feature admin command

Sameeh Jubran (5):
  net: ena: enable negotiating larger Rx ring size
  net: ena: make ethtool show correct current and max queue sizes
  net: ena: allow queue allocation backoff when low on memory
  net: ena: add ethtool function for changing io queue sizes
  net: ena: update driver version from 2.0.3 to 2.1.0

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  56 +++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  76 +++--
 drivers/net/ethernet/amazon/ena/ena_com.h     |   3 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  35 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 303 +++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  28 +-
 6 files changed, 382 insertions(+), 119 deletions(-)

-- 
2.17.1

