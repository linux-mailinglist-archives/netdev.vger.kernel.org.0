Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA204C8E04
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiCAOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiCAOkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:40:41 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38D9630B;
        Tue,  1 Mar 2022 06:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=4BNEEvJoXig/KzB3uGuGWhzfQK9sB/928NSJ69bg+yU=; t=1646145595; x=1647355195; 
        b=Tl4kPSNUsoDuA3T01Q5iu1Ss60OixMKdvm2xgQMCmtl6SWgWhUFBnYvQvNQPfaYPlWQw23ik+27
        Ko9Mgubq5Hy6g53UFRDKwpj+EOx7DQcszWPpYEFIO8Eqn4Jqr16mFQGcMDJ4ZLCqjlU0EPG11BGgr
        l7DPGc+tkDdDYa5JMs52ki1cn6wFrGMuSRi2ittqdE5ZrY2XZrNOVDf+YIXjGqVKAn0k0OJsU9DCa
        GbfWjEG9NOIOeTmOKeuxYQyIJUhL9p3+dwadSSWyrRsOVwD5sLEg6Wf4X9tDfIuCq0BFqUrYGZKI1
        mdEIy+68d6Ho9EC+YzxS+nSaYhiUxKBwD5Ng==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nP3fN-007MtY-DM;
        Tue, 01 Mar 2022 15:39:53 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless 2022-03-01
Date:   Tue,  1 Mar 2022 15:39:47 +0100
Message-Id: <20220301143948.57278-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.35.1
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

So now for the first time I'm sending a pull request
from our combined tree ... let's see if I'm getting
it right.

We actually still have quite a few fixes, but most of
them trickled in through the last couple of days, or
were still somewhat under discussion.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit bf8e59fd315f304eb538546e35de6dc603e4709f:

  atl1c: fix tx timeout after link flap on Mikrotik 10/25G NIC (2022-02-11 14:41:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-for-net-2022-03-01

for you to fetch changes up to a12f76345e026f1b300a0d17c56f020b6949b093:

  cfg80211: fix CONFIG_CFG80211_EXTRA_REGDB_KEYDIR typo (2022-03-01 14:10:14 +0100)

----------------------------------------------------------------
Some last-minute fixes:
 * rfkill
   - add missing rfill_soft_blocked() when disabled

 * cfg80211
   - handle a nla_memdup() failure correctly
   - fix CONFIG_CFG80211_EXTRA_REGDB_KEYDIR typo in
     Makefile

 * mac80211
   - fix EAPOL handling in 802.3 RX path
   - reject setting up aggregation sessions before
     connection is authorized to avoid timeouts or
     similar
   - handle some SAE authentication steps correctly
   - fix AC selection in mesh forwarding

 * iwlwifi
   - remove TWT support as it causes firmware crashes
     when the AP isn't behaving correctly
   - check debugfs pointer before dereferncing it

----------------------------------------------------------------
Ben Dooks (1):
      rfkill: define rfill_soft_blocked() if !RFKILL

Deren Wu (1):
      mac80211: fix EAPoL rekey fail in 802.3 rx path

Golan Ben Ami (1):
      iwlwifi: don't advertise TWT support

Jiasheng Jiang (1):
      nl80211: Handle nla_memdup failures in handle_nan_filter

Johannes Berg (3):
      mac80211: refuse aggregations sessions before authorized
      mac80211: treat some SAE auth steps as final
      cfg80211: fix CONFIG_CFG80211_EXTRA_REGDB_KEYDIR typo

Nicolas Escande (1):
      mac80211: fix forwarded mesh frames AC & queue selection

Randy Dunlap (1):
      iwlwifi: mvm: check debugfs_dir ptr before use

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 11 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  1 -
 include/linux/rfkill.h                             |  5 +++++
 net/mac80211/agg-tx.c                              | 10 +++++++++-
 net/mac80211/ieee80211_i.h                         |  2 +-
 net/mac80211/mlme.c                                | 16 ++++++++++++----
 net/mac80211/rx.c                                  | 14 +++++---------
 net/wireless/Makefile                              |  2 +-
 net/wireless/nl80211.c                             | 12 ++++++++++++
 10 files changed, 54 insertions(+), 22 deletions(-)

