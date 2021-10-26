Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34C43B89B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhJZRxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235152AbhJZRxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49BA60F24;
        Tue, 26 Oct 2021 17:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635270652;
        bh=iCVmFN9H6OTgsfDSH4k0BDSm2Da0RWMIQ7h+0LMCCwc=;
        h=From:To:Cc:Subject:Date:From;
        b=ChE86XzNP0H7IWMu9g2ZVa13veaaPTImTRW5izZZVInyWEwdp9JwhIr5zXH0Rzpdu
         4u+ibc1qy8pkOmNEn7M0xAjBxhzfmxeUpxL+HlAPcIWPBV9jpHgOjES4KNpXbwCUHj
         +niUYURAexeeyNSEAaumPXZ1gB4LsiljV5xCjhtGIJq8HTdmccyX7ngk/82jA7gPu4
         oE6RLfkEK9yz6aPeFwLGfa1/88AXXCfRCM6UrpWZTpxVxjFtyAhoDbcSnJtdAn/kE7
         ajOlmacG37mWXZgo0vraeWRs8g3mA6OtmAQxmALd24J+KpGWmYEB7YgFsXrEqsnIXv
         s1NN/arRGtCtA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        gregkh@linuxfoundation.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] staging: use of_get_ethdev_address()
Date:   Tue, 26 Oct 2021 10:50:38 -0700
Message-Id: <20211026175038.3197397-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new of_get_ethdev_address() helper for the cases
where dev->dev_addr is passed in directly as the destination.

  @@
  expression dev, np;
  @@
  - of_get_mac_address(np, dev->dev_addr)
  + of_get_ethdev_address(np, dev)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Hi Greg, this needs to go to net-next, the helper is new.
---
 drivers/staging/octeon/ethernet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index bf8c5443a218..f662739137b5 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -409,7 +409,7 @@ int cvm_oct_common_init(struct net_device *dev)
 	struct octeon_ethernet *priv = netdev_priv(dev);
 	int ret;
 
-	ret = of_get_mac_address(priv->of_node, dev->dev_addr);
+	ret = of_get_ethdev_address(priv->of_node, dev);
 	if (ret)
 		eth_hw_addr_random(dev);
 
-- 
2.31.1

