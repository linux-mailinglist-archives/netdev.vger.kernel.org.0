Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378933777D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhCKP1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:27:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34130 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234405AbhCKP1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:27:15 -0500
Received: from mail-ed1-f70.google.com ([209.85.208.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKNDW-0005R5-Ni
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 15:27:14 +0000
Received: by mail-ed1-f70.google.com with SMTP id r19so9639278edv.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIj5BtBwg8JC7nZHxIeVIntDKYdsgLPXWA5tG6HI5Ss=;
        b=DPrsSldvzECkcOIXPyQOx3qNrDHNJNeEnsgeNgIBxo4VNWFWQkh+chQ/mArF9jMsc3
         RIUHbfxIou19Dj4//P3x60Qd2lXekd8xwdseWQu//mUiMicryBoNsK6RVVd6vz3EqdDY
         4JvEL9EmVv45AvwXgTeQpoTFNEjqEYZpV+Hhss3AJZ8IPR7n17JInNaRn0LtGGbesc8Q
         iilvKXEJ7B77GKbZ2x1+5L9RthMKDzlbKkz0gM9Bx1eqxrs44HXMSFoOViHFzycOw8W5
         KeCmC88bHWE9gOEonA5AZdTfAVx2+iZtJ0KQFJzmtwDFv0naUL5B/wKRSlASfi/69KZc
         aFng==
X-Gm-Message-State: AOAM531daxwNXit3yRNHbroN0xTekuBIj/Wb8XDXDzMe8sIPEEynlMCD
        /1voqzgcWEOexv5QrOCb62K7I0dYnMyy3cGXRDUvypIyMHGugBsBOiUEPWIt1TzOx4NKKJRXvO/
        bNZaXQr8T4ZTPre5TBvU4a5LqDPTomHIzKQ==
X-Received: by 2002:a17:906:4150:: with SMTP id l16mr3692156ejk.90.1615476432202;
        Thu, 11 Mar 2021 07:27:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJ7WD9YIospDnRGiimdfWoLZHOrOz423wxHgF5hcMLCaCtoxrFxNCxImfeln4ju9bNe30G5A==
X-Received: by 2002:a17:906:4150:: with SMTP id l16mr3692120ejk.90.1615476431970;
        Thu, 11 Mar 2021 07:27:11 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id y12sm1473148ejb.104.2021.03.11.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:27:11 -0800 (PST)
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
Subject: [PATCH v3 09/15] clk: socfpga: allow compile testing of Stratix 10 / Agilex clocks
Date:   Thu, 11 Mar 2021 16:27:07 +0100
Message-Id: <20210311152707.1317791-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
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
 drivers/clk/Makefile        |  2 +-
 drivers/clk/socfpga/Kconfig | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 96802294d35a..9b582b3fca34 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -104,7 +104,7 @@ obj-y					+= renesas/
 obj-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip/
 obj-$(CONFIG_COMMON_CLK_SAMSUNG)	+= samsung/
 obj-$(CONFIG_CLK_SIFIVE)		+= sifive/
-obj-$(CONFIG_ARCH_INTEL_SOCFPGA)	+= socfpga/
+obj-y					+= socfpga/
 obj-$(CONFIG_PLAT_SPEAR)		+= spear/
 obj-y					+= sprd/
 obj-$(CONFIG_ARCH_STI)			+= st/
diff --git a/drivers/clk/socfpga/Kconfig b/drivers/clk/socfpga/Kconfig
index b6c5b9737174..b62ede8cad01 100644
--- a/drivers/clk/socfpga/Kconfig
+++ b/drivers/clk/socfpga/Kconfig
@@ -1,6 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0
+config CLK_INTEL_SOCFPGA
+	bool "Intel SoCFPGA family clock support" if COMPILE_TEST && !ARCH_INTEL_SOCFPGA
+	default ARCH_INTEL_SOCFPGA
+	help
+	  Support for the clock controllers present on Intel SoCFPGA and eASIC
+	  devices like Stratix 10, Agilex and N5X eASIC.
+
+if CLK_INTEL_SOCFPGA
+
 config CLK_INTEL_SOCFPGA64
-	bool
-	# Intel Stratix / Agilex / N5X clock controller support
+	bool "Intel Stratix / Agilex / N5X clock controller support" if COMPILE_TEST && (!ARM64 || !ARCH_INTEL_SOCFPGA)
 	default ARM64 && ARCH_INTEL_SOCFPGA
-	depends on ARM64 && ARCH_INTEL_SOCFPGA
+
+endif # CLK_INTEL_SOCFPGA
-- 
2.25.1

