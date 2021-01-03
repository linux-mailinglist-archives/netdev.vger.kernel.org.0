Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114B02E8E76
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbhACVhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:37:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbhACVhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:37:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6161B2078D;
        Sun,  3 Jan 2021 21:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709832;
        bh=cPFobVnyBxf2yC8kLS4j/2ZwleDDSVRsDiNdqpQzXw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chBLVJeOYjkPZiQuR0khSIo19JAQSB0yxrdVAS2K+SzzIFWiBWdyrLFmMBWD+htB7
         f1ADN/z0j6pom7vZm7C/6W2IsBTb4lZSjlV3zjBNOnVZEt2xzHT4YNcUQxD5MLdKSw
         jm5BBZ1TvZl7PMpzcIBEjRJmtUgjeXp49diMdK/I7hbtVHnTqZ/QJEerhGh9CxNTY1
         koLAI3TAoqhLIsGrWwFOE0pWisX+6FHLr/hXsiGqtJz1wwQOTTh1d+b0esIwrhRwqH
         A9XYkVzaRWmaGBEpYPU1VnucEM3dw4G2ux8e0d01dh/3j+AvO4B312jsbJR+T32uNi
         NTJwx2pEwKw0A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
        <stefan.sorensen@spectralink.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] phy: dp83640: select CONFIG_CRC32
Date:   Sun,  3 Jan 2021 22:36:18 +0100
Message-Id: <20210103213645.1994783-2-arnd@kernel.org>
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

arm-linux-gnueabi-ld: drivers/net/phy/dp83640.o: in function `match':
dp83640.c:(.text+0x476c): undefined reference to `crc32_le'

Fixes: 539e44d26855 ("dp83640: Include hash in timestamp/packet matching")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/ptp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 476d7c7fe70a..d2bf05ccbbe2 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -64,6 +64,7 @@ config DP83640_PHY
 	depends on NETWORK_PHY_TIMESTAMPING
 	depends on PHYLIB
 	depends on PTP_1588_CLOCK
+	select CRC32
 	help
 	  Supports the DP83640 PHYTER with IEEE 1588 features.
 
-- 
2.29.2

