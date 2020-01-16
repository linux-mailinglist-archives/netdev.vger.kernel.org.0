Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7513F416
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbgAPRKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389804AbgAPRKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471F324691;
        Thu, 16 Jan 2020 17:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194600;
        bh=9jFjZ5bu+tsaBRyIe6orZnczu0wyPfyxbPpkonaWPQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHKLR1NLahz5oNRrkeG2y20REgXpWV2mcGbBbj+LR/mRHIPiJMp5uEj1ETDauSmtF
         IO4IynIkjg/UMOUck50BDZdt/O7Dch/+x4g9rrewg0EEyWIfapTu7SLt/l0r9GAgbL
         jHbc8Yf9aDz9XQE+Tx9YgRNSeBTkv4Bk2cTW/00k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 468/671] libertas_tf: Use correct channel range in lbtf_geo_init
Date:   Thu, 16 Jan 2020 12:01:46 -0500
Message-Id: <20200116170509.12787-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2ec4ad49b98e4a14147d04f914717135eca7c8b1 ]

It seems we should use 'range' instead of 'priv->range'
in lbtf_geo_init(), because 'range' is the corret one
related to current regioncode.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 691cdb49388b ("libertas_tf: command helper functions for libertas_tf")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas_tf/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/cmd.c b/drivers/net/wireless/marvell/libertas_tf/cmd.c
index 909ac3685010..2b193f1257a5 100644
--- a/drivers/net/wireless/marvell/libertas_tf/cmd.c
+++ b/drivers/net/wireless/marvell/libertas_tf/cmd.c
@@ -69,7 +69,7 @@ static void lbtf_geo_init(struct lbtf_private *priv)
 			break;
 		}
 
-	for (ch = priv->range.start; ch < priv->range.end; ch++)
+	for (ch = range->start; ch < range->end; ch++)
 		priv->channels[CHAN_TO_IDX(ch)].flags = 0;
 }
 
-- 
2.20.1

