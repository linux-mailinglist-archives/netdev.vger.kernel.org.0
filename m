Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6718D271E26
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIUIjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:39:31 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:38154 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUIjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:39:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600677570; x=1632213570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r1+zh/t+98fHaod7VpfYZo9J9Te+uQtzQc0XDt43tg4=;
  b=FvPBQEX6MmLc0ubjguWMwl+CWSCXz+W9hW0xQEyHcufH7rLHf7pyXa+j
   8/XPUFxBZz+KyYndo2bqaVJXsyikYXz368se1U1GOrYN6NGLT0KhkMXOI
   LF3wSz1207qeeS75OBZToFjMPeDvBtxO6KZ9OPGxuaij2ZVJQ1+YPcBo4
   Q=;
X-IronPort-AV: E=Sophos;i="5.77,286,1596499200"; 
   d="scan'208";a="55260569"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Sep 2020 08:39:29 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 8ADA3A1694;
        Mon, 21 Sep 2020 08:39:28 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.38) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 08:39:20 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net-next 7/7] net: ena: update ena documentation
Date:   Mon, 21 Sep 2020 11:37:42 +0300
Message-ID: <20200921083742.6454-8-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921083742.6454-1-shayagr@amazon.com>
References: <20200921083742.6454-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D31UWC003.ant.amazon.com (10.43.162.34) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
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

