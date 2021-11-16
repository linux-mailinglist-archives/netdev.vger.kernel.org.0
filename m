Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A194536F9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238840AbhKPQMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbhKPQLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:11:53 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6894C061746;
        Tue, 16 Nov 2021 08:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=1kQoXqxgBOvqoeUGobCEXZnGk+ezCOczJQpIwyP64mc=; t=1637078935; x=1638288535; 
        b=X/TrbHHmPM26UQOqfeniI/Q3U3grAeQMgv6XKik65fKALINZvn57d4E5lvwFfzOWctQV8LQjbQL
        +ZFRNc1Y6YroWqspMwCYER2OLJRK+y9/Mo4fM5qC5k2FBmXq5+wBbxKsGOj4F4c+Hj7ST5RWWMiDP
        TU9tdgRpJy2bFdLGDbDeDWodpYdtldiAeWw6Jy5xwk9ECnsn8kPDxRwmOzf3WNwd5jYYeo/JI2RJ4
        qxo0lIjZj56oLjS3fmkjBujGMcQIR0MJzPZQWPl3ftkkgocHF3u33VZdurGp7ilzuLlCGZGMqNfHh
        w6+wrDmHKZSYthjHjPS27/Oi7wWxyBW4NxWQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mn10t-00G8LM-Fj;
        Tue, 16 Nov 2021 17:08:51 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-11-16
Date:   Tue, 16 Nov 2021 17:08:44 +0100
Message-Id: <20211116160845.157214-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We've already got a couple of fixes for this cycle, and in
particular the radiotap one has been bothering users.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 1aa3b2207e889a948049c9a8016cedb0218c2389:

  net,lsm,selinux: revert the security_sctp_assoc_established() hook (2021-11-14 12:21:53 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-11-16

for you to fetch changes up to 30f6cf96912b638d0ddfc325204b598f94efddc2:

  mac80211: fix throughput LED trigger (2021-11-15 10:56:57 +0100)

----------------------------------------------------------------
Couple of fixes:
 * bad dont-reorder check
 * throughput LED trigger for various new(ish) paths
 * radiotap header generation
 * locking assertions in mac80211 with monitor mode
 * radio statistics
 * don't try to access IV when not present
 * call stop_ap for P2P_GO as well as we should

----------------------------------------------------------------
Felix Fietkau (2):
      mac80211: drop check for DONT_REORDER in __ieee80211_select_queue
      mac80211: fix throughput LED trigger

Johannes Berg (3):
      nl80211: fix radio statistics in survey dump
      mac80211: fix radiotap header generation
      mac80211: fix monitor_sdata RCU/locking assertions

Nguyen Dinh Phi (1):
      cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

Xing Song (1):
      mac80211: do not access the IV when it was stripped

 net/mac80211/cfg.c     | 12 ++++++++----
 net/mac80211/iface.c   |  4 +++-
 net/mac80211/led.h     |  8 ++++----
 net/mac80211/rx.c      | 12 +++++++-----
 net/mac80211/tx.c      | 34 +++++++++++++++-------------------
 net/mac80211/util.c    |  7 ++++---
 net/mac80211/wme.c     |  3 +--
 net/wireless/nl80211.c | 34 +++++++++++++++++++---------------
 net/wireless/nl80211.h |  6 +-----
 net/wireless/util.c    |  1 +
 10 files changed, 63 insertions(+), 58 deletions(-)

