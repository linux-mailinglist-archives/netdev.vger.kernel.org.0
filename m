Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3497569479
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiGFVdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiGFVdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:05 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B1C27145;
        Wed,  6 Jul 2022 14:33:04 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bk26so8686511wrb.11;
        Wed, 06 Jul 2022 14:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fg/phBGKhZr7UrHQOPXuoLQtqwIeUVgaOU3TILEF07Q=;
        b=VL+ggLiQ9rzXiwBSovopuHxOXFel3Xhv127KxNiPzpYMOUJGAq+aC25L3/C2QxYPt8
         s7r3wWaozRrfkZiwdDg3GQBXS/H75PEcXUmFh0ChuFF+3SSP3Hx5L3JkAsWcA/hUL9kx
         Y3zFnDEJbukzWApw1yYlwXS73Ds71s0tvUjmt70PR62inqOFeQmibnDEWomQAc+s9Ecr
         urZ1N24xEILx87Rxw7s9lAQ6DKF2D20GRm/0JCfTxpqBWopBoNikhutdYSy2LErSNKVA
         bvrcrJtujRmjOaZ3JzlnPM0ml5yiUu7h69htmTzz8qQuIA1EVS/ubOPxR7bDRWdelgc3
         SXPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fg/phBGKhZr7UrHQOPXuoLQtqwIeUVgaOU3TILEF07Q=;
        b=o6LDYY8x9ff380qtV9V9UneRIWve5XeGLyHRZFWq+c9XVCSXdcBZbF/c7Ab6XNe5s3
         XnXrxxEBwqxJDyF4LdI02wspYITnC9C/wu3bX7AqTS3Jt+C7eE/60YeF05tjmnARnMle
         Hiv+3LH6Nyv6Q+rpE5xUzE9WpCLbMKMIwMJfZw1BMWi8q7cTw9P3odQDRx7Du8BADeEB
         l/C2VPsT4TaPmsg9sThl2oAL5alOvI1J/es/2WO3sr/uqosi+47LOmj/N7MPN81TrFl1
         2Eho3DdeGXnqyxuVXixieOeSP8ey1ruCVgwTElMD2wlNDjbMLRnWNbsaXZ1j/kYFtNGS
         8Cmg==
X-Gm-Message-State: AJIora9cIlpwflEnYPNKtPszQWC43m0gR/OBiiciosVCX2B5AIX13eC3
        xPRXoLySjaIsbTtjBxI2HNw=
X-Google-Smtp-Source: AGRyM1uysZZkfTar5qcs0P2RtQiH2zA7twOcPZSQdqOuscQRra/ocxGsMPqKorDoXbhv6GmCUB05Rg==
X-Received: by 2002:adf:f9ce:0:b0:21d:68b7:e7af with SMTP id w14-20020adff9ce000000b0021d68b7e7afmr18658227wrr.236.1657143183028;
        Wed, 06 Jul 2022 14:33:03 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id bd16-20020a05600c1f1000b003a18ecfcd8csm18092287wmb.19.2022.07.06.14.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:02 -0700 (PDT)
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
Subject: [PATCH v3 1/9] dt-bindings: power: Add Tegra234 MGBE power domains
Date:   Wed,  6 Jul 2022 23:32:47 +0200
Message-Id: <20220706213255.1473069-2-thierry.reding@gmail.com>
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

Add power domain IDs for the four Multi-Gigabit Ethernet (MGBE) power
partitions found on NVIDIA Tegra234.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/dt-bindings/power/tegra234-powergate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/tegra234-powergate.h b/include/dt-bindings/power/tegra234-powergate.h
index f610eee9bce8..df1d4dd8dcf3 100644
--- a/include/dt-bindings/power/tegra234-powergate.h
+++ b/include/dt-bindings/power/tegra234-powergate.h
@@ -18,5 +18,6 @@
 #define TEGRA234_POWER_DOMAIN_MGBEA	17U
 #define TEGRA234_POWER_DOMAIN_MGBEB	18U
 #define TEGRA234_POWER_DOMAIN_MGBEC	19U
+#define TEGRA234_POWER_DOMAIN_MGBED	20U
 
 #endif
-- 
2.36.1

