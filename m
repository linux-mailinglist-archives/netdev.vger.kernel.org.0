Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8313DC91D
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhHAAcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 20:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhHAAcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 20:32:06 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFEFC0613CF
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:31:58 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id b21so18650364ljo.13
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XwiTSMLrZkuBiZd1olOJbf+y/nxUHybnrS+ax6rMLQ8=;
        b=oRa3h4HPdjP65j0kac0hidY3TLnoa3mWCeo5je5tvFSe1r8pNv0yZGO1aSJKgDzlCK
         YUGKt+Gl6lz8LaAM5BmvKwxKpZHB3uoguS926MseTUy9WdSsvVLR93a4EgSuTsAyflqC
         mthk/YyCXFN13ZcP/qQObOX00to2+zITu0dXq4vtcdc+hFGuVkSNqNiLT1g3jtUEa6o7
         hVPMxKugWu4d1pgokA5Ka1JDaDBxyx33YaK4YLmB0GQZeQZodolUvrj0dvjCkKykSvX1
         qmHXKvRFu5WfWxb0uzdvTa9mJhIf/HmVCbnb2TTti39nUs4NgkB53gIgIioIhI5aLet5
         aSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XwiTSMLrZkuBiZd1olOJbf+y/nxUHybnrS+ax6rMLQ8=;
        b=CAv5M7vUJ41RPDhYYJNW6YYdwvyqH2BwwePhKK3WTPfFYjStOjc6ATRes3pecrs2lY
         6/4x/Wb0WvQ9MaV8UzpDVwCml8tEp+MTR360UkIoVbHsLkg3VVIDeuicjaRr6xQPf6D1
         jRrFmeexZVvC2jrR8Vo6Pl0LxX7sboaVE70gA/omazzIibYlLuHB0qJBTKrpIpmqPMgi
         SHMvpuV+dR70UParI1mZgFj0NNCC7m+pNLCuQ6B7R0DZxOVN9yHhZNOox8G1w13r99lc
         /JkSh39MmoHd8R1J3OItT1n9+LZR/cY/u/UlBeN65yL3egeQS17khSZVL70QaCmgdz3u
         0gqg==
X-Gm-Message-State: AOAM530c9/GjvNFyAlYF3V4kDcNqihZKhPT8xHDK1bD+4d5r5DgHcM9D
        3FNaGOs9VsacvEvfciwSaBT0ygTubui63g==
X-Google-Smtp-Source: ABdhPJzuiNtFIqIXATW1l0S2/idvpkRnUuVVb1S582zq3/LtPmXMTzs8QRqwYS0q4NhuBv49YNFOvA==
X-Received: by 2002:a2e:a555:: with SMTP id e21mr6924730ljn.238.1627777916941;
        Sat, 31 Jul 2021 17:31:56 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r6sm485255ljk.76.2021.07.31.17.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 17:31:56 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 3/6] ixp4xx_eth: enable compile testing
Date:   Sun,  1 Aug 2021 02:27:34 +0200
Message-Id: <20210801002737.3038741-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210801002737.3038741-1-linus.walleij@linaro.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver is now independent of machine specific header
files and should build on all architectures, so enable
building with CONFIG_COMPILE_TEST.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 0e878fa6e322..b93e88422a13 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -6,8 +6,8 @@
 config NET_VENDOR_XSCALE
 	bool "Intel XScale IXP devices"
 	default y
-	depends on NET_VENDOR_INTEL && (ARM && ARCH_IXP4XX && \
-		   IXP4XX_NPE && IXP4XX_QMGR)
+	depends on NET_VENDOR_INTEL && IXP4XX_NPE && IXP4XX_QMGR
+	depends on ARCH_IXP4XX || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -20,7 +20,8 @@ if NET_VENDOR_XSCALE
 
 config IXP4XX_ETH
 	tristate "Intel IXP4xx Ethernet support"
-	depends on ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR
+	depends on IXP4XX_NPE && IXP4XX_QMGR
+	depends on ARCH_IXP4XX || COMPILE_TEST
 	select PHYLIB
 	select OF_MDIO if OF
 	select NET_PTP_CLASSIFY
-- 
2.31.1

