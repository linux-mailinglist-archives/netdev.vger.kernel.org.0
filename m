Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9ECA12A5D
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfECJZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:25:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51642 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfECJZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 05:25:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hMURL-0005qF-Fn; Fri, 03 May 2019 11:25:11 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/8] nl80211: fix NL80211_ATTR_FTM_RESPONDER policy
Date:   Fri,  3 May 2019 11:24:54 +0200
Message-Id: <20190503092501.10275-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190503092501.10275-1-johannes@sipsolutions.net>
References: <20190503092501.10275-1-johannes@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The nested policy here should be established using the
NLA_POLICY_NESTED() macro so the length is properly
filled in.

Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fffe4b371e23..f40a004ec6f2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -538,10 +538,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
 
-	[NL80211_ATTR_FTM_RESPONDER] = {
-		.type = NLA_NESTED,
-		.validation_data = nl80211_ftm_responder_policy,
-	},
+	[NL80211_ATTR_FTM_RESPONDER] =
+		NLA_POLICY_NESTED(nl80211_ftm_responder_policy),
 	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
 		NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
-- 
2.17.2

