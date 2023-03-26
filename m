Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2336C94FB
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjCZOJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjCZOJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:09:02 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14015FDC;
        Sun, 26 Mar 2023 07:08:46 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 59so5038502qva.11;
        Sun, 26 Mar 2023 07:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679839726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gZ3M3RaLFnNGnHTnAZjnH0dZMMcYJsuKybc/E0bZ/Sg=;
        b=PeCR9X86QsaVx20aY4cZ/N/U/BGXc9v0DseOfWum4DxYo6HDHO24fXFQLN385sn7Ak
         ZnG+jG5QCzkpJ5OEPA4GGNujEszVt6QCOLJqDleCWpkO2MvcSaSYN9J7THCkRyhj7dy9
         P7Su8HM8g/fddSiIMePJNUY8gHW02b2wpKHcIcEb+FKDaXzhdb0AdbacaM/cIeruVxsm
         CZu38ZsgmVurt3yKyYDFLeRrUh8iHltb17BOTd27+2wzzJfAgtws7/vAybMOAgcnFh4Z
         bVXqgEIdaM2bEl5swVmeZPpepIvamUtvQXclBqIfn2V7fJmLVvHsibGC3GOAiXlzSqE0
         aAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679839726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gZ3M3RaLFnNGnHTnAZjnH0dZMMcYJsuKybc/E0bZ/Sg=;
        b=amkYmb+5iK4h+YWyR4xT+LbJjn88rvnNqhyQZiKwO7yB/QebncrSltp8MvHoHF9FJC
         +vGzyVuvWqTlEji/To8pTFz/cZUwxjXarATR3K0LlJAkqROL1mH4xoX/buSn3kQtbgZj
         q1GrDy6pAYveQJz6A8nat/CeNNeKKYnZFi+PnT9CCDCqYf31IacvmZa3I2YMK0ATiVrM
         yZtgxF1LPsyIhkCV/YAZQGLsVKVhr7LWZ4Gsv6NKau30C6KfL1lstKtibe6xYhv2d20i
         Ga1aklAHnZY/4DVFvIciKCSERD7mJuNDEwjAoRlUd6lsgRmIPksarLPrHAB53jhXD7DU
         GIEQ==
X-Gm-Message-State: AAQBX9e8zKb3cmwkKTHVIfVw3oznmMv46vpj1VcDfwe/fhGrjfMdbWx4
        POqe2KJ8qkd5S54Bb4qTOjs=
X-Google-Smtp-Source: AKy350bmLDXXIZMwWIHi9YWMFSuPyoUC5Stl7CpvUKVBBwX6hYz/oXixnBj/Ni0i+8VU4sVOQf3erQ==
X-Received: by 2002:a05:6214:f67:b0:5aa:d98a:8ace with SMTP id iy7-20020a0562140f6700b005aad98a8acemr17506531qvb.19.1679839725854;
        Sun, 26 Mar 2023 07:08:45 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id j5-20020a0ce6a5000000b005dd8b93458esm2212220qvn.38.2023.03.26.07.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:08:45 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 4/7] net: dsa: mt7530: set both CPU port interfaces to PHY_INTERFACE_MODE_NA
Date:   Sun, 26 Mar 2023 17:08:15 +0300
Message-Id: <20230326140818.246575-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230326140818.246575-1-arinc.unal@arinc9.com>
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Set interfaces of both CPU ports to PHY_INTERFACE_MODE_NA. Either phylink
or mt7530_setup_port5() on mt7530_setup() will handle the rest.

This is already being done for port 6, do it for port 5 as well.

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6d33c1050458..3deebdcfeedf 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2203,14 +2203,18 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 			   RD_TAP_MASK, RD_TAP(16));
 
+	/* Let phylink decide the interface later. If port 5 is used for phy
+	 * muxing, its interface will be handled without involving phylink.
+	 */
+	priv->p5_interface = PHY_INTERFACE_MODE_NA;
+	priv->p6_interface = PHY_INTERFACE_MODE_NA;
+
 	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-	priv->p6_interface = PHY_INTERFACE_MODE_NA;
-
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-- 
2.37.2

