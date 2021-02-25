Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273E43251A0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhBYOkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBYOj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:39:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1879364EC3;
        Thu, 25 Feb 2021 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614263956;
        bh=Qq8jqEoh+azun2jK73XZzJMU37OcfRZrN7R9i+zYwUo=;
        h=From:To:Cc:Subject:Date:From;
        b=h3HE6oYtJcCq9fIpq9tXgUMqk+xtwGeeqeTOgd3IknWR9r1tzBOqxNbQRqF0xPYZk
         3qN2f91McxFiBFDmuoHD34MylKmKZnMJdZO7WO8rFLng53j3722BRJSj6OMAqxSh6x
         KDWeEpfNL7TkuPjewwrYmpfC+Y2D9xT0iCFoO53FNFtpCJRIWC6X8Mc3fffAO5ixVV
         8NDKnia+T5/X1MxPaX/Wo6P1L2qrXsqUzhCbF/I/g8pH82O/fl6FLJ7GHlmCc3tAPZ
         QiyXC2ccdVo8TyB3tET4f8QAIWGiLXS+LR/rpwyhlnohG3XL5nTPXSKpMcBiwcwiMC
         6WzSp/oySZJTw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: mscc: ocelot: select NET_DEVLINK
Date:   Thu, 25 Feb 2021 15:38:31 +0100
Message-Id: <20210225143910.3964364-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without this option, the driver fails to link:

ld.lld: error: undefined symbol: devlink_sb_register
>>> referenced by ocelot_devlink.c
>>>               net/ethernet/mscc/ocelot_devlink.o:(ocelot_devlink_sb_register) in archive drivers/built-in.a
>>> referenced by ocelot_devlink.c
>>>               net/ethernet/mscc/ocelot_devlink.o:(ocelot_devlink_sb_register) in archive drivers/built-in.a

Fixes: f59fd9cab730 ("net: mscc: ocelot: configure watermarks using devlink-sb")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mscc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index c0ede0ca7115..05cb040c2677 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -13,6 +13,7 @@ if NET_VENDOR_MICROSEMI
 
 # Users should depend on NET_SWITCHDEV, HAS_IOMEM
 config MSCC_OCELOT_SWITCH_LIB
+	select NET_DEVLINK
 	select REGMAP_MMIO
 	select PACKING
 	select PHYLIB
-- 
2.29.2

