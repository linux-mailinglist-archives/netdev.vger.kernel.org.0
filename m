Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2381A6A8F5D
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 03:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCCCm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 21:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCCCmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 21:42:55 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FD72698
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 18:42:53 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id bi9so1880705lfb.2
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 18:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677811371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U5WGNHoHvFrqEzbIMWPaETRGh642NbHa8AZbtFWCIaY=;
        b=a1Th93dRZhNLFhiK7IaDAOwo6+U7mQU2G9IxkKcOhsXbtvHHwqOJBbyqnZq9OWlJbe
         PRy2m3odeC/uu+rdRtGZFHE4CyA+ZQyW570JMMZLN4ZkJTbwPvvrklO6MtzsN/isn4BZ
         d6+Vw3elF8Thke2Olw45Gfy2cHVxP7Mn/m34a+orjQ73+ZKOSd2QIvCAH5Xjl2PGcOSe
         Kt+nHfF3mpKhQlnRl82T+Ihx/9ydlw6UJibClFQKxIyBYPPaSJ8YYC0mAaBnuZk5yqdu
         wUD+TIYQLfmen1g5gsYWk2+PTx84nUjPbl82gCmqpBZeOrpdzxTaESrrrRSVSUuAlubS
         glEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677811371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U5WGNHoHvFrqEzbIMWPaETRGh642NbHa8AZbtFWCIaY=;
        b=YzFhe/Mx6p4Qe6VpJsymwD0k0K3d2lA+REJaEErZl5hAMVjQqPjHdB1vBH7cG94E6N
         zz7KTyWBIelSi/HcVmY9o/U8DcgswXNVCjAGabT65P9geTPuCwgSAouFcmN81xP9HaN6
         yEVUNDIGW4XRWB82dkOpExGjYGP0erYQVn6EWGHRyh0AyhPKibjOWe1tjYHuLfFAOLgx
         0fM9k0zr+xFwEilbmS5l73YokFmIXYDXxdi7ODs72yLcpJHOEJz4kzCIwWLJBGW1mTF2
         vGbsbsJdYVLlD0BPmggVORVYuQseQZErasdq4KxdqcLKHX5CWVUy7a3XVFrC6CaqUqlr
         TAZA==
X-Gm-Message-State: AO0yUKWv2pT5geJ610qfUmzdbqtO9hBIpunyAqo6XDzwGBt9plVeDMjE
        +dXagYVBc7ayZf1giwSmkJgU7Q==
X-Google-Smtp-Source: AK7set9F3ef7m9KaxrogAYM4oalKAF6WRYPXP6o4DQr3SoBD77rCGtH28CpKaBUu35HPmnfJ/K7pCw==
X-Received: by 2002:a19:7611:0:b0:4b5:b705:9bf7 with SMTP id c17-20020a197611000000b004b5b7059bf7mr99636lff.11.1677811371416;
        Thu, 02 Mar 2023 18:42:51 -0800 (PST)
Received: from localhost.localdomain (abym99.neoplus.adsl.tpnet.pl. [83.9.32.99])
        by smtp.gmail.com with ESMTPSA id x19-20020a19f613000000b004db1cd5efcesm181379lfe.241.2023.03.02.18.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 18:42:51 -0800 (PST)
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
To:     linux-arm-msm@vger.kernel.org, andersson@kernel.org,
        agross@kernel.org
Cc:     marijn.suijten@somainline.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wifi: ath10k: snoc: Add VDD_SMPS regulator
Date:   Fri,  3 Mar 2023 03:42:46 +0100
Message-Id: <20230303024246.2175382-2-konrad.dybcio@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303024246.2175382-1-konrad.dybcio@linaro.org>
References: <20230303024246.2175382-1-konrad.dybcio@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least SM6375 (bundled with soc_id 0x400e0000) and SM4350 (bundled
with unknown, probably the same) expect one more supply, called vdd-smps
downstream. It's set to 0.984V and connected to a - you guessed it - SMPS
regulator on PM6125. Add support for it.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
---
The smps name sounds like a quick downstream hack and is probably
something more exquisite in reality.. Not something I know, though.

 drivers/net/wireless/ath/ath10k/snoc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 9a82f0336d95..6443523131db 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -48,6 +48,7 @@ static const char * const ath10k_regulators[] = {
 	"vdd-1.3-rfa",
 	"vdd-3.3-ch0",
 	"vdd-3.3-ch1",
+	"vdd-smps",
 };
 
 static const char * const ath10k_clocks[] = {
-- 
2.39.2

