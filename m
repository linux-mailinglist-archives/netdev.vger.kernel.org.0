Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7CB3637C1
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhDRVMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:12:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35216 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbhDRVMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:12:24 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1111463E87;
        Sun, 18 Apr 2021 23:11:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: [PATCH net-next 1/3] net: ethernet: mtk_eth_soc: fix undefined reference to `dsa_port_from_netdev'
Date:   Sun, 18 Apr 2021 23:11:43 +0200
Message-Id: <20210418211145.21914-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210418211145.21914-1-pablo@netfilter.org>
References: <20210418211145.21914-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Caused by:

 CONFIG_NET_DSA=m
 CONFIG_NET_MEDIATEK_SOC=y

mtk_ppe_offload.c:undefined reference to `dsa_port_from_netdev'

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 3362b148de23..08c2e446d3d5 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -9,6 +9,7 @@ if NET_VENDOR_MEDIATEK
 
 config NET_MEDIATEK_SOC
 	tristate "MediaTek SoC Gigabit Ethernet support"
+	depends on NET_DSA || !NET_DSA
 	select PHYLINK
 	help
 	  This driver supports the gigabit ethernet MACs in the
-- 
2.20.1

