Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7133E4B4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhCQBAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhCQA6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAAA564FDC;
        Wed, 17 Mar 2021 00:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942706;
        bh=CQc9slPGL4g3f67igfau97+LTUFoNFOw+FsaA6BWRuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFUiCJhagDjz29jZLXyM3gMwKVy0uoKMvbqi+XtbZEswZY/1uAhmMwgVxy6u4deBQ
         BzW9+Zu55EI9BCeR8iAUXjVadk+1v/tqSqPwaFvbL/Zsw8iNc1FjGKOcrbh+6kyWZK
         5VaeunKycZWKv94XIioMVCIxtMTmuC/w0ssXC6lrdJeml/4BUMakRdQPose/n9wAl6
         QOgkix3G+0bk2oI2MslSeAq3NWlugEHwhvoCUXKK//NWujjJY1Q7LPEKtginecreJ4
         JjZZrU6A0PDo+5wFs6+tMp2tdUV3RqIo4Wqb02FFlKgi9XMRKlhGhLmg620C7NnV6U
         EejgoH0ZBaWJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/37] net: davicom: Use platform_get_irq_optional()
Date:   Tue, 16 Mar 2021 20:57:44 -0400
Message-Id: <20210317005802.725825-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index 70060c51854f..733473bdb2fa 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1506,7 +1506,7 @@ dm9000_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	db->irq_wake = platform_get_irq(pdev, 1);
+	db->irq_wake = platform_get_irq_optional(pdev, 1);
 	if (db->irq_wake >= 0) {
 		dev_dbg(db->dev, "wakeup irq %d\n", db->irq_wake);
 
-- 
2.30.1

