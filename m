Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9621E47B838
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhLUCGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbhLUCD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:03:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2FBC0698C5;
        Mon, 20 Dec 2021 18:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1710B81114;
        Tue, 21 Dec 2021 02:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA41C36AE8;
        Tue, 21 Dec 2021 02:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052125;
        bh=GUKLvCW3QxUOI2qq6LJRRmK+b6RA3leVbn6X5p3+IPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oeUC77BK0q1PdNwV+bD1a8SdFbcZ5yXvqJRvDa0YnyVORFvZU3N/Kk9c1GelQP2WD
         QKJ/E6AkCWiN94WeUGrgcHet3tc98uSbnu7RXUltbQzwBJ891VJNZbR/j99aeR3ahR
         VZAqllBAl0up5Uf0mfKwcs+a15AtA8RqbZ6R9gPArYf0M3btW1PzioxAkpuk0LKjfg
         CS7shL1GKw5JzUdipSPzaxK2PDwXLdZiIi+uXvwcX9/B+IHS//mgIdeTM0oRHH0J8C
         n3QG06r8c+npoTPz5N2swrDPKUy9hAKwp6aDthIkyclJM62i8+veA+sGv1N/9ipu7b
         VBEj8hs2PJIWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/4] mac80211: Fix the size used for building probe request
Date:   Mon, 20 Dec 2021 21:01:58 -0500
Message-Id: <20211221020158.117612-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020158.117612-1-sashal@kernel.org>
References: <20211221020158.117612-1-sashal@kernel.org>
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
index 52f9742c438a4..a7e1a29a95933 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1545,7 +1545,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
-				     100 + ie_len);
+				     local->scan_ies_len + ie_len);
 	if (!skb)
 		return NULL;
 
-- 
2.34.1

