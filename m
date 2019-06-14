Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3145F89
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFNNvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:51:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42446 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbfFNNu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:50:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hbmbS-0001SE-8V; Fri, 14 Jun 2019 15:50:50 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2019-06-14
Date:   Fri, 14 Jun 2019 15:50:41 +0200
Message-Id: <20190614135042.28352-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here's a round of fixes for the current tree, things are all over
and the only really important thing is the TDLS and MFP fix, both
of which allow a security bypass in MFP.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 63863ee8e2f6f6ae47be3dff4af2f2806f5ca2dd:

  Merge tag 'gcc-plugins-v5.2-rc1' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/kees/linux (2019-05-13 16:01:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2019-06-14

for you to fetch changes up to b65842025335711e2a0259feb4dbadb0c9ffb6d9:

  cfg80211: report measurement start TSF correctly (2019-06-14 15:46:33 +0200)

----------------------------------------------------------------
Various fixes, all over:
 * a few memory leaks
 * fixes for management frame protection security
   and A2/A3 confusion (affecting TDLS as well)
 * build fix for certificates
 * etc.

----------------------------------------------------------------
Andy Strohman (1):
      nl80211: fix station_info pertid memory leak

Avraham Stern (1):
      cfg80211: report measurement start TSF correctly

Eric Biggers (1):
      cfg80211: fix memory leak of wiphy device name

Gustavo A. R. Silva (1):
      mac80211_hwsim: mark expected switch fall-through

Johannes Berg (2):
      nl80211: fill all policy .type entries
      mac80211: drop robust management frames from unknown TA

John Crispin (1):
      mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()

Jouni Malinen (1):
      mac80211: Do not use stack memory with scatterlist for GMAC

Luca Coelho (1):
      cfg80211: use BIT_ULL in cfg80211_parse_mbssid_data()

Manikanta Pubbisetty (1):
      {nl,mac}80211: allow 4addr AP operation on crypto controlled devices

Maxim Mikityanskiy (1):
      wireless: Skip directory when generating certificates

Mordechay Goodstein (1):
      cfg80211: util: fix bit count off by one

Naftali Goldstein (1):
      mac80211: do not start any work during reconfigure flow

Pradeep Kumar Chitrapu (1):
      mac80211: free peer keys before vif down in mesh

Thomas Pedersen (1):
      mac80211: mesh: fix RCU warning

Yibo Zhao (1):
      mac80211: only warn once on chanctx_conf being NULL

Yu Wang (1):
      mac80211: handle deauthentication/disassociation from TDLS peer

YueHaibing (1):
      mac80211: remove set but not used variable 'old'

 drivers/net/wireless/mac80211_hwsim.c |  1 +
 include/net/cfg80211.h                |  3 +-
 net/mac80211/ieee80211_i.h            | 12 ++++-
 net/mac80211/key.c                    |  2 -
 net/mac80211/mesh.c                   |  6 ++-
 net/mac80211/mlme.c                   | 12 ++++-
 net/mac80211/rx.c                     |  2 +
 net/mac80211/tdls.c                   | 23 ++++++++
 net/mac80211/util.c                   |  8 ++-
 net/mac80211/wpa.c                    |  7 ++-
 net/wireless/Makefile                 |  1 +
 net/wireless/core.c                   |  8 ++-
 net/wireless/nl80211.c                | 99 ++++++++++++++++++++++++++---------
 net/wireless/pmsr.c                   |  4 +-
 net/wireless/scan.c                   |  4 +-
 net/wireless/util.c                   |  4 +-
 16 files changed, 156 insertions(+), 40 deletions(-)

