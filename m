Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AED3A179E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbhFIOon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbhFIOom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:44:42 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D91CC061574;
        Wed,  9 Jun 2021 07:42:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lqzPq-004Hl0-Ds; Wed, 09 Jun 2021 16:42:46 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-06-09
Date:   Wed,  9 Jun 2021 16:42:42 +0200
Message-Id: <20210609144243.97486-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The last pull request I sent was coordinated with only
those CVE fixes - now I have accumulated more fixes,
many of them actually locking fixes for the RTNL redux.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 593f555fbc6091bbaec8dd2a38b47ee643412e61:

  net: stmmac: fix kernel panic due to NULL pointer dereference of mdio_bus_data (2021-05-30 13:41:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-06-09

for you to fetch changes up to a9799541ca34652d9996e45f80e8e03144c12949:

  mac80211: drop multicast fragments (2021-06-09 16:17:45 +0200)

----------------------------------------------------------------
A fair number of fixes:
 * fix more fallout from RTNL locking changes
 * fixes for some of the bugs found by syzbot
 * drop multicast fragments in mac80211 to align
   with the spec and what drivers are doing now
 * fix NULL-ptr deref in radiotap injection

----------------------------------------------------------------
Brian Norris (1):
      mac80211: correct ieee80211_iterate_active_interfaces_mtx() locking comments

Du Cheng (2):
      cfg80211: call cfg80211_leave_ocb when switching away from OCB
      mac80211: fix skb length check in ieee80211_scan_rx()

Johannes Berg (9):
      mac80211: remove warning in ieee80211_get_sband()
      mac80211_hwsim: drop pending frames on stop
      staging: rtl8723bs: fix monitor netdev register/unregister
      mac80211: fix deadlock in AP/VLAN handling
      mac80211: fix 'reset' debugfs locking
      cfg80211: fix phy80211 symlink creation
      cfg80211: shut down interfaces on failed resume
      mac80211: move interface shutdown out of wiphy lock
      mac80211: drop multicast fragments

Mathy Vanhoef (1):
      mac80211: Fix NULL ptr deref for injected rate info

 drivers/net/wireless/mac80211_hwsim.c             |  5 +++
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |  4 +-
 include/net/mac80211.h                            |  9 +++-
 net/mac80211/debugfs.c                            | 11 ++++-
 net/mac80211/ieee80211_i.h                        |  2 +-
 net/mac80211/iface.c                              | 19 ++++++---
 net/mac80211/main.c                               |  7 ++-
 net/mac80211/rx.c                                 |  9 ++--
 net/mac80211/scan.c                               | 21 ++++++---
 net/mac80211/tx.c                                 | 52 ++++++++++++++++-------
 net/mac80211/util.c                               |  2 -
 net/wireless/core.c                               | 13 +++---
 net/wireless/sysfs.c                              |  4 ++
 net/wireless/util.c                               |  3 ++
 14 files changed, 109 insertions(+), 52 deletions(-)

