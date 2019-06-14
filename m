Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC084606B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfFNOQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:16:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42776 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfFNOQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:16:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hbn0W-0002JZ-Q3; Fri, 14 Jun 2019 16:16:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2019-06-14
Date:   Fri, 14 Jun 2019 16:16:37 +0200
Message-Id: <20190614141638.30018-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

And ... here's a -next pull request. Nothing really major here,
see more details below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit cec4f328c929f72ad634e8f385b589bd6eac80e5:

  enetc: fix le32/le16 degrading to integer warnings (2019-05-27 10:12:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2019-06-14

for you to fetch changes up to ddb754aa31813fd17d8374eba881827e6e2c85c6:

  mac80211: notify offchannel expire on mgmt_tx (2019-06-14 16:08:28 +0200)

----------------------------------------------------------------
Many changes all over:
 * HE (802.11ax) work continues
 * WPA3 offloads
 * work on extended key ID handling continues
 * fixes to honour AP supported rates with auth/assoc frames
 * nl80211 netlink policy improvements to fix some issues
   with strict validation on new commands with old attrs

----------------------------------------------------------------
Alexander Wetzel (1):
      mac80211: AMPDU handling for Extended Key ID

Chaitanya Tata (1):
      cfg80211: Handle bss expiry during connection

Chung-Hsien Hsu (3):
      nl80211: add NL80211_ATTR_IFINDEX to port authorized event
      nl80211: add WPA3 definition for SAE authentication
      nl80211: add support for SAE authentication offload

Greg Kroah-Hartman (1):
      mac80211: no need to check return value of debugfs_create functions

Ilan Peer (2):
      cfg80211: Add a function to iterate all BSS entries
      ieee80211: Add a missing extended capability flag definition

James Prestwood (2):
      nl80211: send event when CMD_FRAME duration expires
      mac80211: notify offchannel expire on mgmt_tx

Johannes Berg (6):
      nl80211: fill all policy .type entries
      nl80211: require and validate vendor command policy
      mac80211: call rate_control_send_low() internally
      mac80211: use STA info in rate_control_send_low()
      mac80211: fill low rate even for HAS_RATE_CONTROL
      mac80211: extend __rate_control_send_low warning

John Crispin (3):
      mac80211: add ieee80211_get_he_iftype_cap() helper
      mac80211: dynamically enable the TWT requester support on STA interfaces
      mac80211: allow turning TWT responder support on and off via netlink

 .../driver-api/80211/mac80211-advanced.rst         |   3 -
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |   3 -
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   4 -
 drivers/net/wireless/mac80211_hwsim.c              |   2 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |   3 -
 include/linux/ieee80211.h                          |   8 ++
 include/net/cfg80211.h                             |  82 +++++++++--
 include/net/mac80211.h                             |  32 ++---
 include/net/netlink.h                              |   9 ++
 include/uapi/linux/nl80211.h                       |  24 ++++
 net/mac80211/cfg.c                                 |   8 +-
 net/mac80211/debugfs.c                             |   1 +
 net/mac80211/debugfs_key.c                         |   3 -
 net/mac80211/debugfs_netdev.c                      |  10 +-
 net/mac80211/debugfs_sta.c                         |   2 -
 net/mac80211/key.c                                 | 100 +++++++------
 net/mac80211/mlme.c                                |  25 +++-
 net/mac80211/offchannel.c                          |   4 +
 net/mac80211/rate.c                                |  27 ++--
 net/mac80211/rc80211_minstrel.c                    |   4 -
 net/mac80211/rc80211_minstrel_ht.c                 |   3 -
 net/mac80211/sta_info.c                            |  43 +++++-
 net/wireless/core.c                                |  13 ++
 net/wireless/core.h                                |   4 +
 net/wireless/nl80211.c                             | 155 +++++++++++++++++----
 net/wireless/scan.c                                |  33 ++++-
 net/wireless/sme.c                                 |  32 ++++-
 net/wireless/trace.h                               |  18 +++
 30 files changed, 495 insertions(+), 168 deletions(-)

