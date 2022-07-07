Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0143A569C13
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiGGHsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiGGHsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:30 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA2655B7;
        Thu,  7 Jul 2022 00:48:28 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m6-20020a05600c3b0600b003a0489f412cso478899wms.1;
        Thu, 07 Jul 2022 00:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4NIkOiNcygsNIrF/pyEHDspUdUt7dpZ9CM2vTRfSAbQ=;
        b=dLMK60dvjcHyh9HyrCfa2Guijrm/7jGoI7iccHPjJCmhyGTNJfDKYVvKtihBTU8EVO
         Q0Jibmd3sXJh0FdMqUmjA5EIXpW7+p/9DRDyEQDiN8BxNztRHmvXmHb//B6PNDj4fSas
         EyvhG9oEO6Wu/bSEkQ0l83Yv5wMclZcKXJHPeRg9phUq9g8KeOZYoWE0x2A5EsMbwU1c
         oK0qjlOTuSsuanVCtDcgOVCpi++P+seE5d3cC8iut8MmWeXReX4bjKYhLo9+CBH/5LXm
         6NKoE5H9aH5XlPm7nWPJ5OHjczp6r2v17AXxakV3vGgo1JLht943mpzEGNjMLjf7qLbS
         fpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4NIkOiNcygsNIrF/pyEHDspUdUt7dpZ9CM2vTRfSAbQ=;
        b=JughoW6vwhESmBJ+4xDYIDU2xhtHl66X2iGxQobh6iXASRCe/JvvSZGEk1LzUam3M9
         FP+n6uthEQUpv42R2/rv8Ep+GKdEYQYsadzpmG/L+uFfYA6/Pt/+gRBAeF9Qbfz/wpNf
         BAz+ATkJNgbysGZkEszzFH0XdcfMragOWtzhIu2bJpRUlCy9+eOHa/NClExb++gbqv6m
         NPfUMmea0cOmY+GICwKHEcNBDXaKo58Vketpxvfu3Y/D4RClW/qC+OcXY7M99V3IXvpe
         AO/ovHGVOCPuwIeL4Bz1phwrT/D+o2LFfkrWWC3cqYgLaDXbvWDHaWme3fZg1t/WTYpb
         v2bg==
X-Gm-Message-State: AJIora8Y9YmOJmH3H439oFXTaNWx6xBswLW3IZ2W2l1nhDXR9RaKQ1BT
        p/Kjpi3+TMU8qn5td1EMo30=
X-Google-Smtp-Source: AGRyM1uhtdRQ+r4IHNVsWwDSYNbKSIMbPcT+PRLqMYA9WCY5uGoZzLPbemQWeCvxSD1Cl4TyZhbJeg==
X-Received: by 2002:a05:600c:4e90:b0:3a0:57d6:4458 with SMTP id f16-20020a05600c4e9000b003a057d64458mr2921012wmq.198.1657180106883;
        Thu, 07 Jul 2022 00:48:26 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id e29-20020a5d595d000000b0021bc663ed67sm32555416wri.56.2022.07.07.00.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:26 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v4 4/9] memory: tegra: Add MGBE memory clients for Tegra234
Date:   Thu,  7 Jul 2022 09:48:13 +0200
Message-Id: <20220707074818.1481776-5-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707074818.1481776-1-thierry.reding@gmail.com>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The NVIDIA Tegra234 SoC has multiple network interfaces with each their
own memory clients and stream IDs to allow for proper isolation.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/memory/tegra/tegra234.c | 80 +++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/memory/tegra/tegra234.c b/drivers/memory/tegra/tegra234.c
index e23ebd421f17..a9e8fd99730f 100644
--- a/drivers/memory/tegra/tegra234.c
+++ b/drivers/memory/tegra/tegra234.c
@@ -11,6 +11,76 @@
 
 static const struct tegra_mc_client tegra234_mc_clients[] = {
 	{
+		.id = TEGRA234_MEMORY_CLIENT_MGBEARD,
+		.name = "mgbeard",
+		.sid = TEGRA234_SID_MGBE,
+		.regs = {
+			.sid = {
+				.override = 0x2c0,
+				.security = 0x2c4,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEBRD,
+		.name = "mgbebrd",
+		.sid = TEGRA234_SID_MGBE_VF1,
+		.regs = {
+			.sid = {
+				.override = 0x2c8,
+				.security = 0x2cc,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBECRD,
+		.name = "mgbecrd",
+		.sid = TEGRA234_SID_MGBE_VF2,
+		.regs = {
+			.sid = {
+				.override = 0x2d0,
+				.security = 0x2d4,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEDRD,
+		.name = "mgbedrd",
+		.sid = TEGRA234_SID_MGBE_VF3,
+		.regs = {
+			.sid = {
+				.override = 0x2d8,
+				.security = 0x2dc,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEAWR,
+		.name = "mgbeawr",
+		.sid = TEGRA234_SID_MGBE,
+		.regs = {
+			.sid = {
+				.override = 0x2e0,
+				.security = 0x2e4,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEBWR,
+		.name = "mgbebwr",
+		.sid = TEGRA234_SID_MGBE_VF1,
+		.regs = {
+			.sid = {
+				.override = 0x2f8,
+				.security = 0x2fc,
+			},
+		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBECWR,
+		.name = "mgbecwr",
+		.sid = TEGRA234_SID_MGBE_VF2,
+		.regs = {
+			.sid = {
+				.override = 0x308,
+				.security = 0x30c,
+			},
+		},
+	}, {
 		.id = TEGRA234_MEMORY_CLIENT_SDMMCRAB,
 		.name = "sdmmcrab",
 		.sid = TEGRA234_SID_SDMMC4,
@@ -20,6 +90,16 @@ static const struct tegra_mc_client tegra234_mc_clients[] = {
 				.security = 0x31c,
 			},
 		},
+	}, {
+		.id = TEGRA234_MEMORY_CLIENT_MGBEDWR,
+		.name = "mgbedwr",
+		.sid = TEGRA234_SID_MGBE_VF3,
+		.regs = {
+			.sid = {
+				.override = 0x328,
+				.security = 0x32c,
+			},
+		},
 	}, {
 		.id = TEGRA234_MEMORY_CLIENT_SDMMCWAB,
 		.name = "sdmmcwab",
-- 
2.36.1

