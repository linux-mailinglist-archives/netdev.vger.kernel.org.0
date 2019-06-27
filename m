Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF7C575A5
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfF0AbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfF0AbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:05 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B5E217D9;
        Thu, 27 Jun 2019 00:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595464;
        bh=hfofzkUcH0VTTJYIQDvXderaZwVE2BnV09M1bS/FYS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gozPo01/wCrvdsuKd+X/WmTVUjM5/rzCJxAg96WdfvJ3nLclRV1ASgx9vbYo1da6h
         1iIpGcXvkPIGVRdVVslD/ROuQ2A6K7k433dm91uwi60T00pVT+eKaGTFbZXDJHjazt
         e8wK9+sbTJeSWB4aCCY5eUKBA7gb59DcZhXay3KI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 13/95] mac80211: fix rate reporting inside cfg80211_calculate_bitrate_he()
Date:   Wed, 26 Jun 2019 20:28:58 -0400
Message-Id: <20190627003021.19867-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
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
index 75899b62bdc9..5a03f38788e7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1237,7 +1237,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 	if (rate->he_dcm)
 		result /= 2;
 
-	return result;
+	return result / 10000;
 }
 
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
-- 
2.20.1

