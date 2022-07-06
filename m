Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED9C569477
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiGFVdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiGFVdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC7F2A955;
        Wed,  6 Jul 2022 14:33:10 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v16so12315846wrd.13;
        Wed, 06 Jul 2022 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qksiefyWfPEtdDN03SulVwHSuSdTMWDrDcF6sRt+8P4=;
        b=RqlLDdLC93LTRiXfFHQbhDbjFT/UxkW4XCzvtb6YUDIbkKNLbXpYgYcF7QaHEMWPFB
         uE4rwaCgMtOaohoDN2ZyvISafWSVnilJT1nn9YUwGOnRR1ZEjWryC1g3MSZUcu+HAFUY
         fzRqzwEcF5sgaQ8z1WIarOcoFmWTeQ6bK7Uv+VzONtOM8K9os3mZ1EFwZmUw6mZS47mb
         JCIzSuAM7kaVLK4CVctKU/xoMR5K5I7bORTs3/Jv297bJ3z53fBFb2CYn1dBlX5btdN/
         Yo+rLqIVObShwY+JBVEXneLi9OanD+MIr8PBzL0Y9//E9cevwB6JQoqsmrWbUv3Ct7CZ
         yKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qksiefyWfPEtdDN03SulVwHSuSdTMWDrDcF6sRt+8P4=;
        b=HFNU11XnBjQzN/IirDCD2y3JkPC8tiv8XjJaW9DBSBPdGqyAQ9no2drDPdsyAXSeEE
         Dv3WppikjTTdWWD6AzHTMshdtxTT7tb5DzoTRxFMqCBbhBLCsoqL8BnKpxHZbFnrzmWD
         +LwXLxUueJ6crLcV5Hi/k6px54+hkOxQtgZ6w7xlgZhRHeBoleTcZK8Avw82qOD5fwVZ
         ra0XGS4cNObtGlVNTDqCmLCb+YEGCjml4uRzMoQDSZEJLKlteSsY7BFQoG5a6FMR4N5P
         +y9Q+0EtxGe+INvhZUiYtpmVbBMAKHMNtYnsXIfi2zrnIH1hHrKT6o4zRRUSYdvnrut9
         ekeg==
X-Gm-Message-State: AJIora+NsbfwcAzmaeDAdD1tTpfi5QlluIJgYUj4YzUwtGYwFxICy90j
        IaIvt2aNhseBYGXFwqeGS7o=
X-Google-Smtp-Source: AGRyM1s6fbdaehrJ71MyjsBSmSmbm4MN9IXvDpm8OLuI5yQ9210DMQ0DXoTrc8chF5uUY28nEo+V7g==
X-Received: by 2002:a5d:4d46:0:b0:21d:8196:6181 with SMTP id a6-20020a5d4d46000000b0021d81966181mr2190490wru.459.1657143188936;
        Wed, 06 Jul 2022 14:33:08 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id m17-20020adfe0d1000000b0021b866397a7sm37429688wri.1.2022.07.06.14.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:07 -0700 (PDT)
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
Subject: [PATCH v3 4/9] memory: tegra: Add MGBE memory clients for Tegra234
Date:   Wed,  6 Jul 2022 23:32:50 +0200
Message-Id: <20220706213255.1473069-5-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706213255.1473069-1-thierry.reding@gmail.com>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
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
index 5244b3c560b0..c1018a50431e 100644
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

