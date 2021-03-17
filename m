Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEAF33E362
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhCQA4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhCQA4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4FE264F9B;
        Wed, 17 Mar 2021 00:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942567;
        bh=6trsffUs/8vhCMgAh9Mt0PIKJrww1mYU5yj1hfpoZxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4wNI39G36WTd3/i0Sp1JKaIKcI3+gh4NXajnHvmxj6wSUNKMBaygfr3qKQnauwzO
         oRqzUTTSRCsRamdyHzCGsxIgTFHFLgn1SqGCOvfE7dkpRMYfNgjW3/vmmtbWu+D2yx
         1gE1X2vEVusz71fUmB2TpJeJnGECgV8hBXgiWwGGX2qZfguQ9GQ7+DR9/zJ+HWXd6I
         0gU0nqjfPsDqYA20lKSRRFVWSXl44hJ/qzwh6aaT2YQ5Nv2MHW3FD/AMKerNuwX0CQ
         bm5NuhMXhmPdmvGn+8Vj8ee5WZZWQMgUxMv1LQKou5VkoPjYeUyP3eeLQHtim2vOaH
         3HC3RX/V4Djjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 25/61] net: davicom: Use platform_get_irq_optional()
Date:   Tue, 16 Mar 2021 20:54:59 -0400
Message-Id: <20210317005536.724046-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index 3fdc70dab5c1..bd19567124a6 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1501,7 +1501,7 @@ dm9000_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	db->irq_wake = platform_get_irq(pdev, 1);
+	db->irq_wake = platform_get_irq_optional(pdev, 1);
 	if (db->irq_wake >= 0) {
 		dev_dbg(db->dev, "wakeup irq %d\n", db->irq_wake);
 
-- 
2.30.1

