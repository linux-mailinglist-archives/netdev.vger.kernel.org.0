Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFF16EAD24
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjDUOh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjDUOhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:18 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D49BC654;
        Fri, 21 Apr 2023 07:37:07 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94ed301bba0so288260666b.0;
        Fri, 21 Apr 2023 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087826; x=1684679826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnhLc2FNX94+xwHWTwQbzfts7CiDXWRNDdKOnOqCup4=;
        b=ZfplyYY8FBBsOYOz/1YZN5onQ7ZolL5O8v8pYM0BkG79g3XCnEc0ii9N2n+Swi7ZCp
         JG2MDFq3850J8mhyqBuLlLqlylW3jYjVgrenC1kNRL10/sMeF7TfAnl15iRRakJGQucA
         9qqoaxGkk5PqT15iI1IxUGTt3GDyIsYobss2f0KXQYr2zR2h2Deq/TA0YykhXe7doJSX
         vqZTXq42eVbNh91sxsRsN0MZbwL0JSL9hoz4HKbz2fOu/PuJ5cH5aP5XN392g/lX2a7u
         n1pKXrKaZTgmJ0AEmySAxEnYhiWz4VQrumuirOmrqXra5KcfFB4NXcU/iuhTS3kNNpTe
         0oBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087826; x=1684679826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnhLc2FNX94+xwHWTwQbzfts7CiDXWRNDdKOnOqCup4=;
        b=l+ptUk1aDP4mLwJOfFAvhnPEnUgAJNcFmxMyUjbx8Q6hYV4UT4qevBW8idIokcloOA
         d7k5V5cy9ljl9HjAhpy7getV8+1X7WmpzJZCMUkvZ7VKGfUoccp5ec4ZAT9tcHIplJDE
         G30HfBBN9akbJPWDhDNJkJO+O0ZAoBbzGc8N6CsDtyFGUo0yDzxlLxWhr/nr+iMOCgIB
         wY7yyyO6POEIhTxotscnteNvjw4P1l554eZ4YbiFfc6zkSjhtt42wZmPd2QzpKZQWRrI
         XxThVgyPoy+1lQ5esuno8B+XbFC6325VSwoMiQ2/fMVVjjo6fkJiOaTWZuIxXKfd2Khu
         FTjQ==
X-Gm-Message-State: AAQBX9cVwdM2e1RLHEuBv5Z8HOM0SXGBdhY1yqQrR22zIwN0cjHROeA4
        pYDbvyhmnERYjO+WnjqGQDA=
X-Google-Smtp-Source: AKy350ZqzYQrqGoBR9DHsnACsf12BT62R4GZLXzYkBwQJ6WLs1oUkD7PNNKFL264rZDENkDoVbhmNw==
X-Received: by 2002:a17:906:8993:b0:94e:fe0f:b2be with SMTP id gg19-20020a170906899300b0094efe0fb2bemr2213016ejc.14.1682087825965;
        Fri, 21 Apr 2023 07:37:05 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:05 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 05/22] net: dsa: mt7530: read XTAL value from correct register
Date:   Fri, 21 Apr 2023 17:36:31 +0300
Message-Id: <20230421143648.87889-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

On commit 7ef6f6f8d237 ("net: dsa: mt7530: Add MT7621 TRGMII mode support")
bit mask macros were added under the MT7530_HWTRAP register to read the
crystal frequency. However, the value given to the xtal variable on
mt7530_pad_clk_setup() is read from the MT7530_MHWTRAP register instead.

It doesn't seem to matter as my testing on MCM and standalone MT7530 shows
the value is correctly read from both registers but change it anyway.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e956ffa1eea8..30553044d4b7 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -406,7 +406,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	struct mt7530_priv *priv = ds->priv;
 	u32 ncpo1, ssc_delta, trgint, xtal;
 
-	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
+	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
 
 	if (xtal == HWTRAP_XTAL_20MHZ) {
 		dev_err(priv->dev,
-- 
2.37.2

