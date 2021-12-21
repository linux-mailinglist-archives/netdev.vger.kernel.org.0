Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D7547B735
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 02:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhLUB62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 20:58:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhLUB6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:58:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8707B81100;
        Tue, 21 Dec 2021 01:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFB3C36AE5;
        Tue, 21 Dec 2021 01:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051898;
        bh=YNsmJF9wUl172QfFOO5juIGaWxLaevaK5MaNvB6td9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ti+7oQc0LC52oz27FBFa9xrFRURklqIuZimrn7MPUVEsDuGkVVW0XZFSNKL6fF4Di
         27cQxgUCaSjeKbaWLVZ2NDi+qQVL/e3pW4ENsnvfNEzIeLIQzKhyf/3CqCbDEbLGjT
         giunulDkZflr0fH3hE+tQIdwCRLKbdfOOWv3ktdaAQb8OhFquDzRzMwz9fBZT2ISRr
         NpWU8yT1BiobSiIY1dS9d5ODB8DhjZ85JXGkRnmvYiJ8NzV9ipx3Ga36BKKuf+S2r+
         G63+8CEIQINveAh1jKXSHvDbskHQxAOn9GyMhh6lb1uEPYoCqSuPWDTI3uCJ72dzCE
         YShlCPgVZAEaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/29] mac80211: Fix the size used for building probe request
Date:   Mon, 20 Dec 2021 20:57:36 -0500
Message-Id: <20211221015751.116328-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit f22d981386d12d1513bd2720fb4387b469124d4b ]

Instead of using the hard-coded value of '100' use the correct
scan IEs length as calculated during HW registration to mac80211.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.0a82d6891719.I8ded1f2e0bccb9e71222c945666bcd86537f2e35@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 03ea4f929b997..39961a4f55d12 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2061,7 +2061,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
-				     100 + ie_len);
+				     local->scan_ies_len + ie_len);
 	if (!skb)
 		return NULL;
 
-- 
2.34.1

