Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F432498FF
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgHSJFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:05:45 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:17973 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgHSJFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597827945; x=1629363945;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=cNLBIhUBNJBr0EY2g7O+ZaSl+hhsVOc0rrvJyFOe26g=;
  b=Mv/JLh7mQpnU20/MbdCd/8Pr0ULXIqzZZ9/v1Mi5uPWJb2DO0x66GaGE
   WQc2s7pEYGfzyalWjdqr5bRtnvubdiaMyxDAMtPMkwqjd9y/t3K0kTW3u
   vE+wWsHA2n26WjFfdvsVScI+nql7XRBmEAYNUy0ndej6Yq7bNZYs+GMh7
   g=;
X-IronPort-AV: E=Sophos;i="5.76,330,1592870400"; 
   d="scan'208";a="48656425"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 Aug 2020 09:05:40 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 96DEDC0BC4;
        Wed, 19 Aug 2020 09:05:39 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:05:38 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.100) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:05:30 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net 0/3] Bug fixes for ENA ethernet driver
Date:   Wed, 19 Aug 2020 12:04:40 +0300
Message-ID: <20200819090443.24917-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the following:
- Fix undesired call to ena_restore after returning from suspend
- Fix condition inside a WARN_ON
- Fix overriding previous value when updating missed_tx statistic

v1->v2:
- fix bug when calling reset routine after device resources are freed (Jakub)

Shay Agroskin (3):
  net: ena: Prevent reset after device destruction
  net: ena: Change WARN_ON expression in ena_del_napi_in_range()
  net: ena: Make missed_tx stat incremental

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 35 ++++++++++----------
 1 file changed, 18 insertions(+), 17 deletions(-)

-- 
2.17.1

