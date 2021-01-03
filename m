Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3062E8E7E
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbhACVj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbhACVj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:39:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 354FB2078D;
        Sun,  3 Jan 2021 21:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709927;
        bh=nTncnXWTS4UYYvu6MDihO1QdQbWTbMfi56wliMoTwII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIaQfci9xhahasNhtRL7b2qyz6kfKfVnd6Og7qgN3/GXl2NN0UZ5gN0XcxsUH8C1v
         VB9rFsfIMxuwpm6IeoEdhQm3IUNd1VUaHrOFvls5U7WLYwwaJgE1XWraaRqFfy6CPn
         8yJjBR9YsAIO1BnJdyXIA5x6DuOzCaBrSUe5sYaS/e5qoXT19AHab0n9+24GEflA5t
         HEV7sXo3YwopwATYZZjm7CXKKSV54pAUP6XIadkeqWvGcypsvI1/Mutqd6m2HZ/RFq
         2WoODV9b7a6PZfZ9lnG8XRx+oAYUrEADdrW6SHoKXkUv049QuBuSJjyq8WU8RIX0wH
         TcXNMmWuIhMJA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Tova Mussai <tova.mussai@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] cfg80211: select CONFIG_CRC32
Date:   Sun,  3 Jan 2021 22:36:21 +0100
Message-Id: <20210103213645.1994783-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103213645.1994783-1-arnd@kernel.org>
References: <20210103213645.1994783-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without crc32 support, this fails to link:

arm-linux-gnueabi-ld: net/wireless/scan.o: in function `cfg80211_scan_6ghz':
scan.c:(.text+0x928): undefined reference to `crc32_le'

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/wireless/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 27026f587fa6..f620acd2a0f5 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -21,6 +21,7 @@ config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
 	select FW_LOADER
+	select CRC32
 	# may need to update this when certificates are changed and are
 	# using a different algorithm, though right now they shouldn't
 	# (this is here rather than below to allow it to be a module)
-- 
2.29.2

