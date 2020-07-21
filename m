Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21E3228113
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGUNic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:38:32 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:44856 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgGUNib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338712; x=1626874712;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=L9o2tY2bx9qJj5DazXdRvZ/5f5QfziJvRG2+QgkCtyk=;
  b=YAiSxba/5lt0fa0bpgusKjDoiUB3fovjo9y/bJTr35nWA/AGzVAxxJgp
   VtzrnTG5djKiBTxTJuaFD/xGKrD9Nh8Un0W6I3DOWiY87n+XL9ndlHLqg
   e8F/mwD74sG20WHiCBZ22C8pazePIcUOf+GwaWeP6yel21Q2hbWfO5A/K
   w=;
IronPort-SDR: +lQIiTLXKF10j3h/bRVO30dKtj26gBDX1yZWqkuSKCMR3dvOVzrvzZcBtI/lgmbzQX7iLhg0SZ
 sYl1fdI2fWRw==
X-IronPort-AV: E=Sophos;i="5.75,378,1589241600"; 
   d="scan'208";a="44633307"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jul 2020 13:38:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id DA012A2359;
        Tue, 21 Jul 2020 13:38:29 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:29 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:28 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:38:24 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 0/8] ENA driver new features
Date:   Tue, 21 Jul 2020 16:38:03 +0300
Message-ID: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

V4 changes:
-----------
Add smp_rmb() to "net: ena: avoid unnecessary rearming of interrupt
vector when busy-polling" to adhere to the linux kernel memory model,
and update the commit message accordingly.

V3 changes:
-----------
1. Add "net: ena: enable support of rss hash key and function
   changes" patch again, with more explanations why it should
   be in net-next in commit message.
2. Add synchronization considerations to "net: ena: avoid unnecessary
   rearming of interrupt vector when busy-polling"


V2 changes:
-----------
1. Update commit messages of 2 patches to be more verbose.
2. Remove "net: ena: enable support of rss hash key and function
   changes" patch. Will be resubmitted net.


V1 cover letter:
----------------
This patchset contains performance improvements, support for new devices
and functionality:

1. Support for upcoming ENA devices
2. Avoid unnecessary IRQ unmasking in busy poll to reduce interrupt rate
3. Enabling device support for RSS function and key manipulation
4. Support for NIC-based traffic mirroring (SPAN port)
5. Additional PCI device ID
6. Cosmetic changes

Arthur Kiyanovski (8):
  net: ena: avoid unnecessary rearming of interrupt vector when
    busy-polling
  net: ena: add reserved PCI device ID
  net: ena: cosmetic: satisfy gcc warning
  net: ena: cosmetic: change ena_com_stats_admin stats to u64
  net: ena: add support for traffic mirroring
  net: ena: enable support of rss hash key and function changes
  net: ena: move llq configuration from ena_probe to ena_device_init()
  net: ena: support new LLQ acceleration mode

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  47 ++++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  19 +-
 drivers/net/ethernet/amazon/ena/ena_com.h     |  13 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  51 +++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   3 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 178 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   3 +
 .../net/ethernet/amazon/ena/ena_pci_id_tbl.h  |   5 +
 9 files changed, 220 insertions(+), 103 deletions(-)

-- 
2.23.3

