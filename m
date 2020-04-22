Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1D81B39AD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgDVIJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:55 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:57816 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgDVIJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542989; x=1619078989;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eMKzav3j1FzbCMKZ9ztyP7zJNLMb8g9HOBHIBSJ5gz4=;
  b=v/eUKkgrNUELDgAe9gYaGeiAdoR4m25em0rQalcFNCZTWsGIErx6hMEg
   OqJWkjuoV/ELqe9TMfYJoy7AFz6nCMtEUq2rE+AOQQ+VXfpJ6+kpHjHjw
   QjYEUUGo3ofhQ9OvvP4idp6fWdVUpV0jNUrNGjde7/VD1sQ/mIlsHx6xo
   c=;
IronPort-SDR: RYV//7x4y+f6PdZH0k9o/5NTjNe5FwASURCeZXpTVJF7K/UuU3khbSIPxDjNjH+jAF50KOvYrl
 tRHdSDGsgJ4w==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="26803349"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Apr 2020 08:09:34 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 7B809A239B;
        Wed, 22 Apr 2020 08:09:32 +0000 (UTC)
Received: from EX13d09UWA002.ant.amazon.com (10.43.160.186) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA002.ant.amazon.com (10.43.160.186) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 5485B81CE8; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 00/13] Enhance current features in ena driver
Date:   Wed, 22 Apr 2020 08:09:10 +0000
Message-ID: <20200422080923.6697-1-sameehj@amazon.com>
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

