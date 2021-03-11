Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4BB3377A2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhCKP2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:28:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34281 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbhCKP1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 10:27:45 -0500
Received: from mail-ej1-f69.google.com ([209.85.218.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lKNDz-0005gR-Kn
        for netdev@vger.kernel.org; Thu, 11 Mar 2021 15:27:43 +0000
Received: by mail-ej1-f69.google.com with SMTP id 11so8805679ejz.20
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 07:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RBN1O3Wcnz1uvA/bXXgFQO/02vpYiyGG/6WCSqIa6KY=;
        b=hKyaW5tlxjFVz3qRxTses3burc/6vWa+e1AakqRn9x6/J6VIEXsYNDkxxS50D+xZ7q
         DoD7fZnla+qVnbd65x+gSK+PZNCz2EIuh4v0hCvEy2oIsZjG4S3Sh8vPPyLpELdsK6WL
         KuFuFG/TPLMFxj82bC8zrYdjTxcCRFUWr6zGtJhzZUXGphvIctfu60ArEGNKi0HdZzQz
         9jbRfpKgvrs2OAfzfWOoMXbC2AAWEy0IIRM4vCQZppKfi6X68tVdqsFEoUHfPClNP5YY
         67kphHdikDi45mz2huFg5SUO9i3jqTFyNa1+CxAiVcmjDPvo9K/KQGTiFtu5WKpbHEeM
         sTyg==
X-Gm-Message-State: AOAM531CZZMavyCsnIfGf+9Ac3ER2WxwZ/y+jcAyOieYEdCnE8P1Q3BG
        VA0efwl3IQ2LUjw/04ATq8ARf83LEpmay4inXTU3CkTomRolhzxhK7ykwZfaeoRkHL9O+fPbF64
        +BTPfJIm+vky1IRbmgNFyA1C+PHpUh/aLzg==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr9145602edd.103.1615476463285;
        Thu, 11 Mar 2021 07:27:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzftQgQhm6JCnX7NkcREdfHxQ79cH5j2A8F4fhogge3Hb8YjiFCimex/EvBlWPVnkSsMSMXPQ==
X-Received: by 2002:a05:6402:510b:: with SMTP id m11mr9145573edd.103.1615476463167;
        Thu, 11 Mar 2021 07:27:43 -0800 (PST)
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.gmail.com with ESMTPSA id k9sm1567062edn.68.2021.03.11.07.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 07:27:42 -0800 (PST)
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
Subject: [PATCH v3 14/15] reset: socfpga: use ARCH_INTEL_SOCFPGA also for 32-bit ARM SoCs
Date:   Thu, 11 Mar 2021 16:27:41 +0100
Message-Id: <20210311152741.1318599-1-krzysztof.kozlowski@canonical.com>
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

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/reset/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index b1e8efa16166..7043c7f6dcf0 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -205,8 +205,8 @@ config RESET_STM32MP157
 	  This enables the RCC reset controller driver for STM32 MPUs.
 
 config RESET_SOCFPGA
-	bool "SoCFPGA Reset Driver" if COMPILE_TEST && !ARCH_SOCFPGA
-	default ARCH_SOCFPGA
+	bool "SoCFPGA Reset Driver" if COMPILE_TEST && (!ARM || !ARCH_INTEL_SOCFPGA)
+	default ARM && ARCH_INTEL_SOCFPGA
 	select RESET_SIMPLE
 	help
 	  This enables the reset driver for the SoCFPGA ARMv7 platforms. This
-- 
2.25.1

