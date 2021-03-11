Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC2337796
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhCKP2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:28:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34199 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhCKP1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:27:31 -0500
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKNDm-0005Z5-IV
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 15:27:30 +0000
Received: by mail-wr1-f72.google.com with SMTP id v13so9679001wrs.21
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:27:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/3UhGLxhWacdcsSpVsIOhi7iq++tfBdPJwQmfZFh1zw=;
        b=UFOZCmQvyTYogkQe0MTon27B8yPqQOVV+TRPQ/ikBCXAsqIbc/vwa8tMwzxB15lm9M
         jqUOZs+CSmzGgiGTesu4NiSbbSmZ25MzujSriIvwJDIHmlmQ96HfhB1mKK0IAtYfuM6S
         0LO4JcAzJhmkgejDghcLfNxZCEtQcrX1PevqgL/GgpV4agxSRRFN2UQXqI4Lf837Z2cz
         F9J2buC30kezQkGFMua7gxNo7xJeAJE1yieD5t2IwhwB6tpy1V7zWUTRKCfINnmpOyXx
         4kR/CHSc1uXLujHHMZj6NeAUzm7B/T5kRkVjxMk3JSeaaTJLhEjuGbp5JR9Bf7uQwH9s
         m1Og==
X-Gm-Message-State: AOAM533YrQkeddp0xhY50N9sYsH6ex8tF6NCCCcDaOCeLKcrSVy09LjY
        XYbaQ+tgsSd0CFdgELpfAgua8i35rFTf9Rbwj6lVcd+/8I1SoAoorKzX+AudhWNUrkmZ2tERenH
        Rzjsey6tyuUSAA3bPaIwYz0rLpsXHWGfpkw==
X-Received: by 2002:a05:6402:1103:: with SMTP id u3mr8916746edv.205.1615476439289;
        Thu, 11 Mar 2021 07:27:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykFYMegR7g3sofzBC+1YkJVaDapoNS+bRGUtFV8/I7aVJB5VDHjlbA8PWaxRhm9KLVG244sg==
X-Received: by 2002:a05:6402:1103:: with SMTP id u3mr8916710edv.205.1615476439104;
        Thu, 11 Mar 2021 07:27:19 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id yk8sm1445697ejb.123.2021.03.11.07.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:27:18 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH v3 10/15] clk: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs (and compile test)
Date:   Thu, 11 Mar 2021 16:27:15 +0100
Message-Id: <20210311152715.1317848-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARCH_SOCFPGA is being renamed to ARCH_INTEL_SOCFPGA so adjust the
32-bit ARM drivers to rely on new symbol.

There is little point to share clock controller drivers between 32-bit
and 64-bit platforms because there will not be a generic image for both
of them.  Therefore add a new Kconfig entry for building 32-bit clock
driverss, similar to one for 64-bit.  This allows enabling compile
testing.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/clk/socfpga/Kconfig  | 6 +++++-
 drivers/clk/socfpga/Makefile | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
index b62ede8cad01..0cf16b894efb 100644
--- a/drivers/clk/socfpga/Kconfig
+++ b/drivers/clk/socfpga/Kconfig
@@ -4,10 +4,14 @@ config CLK_INTEL_SOCFPGA
 	default ARCH_INTEL_SOCFPGA
 	help
 	  Support for the clock controllers present on Intel SoCFPGA and eASIC
-	  devices like Stratix 10, Agilex and N5X eASIC.
+	  devices like Aria, Cyclone, Stratix 10, Agilex and N5X eASIC.
 
 if CLK_INTEL_SOCFPGA
 
+config CLK_INTEL_SOCFPGA32
+	bool "Intel Aria / Cyclone clock controller support" if COMPILE_TEST && (!ARM || !ARCH_INTEL_SOCFPGA)
+	default ARM && ARCH_INTEL_SOCFPGA
+
 config CLK_INTEL_SOCFPGA64
 	bool "Intel Stratix / Agilex / N5X clock controller support" if COMPILE_TEST && (!ARM64 || !ARCH_INTEL_SOCFPGA)
 	default ARM64 && ARCH_INTEL_SOCFPGA
diff --git a/drivers/clk/socfpga/Makefile b/drivers/clk/socfpga/Makefile
index ebd3538d12de..e8dfce339c91 100644
--- a/drivers/clk/socfpga/Makefile
+++ b/drivers/clk/socfpga/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_ARCH_SOCFPGA) += clk.o clk-gate.o clk-pll.o clk-periph.o
-obj-$(CONFIG_ARCH_SOCFPGA) += clk-pll-a10.o clk-periph-a10.o clk-gate-a10.o
+obj-$(CONFIG_CLK_INTEL_SOCFPGA32) += clk.o clk-gate.o clk-pll.o clk-periph.o \
+				     clk-pll-a10.o clk-periph-a10.o clk-gate-a10.o
 obj-$(CONFIG_CLK_INTEL_SOCFPGA64) += clk-s10.o \
 				     clk-pll-s10.o clk-periph-s10.o clk-gate-s10.o \
 				     clk-agilex.o
-- 
2.25.1

