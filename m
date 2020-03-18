Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5C18A617
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgCRUyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgCRUyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D1120B1F;
        Wed, 18 Mar 2020 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564888;
        bh=wHVMFXCOPG4nZvILfcIh/HvdK/unXPCQb97HaqKUvT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCWEJ6nB8KFwsBsqkNBSMP0vHZLMbtdwS55IfICXwFy2PY8XX/8cNADnFOW9J7YEG
         ID3sr/JcsbI056LlNAs0iQuXA5vpNBhn2aKvR6w4TGMMbDgfQAj6fQzUkWR8rWE3uj
         4erWPodOS1QL6wrLhRCrPxwGhWssuzjgvwk0JApk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 57/73] nl80211: add missing attribute validation for beacon report scanning
Date:   Wed, 18 Mar 2020 16:53:21 -0400
Message-Id: <20200318205337.16279-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 056e9375e1f3c4bf2fd49b70258c7daf788ecd9d ]

Add missing attribute validation for beacon report scanning
to the netlink policy.

Fixes: 1d76250bd34a ("nl80211: support beacon report scanning")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20200303051058.4089398-3-kuba@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9ca16ca0528ac..f0c6c522964c2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -469,6 +469,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_PLINK_STATE] =
 		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_STATES - 1),
+	[NL80211_ATTR_MEASUREMENT_DURATION] = { .type = NLA_U16 },
+	[NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MESH_PEER_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
-- 
2.20.1

