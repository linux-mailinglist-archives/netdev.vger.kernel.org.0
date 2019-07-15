Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF53A6944D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404907AbfGOOpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404695AbfGOOpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:45:51 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E386A20868;
        Mon, 15 Jul 2019 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201950;
        bh=hmAUVSk5NUoM581ONsivJRBzZRR3PCWnwVeYf0U1T4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojoQiVi1IoWeG+muCmn7/O+mDZheO8+UoIkWQeyPZM21wDUOzBbUCpptUMA67RwpM
         t0pOEI0vBt9pJOYY2ZvoUidDD2c0ZYghdEr+TA45laxLhP0xOvJ3ErV9l1ljZXy88V
         s3wAmtjtE8HQk4xa21cy+1GDlLhNG/9BOXOngsjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anilkumar Kolli <akolli@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/53] ath: DFS JP domain W56 fixed pulse type 3 RADAR detection
Date:   Mon, 15 Jul 2019 10:44:46 -0400
Message-Id: <20190715144535.11636-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anilkumar Kolli <akolli@codeaurora.org>

[ Upstream commit d8792393a783158cbb2c39939cb897dc5e5299b6 ]

Increase pulse width range from 1-2usec to 0-4usec.
During data traffic HW occasionally fails detecting radar pulses,
so that SW cannot get enough radar reports to achieve the success rate.

Tested ath10k hw and fw:
	* QCA9888(10.4-3.5.1-00052)
	* QCA4019(10.4-3.2.1.1-00017)
	* QCA9984(10.4-3.6-00104)
	* QCA988X(10.2.4-1.0-00041)

Tested ath9k hw: AR9300

Tested-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 2303ef96299d..0835828ffed7 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -111,7 +111,7 @@ static const struct radar_detector_specs jp_radar_ref_types[] = {
 	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, 29, false),
 	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, 29, false),
 	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, 50, false),
-	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, 50, false),
+	JP_PATTERN(3, 0, 4, 4000, 4000, 1, 18, 50, false),
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
 	JP_PATTERN(5, 6, 10, 200, 500, 1, 16, 50, false),
 	JP_PATTERN(6, 11, 20, 200, 500, 1, 12, 50, false),
-- 
2.20.1

