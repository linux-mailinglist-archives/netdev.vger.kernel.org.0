Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1C0569C1E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiGGHs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiGGHs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43953CC;
        Thu,  7 Jul 2022 00:48:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s1so25083732wra.9;
        Thu, 07 Jul 2022 00:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fg/phBGKhZr7UrHQOPXuoLQtqwIeUVgaOU3TILEF07Q=;
        b=ULIMVJBLFkwjW5lRytcBI1Z1ous6zpUq8uvZuEa8PzjoQ7LOnoav9ty0TFZXd6iaf9
         UcqYSsmyfd1u72P90PVJMZERgmTw7KqPmuWLPzozxGg6yw/SyAMvbbNTDIRVK/tFTHe/
         Y7+85G54yhDDxc5SuwOylxW2Uuqt5/VIpeh7HaxnD9SHq6tJ+GER/clrE1NXTXURcVHy
         nTGQc7ymz3Q+k9TDCHxktgFDdNrYINxFMAKNnKDP7Iqc2hun6+gzR46G5v4SGyPwkO4y
         PpOSq62/mDfkTBD07UFO7dRKcgSujRLzo/n3W769LGMzzHo8szpBvXn7OtrXPwxSzOzP
         caNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fg/phBGKhZr7UrHQOPXuoLQtqwIeUVgaOU3TILEF07Q=;
        b=xmGiurDLeH465cyt/s4Qq6k8xOiCa3+rucKvCLfGJYb4ABV9l/QnFGdHmvfHlExDuz
         dR2fnjg3Z+yfQRgecWcwJBvrtBQ+wCxBbvoGVY/dk3Tf4Cq377NHXYpjwDkCN1Dmb8ym
         brrAHWLSzfz4IdlZ5O7xwsn5EbFSSCVg7sT+qC62ToMcIbnNe+cWEn308domn81Vy9kL
         cP6ffTGWLfioltGQ7XDiCSM/HXkOOjDBDhuBZnPgECrXC+IQI1uT4OUyYxDvdWkcm5/l
         NFAQWqmLFqT+ph+3HpiqUFI/SKW4Vq6n+w0cAMH5lvRcbIT+3KlDeDVc/b6AILr2ZMjZ
         Rmdw==
X-Gm-Message-State: AJIora/SDc1Yq2VRI0TSAInGyHDsh0i0OhErZ3+ZghRCzXXx+A7X5S09
        DZXQ5wO0PbRSkH617DxtQdk=
X-Google-Smtp-Source: AGRyM1uMa+kP9ZGMe+b/dOelUGqRU1UsQoUajdkdJg2Ma9Ep+Zlf2JZitnYiwu0O6/852SNmOat4OA==
X-Received: by 2002:adf:e28a:0:b0:210:b31:722 with SMTP id v10-20020adfe28a000000b002100b310722mr41500539wri.65.1657180101799;
        Thu, 07 Jul 2022 00:48:21 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id q13-20020adff50d000000b0021d64a11727sm12810726wro.49.2022.07.07.00.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:20 -0700 (PDT)
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
Subject: [PATCH v4 1/9] dt-bindings: power: Add Tegra234 MGBE power domains
Date:   Thu,  7 Jul 2022 09:48:10 +0200
Message-Id: <20220707074818.1481776-2-thierry.reding@gmail.com>
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

