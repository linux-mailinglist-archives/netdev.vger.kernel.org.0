Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B06427BA4E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgI2Bg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgI2Bag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 589D32075A;
        Tue, 29 Sep 2020 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343036;
        bh=EVrZq7EtFeZF5oTNUnyKqTUgn8O2kNcpOGjMcuAV/xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pb6QqyKUe4eebMfucZPTO9/+1ZMJv7HNVrM2YdmeyCpOEcSVRcxoYxn4TvMdOgaQh
         dFtP25+moiI8dLKCQtJ5FYGw28EzFHLSZXc8NpUlKP1OqHPgi9ocbT1UGR+3uaNz1i
         fqKeomhGNidkYYCFLP5PYOR8ibjHDXTSUPb2ZOeo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 06/29] Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"
Date:   Mon, 28 Sep 2020 21:30:03 -0400
Message-Id: <20200929013027.2406344-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 1264c1e0cfe55e2d6c35e869244093195529af37 ]

This patch causes a regression betwen Kernel 5.7 and 5.8 at wlcore:
with it applied, WiFi stops working, and the Kernel starts printing
this message every second:

   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 133 at drivers/net/wireless/ti/wlcore/main.c:795 wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   Modules linked in: wl18xx wlcore mac80211 libarc4 cfg80211 rfkill snd_soc_hdmi_codec crct10dif_ce wlcore_sdio adv7511 cec kirin9xx_drm(C) kirin9xx_dw_drm_dsi(C) drm_kms_helper drm ip_tables x_tables ipv6 nf_defrag_ipv6
   CPU: 0 PID: 133 Comm: kworker/0:1 Tainted: G        WC        5.8.0+ #186
   Hardware name: HiKey970 (DT)
   Workqueue: events_freezable ieee80211_restart_work [mac80211]
   pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
   pc : wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
   lr : wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
   sp : ffff8000126c3a60
   x29: ffff8000126c3a60 x28: 00000000000025de
   x27: 0000000000000010 x26: 0000000000000005
   x25: ffff0001a5d49e80 x24: ffff8000092cf580
   x23: ffff0001b7c12623 x22: ffff0001b6fcf2e8
   x21: ffff0001b7e46200 x20: 00000000fffffffb
   x19: ffff0001a78e6400 x18: 0000000000000030
   x17: 0000000000000001 x16: 0000000000000001
   x15: ffff0001b7e46670 x14: ffffffffffffffff
   x13: ffff8000926c37d7 x12: ffff8000126c37e0
   x11: ffff800011e01000 x10: ffff8000120526d0
   x9 : 0000000000000000 x8 : 3431206572756c69
   x7 : 6166206574756365 x6 : 0000000000000c2c
   x5 : 0000000000000000 x4 : ffff0001bf1361e8
   x3 : ffff0001bf1790b0 x2 : 0000000000000000
   x1 : ffff0001a5d49e80 x0 : 0000000000000001
   Call trace:
    wl12xx_queue_recovery_work.part.0+0x6c/0x74 [wlcore]
    wl12xx_queue_recovery_work+0x24/0x30 [wlcore]
    wl1271_cmd_set_sta_key+0x258/0x25c [wlcore]
    wl1271_set_key+0x7c/0x2dc [wlcore]
    wlcore_set_key+0xe4/0x360 [wlcore]
    wl18xx_set_key+0x48/0x1d0 [wl18xx]
    wlcore_op_set_key+0xa4/0x180 [wlcore]
    ieee80211_key_enable_hw_accel+0xb0/0x2d0 [mac80211]
    ieee80211_reenable_keys+0x70/0x110 [mac80211]
    ieee80211_reconfig+0xa00/0xca0 [mac80211]
    ieee80211_restart_work+0xc4/0xfc [mac80211]
    process_one_work+0x1cc/0x350
    worker_thread+0x13c/0x470
    kthread+0x154/0x160
    ret_from_fork+0x10/0x30
   ---[ end trace b1f722abf9af5919 ]---
   wlcore: WARNING could not set keys
   wlcore: ERROR Could not add or replace key
   wlan0: failed to set key (4, ff:ff:ff:ff:ff:ff) to hardware (-5)
   wlcore: Hardware recovery in progress. FW ver: Rev 8.9.0.0.79
   wlcore: pc: 0x0, hint_sts: 0x00000040 count: 39
   wlcore: down
   wlcore: down
   ieee80211 phy0: Hardware restart was requested
   mmc_host mmc0: Bus speed (slot 0) = 400000Hz (slot req 400000Hz, actual 400000HZ div = 0)
   mmc_host mmc0: Bus speed (slot 0) = 25000000Hz (slot req 25000000Hz, actual 25000000HZ div = 0)
   wlcore: PHY firmware version: Rev 8.2.0.0.242
   wlcore: firmware booted (Rev 8.9.0.0.79)
   wlcore: ERROR command execute failure 14
   ------------[ cut here ]------------

Tested on Hikey 970.

This reverts commit 2b7aadd3b9e17e8b81eeb8d9cc46756ae4658265.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/f0a2cb7ea606f1a284d4c23cbf983da2954ce9b6.1598420968.git.mchehab+huawei@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/cmd.h  | 1 -
 drivers/net/wireless/ti/wlcore/main.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 9acd8a41ea61f..f2609d5b6bf71 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -458,7 +458,6 @@ enum wl1271_cmd_key_type {
 	KEY_TKIP = 2,
 	KEY_AES  = 3,
 	KEY_GEM  = 4,
-	KEY_IGTK  = 5,
 };
 
 struct wl1271_cmd_set_keys {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index de6c8a7589ca3..ef169de992249 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3550,9 +3550,6 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 	case WL1271_CIPHER_SUITE_GEM:
 		key_type = KEY_GEM;
 		break;
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-		key_type = KEY_IGTK;
-		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
 
@@ -6222,7 +6219,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		WLAN_CIPHER_SUITE_TKIP,
 		WLAN_CIPHER_SUITE_CCMP,
 		WL1271_CIPHER_SUITE_GEM,
-		WLAN_CIPHER_SUITE_AES_CMAC,
 	};
 
 	/* The tx descriptor buffer */
-- 
2.25.1

