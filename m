Return-Path: <netdev+bounces-11393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0334732E86
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F04811C21027
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2175F946D;
	Fri, 16 Jun 2023 10:33:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D821990D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:33:07 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570844234
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:32:46 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5169f614977so705431a12.3
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 03:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686911498; x=1689503498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaBTG2zxwhnxmGeWEEvsgJ1P9b9NURsoufZiPInkKEc=;
        b=h9v9BsnMb8Bf3tOsibIfWu1YRF7sqKDKvcliKPiGOhQm9d+yURo0wcCeqd+DmQDhKt
         HQxtH4w/UDkNR6lgDkzs6RpPodbxsGvG8XQItKw1Mgb2BcNW4BaV6fqdWsS6SGYURdCw
         KCN8VsLvFKkiBuea1lWMUMpFFkdOyzYqJ0nWTvNBytpmZ6IFN9/WVZqW3V68LdJK4/zM
         RguwkU1YaZdt+C9D5w0L27ABoizLpwuHYr8gk4JXNooSpONL5bmv5y86Q1x4G82NSJUm
         ZqBCrP4sRfEIx/ELuTZtkaK3hZr2nWpTGQVO/4ooNGnI5KSbsK7aMWN0NedI3iV46wow
         O08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686911498; x=1689503498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaBTG2zxwhnxmGeWEEvsgJ1P9b9NURsoufZiPInkKEc=;
        b=iL+sPFmcJJojhKtlXmzJzgnL+9kkiYrCvpiUmnrzz0mXay1RMUCcG5V5xGWt63KM5J
         Znx1j6KpH9OLN6BzUiTl7ai9B6omagPxaAwAU8X1sN60z2bqzKKtnEfNH2KwkrAfV0du
         cX9rTw734LZWkUBTW3U/ND77WDQO+iMAaLvqD17t7vqKBS4+/0fkYeob+nUne9BbQzEF
         5/jh0UkjCZRSrYfF4VA8U16p283vNRaswe0MimPjnop4ghUBvilsrtX2evqFNJJaVZ9u
         nIlkwPHgwJ1IYBnMokzWDKu5RB9VMZuAl2qylDyk0eJAqSLuKjGiVEPxOON4SMUJ1Y9B
         L+ew==
X-Gm-Message-State: AC+VfDx4O58+L2SFlbL/t5HZLHDnJU/LsKumZROQ4fJAcEgYARcMjr6f
	yl8WtX6Yt3+GP2ARziErCRJ8jA==
X-Google-Smtp-Source: ACHHUZ46d2PnNLTuBJzAtrPzWBhQyazG0ug3ioL29Qy1uIyi1v1EBT6OTUHZcgKN9qMGn18t6oaADg==
X-Received: by 2002:a17:907:6ea4:b0:978:94b1:25ac with SMTP id sh36-20020a1709076ea400b0097894b125acmr1625268ejc.40.1686911498060;
        Fri, 16 Jun 2023 03:31:38 -0700 (PDT)
Received: from krzk-bin.. ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id s20-20020a170906961400b009829d2e892csm2251098ejx.15.2023.06.16.03.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:31:37 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	devicetree@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RFT PATCH 2/2] MIPS: dts: loongson: drop incorrect dwmac fallback compatible
Date: Fri, 16 Jun 2023 12:31:27 +0200
Message-Id: <20230616103127.285608-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616103127.285608-1-krzysztof.kozlowski@linaro.org>
References: <20230616103127.285608-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Device binds to proper PCI ID (LOONGSON, 0x7a03), already listed in DTS,
so checking for some other compatible does not make sense.  It cannot be
bound to unsupported platform.

Drop useless, incorrect (space in between) and undocumented compatible.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

This patch depends on driver change, thus it should be accepted a
release after the driver is merged.
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 3 +--
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
index 8143a61111e3..c16b521308cb 100644
--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -123,8 +123,7 @@ gmac@3,0 {
 				compatible = "pci0014,7a03.0",
 						   "pci0014,7a03",
 						   "pciclass0c0320",
-						   "pciclass0c03",
-						   "loongson, pci-gmac";
+						   "pciclass0c03";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
 				interrupts = <12 IRQ_TYPE_LEVEL_LOW>,
diff --git a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
index 2f45fce2cdc4..ed99ee316feb 100644
--- a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
+++ b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
@@ -186,8 +186,7 @@ gmac@3,0 {
 				compatible = "pci0014,7a03.0",
 						   "pci0014,7a03",
 						   "pciclass020000",
-						   "pciclass0200",
-						   "loongson, pci-gmac";
+						   "pciclass0200";
 
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
 				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.34.1


