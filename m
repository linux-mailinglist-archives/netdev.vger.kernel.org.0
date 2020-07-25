Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0633922D9B0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 21:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgGYTzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 15:55:36 -0400
Received: from smtprelay0110.hostedemail.com ([216.40.44.110]:59088 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726727AbgGYTzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 15:55:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 9D4951822383C;
        Sat, 25 Jul 2020 19:55:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:541:968:973:988:989:1260:1311:1314:1345:1437:1515:1535:1606:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3355:3867:3870:3872:4117:4605:5007:6261:7974:10004:10848:11026:11657:11658:11914:12043:12296:12297:12679:12895:13894:14096:14394:21080:21433:21451:21611:21627:30029:30030:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: comb92_0614f4a26f52
X-Filterd-Recvd-Size: 6550
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:55:33 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] rtlwifi: Convert RT_TRACE to rtl_dbg and neatening
Date:   Sat, 25 Jul 2020 12:55:02 -0700
Message-Id: <cover.1595706419.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RT_TRACE seems like it should be associated to tracing but it's not.
It's a generic debug logging mechanism.
Rename it to a more typical name.
Miscellaneous neatening around these changes.

Joe Perches (6):
  rtlwifi: Convert RT_TRACE to rtl_dbg
  rtlwifi: Remove unnecessary parenthese in rtl_dbg uses
  rtlwifi: Better spacing around rtl_dbg uses
  rtlwifi: Convert rtl_dbg embedded function names to %s: ..., __func__
  rtlwifi: Avoid multiline dereferences in rtl_dbg uses
  rtlwifi: Convert sleeped to slept in rtl_dbg uses

 drivers/net/wireless/realtek/rtlwifi/base.c   | 144 +--
 .../rtlwifi/btcoexist/halbtc8192e2ant.c       | 733 ++++++++--------
 .../rtlwifi/btcoexist/halbtc8723b1ant.c       | 366 ++++----
 .../rtlwifi/btcoexist/halbtc8723b2ant.c       | 720 +++++++--------
 .../rtlwifi/btcoexist/halbtc8821a1ant.c       | 670 +++++++-------
 .../rtlwifi/btcoexist/halbtc8821a2ant.c       | 760 ++++++++--------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c  |  36 +-
 .../realtek/rtlwifi/btcoexist/rtl_btc.c       |   6 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c    |  82 +-
 drivers/net/wireless/realtek/rtlwifi/core.c   | 261 +++---
 drivers/net/wireless/realtek/rtlwifi/debug.c  |   4 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h  |  11 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c  |  72 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c    | 290 +++---
 drivers/net/wireless/realtek/rtlwifi/ps.c     |  98 +--
 drivers/net/wireless/realtek/rtlwifi/regd.c   |  18 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/dm.c   | 201 +++--
 .../wireless/realtek/rtlwifi/rtl8188ee/fw.c   |  90 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   | 194 ++---
 .../wireless/realtek/rtlwifi/rtl8188ee/led.c  |  20 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.c  | 385 ++++----
 .../wireless/realtek/rtlwifi/rtl8188ee/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  |  24 +-
 .../realtek/rtlwifi/rtl8192c/dm_common.c      | 225 +++--
 .../realtek/rtlwifi/rtl8192c/fw_common.c      |  88 +-
 .../realtek/rtlwifi/rtl8192c/phy_common.c     | 268 +++---
 .../wireless/realtek/rtlwifi/rtl8192ce/dm.c   |  40 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   | 178 ++--
 .../wireless/realtek/rtlwifi/rtl8192ce/led.c  |  12 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  | 121 ++-
 .../wireless/realtek/rtlwifi/rtl8192ce/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  |  14 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/dm.c   |  40 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   | 154 ++--
 .../wireless/realtek/rtlwifi/rtl8192cu/led.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  |  66 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/phy.c  | 134 +--
 .../wireless/realtek/rtlwifi/rtl8192cu/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  |  58 +-
 .../wireless/realtek/rtlwifi/rtl8192de/dm.c   | 314 +++----
 .../wireless/realtek/rtlwifi/rtl8192de/fw.c   | 116 +--
 .../wireless/realtek/rtlwifi/rtl8192de/hw.c   | 206 ++---
 .../wireless/realtek/rtlwifi/rtl8192de/led.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c  | 422 ++++-----
 .../wireless/realtek/rtlwifi/rtl8192de/rf.c   |  30 +-
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  |  20 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/dm.c   |  66 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/fw.c   | 102 +--
 .../wireless/realtek/rtlwifi/rtl8192ee/hw.c   | 208 ++---
 .../wireless/realtek/rtlwifi/rtl8192ee/led.c  |  18 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.c  | 357 ++++----
 .../wireless/realtek/rtlwifi/rtl8192ee/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  |  32 +-
 .../wireless/realtek/rtlwifi/rtl8192se/dm.c   |  42 +-
 .../wireless/realtek/rtlwifi/rtl8192se/fw.c   |  40 +-
 .../wireless/realtek/rtlwifi/rtl8192se/hw.c   | 158 ++--
 .../wireless/realtek/rtlwifi/rtl8192se/led.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8192se/phy.c  | 215 +++--
 .../wireless/realtek/rtlwifi/rtl8192se/rf.c   |  70 +-
 .../wireless/realtek/rtlwifi/rtl8192se/sw.c   |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192se/trx.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/dm.c   | 162 ++--
 .../wireless/realtek/rtlwifi/rtl8723ae/fw.c   |  64 +-
 .../rtlwifi/rtl8723ae/hal_bt_coexist.c        | 151 ++--
 .../realtek/rtlwifi/rtl8723ae/hal_btc.c       | 654 +++++++-------
 .../wireless/realtek/rtlwifi/rtl8723ae/hw.c   | 234 ++---
 .../wireless/realtek/rtlwifi/rtl8723ae/led.c  |  12 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.c  | 344 ++++----
 .../wireless/realtek/rtlwifi/rtl8723ae/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  |  14 +-
 .../wireless/realtek/rtlwifi/rtl8723be/dm.c   | 119 ++-
 .../wireless/realtek/rtlwifi/rtl8723be/fw.c   |  66 +-
 .../wireless/realtek/rtlwifi/rtl8723be/hw.c   | 202 ++---
 .../wireless/realtek/rtlwifi/rtl8723be/led.c  |  10 +-
 .../wireless/realtek/rtlwifi/rtl8723be/phy.c  | 309 ++++---
 .../wireless/realtek/rtlwifi/rtl8723be/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c  |  24 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.c    |  22 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.c   |  36 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/dm.c   | 823 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8821ae/fw.c   | 134 +--
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 466 +++++-----
 .../wireless/realtek/rtlwifi/rtl8821ae/led.c  |  32 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 538 ++++++------
 .../wireless/realtek/rtlwifi/rtl8821ae/rf.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.c  |  58 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c    |  18 +-
 87 files changed, 6766 insertions(+), 6811 deletions(-)

-- 
2.26.0

