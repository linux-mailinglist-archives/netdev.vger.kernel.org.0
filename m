Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E45A242816
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgHLKMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 06:12:24 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:59832 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgHLKMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 06:12:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597227145; x=1628763145;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=53Soh9BjBWKGMnO1LZQdsglyRW37WdZ+GhuD7djatKA=;
  b=Y5IXlbZbGAQC1O2RAgAeSfwKnhok24BJ8RdYvwBITKd7W76K5QrOTAPg
   UH1hHcSsc8FKJphg8aQqNLANyKy4bCLnlNn9TTbDgi97j3TfkEuuG20Sw
   URxueUyPz9f6aaAL/Jw+N/2X3MyGwwP2qwhFn6sfPygokcotMukKhHmv1
   g=;
IronPort-SDR: kyzkoRAn4EtOvBnmN83qloct25XWKmw3GQ/bnlTWiV4LaQ7HJDD3rfLuYj5BYHmWL76abafP30
 T8Fkeil9L2GA==
X-IronPort-AV: E=Sophos;i="5.76,303,1592870400"; 
   d="scan'208";a="47524580"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Aug 2020 10:12:24 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 5EDEFA0652;
        Wed, 12 Aug 2020 10:12:23 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:22 +0000
Received: from u4b1e9be9d67d5a.ant.amazon.com (10.43.161.34) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 12 Aug 2020 10:12:14 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <dwmw@amazon.com>, <zorik@amazon.com>, <matua@amazon.com>,
        <saeedb@amazon.com>, <msw@amazon.com>, <aliguori@amazon.com>,
        <nafea@amazon.com>, <gtzalik@amazon.com>, <netanel@amazon.com>,
        <alisaidi@amazon.com>, <benh@amazon.com>, <akiyano@amazon.com>,
        <sameehj@amazon.com>, <ndagan@amazon.com>,
        Shay Agroskin <shayagr@amazon.com>
Subject: [PATCH V1 net 0/3] Bug fixes for ENA ethernet driver
Date:   Wed, 12 Aug 2020 13:10:56 +0300
Message-ID: <20200812101059.5501-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the following:
- Fix possible NULL dereference after returning from suspend
- Fix condition inside a WARN_ON
- Fix overriding previous value when updating missed_tx statistic

Shay Agroskin (3):
  net: ena: Prevent reset after device destruction
  net: ena: Change WARN_ON expression in ena_del_napi_in_range()
  net: ena: Make missed_tx stat incremental

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 33 +++++++++-----------
 1 file changed, 14 insertions(+), 19 deletions(-)

-- 
2.28.0

