Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CC230C234
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhBBOoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbhBBOl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:41:56 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5166BC061573;
        Tue,  2 Feb 2021 06:41:13 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l6wrf-00EuM5-L5; Tue, 02 Feb 2021 15:41:11 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-02-02
Date:   Tue,  2 Feb 2021 15:41:05 +0100
Message-Id: <20210202144106.38207-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

And for mac80211-next, I have only locking fixes right now. I'm
happy that it otherwise seems to be fine though, now no new bugs
have been reported for a few days.

I might send some more things your way another day, but wanted
to get the locking fixes out sooner.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit d1f3bdd4eaae1222063c2f309625656108815915:

  net: dsa: rtl8366rb: standardize init jam tables (2021-01-27 20:21:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-02-02

for you to fetch changes up to 40c575d1ec71f7a61c73ba1603a69650c130559c:

  cfg80211: fix netdev registration deadlock (2021-02-01 19:30:54 +0100)

----------------------------------------------------------------
This time, only RTNL locking reduction fallout.
 - cfg80211_dev_rename() requires RTNL
 - cfg80211_change_iface() and cfg80211_set_encryption()
   require wiphy mutex (was missing in wireless extensions)
 - cfg80211_destroy_ifaces() requires wiphy mutex
 - netdev registration can fail due to notifiers, and then
   notifiers are "unrolled", need to handle this properly

----------------------------------------------------------------
Johannes Berg (5):
      nl80211: call cfg80211_dev_rename() under RTNL
      wext: call cfg80211_change_iface() with wiphy lock held
      wext: call cfg80211_set_encryption() with wiphy lock held
      cfg80211: call cfg80211_destroy_ifaces() with wiphy lock held
      cfg80211: fix netdev registration deadlock

 include/net/cfg80211.h     |  4 +++-
 net/wireless/core.c        |  7 ++++++-
 net/wireless/nl80211.c     |  2 +-
 net/wireless/wext-compat.c | 14 ++++++++++++--
 4 files changed, 22 insertions(+), 5 deletions(-)

