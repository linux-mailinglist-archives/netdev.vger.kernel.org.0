Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA305176E74
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgCCFLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbgCCFLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:11:10 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F48C2173E;
        Tue,  3 Mar 2020 05:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212269;
        bh=3g/nS2QPU8iYCOIqxGuzFG/Tz8mgplaIyPPBhcSeaIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIQg38ZPj6yJYZTrYvyIsHqxVyZJ+AN6cdwCY/49hSNLBL3Kjg4NN43eWlYBE2Pbw
         heapgX+fHa0pO8sb/tOWVfr3MZa89RHRfiF38Nc5deZgmgfJoVArwYu44QwZVOVf6U
         jsQuC1R97DwKHPNa+w9MfAjLtFDw0rK+mGc81jic=
From:   Jakub Kicinski <kuba@kernel.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org, Jakub Kicinski <kuba@kernel.org>,
        Arik Nemtsov <arik@wizery.com>
Subject: [PATCH wireless 3/3] nl80211: add missing attribute validation for channel switch
Date:   Mon,  2 Mar 2020 21:10:58 -0800
Message-Id: <20200303051058.4089398-4-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303051058.4089398-1-kuba@kernel.org>
References: <20200303051058.4089398-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for NL80211_ATTR_OPER_CLASS
to the netlink policy.

Fixes: 1057d35ede5d ("cfg80211: introduce TDLS channel switch commands")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Arik Nemtsov <arik@wizery.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48e6508aba52..ec5d67794aab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -565,6 +565,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		NLA_POLICY_MAX(NLA_U8, IEEE80211_NUM_UPS - 1),
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_OPER_CLASS] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = {
 		.type = NLA_EXACT_LEN_WARN,
 		.len = ETH_ALEN
-- 
2.24.1

