Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A11569C22
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiGGHsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiGGHsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:36 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959C43205E;
        Thu,  7 Jul 2022 00:48:34 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id h131-20020a1c2189000000b003a2cc290135so396191wmh.2;
        Thu, 07 Jul 2022 00:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UmEVPXSuMOSm98KToNOHXi0Hb6WIl7OgT+YvYE3P9Dw=;
        b=J/pDhOC9g92s4WAsGzzLFcoqGiEyoYkBip93jOIBuEHmidc1qQGd0t3dpERjjoXD40
         LflVjbyRFExdvkMNSQebvSYLJO1a4ecxJ6ybyq0XnWpTzd2ilzz+fMNJXEiUYiHRyZMA
         sH6TWFlxNTpYTjAjR11DSm6GfpmV48lMclWizo+9/0BCz9wYOSdzAR5VhAmwEKFsTiw7
         c9o7DEv4q2NYBToEhS/iY2kCHUOBzeHJvgKtWgvZh28t33g0NKya4nu/7CAiMvzovcoH
         KmqbOFkCsfdisaJ0D7k9rU0tFKqp95O00SKKqoxI1H3ltkhGG7HTSKBWBkaMa8qFwRZF
         LBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UmEVPXSuMOSm98KToNOHXi0Hb6WIl7OgT+YvYE3P9Dw=;
        b=wrRfZ5Qc/8OpryJR5FSPhUMOK7Yc1QkWHzBuUDg5G/EuUTl3kiX3GazjCO8nMbw82n
         ZhzEUkH9sONXS4Ln+x0tsodOlUHbQVdAsV0C/DsWT6y+ikvARSig6A21osf5QOFBoRHt
         cnKCidBQdR4Er84BusZ6+kF+PxmriJFI6w2l0CU/Ana4uObcWMfE4whEUetOrop1EjNu
         es970GjprQLnw6g60Iw8B/LSTwUp7UCEsCiJZJf0goWkvbKH79T+MCT4c1Cwonnp4aui
         7UxVwDmzgvlBw8rR9VMqLo2PxtX5dCTyesZPb1JRkdqw6mHOc5VgHf6ITD4tFemzmk8u
         XZBA==
X-Gm-Message-State: AJIora9N9nEWsejDzW3sBEe9kcHsywKOpTW6kxuQVYbZMD3dwohTv4hQ
        K/BlZ50cnmmFAC6boyQbrhI=
X-Google-Smtp-Source: AGRyM1vlEbAGPHiGtNwmfUPmWwFtg2P5CO+mr1mjFZwoytPnGsPJ5/9/CiAE9LDlo2LIOeShFe8boQ==
X-Received: by 2002:a7b:cb8b:0:b0:3a1:98f8:abda with SMTP id m11-20020a7bcb8b000000b003a198f8abdamr2938192wmi.129.1657180113425;
        Thu, 07 Jul 2022 00:48:33 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c358d00b003974a00697esm24622226wmq.38.2022.07.07.00.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:32 -0700 (PDT)
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
        netdev@vger.kernel.org
Subject: [PATCH v4 8/9] arm64: defconfig: Enable Tegra MGBE driver
Date:   Thu,  7 Jul 2022 09:48:17 +0200
Message-Id: <20220707074818.1481776-9-thierry.reding@gmail.com>
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

From: Bhadram Varka <vbhadram@nvidia.com>

Enable the driver for the Multi-Gigabit Ethernet (MGBE) controller which
can be found on NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 7d1105343bc2..f80142abd9c6 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -359,6 +359,7 @@ CONFIG_SMSC911X=y
 CONFIG_SNI_AVE=y
 CONFIG_SNI_NETSEC=y
 CONFIG_STMMAC_ETH=m
+CONFIG_DWMAC_TEGRA=m
 CONFIG_TI_K3_AM65_CPSW_NUSS=y
 CONFIG_QCOM_IPA=m
 CONFIG_MESON_GXL_PHY=m
-- 
2.36.1

