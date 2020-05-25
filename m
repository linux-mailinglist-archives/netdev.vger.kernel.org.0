Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B895F1E1064
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403957AbgEYOWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390867AbgEYOWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 10:22:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8E9C061A0E;
        Mon, 25 May 2020 07:22:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdE00-002lqM-4Z; Mon, 25 May 2020 16:22:40 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next next-2020-04-25
Date:   Mon, 25 May 2020 16:22:32 +0200
Message-Id: <20200525142233.42467-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here's a batch of updates for net-next. I didn't get through
everything yet, but Kalle needed some of the changes here
(the ones related to DPP) for some driver changes, so here
it is.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1802136023c010759d9ed1ff2b6384bcbf5eb3f9:

  Merge branch 'ovs-meter-tables' (2020-04-23 18:26:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-04-25

for you to fetch changes up to 60689de46c7f6a0028c8b37b6f03db68cbfad8ed:

  mac80211: fix memory overlap due to variable length param (2020-04-29 16:21:45 +0200)

----------------------------------------------------------------
One batch of changes, containing:
 * hwsim improvements from Jouni and myself, to be able to
   test more scenarios easily
 * some more HE (802.11ax) support
 * some initial S1G (sub 1 GHz) work for fractional MHz channels
 * some (action) frame registration updates to help DPP support
 * along with other various improvements/fixes

----------------------------------------------------------------
Andrei Otcheretianski (1):
      mac80211: Don't destroy auth data in case of anti-clogging

Ilan Peer (3):
      cfg80211: Parse HE membership selector
      mac80211: Skip entries with HE membership selector
      mac80211: Fail association when AP has no legacy rates

Johannes Berg (13):
      mac80211_hwsim: notify wmediumd of used MAC addresses
      mac80211: mlme: remove duplicate AID bookkeeping
      mac80211: fix drv_config_iface_filter() behaviour
      cfg80211: change internal management frame registration API
      cfg80211: support multicast RX registration
      nl80211: allow client-only BIGTK support
      mac80211: implement Operating Mode Notification extended NSS support
      mac80211: minstrel_ht_assign_best_tp_rates: remove redundant test
      mac80211_hwsim: indicate in IBSS that we have transmitted beacons
      cfg80211: reject channels/chandefs with KHz offset >= 1000
      mac80211: fix two missing documentation entries
      staging: rtl8723bs: remove mgmt_frame_register method
      staging: wilc1000: adjust for management frame register API changes

Jouni Malinen (6):
      cfg80211: Unprotected Beacon frame RX indication
      mac80211: Report beacon protection failures to user space
      mac80211: Process multicast RX registration for Action frames
      mac80211_hwsim: Advertise support for multicast RX registration
      mac80211: TX legacy rate control for Beacon frames
      mac80211_hwsim: Claim support for setting Beacon frame TX legacy rate

Mordechay Goodstein (2):
      mac80211: agg-tx: refactor sending addba
      mac80211: agg-tx: add an option to defer ADDBA transmit

Rajkumar Manoharan (1):
      mac80211: fix memory overlap due to variable length param

Shaul Triebitz (1):
      mac80211: add twt_protected flag to the bss_conf structure

Thomas Pedersen (4):
      ieee80211: share 802.11 unit conversion helpers
      cfg80211: express channels with a KHz component
      mac80211: handle channel frequency offset
      mac80211: add freq_offset to RX status

 drivers/net/wireless/ath/ath11k/mac.c              |   3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  26 ++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  19 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   6 +-
 drivers/net/wireless/mac80211_hwsim.c              |  63 ++++++++++
 drivers/net/wireless/mac80211_hwsim.h              |   8 ++
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  16 +--
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  83 +++++++------
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |  24 ----
 drivers/staging/wilc1000/cfg80211.c                |  36 +++---
 drivers/staging/wilc1000/cfg80211.h                |   5 +-
 drivers/staging/wilc1000/netdev.c                  |  21 ++--
 drivers/staging/wilc1000/netdev.h                  |   9 +-
 include/linux/ieee80211.h                          |  23 +++-
 include/net/cfg80211.h                             | 134 ++++++++++++++++++---
 include/net/mac80211.h                             |  35 +++++-
 include/net/regulatory.h                           |   7 --
 include/uapi/linux/nl80211.h                       |  23 ++++
 net/mac80211/agg-tx.c                              |  79 +++++++-----
 net/mac80211/cfg.c                                 |  93 +++++++++-----
 net/mac80211/chan.c                                |   1 +
 net/mac80211/debugfs_netdev.c                      |   2 +-
 net/mac80211/he.c                                  |  13 +-
 net/mac80211/ibss.c                                |   5 +
 net/mac80211/ieee80211_i.h                         |   9 +-
 net/mac80211/iface.c                               |   5 +
 net/mac80211/main.c                                |  11 +-
 net/mac80211/mesh.c                                |   1 +
 net/mac80211/mlme.c                                |  62 +++++++---
 net/mac80211/offchannel.c                          |   4 +
 net/mac80211/rc80211_minstrel_ht.c                 |   3 +-
 net/mac80211/rx.c                                  |  17 ++-
 net/mac80211/scan.c                                |   4 +-
 net/mac80211/sta_info.h                            |   4 +
 net/mac80211/tdls.c                                |   7 +-
 net/mac80211/trace.h                               |  41 +++++--
 net/mac80211/tx.c                                  |   7 +-
 net/mac80211/vht.c                                 |  10 +-
 net/wireless/chan.c                                |  71 ++++++-----
 net/wireless/core.c                                |  10 +-
 net/wireless/core.h                                |   9 +-
 net/wireless/mlme.c                                | 106 ++++++++--------
 net/wireless/nl80211.c                             |  44 ++++++-
 net/wireless/rdev-ops.h                            |  11 +-
 net/wireless/reg.c                                 |  40 +++---
 net/wireless/scan.c                                |   4 +-
 net/wireless/sme.c                                 |   2 +
 net/wireless/trace.h                               |  41 ++++---
 net/wireless/util.c                                |  58 +++++----
 49 files changed, 873 insertions(+), 442 deletions(-)

