Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28D413BD06
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 11:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgAOKDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 05:03:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:37868 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgAOKDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 05:03:40 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1irfWT-008lR3-Q9; Wed, 15 Jan 2020 11:03:37 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-01-15
Date:   Wed, 15 Jan 2020 11:03:32 +0100
Message-Id: <20200115100333.40963-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a small set of fixes for the current cycle still. Most
issues are actually older and tagged with appropriate Fixes
etc.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 738d2902773e30939a982c8df7a7f94293659810:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-12-31 11:14:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-01-15

for you to fetch changes up to 81c044fc3bdc5b7be967cd3682528ea94b58c06a:

  cfg80211: fix page refcount issue in A-MSDU decap (2020-01-15 09:53:35 +0100)

----------------------------------------------------------------
A few fixes:
 * -O3 enablement fallout, thanks to Arnd who ran this
 * fixes for a few leaks, thanks to Felix
 * channel 12 regulatory fix for custom regdomains
 * check for a crash reported by syzbot
   (NULL function is called on drivers that don't have it)
 * fix TKIP replay protection after setup with some APs
   (from Jouni)
 * restrict obtaining some mesh data to avoid WARN_ONs
 * fix deadlocks with auto-disconnect (socket owner)
 * fix radar detection events with multiple devices

----------------------------------------------------------------
Arnd Bergmann (1):
      wireless: wext: avoid gcc -O3 warning

Felix Fietkau (3):
      cfg80211: fix memory leak in nl80211_probe_mesh_link
      cfg80211: fix memory leak in cfg80211_cqm_rssi_update
      cfg80211: fix page refcount issue in A-MSDU decap

Ganapathi Bhat (1):
      wireless: fix enabling channel 12 for custom regulatory domain

Johannes Berg (1):
      cfg80211: check for set_wiphy_params

Jouni Malinen (1):
      mac80211: Fix TKIP replay protection immediately after key setup

Markus Theil (2):
      mac80211: mesh: restrict airtime metric to peered established plinks
      cfg80211: fix deadlocks in autodisconnect work

Orr Mazor (1):
      cfg80211: Fix radar event during another phy CAC

 include/net/cfg80211.h   |  5 +++++
 net/mac80211/cfg.c       | 23 +++++++++++++++++++++++
 net/mac80211/mesh_hwmp.c |  3 +++
 net/mac80211/tkip.c      | 18 +++++++++++++++---
 net/wireless/nl80211.c   |  3 +++
 net/wireless/rdev-ops.h  | 14 ++++++++++++++
 net/wireless/reg.c       | 36 ++++++++++++++++++++++++++++++++----
 net/wireless/sme.c       |  6 +++---
 net/wireless/trace.h     |  5 +++++
 net/wireless/util.c      |  2 +-
 net/wireless/wext-core.c |  3 ++-
 11 files changed, 106 insertions(+), 12 deletions(-)

