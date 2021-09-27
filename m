Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB93841921F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhI0KWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 06:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbhI0KWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 06:22:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D1BC061575;
        Mon, 27 Sep 2021 03:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=HbwYiyPrCUCdCR4r0G9Lbu1ysCwtS8TbwZ3arIhdYmU=; t=1632738061; x=1633947661; 
        b=nJroi7iH/cQEPDBeyNmmaw46l97MOMDM9ym2RQl9b9hRYNPUBZqevOLaqAJoWY9sM4gFy9qAlRX
        ilMWVrOWBrejlDtJUMyi/fWb8HSu4Ewd6R3wsKlmOsBqj8/6UjH7AQzjqtWQ1IcPXB7VALG5RKRTI
        vJ3eyUACWBs2MeQcP7hxGW0BPjqrVtXcuewd7ZnLoYFc25NQa6N82hlxs1sD4w7TuT5MAL8ckdoPv
        wXO88sAXx58VlEQlRX3+FauSGwJ2fbVOkwnnYG6WmfjuJdKKpg6SRWQCGkb9usSR2dk8rda3pNVFe
        goDWxDRDF3oMA9KqKu9u+FvC6/spm5hAI8eQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mUnkp-00CNSS-Je;
        Mon, 27 Sep 2021 12:20:59 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2021-09-27
Date:   Mon, 27 Sep 2021 12:20:56 +0200
Message-Id: <20210927102057.45765-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So somehow this time around we ended up with a larger than
usual set of fixes - see below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 977d293e23b48a1129830d7968605f61c4af71a0:

  mptcp: ensure tx skbs always have the MPTCP ext (2021-09-22 14:39:41 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-net-2021-09-27

for you to fetch changes up to 33092aca857bf35a8e9cac0e8340c685a4796e90:

  mac80211: Fix Ptk0 rekey documentation (2021-09-27 12:02:54 +0200)

----------------------------------------------------------------
Some fixes:
 * potential use-after-free in CCMP/GCMP RX processing
 * potential use-after-free in TX A-MSDU processing
 * revert to low data rates for no-ack as the commit
   broke other things
 * limit VHT MCS/NSS in radiotap injection
 * drop frames with invalid addresses in IBSS mode
 * check rhashtable_init() return value in mesh
 * fix potentially unaligned access in mesh
 * fix late beacon hrtimer handling in hwsim (syzbot)
 * fix documentation for PTK0 rekeying

----------------------------------------------------------------
Alexander Wetzel (1):
      mac80211: Fix Ptk0 rekey documentation

Chih-Kang Chang (1):
      mac80211: Fix ieee80211_amsdu_aggregate frag_tail bug

Felix Fietkau (1):
      Revert "mac80211: do not use low data rates for data frames with no ack flag"

Johannes Berg (3):
      mac80211: mesh: fix potentially unaligned access
      mac80211-hwsim: fix late beacon hrtimer handling
      mac80211: fix use-after-free in CCMP/GCMP RX

Lorenzo Bianconi (1):
      mac80211: limit injected vht mcs/nss in ieee80211_parse_tx_radiotap

MichelleJin (1):
      mac80211: check return value of rhashtable_init

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

 drivers/net/wireless/mac80211_hwsim.c |  4 ++--
 include/net/mac80211.h                |  8 ++++----
 net/mac80211/mesh_pathtbl.c           |  5 ++++-
 net/mac80211/mesh_ps.c                |  3 ++-
 net/mac80211/rate.c                   |  4 ----
 net/mac80211/rx.c                     |  3 ++-
 net/mac80211/tx.c                     | 12 ++++++++++++
 net/mac80211/wpa.c                    |  6 ++++++
 8 files changed, 32 insertions(+), 13 deletions(-)

