Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D249F34A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346303AbiA1GGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiA1GG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:26 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BB5C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:26 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id c7-20020a4ad207000000b002e7ab4185d2so1223305oos.6
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vBjYNpzDA1g3Hu4DSh3sQR3rc29Wo18tFCXs2Z9M3CI=;
        b=PtzXwtjvUvXNPKkNBQbObntxASqBntSlJCw5SAW27+KZJBGlVJNqW9AvosKGo5O3j1
         Nu1iJKF4ei99xz91tzm54WiX1pA8hEFzdLB/AmSnPavHEPGurPGKXyADK6cenSO00U4g
         hXOf8d787REmKddINk8WKxiq6EQx0eQDFvqiVaTxE/9cSNiTbvfbij1Tm0M+AW4Wg9s9
         Ybtrn2+35vuM9iC/y4bX5Ps2UhxWQDXQgcseCdMhMJyPEmmBWBXmlVm6h1Ya5PmcsRR3
         ztdK+ed/l88usuvlc/Mkk7tAxJ/nrU3ydTOS53/mnSNd/cC4KaD0rHKPXKTDHBRcUMKW
         RaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vBjYNpzDA1g3Hu4DSh3sQR3rc29Wo18tFCXs2Z9M3CI=;
        b=VQOT88kldz8rsmShbOPvsahCQ8xmvP1o49vC+C4x+Xqc6ACVe/ojU5vIMZc2PW/p7R
         yJ6J8VX94+wW3J9DVbPjdGwHrSGJbgwCjcv9pC/tqjhSFOsLzUnKIRhVW/Zc4QNaj07T
         RQQKdGlWBhZImV1sPyiHQvRU5CBfTE1oN+pPZoKGGa5wH9uytBTqhEO4AhtXk+/dIAWu
         xiC7enEm8x/7Xxd1P/dNNzuuJTq/3IsuISCZEmaa/DQ2S3vQGVPyiXY2I7hjfnq3F6kB
         5gLQH2i2JSB0rGZd3hFeqfUWd3Ymvycg/Uvuakd0L6GGzh8TC4cpOb2zzkaHnjNC16Qb
         X/oQ==
X-Gm-Message-State: AOAM531rZKaA6Ii03+pOw6bDBgs8dOS73GLiad4HpzwBfgjsV2mMZNct
        /m1sw6IHNkq57B3mvX/c1lvDL/BlBaMknQ==
X-Google-Smtp-Source: ABdhPJzatYr+KhH+VHFmjZo4kxz69jjLNnG6BilCrQN1sTY5VbjpJ/3fs7KOPKmuhJTyYL69HNOnlQ==
X-Received: by 2002:a4a:c197:: with SMTP id w23mr3546645oop.30.1643349985323;
        Thu, 27 Jan 2022 22:06:25 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:24 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 13/13] net: dsa: realtek: rtl8365mb: fix trap_door > 7
Date:   Fri, 28 Jan 2022 03:05:09 -0300
Message-Id: <20220128060509.13800-14-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trap door number is a 4-bit number divided in two regions (3 and 1-bit).
Both values were not masked properly. This bug does not affect supported
devices as they use up to port 7 (ext2). It would only be a problem if
the driver becomes compatible with 10-port switches like RTL8370MB and
RTL8310SR.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 34c99e7539e7..e1c5a67a21c4 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1764,9 +1764,9 @@ static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365m
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_POSITION_MASK, cpu->position) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_RXBYTECOUNT_MASK, cpu->rx_length) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TAG_FORMAT_MASK, cpu->format) |
-	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_port) |
+	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_MASK, cpu->trap_port & 0x7) |
 	      FIELD_PREP(RTL8365MB_CPU_CTRL_TRAP_PORT_EXT_MASK,
-			 cpu->trap_port >> 3);
+			 cpu->trap_port >> 3 & 0x1);
 	ret = regmap_write(priv->map, RTL8365MB_CPU_CTRL_REG, val);
 	if (ret)
 		return ret;
-- 
2.34.1

