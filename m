Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECE42CB4A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhJMUrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhJMUqu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5501A6113D;
        Wed, 13 Oct 2021 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157886;
        bh=BdejYnqQtajSfvKhHdWBG4JMpuLyIt7cl+zkM2w94FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyKkq/5uS3a6dJWEhZ6WqLghaPKWsO01yjZz4/9OCw1/dEoBV4C6zmu2ZCkPt9JGV
         WDN6tbQBteci3qoYyN8D211bhcYcN/GaIz2Koll7+UFQ4TBgxTCX3QmVnvk85WOGB/
         1HoNEWQAN1hJOPilqpjDFXt4yRXVqybaU4rhSSDo3kraDT9M7rn98RbRDYAxZmF8FW
         BI7UF1dHA/f7QWuyhRbKLCzjL6Dzl8qx+73e0uIyZr2nnAUTQdfs/ILWoCDGiLyVV6
         0jSB17E9Vs9kHuCAYH6Fa8QWk796VcRn7DikYjcUuKAgsLrNU4HYbR6C4ufaPrdu08
         20c1vaNVwemTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/7] ethernet: ibm/emac: use of_get_ethdev_address() to load dev_addr
Date:   Wed, 13 Oct 2021 13:44:33 -0700
Message-Id: <20211013204435.322561-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A straggler I somehow missed in the automated conversion in
commit 9ca01b25dfff ("ethernet: use of_get_ethdev_address()").
Use the new helper instead of using netdev->dev_addr directly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 8db0ec38bbee..6b3fc8823c54 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2975,7 +2975,7 @@ static int emac_init_config(struct emac_instance *dev)
 	}
 
 	/* Read MAC-address */
-	err = of_get_mac_address(np, dev->ndev->dev_addr);
+	err = of_get_ethdev_address(np, dev->ndev);
 	if (err) {
 		if (err != -EPROBE_DEFER)
 			dev_err(&dev->ofdev->dev, "Can't get valid [local-]mac-address from OF !\n");
-- 
2.31.1

