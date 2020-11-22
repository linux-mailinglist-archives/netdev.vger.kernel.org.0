Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C72BC2DB
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 01:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgKVA0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 19:26:31 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48538 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgKVA0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 19:26:30 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 51B251F417FB
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH] dpaa2-eth: Fix compile error due to missing devlink support
Date:   Sat, 21 Nov 2020 21:23:36 -0300
Message-Id: <20201122002336.79912-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2 driver depends on devlink, so it should select
NET_DEVLINK in order to fix compile errors, such as:

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_eth_rx_err':
dpaa2-eth.c:(.text+0x3cec): undefined reference to `devlink_trap_report'
drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_info_get':
dpaa2-eth-devlink.c:(.text+0x160): undefined reference to `devlink_info_driver_name_put'

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index cfd369cf4c8c..aee59ead7250 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -2,6 +2,7 @@
 config FSL_DPAA2_ETH
 	tristate "Freescale DPAA2 Ethernet"
 	depends on FSL_MC_BUS && FSL_MC_DPIO
+	select NET_DEVLINK
 	select PHYLINK
 	select PCS_LYNX
 	help
-- 
2.27.0

