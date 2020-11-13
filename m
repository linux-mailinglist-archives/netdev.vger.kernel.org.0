Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534742B18CE
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgKMKL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgKMKL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:11:56 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75DEC0613D1;
        Fri, 13 Nov 2020 02:11:55 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kdW3d-006shG-Bc; Fri, 13 Nov 2020 11:11:53 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-11-13
Date:   Fri, 13 Nov 2020 11:11:47 +0100
Message-Id: <20201113101148.25268-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

And here's another set of patches, this one for -next. Nothing
much stands out, perhaps apart from the WDS removal, but that
was old and pretty much dead code when we turned it off, so it
won't be missed.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit c9448e828d113cd7eafe77c414127e877ca88b20:

  Merge tag 'mlx5-updates-2020-11-03' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2020-11-05 18:01:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-11-13

for you to fetch changes up to da1e9dd3a11cda85b58dafe64f091734934b2f6c:

  nl80211: fix kernel-doc warning in the new SAE attribute (2020-11-11 08:39:13 +0100)

----------------------------------------------------------------
Some updates:
 * injection/radiotap updates for new test capabilities
 * remove WDS support - even years ago when we turned
   it off by default it was already basically unusable
 * support for HE (802.11ax) rates for beacons
 * support for some vendor-specific HE rates
 * many other small features/cleanups

----------------------------------------------------------------
Colin Ian King (1):
      nl80211/cfg80211: fix potential infinite loop

Johannes Berg (9):
      wireless: remove CONFIG_WIRELESS_WDS
      ath9k: remove WDS code
      carl9170: remove WDS code
      b43: remove WDS code
      b43legacy: remove WDS code
      rt2x00: remove WDS code
      mac80211: remove WDS-related code
      cfg80211: remove WDS code
      nl80211: fix kernel-doc warning in the new SAE attribute

Julia Lawall (1):
      mac80211: use semicolons rather than commas to separate statements

Kurt Lee (1):
      ieee80211: Add definition for WFA DPP

Mathy Vanhoef (4):
      mac80211: add radiotap flag to assure frames are not reordered
      mac80211: adhere to Tx control flag that prevents frame reordering
      mac80211: don't overwrite QoS TID of injected frames
      mac80211: assure that certain drivers adhere to DONT_REORDER flag

Pradeep Kumar Chitrapu (1):
      mac80211: save HE oper info in BSS config for mesh

Rajkumar Manoharan (2):
      nl80211: fix beacon tx rate mask validation
      cfg80211: add support to configure HE MCS for beacon rate

Rohan Dutta (1):
      cfg80211: Add support to configure SAE PWE value to drivers

Vamsi Krishna (1):
      cfg80211: Add support to calculate and report 4096-QAM HE rates

 drivers/net/wireless/Kconfig                      | 13 ----
 drivers/net/wireless/ath/ath9k/ath9k.h            |  1 -
 drivers/net/wireless/ath/ath9k/debug.c            |  4 +-
 drivers/net/wireless/ath/ath9k/init.c             | 19 -----
 drivers/net/wireless/ath/ath9k/main.c             |  5 --
 drivers/net/wireless/ath/carl9170/mac.c           |  4 --
 drivers/net/wireless/ath/carl9170/main.c          |  1 -
 drivers/net/wireless/broadcom/b43/main.c          |  6 +-
 drivers/net/wireless/broadcom/b43legacy/main.c    |  6 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c |  1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c    |  6 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c    |  3 +-
 include/linux/ieee80211.h                         |  3 +
 include/net/cfg80211.h                            | 21 ++++--
 include/net/ieee80211_radiotap.h                  |  1 +
 include/net/mac80211.h                            |  7 +-
 include/uapi/linux/nl80211.h                      | 38 +++++++++-
 net/mac80211/cfg.c                                | 11 ---
 net/mac80211/chan.c                               |  3 +-
 net/mac80211/debugfs_netdev.c                     | 11 ---
 net/mac80211/debugfs_sta.c                        |  2 +-
 net/mac80211/ieee80211_i.h                        |  6 --
 net/mac80211/iface.c                              | 52 ++------------
 net/mac80211/main.c                               |  8 ---
 net/mac80211/mesh.c                               | 30 ++++++++
 net/mac80211/pm.c                                 | 15 ----
 net/mac80211/rx.c                                 |  5 --
 net/mac80211/tx.c                                 | 39 +++--------
 net/mac80211/util.c                               |  2 +-
 net/mac80211/wme.c                                | 18 +++--
 net/wireless/chan.c                               |  6 +-
 net/wireless/core.c                               |  8 +--
 net/wireless/nl80211.c                            | 85 ++++++++++++-----------
 net/wireless/rdev-ops.h                           | 10 ---
 net/wireless/scan.c                               |  2 +-
 net/wireless/trace.h                              |  5 --
 net/wireless/util.c                               | 37 +++++-----
 net/wireless/wext-compat.c                        | 51 --------------
 38 files changed, 198 insertions(+), 347 deletions(-)

