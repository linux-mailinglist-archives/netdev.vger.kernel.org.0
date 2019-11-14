Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54023FC20A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfKNJCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:02:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725920AbfKNJCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 04:02:54 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1328043A7DF9ACC78C52;
        Thu, 14 Nov 2019 17:02:51 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 14 Nov 2019
 17:02:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <f.fainelli@gmail.com>, <jiri@mellanox.com>,
        <geert+renesas@glider.be>, <jakub.kicinski@netronome.com>,
        <gospo@broadcom.com>, <rdunlap@infradead.org>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] cnic: Fix Kconfig warning without MMU
Date:   Thu, 14 Nov 2019 17:02:19 +0800
Message-ID: <20191114090219.38344-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If MMU is not set, Kconfig warning this:

WARNING: unmet direct dependencies detected for UIO
  Depends on [n]: MMU [=n]
  Selected by [y]:
  - CNIC [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n)

Make CNIC depend on UIO instead of select it to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/broadcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 53055ce..7acb677 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -87,8 +87,8 @@ config BNX2
 config CNIC
 	tristate "QLogic CNIC support"
 	depends on PCI && (IPV6 || IPV6=n)
+	depends on UIO
 	select BNX2
-	select UIO
 	---help---
 	  This driver supports offload features of QLogic bnx2 gigabit
 	  Ethernet cards.
-- 
2.7.4


