Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDA633775E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbhCKP0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:26:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34022 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbhCKP0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:26:08 -0500
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKNCR-00051w-4a
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 15:26:07 +0000
Received: by mail-ej1-f69.google.com with SMTP id gn30so8761010ejc.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:26:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=seRfZbNnrbt83A3lqfbME46rdPLUXBuaJIJzFEroJqM=;
        b=FJf5pZgadRYPJ2wRY/eRP4WXbxJDaENjOzn0MkZqFENty94wdzrDSsymKrfnnWsKXo
         w5sIJL7wvy9t0fSXCGKuyj4/V6e/jx6zYXBF6Yy6U+U0yKcZ7vadLQg3chs+raNrHmLN
         0wAqdr4PG2rtvYoFQHvurO8R9J9NMqj0ZV20XPQKpGpn9x1PouPguadbTPQ/n79rXA6c
         AwMr2kN7XDN80C6lQCoAKECt1/mGTumwwSKBPN50kKgHIMPQgxcOKPdqib5UqtHTL4D9
         E9qM764CpMuTGzpa727JtoE3bKmrWTeMSQGW7O1oegghbMVVudCeIl1d7W3mIbUy1F82
         vhrg==
X-Gm-Message-State: AOAM532jmSu+H+l1n4FgT2tO1ZrzZuGrLqGhjiSNVu6AXiLb/E7Dxcgo
        NGkA4QvjHbuoElcpozDhnLQIqa8P4AT61j+Y3EdmEB6KSscGuFVkMSLuceZdSx6Q330aKrn0S4R
        p05BdtUDX/v6274Zei9MMxTugJS5l1nIphA==
X-Received: by 2002:a17:906:2c44:: with SMTP id f4mr3504726ejh.508.1615476355784;
        Thu, 11 Mar 2021 07:25:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyyTATyAQcbeENIUwKOgFEFyZfkouzkosm1a5SyTcN6wlVTiKi+ARuyDQUI5aUuLLjUtpz6tg==
X-Received: by 2002:a17:906:2c44:: with SMTP id f4mr3504683ejh.508.1615476355579;
        Thu, 11 Mar 2021 07:25:55 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id v25sm1517826edr.18.2021.03.11.07.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:25:55 -0800 (PST)
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
Subject: [PATCH v3 04/15] net: stmmac: merge ARCH_SOCFPGA and ARCH_STRATIX10
Date:   Thu, 11 Mar 2021 16:25:34 +0100
Message-Id: <20210311152545.1317581-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
References: <20210311152545.1317581-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify 32-bit and 64-bit Intel SoCFPGA Kconfig options by having only
one for both of them.  This the common practice for other platforms.
Additionally, the ARCH_SOCFPGA is too generic as SoCFPGA designs come
from multiple vendors.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index e675ba12fde2..7737e4d0bb9e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -140,8 +140,8 @@ config DWMAC_ROCKCHIP
 
 config DWMAC_SOCFPGA
 	tristate "SOCFPGA dwmac support"
-	default (ARCH_SOCFPGA || ARCH_STRATIX10)
-	depends on OF && (ARCH_SOCFPGA || ARCH_STRATIX10 || COMPILE_TEST)
+	default ARCH_INTEL_SOCFPGA
+	depends on OF && (ARCH_INTEL_SOCFPGA || COMPILE_TEST)
 	select MFD_SYSCON
 	help
 	  Support for ethernet controller on Altera SOCFPGA
-- 
2.25.1

