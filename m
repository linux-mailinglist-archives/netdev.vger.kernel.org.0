Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBC850346F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiDPG2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiDPG2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:28:02 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBA031519
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 23:25:31 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i3-20020a056830010300b00605468119c3so9101otp.11
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 23:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1nj3J8YU5Vej28oK4eTz5AhdGlTE1eHnuaxj+1M/yCk=;
        b=btV3Z3eteJFAElnS9gk7VjFFNe0KKh31GbJUhz2UFW6eYt+vwSqH6q7kSg6UQPkeZb
         1IHwXLqOdfwtRJLeaTk2WvdJjo+2CXMJjnPvxRhvnsDgOQRPvsc8YLnoBJa3EpZ+71px
         4vTN4j6ek47Upp+uPpFur81slS/Mc9h9yNob/1lkZd/DQfLTacs/RHtNUOBfaKvGJxe8
         e1oI1gcbYcK+cYUhmIa6V6T/xVx/8dWZoP9PTDSVzE73UX7asq1aDFN4yWyaig8R7HRr
         9W2TtlMGl/JoIFOMX+GLTER9l5R9Rfs72Y4wcHlASZVslqn1qWScLSKryBkp8BQdBVt7
         tePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1nj3J8YU5Vej28oK4eTz5AhdGlTE1eHnuaxj+1M/yCk=;
        b=zXtowd7oegPXoQ1XyLo/flAeVGawm4RH8vS8bOc54nBYC9xQrZIoLwvx5Zz++ckseK
         ph9OvX+vkE6MtC1jxFlpLA94/mh6dbMLZO/5lVI8YRJFEP94zdeBEcBAEyugrncT/4+U
         shzCoBQ8ohnY3Kckllp+y8eDDDF/9Tdj0crFw4e8WrViZ96v/B5FWtWofo90KC5d8lCw
         smDhu/KKpR0lFc2C8B+Ubw5zMX6uHvAFPe5NuwW8lAIN969hDsNyQX5xNz/hg0JEg8eA
         avXhZ0F/mhePmLfF04rbFC/AVEV8KTqHXUZFc7TdiBY8mSff45adeXNyze07Rp1JWFFR
         FVMw==
X-Gm-Message-State: AOAM531qW4FDSXEZbsVYrbGi6+0Flf+CKEnWS9h4BjquByU3/mFEYon4
        TBN/FRFgC0gz4SO8ysqmWKKHcQPAUJpioA==
X-Google-Smtp-Source: ABdhPJwsyzAdOu3sK54bN8AMM0A9hsW2LuTVDRDlZf3q4D+el+ggs3OtAPCK+0fn9UbCPanDFgCizw==
X-Received: by 2002:a9d:6f07:0:b0:5b2:38e8:41f7 with SMTP id n7-20020a9d6f07000000b005b238e841f7mr783322otq.308.1650090330659;
        Fri, 15 Apr 2022 23:25:30 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 6-20020aca0706000000b002f9d20b3134sm1838928oih.7.2022.04.15.23.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 23:25:29 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s string
Date:   Sat, 16 Apr 2022 03:25:04 -0300
Message-Id: <20220416062504.19005-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220416062504.19005-1-luizluca@gmail.com>
References: <20220416062504.19005-1-luizluca@gmail.com>
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

There is no need to add new compatible strings for each new supported
chip version. The compatible string is used only to select the subdriver
(rtl8365mb.c or rtl8366rb). Once in the subdriver, it will detect the
chip model by itself, ignoring which compatible string was used.

Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 1 -
 drivers/net/dsa/realtek/realtek-smi.c  | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 31e1f100e48e..c58f49d558d2 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -267,7 +267,6 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 #endif
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
-	{ .compatible = "realtek,rtl8367s", .data = &rtl8365mb_variant, },
 #endif
 	{ /* sentinel */ },
 };
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 6cec559c90ce..45992f79ec8d 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -551,10 +551,6 @@ static const struct of_device_id realtek_smi_of_match[] = {
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8365mb_variant,
 	},
-	{
-		.compatible = "realtek,rtl8367s",
-		.data = &rtl8365mb_variant,
-	},
 #endif
 	{ /* sentinel */ },
 };
-- 
2.35.1

