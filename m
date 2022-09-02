Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1065F5AAC2C
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiIBKQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiIBKQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:16:20 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05309F8EA
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:16:18 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id az24-20020a05600c601800b003a842e4983cso1151003wmb.0
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 03:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rr5tzsHQc3yLS16O/BYAtf4/ZFucy1qvPc1kp4CmIlU=;
        b=oeWU+dXxsvUkkT0FKo7qyPeq8TWbpyAmn2qQDrRGtoY64WkTQYWnwZKsuMk5r5rJbx
         F4uXQMbaz5nAZzvN3YRcuO0u4GV5BUas2+iOseifSTJjchhtKQk+CcdIBtqVi6zvFE97
         2YRuGZfZ/2cGsnRdzvf76F4VijNwdHdD+MiLw1CM8k4LLhdhg+KiUdlWekUfTStO/i9L
         qejhosM9Nd15UXYhlmEHMBcXVonzZ9Ker/vt5J8Skp47vRAkvd1guA5L5jhrv0yJJQk3
         zEF9eCEmN10Uga3bfyM88FduaEyXJGbtsklKfwftCF6ViRIN2AS5Gc8IXXKLudBhC1E+
         VirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rr5tzsHQc3yLS16O/BYAtf4/ZFucy1qvPc1kp4CmIlU=;
        b=f/OqbEeSKU6nx4z2RmpEPYKQaPzzDOgZn4+lQYvedmKuLmXBYIJbky6hU/5fuAlwqG
         ODs4h9xTMztu/KkgVVlHioG+pYNm3M1xMH+PNQDl9QD0hgeO7Awr/Ev7KzvjOQ46/H+r
         eQXOIc2QtctFx1CPlgoqKOzgPMvlOGur3mXAU244BQn9NuPx4nQqgmsdYrPYM++DgD2O
         hCYfByPYIXKTuWQ77760RadU4JUag/fsig6mbO6AxPLSRtupj4XHjs96vOvEQQTvE/qJ
         rfCAQv+TtfWNQKlE94A6s5zn6rfsY3zdE8/txntuKNb0UZj13w9c6nOB5O1mERrzK9TW
         PSSA==
X-Gm-Message-State: ACgBeo3fRvO3tL2SHRCzKTrYW2nVOqyXUXKJtRf3ycN0uTz/PkgL0W+1
        OuTTPjWsyNnaaekmDWxwPz9FZKQuXpS7Bw==
X-Google-Smtp-Source: AA6agR7bxsSfxiCMcdUIfCQSmvV8TjUg7HmC087vIouytECa4QBtLFhAVSfzEgDAtGfke1K6HaZumQ==
X-Received: by 2002:a1c:e917:0:b0:3a6:85b2:e8d with SMTP id q23-20020a1ce917000000b003a685b20e8dmr2332591wmc.154.1662113777198;
        Fri, 02 Sep 2022 03:16:17 -0700 (PDT)
Received: from P-NTS-Evian.home (2a01cb058f8a18001c97b8d1b477d53f.ipv6.abo.wanadoo.fr. [2a01:cb05:8f8a:1800:1c97:b8d1:b477:d53f])
        by smtp.gmail.com with ESMTPSA id a8-20020adfeec8000000b00226d1821abesm1140913wrp.56.2022.09.02.03.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 03:16:16 -0700 (PDT)
From:   Romain Naour <romain.naour@smile.fr>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, olteanv@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v3: net-next 3/4] net: dsa: microchip: ksz9477: remove 0x033C and 0x033D addresses from regmap_access_tables
Date:   Fri,  2 Sep 2022 12:16:09 +0200
Message-Id: <20220902101610.109646-3-romain.naour@smile.fr>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220902101610.109646-1-romain.naour@smile.fr>
References: <20220902101610.109646-1-romain.naour@smile.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Naour <romain.naour@skf.com>

According to the KSZ9477S datasheet, there is no global register
at 0x033C and 0x033D addresses.

Signed-off-by: Romain Naour <romain.naour@skf.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 02fb721c1090..a700631130e0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -546,7 +546,8 @@ static const struct regmap_range ksz9477_valid_regs[] = {
 	regmap_reg_range(0x0302, 0x031b),
 	regmap_reg_range(0x0320, 0x032b),
 	regmap_reg_range(0x0330, 0x0336),
-	regmap_reg_range(0x0338, 0x033e),
+	regmap_reg_range(0x0338, 0x033b),
+	regmap_reg_range(0x033e, 0x033e),
 	regmap_reg_range(0x0340, 0x035f),
 	regmap_reg_range(0x0370, 0x0370),
 	regmap_reg_range(0x0378, 0x0378),
-- 
2.34.3

