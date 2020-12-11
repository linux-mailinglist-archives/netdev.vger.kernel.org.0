Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A865B2D77CC
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbgLKO0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732873AbgLKO0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:26:41 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3958EC0613CF;
        Fri, 11 Dec 2020 06:26:00 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1knjMr-006pW4-KB; Fri, 11 Dec 2020 15:25:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-12-11
Date:   Fri, 11 Dec 2020 15:25:51 +0100
Message-Id: <20201211142552.209018-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Welcome back!

I'm a bit late with this, I guess, but I hope you can still
pull it into net-next for 5.11. Nothing really stands out,
we have some 6 GHz fixes, and various small things all over.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 91163f82143630a9629a8bf0227d49173697c69c:

  Merge branch 'add-ppp_generic-ioctls-to-bridge-channels' (2020-12-10 13:58:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-12-11

for you to fetch changes up to c534e093d865d926d042e0a3f228d1152627ccab:

  mac80211: add ieee80211_set_sar_specs (2020-12-11 13:39:59 +0100)

----------------------------------------------------------------
A new set of wireless changes:
 * validate key indices for key deletion
 * more preamble support in mac80211
 * various 6 GHz scan fixes/improvements
 * a common SAR power limitations API
 * various small fixes & code improvements

----------------------------------------------------------------
Anant Thazhemadam (1):
      nl80211: validate key indexes for cfg80211_registered_device

Avraham Stern (3):
      nl80211: always accept scan request with the duration set
      ieee80211: update reduced neighbor report TBTT info length
      mac80211: support Rx timestamp calculation for all preamble types

Ayala Beker (1):
      cfg80211: scan PSC channels in case of scan with wildcard SSID

Carl Huang (2):
      nl80211: add common API to configure SAR power limitations
      mac80211: add ieee80211_set_sar_specs

Colin Ian King (1):
      net: wireless: make a const array static, makes object smaller

Emmanuel Grumbach (2):
      rfkill: add a reason to the HW rfkill state
      mac80211: don't filter out beacons once we start CSA

Gustavo A. R. Silva (3):
      cfg80211: Fix fall-through warnings for Clang
      mac80211: Fix fall-through warnings for Clang
      nl80211: Fix fall-through warnings for Clang

Ilan Peer (6):
      cfg80211: Parse SAE H2E only membership selector
      mac80211: Skip entries with SAE H2E only membership selector
      cfg80211: Update TSF and TSF BSSID for multi BSS
      cfg80211: Save the regulatory domain when setting custom regulatory
      mac80211: Fix calculation of minimal channel width
      mac80211: Update rate control on channel change

Johannes Berg (10):
      mac80211: support MIC error/replay detected counters driver update
      mac80211: disallow band-switch during CSA
      cfg80211: include block-tx flag in channel switch started event
      cfg80211: remove struct ieee80211_he_bss_color
      mac80211: use struct assignment for he_obss_pd
      cfg80211: support immediate reconnect request hint
      mac80211: support driver-based disconnect with reconnect hint
      mac80211: don't set set TDLS STA bandwidth wider than possible
      mac80211: use bitfield helpers for BA session action frames
      mac80211: ignore country element TX power on 6 GHz

Lev Stipakov (1):
      net: mac80211: use core API for updating TX/RX stats

Sami Tolvanen (1):
      cfg80211: fix callback type mismatches in wext-compat

Shaul Triebitz (1):
      mac80211: he: remove non-bss-conf fields from bss_conf

Tom Rix (1):
      mac80211: remove trailing semicolon in macro definitions

Wen Gong (2):
      mac80211: mlme: save ssid info to ieee80211_bss_conf while assoc
      mac80211: fix a mistake check for rx_stats update

 include/linux/ieee80211.h     |   9 +-
 include/linux/rfkill.h        |  24 ++++-
 include/net/cfg80211.h        |  75 ++++++++++---
 include/net/mac80211.h        |  35 ++++++-
 include/uapi/linux/nl80211.h  | 114 +++++++++++++++++++-
 include/uapi/linux/rfkill.h   |  16 ++-
 net/mac80211/agg-rx.c         |   8 +-
 net/mac80211/agg-tx.c         |  12 +--
 net/mac80211/cfg.c            |  22 +++-
 net/mac80211/chan.c           |  71 ++++++++++++-
 net/mac80211/debugfs.c        |   2 +-
 net/mac80211/debugfs_key.c    |   2 +-
 net/mac80211/debugfs_netdev.c |   6 +-
 net/mac80211/debugfs_sta.c    |   2 +-
 net/mac80211/ieee80211_i.h    |  14 +--
 net/mac80211/key.c            |  49 +++++++++
 net/mac80211/mlme.c           | 123 +++++++++++++++-------
 net/mac80211/rx.c             |  20 +---
 net/mac80211/trace.h          |  23 +++-
 net/mac80211/tx.c             |  16 +--
 net/mac80211/util.c           |  66 +++++++++++-
 net/mac80211/vht.c            |  14 ++-
 net/rfkill/core.c             |  41 ++++++--
 net/wireless/core.h           |   2 +
 net/wireless/mlme.c           |  26 +++--
 net/wireless/nl80211.c        | 239 ++++++++++++++++++++++++++++++++++++++----
 net/wireless/nl80211.h        |   8 +-
 net/wireless/rdev-ops.h       |  12 +++
 net/wireless/reg.c            |  10 +-
 net/wireless/scan.c           |  21 ++--
 net/wireless/trace.h          |  31 +++++-
 net/wireless/util.c           |  52 +++++++--
 net/wireless/wext-compat.c    | 103 ++++++++++++------
 33 files changed, 1041 insertions(+), 227 deletions(-)

