Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3442B472B3D
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 12:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhLMLXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 06:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhLMLXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 06:23:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B698C06173F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 03:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88426CE1006
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 11:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21961C34601;
        Mon, 13 Dec 2021 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639394619;
        bh=Z/A3/kQ7UdejO+GL93876n7BCkFlCa7BwWjj41yTJQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=GJxsondHP4hiIhK56DiaKGh6IRJLnsRW+AUIkRebtXQkecxtg6WS5B5oeU8U1LKp2
         AIO9l6FXRPKZj7pxvLsJB2tlAuKnKvlUwrPHl07L7bGwQmt67xRATZq1PpQmRNUV9g
         wgfNZ/JjK3g2XmEXVQeXTA9VEgg3MvilvuLxFb4hqGuf0ovxzCn6xXD0R8igWtH9jW
         kvfOzcZp9vUk4erJCrQE8I2VgrMQAxon6qseVflYnNW3rl8tkyS6cP1d2AWKXZfUUW
         QJfkr02z7J6S8qHcTo+uBYnGdhvXGd2jlIwum7JUChnc0wfhJtXhK9NRVfiDJ6chaj
         7g7mIw5Vl6V8Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, mark-mc.Lee@mediatek.com
Subject: [PATCH net-next] net: mtk_eth: add COMPILE_TEST support
Date:   Mon, 13 Dec 2021 12:23:22 +0100
Message-Id: <208b18f9e48e1ebddaee4baf28721bd3f9715046.1639394268.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the build testing of mtk_eth drivers by enabling them when
COMPILE_TEST is selected. Moreover COMPILE_TEST will be useful
for the driver development.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index c357c193378e..86d356b4388d 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_VENDOR_MEDIATEK
 	bool "MediaTek devices"
-	depends on ARCH_MEDIATEK || SOC_MT7621 || SOC_MT7620
+	depends on ARCH_MEDIATEK || SOC_MT7621 || SOC_MT7620 || COMPILE_TEST
 	help
 	  If you have a Mediatek SoC with ethernet, say Y.
 
@@ -10,6 +10,7 @@ if NET_VENDOR_MEDIATEK
 config NET_MEDIATEK_SOC
 	tristate "MediaTek SoC Gigabit Ethernet support"
 	depends on NET_DSA || !NET_DSA
+	select PINCTRL
 	select PHYLINK
 	select DIMLIB
 	help
-- 
2.33.1

