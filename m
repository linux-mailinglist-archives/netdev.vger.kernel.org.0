Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F66A1B39DC
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgDVIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:52 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:25927 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgDVIQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543394; x=1619079394;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eMKzav3j1FzbCMKZ9ztyP7zJNLMb8g9HOBHIBSJ5gz4=;
  b=gpgvl88lqUaAZfbaQ6v+ATmkyJvzjvqpL6vq1K1wUUGbE2fPM6ptSP34
   7uuNtcxOuGYBzYDCDghbl6zoNbv88rhgo5hUKco/IjwlcTtuwMgE4dh+/
   uyqyYtofkMRdxtGQNsR5aHZc5zF7QvXNOSZHJkbIDBeo21T9IozZmqPcp
   M=;
IronPort-SDR: /+81uWR3fnc78zLx6jMi08B+xUyUVXS1zE6ChOu4k6flxiMzf6K+gZxmXLgbx5eW85CK8/faVU
 23erW6Y7GvGQ==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="38703215"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 Apr 2020 08:16:32 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 5AFF4A1D3A;
        Wed, 22 Apr 2020 08:16:31 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:30 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:30 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:30 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6239B81CEA; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 00/13] Enhance current features in ena driver
Date:   Wed, 22 Apr 2020 08:16:15 +0000
Message-ID: <20200422081628.8103-1-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

This patchset introduces the following:
* minor changes to RSS feature
* add total rx and tx drop counter
* add unmask_interrupt counter for ethtool statistics
* add missing implementation for ena_com_get_admin_polling_mode()
* some minor code clean-up and cosmetics
* use SHUTDOWN as reset reason when closing interface

Arthur Kiyanovski (6):
  net: ena: fix error returning in ena_com_get_hash_function()
  net: ena: avoid unnecessary admin command when RSS function set fails
  net: ena: change default RSS hash function to Toeplitz
  net: ena: implement ena_com_get_admin_polling_mode()
  net: ena: move llq configuration from ena_probe to ena_device_init()
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

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |   8 +
 drivers/net/ethernet/amazon/ena/ena_com.c     |  44 +++---
 drivers/net/ethernet/amazon/ena/ena_com.h     |  39 +++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  68 ++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 146 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   2 +
 6 files changed, 181 insertions(+), 126 deletions(-)

-- 
2.24.1.AMZN

