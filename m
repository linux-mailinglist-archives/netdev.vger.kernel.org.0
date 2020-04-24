Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31211B711F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDXJmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726489AbgDXJms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 05:42:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66484C09B045;
        Fri, 24 Apr 2020 02:42:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jRur8-00FRkz-9F; Fri, 24 Apr 2020 11:42:46 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-04-24
Date:   Fri, 24 Apr 2020 11:42:37 +0200
Message-Id: <20200424094238.13194-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Just a couple of changes, the most relevant part is the debugfs
fixes after the recent race fix.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 7c74b0bec918c1e0ca0b4208038c156eacf8f13f:

  ipv4: Update fib_select_default to handle nexthop objects (2020-04-22 19:57:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2020-04-24

for you to fetch changes up to 8ca47eb9f9e4e10e7e7fa695731a88941732c38d:

  mac80211: sta_info: Add lockdep condition for RCU list usage (2020-04-24 11:31:20 +0200)

----------------------------------------------------------------
Just three changes:
 * fix a wrong GFP_KERNEL in hwsim
 * fix the debugfs mess after the mac80211 registration race fix
 * suppress false-positive RCU list lockdep warnings

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: populate debugfs only after cfg80211 init

Madhuparna Bhowmik (1):
      mac80211: sta_info: Add lockdep condition for RCU list usage

Wei Yongjun (1):
      mac80211_hwsim: use GFP_ATOMIC under spin lock

 drivers/net/wireless/intel/iwlegacy/3945-rs.c |  2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  2 +-
 drivers/net/wireless/mac80211_hwsim.c         |  2 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c     |  2 +-
 include/net/mac80211.h                        |  4 +++-
 net/mac80211/main.c                           |  5 +++--
 net/mac80211/rate.c                           | 15 ++++-----------
 net/mac80211/rate.h                           | 23 +++++++++++++++++++++++
 net/mac80211/rc80211_minstrel_ht.c            | 19 +++++++++++++------
 net/mac80211/sta_info.c                       |  3 ++-
 12 files changed, 54 insertions(+), 27 deletions(-)

