Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FC4538414
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbiE3OrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbiE3OnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:43:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE4A941BA
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 06:55:30 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrO-0007UU-PV; Mon, 30 May 2022 15:55:07 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrO-005SmD-GU; Mon, 30 May 2022 15:55:05 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrL-004dIL-E2; Mon, 30 May 2022 15:55:03 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2 00/10] RTW88: Add support for USB variants
Date:   Mon, 30 May 2022 15:54:47 +0200
Message-Id: <20220530135457.1104091-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second round of patches for RTW88 USB support. I hopefully
addressed all comments to v1.

Overall changes since v1:
- Dropped rtl8723du chipset support (reported to be not working)
- make mostly checkpatch clean

see changelog in the patches for patch specific changes

Sascha

Sascha Hauer (10):
  rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
  rtw88: Drop rf_lock
  rtw88: Drop h2c.lock
  rtw88: Drop coex mutex
  rtw88: iterate over vif/sta list non-atomically
  rtw88: Add common USB chip support
  rtw88: Add rtw8821cu chipset support
  rtw88: Add rtw8822bu chipset support
  rtw88: Add rtw8822cu chipset support
  rtw88: disable powersave modes for USB devices

 drivers/net/wireless/realtek/rtw88/Kconfig    |   36 +
 drivers/net/wireless/realtek/rtw88/Makefile   |   11 +
 drivers/net/wireless/realtek/rtw88/coex.c     |    3 +-
 drivers/net/wireless/realtek/rtw88/debug.c    |   15 +
 drivers/net/wireless/realtek/rtw88/fw.c       |   13 +-
 drivers/net/wireless/realtek/rtw88/hci.h      |    9 +-
 drivers/net/wireless/realtek/rtw88/mac.c      |    3 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |    5 +-
 drivers/net/wireless/realtek/rtw88/main.c     |    8 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   11 +-
 drivers/net/wireless/realtek/rtw88/phy.c      |    6 +-
 drivers/net/wireless/realtek/rtw88/ps.c       |    2 +-
 drivers/net/wireless/realtek/rtw88/reg.h      |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |   23 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h |   21 +
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |   50 +
 .../net/wireless/realtek/rtw88/rtw8821cu.h    |   10 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   19 +
 .../net/wireless/realtek/rtw88/rtw8822bu.c    |   90 ++
 .../net/wireless/realtek/rtw88/rtw8822bu.h    |   10 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |   24 +
 .../net/wireless/realtek/rtw88/rtw8822cu.c    |   44 +
 .../net/wireless/realtek/rtw88/rtw8822cu.h    |   10 +
 drivers/net/wireless/realtek/rtw88/tx.h       |   31 +
 drivers/net/wireless/realtek/rtw88/usb.c      | 1037 +++++++++++++++++
 drivers/net/wireless/realtek/rtw88/usb.h      |  114 ++
 drivers/net/wireless/realtek/rtw88/util.c     |  103 ++
 drivers/net/wireless/realtek/rtw88/util.h     |   12 +-
 28 files changed, 1684 insertions(+), 37 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h

-- 
2.30.2

