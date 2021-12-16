Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038E8477D2E
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241259AbhLPUOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241262AbhLPUOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:45 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02820C061401
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:45 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id p4so84852qkm.7
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nyaeI1dMP5hxSYQTjdPnHMUJJP7nk2LadSzyKZMdgfs=;
        b=ljWZrCubVXNa6CZraeKmUAmy1VBsgBVOkQm4XXDKQ9uGzRgzGEd+WgnbF6oN8LVCPJ
         kBPF6I6dxr9MQbFgHrUScGa1Su/KhdxZLGSgBqrk+GJq6P1+Obs4+DnFzVItJFFki+fj
         /ynSVgOXEWSjRKNPlakFF8ph3RpZyB6r3ABg+T6Dt3t16aKLn8ubDtA4DX5EZxD8YQgj
         G0VWxSmWse8VLmZaxtvsNKAZelox+WDmDqaxLf/OwaXux3zSQ4xbPCiNmxEAERmdKCb5
         gz2PdBPDVFZMz+UQpKqj/jKc3qeTwobJwiOtlsm2VbbLGrcdQJqbhp7XAIyHlk62BTKD
         asIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nyaeI1dMP5hxSYQTjdPnHMUJJP7nk2LadSzyKZMdgfs=;
        b=cdQjzIV8ld47q5CYDhOlh456lbiH7zPllSwzK64wutAFkgoyjudCDWVXGO1k+2PgX1
         81mNXyye26qrPSKEj1ByEVJETf1UATMyL1Pd8D0tXeO0Ci1qwlGE82TP4FsuNFAlo8I/
         OUNfQXnjClUIWi3gNl8XmC0xNyiLojYlfSpclpfsyayxB1dL11+RM/3PkqZVldtDEQx/
         Pu+ECgu0IVVj7o17wH7NwYK7ZLbxJ3t2OtQ2N1gm1IaX9KhyVRVZZfA82ty3dWnUYRXJ
         V6MH0tYD93Yicx8I/hh2LKVftZW+4n9jMofbIHYr5hCToKq/CybCYoqF11rh0wjdhcK6
         dy3Q==
X-Gm-Message-State: AOAM5322lgQuHlypGM5cGf30bYYzowmx/x/LbqigscFzNAv/8v3lrazi
        0AfciFJA3YekXmrOCEuwDcMITR0EDzRuRw==
X-Google-Smtp-Source: ABdhPJwBI4lfh2gST4y63RNe5r8CNyXEknbw1Q4TOMlSCPZ0NkFhYxhoF9b7BnK0MI7/uyGumnAckw==
X-Received: by 2002:a05:620a:24c9:: with SMTP id m9mr13616692qkn.317.1639685683960;
        Thu, 16 Dec 2021 12:14:43 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:43 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 11/13] net: dsa: realtek: rtl8367c: use GENMASK(n-1,0) instead of BIT(n)-1
Date:   Thu, 16 Dec 2021 17:13:40 -0300
Message-Id: <20211216201342.25587-12-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8367c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8367c.c b/drivers/net/dsa/realtek/rtl8367c.c
index 6aca48165d1f..f370ea948c59 100644
--- a/drivers/net/dsa/realtek/rtl8367c.c
+++ b/drivers/net/dsa/realtek/rtl8367c.c
@@ -1955,7 +1955,7 @@ static int rtl8367c_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = BIT(priv->num_ports) - 1;
+		mb->port_mask = GENMASK(priv->num_ports-1,0);
 		mb->learn_limit_max = RTL8367C_LEARN_LIMIT_MAX;
 		mb->jam_table = rtl8367c_init_jam_8367c;
 		mb->jam_size = ARRAY_SIZE(rtl8367c_init_jam_8367c);
-- 
2.34.0

