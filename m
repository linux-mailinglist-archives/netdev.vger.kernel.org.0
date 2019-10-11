Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B332AD3BBE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfJKI5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:57:53 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34772 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfJKI5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 04:57:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iIqk9-0005yz-TB; Fri, 11 Oct 2019 10:57:50 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next next-2019-10-11
Date:   Fri, 11 Oct 2019 10:57:35 +0200
Message-Id: <20191011085736.15772-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Let me try to be a bit "maintainer-of-the-day agnostic" ;-)

I'll be going on vacation, but figured I'd at least get this
stuff out. As usual, I ran the hwsim tests from wpa_s/hostapd
and all looks fine, compilation also was OK.

Kalle has agreed to help cover when I'm on vacation (though
I'm home next week, so if there's any fallout I'll deal with
it then), so if there's something urgent he may include some
stack changes in his trees or ask you to or apply a patch.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 9077f052abd5391a866dd99e27212213648becef:

  net: propagate errors correctly in register_netdevice() (2019-10-03 12:31:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2019-10-11

for you to fetch changes up to 7dfd8ac327301f302b03072066c66eb32578e940:

  mac80211_hwsim: add support for OCB (2019-10-11 10:33:34 +0200)

----------------------------------------------------------------
A few more small things, nothing really stands out:
 * minstrel improvements from Felix
 * a TX aggregation simplification
 * some additional capabilities for hwsim
 * minor cleanups & docs updates

----------------------------------------------------------------
Denis Kenzior (1):
      nl80211: trivial: Remove redundant loop

Felix Fietkau (3):
      mac80211: minstrel: remove divisions in tx status path
      mac80211: minstrel_ht: replace rate stats ewma with a better moving average
      mac80211: minstrel_ht: rename prob_ewma to prob_avg, use it for the new average

Johannes Berg (2):
      mac80211: pass internal sta to ieee80211_tx_frags()
      mac80211: simplify TX aggregation start

Koen Vandeputte (1):
      mac80211: IBSS: avoid unneeded return value processing

Ramon Fontes (2):
      mac80211_hwsim: add more 5GHz channels, 5/10 MHz support
      mac80211_hwsim: add support for OCB

Sunil Dutt (1):
      nl80211: Document the expectation for NL80211_ATTR_IE in NL80211_CMD_CONNECT

 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  2 +-
 drivers/net/wireless/ath/carl9170/main.c           |  3 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  5 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |  3 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  5 +-
 drivers/net/wireless/mac80211_hwsim.c              | 37 +++++++++--
 drivers/net/wireless/marvell/mwl8k.c               |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  3 +-
 drivers/net/wireless/mediatek/mt7601u/main.c       |  3 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  4 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  3 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |  3 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  3 +-
 include/net/mac80211.h                             | 11 +++-
 include/uapi/linux/nl80211.h                       |  8 +++
 net/mac80211/agg-tx.c                              |  9 ++-
 net/mac80211/ibss.c                                |  9 +--
 net/mac80211/rc80211_minstrel.c                    | 48 +++++++-------
 net/mac80211/rc80211_minstrel.h                    | 57 +++++++++++++++--
 net/mac80211/rc80211_minstrel_debugfs.c            |  8 +--
 net/mac80211/rc80211_minstrel_ht.c                 | 73 ++++++++++++----------
 net/mac80211/rc80211_minstrel_ht.h                 |  2 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c         |  8 +--
 net/mac80211/tx.c                                  | 15 ++---
 net/wireless/nl80211.c                             |  6 +-
 30 files changed, 212 insertions(+), 130 deletions(-)

