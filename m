Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766A214CC01
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgA2OEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:04:30 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:41315 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgA2OE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580306669; x=1611842669;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bvNU1cXJeMKiSafAER1twu4gcvV5rbCLJQTEi7RpvX0=;
  b=gt6n8i8mQWC0bnEQLNuOXId21VtJJwUMVL2ctgZfKiupVJePjLEu+wum
   D4bJP3vgyAECt0Ap4xSL8MssBzc2HVrsEm7vXgljtDmk9uTX+3yz6wb9q
   LHBWRU3O114rHh39tWg0u13hQleOvwwA31J0PeZu32eWcbaneGZCyqjHw
   E=;
IronPort-SDR: s2oiNl476rOfOfC5dTVveEGO6mzx94FE9ji2WUKVdCCKCiNpsYQqCdqPUHJ60tDydoKLOw3QMw
 ZISwn9Qy7Icg==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="15296949"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 29 Jan 2020 14:04:26 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id BBF3E283183;
        Wed, 29 Jan 2020 14:04:25 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:25 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 14:04:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 Jan 2020 14:04:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 9589B81CF0; Wed, 29 Jan 2020 14:04:24 +0000 (UTC)
From:   Sameeh Jubran <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 00/11] Bug fixes for ENA Ethernet driver
Date:   Wed, 29 Jan 2020 14:04:11 +0000
Message-ID: <20200129140422.20166-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series include multiple bug fixes for the ena driver,
please review.

Arthur Kiyanovski (10):
  net: ena: fix potential crash when rxfh key is NULL
  net: ena: fix uses of round_jiffies()
  net: ena: add missing ethtool TX timestamping indication
  net: ena: fix incorrect default RSS key
  net: ena: rss: store hash function as values and not bits
  net: ena: rss: fix failure to get indirection table
  net: ena: fix incorrectly saving queue numbers when setting RSS
    indirection table
  net: ena: fix corruption of dev_idx_to_host_tbl
  net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE
  net: ena: ena-com.c: prevent NULL pointer dereference

Sameeh Jubran (1):
  net: ena: ethtool: use correct value for crc32 hash

 drivers/net/ethernet/amazon/ena/ena_com.c     | 109 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  31 ++++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  90 +++++++++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   2 +
 5 files changed, 160 insertions(+), 78 deletions(-)

-- 
2.24.1.AMZN

