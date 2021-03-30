Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5872934E71D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhC3MGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:06:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14636 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhC3MFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 08:05:46 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8p4B659dznVL7;
        Tue, 30 Mar 2021 20:03:06 +0800 (CST)
Received: from huawei.com (10.67.174.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 20:05:33 +0800
From:   Zhang Jianhua <zhangjianhua18@huawei.com>
To:     <ath9k-devel@qca.qualcomm.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <zhangjianhua18@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <johnny.chenyi@huawei.com>
Subject: [PATCH -next v2] drivers: net: CONFIG_ATH9K select LEDS_CLASS and NEW_LEDS
Date:   Tue, 30 Mar 2021 20:05:33 +0800
Message-ID: <20210330120533.102712-1-zhangjianhua18@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.96]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_ATH9K=y, the following errors will be seen while compiling
gpio.c

drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_deinit_leds':
gpio.c:(.text+0x604): undefined reference to `led_classdev_unregister'
gpio.c:(.text+0x604): relocation truncated to fit: R_AARCH64_CALL26
against undefined symbol `led_classdev_unregister'
drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_init_leds':
gpio.c:(.text+0x708): undefined reference to `led_classdev_register_ext'
gpio.c:(.text+0x708): relocation truncated to fit: R_AARCH64_CALL26
against undefined symbol `led_classdev_register_ext'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Jianhua <zhangjianhua18@huawei.com>

---
v2:
add 'select NEW_LEDS'
---
 drivers/net/wireless/ath/ath9k/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index e150d82eddb6..0a73ede3148a 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -24,6 +24,8 @@ config ATH9K
 	select MAC80211_LEDS if LEDS_CLASS=y || LEDS_CLASS=MAC80211
 	select ATH9K_HW
 	select ATH9K_COMMON
+	select NEW_LEDS
+	select LEDS_CLASS
 	help
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
-- 
2.17.1

