Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542446EDE12
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjDYIbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbjDYIat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:30:49 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CE47EF1;
        Tue, 25 Apr 2023 01:30:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-505035e3368so9425919a12.0;
        Tue, 25 Apr 2023 01:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411407; x=1685003407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tfx+BLJ2lT7W1hbyqlRkyETFUUJ2bPA0crwpD9qp128=;
        b=lZ86hWU04mqxssyBsem/asz8Vblm4BlcY+EtZFE6dNEGktzls4r3kDlzKQwLR1TdGL
         yh2JVg8uFn2wmGxT97pc16iIJcFEjFkNIvZ53K9aYOXT4lXDB4tATbaNh0cL+keRKc9v
         lVKlxpYEkFeqr1dtSZa84/DzY6AjztgSKrpEqZh+hHTVRX6wAy3gkmHMBaQ2vZjCbU5h
         jnP8sqAQ0ek2XpIbBALycsChBgYaQjewRe5/j6VnK1INVv0xGTcgYF2l0jBgIe35SlTk
         6gy7iExOLnqjRIiqgEbfxMnlOrsKV8sKBhwtn+V1L+9ClSZv0GzJxYhqoT8MCK2mZU7P
         e/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411407; x=1685003407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tfx+BLJ2lT7W1hbyqlRkyETFUUJ2bPA0crwpD9qp128=;
        b=eiMBTU55CkHLUNYf3ev2MEff0dMAW0VkuIG71z4mFEG6xrq1iP0AOKsQ2CDn+l5vFi
         gdsqkeZ7TtjpicOHgTPvjTUz7BE4521YZY8CAGB/ZzrgfcAft1/4pGfH5H/vwnxjYe2k
         nDinD18PS7e46aTVmZ3vI/Hc64/IfZ1wcavkvrzxPE83ACXkAxx/AU+rcbh1eh78xEbz
         w8RuvNIZRk6sB01X7zjBSqYPFq8itXSiJlqeiQIvfR6+LaoXGKCXTCXDIpNv59Ln/GQl
         LW1dcnPkC/NLVF6ojlWscrYq/Qymtelh8yDvK5Ph+CCZnXzC+1onbu/HarmuYhU1It2m
         gXWA==
X-Gm-Message-State: AAQBX9dAvrsQBlYepnqJJBEgl+A9w/UZ0FX3MZOvNd64kDi/jAQ5oMNd
        2N4sKLShwEoO7FNevJwPaOQ=
X-Google-Smtp-Source: AKy350ZD6hZxk3RZBq4dVJ0BB2vezChvZmKmMxTOeiV4iOmfOvMgxynKFkCZYPOAMRNP2pPpfHi9Rg==
X-Received: by 2002:a17:907:80ce:b0:959:5454:1db7 with SMTP id io14-20020a17090780ce00b0095954541db7mr5667977ejc.3.1682411406637;
        Tue, 25 Apr 2023 01:30:06 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:06 -0700 (PDT)
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
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 06/24] net: dsa: mt7530: read XTAL value from correct register
Date:   Tue, 25 Apr 2023 11:29:15 +0300
Message-Id: <20230425082933.84654-7-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
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
index d0eae8e8c41d..98ef5ba0b19b 100644
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

