Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAF43251A4
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhBYOku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232557AbhBYOkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:40:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 350D164F0C;
        Thu, 25 Feb 2021 14:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614264001;
        bh=dz3Sbgg/xpmcniXZjEqhsxwzzTzHt6BhgNO7KsulOfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJ24KEJDU2rGKJpM8gePQBoRP7Mv8Pe3VKYaNyt9rbqNM9nvLrMQlB6FkIW8tmFCA
         MXM1hp2x/81XTPWOy2AZA14qDMm3dZQZOYom0Rpep446fX7x766fsbPbCFqvf0e2jn
         XZNx5t5HoFWnhGpJp14Oez0+LA498NAPkQn4Z6PiMztxj61Dy4qtCVbCCZYKPCc86K
         cs75pzgmRfK724Uiy7et45+RYn6/cbpmJssTP0yQgXOCNENvCxSX2ZtTcy1D0fM3WI
         q46BSHHkgSnKzhnNJLyDR06UcuDb5fUyc3hGaRWoAOrwbQYy+6Us7PS/0JacJHqfwe
         8rwMo31ByPxuQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: dsa: mt7530: add GPIOLIB dependency
Date:   Thu, 25 Feb 2021 15:38:33 +0100
Message-Id: <20210225143910.3964364-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225143910.3964364-1-arnd@kernel.org>
References: <20210225143910.3964364-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The new gpio support may be optional at runtime, but it requires
building against gpiolib:

ERROR: modpost: "gpiochip_get_data" [drivers/net/dsa/mt7530.ko] undefined!
ERROR: modpost: "devm_gpiochip_add_data_with_key" [drivers/net/dsa/mt7530.ko] undefined!

Add a Kconfig dependency to enforce this.

Fixes: 429a0edeefd8 ("net: dsa: mt7530: MT7530 optional GPIO support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 3af373e90806..07fc2a732597 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -37,6 +37,7 @@ config NET_DSA_LANTIQ_GSWIP
 config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	depends on NET_DSA
+	depends on GPIOLIB
 	select NET_DSA_TAG_MTK
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
-- 
2.29.2

