Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FF5976A2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfHUKEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:04:33 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59040 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfHUKEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 06:04:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i0NTh-0007nV-5L; Wed, 21 Aug 2019 12:04:29 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-08-21
Date:   Wed, 21 Aug 2019 12:04:23 +0200
Message-Id: <20190821100424.13682-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

For -next, we have more changes, but as described in the tag
they really just fall into a few groups of changes :-)

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 8c40f3b212a373be843a29db608b462af5c3ed5d:

  Merge tag 'mlx5-updates-2019-08-15' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-08-20 22:59:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-08-21

for you to fetch changes up to 48cb39522a9d4d4680865e40a88f975a1cee6abc:

  mac80211: minstrel_ht: improve rate probing for devices with static fallback (2019-08-21 11:10:13 +0200)

----------------------------------------------------------------
Here are a few groups of changes:
 * EDMG channel support (60 GHz, just a single patch)
 * initial 6/7 GHz band support (Arend)
 * association timestamp recording (Ben)
 * rate control improvements for better performance with
   the mt76 driver (Felix)
 * various fixes for previous HE support changes (John)

----------------------------------------------------------------
Alexei Avshalom Lazar (1):
      nl80211: Add support for EDMG channels

Arend van Spriel (8):
      nl80211: add 6GHz band definition to enum nl80211_band
      cfg80211: add 6GHz UNII band definitions
      cfg80211: util: add 6GHz channel to freq conversion and vice versa
      cfg80211: extend ieee80211_operating_class_to_band() for 6GHz
      cfg80211: add 6GHz in code handling array with NUM_NL80211_BANDS entries
      cfg80211: use same IR permissive rules for 6GHz band
      cfg80211: ibss: use 11a mandatory rates for 6GHz band operation
      cfg80211: apply same mandatory rate flags for 5GHz and 6GHz

Ben Greear (2):
      cfg80211: Support assoc-at timer in sta-info
      mac80211: add assoc-at support

Felix Fietkau (4):
      mac80211: minstrel_ht: fix per-group max throughput rate initialization
      mac80211: minstrel_ht: reduce unnecessary rate probing attempts
      mac80211: minstrel_ht: fix default max throughput rate indexes
      mac80211: minstrel_ht: improve rate probing for devices with static fallback

John Crispin (5):
      mac80211: fix TX legacy rate reporting when tx_status_ext is used
      mac80211: fix bad guard when reporting legacy rates
      mac80211: 80Mhz was not reported properly when using tx_status_ext
      mac80211: add missing length field increment when generating Radiotap header
      mac80211: fix possible NULL pointerderef in obss pd code

 drivers/net/wireless/ath/wil6210/cfg80211.c |   2 +-
 include/net/cfg80211.h                      |  88 ++++++++-
 include/uapi/linux/nl80211.h                |  29 +++
 net/mac80211/he.c                           |   3 +-
 net/mac80211/mlme.c                         |   2 +-
 net/mac80211/rc80211_minstrel.h             |   1 +
 net/mac80211/rc80211_minstrel_ht.c          | 277 ++++++++++++++++++++++++----
 net/mac80211/rc80211_minstrel_ht.h          |  12 ++
 net/mac80211/sta_info.c                     |   3 +
 net/mac80211/sta_info.h                     |   2 +
 net/mac80211/status.c                       |  31 ++--
 net/mac80211/tx.c                           |   1 +
 net/wireless/chan.c                         | 162 +++++++++++++++-
 net/wireless/ibss.c                         |  16 +-
 net/wireless/nl80211.c                      |  39 ++++
 net/wireless/reg.c                          |  21 ++-
 net/wireless/trace.h                        |   3 +-
 net/wireless/util.c                         |  56 +++++-
 18 files changed, 684 insertions(+), 64 deletions(-)

