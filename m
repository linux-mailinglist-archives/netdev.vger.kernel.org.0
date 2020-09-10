Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B08F2653BD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgIJVkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:40:01 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:23191 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730339AbgIJNHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 09:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599743245; x=1631279245;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=uP6m1zaP1goYm/3lPtOTDYan9fxKHTKsf0GmarhYNSc=;
  b=LPAWMCiJY/41cD6iUsDvNCUbtNx+7pNGMtJhNEOEW4NNvS0IuoKmWSXJ
   4Lc5jmPsDlaAMBveoucYB9w0hl8rCzCxa8PT3y0rjrTloPnPQoI3ck/Pt
   kvfDikxyN0lBzKgDVlieMAUm087Tu1EE9OoANSYAAxQBj2TBv+3AA/7KR
   g=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; 
   d="scan'208";a="53166171"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Sep 2020 13:07:24 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id C2DB0A206F;
        Thu, 10 Sep 2020 13:07:23 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 13:07:22 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 10 Sep 2020 13:07:22 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 1502E81BBC; Thu, 10 Sep 2020 13:07:22 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V4 net-next 0/4] Enhance current features in ena driver
Date:   Thu, 10 Sep 2020 13:07:09 +0000
Message-ID: <20200910130713.26074-1-sameehj@amazon.com>
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

V3: Fix indentation in patches #3 and #4
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
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    | 170 +++++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  39 +++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |   9 ++
 6 files changed, 232 insertions(+), 51 deletions(-)

-- 
2.16.6

