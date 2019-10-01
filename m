Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92952C39C3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389832AbfJAQBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:01:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732809AbfJAQBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:01:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFKaa-0004tD-LK; Tue, 01 Oct 2019 18:01:24 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-10-01
Date:   Tue,  1 Oct 2019 18:01:16 +0200
Message-Id: <20191001160117.13628-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here's a list of fixes - the BHs disabled one has been reported
multiple times, and the SSID/MBSSID ordering one has over-the-air
security implementations.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 68ce6688a5baefde30914fc07fc27292dbbe8320:

  net: sched: taprio: Fix potential integer overflow in taprio_set_picos_per_byte (2019-09-30 18:32:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-10-01

for you to fetch changes up to d8dec42b5c2d2b273bc30b0e073cfbe832d69902:

  mac80211: keep BHs disabled while calling drv_tx_wake_queue() (2019-10-01 17:56:19 +0200)

----------------------------------------------------------------
A small list of fixes this time:
 * two null pointer dereference fixes
 * a fix for preempt-enabled/BHs-enabled (lockdep) splats
   (that correctly pointed out a bug)
 * a fix for multi-BSSID ordering assumptions
 * a fix for the EDMG support, on-stack chandefs need to
   be initialized properly (now that they're bigger)
 * beacon (head) data from userspace should be validated

----------------------------------------------------------------
Johannes Berg (4):
      nl80211: validate beacon head
      cfg80211: validate SSID/MBSSID element ordering assumption
      cfg80211: initialize on-stack chandefs
      mac80211: keep BHs disabled while calling drv_tx_wake_queue()

Miaoqing Pan (2):
      nl80211: fix null pointer dereference
      mac80211: fix txq null pointer dereference

 net/mac80211/debugfs_netdev.c | 11 +++++++++--
 net/mac80211/util.c           | 13 ++++++++-----
 net/wireless/nl80211.c        | 44 ++++++++++++++++++++++++++++++++++++++++---
 net/wireless/reg.c            |  2 +-
 net/wireless/scan.c           |  7 ++++++-
 net/wireless/wext-compat.c    |  2 +-
 6 files changed, 66 insertions(+), 13 deletions(-)

