Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768E963BDA3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiK2KKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiK2KKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:10:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1115F86D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:08:41 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxX1-0006yE-N1; Tue, 29 Nov 2022 11:08:03 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWy-0012iF-LB; Tue, 29 Nov 2022 11:08:01 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWx-00BYGm-BG; Tue, 29 Nov 2022 11:07:59 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v4 00/11] RTW88: Add support for USB variants
Date:   Tue, 29 Nov 2022 11:07:43 +0100
Message-Id: <20221129100754.2753237-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4 of this patchset. No big changes, only the review comments from v3
are integrated.

Sascha Hauer (11):
  wifi: rtw88: print firmware type in info message
  wifi: rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex
    held
  wifi: rtw88: Drop rf_lock
  wifi: rtw88: Drop h2c.lock
  wifi: rtw88: Drop coex mutex
  wifi: rtw88: iterate over vif/sta list non-atomically
  wifi: rtw88: Add common USB chip support
  wifi: rtw88: Add rtw8821cu chipset support
  wifi: rtw88: Add rtw8822bu chipset support
  wifi: rtw88: Add rtw8822cu chipset support
  wifi: rtw88: Add rtw8723du chipset support

 drivers/net/wireless/realtek/rtw88/Kconfig    |  47 +
 drivers/net/wireless/realtek/rtw88/Makefile   |  15 +
 drivers/net/wireless/realtek/rtw88/coex.c     |   3 +-
 drivers/net/wireless/realtek/rtw88/debug.c    |  15 +
 drivers/net/wireless/realtek/rtw88/fw.c       |  13 +-
 drivers/net/wireless/realtek/rtw88/hci.h      |   9 +-
 drivers/net/wireless/realtek/rtw88/mac.c      |   3 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c     |  12 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  12 +-
 drivers/net/wireless/realtek/rtw88/phy.c      |   6 +-
 drivers/net/wireless/realtek/rtw88/ps.c       |   2 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c |  28 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |  13 +-
 .../net/wireless/realtek/rtw88/rtw8723du.c    |  36 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |  18 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |  21 +
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |  50 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |  19 +
 .../net/wireless/realtek/rtw88/rtw8822bu.c    |  90 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |  24 +
 .../net/wireless/realtek/rtw88/rtw8822cu.c    |  44 +
 drivers/net/wireless/realtek/rtw88/tx.h       |  31 +
 drivers/net/wireless/realtek/rtw88/usb.c      | 917 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/usb.h      | 107 ++
 drivers/net/wireless/realtek/rtw88/util.c     | 103 ++
 drivers/net/wireless/realtek/rtw88/util.h     |  12 +-
 28 files changed, 1615 insertions(+), 38 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h

-- 
2.30.2

