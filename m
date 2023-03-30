Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497896D100E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjC3Udl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjC3Udk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:33:40 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC4DC14A;
        Thu, 30 Mar 2023 13:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=4vEkhJmEUEYsuUo5MjzSqkmJqB8oAk66OhQrLB69/u0=; t=1680208406; x=1681418006; 
        b=a5ncNhlgVfZ6X4u8KDVf2ZxeSib4V4IGex5d3zhESGBfUzndKmP58F5ao4IHkwqSGtVjzzqdnB8
        oX1LYdw7R4NGLAhAbkkPmxRXKC6AgtyYsF1T0c8WnzeBAi/JgGURNvwWlV/jF2Nyv9uB5Mq4p2nR0
        apTRAYMUSimsvFbrt/7KLcQ34XAOOc4+pu6KHNg/jSpghIXw8UBxnWFwhUwNB0Uw4m3/LGFz0x3pL
        uW0SOVp2qTE6Mc/Wmv9nC4iMvCEuj2QV5SMUIl6/wV3GJbQH155MTSLj3frFcPb87F+8i+wpD64mg
        pNRsy0WI/Q1vkD8O2ubmCjColZoqBcnBNQ4g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phyxX-001RcA-26;
        Thu, 30 Mar 2023 22:33:23 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2023-03-30
Date:   Thu, 30 Mar 2023 22:33:12 +0200
Message-Id: <20230330203313.919164-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a small set of fixes for the net. Most of the
issues are relatively new.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f355f70145744518ca1d9799b42f4a8da9aa0d36:

  wifi: mac80211: fix mesh path discovery based on unicast packets (2023-03-22 13:46:46 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-03-30

for you to fetch changes up to 12b220a6171faf10638ab683a975cadcf1a352d6:

  wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta (2023-03-30 11:19:53 +0200)

----------------------------------------------------------------
Just a few fixes:
 * fix size calculation for EHT element to put into SKBs
 * remove erroneous pre-RCU calls for drivers not using sta_state calls
 * fix mesh forwarding and non-forwarding RX
 * fix mesh flow dissection
 * fix a potential NULL dereference on A-MSDU RX w/o station
 * make two variable non-static that really shouldn't be static

----------------------------------------------------------------
Felix Fietkau (6):
      wifi: mac80211: drop bogus static keywords in A-MSDU rx
      wifi: mac80211: fix potential null pointer dereference
      wifi: mac80211: fix receiving mesh packets in forwarding=0 networks
      wifi: mac80211: fix mesh forwarding
      wifi: mac80211: fix flow dissection for forwarded packets
      wifi: mac80211: fix invalid drv_sta_pre_rcu_remove calls for non-uploaded sta

Ryder Lee (1):
      wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()

 net/mac80211/rx.c       | 29 ++++++++++++++++-------------
 net/mac80211/sta_info.c |  3 ++-
 net/mac80211/util.c     |  2 +-
 3 files changed, 19 insertions(+), 15 deletions(-)

