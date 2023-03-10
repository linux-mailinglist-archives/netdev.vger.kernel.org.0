Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153366B3E52
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCJLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCJLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:47:02 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09F41111C7;
        Fri, 10 Mar 2023 03:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=bM1vAhEohfFFddiiiteQvy/S8eWo9E5W38sP+oPtxxw=; t=1678448814; x=1679658414; 
        b=tfOWdXbr834gApfdcgJpZjJvb8/Ro3ncobU0mqxWrJfPuX1dvJS4vDLpHAYGyWWRFElBpCwO3Mv
        mYWafe99LH0cRb1Nj3YxqrBmeXuntWeAbBoaZBrXHxY6h0bXkttBBm4vPaQN7V8qu9XrujDKK/kk8
        RCEGqyP1fDeeYj4JQAzCXcHfipVCtGKQhFWmEW4ELi/b1/gVudwQ5JlajAnXivfirDp2kz/jOxMwj
        P7L2LtDaRJ3eLi9H5YgR+IFTjZxEOO/gsdeGInGuH1TkRkqnQMq8GUtajqRtAJHvoB18KSUms1QPf
        5bLE9u0bcbQnTZcUKXsLUSX8BgeDJBb5nWPA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pabD1-00H0ZJ-0C;
        Fri, 10 Mar 2023 12:46:51 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2023-03-10
Date:   Fri, 10 Mar 2023 12:46:46 +0100
Message-Id: <20230310114647.35422-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

For now in wireless we only have a few fixes for some
recently reported (and mostly recently introduced)
problems.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 44889ba56cbb3d51154660ccd15818bc77276696:

  Merge tag 'net-6.3-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-03-09 10:56:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-03-10

for you to fetch changes up to 96c069508377547f913e7265a80fffe9355de592:

  wifi: cfg80211: fix MLO connection ownership (2023-03-10 11:47:25 +0100)

----------------------------------------------------------------
Just a few fixes:
 * MLO connection socket ownership didn't work
 * basic rates validation was missing (reported by
   by a private syzbot instances)
 * puncturing bitmap netlink policy was completely broken
 * properly check chandef for NULL channel, it can be
   pointing to a chandef that's still uninitialized

----------------------------------------------------------------
Johannes Berg (4):
      wifi: nl80211: fix NULL-ptr deref in offchan check
      wifi: nl80211: fix puncturing bitmap policy
      wifi: mac80211: check basic rates validity
      wifi: cfg80211: fix MLO connection ownership

 net/mac80211/cfg.c     | 21 +++++++++++----------
 net/wireless/nl80211.c | 26 +++++++++++++++-----------
 2 files changed, 26 insertions(+), 21 deletions(-)

