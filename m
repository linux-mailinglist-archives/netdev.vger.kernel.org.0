Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D809C3EBE21
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhHMWDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhHMWDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:03:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28643C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:40 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id n6so17664154ljp.9
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XwiTSMLrZkuBiZd1olOJbf+y/nxUHybnrS+ax6rMLQ8=;
        b=FVvLdWHg1BJXQya3T61vQkPb+D2GERvdd8JZMxz0oOcjGxuG7B8q6DABA/wmAVL8EA
         XHdMUW9Rfuan2qILdIGML8DLx41X6krzeT3ZaXheCXRYs38W34bobEO6WBs0QmV7ZVLk
         0F0/i0mMY95mEDREiHlJ5pD/iEYJwMGfVU0uoIpA1m2ZTMjPuiP8/4+nuufCXkdj6d2A
         V2OVXJ1PnWMjAFsF21uPP3mTQ0I6N+fIlLH8lH03Ev1wR8dHUUKYBmuK0ezUcBzy0h1W
         mfiScCHeEGtAScxgB/ohLML1N7InjkVn4zJzcAJ5QWIxG6x5ggouf0NUAByNwm8PE0+m
         B3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XwiTSMLrZkuBiZd1olOJbf+y/nxUHybnrS+ax6rMLQ8=;
        b=FF0xXTyLMt6R3y0AJFILEMlU2rSFXs7WPoj8ljPru2uEggCelvkNl8JJj1BWCvP4OY
         f9+IAIKSnN2rMlCp/vHB3HLSf13ANidP6YG+k3/o0eVzak4TNHNIDb0AgrDPEno8IWTB
         xa2rJB10N/240y/PrcJIj73PwOfFYYGBIN6j8Se8L1dKI0qvLYQpG+lgR2NjHRlyQ6hD
         jYIB32L3XXhmv/vwNu9TKCjmFfA3OFr9/We9Y9vMj3eOnfilXnTNhQ0rZdHjC+DsQumK
         0b6dsVMmVWz77wMpdyU+mp9rWw+ORGKd3hUtMpyJYTasCIYQHqJv+2cQJ9gI6rv1lWQY
         6H9A==
X-Gm-Message-State: AOAM531rDsQL0/naERpa2yK+qTkpT/n9WG9dH+CyXrgGvzhljfVusokl
        D9g3fM5cHT0h/BKUS1dKV/6ilFJYP58JUw==
X-Google-Smtp-Source: ABdhPJxT6ShWhtRJGux7DWv7elPCg1pKVxhyUuhOwF1gRUOMYP43v7JLOp3T1wVP1IdGDnFylu5d6Q==
X-Received: by 2002:a2e:8688:: with SMTP id l8mr3264380lji.157.1628892158399;
        Fri, 13 Aug 2021 15:02:38 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm274912ljp.61.2021.08.13.15.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:02:38 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 3/6 v2] ixp4xx_eth: enable compile testing
Date:   Sat, 14 Aug 2021 00:00:08 +0200
Message-Id: <20210813220011.921211-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813220011.921211-1-linus.walleij@linaro.org>
References: <20210813220011.921211-1-linus.walleij@linaro.org>
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

