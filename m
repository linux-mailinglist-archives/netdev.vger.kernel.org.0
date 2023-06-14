Return-Path: <netdev+bounces-10624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD9172F708
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92DBD281325
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D192117D7;
	Wed, 14 Jun 2023 07:55:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36AD7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:55:08 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B441FDE;
	Wed, 14 Jun 2023 00:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=+93bg2u37IZ2abu7281QFEmzxqZpvE70pwxwTdayMyk=; t=1686729307; x=1687938907; 
	b=rzSyzkws6/lV/RfiQMY+uLpKp/2kwhud2eCcdY78+QI+tlZYZlMSEam8PX1Qf3MAL/zWJmXL6M5
	WOTk5Ww/p4se1JfAal8OWgHB9PWuWbx8xqUeu2m/HTZLPj4def9mZMkBwqaoftQ/Vz6M0DOx3aHEX
	SLlJ7OK4m5LhCrKwH4PFXt9CqSiNI5NUsLTZ/Zhi9YRZLUL0Vt3dv+xZhwSsjh3ZwViXS9MyR+wFD
	xO3InTMZV8x8gvGpKAyHMzXTkyEyfCk22Mq8xcr1b3Bc8kW2J6U8g2503+uvD++eaZ/4x+R3X776k
	7AiSwN1sH5TLOZro3Na/KGHjHwG5vGP0XNFQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1q9LLN-005zVC-2l;
	Wed, 14 Jun 2023 09:55:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2023-06-14
Date: Wed, 14 Jun 2023 09:55:01 +0200
Message-Id: <20230614075502.11765-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I know it's getting late in the game, but there were still
a number of locking related fixes and some other things
coming in recently, so here they are.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit f7e60032c6618dfd643c7210d5cba2789e2de2e2:

  wifi: cfg80211: fix locking in regulatory disconnect (2023-06-06 14:51:32 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2023-06-14

for you to fetch changes up to f1a0898b5d6a77d332d036da03bad6fa9770de5b:

  wifi: iwlwifi: mvm: spin_lock_bh() to fix lockdep regression (2023-06-14 09:05:51 +0200)

----------------------------------------------------------------
A couple of straggler fixes, mostly in the stack:
 * fix fragmentation for multi-link related elements
 * fix callback copy/paste error
 * fix multi-link locking
 * remove double-locking of wiphy mutex
 * transmit only on active links, not all
 * activate links in the correct order
 * don't remove links that weren't added
 * disable soft-IRQs for LQ lock in iwlwifi

----------------------------------------------------------------
Benjamin Berg (3):
      wifi: cfg80211: fix link del callback to call correct handler
      wifi: mac80211: take lock before setting vif links
      wifi: mac80211: fragment per STA profile correctly

Dan Carpenter (1):
      wifi: cfg80211: fix double lock bug in reg_wdev_chan_valid()

Hugh Dickins (1):
      wifi: iwlwifi: mvm: spin_lock_bh() to fix lockdep regression

Ilan Peer (1):
      wifi: mac80211: Use active_links instead of valid_links in Tx

Johannes Berg (2):
      wifi: mac80211: fix link activation settings order
      wifi: cfg80211: remove links only on AP

 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 12 ++++++------
 net/mac80211/cfg.c                          |  9 ++++++++-
 net/mac80211/ieee80211_i.h                  |  2 +-
 net/mac80211/link.c                         |  4 ++--
 net/mac80211/mlme.c                         |  5 +++--
 net/mac80211/tx.c                           |  6 +++---
 net/mac80211/util.c                         |  4 ++--
 net/wireless/rdev-ops.h                     |  6 +++---
 net/wireless/reg.c                          |  3 ---
 net/wireless/util.c                         |  9 ++++++++-
 10 files changed, 36 insertions(+), 24 deletions(-)


