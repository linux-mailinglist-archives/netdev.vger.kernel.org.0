Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E916B5EE4
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCKRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 12:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCKRdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 12:33:16 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40598168A7
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x3so32950394edb.10
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 09:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678555993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZxuVpVebsRRraysHVEtopW/pRW+n6rrpYSxL3G7TSA=;
        b=tMKPN/0O5hiExIQzmUdM/nd3i2G0ghQ+pin+O8uUESJmlR1h3DD8OvmvNZEBkC8BFx
         rBh8zgXrwH3RArTVe8yXftf6Ar3BxqZSycY/MjqnkK9QaNOVsTBky3K8qo+yjWoWB3HT
         DXqU5AQPyxMwkaEMgypUS3ERBToIKsBxAWG5OkI9FbvEFqDpRtwsemVTrdxVZ4D4EGoa
         iP6IoifCjqOvmbr+ad57xelqN3xTwF/hyP8pJDoUjm7O/rC+tKbu8sFwi2/p0k9qOyiU
         5uYOHVUrT0q6s9o9p9Y2zuMKKq+IXGYtW5EUo6PVnwyXdtba9YBdmp7VQP9P3zrIeMMj
         oT/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678555993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZxuVpVebsRRraysHVEtopW/pRW+n6rrpYSxL3G7TSA=;
        b=8FhUPJPJHiYSIMZT4ftWwXWIlsNSLIQefEobdxf1dixSvJvlDpCaFruGyq+TpWRD36
         FyQqYXT4ZOR7VKE7CvK4Nj4bW8hVN3I4vtBCEtzP5HKARan+8ov4LSR3H6irLTSCldss
         xtmopzE87wsemqThcjp8zi9fcg+pSfbhuvTeGY97xJgbj3VKtCeTOUej2LXPcIydHUno
         zsXNn5CmADJDEMvt3A5A78LmDcB7/B4seQxvNbl+cKmMIPZ4676b4XJMz8ROpbh2GbQW
         8g5se9777eurkCHm59uBnTHjAR43MAjWAUxVGcDvUPmho+0GiaIiHwfJ8k1s5+09a1mb
         haDQ==
X-Gm-Message-State: AO0yUKVt8NuGYZuir8felCkbJPs+MmCblnEfo2kaBy/5hjPophVYA7Iz
        DTbgnx4d04JnZDKHPAPetq8wVw==
X-Google-Smtp-Source: AK7set+YXBuxIPUkydQd5TySLdyku2ej4p0a0d6fGBoTL1fEL0/yj69k0x70JsFAUDGnbbvJtselrA==
X-Received: by 2002:a50:ee92:0:b0:4fb:2060:4c24 with SMTP id f18-20020a50ee92000000b004fb20604c24mr1127782edr.4.1678555993534;
        Sat, 11 Mar 2023 09:33:13 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id k15-20020a50ce4f000000b004d8287c775fsm1440885edj.8.2023.03.11.09.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 09:33:13 -0800 (PST)
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
Subject: [PATCH 02/12] net: dsa: lan9303: drop of_match_ptr for ID table
Date:   Sat, 11 Mar 2023 18:32:53 +0100
Message-Id: <20230311173303.262618-2-krzysztof.kozlowski@linaro.org>
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

The driver will match mostly or only by DT table (even thought there is
regular ID table) so there is little benefit in of_match_ptr (this also
allows ACPI matching via PRP0001, even though it might not be relevant
here).

  drivers/net/dsa/lan9303_i2c.c:97:34: error: ‘lan9303_i2c_of_match’ defined but not used [-Werror=unused-const-variable=]
  drivers/net/dsa/lan9303_mdio.c:157:34: error: ‘lan9303_mdio_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/dsa/lan9303_i2c.c  | 2 +-
 drivers/net/dsa/lan9303_mdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/lan9303_i2c.c b/drivers/net/dsa/lan9303_i2c.c
index 1cb41c36bd47..e8844820c3a9 100644
--- a/drivers/net/dsa/lan9303_i2c.c
+++ b/drivers/net/dsa/lan9303_i2c.c
@@ -103,7 +103,7 @@ MODULE_DEVICE_TABLE(of, lan9303_i2c_of_match);
 static struct i2c_driver lan9303_i2c_driver = {
 	.driver = {
 		.name = "LAN9303_I2C",
-		.of_match_table = of_match_ptr(lan9303_i2c_of_match),
+		.of_match_table = lan9303_i2c_of_match,
 	},
 	.probe_new = lan9303_i2c_probe,
 	.remove = lan9303_i2c_remove,
diff --git a/drivers/net/dsa/lan9303_mdio.c b/drivers/net/dsa/lan9303_mdio.c
index 4f33369a2de5..d8ab2b77d201 100644
--- a/drivers/net/dsa/lan9303_mdio.c
+++ b/drivers/net/dsa/lan9303_mdio.c
@@ -164,7 +164,7 @@ MODULE_DEVICE_TABLE(of, lan9303_mdio_of_match);
 static struct mdio_driver lan9303_mdio_driver = {
 	.mdiodrv.driver = {
 		.name = "LAN9303_MDIO",
-		.of_match_table = of_match_ptr(lan9303_mdio_of_match),
+		.of_match_table = lan9303_mdio_of_match,
 	},
 	.probe  = lan9303_mdio_probe,
 	.remove = lan9303_mdio_remove,
-- 
2.34.1

