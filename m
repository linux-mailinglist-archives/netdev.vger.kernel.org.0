Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13AFFEDC3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfKPPqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbfKPPqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:43 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC5AA20898;
        Sat, 16 Nov 2019 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919203;
        bh=K6SV6E2fk/vQUx9u9jTQu3pwQlpbEddX+FJVxsoihFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kj9CzMvuWmhBftY5IqK3UZ9YpI+dLLh6HbgER8AhjRfBHY4txgrK7N2FndyqY0cI6
         cU98V9K/u/GN4+gNrCiIMTPYjxHzGHNFvEWSq6XTYA5k0K04CfTwe7sOgfWjB3KI/h
         QjKqrLa9qhnVvUOETmg6BwPR81qME7qXQ1glZfEI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 205/237] rtlwifi: rtl8192de: Fix misleading REG_MCUFWDL information
Date:   Sat, 16 Nov 2019 10:40:40 -0500
Message-Id: <20191116154113.7417-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

[ Upstream commit 7d129adff3afbd3a449bc3593f2064ac546d58d3 ]

RT_TRACE shows REG_MCUFWDL value as a decimal value with a '0x'
prefix, which is somewhat misleading.

Fix it to print hexadecimal, as was intended.

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 85cedd083d2b8..75bfa9dfef4aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -173,7 +173,7 @@ static int _rtl92d_fw_init(struct ieee80211_hw *hw)
 			 rtl_read_byte(rtlpriv, FW_MAC1_READY));
 	}
 	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
-		 "Polling FW ready fail!! REG_MCUFWDL:0x%08ul\n",
+		 "Polling FW ready fail!! REG_MCUFWDL:0x%08x\n",
 		 rtl_read_dword(rtlpriv, REG_MCUFWDL));
 	return -1;
 }
-- 
2.20.1

