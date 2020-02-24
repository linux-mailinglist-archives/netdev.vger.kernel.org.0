Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F18C16AF40
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgBXSev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:34:51 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41994 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:34:51 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j6IZ6-007NT1-Ei; Mon, 24 Feb 2020 19:34:48 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next next-2020-02-24
Date:   Mon, 24 Feb 2020 19:34:41 +0100
Message-Id: <20200224183442.82066-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Some new updates - initial beacon protection support and TID
configuration are the interesting parts, but need drivers to
fill in, so that'll come from Kalle later :)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 92df9f8a745ee9b8cc250514272345cb2e74e7ef:

  Merge branch 'mvneta-xdp-ethtool-stats' (2020-02-16 20:04:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-02-24

for you to fetch changes up to 370f51d5edac83bfdb9a078d7098f06403dfa4bc:

  mac80211: Add api to support configuring TID specific configuration (2020-02-24 14:07:01 +0100)

----------------------------------------------------------------
A new set of changes:
 * lots of small documentation fixes, from Jérôme Pouiller
 * beacon protection (BIGTK) support from Jouni Malinen
 * some initial code for TID configuration, from Tamizh chelvam
 * I reverted some new API before it's actually used, because
   it's wrong to mix controlled port and preauth
 * a few other cleanups/fixes

----------------------------------------------------------------
Amol Grover (1):
      cfg80211: Pass lockdep expression to RCU lists

Emmanuel Grumbach (1):
      cfg80211: remove support for adjacent channel compensation

Johannes Berg (4):
      mac80211: check vif pointer before airtime calculation
      Revert "mac80211: support NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211_MAC_ADDRS"
      Revert "nl80211: add src and dst addr attributes for control port tx/rx"
      nl80211: modify TID-config API

Jouni Malinen (7):
      cfg80211: More error messages for key addition failures
      cfg80211: Support key configuration for Beacon protection (BIGTK)
      mac80211: Support BIGTK configuration for Beacon protection
      mac80211: Update BIP to support Beacon frames
      mac80211: Beacon protection using the new BIGTK (AP)
      mac80211: Beacon protection using the new BIGTK (STA)
      mac80211_hwsim: enable Beacon protection

Jérôme Pouiller (9):
      cfg80211: drop duplicated documentation of field "probe_resp_offload"
      cfg80211: drop duplicated documentation of field "privid"
      cfg80211: drop duplicated documentation of field "registered"
      cfg80211: drop duplicated documentation of field "_net"
      cfg80211: drop duplicated documentation of field "perm_addr"
      cfg80211: drop duplicated documentation of field "reg_notifier"
      cfg80211: merge documentations of field "debugfsdir"
      cfg80211: merge documentations of field "dev"
      cfg80211: fix indentation errors

Tamizh chelvam (5):
      nl80211: Add NL command to support TID speicific configurations
      nl80211: Add support to configure TID specific retry configuration
      nl80211: Add support to configure TID specific AMPDU configuration
      nl80211: Add support to configure TID specific RTSCTS configuration
      mac80211: Add api to support configuring TID specific configuration

 drivers/net/wireless/mac80211_hwsim.c |   1 +
 include/net/cfg80211.h                | 122 +++++++++-----
 include/net/mac80211.h                |  10 ++
 include/uapi/linux/nl80211.h          | 114 +++++++++++--
 net/mac80211/aes_cmac.c               |  21 ++-
 net/mac80211/aes_gmac.c               |  24 ++-
 net/mac80211/cfg.c                    |  71 +++++++-
 net/mac80211/debugfs_key.c            |  31 ++++
 net/mac80211/debugfs_key.h            |  10 ++
 net/mac80211/driver-ops.h             |  27 +++
 net/mac80211/ieee80211_i.h            |   9 +-
 net/mac80211/key.c                    |  40 ++++-
 net/mac80211/key.h                    |   3 +
 net/mac80211/main.c                   |   2 -
 net/mac80211/rx.c                     |  79 +++++++--
 net/mac80211/scan.c                   |   3 +-
 net/mac80211/sta_info.h               |   4 +-
 net/mac80211/tx.c                     |  35 +++-
 net/wireless/nl80211.c                | 298 ++++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h               |  45 ++++-
 net/wireless/scan.c                   |  11 +-
 net/wireless/sme.c                    |  11 +-
 net/wireless/trace.h                  |  81 +++++++--
 net/wireless/util.c                   |   7 +-
 24 files changed, 909 insertions(+), 150 deletions(-)

