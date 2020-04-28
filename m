Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC031BB773
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgD1H1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:46 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:27819 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD1H1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058865; x=1619594865;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=owmsZ8zCmFqCQngUH2OueWDd4Iu6OCFWrO/MoPG+kyY=;
  b=g6NDNx4W4r7wsJ/Oi0Sxoozu2DDJ9kr3bB9+R9KZt0h+xLY8ubwt6D+j
   bKHnfEDj4Gs3+AlYiY21EVUF0EtSBFFhyw68ciukbuJI47SeYDLsr4lAL
   tUMPXG9O78q2gVRrK/413kE7M2v1svBI6kIL9qYDNraAkEpIiYoB9aC0K
   0=;
IronPort-SDR: 9+5f4E6CNL469meIK3BndslbCE5WYK1yfpgNpXGtV34a8f3YKDn05M4CfN+zWtdbD33ZT4zJwu
 ddqmMW07Nylw==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="29020926"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 28 Apr 2020 07:27:33 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 4C926A2154;
        Tue, 28 Apr 2020 07:27:31 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:30 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:30 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:30 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 499EA81C7F; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 00/13] Enhance current features in ena driver
Date:   Tue, 28 Apr 2020 07:27:13 +0000
Message-ID: <20200428072726.22247-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Difference from v1:
* reodered paches #01 and #02.
* dropped adding Rx/Tx drops to ethtool in patch #08

V1:
This patchset introduces the following:
* minor changes to RSS feature
* add total rx and tx drop counter
* add unmask_interrupt counter for ethtool statistics
* add missing implementation for ena_com_get_admin_polling_mode()
* some minor code clean-up and cosmetics
* use SHUTDOWN as reset reason when closing interface

Arthur Kiyanovski (6):
  net: ena: avoid unnecessary admin command when RSS function set fails
  net: ena: fix error returning in ena_com_get_hash_function()
  net: ena: change default RSS hash function to Toeplitz
  net: ena: implement ena_com_get_admin_polling_mode()
  net: ena: move llq configuration from ena_probe to ena_device_init()
  net: ena: cosmetic: extract code to ena_indirection_table_set()

Sameeh Jubran (7):
  net: ena: allow setting the hash function without changing the key
  net: ena: changes to RSS hash key allocation
  net: ena: remove code that does nothing
  net: ena: add unmask interrupts statistics to ethtool
  net: ena: add support for reporting of packet drops
  net: ena: use SHUTDOWN as reset reason when closing interface
  net: ena: cosmetic: remove unnecessary spaces and tabs in ena_com.h
    macros

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |   8 +
 drivers/net/ethernet/amazon/ena/ena_com.c     |  44 +++---
 drivers/net/ethernet/amazon/ena/ena_com.h     |  39 +++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  66 ++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 146 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   2 +
 6 files changed, 179 insertions(+), 126 deletions(-)

-- 
2.24.1.AMZN

