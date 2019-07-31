Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A36F27C223
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbfGaMtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 08:49:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58816 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfGaMtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 08:49:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hso36-0000A3-KZ; Wed, 31 Jul 2019 14:49:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-07-31
Date:   Wed, 31 Jul 2019 14:49:32 +0200
Message-Id: <20190731124933.19420-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have few fixes, most importantly probably the NETIF_F_LLTX revert,
we thought we were now more layered like VLAN or such since we do all
of the queue control internally, but it caused problems, evidently not.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 47d858d0bdcd47cc1c6c9eeca91b091dd9e55637:

  ipip: validate header length in ipip_tunnel_xmit (2019-07-25 17:23:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-07-31

for you to fetch changes up to eef347f846ee8f7296a6f84e3866c057ca6bcce0:

  Revert "mac80211: set NETIF_F_LLTX when using intermediate tx queues" (2019-07-30 14:52:50 +0200)

----------------------------------------------------------------
Just a few fixes:
 * revert NETIF_F_LLTX usage as it caused problems
 * avoid warning on WMM parameters from AP that are too short
 * fix possible null-ptr dereference in hwsim
 * fix interface combinations with 4-addr and crypto control

----------------------------------------------------------------
Brian Norris (1):
      mac80211: don't WARN on short WMM parameters from AP

Jia-Ju Bai (1):
      mac80211_hwsim: Fix possible null-pointer dereferences in hwsim_dump_radio_nl()

Johannes Berg (1):
      Revert "mac80211: set NETIF_F_LLTX when using intermediate tx queues"

Manikanta Pubbisetty (1):
      {nl,mac}80211: fix interface combinations on crypto controlled devices

 drivers/net/wireless/mac80211_hwsim.c |  8 +++++---
 include/net/cfg80211.h                | 15 +++++++++++++++
 net/mac80211/iface.c                  |  1 -
 net/mac80211/mlme.c                   | 10 ++++++++++
 net/mac80211/util.c                   |  7 +++----
 net/wireless/core.c                   |  6 ++----
 net/wireless/nl80211.c                |  4 +---
 net/wireless/util.c                   | 27 +++++++++++++++++++++++++--
 8 files changed, 61 insertions(+), 17 deletions(-)

