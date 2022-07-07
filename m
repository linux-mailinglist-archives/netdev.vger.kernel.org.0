Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C00569C0A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiGGHsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiGGHsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:30 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CDF10EA;
        Thu,  7 Jul 2022 00:48:26 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so12942354wmp.3;
        Thu, 07 Jul 2022 00:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SijNeI2cf5r//czAcF6wXj1p9zEVk+T4hlYMkSl1YWQ=;
        b=CQJU35O2n9Oc+IISwu6cvuxVnds7tLPR4UH9qIH1c1GALUf/Ly2K2py+iyaPL1qLGj
         CUMNaQ9iQoX5tfAu9gR5V7h7DGh0aYVLGR2d4u7v2TGMVrI3yG9n7OlUg/Yu+vDytCVZ
         Mcj9soGnn+pkHdpY16psEcosZjl0K8wQ95Z7zdXGoEGai0QkcOzzGIheg2KgORb77P92
         C01sltBkTgrGUHkMbCmpYfEjwUHSpnkbKkIohDGg71kQ6yOPGHIZ7922sY2q/N0YZTR7
         sReVrDFW6QqS1IJDqj+K5mCd8wcyB6Lw3wqTDj+vXDnlpRgQbFRNklbx75nENQ7S5atF
         8Y3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SijNeI2cf5r//czAcF6wXj1p9zEVk+T4hlYMkSl1YWQ=;
        b=eQRx83l2SlM/MA25OFv6lnVggOHBWpVJs5iMjHpHtP3nlQ4i/OmvjVBaxp3Y/tjMtC
         I3m+/x/9HJg9OKQpAvcPGXh4wo4XWNyPXmitwrWGKk94prMK8XQ7Ru1NR5gujjUWmVv/
         0qO8AlGilp55GS6bnZQq13AUUQhw8dV5RuT1PpvXM4ZQ7bUiAPHXpCHb/12IIIdFY1VR
         SIhlnbAAJfJhF4g+8SVbC6PE5TKSOZ0E8uEyGHNoJ+j89CFr3HByOovjcbvEDJVLpHyd
         RhQt6QWXMQbcasuMFz/8YcqpAczb7VqSOYEuIJAZ4E40yip/N1iN0JXw1EkeQ+QoFPnn
         Fhsw==
X-Gm-Message-State: AJIora/Mq7T5Z4v5vvCybz8i2V/9niK3ev0O6F37XZUrduuK1nyfT9ZW
        vl+LIaUXbutRl8GIxkhwIb4=
X-Google-Smtp-Source: AGRyM1tK51jJgAp+gAiH1RsIWhURklqLgCKj7JpymHHYw4SavmDFsLycDs1DsG3i5Xco0azf076Kdw==
X-Received: by 2002:a05:600c:3658:b0:3a0:390e:ea00 with SMTP id y24-20020a05600c365800b003a0390eea00mr2873945wmq.128.1657180105302;
        Thu, 07 Jul 2022 00:48:25 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id v6-20020a05600c12c600b0039c811077d3sm27138383wmd.22.2022.07.07.00.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:24 -0700 (PDT)
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
Subject: [PATCH v4 3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
Date:   Thu,  7 Jul 2022 09:48:12 +0200
Message-Id: <20220707074818.1481776-4-thierry.reding@gmail.com>
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

Add the memory client and stream ID definitions for the Multi-Gigabit
Ethernet (MGBE) hardware found on NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/dt-bindings/memory/tegra234-mc.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/dt-bindings/memory/tegra234-mc.h b/include/dt-bindings/memory/tegra234-mc.h
index e3b0e9da295d..c202e7642bbd 100644
--- a/include/dt-bindings/memory/tegra234-mc.h
+++ b/include/dt-bindings/memory/tegra234-mc.h
@@ -11,11 +11,15 @@
 /* NISO0 stream IDs */
 #define TEGRA234_SID_APE	0x02
 #define TEGRA234_SID_HDA	0x03
+#define TEGRA234_SID_MGBE	0x06
 #define TEGRA234_SID_PCIE0	0x12
 #define TEGRA234_SID_PCIE4	0x13
 #define TEGRA234_SID_PCIE5	0x14
 #define TEGRA234_SID_PCIE6	0x15
 #define TEGRA234_SID_PCIE9	0x1f
+#define TEGRA234_SID_MGBE_VF1	0x49
+#define TEGRA234_SID_MGBE_VF2	0x4a
+#define TEGRA234_SID_MGBE_VF3	0x4b
 
 /* NISO1 stream IDs */
 #define TEGRA234_SID_SDMMC4	0x02
@@ -61,8 +65,24 @@
 #define TEGRA234_MEMORY_CLIENT_PCIE10AR1 0x48
 /* PCIE7r1 read clients */
 #define TEGRA234_MEMORY_CLIENT_PCIE7AR1 0x49
+/* MGBE0 read client */
+#define TEGRA234_MEMORY_CLIENT_MGBEARD 0x58
+/* MGBEB read client */
+#define TEGRA234_MEMORY_CLIENT_MGBEBRD 0x59
+/* MGBEC read client */
+#define TEGRA234_MEMORY_CLIENT_MGBECRD 0x5a
+/* MGBED read client */
+#define TEGRA234_MEMORY_CLIENT_MGBEDRD 0x5b
+/* MGBE0 write client */
+#define TEGRA234_MEMORY_CLIENT_MGBEAWR 0x5c
+/* MGBEB write client */
+#define TEGRA234_MEMORY_CLIENT_MGBEBWR 0x5f
+/* MGBEC write client */
+#define TEGRA234_MEMORY_CLIENT_MGBECWR 0x61
 /* sdmmcd memory read client */
 #define TEGRA234_MEMORY_CLIENT_SDMMCRAB 0x63
+/* MGBED write client */
+#define TEGRA234_MEMORY_CLIENT_MGBEDWR 0x65
 /* sdmmcd memory write client */
 #define TEGRA234_MEMORY_CLIENT_SDMMCWAB 0x67
 /* BPMP read client */
-- 
2.36.1

