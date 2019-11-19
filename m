Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF586101178
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKSCxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:53:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58072 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727014AbfKSCxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 21:53:19 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C122B8909482A1E8353F;
        Tue, 19 Nov 2019 10:53:16 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Tue, 19 Nov 2019 10:53:06 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net] net: dsa: ocelot: add dependency for NET_DSA_MSCC_FELIX
Date:   Tue, 19 Nov 2019 10:51:28 +0800
Message-ID: <20191119025128.7393-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_NET_DSA_MSCC_FELIX=y, and CONFIG_NET_VENDOR_MICROSEMI=n,
below errors can be found:
drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_del':
felix.c:(.text+0x26e): undefined reference to `ocelot_vlan_del'
drivers/net/dsa/ocelot/felix.o: In function `felix_vlan_add':
felix.c:(.text+0x352): undefined reference to `ocelot_vlan_add'

and warning as below:
WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] &&
NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
Selected by [y]:
NET_DSA_MSCC_FELIX [=y] && NETDEVICES [=y] && HAVE_NET_DSA [=y]
&& NET_DSA [=y] && PCI [=y]

This patch add dependency NET_VENDOR_MICROSEMI for NET_DSA_MSCC_FELIX.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/dsa/ocelot/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 0031ca8..61c4ce7 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
-	depends on NET_DSA && PCI
+	depends on NET_DSA && PCI && NET_VENDOR_MICROSEMI
 	select MSCC_OCELOT_SWITCH
 	select NET_DSA_TAG_OCELOT
 	help
-- 
2.7.4

