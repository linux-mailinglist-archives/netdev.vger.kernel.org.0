Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF08267E93
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 10:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgIMIXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 04:23:41 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:13722 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgIMIW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 04:22:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599985376; x=1631521376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=r1+zh/t+98fHaod7VpfYZo9J9Te+uQtzQc0XDt43tg4=;
  b=NWh7+pBwEjkZYKjw+WtSDlgfbvThnFa4qHCHjZDGJCgrACFbip239DIN
   VXhF/sH6PjRF+lJyfuK536HquqDlJXj0OUxhthwSqO880+5r6TkIUG/eo
   7IsfAD1HYhitVwZcBzbLN8kGqqBTbffGz6Zecvfq5gNCDJAikNfgzYNjU
   s=;
X-IronPort-AV: E=Sophos;i="5.76,421,1592870400"; 
   d="scan'208";a="53643474"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Sep 2020 08:22:55 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 78831A1DA8;
        Sun, 13 Sep 2020 08:22:54 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.161.85) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 13 Sep 2020 08:22:45 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V1 net-next 8/8] net: ena: update ena documentation
Date:   Sun, 13 Sep 2020 11:20:56 +0300
Message-ID: <20200913082056.3610-9-shayagr@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200913082056.3610-6-shayagr@amazon.com>
References: <20200913082056.3610-6-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D44UWC002.ant.amazon.com (10.43.162.169) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PCI vendor IDs in the documentation inaccurately describe the ENA
devices. For example, the 1d0f:ec20 can have LLQ support. The driver
loads in LLQ mode by default, and a message is printed to the kernel
ring if the mode isn't supported by the device, so the device table
isn't needed.

Also, LLQ can support various entry sizes, so the documentation is
updated to reflect that.

Interrupt moderation description is also updated to be more accurate.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 .../device_drivers/ethernet/amazon/ena.rst    | 23 ++-----------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index a666913d9b5b..3561a8a29fd2 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -39,16 +39,6 @@ debug logs.
 Some of the ENA devices support a working mode called Low-latency
 Queue (LLQ), which saves several more microseconds.
 
-Supported PCI vendor ID/device IDs
-==================================
-
-=========   =======================
-1d0f:0ec2   ENA PF
-1d0f:1ec2   ENA PF with LLQ support
-1d0f:ec20   ENA VF
-1d0f:ec21   ENA VF with LLQ support
-=========   =======================
-
 ENA Source Code Directory Structure
 ===================================
 
@@ -212,20 +202,11 @@ In adaptive interrupt moderation mode the interrupt delay value is
 updated by the driver dynamically and adjusted every NAPI cycle
 according to the traffic nature.
 
-By default ENA driver applies adaptive coalescing on Rx traffic and
-conventional coalescing on Tx traffic.
-
 Adaptive coalescing can be switched on/off through ethtool(8)
 adaptive_rx on|off parameter.
 
-The driver chooses interrupt delay value according to the number of
-bytes and packets received between interrupt unmasking and interrupt
-posting. The driver uses interrupt delay table that subdivides the
-range of received bytes/packets into 5 levels and assigns interrupt
-delay value to each level.
-
-The user can enable/disable adaptive moderation, modify the interrupt
-delay table and restore its default values through sysfs.
+More information about Adaptive Interrupt Moderation (DIM) can be found in
+Documentation/networking/net_dim.rst
 
 RX copybreak
 ============
-- 
2.17.1

