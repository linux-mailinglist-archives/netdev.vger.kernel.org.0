Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0AAE31A79
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfFAIGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 04:06:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47324 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726013AbfFAIGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 04:06:44 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EFC26A79FF7D3BE022FC;
        Sat,  1 Jun 2019 16:06:38 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Sat, 1 Jun 2019
 16:06:30 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <gregkh@linuxfoundation.org>,
        <tglx@linutronix.de>, <ariel.elior@marvell.com>,
        <michal.kalderon@marvell.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] qed: Fix build error without CONFIG_DEVLINK
Date:   Sat, 1 Jun 2019 16:06:05 +0800
Message-ID: <20190601080605.13052-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix gcc build error while CONFIG_DEVLINK is not set

drivers/net/ethernet/qlogic/qed/qed_main.o: In function `qed_remove':
qed_main.c:(.text+0x1eb4): undefined reference to `devlink_unregister'

Select DEVLINK to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 24e04879abdd ("qed: Add qed devlink parameters table")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/qlogic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index fdbb3ce..a391cf6 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -87,6 +87,7 @@ config QED
 	depends on PCI
 	select ZLIB_INFLATE
 	select CRC8
+	select NET_DEVLINK
 	---help---
 	  This enables the support for ...
 
-- 
2.7.4


