Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221F8176E6F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgCCFLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgCCFLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:11:09 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 419A0214D8;
        Tue,  3 Mar 2020 05:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212268;
        bh=6haNE0t4L7XP3kqs2nre8rVY0GF2T4MZ+TIai8tnIWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1zmIJjg5k7zy4T3PUeETLudVEkV2+3xg7daHHRq5dE63ESV+uhaGFSqMub5uWt8f
         TXdl2LL6NCgwiraWBjjbWwvxL2NfjkBU2C8nd62TPyCtr+UIHV6QyznIsEk2td9L9o
         BY+TtwMpfUwSgbkkMfvG08x2ZYdroAxfiBA+BHtE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org, Jakub Kicinski <kuba@kernel.org>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>
Subject: [PATCH wireless 1/3] nl80211: add missing attribute validation for critical protocol indication
Date:   Mon,  2 Mar 2020 21:10:56 -0800
Message-Id: <20200303051058.4089398-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303051058.4089398-1-kuba@kernel.org>
References: <20200303051058.4089398-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for critical protocol fields
to the netlink policy.

Fixes: 5de17984898c ("cfg80211: introduce critical protocol indication from user-space")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
CC: Arend van Spriel <arend@broadcom.com>
CC: Pieter-Paul Giesberts <pieterpg@broadcom.com>

Leaving the conversion to RANGE to a follow up,
as this may get stabled.
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b19e9fac4aa..cd0e024d7cb6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -531,6 +531,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_CRIT_PROT_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_MAX_CRIT_PROT_DURATION] = { .type = NLA_U16 },
 	[NL80211_ATTR_PEER_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_CH_SWITCH_COUNT] = { .type = NLA_U32 },
-- 
2.24.1

