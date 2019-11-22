Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC321072AB
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 14:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfKVNBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 08:01:49 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45160 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfKVNBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 08:01:48 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY8ZG-0003pg-QY; Fri, 22 Nov 2019 14:01:46 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next next-2019-11-22
Date:   Fri, 22 Nov 2019 14:01:40 +0100
Message-Id: <20191122130141.18186-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here's a final pull request for -next. I know I'm cutting it close, but
the only interesting new thing here is AQL (airtime queue limits) which
has been under discussion and heavy testing for quite a while, so I
wanted to still get it in.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 13baf667fa8e23aed12516776de6e50f7617820a:

  enetc: make enetc_setup_tc_mqprio static (2019-11-21 19:30:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2019-11-22

for you to fetch changes up to 7a89233ac50468a3a9636803a85d06c8f907f8ee:

  mac80211: Use Airtime-based Queue Limits (AQL) on packet dequeue (2019-11-22 13:36:25 +0100)

----------------------------------------------------------------
The interesting new thing here is AQL, the Airtime Queue Limit
patchset from Kan Yan (Google) and Toke Høiland-Jørgensen (Redhat).
The effect is intended to eventually be similar to BQL, but byte
queue limits are not useful in wifi where the actual throughput can
vary by around 4 orders of magnitude. There are more details in the
patches themselves.

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: add a comment about monitor-to-dev injection

Kan Yan (1):
      mac80211: Implement Airtime-based Queue Limit (AQL)

Taehee Yoo (1):
      virt_wifi: fix use-after-free in virt_wifi_newlink()

Thomas Pedersen (2):
      mac80211: expose HW conf flags through debugfs
      mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED

Toke Høiland-Jørgensen (3):
      mac80211: Add new sta_info getter by sta/vif addrs
      mac80211: Import airtime calculation code from mt76
      mac80211: Use Airtime-based Queue Limits (AQL) on packet dequeue

 drivers/net/wireless/virt_wifi.c |   4 +-
 include/net/cfg80211.h           |   7 +
 include/net/mac80211.h           |  57 ++++
 net/mac80211/Makefile            |   3 +-
 net/mac80211/airtime.c           | 597 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs.c           |  88 ++++++
 net/mac80211/debugfs_sta.c       |  43 ++-
 net/mac80211/ieee80211_i.h       |   8 +
 net/mac80211/main.c              |  10 +-
 net/mac80211/sta_info.c          |  52 ++++
 net/mac80211/sta_info.h          |  12 +
 net/mac80211/status.c            |  39 ++-
 net/mac80211/tx.c                |  72 ++++-
 13 files changed, 966 insertions(+), 26 deletions(-)
 create mode 100644 net/mac80211/airtime.c

