Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B325586F
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgH1KMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgH1KMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 06:12:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FC9C061264;
        Fri, 28 Aug 2020 03:12:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kBbND-00C1XR-4X; Fri, 28 Aug 2020 12:12:43 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2020-08-28
Date:   Fri, 28 Aug 2020 12:12:37 +0200
Message-Id: <20200828101238.18356-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here also nothing stands out, though perhaps you'd be
interested in the fact that we now use the new netlink
range length validation for some binary attributes.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f09665811b142cbf1eb36641ca42cee42c463b3f:

  Merge branch 'drivers-net-constify-static-ops-variables' (2020-08-26 16:21:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2020-08-28

for you to fetch changes up to 2831a631022eed6e3f800f08892132c6edde652c:

  nl80211: support SAE authentication offload in AP mode (2020-08-27 15:19:44 +0200)

----------------------------------------------------------------
This time we have:
 * some code to support SAE (WPA3) offload in AP mode
 * many documentation (wording) fixes/updates
 * netlink policy updates, including the use of NLA_RANGE
   with binary attributes
 * regulatory improvements for adjacent frequency bands
 * and a few other small additions/refactorings/cleanups

----------------------------------------------------------------
Chung-Hsien Hsu (1):
      nl80211: support SAE authentication offload in AP mode

James Prestwood (1):
      nl80211: fix PORT_AUTHORIZED wording to reflect behavior

Johannes Berg (2):
      nl80211: clean up code/policy a bit
      nl80211: use NLA_POLICY_RANGE(NLA_BINARY, ...) for a few attributes

John Crispin (2):
      nl80211: rename csa counter attributes countdown counters
      mac80211: rename csa counters to countdown counters

Markus Theil (2):
      cfg80211: add helper fn for single rule channels
      cfg80211: add helper fn for adjacent rule channels

Miaohe Lin (1):
      net: wireless: Convert to use the preferred fallthrough macro

Miles Hu (1):
      nl80211: add support for setting fixed HE rate/gi/ltf

Randy Dunlap (7):
      net: mac80211: agg-rx.c: fix duplicated words
      net: mac80211: mesh.h: delete duplicated word
      net: wireless: delete duplicated word + fix grammar
      net: wireless: reg.c: delete duplicated words + fix punctuation
      net: wireless: scan.c: delete or fix duplicated words
      net: wireless: sme.c: delete duplicated word
      net: wireless: wext_compat.c: delete duplicated word

 drivers/net/wireless/ath/ath10k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   6 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   8 +-
 include/net/cfg80211.h                             |   3 +
 include/net/mac80211.h                             |  35 ++-
 include/uapi/linux/nl80211.h                       |  76 ++++--
 net/mac80211/agg-rx.c                              |   2 +-
 net/mac80211/cfg.c                                 |  14 +-
 net/mac80211/ibss.c                                |   4 +-
 net/mac80211/ieee80211_i.h                         |   6 +-
 net/mac80211/main.c                                |   2 +-
 net/mac80211/mesh.c                                |   6 +-
 net/mac80211/offchannel.c                          |   2 +-
 net/mac80211/tx.c                                  |  73 +++---
 net/wireless/chan.c                                |   4 +-
 net/wireless/core.h                                |   4 +-
 net/wireless/mlme.c                                |   2 +-
 net/wireless/nl80211.c                             | 278 ++++++++++++++-------
 net/wireless/reg.c                                 | 257 +++++++++++++++----
 net/wireless/scan.c                                |   6 +-
 net/wireless/sme.c                                 |   6 +-
 net/wireless/util.c                                |   4 +-
 net/wireless/wext-compat.c                         |   6 +-
 31 files changed, 561 insertions(+), 275 deletions(-)

