Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0FC6B5EEC
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCKRdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:33:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCKRd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:29 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBBE2940C
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id k10so32933031edk.13
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678555996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cV5jhwqAFb9J/sgkVfjUP7KhaalS+CKZT6hVt29t4R8=;
        b=MYvjilFcpCdittD302lL2YjMwJ2qvaM+TOfrxTuATwXHJ1CfzEjqOmvaSvScCqmkin
         pTnDZ5d2rOiT4dU1dZdXkgCPw+Covleytz7abYY23PlkYjskdqFG39/Y7ZSCIpoxgXlf
         PeXzpD5kSyI+JJmWgeCFORKW1S9np8HnYzatbTyNAthhVQzk9si2w3X8tLVL3QW+VvVZ
         ucE+S8IILRThkeL4sB1bDjwNLZa/k37MagG/E41twesL3QAeTRhWuv+B7FtdiicQVIW5
         7m7opj8Qi4+juTxzE+C0FUuMelNeoewwPeqTez0Fwm5ZNQR0j+3L6jIcetbH+ngR/aLF
         V6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cV5jhwqAFb9J/sgkVfjUP7KhaalS+CKZT6hVt29t4R8=;
        b=BG54dvkFs6tNPi7ty6NFzzhRJiD3BztjlX9b+19qBT24dFrVSbKuvhoDJuoFrgfTUy
         iW58jhegjraq56ngR9JOKbew9rfaaL+fHce9DS5wwHoMvwWN5kWfqD8m86F37078YdPj
         bqBi98leeoDDD+Y9yNgO6+CGwWIp/8k+q79aNBCB5/9xvhqcEoocvYA8T3NJpUrH3g+9
         Swq05qOyb3RVatsZmibUgzuNiFpaNCtpe9zrdLH7aZ46rGCbqIqC2R4Gq7RnlrVfituv
         VICW6lh77JsM//hS0HHUmV3sl9hD8vQlSslVTa+KI4Ve3tCQCqu3VHokKEhkfMGEYiTo
         Hlcg==
X-Gm-Message-State: AO0yUKVXSpbSmcUd/XHlXTdcwYEODqWJzBiZpfMruwHE6YD35OL7d50X
        7LSlo3uVIazxKu1J8khLsFrgWg==
X-Google-Smtp-Source: AK7set/PA0/E9yFuXJbNrBsBaZOrTV+sx32D7gEew2JFPqh8HWaLIK52psR0MV7S5RRnbLvgEyjCBA==
X-Received: by 2002:a05:6402:35a:b0:4ab:4dc6:6f8c with SMTP id r26-20020a056402035a00b004ab4dc66f8cmr28767868edw.4.1678555996559;
        Sat, 11 Mar 2023 09:33:16 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:16 -0800 (PST)
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
Subject: [PATCH 04/12] net: dsa: ksz9477: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:32:55 +0100
Message-Id: <20230311173303.262618-4-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
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

The driver will match mostly by DT table (even thought there is regular
ID table) so there is little benefit in of_match_ptr (this also allows
ACPI matching via PRP0001, even though it might not be relevant here).

  drivers/net/dsa/microchip/ksz9477_i2c.c:84:34: error: ‘ksz9477_dt_ids’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index e315f669ec06..97a317263a2f 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -117,7 +117,7 @@ MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
 static struct i2c_driver ksz9477_i2c_driver = {
 	.driver = {
 		.name	= "ksz9477-switch",
-		.of_match_table = of_match_ptr(ksz9477_dt_ids),
+		.of_match_table = ksz9477_dt_ids,
 	},
 	.probe_new = ksz9477_i2c_probe,
 	.remove	= ksz9477_i2c_remove,
-- 
2.34.1

