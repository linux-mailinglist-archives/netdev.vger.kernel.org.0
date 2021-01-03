Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4AA2E8E77
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbhACViQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbhACViQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:38:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D533520780;
        Sun,  3 Jan 2021 21:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709855;
        bh=khXj97CoKJW2rMMdFS64ynxksQ+AMhuqjtWxv1oXc3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWPRdrxpFUFamAglhnkHxT02k/bqev2QTgqt14Lv5m8Y8ISf7XdfasnTwX6c1Un4E
         KKAODarwjdjm02KW3GWF6HHcPTkK3ILxvezsttaZ7fHbP6IPh8r2uIz7EdU9qBJFpD
         a/uf4DrXjk0n5LuD6VL4+nvEzk/x8l+fJ2ONR6VcvrFOXF/281oPLSutaMki2E8r4c
         aT4le59uph2seUFTOf2CcLnmodHGZ1eFTX8Io6qGvPtlEy3eibXT6M48X/5mFAYfMC
         X7WjMJimHb1hEFHVhVV/vu6Mhb9HsYKuPzO2OkRXvIfC40uHX53GzhmCXQA/QUEYrF
         Fvt3RIcEiangA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Henning Colliander <henning.colliander@evidente.se>,
        Christer Beskow <chbe@kvaser.com>,
        Jimmy Assarsson <extja@kvaser.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] can: kvaser_pciefd: select CONFIG_CRC32
Date:   Sun,  3 Jan 2021 22:36:19 +0100
Message-Id: <20210103213645.1994783-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103213645.1994783-1-arnd@kernel.org>
References: <20210103213645.1994783-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without crc32, this driver fails to link:

arm-linux-gnueabi-ld: drivers/net/can/kvaser_pciefd.o: in function `kvaser_pciefd_probe':
kvaser_pciefd.c:(.text+0x2b0): undefined reference to `crc32_be'

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/can/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 424970939fd4..1c28eade6bec 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -123,6 +123,7 @@ config CAN_JANZ_ICAN3
 config CAN_KVASER_PCIEFD
 	depends on PCI
 	tristate "Kvaser PCIe FD cards"
+	select CRC32
 	  help
 	  This is a driver for the Kvaser PCI Express CAN FD family.
 
-- 
2.29.2

