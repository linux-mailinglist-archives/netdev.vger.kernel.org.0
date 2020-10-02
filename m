Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81128105F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 12:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgJBKLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 06:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBKLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 06:11:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3CCC0613D0;
        Fri,  2 Oct 2020 03:11:36 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOI2H-00FAum-Tl; Fri, 02 Oct 2020 12:11:34 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-10-02
Date:   Fri,  2 Oct 2020 12:11:25 +0200
Message-Id: <20201002101126.221601-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here's a - probably final - set of patches for net-next.
Really the big thing is more complete S1G support, along
with a small list of other things, see the tag message.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 0675c285ea65540cccae64c87dfc7a00c7ede03a:

  net: vlan: Fixed signedness in vlan_group_prealloc_vid() (2020-09-28 00:51:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2020-10-02

for you to fetch changes up to 75f87eaeaced820cc776b3147d22ec44fbf5fc17:

  mac80211: avoid processing non-S1G elements on S1G band (2020-10-02 12:07:24 +0200)

----------------------------------------------------------------
Another set of changes, this time with:
 * lots more S1G band support
 * 6 GHz scanning, finally
 * kernel-doc fixes
 * non-split wiphy dump fixes in nl80211
 * various other small cleanups/features

----------------------------------------------------------------
Ben Greear (1):
      mac80211: Support not iterating over not-sdata-in-driver ifaces

Dan Carpenter (1):
      cfg80211: regulatory: remove a bogus initialization

Felix Fietkau (1):
      mac80211: fix regression in sta connection monitor

Johannes Berg (6):
      mac80211_hwsim: fix typo in kernel-doc
      mac80211: fix some missing kernel-doc
      wireless: radiotap: fix some kernel-doc
      mac80211: fix some more kernel-doc in mesh
      nl80211: reduce non-split wiphy dump size
      nl80211: fix non-split wiphy information

Loic Poulain (1):
      mac80211: Inform AP when returning operating channel

Rajkumar Manoharan (2):
      nl80211: fix OBSS PD min and max offset validation
      nl80211: extend support to config spatial reuse parameter set

Thomas Pedersen (18):
      mac80211: get correct default channel width for S1G
      mac80211: s1g: choose scanning width based on frequency
      nl80211: support S1G capability overrides in assoc
      mac80211: support S1G STA capabilities
      cfg80211: convert S1G beacon to scan results
      cfg80211: parse S1G Operation element for BSS channel
      mac80211: convert S1G beacon to scan results
      cfg80211: handle Association Response from S1G STA
      mac80211: encode listen interval for S1G
      mac80211: don't calculate duration for S1G
      mac80211: handle S1G low rates
      mac80211: avoid rate init for S1G band
      mac80211: receive and process S1G beacons
      mac80211: support S1G association
      nl80211: include frequency offset in survey info
      mac80211_hwsim: write TSF timestamp correctly to S1G beacon
      mac80211_hwsim: indicate support for S1G
      mac80211: avoid processing non-S1G elements on S1G band

Tova Mussai (1):
      nl80211/cfg80211: support 6 GHz scanning

 drivers/net/wireless/mac80211_hwsim.c | 100 +++++-
 include/linux/ieee80211.h             |  74 ++++-
 include/net/cfg80211.h                |  45 ++-
 include/net/mac80211.h                |   8 +
 include/uapi/linux/nl80211.h          |  25 ++
 net/mac80211/cfg.c                    |   2 +
 net/mac80211/chan.c                   |   9 +-
 net/mac80211/ibss.c                   |   3 +-
 net/mac80211/ieee80211_i.h            |  19 +-
 net/mac80211/iface.c                  |   5 +
 net/mac80211/mesh_plink.c             |   1 +
 net/mac80211/mesh_ps.c                |   4 +
 net/mac80211/mlme.c                   | 179 +++++++++--
 net/mac80211/offchannel.c             |  38 +--
 net/mac80211/rate.c                   |  39 ++-
 net/mac80211/rx.c                     |  87 +++--
 net/mac80211/scan.c                   |  43 ++-
 net/mac80211/status.c                 |  16 +-
 net/mac80211/tx.c                     |   6 +
 net/mac80211/util.c                   | 193 +++++++++++
 net/wireless/core.c                   |   8 +-
 net/wireless/core.h                   |   5 +-
 net/wireless/mlme.c                   |  14 +-
 net/wireless/nl80211.c                | 115 +++++--
 net/wireless/radiotap.c               |   1 +
 net/wireless/reg.c                    |   2 +-
 net/wireless/scan.c                   | 581 ++++++++++++++++++++++++++++++++--
 27 files changed, 1423 insertions(+), 199 deletions(-)

