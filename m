Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF65222AA8
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgGPSKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:10:47 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:18697 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgGPSKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594923046; x=1626459046;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=R/QGFb9bd9NlQckicHhjj1+4/dUb7L6AFljWnSPrN+M=;
  b=nmXj0Lk/ixrH1YQWJd+GT+rR+LtMv0EmWGzMDfqRpJLEtbnKakX6ctdw
   bh4csOdbzoU2ut5t4rOw+00s4WRrOMee0MEtPK55xKpAKLmR3bgSwmhQU
   qJHXChHVJf465jFyeGcnOlFRZplzheIuFh0n81jXIMnp1NKOYlvwVzf2v
   c=;
IronPort-SDR: zULfCH6oHSOWQkq8QrAKh82V9kGQKt5Y95S2ydu2zstygwNDsk1KtapsgJL6nr3aaqTF/+GEvo
 F9KfyYfs6q8A==
X-IronPort-AV: E=Sophos;i="5.75,360,1589241600"; 
   d="scan'208";a="52185555"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 16 Jul 2020 18:10:38 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id 814EEA176D;
        Thu, 16 Jul 2020 18:10:37 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:10:36 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:10:36 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.20) by
 mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 16 Jul 2020 18:10:33 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     EC2 Default User <ec2-user@ip-172-31-75-92.ec2.internal>,
        <dwmw@amazon.com>, <zorik@amazon.com>, <matua@amazon.com>,
        <saeedb@amazon.com>, <msw@amazon.com>, <aliguori@amazon.com>,
        <nafea@amazon.com>, <gtzalik@amazon.com>, <netanel@amazon.com>,
        <alisaidi@amazon.com>, <benh@amazon.com>, <ndagan@amazon.com>,
        <shayagr@amazon.com>, <sameehj@amazon.com>
Subject: [PATCH V3 net-next 0/8] ENA driver new features
Date:   Thu, 16 Jul 2020 21:10:02 +0300
Message-ID: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: EC2 Default User <ec2-user@ip-172-31-75-92.ec2.internal>


V3 changes:
-----------
1. Add "net: ena: enable support of rss hash key and function
   changes" patch again, with more explanations why it should
   be in net-next in commit message.
2. Add synchronization considerations to "net: ena: avoid unnecessary
   rearming of interrupt vector when busy-polling"


V2 changes:
-----------
1. Update commit messages of 2 patches to be more verbose.
2. Remove "net: ena: enable support of rss hash key and function
   changes" patch. Will be resubmitted net.


V1 cover letter:
----------------
This patchset contains performance improvements, support for new devices
and functionality:

1. Support for upcoming ENA devices
2. Avoid unnecessary IRQ unmasking in busy poll to reduce interrupt rate
3. Enabling device support for RSS function and key manipulation
4. Support for NIC-based traffic mirroring (SPAN port)
5. Additional PCI device ID
6. Cosmetic changes


Arthur Kiyanovski (8):
  net: ena: avoid unnecessary rearming of interrupt vector when
    busy-polling
  net: ena: add reserved PCI device ID
  net: ena: cosmetic: satisfy gcc warning
  net: ena: cosmetic: change ena_com_stats_admin stats to u64
  net: ena: add support for traffic mirroring
  net: ena: enable support of rss hash key and function changes
  net: ena: move llq configuration from ena_probe to ena_device_init()
  net: ena: support new LLQ acceleration mode

 .../net/ethernet/amazon/ena/ena_admin_defs.h  |  47 ++++-
 drivers/net/ethernet/amazon/ena/ena_com.c     |  19 +-
 drivers/net/ethernet/amazon/ena/ena_com.h     |  13 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c |  51 +++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h |   3 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |   4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 177 ++++++++++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |   3 +
 .../net/ethernet/amazon/ena/ena_pci_id_tbl.h  |   5 +
 9 files changed, 219 insertions(+), 103 deletions(-)

-- 
2.23.3

