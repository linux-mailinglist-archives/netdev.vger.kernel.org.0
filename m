Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF1B1DD6A7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgEUTIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:08:43 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:19938 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbgEUTIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088121; x=1621624121;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=SL+7fKq5Tuj4Vc9RwwpjbDamZ/XcRxIL7T6hg1WN7Kw=;
  b=EyHLKXwMZyrS951x/B4pL5Pb5DxZykGDBm670c0nIutnZSWnhBw7ksmN
   01Vgzr0YnAwl1vOY1Sj5qGALMbVM3PuLsB6+u5XUxgPQNoR/W0DHUYRTP
   8tBFaqjyzPPSn4cp92OW5nJUbZ34gxWKSQCtKpvGREjWBiCX6Jb05n7el
   E=;
IronPort-SDR: 4KD49vL3fJsn5b0Lpy/XtR4pXgaA1geJcrHPMVVwf1HUmOg9/qwEDpTW+ZzTpeL8dO8uoa62zI
 oR9hJKQhDB/A==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="36850931"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 May 2020 19:08:39 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 3B38BA1D78;
        Thu, 21 May 2020 19:08:39 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:38 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:08:38 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:35 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 00/15] ENA features and cosmetic changes
Date:   Thu, 21 May 2020 22:08:19 +0300
Message-ID: <1590088114-381-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This patchset includes:
1. new rx offset feature
2. reduction of the driver load time
3. error prints
4. multiple cosmetic changes to the code 

Arthur Kiyanovski (15):
  net: ena: add support for the rx offset feature
  net: ena: rename ena_com_free_desc to make API more uniform
  net: ena: use explicit variable size for clarity
  net: ena: fix ena_com_comp_status_to_errno() return value
  net: ena: add prints to failed commands
  net: ena: simplify ena_com_update_intr_delay_resolution()
  net: ena: cosmetic: rename ena_update_tx/rx_rings_intr_moderation()
  net: ena: cosmetic: set queue sizes to u32 for consistency
  net: ena: cosmetic: fix spelling and grammar mistakes in comments
  net: ena: cosmetic: fix line break issues
  net: ena: cosmetic: remove unnecessary code
  net: ena: cosmetic: code reorderings
  net: ena: cosmetic: fix spacing issues
  net: ena: cosmetic: minor code changes
  net: ena: reduce driver load time

 .../net/ethernet/amazon/ena/ena_admin_defs.h  | 11 ++-
 drivers/net/ethernet/amazon/ena/ena_com.c     | 85 ++++++++++---------
 drivers/net/ethernet/amazon/ena/ena_com.h     | 35 ++++----
 .../net/ethernet/amazon/ena/ena_common_defs.h |  2 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 50 +++++++----
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  7 +-
 .../net/ethernet/amazon/ena/ena_eth_io_defs.h |  6 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 19 ++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 39 +++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 10 +--
 .../net/ethernet/amazon/ena/ena_regs_defs.h   |  2 +-
 11 files changed, 150 insertions(+), 116 deletions(-)

-- 
2.23.1

