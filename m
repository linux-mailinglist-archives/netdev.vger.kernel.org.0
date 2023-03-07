Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17A6AF82D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCGWDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjCGWDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:03:41 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7ABA42EB;
        Tue,  7 Mar 2023 14:03:38 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id j3so8738164wms.2;
        Tue, 07 Mar 2023 14:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678226617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JuDmDmY4IV0QLoJ1ArzJ4ijcazQ7ZD0u2S2wBUytaV4=;
        b=RNXi6CIgsswuyNAn64MCE1WBucMN/4Lb2cthlZw4x33sH4no/5WS9mQOMKrXlZeIiZ
         f4A2fky6gKi+hjyL07oPC4kprq1TCIoE9pRh0xDlCilqd4j35ULgS5rUYFFwQqiEgk6F
         dFcWPzK/4/j5+q0lz+LJNcsixcNJHCcPeJHy7Q16jEXU8Iah9kdiFgCzW3RAO+6OMgpi
         1mVqCP4Hx/9Ppg5oftc8FsrLtbcNvc4UboWlZ0RSzEkX/34eJ4DiE3nPssW7VrzWwjba
         7gssg+qqA46xyoQmNVnsXbI4zHB8V0fgh5ij87CA18eZoqDNVkGgXyIC0DfSgJUkYr/i
         m2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678226617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JuDmDmY4IV0QLoJ1ArzJ4ijcazQ7ZD0u2S2wBUytaV4=;
        b=0Z21xhCB2+DQJFszCyX2N30jqlziUxf0jnG3Kp+GW+7PEFEYqdo2Lp4eUrNK67XQR3
         5AZA4RqWlMTNDKQEmHYlIdmZhmbT7GX8SStutkuuPnYW4KxhNInnI5NDo0iUQeQIKsmQ
         rLU/jPyLaFfiHtfQS/GlOI3mV9OyXvyWoJALqG74hT/u6mxppeMZvPPASXWmLkN9BwvU
         YsgPBr2Q5Rxx0/R+wnWnQCRqGt91Xwnu1vi2313bNeFVaIJYZSThQWz30zlDSX+y4iM1
         gpdwN1bSjHFyEkdZ9+Ai4Asr3RdNz++KHlxXcmgYNYtUBNdlSgn2mCcB+yfRCeZ+YmwY
         7Msg==
X-Gm-Message-State: AO0yUKUxDCwict25pqP91jJle5CSPmVl/O7vCkxgu+VvIwkD9c4Qr3I5
        5gytuMh5s7taqlzEy3LM2YG8NMOYBpBKXuT9
X-Google-Smtp-Source: AK7set+nNuteaAJCPG2h+uXKJN36DhqNuJ1LM58JQ9dJYBDea2ahKspMS4VBH1MVa7s1gsdYprAUZw==
X-Received: by 2002:a05:600c:5127:b0:3ea:f01d:2346 with SMTP id o39-20020a05600c512700b003eaf01d2346mr14624376wms.15.1678226617227;
        Tue, 07 Mar 2023 14:03:37 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d670d000000b002c8476dde7asm13556735wru.114.2023.03.07.14.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:03:36 -0800 (PST)
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 1/2] net: dsa: mt7530: remove now incorrect comment regarding port 5
Date:   Wed,  8 Mar 2023 01:03:27 +0300
Message-Id: <20230307220328.11186-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
port 5") under mt7530_setup_port5().

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a508402c4ecb..b1a79460df0e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2201,7 +2201,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
-	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
+	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
-- 
2.37.2

