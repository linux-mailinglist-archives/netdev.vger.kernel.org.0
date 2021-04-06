Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA970355376
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343872AbhDFMRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:17:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15558 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbhDFMRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:17:14 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FF5zr3xnZzPnpW;
        Tue,  6 Apr 2021 20:14:16 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 20:16:51 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] rtlwifi: rtl8192de: Use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 6 Apr 2021 20:16:46 +0800
Message-ID: <1617711406-49649-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guobin Huang <huangguobin4@huawei.com>

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
---
 .../realtek/rtlwifi/rtl8192de/sw.c         | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 1dbdddce0823..a74724c971b9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -372,18 +372,14 @@ static struct pci_driver rtl92de_driver = {
 
 /* add global spin lock to solve the problem that
  * Dul mac register operation on the same time */
-spinlock_t globalmutex_power;
-spinlock_t globalmutex_for_fwdownload;
-spinlock_t globalmutex_for_power_and_efuse;
+DEFINE_SPINLOCK(globalmutex_power);
+DEFINE_SPINLOCK(globalmutex_for_fwdownload);
+DEFINE_SPINLOCK(globalmutex_for_power_and_efuse);
 
 static int __init rtl92de_module_init(void)
 {
 	int ret = 0;
 
-	spin_lock_init(&globalmutex_power);
-	spin_lock_init(&globalmutex_for_fwdownload);
-	spin_lock_init(&globalmutex_for_power_and_efuse);
-
 	ret = pci_register_driver(&rtl92de_driver);
 	if (ret)
 		WARN_ONCE(true, "rtl8192de: No device found\n");

