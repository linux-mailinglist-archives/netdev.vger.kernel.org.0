Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947AE1DE2A4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgEVJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:11:15 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63739 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgEVJLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138674; x=1621674674;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=h3b+TirJuH8fJw6XadcUaYKncmwWWBnX45jn685yYOg=;
  b=auRGArPCqpT97xTa1MgA9sIaj3IQY7tTkpMGPWaaC2v0VxGoIZzQeee9
   RqIxXk1IGzahyudXv265zpCAe4m3pHULyyYj1SICOI09/1WwoiTRIAgXL
   h4ZXL/visqUDOv4xUzwm8Qr3R19O/1HjjlyNl3mWFu83wkDhB7AHot08r
   Y=;
IronPort-SDR: UtBIFXLLho83WsyP9jYMV/o7PYULHlEWHlEjqSOPvQ8UH8IsKhQPz6cNuaRgw9dRlBhzKBHywT
 dlmVgb7JK8/Q==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="36968614"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 May 2020 09:11:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 2CF17241319;
        Fri, 22 May 2020 09:11:12 +0000 (UTC)
Received: from EX13D21UWB001.ant.amazon.com (10.43.161.108) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D21UWB001.ant.amazon.com (10.43.161.108) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:12 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:08 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 00/14] ENA features and cosmetic changes
Date:   Fri, 22 May 2020 12:08:51 +0300
Message-ID: <1590138545-501-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Diff from V1 of this patchset:
Removed error prints patch

This patchset includes:
1. new rx offset feature
2. reduction of the driver load time
3. multiple cosmetic changes to the code

Arthur Kiyanovski (14):
  net: ena: add support for the rx offset feature
  net: ena: rename ena_com_free_desc to make API more uniform
  net: ena: use explicit variable size for clarity
  net: ena: fix ena_com_comp_status_to_errno() return value
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
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 26 +++---
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |  7 +-
 .../net/ethernet/amazon/ena/ena_eth_io_defs.h |  6 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 19 ++---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 39 +++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 10 +--
 .../net/ethernet/amazon/ena/ena_regs_defs.h   |  2 +-
 11 files changed, 131 insertions(+), 111 deletions(-)

-- 
2.23.1

