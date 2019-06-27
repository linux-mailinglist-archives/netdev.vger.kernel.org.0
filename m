Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E66C57639
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfF0Agh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbfF0Agg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:36:36 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3CF21851;
        Thu, 27 Jun 2019 00:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595795;
        bh=PUOoeL0ycfB19n0toeqNbyznI5I6SOYyob2cp42sH5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyBR2hU1CoUwBqpp7BbJRIbAALuimOwBvWaE5Cd1bQInHUs3fMo4gvfS5nZzm3Z1K
         qKztoc6bXdd7c4wYhx+EH3wq4lD/3k769SEapB19J3YvZDXvCoeh2fUOGng+wIZDEz
         2+X8+O+3xegXXOysexEmFkWpGLu43BGammDI0fZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/60] mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()
Date:   Wed, 26 Jun 2019 20:35:21 -0400
Message-Id: <20190627003616.20767-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Crispin <john@phrozen.org>

[ Upstream commit 25d16d124a5e249e947c0487678b61dcff25cf8b ]

The reported rate is not scaled down correctly. After applying this patch,
the function will behave just like the v/ht equivalents.

Signed-off-by: Shashidhar Lakkavalli <slakkavalli@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index aad1c8e858e5..d57e2f679a3e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1219,7 +1219,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (rate->he_dcm)
 		result /= 2;
 
-	return result;
+	return result / 10000;
 }
 
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
-- 
2.20.1

