Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DC06B5EE8
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCKRdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCKRdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:18 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C588012F2B
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:13 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id cy23so32926804edb.12
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678555992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wf3VcA12/YrUundcroeR6wyGdqPTMCPD8/QGoi4c1VQ=;
        b=UlZRqvn12gq/jGCCnKeQnJcvhYq4mKfAWsv8joCF1SKk81V5nKo6bL4qnULGKxYSD5
         B2YK/KjiT/rlm1xbIwn85ZKrc4c5jKwMcQLv0cv1YQTnYNYLj8AXVQMeP01QTZYrOVpf
         Jp18EuL79aOIZ+Hn1V8XgZoi/kIP+++F4/Gfbh5nloPb73y1VGK+t4uKQ/p8h+Yv+SfS
         Pcn7Pq4eq7a2t9MOj4lkEc9R3yRwiiZ8/xLmMkoHHRKXZZuFOM3Ti/RBu3sw/i5sTRie
         O+ZU0ciUG2+ddhxbNO7pPID0i7DAj18EzJI8cQVD+MbBI5wRiig3+DhLGub5ZUyNjxLF
         4Onw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wf3VcA12/YrUundcroeR6wyGdqPTMCPD8/QGoi4c1VQ=;
        b=yua9o0x5nNK6FPWBav4DP1nhgvj7eOKg7yy2Pak1gUGpDoN666YmmAyltx0pTAwl1B
         Gbng/iezXsEOiP9X3GxLzP9L2GiJCOoWYEUdL+vTt1YDAK4HYiR1b0durDFK+rd98oR2
         AtIkkNn1LxijUIRkMkY42VwFoXU22LVR/bIaZnpAI98KQvZuPII/pDdo4Awf//3OUAEj
         EQijFc+pOY3md3aC5Cq43UBPhAx/tPX1EG1fXl17gnU28nfR3XW4HbWFXKN0IfamMs6D
         ughc1jnWQOds7CGjxhQqGpFCnb/Yi9zDCLdpJOESrrt71jdjqKbjT33H8QjO98/GJuLY
         yV9w==
X-Gm-Message-State: AO0yUKW2q2ndlJD2lHVgQCI7pFqQQMkchHiDpT35vUKo0jdDZVfFC6ls
        qGbEI802/yVXI4tZ6CSAXf/gcQ==
X-Google-Smtp-Source: AK7set+f79dWDHOOxM5tf/Bi+yy9nY4COgvksaFhvAvFJlsDWV8YsvBROd1UMXS3rxmXEvfUyo2jmQ==
X-Received: by 2002:aa7:c40c:0:b0:4fa:ac78:7f2a with SMTP id j12-20020aa7c40c000000b004faac787f2amr1891149edq.41.1678555992182;
        Sat, 11 Mar 2023 09:33:12 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:11 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 01/12] net: dsa: lantiq_gswip: mark OF related data as maybe unused
Date:   Sat, 11 Mar 2023 18:32:52 +0100
Message-Id: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/net/dsa/lantiq_gswip.c:1888:34: error: ‘xway_gphy_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/dsa/lantiq_gswip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 05ecaa007ab1..3c76a1a14aee 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1885,7 +1885,7 @@ static const struct xway_gphy_match_data xrx300_gphy_data = {
 	.ge_firmware_name = "lantiq/xrx300_phy11g_a21.bin",
 };
 
-static const struct of_device_id xway_gphy_match[] = {
+static const struct of_device_id xway_gphy_match[] __maybe_unused = {
 	{ .compatible = "lantiq,xrx200-gphy-fw", .data = NULL },
 	{ .compatible = "lantiq,xrx200a1x-gphy-fw", .data = &xrx200a1x_gphy_data },
 	{ .compatible = "lantiq,xrx200a2x-gphy-fw", .data = &xrx200a2x_gphy_data },
-- 
2.34.1

