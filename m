Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084AF569476
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiGFVdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiGFVdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:09 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1353B2A27C;
        Wed,  6 Jul 2022 14:33:08 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r14so17973439wrg.1;
        Wed, 06 Jul 2022 14:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9dxBJ140TPYxlhDNB6G3wfdXVIMKBJMVJJIVAjp3nLM=;
        b=ZVtSDNVURaeQawzT/JOp31PnvT154C55KG7QUiU7XquIjkcV7bsV/i9gBZxa+jtDBl
         uixw40szu3Y5083pCDAwgxBouPFujiC64zitUF4kxtAX1+yCthYHSWecW+7ZVJ9vCZON
         6kXs6ko3k+Kttj5SozY7SP/JGPfN9xVxeIPVV9LfJ9j2QnJkv9F6ZQdUNtRkqZY3xbfN
         wsUwosBqNvqZ9tvt59zCIjo9P+jyXopEXwnYB+fu/bg9Y+JM6ZsBc0hvK6URm80Gemiz
         t0YXlaA2a9f4Ue6zBBT6fvqlhkUgxDR6mm6jaliq1FF4W/I7DsZyea6R0vVuocCRnDtf
         PEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9dxBJ140TPYxlhDNB6G3wfdXVIMKBJMVJJIVAjp3nLM=;
        b=NnkMOIW6a0FRXmS/aExLvUcPXbhPDh15YGAo03W7UFxOkM0jS2CO9enxljQe6bZrMM
         aF8QgUWZl1GjGuVYCpnNAvCVpY98JiZ5buH7aVrtC5B3QvmJ/efigYE2RV2o9dRLfqAm
         5Ou0VdYYLU4n6sP+tZmBdBDOGKw7FpCm2d6znboJAllhjmN2Aynm8tEn9EHwaeK6toMz
         1ZmhC9/6QVYpscTyF65Qy8oJDB49SrTZj0oX9CshaPRPv7+X7cyajtV+Z7he+ULHV2xX
         oRCv3dMbXxE8Bqk70RDpf1kfx6yY1rAL6+9gpI5sTcncKvk5CSrQIP9w9m2212FY25Fc
         Y7hA==
X-Gm-Message-State: AJIora/7xdOWLm9zHaJ3IGW97lEh0lP0ToMic8ckramHBnDA4FwWZUut
        QT+oowYSpZRkVNr9yF7oZpM=
X-Google-Smtp-Source: AGRyM1tpd3bvHjERUgjGLLyI4yLrMBQjl0sLrHu+150XgleOl0ozIL/tQ6+wXSifm6qi++Pgch5suQ==
X-Received: by 2002:adf:f2cd:0:b0:21d:6913:6d32 with SMTP id d13-20020adff2cd000000b0021d69136d32mr19101210wrp.438.1657143186545;
        Wed, 06 Jul 2022 14:33:06 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id f190-20020a1c38c7000000b0039c5328ad92sm23605784wma.41.2022.07.06.14.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:05 -0700 (PDT)
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
Subject: [PATCH v3 3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
Date:   Wed,  6 Jul 2022 23:32:49 +0200
Message-Id: <20220706213255.1473069-4-thierry.reding@gmail.com>
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

Add the memory client and stream ID definitions for the Multi-Gigabit
Ethernet (MGBE) hardware found on NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/dt-bindings/memory/tegra234-mc.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/dt-bindings/memory/tegra234-mc.h b/include/dt-bindings/memory/tegra234-mc.h
index 35491bacbc86..8c785c1937f2 100644
--- a/include/dt-bindings/memory/tegra234-mc.h
+++ b/include/dt-bindings/memory/tegra234-mc.h
@@ -12,11 +12,15 @@
 #define TEGRA234_SID_APE	0x02
 #define TEGRA234_SID_HDA	0x03
 #define TEGRA234_SID_GPCDMA	0x04
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
@@ -63,8 +67,24 @@
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
 /* EQOS read client */
-- 
2.36.1

