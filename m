Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A155A2324
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245656AbiHZIhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245301AbiHZIhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:37:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2537C767;
        Fri, 26 Aug 2022 01:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=AUQydQj0EINK83vChZVrw9x8nK+8oubl9gVGNSFLXZw=; t=1661503041; x=1662712641; 
        b=bZGEK2FbACQBvzZ+pz6WKmvIM94ZLIsNBKO50+mMgmeNGnOwwlEv0gBfNCm92tIFAlv5fkUQtar
        qeeA1KBvkomWizOkaLlwI/4Esftb3zQU3I9nKNN+SPplgoLDX+jMe8UmTN8pFbHTdiFbssBtYoLUp
        A1Dkd3a1nMdMwV4Iyu0D2uGE+Ky08P1RqgrojlkIIVNKHtncpHB7Ub+xbNQUcxAZhtcYn9qHWQyUU
        EghCh75uNUorG6sTpYSXxuV4Ol1zhXqFDuzA9kn3x1cBGqYAwCcrvqUOJdWRJWH4+S02hWkLu2Fg0
        PD8Ziq0PTwPOOm5CVgSGZ6U3uMACyKOoGPpg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oRUq7-000ARx-1k;
        Fri, 26 Aug 2022 10:37:19 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2022-08-26
Date:   Fri, 26 Aug 2022 10:37:15 +0200
Message-Id: <20220826083716.15682-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here are a couple of fixes for the current cycle,
see the tag description below.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 24c7a64ea4764d70e4ac9b0a60ecd9b03c68435e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2022-08-24 19:18:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-08-26

for you to fetch changes up to 55f0a4894484e8d6ddf662f5aebbf3b4cb028541:

  wifi: mac80211: potential NULL dereference in ieee80211_tx_control_port() (2022-08-25 10:05:25 +0200)

----------------------------------------------------------------
Just a couple of fixes:
 * two potential leaks
 * use-after-free in certain scan races
 * warning in IBSS code
 * error return from a debugfs file was wrong
 * possible NULL-ptr-deref when station lookup fails

----------------------------------------------------------------
Dan Carpenter (2):
      wifi: cfg80211: debugfs: fix return type in ht40allow_map_read()
      wifi: mac80211: potential NULL dereference in ieee80211_tx_control_port()

Lorenzo Bianconi (1):
      wifi: mac80211: always free sta in __sta_info_alloc in case of error

Siddh Raman Pant (2):
      wifi: mac80211: Fix UAF in ieee80211_scan_rx()
      wifi: mac80211: Don't finalize CSA in IBSS mode if state is disconnected

Yang Yingliang (1):
      wifi: mac80211: fix possible leak in ieee80211_tx_control_port()

 net/mac80211/ibss.c     |  4 ++++
 net/mac80211/scan.c     | 11 +++++++----
 net/mac80211/sta_info.c |  2 +-
 net/mac80211/tx.c       |  3 ++-
 net/wireless/debugfs.c  |  3 ++-
 5 files changed, 16 insertions(+), 7 deletions(-)

