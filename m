Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A42426274F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 08:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgIIGqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 02:46:34 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:23418 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgIIGqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 02:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599633993; x=1631169993;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=auNFh+4XzaLdVxLoW3Si7AcVbFFqz64CCNAbmq+ZEv0=;
  b=HavgI1ru5gwchqoljoT5VK7i4QFUnH0dGiSCnYtKK4S6IqqQXBHezQ5g
   EmXejXi3Spsp+jZSXyKocKYdaxQWoneXwSVQP/trA4PJW2IFrVHZ7TbMb
   /nK3XVkiXibrfk4L7wL2JafuwzLJE/kgNjLkx2x4eo4KXwJ41Ym6JHl28
   s=;
X-IronPort-AV: E=Sophos;i="5.76,408,1592870400"; 
   d="scan'208";a="52850039"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 09 Sep 2020 06:46:31 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 7646EA29C4;
        Wed,  9 Sep 2020 06:46:30 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 06:46:30 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 9 Sep 2020 06:46:29 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 9 Sep 2020 06:46:29 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id EE51A81B68; Wed,  9 Sep 2020 06:46:28 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 0/4] Enhance current features in ena driver
Date:   Wed, 9 Sep 2020 06:46:23 +0000
Message-ID: <20200909064627.30104-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This series adds the following:
* Exposes new device stats using ethtool.
* Adds and exposes the stats of xdp TX queues through ethtool.

V2: Drop the need for casting stat_offset
V1: Use unsigned long for pointer math instead of uintptr_t

Sameeh Jubran (4):
  net: ena: ethtool: convert stat_offset to 64 bit resolution
  net: ena: ethtool: Add new device statistics
  net: ena: ethtool: add stats printing to XDP queues
  net: ena: xdp: add queue counters for xdp actions

 drivers/net/ethernet/amazon/ena/ena_admin_defs.h |  37 ++++-
 drivers/net/ethernet/amazon/ena/ena_com.c        |  19 ++-
 drivers/net/ethernet/amazon/ena/ena_com.h        |   9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    | 172 +++++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  45 +++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |   9 ++
 6 files changed, 236 insertions(+), 55 deletions(-)

-- 
2.16.6

