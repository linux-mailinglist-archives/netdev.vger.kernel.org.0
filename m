Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E162C2CE
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfE1JLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:11:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726506AbfE1JLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:11:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5831C91C97D14D4ADA04;
        Tue, 28 May 2019 17:11:12 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Tue, 28 May 2019
 17:11:03 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: stmmac: Fix build error without CONFIG_INET
Date:   Tue, 28 May 2019 17:10:40 +0800
Message-ID: <20190528091040.20288-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix gcc build error while CONFIG_INET is not set

drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.o: In function `__stmmac_test_loopback':
stmmac_selftests.c:(.text+0x8ec): undefined reference to `ip_send_check'
stmmac_selftests.c:(.text+0xacc): undefined reference to `udp4_hwcsum'

Add CONFIG_INET dependency to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 7791ad5..0b5c8d7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -15,6 +15,7 @@ if STMMAC_ETH
 
 config STMMAC_SELFTESTS
 	bool "Support for STMMAC Selftests"
+	depends on INET
 	depends on STMMAC_ETH
 	default n
 	---help---
-- 
2.7.4


