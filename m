Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339CA21CBE4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGLWgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:36:32 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:17580 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLWgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594593392; x=1626129392;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=tDMZzmH2plQZzI5ssfb0Mxm+xSaBDGv3Q++AjfNdf3U=;
  b=o1YueUVLYAf75l0mgT0xYOltapavJCLR9ebIdxoeBFVns8uhfBSG5q0u
   o5oC484eSlxH9ST4gBjHctAJsI0wt2OaFb+R66NMM7O04O63ZiVuEdz9W
   Fvc28EAeDTD0OZLhglJtAqsftlKo/sKbAHLQjZQFaELylmKK+unXFiNbW
   s=;
IronPort-SDR: RYiqxoqp6wFTOHOjcsS2eop28wy2Elso1V9EmZ6qr+31GeY889JUFlESREHBcRb1slm4d/sNNP
 txHwU0efzHVA==
X-IronPort-AV: E=Sophos;i="5.75,345,1589241600"; 
   d="scan'208";a="42808968"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Jul 2020 22:36:20 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 0F066A1CB3;
        Sun, 12 Jul 2020 22:36:19 +0000 (UTC)
Received: from EX13D10UWA001.ant.amazon.com (10.43.160.216) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:18 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA001.ant.amazon.com (10.43.160.216) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:18 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.5) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 22:36:13 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 0/7] ENA driver new features
Date:   Mon, 13 Jul 2020 01:36:04 +0300
Message-ID: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>


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

Arthur Kiyanovski (7):
  net: ena: avoid unnecessary rearming of interrupt vector when
    busy-polling
  net: ena: add reserved PCI device ID
  net: ena: cosmetic: satisfy gcc warning
  net: ena: cosmetic: change ena_com_stats_admin stats to u64
  net: ena: add support for traffic mirroring
  net: ena: move llq configuration from ena_probe to ena_device_init()
  net: ena: support new LLQ acceleration mode

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  44 ++++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  19 +-
 drivers/net/ethernet/amazon/ena/ena_com.h     |  13 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  51 +++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   3 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 176 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   3 +
 .../net/ethernet/amazon/ena/ena_pci_id_tbl.h  |   5 +
 9 files changed, 215 insertions(+), 103 deletions(-)

-- 
2.23.1

