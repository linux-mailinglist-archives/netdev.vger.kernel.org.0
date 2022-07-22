Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1588E57DB86
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 09:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiGVHwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 03:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGVHwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 03:52:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967A415A1C;
        Fri, 22 Jul 2022 00:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 508B7B8279F;
        Fri, 22 Jul 2022 07:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04905C341C7;
        Fri, 22 Jul 2022 07:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658476340;
        bh=ZvAONlYYNQ8PsL65uf5ALselsuFp0Acf+/dRqaVeOmI=;
        h=Date:From:To:Cc:Subject:From;
        b=PtN//AyrRKdsjzZruS5uqJ1OutF6TkQhqxlFbBaMRa9J23fxRS58EmL2ScVgSjS7a
         LMtQxQh3LMvmdHMwh/ARywtol58I/qBD1+UCl9pBmp7jstrHWH/G78/tlSg5YKDVuq
         /xbZx7H5q59whqn7NLonT5Q4exlIH0vb9LGD8ERgTxGsOYV3Gx+vF5y6taVdigSYj+
         X7AEXItplRm2KFL8L+rfVbgzgSOmXBG2JK39M+HaRF0pQML3iMIuV+WTIBD3RT3PZc
         uBagtjkZc/IkNG+2ervc7GGbMu66d1FPpIqWyHgbTsk6Q62Qmh23GO61dphDrqo/AE
         anZnLPlv1wAaA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oEnSP-0007BX-T3; Fri, 22 Jul 2022 09:52:22 +0200
Date:   Fri, 22 Jul 2022 09:52:21 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: mac80211/ath11k regression in next-20220720
Message-ID: <YtpXNYta924al1Po@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

After moving from next-20220714 to next-20220720, ath11k stopped
working here and instead spits out a bunch of warnings (see log below).

I noticed that this series from Johannes was merged in that period:

	https://lore.kernel.org/all/20220713094502.163926-1-johannes@sipsolutions.net/

but can't say for sure that it's related. I also tried adding the
follow-up fixes from the mld branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/log/?h=mld

but it didn't seem to make any difference.

Any ideas about what might be going on here?

Johan


[  256.674853] wlan0: authenticate with 70:3a:cb:f7:3a:e4
[  256.687231] wlan0: bad VHT capabilities, disabling VHT
[  256.687324] wlan0: Invalid HE elem, Disable HE
[  256.687389] wlan0: 80 MHz not supported, disabling VHT
[  256.779398] wlan0: send auth to 70:3a:cb:f7:3a:e4 (try 1/3)
[  256.788290] wlan0: authenticated
[  256.807167] wlan0: 80 MHz not supported, disabling VHT
[  256.823138] wlan0: associate with 70:3a:cb:f7:3a:e4 (try 1/3)
[  256.932099] wlan0: associate with 70:3a:cb:f7:3a:e4 (try 2/3)
[  257.047894] wlan0: associate with 70:3a:cb:f7:3a:e4 (try 3/3)
[  257.156109] wlan0: association with 70:3a:cb:f7:3a:e4 timed out
[  257.171179] ath11k_pci 0006:01:00.0: failed to lookup peer 70:3a:cb:f7:3a:e4 on vdev 0
[  257.171340] ------------[ cut here ]------------
[  257.171360] WARNING: CPU: 4 PID: 71 at drivers/net/wireless/ath/ath11k/mac.c:7181 ath11k_mac_op_unassign_vif_chanctx
+0x1e8/0x2c0 [ath11k]

[  257.172255] Call trace:
[  257.172267]  ath11k_mac_op_unassign_vif_chanctx+0x1e8/0x2c0 [ath11k]
[  257.172313]  ieee80211_assign_link_chanctx+0x74/0x320 [mac80211]
[  257.172380]  __ieee80211_link_release_channel+0x58/0x150 [mac80211]
[  257.172443]  ieee80211_link_release_channel+0x3c/0x60 [mac80211]
[  257.172503]  ieee80211_destroy_assoc_data+0xcc/0x170 [mac80211]
[  257.172563]  ieee80211_sta_work+0x220/0xa20 [mac80211]
[  257.172621]  ieee80211_iface_work+0x388/0x3f0 [mac80211]
[  257.172681]  process_one_work+0x1cc/0x320
[  257.172708]  worker_thread+0x14c/0x450
[  257.172729]  kthread+0x10c/0x110
[  257.172747]  ret_from_fork+0x10/0x20
[  257.172768] ---[ end trace 0000000000000000 ]---
[  257.173752] ------------[ cut here ]------------
[  257.173771] WARNING: CPU: 4 PID: 71 at drivers/net/wireless/ath/ath11k/mac.c:6813 ath11k_mac_vdev_stop+0x134/0x1a0 [
ath11k]

[  257.175919] Call trace:
[  257.177237]  ath11k_mac_vdev_stop+0x134/0x1a0 [ath11k]
[  257.178582]  ath11k_mac_op_unassign_vif_chanctx+0x74/0x2c0 [ath11k]
[  257.179925]  ieee80211_assign_link_chanctx+0x74/0x320 [mac80211]
[  257.181281]  __ieee80211_link_release_channel+0x58/0x150 [mac80211]
[  257.182633]  ieee80211_link_release_channel+0x3c/0x60 [mac80211]
[  257.183990]  ieee80211_destroy_assoc_data+0xcc/0x170 [mac80211]
[  257.185350]  ieee80211_sta_work+0x220/0xa20 [mac80211]
[  257.186779]  ieee80211_iface_work+0x388/0x3f0 [mac80211]
[  257.188137]  process_one_work+0x1cc/0x320
[  257.189455]  worker_thread+0x14c/0x450
[  257.190771]  kthread+0x10c/0x110
[  257.192082]  ret_from_fork+0x10/0x20
[  257.193382] ---[ end trace 0000000000000000 ]---
[  257.194721] ath11k_pci 0006:01:00.0: failed to find peer vdev_id 0 addr 70:3a:cb:f7:3a:e4 in delete
[  257.196084] ath11k_pci 0006:01:00.0: failed to delete peer 70:3a:cb:f7:3a:e4 for vdev 0: -22
