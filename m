Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4DF1F30AE
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388124AbgFIBBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgFHXIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AAD120774;
        Mon,  8 Jun 2020 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657687;
        bh=V2+xHMTqohevdbiF822LvwMu8HBv9ms+KvauSS3xlIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccUhWkvSmnGjfey3RYVsCxQpWSAEjkRTRbSq9EfMrNC6pPtZzii6T7muXQw/1csM2
         dxTXMhcrNW+dFnKXHCNBtb6j67Ggzq2eVKpbNPphthyo9FatEeb6yjGkXhadLBWqTQ
         ol5rLZF4QJ/id+Vs08kWZCw5AlzffB35EKwpJBkQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 089/274] ath11k: fix error message to correctly report the command that failed
Date:   Mon,  8 Jun 2020 19:03:02 -0400
Message-Id: <20200608230607.3361041-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9a8074e3bcd7956ec6b4f7c26360af1b0b0abe38 ]

Currently the error message refers to the command WMI_TWT_DIeABLE_CMDID
which looks like a cut-n-paste mangled typo. Fix the message to match
the command WMI_BSS_COLOR_CHANGE_ENABLE_CMDID that failed.

Fixes: 5a032c8d1953 ("ath11k: add WMI calls required for handling BSS color")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200327192639.363354-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e7ce36966d6a..6fec62846279 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2779,7 +2779,7 @@ int ath11k_wmi_send_bss_color_change_enable_cmd(struct ath11k *ar, u32 vdev_id,
 	ret = ath11k_wmi_cmd_send(wmi, skb,
 				  WMI_BSS_COLOR_CHANGE_ENABLE_CMDID);
 	if (ret) {
-		ath11k_warn(ab, "Failed to send WMI_TWT_DIeABLE_CMDID");
+		ath11k_warn(ab, "Failed to send WMI_BSS_COLOR_CHANGE_ENABLE_CMDID");
 		dev_kfree_skb(skb);
 	}
 	return ret;
-- 
2.25.1

