Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06EE176E72
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgCCFLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgCCFLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:11:09 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE013215A4;
        Tue,  3 Mar 2020 05:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212269;
        bh=Acem9Yk+8J44gj1pR+rzc2aijA4WBRsn1xT2ymQr8cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSLVAND9qeTgDW85OERPRM+/L0Cq3cuaeWRnZlf1Bv+X1SRYlBNJ9QFNR04vJlOYc
         xA7A4fSdL2jSsHDWubyt8gCJySRqVYU6rEoMyzX7V8O4G6V5lcsUO/E9xgV7fxPSX4
         nWV5SEPFdJiSPa0WvYP4cE5kpIYujU7Rn0qyinGI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org, Jakub Kicinski <kuba@kernel.org>,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH wireless 2/3] nl80211: add missing attribute validation for beacon report scanning
Date:   Mon,  2 Mar 2020 21:10:57 -0800
Message-Id: <20200303051058.4089398-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303051058.4089398-1-kuba@kernel.org>
References: <20200303051058.4089398-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for beacon report scanning
to the netlink policy.

Fixes: 1d76250bd34a ("nl80211: support beacon report scanning")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: David Spinadel <david.spinadel@intel.com>
CC: Luca Coelho <luciano.coelho@intel.com>
CC: Avraham Stern <avraham.stern@intel.com>
CC: Assaf Krauss <assaf.krauss@intel.com>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cd0e024d7cb6..48e6508aba52 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -470,6 +470,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_PLINK_STATE] =
 		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_STATES - 1),
+	[NL80211_ATTR_MEASUREMENT_DURATION] = { .type = NLA_U16 },
+	[NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MESH_PEER_AID] =
 		NLA_POLICY_RANGE(NLA_U16, 1, IEEE80211_MAX_AID),
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
-- 
2.24.1

