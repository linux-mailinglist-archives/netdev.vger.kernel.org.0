Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D272A47B827
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhLUCEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhLUCDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6309C07E5F4;
        Mon, 20 Dec 2021 18:01:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EAC861376;
        Tue, 21 Dec 2021 02:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D580C36AE5;
        Tue, 21 Dec 2021 02:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052113;
        bh=84KaSOMzoHm5K29GasXo/b52Xm3od8IA95wX1I3yXXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlZhnLoSin1zKfUyVSan9jCqRdhi8e2AJd91qCIr9e3Wa/MlN4GAZWfyo4i+ieWYm
         bHXoonr1UGhC3ZGC8pg+kOH456Vy+mymKxEBiSz6gRarjTsWqspiG7pExKmRaMPWLl
         9XHXohlWVMeeEXAma3CEK11LiW9wyJnvOGTUraBGH0uoHm4qFscqXyMoGnVAqHjumi
         xB1sMfCYAfoH2gn2yTz5tWLpDfMoNcrPY41bp7TW9oJPW6FZehehX4mhvtPGOdWszk
         MyC8URPwlo5hhkeVIugEtg0aTXlOSKYTf940W6BRJj7ONNBnRDzxlvZFRYzaaXuJqY
         8e4Jx2jLhDMzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/9] mac80211: Fix the size used for building probe request
Date:   Mon, 20 Dec 2021 21:01:20 -0500
Message-Id: <20211221020123.117380-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020123.117380-1-sashal@kernel.org>
References: <20211221020123.117380-1-sashal@kernel.org>
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
index cd3cdd1a0b576..e25d570479bf6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1548,7 +1548,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
-				     100 + ie_len);
+				     local->scan_ies_len + ie_len);
 	if (!skb)
 		return NULL;
 
-- 
2.34.1

