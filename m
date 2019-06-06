Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27A83738F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbfFFLzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:55:31 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:53394 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFLzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 07:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559822130; x=1591358130;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=wFwpR8M3LFos3rJv07LQJiHt/gcb0Wptk+ERMD+MBaA=;
  b=cXpelelN5U1/wg8RTnCi07UGcrjJqyms6TnWQ0kMNt2Jmz16DVdWJoAz
   gVxpaLd5hYPY3CP+YW5lixJ3cTy4FUZMZAmg80xtyDq2zGM0mjl3T393q
   YkxWXKuDTKvIiDJj3S7Xt7OaEUx0D3/PZHvzO4TSJI6wH6uz8XDECulJj
   8=;
X-IronPort-AV: E=Sophos;i="5.60,559,1549929600"; 
   d="scan'208";a="399639123"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 06 Jun 2019 11:55:28 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 8D490C63B7;
        Thu,  6 Jun 2019 11:55:28 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:28 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 11:55:27 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 6 Jun 2019 11:55:24 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 0/6] Support for dynamic queue size changes
Date:   Thu, 6 Jun 2019 14:55:14 +0300
Message-ID: <20190606115520.20394-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset introduces the following:
* add new admin command for supporting different queue size for Tx/Rx
* add support for Tx/Rx queues size modification through ethtool
* allow queues allocation backoff when low on memory
* update driver version

Arthur Kiyanovski (1):
  net: ena: add MAX_QUEUES_EXT get feature admin command

Sameeh Jubran (5):
  net: ena: enable negotiating larger Rx ring size
  net: ena: make ethtool show correct current and max queue sizes
  net: ena: allow queue allocation backoff when low on memory
  net: ena: add ethtool function for changing io queue sizes
  net: ena: update driver version from 2.0.3 to 2.1.0

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  56 +++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  76 +++--
 drivers/net/ethernet/amazon/ena/ena_com.h     |   3 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  35 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 303 +++++++++++++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  28 +-
 6 files changed, 382 insertions(+), 119 deletions(-)

-- 
2.17.1

