Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509982E1757
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbgLWDJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:09:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728206AbgLWCSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F4E12337F;
        Wed, 23 Dec 2020 02:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689850;
        bh=vtedTUleFBXNCwzg4s3bdonFwhcKHWAbDQIhK5MwOZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZhEERGS4tySGq/PJVDs8oO8H+YJRhCQ1j3wi0cvE0xLvUplQFNOQ2ZVNI/P63JPn
         ll0Jziby4jdayXARGoBi4FI+t0atDpgB0M2VKOufP+vhD5XHfzg883wSC84AaMoj0e
         tB/eCz3++Jpf71H2WleEzmqQ8MI81V/A4mJKVCpyL4SxLdX7X+MasWNXoUjL3q0c+3
         EgXo5nNQoSVbTong/Q6htMenQd/sHaCvo6Z7UHEPYERmWzYjOs0c44MnbiUqhmpPBk
         uWk6WNkWfyZbgBI1EIibfzwPk6cj56BBILw+DnqrlvY24AwI094nyeHrHEYAdLccO5
         PF3Y9AjqdxmjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamizh Chelvam <tamizhr@codeaurora.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 049/217] ath10k: fix compilation warning
Date:   Tue, 22 Dec 2020 21:13:38 -0500
Message-Id: <20201223021626.2790791-49-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tamizh Chelvam <tamizhr@codeaurora.org>

[ Upstream commit b9162645117841978a3fb31546409271e007dd28 ]

This change fixes below compilation warning.

smatch warnings:
 drivers/net/wireless/ath/ath10k/mac.c:9125 ath10k_mac_op_set_tid_config() error: uninitialized symbol 'ret'.

No functional changes. Compile tested only.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1604507837-29361-1-git-send-email-tamizhr@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2e3eb5bbe49c8..d62b9edd60666 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9169,10 +9169,11 @@ static int ath10k_mac_op_set_tid_config(struct ieee80211_hw *hw,
 			goto exit;
 	}
 
+	ret = 0;
+
 	if (sta)
 		goto exit;
 
-	ret = 0;
 	arvif->tids_rst = 0;
 	data.curr_vif = vif;
 	data.ar = ar;
-- 
2.27.0

