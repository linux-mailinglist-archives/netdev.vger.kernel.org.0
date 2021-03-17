Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA1C33E424
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhCQA6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhCQA5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE6164FAE;
        Wed, 17 Mar 2021 00:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942644;
        bh=q53tmHPLBEu64poATFTUri5JGMMdG6RfXvashlFEc6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZg6CK+tBoXWXuZW9IF+hEodBtqUL5lRKuKHbXiM6/SdeFW7SiqPwAWGGCHug19k4
         SbUyinQGd/mUKGRhKoJ3gPoepLUd24xfrVpUzecODMC/S7Enh7qqkhS0EwbnKCXrzU
         Kn3MpBA2S8pqce6S6GPlVLg40dmjatyJkDESJyPk5Ia1r53W64tWPpcHM2xah7XR1/
         O7zGrZVTD5gRlSklDpqsMPJTBaw+9XpHnObG+kZzTJtvvehnceWMF+9hfu3JZ8uvzT
         Lo11xp3MbVs3b11XmXxl0kJq1BFX4yAHo5H8Kk5IGo63CPKFe4557hGgKWhU9e4clO
         MdI5S1GcTsvOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/54] net: davicom: Use platform_get_irq_optional()
Date:   Tue, 16 Mar 2021 20:56:23 -0400
Message-Id: <20210317005654.724862-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 2e2696223676d56db1a93acfca722c1b96cd552d ]

The second IRQ line really is optional, so use
platform_get_irq_optional() to obtain it.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/davicom/dm9000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 5c6c8c5ec747..166620241494 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1504,7 +1504,7 @@ dm9000_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	db->irq_wake = platform_get_irq(pdev, 1);
+	db->irq_wake = platform_get_irq_optional(pdev, 1);
 	if (db->irq_wake >= 0) {
 		dev_dbg(db->dev, "wakeup irq %d\n", db->irq_wake);
 
-- 
2.30.1

