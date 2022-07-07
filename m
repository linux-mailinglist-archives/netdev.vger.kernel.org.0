Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D29569C0C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiGGHse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGGHs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:28 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1973CC1A;
        Thu,  7 Jul 2022 00:48:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o19-20020a05600c4fd300b003a0489f414cso10201084wmq.4;
        Thu, 07 Jul 2022 00:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUNYuwH7o5jxQDGNnxUu6dXKQA1yYpc1eiHPJaWHPVs=;
        b=Pxt6QPh6HZEzwWfmoOOrPcDuK5pGWb7Ff5ZzLmmyNeZSwtG+NkLIsUwmlS8q/DNFti
         uc/999zQI70VDJfUL6DJ6+opX2oteLHEVsO+MCqrGUwOpW1UHoG27OXtay6DtKm8omY/
         7LTUZYGTbPoHieCEBdwQyIB6v50KPhyR6BscLHFmPV0fraXQPtWwqjPQvc0nejcRNzu+
         /UAQZB85gWIW7jXTq9hlA6s0DPaaRfgbIdAtq5xFxmJhf3LNTQUIg8BO/0BfNBekDieY
         6p/8lzQI3grDG6rTOQzl29IPO05QwnjhPyzSUOwinxQL75e0ElQE1BLu5Xpok6CR6VJ2
         Zhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUNYuwH7o5jxQDGNnxUu6dXKQA1yYpc1eiHPJaWHPVs=;
        b=jvYJtR6uBxewEdFtrkvg0ozJ+TrFgh/bPMU5kZvW60SCd2dyZQruUzb8IH7FZ/o6+P
         Qx8DNiYwy3xfrv1qKGruUpb6WK2O5924sEhxFuoDXpvTRTPOJUuew9gptrjKik9cWR/Q
         Fa50bXcklT+6YWm72fOhRMo8t1RYo2XnJckHVqLdKhPc5EUeB/0NO+E2XjO6JMNbCHmv
         1ueLyYItcJmVRWOPAa2uhiTxbgVRWoHNjkQ/ETygB94wz9oD0DtlbdAhKNkATgdu02X0
         NnnomTC1np11hRxa47ElURKuJuQCRhSe47ds/VTTSJZFX3qRlWhKWAnRaWVgdwpDS9u+
         zKyg==
X-Gm-Message-State: AJIora9m+Wiv1px1IDTMsmAZChN4tIH6cTKI4xtkQJsQWRAp/Nny1gcg
        C36JJ4JWE6WQ4LV/kRq3AU8=
X-Google-Smtp-Source: AGRyM1uaQCaaIKFe4Ez/4ZeIDKh+VI+unCvT3ptEiyBE4zTz/bXJ7W3C7AhgynAei4eNWnBv88d1FA==
X-Received: by 2002:a05:600c:3d8f:b0:3a1:963d:202d with SMTP id bi15-20020a05600c3d8f00b003a1963d202dmr2844122wmb.11.1657180103523;
        Thu, 07 Jul 2022 00:48:23 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id q7-20020a05600000c700b0021d76985929sm5799526wrx.80.2022.07.07.00.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:22 -0700 (PDT)
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
Subject: [PATCH v4 2/9] dt-bindings: Add Tegra234 MGBE clocks and resets
Date:   Thu,  7 Jul 2022 09:48:11 +0200
Message-Id: <20220707074818.1481776-3-thierry.reding@gmail.com>
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

Add the clocks and resets used by the Multi-Gigabit Ethernet (MGBE)
hardware found on NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/dt-bindings/clock/tegra234-clock.h | 101 +++++++++++++++++++++
 include/dt-bindings/reset/tegra234-reset.h |   8 ++
 2 files changed, 109 insertions(+)

diff --git a/include/dt-bindings/clock/tegra234-clock.h b/include/dt-bindings/clock/tegra234-clock.h
index bd4c3086a2da..bab85d9ba8cd 100644
--- a/include/dt-bindings/clock/tegra234-clock.h
+++ b/include/dt-bindings/clock/tegra234-clock.h
@@ -164,10 +164,111 @@
 #define TEGRA234_CLK_PEX1_C5_CORE		225U
 /** @brief PLL controlled by CLK_RST_CONTROLLER_PLLC4_BASE */
 #define TEGRA234_CLK_PLLC4			237U
+/** @brief RX clock recovered from MGBE0 lane input */
+#define TEGRA234_CLK_MGBE0_RX_INPUT		248U
+/** @brief RX clock recovered from MGBE1 lane input */
+#define TEGRA234_CLK_MGBE1_RX_INPUT		249U
+/** @brief RX clock recovered from MGBE2 lane input */
+#define TEGRA234_CLK_MGBE2_RX_INPUT		250U
+/** @brief RX clock recovered from MGBE3 lane input */
+#define TEGRA234_CLK_MGBE3_RX_INPUT		251U
 /** @brief 32K input clock provided by PMIC */
 #define TEGRA234_CLK_CLK_32K			289U
+/** @brief Monitored branch of MBGE0 RX input clock */
+#define TEGRA234_CLK_MGBE0_RX_INPUT_M		357U
+/** @brief Monitored branch of MBGE1 RX input clock */
+#define TEGRA234_CLK_MGBE1_RX_INPUT_M		358U
+/** @brief Monitored branch of MBGE2 RX input clock */
+#define TEGRA234_CLK_MGBE2_RX_INPUT_M		359U
+/** @brief Monitored branch of MBGE3 RX input clock */
+#define TEGRA234_CLK_MGBE3_RX_INPUT_M		360U
+/** @brief Monitored branch of MGBE0 RX PCS mux output */
+#define TEGRA234_CLK_MGBE0_RX_PCS_M		361U
+/** @brief Monitored branch of MGBE1 RX PCS mux output */
+#define TEGRA234_CLK_MGBE1_RX_PCS_M		362U
+/** @brief Monitored branch of MGBE2 RX PCS mux output */
+#define TEGRA234_CLK_MGBE2_RX_PCS_M		363U
+/** @brief Monitored branch of MGBE3 RX PCS mux output */
+#define TEGRA234_CLK_MGBE3_RX_PCS_M		364U
+/** @brief RX PCS clock recovered from MGBE0 lane input */
+#define TEGRA234_CLK_MGBE0_RX_PCS_INPUT		369U
+/** @brief RX PCS clock recovered from MGBE1 lane input */
+#define TEGRA234_CLK_MGBE1_RX_PCS_INPUT		370U
+/** @brief RX PCS clock recovered from MGBE2 lane input */
+#define TEGRA234_CLK_MGBE2_RX_PCS_INPUT		371U
+/** @brief RX PCS clock recovered from MGBE3 lane input */
+#define TEGRA234_CLK_MGBE3_RX_PCS_INPUT		372U
+/** @brief output of mux controlled by GBE_UPHY_MGBE0_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE0_RX_PCS		373U
+/** @brief GBE_UPHY_MGBE0_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE0_TX			374U
+/** @brief GBE_UPHY_MGBE0_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE0_TX_PCS		375U
+/** @brief GBE_UPHY_MGBE0_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE0_MAC_DIVIDER		376U
+/** @brief GBE_UPHY_MGBE0_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE0_MAC			377U
+/** @brief GBE_UPHY_MGBE0_MACSEC_CLK gate output */
+#define TEGRA234_CLK_MGBE0_MACSEC		378U
+/** @brief GBE_UPHY_MGBE0_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE0_EEE_PCS		379U
+/** @brief GBE_UPHY_MGBE0_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE0_APP			380U
+/** @brief GBE_UPHY_MGBE0_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE0_PTP_REF		381U
+/** @brief output of mux controlled by GBE_UPHY_MGBE1_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE1_RX_PCS		382U
+/** @brief GBE_UPHY_MGBE1_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE1_TX			383U
+/** @brief GBE_UPHY_MGBE1_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE1_TX_PCS		384U
+/** @brief GBE_UPHY_MGBE1_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE1_MAC_DIVIDER		385U
+/** @brief GBE_UPHY_MGBE1_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE1_MAC			386U
+/** @brief GBE_UPHY_MGBE1_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE1_EEE_PCS		388U
+/** @brief GBE_UPHY_MGBE1_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE1_APP			389U
+/** @brief GBE_UPHY_MGBE1_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE1_PTP_REF		390U
+/** @brief output of mux controlled by GBE_UPHY_MGBE2_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE2_RX_PCS		391U
+/** @brief GBE_UPHY_MGBE2_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE2_TX			392U
+/** @brief GBE_UPHY_MGBE2_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE2_TX_PCS		393U
+/** @brief GBE_UPHY_MGBE2_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE2_MAC_DIVIDER		394U
+/** @brief GBE_UPHY_MGBE2_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE2_MAC			395U
+/** @brief GBE_UPHY_MGBE2_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE2_EEE_PCS		397U
+/** @brief GBE_UPHY_MGBE2_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE2_APP			398U
+/** @brief GBE_UPHY_MGBE2_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE2_PTP_REF		399U
+/** @brief output of mux controlled by GBE_UPHY_MGBE3_RX_PCS_CLK_SRC_SEL */
+#define TEGRA234_CLK_MGBE3_RX_PCS		400U
+/** @brief GBE_UPHY_MGBE3_TX_CLK divider gated output */
+#define TEGRA234_CLK_MGBE3_TX			401U
+/** @brief GBE_UPHY_MGBE3_TX_PCS_CLK divider gated output */
+#define TEGRA234_CLK_MGBE3_TX_PCS		402U
+/** @brief GBE_UPHY_MGBE3_MAC_CLK divider output */
+#define TEGRA234_CLK_MGBE3_MAC_DIVIDER		403U
+/** @brief GBE_UPHY_MGBE3_MAC_CLK gate output */
+#define TEGRA234_CLK_MGBE3_MAC			404U
+/** @brief GBE_UPHY_MGBE3_MACSEC_CLK gate output */
+#define TEGRA234_CLK_MGBE3_MACSEC		405U
+/** @brief GBE_UPHY_MGBE3_EEE_PCS_CLK gate output */
+#define TEGRA234_CLK_MGBE3_EEE_PCS		406U
+/** @brief GBE_UPHY_MGBE3_APP_CLK gate output */
+#define TEGRA234_CLK_MGBE3_APP			407U
+/** @brief GBE_UPHY_MGBE3_PTP_REF_CLK divider gated output */
+#define TEGRA234_CLK_MGBE3_PTP_REF		408U
 /** @brief CLK_RST_CONTROLLER_AZA2XBITCLK_OUT_SWITCH_DIVIDER switch divider output (aza_2xbitclk) */
 #define TEGRA234_CLK_AZA_2XBIT			457U
 /** @brief aza_2xbitclk / 2 (aza_bitclk) */
 #define TEGRA234_CLK_AZA_BIT			458U
+
 #endif
diff --git a/include/dt-bindings/reset/tegra234-reset.h b/include/dt-bindings/reset/tegra234-reset.h
index 547ca3b60caa..55e397823a38 100644
--- a/include/dt-bindings/reset/tegra234-reset.h
+++ b/include/dt-bindings/reset/tegra234-reset.h
@@ -29,6 +29,12 @@
 #define TEGRA234_RESET_I2C7			33U
 #define TEGRA234_RESET_I2C8			34U
 #define TEGRA234_RESET_I2C9			35U
+#define TEGRA234_RESET_MGBE0_PCS		45U
+#define TEGRA234_RESET_MGBE0_MAC		46U
+#define TEGRA234_RESET_MGBE1_PCS		49U
+#define TEGRA234_RESET_MGBE1_MAC		50U
+#define TEGRA234_RESET_MGBE2_PCS		53U
+#define TEGRA234_RESET_MGBE2_MAC		54U
 #define TEGRA234_RESET_PEX2_CORE_10		56U
 #define TEGRA234_RESET_PEX2_CORE_10_APB		57U
 #define TEGRA234_RESET_PEX2_COMMON_APB		58U
@@ -43,6 +49,8 @@
 #define TEGRA234_RESET_QSPI0			76U
 #define TEGRA234_RESET_QSPI1			77U
 #define TEGRA234_RESET_SDMMC4			85U
+#define TEGRA234_RESET_MGBE3_PCS		87U
+#define TEGRA234_RESET_MGBE3_MAC		88U
 #define TEGRA234_RESET_UARTA			100U
 #define TEGRA234_RESET_PEX0_CORE_0		116U
 #define TEGRA234_RESET_PEX0_CORE_1		117U
-- 
2.36.1

