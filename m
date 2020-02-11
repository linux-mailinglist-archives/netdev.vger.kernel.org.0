Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7921F1592BE
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgBKPSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:18:10 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1963 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729635AbgBKPSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:18:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581434289; x=1612970289;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6+GUvri4wQ+Iif3C//8NMGu1Te2KejyVYpd0dfsYEl0=;
  b=LeKrke/rh2jBD1ClGsDMjTUT183VvGgmBgy/39+Rrcp48SebWzHXBS/e
   biPBma+GVFUfpaG+QODgyd3iI+88d9iq/PJX68LBmTusV+FprH+LkC1Qw
   hY3Xq7YGrLwKDTv4hNLARoK5ep0xCd6z+fkN3wcRNmxd/2vr6apidZEne
   A=;
IronPort-SDR: tTLFKKrh3SdlWtHa/EfXLI0G/tAmiRpzUta8P68HFXI7yCzm8OZW9G9aV0WUZhS0Y5AocRXyka
 V6tOTy08c1Yg==
X-IronPort-AV: E=Sophos;i="5.70,428,1574121600"; 
   d="scan'208";a="25719233"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Feb 2020 15:17:59 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id B8E98141707;
        Tue, 11 Feb 2020 15:17:57 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Feb 2020 15:17:56 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1236.3 via Frontend Transport; Tue, 11 Feb 2020 15:17:57 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 9EDE681CC4; Tue, 11 Feb 2020 15:17:56 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net 00/12] Bug fixes for ENA Ethernet driver
Date:   Tue, 11 Feb 2020 15:17:39 +0000
Message-ID: <20200211151751.29718-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Difference from V1:
* Started using netdev_rss_key_fill()
* Dropped superflous changes that are not related to bug fixes as
  requested by Jakub

Arthur Kiyanovski (9):
  net: ena: fix potential crash when rxfh key is NULL
  net: ena: fix uses of round_jiffies()
  net: ena: add missing ethtool TX timestamping indication
  net: ena: fix incorrect default RSS key
  net: ena: rss: store hash function as values and not bits
  net: ena: fix incorrectly saving queue numbers when setting RSS
    indirection table
  net: ena: fix corruption of dev_idx_to_host_tbl
  net: ena: make ena rxfh support ETH_RSS_HASH_NO_CHANGE
  net: ena: ena-com.c: prevent NULL pointer dereference

Sameeh Jubran (3):
  net: ena: rss: do not allocate key when not supported
  net: ena: rss: fix failure to get indirection table
  net: ena: ethtool: use correct value for crc32 hash

 drivers/net/ethernet/amazon/ena/ena_com.c     | 96 +++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_com.h     |  9 ++
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 46 ++++++++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 5 files changed, 115 insertions(+), 44 deletions(-)

-- 
2.24.1.AMZN

