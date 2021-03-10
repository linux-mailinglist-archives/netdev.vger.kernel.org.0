Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C47333788
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhCJIj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:39:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41206 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhCJIiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:38:54 -0500
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lJuMm-0003k6-UR
        for netdev@vger.kernel.org; Wed, 10 Mar 2021 08:38:53 +0000
Received: by mail-wr1-f69.google.com with SMTP id g2so7654907wrx.20
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 00:38:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWUlJm1h/cD+o2JnnbxCTfx8shPW082WTgFnXFEhHuE=;
        b=XDODwNIjmYcVjGEcAZoeo3FAlQXqx0KjGEb3W9Da6O61z58SBuoaKPZPrjBFSkzZ4H
         SzdQtupefvfvjPTz+Z0LxNJhWssLKhi2SP/FHD0Sb+rdjCLSiRB26ZUOA6BVcRSqbSPa
         ivhiSI0GgQLbr4aGiIUlDvLpAHGfzUZU13FX9QPkphaoMqDrPMIzsF7FUQoJEv4O6+iP
         W/bDAcA+OcIxxHeBs0WVZcVJ71kc5Zqi+zr08ucetPCtNvAzSsD9RUkIIXKHWzL4zosR
         N8VIUEQKKdbyMcVTE8r5PNRUXlPETcwgi0bH54xIO5TJKjw8nYm/rce4TR7ITzCceOn5
         bsDg==
X-Gm-Message-State: AOAM530iYfADffXJWKZaXw+eJ0DnjEODulZd6Ehcc1d8FIdpZxnWIh6n
        isNghKcYQUoSojKpB16hd6tsEdoGmiifrMEOmHP2xqL7KNT8zWQ3wzdb0odBGwapacVkZq7gQpm
        xwT6ZjHJ+YAfgrTPdFbyR0UC5orWCUDhhcg==
X-Received: by 2002:a05:6000:191:: with SMTP id p17mr2331472wrx.154.1615365532717;
        Wed, 10 Mar 2021 00:38:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyownReKaTZMWbHVmMbUowjv9w6MYTu6DR7rPD+40lY/aAL94Jldh5Hc3FANVrWuTp5YYmT+A==
X-Received: by 2002:a05:6000:191:: with SMTP id p17mr2331462wrx.154.1615365532595;
        Wed, 10 Mar 2021 00:38:52 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id u20sm32781061wru.6.2021.03.10.00.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:38:51 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        arm@kernel.org, soc@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [RFC v2 5/5] clk: socfpga: allow compile testing of Stratix 10 / Agilex clocks
Date:   Wed, 10 Mar 2021 09:38:39 +0100
Message-Id: <20210310083840.481615-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Stratix 10 / Agilex / N5X clocks do not use anything other than OF
or COMMON_CLK so they should be compile testable on most of the
platforms.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/clk/Makefile        |  5 +----
 drivers/clk/socfpga/Kconfig | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index e34457539edf..9b582b3fca34 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -104,10 +104,7 @@ obj-y					+= renesas/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
 obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_CLK_SIFIVE)		+= sifive/
-obj-$(CONFIG_ARCH_SOCFPGA)		+= socfpga/
-obj-$(CONFIG_ARCH_AGILEX)		+= socfpga/
-obj-$(CONFIG_ARCH_N5X)			+= socfpga/
-obj-$(CONFIG_ARCH_SOCFPGA64)		+= socfpga/
+obj-y					+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)		+= spear/
 obj-y					+= sprd/
 obj-$(CONFIG_ARCH_STI)			+= st/
diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
index 834797c68cb2..fb93b7cede27 100644
--- a/drivers/clk/socfpga/Kconfig
+++ b/drivers/clk/socfpga/Kconfig
@@ -1,6 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
+config COMMON_CLK_SOCFPGA
+	bool "Intel SoCFPGA family clock support" if COMPILE_TEST && !ARCH_SOCFPGA && !ARCH_SOCFPGA64
+	depends on ARCH_SOCFPGA || ARCH_SOCFPGA64 || COMPILE_TEST
+	default y if ARCH_SOCFPGA || ARCH_SOCFPGA64
+	help
+	  Support for the clock controllers present on Intel SoCFPGA and eASIC
+	  devices like Stratix 10, Agilex and N5X eASIC.
+
+if COMMON_CLK_SOCFPGA
+
 config COMMON_CLK_SOCFPGA64
-	bool
-	# Intel Stratix / Agilex / N5X clock controller support
+	bool "Intel Stratix / Agilex / N5X clock controller support" if COMPILE_TEST && !ARCH_SOCFPGA64
 	default y if ARCH_SOCFPGA64
-	depends on ARCH_SOCFPGA64
+	depends on ARCH_SOCFPGA64 || COMPILE_TEST
+
+endif # COMMON_CLK_SOCFPGA
-- 
2.25.1

