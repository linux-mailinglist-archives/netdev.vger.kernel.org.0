Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85F92C1457
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731378AbgKWTNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 14:13:08 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:27806 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbgKWTNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 14:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606158788; x=1637694788;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C8AkGa/rGqmLQbd0Mke4gpOM6FmCaymO8ePK0skUwco=;
  b=fRwUV7HBIPIfEQRg7kNGUqP6hL8wBw26EN6kMDx1XJS/HKaZApm7rv2j
   BLilWHERlsoL1SUlVPgLNuVOZyNnkr0bmDUZ1S4OEDNs++4uY75I9snH3
   eQmth1uFp1z4+Zv7afNhGfNn/YBLdEZczBUQjbyot8vA+8eoboQAOLwqM
   I=;
X-IronPort-AV: E=Sophos;i="5.78,364,1599523200"; 
   d="scan'208";a="97115491"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 23 Nov 2020 19:09:33 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 23ECBA1A1B;
        Mon, 23 Nov 2020 19:09:32 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 23 Nov 2020 19:09:24 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V3 net 0/3] Fixes for ENA driver
Date:   Mon, 23 Nov 2020 21:08:56 +0200
Message-ID: <20201123190859.21298-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D17UWC003.ant.amazon.com (10.43.162.206) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This series fixes some issues in the ENA driver:

- fix wrong data offset on machines that support rx offset
- work-around Intel iommu issue
- fix out of bound access when request id is wrong

Changes from previous version:
v1->v2: switched to using dma_set_mask_and_coherent() function
		in second patch
v2->v3: Removed fourth patch from series (would be sent in future series)


Shay Agroskin (3):
  net: ena: handle bad request id in ena_netdev
  net: ena: set initial DMA width to avoid intel iommu issue
  net: ena: fix packet's addresses for rx_offset feature

 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 80 +++++++------------
 2 files changed, 33 insertions(+), 50 deletions(-)

-- 
2.17.1

