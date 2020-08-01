Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953692352B4
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgHAOVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 10:21:39 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54587 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgHAOVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 10:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596291697; x=1627827697;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=AM3hBE6sbYboem44nWSXIbzJhU1thANu5JCUp8DULEk=;
  b=hwYZ6QEMIPkehUcsEjrHaPMnv1DNDzghFHbfu4/UHb7//UBQM146Tdbp
   bticl/AB5K3YYFRJ28UPILbuv6wc8YPtymkOpoaRxIUGlUC7bLpzzFr50
   bpnhkdxXW4ru3ror+tAemsgVrztPzaanTSMENiD2iulSEwHkzdJsjb7s8
   o=;
IronPort-SDR: BOAiWav8xo8KwtKbPPupwUz/fBfJgUvTNyWeOsE6WABzoc7xzXqXe5bWJG/D0aKErhBI6b86Wi
 LTcfdOjoxXfg==
X-IronPort-AV: E=Sophos;i="5.75,422,1589241600"; 
   d="scan'208";a="63479520"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 01 Aug 2020 14:21:34 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id A16A6A204B;
        Sat,  1 Aug 2020 14:21:33 +0000 (UTC)
Received: from EX13d09UWA004.ant.amazon.com (10.43.160.158) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 Aug 2020 14:21:33 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA004.ant.amazon.com (10.43.160.158) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 1 Aug 2020 14:21:33 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sat, 1 Aug 2020 14:21:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 4F40C81CE8; Sat,  1 Aug 2020 14:21:32 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 0/3] Enhance current features in ena driver
Date:   Sat, 1 Aug 2020 14:21:27 +0000
Message-ID: <20200801142130.6537-1-sameehj@amazon.com>
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

Sameeh Jubran (3):
  net: ena: ethtool: Add new device statistics
  net: ena: ethtool: add stats printing to XDP queues
  net: ena: xdp: add queue counters for xdp actions

 drivers/net/ethernet/amazon/ena/ena_admin_defs.h |  37 +++++-
 drivers/net/ethernet/amazon/ena/ena_com.c        |  19 ++-
 drivers/net/ethernet/amazon/ena/ena_com.h        |   9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c    | 158 +++++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  45 ++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h     |   9 ++
 6 files changed, 230 insertions(+), 47 deletions(-)

-- 
2.16.6

