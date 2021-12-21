Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B247BED6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbhLULZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbhLULZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 06:25:44 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9FFC061574;
        Tue, 21 Dec 2021 03:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=U/YkdhrFBRN+ecegwfwsAO9A98MF7KW711dSRTs5IOM=; t=1640085943; x=1641295543; 
        b=hF5WT9ZqRTptvxazYHJJez+v6GcdAQfwCbCPvVpuU5QrZ8HA/qRlqoSQN6rIZPo82kYu8i1owcu
        P4tVGQhQQ5yG7UPT+pOC/tzJiyS8seyU4POaLZ0LV+608B97koGRHTxDxzOTXf76dZ7zUqkvoqXNR
        NxlEAs+uF6JWQp7vex5mnlSRMxAH5Px2uNzakppLv8z+RzOeihapAapG2a+hhbAtfyYw/0w62GEqS
        A6OEhyvU2PTv4RSDwfJwmfbfHx5Bv60jm/r25aBHsT2ByB8921wUV4IKF5xNLhFfRufgB9vED5K5J
        cxesMcUykWKeaB/U1DMEWRjeIij6ADS7NZTw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mzdH4-00EXeT-5V;
        Tue, 21 Dec 2021 12:25:42 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-12-21
Date:   Tue, 21 Dec 2021 12:25:31 +0100
Message-Id: <20211221112532.28708-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have a couple more changes in the wireless stack,
and in part I'm asking you to pull them in order to
fix linux-next.

Note that there are two merge conflicts with net-next:

 1) There's a merge conflict in net/wireless/reg.c,
    which is pretty simple, but you can see a sample
    resolution from Stephen here:
    https://lore.kernel.org/r/20211221111950.57ecc6a7@canb.auug.org.au

 2) There's an API change in mac80211-next that affects
    code I didn't yet have, a change for ath10k is needed,
    again from Stephen we have a sample here:
    https://lore.kernel.org/r/20211221115004.1cd6b262@canb.auug.org.au

If you prefer I pull back net-next and fix these first,
I can do that as well, just let me know.

Please pull and let me know if there's any (further) problem.

Thanks,
johannes



The following changes since commit 3b1abcf1289466eca4c46db8b55c06422f0abf34:

  Merge tag 'regmap-no-bus-update-bits' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap (2021-11-18 17:50:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-12-21

for you to fetch changes up to 701fdfe348f7e5c9fe71caa3558d63dbb4bc4b81:

  cfg80211: Enable regulatory enforcement checks for drivers supporting mesh iface (2021-12-20 11:18:30 +0100)

----------------------------------------------------------------
This time we have:
 * ndo_fill_forward_path support in mac80211, to let
   drivers use it
 * association comeback notification for userspace,
   to be able to react more sensibly to long delays
 * support for background radar detection hardware
   in some chipsets
 * SA Query Procedures offload on the AP side
 * more logging if we find problems with HT/VHT/HE
 * various cleanups and minor fixes

----------------------------------------------------------------
Ayala Beker (1):
      cfg80211: Use the HE operation IE to determine a 6GHz BSS channel

Colin Ian King (1):
      mac80211_hwsim: Fix spelling mistake "Droping" -> "Dropping"

Emmanuel Grumbach (1):
      rfkill: allow to get the software rfkill state

Felix Fietkau (2):
      mac80211: add support for .ndo_fill_forward_path
      mac80211: use coarse boottime for airtime fairness code

Ilan Peer (4):
      mac80211: Remove a couple of obsolete TODO
      cfg80211: Fix order of enum nl80211_band_iftype_attr documentation
      cfg80211: Add support for notifying association comeback
      mac80211: Notify cfg80211 about association comeback

Johannes Berg (5):
      cfg80211: use ieee80211_bss_get_elem() instead of _get_ie()
      cfg80211: simplify cfg80211_chandef_valid()
      mac80211: add more HT/VHT/HE state logging
      nl82011: clarify interface combinations wrt. channels
      cfg80211: refactor cfg80211_get_ies_channel_number()

John Crispin (1):
      mac80211: notify non-transmitting BSS of color changes

Kees Cook (1):
      mac80211: Use memset_after() to clear tx status

Lorenzo Bianconi (7):
      cfg80211: implement APIs for dedicated radar detection HW
      mac80211: introduce set_radar_offchan callback
      cfg80211: move offchan_cac_event to a dedicated work
      cfg80211: fix possible NULL pointer dereference in cfg80211_stop_offchan_radar_detection
      cfg80211: schedule offchan_cac_abort_wk in cfg80211_radar_event
      cfg80211: allow continuous radar monitoring on offchannel chain
      cfg80211: rename offchannel_chain structs to background_chain to avoid confusion with ETSI standard

Miri Korenblit (1):
      ieee80211: change HE nominal packet padding value defines

Nathan Errera (1):
      mac80211: introduce channel switch disconnect function

P Praneesh (1):
      mac80211: fix FEC flag in radio tap header

Peter Seiderer (1):
      mac80211: minstrel_ht: remove unused SAMPLE_SWITCH_THR define

Sriram R (1):
      cfg80211: Enable regulatory enforcement checks for drivers supporting mesh iface

Veerendranath Jakkam (2):
      nl80211: Add support to set AP settings flags with single attribute
      nl80211: Add support to offload SA Query procedures for AP SME device

liuguoqiang (1):
      cfg80211: delete redundant free code

luo penghao (1):
      mac80211: Remove unused assignment statements

 drivers/net/wireless/ath/carl9170/tx.c             |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  16 +--
 drivers/net/wireless/intersil/p54/txrx.c           |   6 +-
 drivers/net/wireless/mac80211_hwsim.c              |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   3 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   3 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
 include/linux/ieee80211.h                          |  11 +-
 include/linux/rfkill.h                             |   7 +
 include/net/cfg80211.h                             |  90 ++++++++----
 include/net/mac80211.h                             |  36 ++++-
 include/uapi/linux/nl80211.h                       |  61 ++++++--
 net/mac80211/cfg.c                                 |  45 +++++-
 net/mac80211/debugfs_sta.c                         |   9 +-
 net/mac80211/driver-ops.h                          |  22 +++
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/iface.c                               |  59 ++++++++
 net/mac80211/main.c                                |  13 +-
 net/mac80211/mlme.c                                |  53 ++++---
 net/mac80211/rc80211_minstrel_ht.c                 |   2 -
 net/mac80211/rx.c                                  |   7 +-
 net/mac80211/trace.h                               |   7 +
 net/mac80211/tx.c                                  |  10 +-
 net/mac80211/wpa.c                                 |   4 -
 net/rfkill/core.c                                  |  12 ++
 net/wireless/chan.c                                |  78 +++++++----
 net/wireless/core.c                                |   9 ++
 net/wireless/core.h                                |  16 +++
 net/wireless/mlme.c                                | 153 ++++++++++++++++++++-
 net/wireless/nl80211.c                             | 123 +++++++++++++----
 net/wireless/rdev-ops.h                            |  17 +++
 net/wireless/reg.c                                 |   2 +
 net/wireless/scan.c                                | 121 ++++++++++------
 net/wireless/sme.c                                 |  22 ++-
 net/wireless/trace.h                               |  47 ++++++-
 net/wireless/wext-sme.c                            |  12 +-
 38 files changed, 865 insertions(+), 238 deletions(-)

