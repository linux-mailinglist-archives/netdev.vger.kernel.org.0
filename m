Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A83AFD7A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfIKNNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:13:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40576 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfIKNNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:13:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i82R7-00086x-GK; Wed, 11 Sep 2019 15:13:29 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-09-11
Date:   Wed, 11 Sep 2019 15:13:25 +0200
Message-Id: <20190911131326.24032-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

As detailed below, here are some more changes for -next, almost
certainly the final round since the merge window is around the
corner now.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit c76c992525245ec1c7b6738bf887c42099abab02:

  nexthops: remove redundant assignment to variable err (2019-08-22 12:14:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-09-11

for you to fetch changes up to c1d3ad84eae35414b6b334790048406bd6301b12:

  cfg80211: Purge frame registrations on iftype change (2019-09-11 10:45:10 +0200)

----------------------------------------------------------------
We have a number of changes, but things are settling down:
 * a fix in the new 6 GHz channel support
 * a fix for recent minstrel (rate control) updates
   for an infinite loop
 * handle interface type changes better wrt. management frame
   registrations (for management frames sent to userspace)
 * add in-BSS RX time to survey information
 * handle HW rfkill properly if !CONFIG_RFKILL
 * send deauth on IBSS station expiry, to avoid state mismatches
 * handle deferred crypto tailroom updates in mac80211 better
   when device restart happens
 * fix a spectre-v1 - really a continuation of a previous patch
 * advertise NL80211_CMD_UPDATE_FT_IES as supported if so
 * add some missing parsing in VHT extended NSS support
 * support HE in mac80211_hwsim
 * let mac80211 drivers determine the max MTU themselves
along with the usual cleanups etc.

----------------------------------------------------------------
Arend van Spriel (1):
      cfg80211: fix boundary value in ieee80211_frequency_to_channel()

Colin Ian King (1):
      mac80211: minstrel_ht: fix infinite loop because supported is not being shifted

Denis Kenzior (1):
      cfg80211: Purge frame registrations on iftype change

Felix Fietkau (1):
      cfg80211: add local BSS receive time to survey information

Johannes Berg (4):
      cfg80211: always shut down on HW rfkill
      mac80211: list features in WEP/TKIP disable in better order
      mac80211: remove unnecessary key condition
      mac80211: IBSS: send deauth when expiring inactive STAs

Lior Cohen (1):
      mac80211: clear crypto tx tailroom counter upon keys enable

Luca Coelho (1):
      mac80211: don't check if key is NULL in ieee80211_key_link()

Masashi Honma (1):
      nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds

Matthew Wang (1):
      nl80211: add NL80211_CMD_UPDATE_FT_IES to supported commands

Mordechay Goodstein (1):
      mac80211: vht: add support VHT EXT NSS BW in parsing VHT

Sven Eckelmann (1):
      mac80211_hwsim: Register support for HE meshpoint

Wen Gong (1):
      mac80211: allow drivers to set max MTU

zhong jiang (1):
      cfg80211: Do not compare with boolean in nl80211_common_reg_change_event

 drivers/net/wireless/mac80211_hwsim.c | 283 +++++++++++++++++++++++-----------
 include/net/cfg80211.h                |   4 +
 include/net/mac80211.h                |   3 +
 include/uapi/linux/nl80211.h          |   3 +
 net/mac80211/ibss.c                   |   8 +
 net/mac80211/ieee80211_i.h            |   3 +-
 net/mac80211/iface.c                  |   2 +-
 net/mac80211/key.c                    |  48 ++----
 net/mac80211/key.h                    |   4 +-
 net/mac80211/main.c                   |   1 +
 net/mac80211/mlme.c                   |  13 +-
 net/mac80211/rc80211_minstrel_ht.c    |   2 +-
 net/mac80211/util.c                   |  11 +-
 net/mac80211/vht.c                    |  10 +-
 net/wireless/core.c                   |  13 +-
 net/wireless/core.h                   |   2 +-
 net/wireless/nl80211.c                |  17 +-
 net/wireless/util.c                   |   3 +-
 net/wireless/wext-compat.c            |   5 +-
 19 files changed, 274 insertions(+), 161 deletions(-)

