Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A171048180F
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhL3B1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:27:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50656 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhL3B1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:27:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DE17615BB;
        Thu, 30 Dec 2021 01:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA02C36AEE;
        Thu, 30 Dec 2021 01:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640827667;
        bh=VyHQY8J49gY+iAihRqxjOKsUj4wupvO0oUTJjIn1KrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCRujHrlvJ++eMV+8eOATEJODo3khk0hQq/qcOGZJbOYVzdGaJEIdQpe3ygUNnexv
         h2B2UhmvvwrWYfXay/0DFsT+93ABO9urf7cswier/8esz/sWGUfqzUcXlAOR+gKynv
         1a/grh6c0mmNY7d0MGHXlo8O9AskGejfATQlOS0UmQGGRK7+ZmQGx+2pLxQMtoRjKi
         CwuAD0fmyCWoX1DMFsFLfNE8h0v8OIFLrH113Ncsdk2CgRt3oUx/bi75brGOEczrS5
         TMAuPXSAUe1oT7//Rt10B20IOyCqz8tUfPiccgTDL8cTvGrxN3k3fiMz1b5EvnF7c3
         RQR99+BMsZxQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, ndagan@amazon.com,
        saeedb@amazon.com, sgoutham@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, grygorii.strashko@ti.com,
        sameehj@amazon.com, chenhao288@hisilicon.com, moyufeng@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-omap@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] net: add includes masked by netdevice.h including uapi/bpf.h
Date:   Wed, 29 Dec 2021 17:27:41 -0800
Message-Id: <20211230012742.770642-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211230012742.770642-1-kuba@kernel.org>
References: <20211230012742.770642-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing includes unmasked by the subsequent change.

Mostly network drivers missing an include for XDP_PACKET_HEADROOM.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - fix buildbot's randconfig failure in ipv6

CC: shayagr@amazon.com
CC: akiyano@amazon.com
CC: darinzon@amazon.com
CC: ndagan@amazon.com
CC: saeedb@amazon.com
CC: sgoutham@marvell.com
CC: kys@microsoft.com
CC: haiyangz@microsoft.com
CC: sthemmin@microsoft.com
CC: wei.liu@kernel.org
CC: decui@microsoft.com
CC: peppe.cavallaro@st.com
CC: alexandre.torgue@foss.st.com
CC: joabreu@synopsys.com
CC: mcoquelin.stm32@gmail.com
CC: grygorii.strashko@ti.com
CC: sameehj@amazon.com
CC: chenhao288@hisilicon.com
CC: moyufeng@huawei.com
CC: linux-arm-kernel@lists.infradead.org
CC: linux-hyperv@vger.kernel.org
CC: linux-stm32@st-md-mailman.stormreply.com
CC: linux-omap@vger.kernel.org
---
 drivers/net/ethernet/amazon/ena/ena_netdev.h       | 1 +
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c | 1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       | 1 +
 drivers/net/ethernet/ti/cpsw_priv.h                | 2 ++
 include/net/ip6_fib.h                              | 1 +
 kernel/bpf/net_namespace.c                         | 1 +
 7 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 0c39fc2fa345..9391c7101fba 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <uapi/linux/bpf.h>
 
 #include "ena_com.h"
 #include "ena_eth_com.h"
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 50bbe79fb93d..4367edbdd579 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -10,6 +10,7 @@
 #include <linux/iommu.h>
 #include <net/ip.h>
 #include <net/tso.h>
+#include <uapi/linux/bpf.h>
 
 #include "nic_reg.h"
 #include "nic.h"
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c1d5a374b967..2ece9e90dc50 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Copyright (c) 2021, Microsoft Corporation. */
 
+#include <uapi/linux/bpf.h>
+
 #include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 4f5292cadf54..d42b6af32d6e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -22,6 +22,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/reset.h>
 #include <net/page_pool.h>
+#include <uapi/linux/bpf.h>
 
 struct stmmac_resources {
 	void __iomem *addr;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index f33c882eb70e..74555970730c 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -6,6 +6,8 @@
 #ifndef DRIVERS_NET_ETHERNET_TI_CPSW_PRIV_H_
 #define DRIVERS_NET_ETHERNET_TI_CPSW_PRIV_H_
 
+#include <uapi/linux/bpf.h>
+
 #include "davinci_cpdma.h"
 
 #define CPSW_DEBUG	(NETIF_MSG_HW		| NETIF_MSG_WOL		| \
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 83b8070d1cc9..a9a4ccc0cdb5 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -20,6 +20,7 @@
 #include <net/inetpeer.h>
 #include <net/fib_notifier.h>
 #include <linux/indirect_call_wrapper.h>
+#include <uapi/linux/bpf.h>
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 #define FIB6_TABLE_HASHSZ 256
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 542f275bf252..868cc2c43899 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/bpf.h>
+#include <linux/bpf-netns.h>
 #include <linux/filter.h>
 #include <net/net_namespace.h>
 
-- 
2.31.1

