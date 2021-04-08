Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA753583E1
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhDHMyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 08:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 08:54:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB72C061760;
        Thu,  8 Apr 2021 05:53:50 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUUAO-0090Mn-LO; Thu, 08 Apr 2021 14:53:48 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-04-08
Date:   Thu,  8 Apr 2021 14:53:43 +0200
Message-Id: <20210408125344.50279-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Yes, I'm late with this, sorry about that. I've mostly restricted this
to the most necessary fixes, though the virt_wifi one isn't but since
that's not used a lot, it's harmless and included since it's obvious.

The only thing that's bigger is the rfkill thing, but that's just since
it adds a new version of the struct for userspace to use, since the
change to the existing struct caused various breakage all around.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 8a12f8836145ffe37e9c8733dce18c22fb668b66:

  net: hso: fix null-ptr-deref during tty device unregistration (2021-04-07 15:18:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-04-08

for you to fetch changes up to abaf94ecc9c356d0b885a84edef4905cdd89cfdd:

  nl80211: fix potential leak of ACL params (2021-04-08 14:44:56 +0200)

----------------------------------------------------------------
Various small fixes:
 * S1G beacon validation
 * potential leak in nl80211
 * fast-RX confusion with 4-addr mode
 * erroneous WARN_ON that userspace can trigger
 * wrong time units in virt_wifi
 * rfkill userspace API breakage
 * TXQ AC confusing that led to traffic stopped forever
 * connection monitoring time after/before confusion

----------------------------------------------------------------
A. Cody Schuffelen (1):
      virt_wifi: Return micros for BSS TSF values

Ben Greear (1):
      mac80211: fix time-is-after bug in mlme

Du Cheng (1):
      cfg80211: remove WARN_ON() in cfg80211_sme_connect

Johannes Berg (4):
      rfkill: revert back to old userspace API by default
      mac80211: fix TXQ AC confusion
      cfg80211: check S1G beacon compat element length
      nl80211: fix potential leak of ACL params

Seevalamuthu Mariappan (1):
      mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

 drivers/net/wireless/virt_wifi.c |  5 ++-
 include/uapi/linux/rfkill.h      | 80 ++++++++++++++++++++++++++++++++++------
 net/mac80211/cfg.c               |  4 +-
 net/mac80211/mlme.c              |  5 ++-
 net/mac80211/tx.c                |  2 +-
 net/rfkill/core.c                |  7 ++--
 net/wireless/nl80211.c           |  4 +-
 net/wireless/scan.c              | 14 ++++---
 net/wireless/sme.c               |  2 +-
 9 files changed, 94 insertions(+), 29 deletions(-)

