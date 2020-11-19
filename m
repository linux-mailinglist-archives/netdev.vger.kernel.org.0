Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC382B9BFD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgKSU3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:29:35 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:58352 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgKSU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605817775; x=1637353775;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IYapUOOx3NgfTHwUwyalUvbHZPxrucT9mPIvOvDeGFE=;
  b=dMkwBBhNnv3vcy55EK85fz2wvpPSqlBtfAE5/r3wELlygiht3I7jui02
   /DbemWOebssT/qGbCI6rnYh0a8qHY32kiplFsfwLsS3QVq6i+Nt69qDet
   wioCMNdTkLq+RF8b2XlWGFMTOE/rlFWO2NLq5eQlVp7MOGh61SxRzykht
   g=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="88885283"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 19 Nov 2020 20:29:28 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 7A8B6A1E1F;
        Thu, 19 Nov 2020 20:29:26 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.231) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 20:29:18 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net 0/4] Fixes for ENA driver
Date:   Thu, 19 Nov 2020 22:28:47 +0200
Message-ID: <20201119202851.28077-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.231]
X-ClientProxiedBy: EX13D48UWB001.ant.amazon.com (10.43.163.80) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
This series fixes some issues in the ENA driver:

- fix wrong data offset on machines that support rx offset
- work-around Intel iommu issue
- fix out of bound access when request id is wrong
- return error code if XDP TX xmit fails

Changes from previous version:
v1->v2: switched to using dma_set_mask_and_coherent() function
		in second patch

Shay Agroskin (4):
  net: ena: handle bad request id in ena_netdev
  net: ena: set initial DMA width to avoid intel iommu issue
  net: ena: fix packet's addresses for rx_offset feature
  net: ena: return error code from ena_xdp_xmit_buff

 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 86 +++++++------------
 2 files changed, 36 insertions(+), 53 deletions(-)

-- 
2.17.1

