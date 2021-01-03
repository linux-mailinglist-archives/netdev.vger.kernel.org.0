Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB412E8E7B
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbhACVjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbhACVjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:39:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F6F8206A1;
        Sun,  3 Jan 2021 21:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709902;
        bh=HlL13LUuAgV0qw5iXRVni4ysniXjQjYwFLmwaw+H6js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJV6eLasBvzgTzh5kczpRwHYEKwHxaObJxYBufP64Tb7DU6Gi5WvVDVmoIyM9g6z7
         Tjwz7TZGIK4dEhCbGoZ2Ef01N76VvCHvduTEiWLCqm/DyLrloG0oaHNL+jLKsDd8/w
         UupbxL1HV1xEVUxqQZBbD9RZiod4WUMZe1vYGJY9nzLz5NPrD4WgjEWdRnxJr6A/hb
         QlArS4hwwi77q5PsRhDkqlwX4tLDNnlsKGLYMNEq7itJGJKxdUEo67Qsz2GRLWnGRc
         r39KlD94YPw97gE8W31YRXFf7gP/4mdXkBOvC95IYkwi2AXqPElhRplrX7cUWbBbdJ
         hCqMFRAqn305w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] wil6210: select CONFIG_CRC32
Date:   Sun,  3 Jan 2021 22:36:20 +0100
Message-Id: <20210103213645.1994783-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103213645.1994783-1-arnd@kernel.org>
References: <20210103213645.1994783-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without crc32, the driver fails to link:

arm-linux-gnueabi-ld: drivers/net/wireless/ath/wil6210/fw.o: in function `wil_fw_verify':
fw.c:(.text+0x74c): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/wireless/ath/wil6210/fw.o:fw.c:(.text+0x758): more undefined references to `crc32_le' follow

Fixes: 151a9706503f ("wil6210: firmware download")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/wil6210/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index 6a95b199bf62..f074e9c31aa2 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -2,6 +2,7 @@
 config WIL6210
 	tristate "Wilocity 60g WiFi card wil6210 support"
 	select WANT_DEV_COREDUMP
+	select CRC32
 	depends on CFG80211
 	depends on PCI
 	default n
-- 
2.29.2

