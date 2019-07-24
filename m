Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0157D72F61
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfGXNBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 09:01:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2751 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726312AbfGXNBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 09:01:44 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C5B3B6749C1C740FA9AE;
        Wed, 24 Jul 2019 21:01:40 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 21:01:33 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <manishc@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>,
        <gregkh@linuxfoundation.org>, <bpoirier@suse.com>
CC:     <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <netdev@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] qlge: Fix build error without CONFIG_ETHERNET
Date:   Wed, 24 Jul 2019 21:01:26 +0800
Message-ID: <20190724130126.53532-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now if CONFIG_ETHERNET is not set, QLGE driver
building fails:

drivers/staging/qlge/qlge_main.o: In function `qlge_remove':
drivers/staging/qlge/qlge_main.c:4831: undefined reference to `unregister_netdev'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 955315b0dc8c ("qlge: Move drivers/net/ethernet/qlogic/qlge/ to drivers/staging/qlge/")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/qlge/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
index ae9ed2c..a3cb25a3 100644
--- a/drivers/staging/qlge/Kconfig
+++ b/drivers/staging/qlge/Kconfig
@@ -2,7 +2,7 @@
 
 config QLGE
 	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
-	depends on PCI
+	depends on ETHERNET && PCI
 	help
 	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
 
-- 
2.7.4


