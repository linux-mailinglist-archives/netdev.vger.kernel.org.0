Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18524A4EE
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHSR3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:29:37 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:47107 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgHSR3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597858165; x=1629394165;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=fIjryviEuOmdREnn2xVhEnk+M4FW+IgMqgYHQ05/2HE=;
  b=UdhuHOpVxr3TUsHXgkuTlnmhvh4pTt3p9wIctvstTP+a89gqgaPKrwIZ
   5S3zOdPZ48EvZTn9YEI8wksy1SO2kioGwGgowL0AacGrpKnhatBTuDN13
   BpErU9en3I6EVUuCNqHZwSMI1eKD1NskNboC8ehpsIT2oS0vBOI2XvVeg
   g=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="69241939"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Aug 2020 17:29:19 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id C195EA1BEB;
        Wed, 19 Aug 2020 17:29:18 +0000 (UTC)
Received: from EX13D28EUC001.ant.amazon.com (10.43.164.4) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:29:17 +0000
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.160.192) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 17:29:10 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V3 net 0/3] Bug fixes for ENA ethernet driver
Date:   Wed, 19 Aug 2020 20:28:35 +0300
Message-ID: <20200819172838.20564-1-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.192]
X-ClientProxiedBy: EX13P01UWB003.ant.amazon.com (10.43.161.209) To
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

v2->v3:
- fix wrong hash in 'Fixes' tag

Shay Agroskin (3):
  net: ena: Prevent reset after device destruction
  net: ena: Change WARN_ON expression in ena_del_napi_in_range()
  net: ena: Make missed_tx stat incremental

 drivers/net/ethernet/amazon/ena/ena_netdev.c | 35 ++++++++++----------
 1 file changed, 18 insertions(+), 17 deletions(-)

-- 
2.17.1

