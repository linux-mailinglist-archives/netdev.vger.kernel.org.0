Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548202B870D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgKRWBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:01:40 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:32073 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgKRWBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:01:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605736900; x=1637272900;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xjUxq99bDOC+vIeq9RkmZR33RpdcRyexxgdrUgUzm5g=;
  b=nd2Jf37U/Ol5vMTm6nt3AvnbdTHK5rTi33fqpwhM5kpxCD8MPgLdEolV
   w0ZAsa8GeggSb/xveeO8NO63lVXTI2c6K7mvxn/kc6PaHOsdfvQqH6UCf
   XBEt/IFd3vryCdn1B7X6UqxmyjkznUj80fIhoaC0gcqV2GKhT79/0w4Go
   s=;
X-IronPort-AV: E=Sophos;i="5.77,488,1596499200"; 
   d="scan'208";a="64517554"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 18 Nov 2020 22:00:19 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 5BC06240B27;
        Wed, 18 Nov 2020 22:00:18 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.43) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 18 Nov 2020 22:00:09 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V1 net 0/4] Fixes for ENA driver
Date:   Wed, 18 Nov 2020 23:59:43 +0200
Message-ID: <20201118215947.8970-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D25UWC002.ant.amazon.com (10.43.162.210) To
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

Shay Agroskin (4):
  net: ena: handle bad request id in ena_netdev
  net: ena: set initial DMA width to avoid intel iommu issue
  net: ena: fix packet's addresses for rx_offset feature
  net: ena: return error code from ena_xdp_xmit_buff

 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  3 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 82 +++++++++----------
 2 files changed, 41 insertions(+), 44 deletions(-)

-- 
2.17.1

