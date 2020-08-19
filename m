Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B604824A058
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgHSNpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 09:45:55 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:15732 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbgHSNoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 09:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597844661; x=1629380661;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=CsYjShdzmZ5D7Eb4dalq4Q5lFeEzadPPyW5FmFvVhRk=;
  b=r8LhxPOGWHptp6tfaRYMeZlMs5/LUxH6sOeG1UphB2ukVcWWIq2owP2F
   nD3w7TDFeXBzK89OhDlF40H2UpPIUGGtMNK9aqZqM6x6xNxtRqFpLRVHc
   eUXxfyJMxWeT/oXA4Fho4/Bg+eZtvGEjIQLzR7yhb5816+bmcj13ANcQ3
   c=;
X-IronPort-AV: E=Sophos;i="5.76,331,1592870400"; 
   d="scan'208";a="48706736"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Aug 2020 13:44:04 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 84BB8A0520;
        Wed, 19 Aug 2020 13:44:03 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 13:44:03 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 13:44:02 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 19 Aug 2020 13:44:02 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6374C819EC; Wed, 19 Aug 2020 13:44:02 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 0/4] Enhance current features in ena driver
Date:   Wed, 19 Aug 2020 13:43:45 +0000
Message-ID: <20200819134349.22129-1-sameehj@amazon.com>
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

V1: Use unsigned long for pointer math instead of uintptr_t

Sameeh Jubran (4):
  net: ena: ethtool: use unsigned long for pointer arithmetics
  net: ena: ethtool: Add new device statistics
  net: ena: ethtool: add stats printing to XDP queues
  net: ena: xdp: add queue counters for xdp actions

 drivers/net/ethernet/amazon/ena/ena_admin_defs.h |  37 ++++-
 drivers/net/ethernet/amazon/ena/ena_com.c        |  19 ++-
 drivers/net/ethernet/amazon/ena/ena_com.h        |   9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    | 170 +++++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  45 +++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |   9 ++
 6 files changed, 236 insertions(+), 53 deletions(-)

-- 
2.16.6

