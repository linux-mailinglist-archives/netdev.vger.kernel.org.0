Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2285EC54F
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiI0OAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbiI0N7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:59:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C2FE39;
        Tue, 27 Sep 2022 06:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=eaizC767E4tlXw5DDeGAD1g3hUIMeIhOVHKkmtgXYTo=; t=1664287171; x=1665496771; 
        b=gcniAqls0krY6PATagJrjDrzrD1ZovHU10lHPBw18jfTq5DFvcYyEbC8KUXSInHimldKM/ckUg5
        +MWlioKAw267XxbBZ9McLggY1+uJwYTW7kssVtAYKQoU+Y5P4Z3Gz8YNeQwiTUmR2gEkx5INiMxT3
        MdtCKZqYZJydPWPMvbDbag5o9guta2rwBpteDU52BYNEbL1QgyE0R9AcGtUnwTufqT135kK0NyutL
        EgWggjJXl7ZHFDibPLjDJLVTBIBun3oE2Rl+hfgrCztvoO3NF/g1FIErgyl9iw5PA0iKjfkJBNhwD
        191rbR4oNcTrBIfzcpc9AemOW0FYFTZTNmiw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1odB7P-009bLz-0k;
        Tue, 27 Sep 2022 15:59:28 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2022-09-27
Date:   Tue, 27 Sep 2022 15:59:22 +0200
Message-Id: <20220927135923.45312-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So I was out for plugfest, and a couple of things accumulated.
I know it's getting late, but these seem important, some are
fixes for reported regressions, some are locking bugs, and a
memory corruption with some drivers is also there ...

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 781b80f452fcc1cfc16ee41f12556626a9ced049:

  wifi: mt76: fix 5 GHz connection regression on mt76x0/mt76x2 (2022-09-12 14:26:02 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-09-27

for you to fetch changes up to 6546646a7fb0d7fe1caef947889497c16aaecc8c:

  wifi: mac80211: mlme: Fix double unlock on assoc success handling (2022-09-27 10:34:45 +0200)

----------------------------------------------------------------
A few late-comer fixes:
 * locking in mac80211 MLME
 * non-QoS driver crash/regression
 * minstrel memory corruption
 * TX deadlock
 * TX queues not always enabled
 * HE/EHT bitrate calculation

----------------------------------------------------------------
Alexander Wetzel (2):
      wifi: mac80211: don't start TX with fq->lock to fix deadlock
      wifi: mac80211: ensure vif queues are operational after start

Hans de Goede (1):
      wifi: mac80211: fix regression with non-QoS drivers

Paweł Lenkow (1):
      wifi: mac80211: fix memory corruption in minstrel_ht_update_rates()

Rafael Mendonca (2):
      wifi: mac80211: mlme: Fix missing unlock on beacon RX
      wifi: mac80211: mlme: Fix double unlock on assoc success handling

Tamizh Chelvam Raja (1):
      wifi: cfg80211: fix MCS divisor value

 net/mac80211/mlme.c                |  9 ++++++---
 net/mac80211/rc80211_minstrel_ht.c |  6 ++++--
 net/mac80211/status.c              |  2 +-
 net/mac80211/tx.c                  |  4 ++++
 net/mac80211/util.c                | 12 ++++++------
 net/wireless/util.c                |  4 ++--
 6 files changed, 23 insertions(+), 14 deletions(-)

