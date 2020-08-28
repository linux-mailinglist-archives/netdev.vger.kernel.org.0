Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC93255850
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgH1KIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgH1KIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 06:08:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAA8C061264;
        Fri, 28 Aug 2020 03:08:18 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kBbIt-00C1Qp-Hw; Fri, 28 Aug 2020 12:08:15 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2020-08-28
Date:   Fri, 28 Aug 2020 12:08:04 +0200
Message-Id: <20200828100805.17954-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

We have a number of fixes for the current release cycle,
one is for a syzbot reported warning (the sanity check)
but most are more wifi protocol related.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit cf96d977381d4a23957bade2ddf1c420b74a26b6:

  net: gemini: Fix missing free_netdev() in error path of gemini_ethernet_port_probe() (2020-08-19 16:37:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2020-08-28

for you to fetch changes up to 2d9b55508556ccee6410310fb9ea2482fd3328eb:

  cfg80211: Adjust 6 GHz frequency to channel conversion (2020-08-27 10:53:21 +0200)

----------------------------------------------------------------
We have:
 * fixes for AQL (airtime queue limits)
 * reduce packet loss detection false positives
 * a small channel number fix for the 6 GHz band
 * a fix for 80+80/160 MHz negotiation
 * an nl80211 attribute (NL80211_ATTR_HE_6GHZ_CAPABILITY) fix
 * add a missing sanity check for the regulatory code

----------------------------------------------------------------
Amar Singhal (1):
      cfg80211: Adjust 6 GHz frequency to channel conversion

Felix Fietkau (4):
      mac80211: use rate provided via status->rate on ieee80211_tx_status_ext for AQL
      mac80211: factor out code to look up the average packet length duration for a rate
      mac80211: improve AQL aggregation estimation for low data rates
      mac80211: reduce packet loss event false positives

Johannes Berg (2):
      nl80211: fix NL80211_ATTR_HE_6GHZ_CAPABILITY usage
      cfg80211: regulatory: reject invalid hints

Shay Bar (1):
      wireless: fix wrong 160/80+80 MHz setting

 net/mac80211/airtime.c  | 202 ++++++++++++++++++++++++++++++++++--------------
 net/mac80211/sta_info.h |   5 +-
 net/mac80211/status.c   |  43 ++++++-----
 net/wireless/chan.c     |  15 +++-
 net/wireless/nl80211.c  |   2 +-
 net/wireless/reg.c      |   3 +
 net/wireless/util.c     |   8 +-
 7 files changed, 192 insertions(+), 86 deletions(-)

