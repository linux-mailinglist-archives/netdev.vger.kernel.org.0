Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA9E2E16B0
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbgLWDBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgLWCTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C5023159;
        Wed, 23 Dec 2020 02:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689970;
        bh=mryxAGDjFsX1PIuKmjvH8P02Z6RglY+u4e6jSfjHakA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMv2kgrcKPd+SfJ1+NPNOqoHjw6Jr+o9P1Uc8PVfg/YsjuQN+gZ/qvAWfD6G/XSoS
         zmrEcbAFe+o7xW2lATE5p+Z2DTdj2zNkOCaNAtL7k46X5/UQsl8kLvebW4zPOGP3Oh
         bw4aGtOyltp6wTc7ST3+kBg6cUa8kkaPcM36cruM488NlAAIVyHuQNtuTChm8ne86b
         47ma4wa3cjZDmjc6NA+/rpZop71LYNvRrarI2JM+B05CWCVi612OMR0vlQGvlkGZ7Q
         9fIs/5Wvzwm6T+3UjJJLfOZbieIyV8EtZTvDj6E9OlTUFgEDLD8C+Jk5jRaFHj0pWx
         tV6U4pNt6Y3Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ching-Te Ku <ku920601@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 060/130] rtw88: coex: change the decode method from firmware
Date:   Tue, 22 Dec 2020 21:17:03 -0500
Message-Id: <20201223021813.2791612-60-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit 362c4a5cc886e9c369bf2106ab648c2ad076abb6 ]

Fix sometimes FW information will be parsed as wrong value,
do a correction of sign bit to show the correct information.
(Ex, Value should be 20, but it shows 236.)

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201112031430.4846-12-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 853ac1c2ed73c..634044a14bb78 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -2451,7 +2451,7 @@ void rtw_coex_wl_fwdbginfo_notify(struct rtw_dev *rtwdev, u8 *buf, u8 length)
 		if (buf[i] >= val)
 			coex_stat->wl_fw_dbg_info[i] = buf[i] - val;
 		else
-			coex_stat->wl_fw_dbg_info[i] = val - buf[i];
+			coex_stat->wl_fw_dbg_info[i] = 255 - val + buf[i];
 
 		coex_stat->wl_fw_dbg_info_pre[i] = buf[i];
 	}
-- 
2.27.0

