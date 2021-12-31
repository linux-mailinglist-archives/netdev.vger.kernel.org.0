Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3E44821FC
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 05:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242688AbhLaEe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 23:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbhLaEez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 23:34:55 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB6DC061401
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:54 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id h5so23820910qvh.8
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 20:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JTpPGoBeiRiM2jGE6s71hAaMpzMJvJZoE5UyHRCbt88=;
        b=Gjrp6e5ZtcG7g+GMJQOCBpdzzNWaHetbwAZWC1Jq/J0rcBiXv4Rm680hsHQt3LlyXL
         8AJKSJJuw3opXfSazvTre9kl2y06JIXkdUw0SXQU9QPlnjymPbxgMu8lAnNz9mifEaUx
         EqIfm/6ebmSKsqDaEtNykzpvpHbExMFImaf7Z8GTwJT1MT7RwaNtKCzOwzJ+30H5a0Jx
         KJg/0GWn7PFQFt9qcE0LCJgv0UhqRouw5IyjUo8ZjU807qeqvyfNWWZjoDTpbQfmsHez
         26hlnbXVXxoD4FKX0+KwNm8Zr8Fa3mQ9+nQdZiLMUyoiFlvZSBOBm8a13CtGlq2YIY1M
         8BZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JTpPGoBeiRiM2jGE6s71hAaMpzMJvJZoE5UyHRCbt88=;
        b=wqwCFNzuJBhB95l8zKuY/U+73AYyTLtaeRe/FndtISDg5DQgqxDvegxWps9QpEM63c
         asfOCC9eFFpE57OZdpNstJh2KOnl50frhJHoWfcqTUqBBNYMAUzf25sJB1Ia4fVuW/ON
         rb4GdWJDgc+FbA4UYMx/I/HEad3kKr4olOLRUumsyCsYhVRWnn6BishkAHKQYSF+0Q/F
         Slifrv1t+DJJ4gBVW4VNmSFClR2pz6Y/QA3GFhHq/xEDWDcQnEVwHgKd5Dd/3tgDVDPa
         6IHhts86eusZHPEYZSeOvuV3vc6BkNQruPMfjlzVgnsTIs9GKwyZkzRAIyEN6OEETEoL
         JTCQ==
X-Gm-Message-State: AOAM532xefF/JGu2MQ1jMUq24+4BnTgEAKwTjlvfymAjjx4xx2/xRJLU
        z3fD1XkLQsjs5gzNtQlitMTCMtFvu1OwI4EP
X-Google-Smtp-Source: ABdhPJwbXfgufxUl1iL+FWxaNA1mfI7VRpXfffzZhg4kJbErTsKojGufl51f5Vw1Fg1Tg/ezuWC78Q==
X-Received: by 2002:ad4:5fcf:: with SMTP id jq15mr29817585qvb.0.1640925293990;
        Thu, 30 Dec 2021 20:34:53 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id i5sm8020030qti.27.2021.12.30.20.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 20:34:53 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3 08/11] net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
Date:   Fri, 31 Dec 2021 01:33:03 -0300
Message-Id: <20211231043306.12322-9-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211231043306.12322-1-luizluca@gmail.com>
References: <20211231043306.12322-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e115129cd5cd..b22f50a9d1ef 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1973,7 +1973,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = BIT(priv->num_ports) - 1;
+		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
-- 
2.34.0

