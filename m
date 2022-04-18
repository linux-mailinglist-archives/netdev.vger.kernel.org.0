Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9187E506048
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiDRXjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiDRXjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:39:03 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FFE2125E
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:36:23 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id q129so16418006oif.4
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6J3ecYFHWqnaENNBasINK4rCLNlZJW9ysI1Bv27bf4=;
        b=F8S0dd3fM88Bl747EAP6b5KVTx2QBb250piBejarrfWT8GhUkJWhTIZTDjF3DR+EN8
         tl86YvtQvlJD5K/Yq2Bg6nWl3O+JsIdaunLf9ZOMI7kdxqVabS4xAFkm/JTUYE1P+rwq
         uBa0XOZJ1oa9aLndQCOMtcRtrW+hb+Cdhe//Vv+F9DHPfH8dKdquEoZtBvq39wgF2kVR
         A5zJ/Kn0Mo8zt6Z3fxE1yJ5yWP5Z+feWM1T6nO9TvTdR+uvsCx09t2KzeGFdSI4DAjR6
         FHQlh2tsPgxlpXuJC5bQDH2wdgvY8g47EWSFMFCz3GIAs6MWzWXqo55VSdSq6+M2Fm0A
         +zwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6J3ecYFHWqnaENNBasINK4rCLNlZJW9ysI1Bv27bf4=;
        b=ZaP+8WxPF7QK/x/Qy1Hw/kJKUH2vsNKfz6dHOlAojurLsFA1uUJK2mZTYPViVZdLTv
         KlDjoSPgcdtyEKgHlGyo+C39lXKFsH0JOKBvt23NL1S7o1qq1X9rTNSaheX1JQlk3Umw
         ZnVLOeJLX5mCpds5fy6AXpFEpqM/61ZzeNOZ+cagKxsUfJgyjZE3ufc6/mGztIfFhBnG
         sEM+WrWBN14n59k23xzVGGAB6eZpo7jR9n4FGvuWMaAVO2fLTfwKO5uJftnTh48onCOL
         QtVL+H6ZbXh8MULJJwvA1KSkBiaDgSJNzEidX5KA/gXihgt0AWr4kQBZgvDtxbtQYkNC
         lTEQ==
X-Gm-Message-State: AOAM530zE3hxz3ADY02m/1yj3wOV07giOta71immsgfj7kNBbiK+JTbK
        0d07kmxUum+QM+XEdwq0IbZGqwSpr6eaWg==
X-Google-Smtp-Source: ABdhPJyl650RS1S8ncTg43mq0ZD506aWc0vvNNXjUmrhEuHowxwz6ll34mt8GlhOJmCmlgfwyFpe8Q==
X-Received: by 2002:a05:6808:1884:b0:2da:5cc2:2bbb with SMTP id bi4-20020a056808188400b002da5cc22bbbmr8303072oib.72.1650324982078;
        Mon, 18 Apr 2022 16:36:22 -0700 (PDT)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id k14-20020a0568080e8e00b003224d35c729sm3674179oil.3.2022.04.18.16.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:36:21 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net v2 2/2] net: dsa: realtek: remove realtek,rtl8367s string
Date:   Mon, 18 Apr 2022 20:35:58 -0300
Message-Id: <20220418233558.13541-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418233558.13541-1-luizluca@gmail.com>
References: <20220418233558.13541-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
(rtl8365mb.c or rtl8366rb.c). Once in the subdriver, it will detect the
chip model by itself, ignoring which compatible string was used.

Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

