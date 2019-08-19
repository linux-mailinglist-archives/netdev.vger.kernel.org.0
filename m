Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99092333
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 14:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfHSMOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 08:14:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:35616 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbfHSMOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 08:14:25 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5E2F4ED99DF63635B5A6;
        Mon, 19 Aug 2019 20:14:23 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 19 Aug 2019
 20:14:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <idosch@mellanox.com>, <jiri@mellanox.com>,
        <mcroce@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] netdevsim: Fix build error without CONFIG_INET
Date:   Mon, 19 Aug 2019 20:08:25 +0800
Message-ID: <20190819120825.74460-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_INET is not set, building fails:

drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
dev.c:(.text+0x67b): undefined reference to `ip_send_check'

Add CONFIG_INET Kconfig dependency to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 48e209e..7bb786e 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -505,7 +505,7 @@ source "drivers/net/hyperv/Kconfig"
 
 config NETDEVSIM
 	tristate "Simulated networking device"
-	depends on DEBUG_FS
+	depends on INET && DEBUG_FS
 	select NET_DEVLINK
 	help
 	  This driver is a developer testing tool and software model that can
-- 
2.7.4


