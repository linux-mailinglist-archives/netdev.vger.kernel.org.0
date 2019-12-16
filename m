Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D3F120133
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLPJbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:31:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41648 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfLPJbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:31:55 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1igmjJ-0019Hz-95; Mon, 16 Dec 2019 10:31:53 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-10-16
Date:   Mon, 16 Dec 2019 10:31:42 +0100
Message-Id: <20191216093143.10808-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have just a handful of fixes, but the AQL one is important since
it disables the code that causes the iwlwifi issues/warnings.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 0af67e49b018e7280a4227bfe7b6005bc9d3e442:

  qede: Fix multicast mac configuration (2019-12-12 11:08:36 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2019-10-16

for you to fetch changes up to 6fc232db9e8cd50b9b83534de9cd91ace711b2d7:

  rfkill: Fix incorrect check to avoid NULL pointer dereference (2019-12-16 10:15:49 +0100)

----------------------------------------------------------------
A handful of fixes:
 * disable AQL on most drivers, addressing the iwlwifi issues
 * fix double-free on network namespace changes
 * fix TID field in frames injected through monitor interfaces
 * fix ieee80211_calc_rx_airtime()
 * fix NULL pointer dereference in rfkill (and remove BUG_ON)

----------------------------------------------------------------
Aditya Pakki (1):
      rfkill: Fix incorrect check to avoid NULL pointer dereference

Dan Carpenter (1):
      mac80211: airtime: Fix an off by one in ieee80211_calc_rx_airtime()

Fredrik Olofsson (1):
      mac80211: fix TID field in monitor mode transmit

Stefan Bühler (1):
      cfg80211: fix double-free after changing network namespace

Toke Høiland-Jørgensen (1):
      mac80211: Turn AQL into an NL80211_EXT_FEATURE

 drivers/net/wireless/ath/ath10k/mac.c |  1 +
 include/uapi/linux/nl80211.h          |  5 +++
 net/mac80211/airtime.c                |  2 +-
 net/mac80211/debugfs_sta.c            | 76 ++++++++++++++++++++++++++---------
 net/mac80211/main.c                   |  4 +-
 net/mac80211/sta_info.c               |  3 ++
 net/mac80211/sta_info.h               |  1 -
 net/mac80211/tx.c                     | 13 +++++-
 net/rfkill/core.c                     |  7 +++-
 net/wireless/core.c                   |  1 +
 10 files changed, 86 insertions(+), 27 deletions(-)

