Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4E4484CCA
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiAEDQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiAEDQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:16:10 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B41C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:16:10 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id f138so36904947qke.10
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JTpPGoBeiRiM2jGE6s71hAaMpzMJvJZoE5UyHRCbt88=;
        b=cYzs9p87wEIzhhN6+Bng4aELxne2yx5lZMpujHL6YW6wP8+++xusRbrDci6G13kv9G
         NC8kUt+Fse5mqldObkU+ji010iuCoDhc1Gq3Onbz9vnwtPlr11x3Ix/MeYPMJEdUBFDe
         lEwnsCYAwXJfyPiiQ33QF7k/a7bHbldxKSskpW5mbPU6tiW5KNS+xpuoKmNv7J+ZGJRO
         7ispRkFZkyCXcC5bNG5NqI8keM4rf9XaqB0iZnUQT73j/gczBcfoe3PIxUsNPfr9qXJz
         f2MbLVy0ly1L9jrP5X+9XkZektdxXa4RTXUMAlr7SA0cwtrn8z1qZxRmL/Z7eKw//GOe
         pwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JTpPGoBeiRiM2jGE6s71hAaMpzMJvJZoE5UyHRCbt88=;
        b=3nDhvj6q1P1VPHkSrE6jESQHZbDZJwYCAqc9oYb2ZeaNdYswNg4h6VM+JLvbCzJgQc
         ajHYjlEQdTwMOBXOtU8aT2wOOyl8m2MsuJIHNXhe8ZjPCCGMHRQHI+3cQLNsiJDLTg/I
         Bk/eAQGj0UX09T3P0kVxAdORXJf0uJ7XoViRavTiMOgyVfQMtJv6vSa0Wrq6rkQwBzEU
         Hk5nTeNsBgYdVIzz1UqTClzztFZ202Aljaq6tdKiIt1/KzYgxKhW0MjPNXxwaoqJrtvU
         XdjbmWaeo1T6TjfinkG6Rg7ilBaDJdNaZt8mnEk9k5vNQbuRIeSN+tc/gDfjv4+VlOIJ
         zoCQ==
X-Gm-Message-State: AOAM530B67314MxCSitrtS323xEU9LXLOgtgo8g2nrpUF5qN27Ksf6ol
        Ydhazytu+0bX7wMyZ0sUNuGuk1+eso/WQPzw
X-Google-Smtp-Source: ABdhPJy7YWSxg4A2NS15kxA7yWIb6DcQxldv4Dnm+sNWzOTCZG5f0FsA14t+PRwaFjVNfaeGiu5www==
X-Received: by 2002:a05:620a:460e:: with SMTP id br14mr37652461qkb.533.1641352569412;
        Tue, 04 Jan 2022 19:16:09 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:16:08 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 08/11] net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
Date:   Wed,  5 Jan 2022 00:15:12 -0300
Message-Id: <20220105031515.29276-9-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
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

