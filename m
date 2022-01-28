Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B649B49F345
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346289AbiA1GGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346280AbiA1GGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:07 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F69C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:07 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id b186so4324893oif.1
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bdc7sMQ7YYNM34XuUwxlD1Zrtl6FVAqWc3bOBcfM+T0=;
        b=f6/udWQYhV/mlGrTFx0aRhrRXWBFEqg7TKoj8HtZElntAyF/H7iE9/Zcp3X9HoYUC0
         qfTYnNVfLc3lb0pJ33GFyswPbcuaKOF28O3KD7wu8S9eeb1SM1/SuScTk3YlBHvuwOko
         Z2SjyjupIG5eurjSo9h1GwJMzij4uuyuibwqRUqVDQ2rtkcVYAvZF30ny8FSJcv0O/fd
         u8PbmIw//eeFhsGiJhtCdkfTrwOK945XxCUTe1syExp35ETgvoXkE/znyDIphx5CbtXC
         k521R2KfKu+8mpHee0odx+2af9GLEX47S7kezbE9lRyw7LJj+SGYp4oNjrUNcJeTVZdB
         Aj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bdc7sMQ7YYNM34XuUwxlD1Zrtl6FVAqWc3bOBcfM+T0=;
        b=Fgrp45kps6QC3iWeWmvzNGCZkrUSIPrNTWqtNWmGe0gnSvudO947jnhBsWINJ/SiwU
         +K8+yNEIHdM9V/vv8XymxzuWcHMQRba+ChihZ2t9wyWr2XVYVYAOkolxpALotuaGB7+7
         +mwzpS4snn2IVsK4MeBvIe1C2rKLqT+x6mVldklteEaTdnAiUOpxK2m8O4poQxlCHUrB
         OBnhYfuEOEvUsPprqct5m0w59dr2aOe5+584wsBmCJOCfKs5q0p8AkHzAevaRHDU0tWq
         H3xUUBUoAAtVbUItr/rjFXbSnoXEkqgSot5EEMvoIua5zKxJSz5hin9fCs5Hlmb3ltfI
         b6Yg==
X-Gm-Message-State: AOAM531DExblk5N826jskIvlbiKbo9AuzgqcwmizmkYL4ulJnpw7EuLr
        RjB19GXwEPB+TJeqtgvH0yED/zU6zcjt0w==
X-Google-Smtp-Source: ABdhPJwJRsSeGNYWl9JgDi6RZMgl2ucPQsw0OpOpBbHEXg99Rjk+TTN4eM6FNAFtzDsoGSrYvtM5UA==
X-Received: by 2002:aca:3f54:: with SMTP id m81mr4327881oia.206.1643349966388;
        Thu, 27 Jan 2022 22:06:06 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:05 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 08/13] net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
Date:   Fri, 28 Jan 2022 03:05:04 -0300
Message-Id: <20220128060509.13800-9-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 8bffdcb99a3d..c2e6ec257a28 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1968,7 +1968,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = BIT(priv->num_ports) - 1;
+		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
-- 
2.34.1

