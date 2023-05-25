Return-Path: <netdev+bounces-5449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34144711485
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E737C1C2096D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEEE23C9B;
	Thu, 25 May 2023 18:40:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A8B22638
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDB8C433D2;
	Thu, 25 May 2023 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040036;
	bh=XafiMvi6pniguY3dOE4WmTLMg0zaHdHzxP2bGOjoW+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENdKoeheA2tfC4CQdwnSyxxX24CZNAgTNUDIhmu8TqR31ba+qK3ZMAvzV9Nbn2LKX
	 nivCrbH0Yg6BSVyoY1GQeNSX5PyZRkfvEc10yhS4I9gXfGWCOy23P2j0D9oKF9tEst
	 LrIevG5PViBR0lf16MmyE5QfahN+MPplUfSwkO5JjLDnpjwOIsXVlbMewACjzq9JqA
	 xcgtykPndX8YVLw16RNg7bGowZ9sZMaxWB6YwAhWUBgnrRI9LvKVKY8NkrsR8U07OF
	 EJMC4JCQE09uEVZ+r7TF65+DEu1xi9LaBSNGfKpW8BInVoU1rmxc+fgLIxwnzsOSw4
	 7YOzhoyf97bUw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 33/43] wifi: mac80211: simplify chanctx allocation
Date: Thu, 25 May 2023 14:38:44 -0400
Message-Id: <20230525183854.1855431-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525183854.1855431-1-sashal@kernel.org>
References: <20230525183854.1855431-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 860e1b43da94551cd1e73adc36b3c64cc3e5dc01 ]

There's no need to call ieee80211_recalc_chanctx_min_def()
since it cannot and won't call the driver anyway; just use
_ieee80211_recalc_chanctx_min_def() instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230504134511.828474-3-gregory.greenman@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 63e15f583e0a6..f32d8d07d6a30 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -563,7 +563,7 @@ ieee80211_alloc_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
 	ctx->conf.radar_enabled = false;
-	ieee80211_recalc_chanctx_min_def(local, ctx);
+	_ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	return ctx;
 }
-- 
2.39.2


