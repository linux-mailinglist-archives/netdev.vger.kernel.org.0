Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624FD260120
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbgIGQ7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729970AbgIGQdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD1321927;
        Mon,  7 Sep 2020 16:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496431;
        bh=YB6LMn6dVIAQQecjsMuXES5wSTgr8G+mlKOQ3KV/a/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrBtNZLbgPDPgOEez+zdRHxQ7E6NjXab+SayYx/ZBK+aSg4JhVnMvfYVDkJCK1osw
         D6XXJoH9i6uyJE99EIKqkD2CTU1OylkgYYcKzya+/AIRD9KS/L3ygETeOv/HpJOjy/
         iTEoeMBi7N/N2DX43wbmT7WRHXo7QNyZSTlMBmK4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amar Singhal <asinghal@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/43] cfg80211: Adjust 6 GHz frequency to channel conversion
Date:   Mon,  7 Sep 2020 12:33:02 -0400
Message-Id: <20200907163329.1280888-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amar Singhal <asinghal@codeaurora.org>

[ Upstream commit 2d9b55508556ccee6410310fb9ea2482fd3328eb ]

Adjust the 6 GHz frequency to channel conversion function,
the other way around was previously handled.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
Link: https://lore.kernel.org/r/1592599921-10607-1-git-send-email-asinghal@codeaurora.org
[rewrite commit message, hard-code channel 2]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8481e9ac33da5..9abafd76ec50e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -116,11 +116,13 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 	else if (freq >= 4910 && freq <= 4980)
 		return (freq - 4000) / 5;
-	else if (freq < 5945)
+	else if (freq < 5925)
 		return (freq - 5000) / 5;
+	else if (freq == 5935)
+		return 2;
 	else if (freq <= 45000) /* DMG band lower limit */
-		/* see 802.11ax D4.1 27.3.22.2 */
-		return (freq - 5940) / 5;
+		/* see 802.11ax D6.1 27.3.22.2 */
+		return (freq - 5950) / 5;
 	else if (freq >= 58320 && freq <= 70200)
 		return (freq - 56160) / 2160;
 	else
-- 
2.25.1

