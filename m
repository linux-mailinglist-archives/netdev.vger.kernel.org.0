Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC601C2B05
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgECJw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:17577 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgECJw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499548; x=1620035548;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dmvfnwY+mo9J94iXc0/GB0s654h1I2SX+w1A1EN7Go4=;
  b=GEm4KrI43pLDhRNmI0hrcBe+SRWobPmWTrdfNDyw0Ww3pwUB0e0VWGxd
   CT7AXhVvclPjBMelQLm2h7cBBDHOfLmn+fCZqy8jJ1svdpt2UR+9h1gv7
   l/1VXTsrBzhKgTRYTULfNTyfQoUBja17EsDCZV7rwRUmy3extEJxRvsvN
   U=;
IronPort-SDR: CSxXgQ19wU9cAMKw+MVGTcxC4WVwwZjTbiQ8a95gee+oc15odgCt9h/A1Z/K9yfDM/RdcK58Ng
 FUq/lejDiIWw==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="42280416"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 May 2020 09:52:26 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id B0ECFA1E4C;
        Sun,  3 May 2020 09:52:24 +0000 (UTC)
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:23 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:23 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 69DEF81C9E; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 00/12] Enhance current features in ena driver
Date:   Sun, 3 May 2020 09:52:09 +0000
Message-ID: <20200503095221.6408-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>


Difference from v2:
* dropped patch "net: ena: move llq configuration from ena_probe to ena_device_init()" 
* reworked patch ""net: ena: implement ena_com_get_admin_polling_mode() to drop the prototype

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

Arthur Kiyanovski (5):
  net: ena: avoid unnecessary admin command when RSS function set fails
  net: ena: fix error returning in ena_com_get_hash_function()
  net: ena: change default RSS hash function to Toeplitz
  net: ena: drop superfluous prototype
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

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  8 +++
 drivers/net/ethernet/amazon/ena/ena_com.c     | 39 ++++++-----
 drivers/net/ethernet/amazon/ena/ena_com.h     | 47 +++++++------
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 66 +++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 13 +++-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  2 +
 6 files changed, 105 insertions(+), 70 deletions(-)

-- 
2.24.1.AMZN

