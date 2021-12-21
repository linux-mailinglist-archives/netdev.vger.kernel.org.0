Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D8947B7E3
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhLUCCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:02:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57046 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhLUCBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:01:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04C3B61366;
        Tue, 21 Dec 2021 02:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BFCC36AE5;
        Tue, 21 Dec 2021 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052075;
        bh=S6MJp60JFU0y4e9Rog1JoZ2y9VbiKJPRS89TaU+hA/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQg/m7SlzvAj7rUYwcYnnHf2LfR0eAB73TuGi54pgnGxif0x+ufzQt5hK1DOqv5Nr
         YAPJAVux6d8ms9yYOnwuvGj5yG2B/UCpT0b+0FnhQ5JsEsAAn8gTGAIhJGbIgliACn
         7PPP9ADwC6dT0JidUgv3xk9F6aLp0WN3ysKRuAYBOwDnOgcyRt/LhAhDDrPVrFsiDt
         scZ2u29f1bE33pnzXa01i+Q6Kl4wB8+K2NOax2S3MVFPgGVXnpIx8nDjblJt9y7gPe
         7XJqQdiYMJ4a34JdajwL+8YNdXsOjdp65ik4e+ZsMeyx8IHkmKDtc7QJubbDvrh0pH
         YzWPZUdrlMQGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/11] mac80211: Fix the size used for building probe request
Date:   Mon, 20 Dec 2021 21:00:25 -0500
Message-Id: <20211221020030.117225-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020030.117225-1-sashal@kernel.org>
References: <20211221020030.117225-1-sashal@kernel.org>
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
index 7fa9871b1db9f..a653632ac5902 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1638,7 +1638,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
-				     100 + ie_len);
+				     local->scan_ies_len + ie_len);
 	if (!skb)
 		return NULL;
 
-- 
2.34.1

