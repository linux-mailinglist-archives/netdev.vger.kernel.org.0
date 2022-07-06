Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA7E569480
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiGFVdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiGFVdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:25 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88CC2AC49;
        Wed,  6 Jul 2022 14:33:18 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id l40-20020a05600c1d2800b003a18adff308so10045693wms.5;
        Wed, 06 Jul 2022 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=elqrnMpvZf1KqnOFoz03ru0nzodV+71XVzlmPZhkxsw=;
        b=FqDZqTpsyq/NGkm/qE3FD1nFhYTK3fltw8ZEYjotV+zeuMSMui65F7HgOCkyGZpdS5
         OeMI4MWqqJPUci8LsbmtDsWtawFPTF6QnQI/MlZtJLoEhcpR+SG2uQVVx3BS+lkBanz0
         UDA3pqIP8JedyC/VMolnRMpIQUTooN8NLZwWGpvFQ6tDSkKow5Tcg5TvLAaatNxZW1fq
         F91DEcdlsnQh3EvEfCgWsPcBAUSZ7Yk8UucgsB6PIGi0ja+BmW2kauKr1F1rrJf3DJyt
         JDa4AbT21v++aEShuNljFUdF/6zT429TgDgUUlsQus+w+HbTn8xRQ+/NYfnn+LwhiX0G
         r96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=elqrnMpvZf1KqnOFoz03ru0nzodV+71XVzlmPZhkxsw=;
        b=BY6TOpEml4ooNKQopDruHT9Wiyn7mmkvNy/Mmd2Xu6xl8Jb1Ettv5NCYClPwJ4RYt8
         wMqvQE32uuJL+XykwE0JUv1WZ7/BWle9AOBxpnsBlwjETluFXBFL/S5uyzonh+4Q9xh+
         Wm5rNl07EVWgwzGQawU3RGXQDm3C7U2/HSJ1tCjW77JNIF7cRtgJjJG6rEGBsX1C4+eR
         uxEu/z0LyeS23BJiXbCwviawXSd7+PfKi9HrHZnBp7O5iyBdFcaSppZZ69Av5kzJGM9G
         oBxsDvVnrRpiWlZjwCSJrKTpXgtpC9SL9jsXMT93hXqFwW37BVykOMdb8GeziroDwdW1
         uUHA==
X-Gm-Message-State: AJIora+JkTnFFl7eVaiZEoMVNcjUNlC7WUVirvHLZHoxHCDVNpBDIf7R
        2xbfpD3Z8YVviM/hFNLIHOk=
X-Google-Smtp-Source: AGRyM1v8HTdFGDus7b4DUbF1Wa/G+H7c9/ZHh+9tYhqVlwe4JBlfhvB2lTxKuZDAOrZjPRL0W0stdA==
X-Received: by 2002:a05:600c:1d95:b0:3a0:3cf1:5eb4 with SMTP id p21-20020a05600c1d9500b003a03cf15eb4mr659292wms.50.1657143198392;
        Wed, 06 Jul 2022 14:33:18 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id 22-20020a05600c029600b003a2b8461ddbsm6921788wmk.41.2022.07.06.14.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:17 -0700 (PDT)
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
Subject: [PATCH v3 8/9] arm64: defconfig: Enable Tegra MGBE driver
Date:   Wed,  6 Jul 2022 23:32:54 +0200
Message-Id: <20220706213255.1473069-9-thierry.reding@gmail.com>
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

From: Bhadram Varka <vbhadram@nvidia.com>

Enable the driver for the Multi-Gigabit Ethernet (MGBE) controller which
can be found on NVIDIA Tegra234 SoCs.

Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d2615b37d857..07e567f73076 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -360,6 +360,7 @@ CONFIG_SMSC911X=y
 CONFIG_SNI_AVE=y
 CONFIG_SNI_NETSEC=y
 CONFIG_STMMAC_ETH=m
+CONFIG_DWMAC_TEGRA=m
 CONFIG_TI_K3_AM65_CPSW_NUSS=y
 CONFIG_QCOM_IPA=m
 CONFIG_MESON_GXL_PHY=m
-- 
2.36.1

