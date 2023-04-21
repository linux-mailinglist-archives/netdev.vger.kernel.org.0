Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59AF6EAD36
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjDUOjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbjDUOiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:38:46 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CFC146F1;
        Fri, 21 Apr 2023 07:37:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-506b8c6bbdbso2564776a12.1;
        Fri, 21 Apr 2023 07:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087856; x=1684679856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJixOmbyU63hr3o8Ny5bPEY6KG/MRULhsuG3NEyY2DA=;
        b=Az8QzgGdCSu60O6ATgA/rltMAPtJHOIM/fNgqvUDwljrF188OKCwkUXZsu9TgceVlb
         XJkSkwuYk0q0LODKP0Ys/gPMEnMs9C7UjYnIRN2N2nUjxcSEfGJV5UOJaNW14e4cnTYS
         YYp2rdotxte5IvfGjycuGpQ4F0+Bt1P7PL7yLDSziXrWL+u+6Mhk9Y28soqpLcZy2kyl
         a7qeOJUJqOqXZDshLZd/zrlM0EyAayg+R+R9eZLdjHd+ki27hhuw/u3u1c3kY2DzOkpQ
         slACzNFllLRnXORAQTxHP8XqHNQ5mNJVS40wnXF5bfsNVrvW0XRlQPB711YFwXXbW8rJ
         1lHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087856; x=1684679856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pJixOmbyU63hr3o8Ny5bPEY6KG/MRULhsuG3NEyY2DA=;
        b=KSFeu6suJF2oYKV+JXYTRU41t6eAa0sra7p2HoYAUQC5VKXF8QRK3T2NI4Mz/Y+sUe
         hvht1Px5j6fUf9acrsaYYXISVxNwlxsive7oRif/rTf6vFcxArQsZia/BoPwnuT7IYMh
         ltB66TFN/epHQ4aLgB6zF3lF80wM7+bEWOmD/l7X8psPWuof09LGRxDn4GJ/v1vnLMr+
         M1E+B+DtPwmZViYRp552SNMkyKGDd8sZAkId2glRIO45lK++szi9DTLsgqmFY2PjXpaD
         iKAJ/VfyWJM6rCa/gGPFccuDVJTzfhCgfGj13+n+UqpIOWe3VPe5HN3OeB1HMrYEJG8M
         PbGQ==
X-Gm-Message-State: AAQBX9dpdMjjpuOPDvWvuqQcT4Tp9p+ca8iJHbtoE0PCSUPKKZsNtXyh
        +1GFguuIiue7t1GAXoqfV0o=
X-Google-Smtp-Source: AKy350Z4aXH6j521XmbeT5SJQ3g67clUrR3I/0wqCunsH6aDT41k5hSTcXbseqGcd/WUsvruZjAStw==
X-Received: by 2002:a17:906:250b:b0:94f:a309:67b9 with SMTP id i11-20020a170906250b00b0094fa30967b9mr2483806ejb.6.1682087856476;
        Fri, 21 Apr 2023 07:37:36 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:36 -0700 (PDT)
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
Subject: [RFC PATCH net-next 19/22] net: dsa: mt7530: set interrupt register only for MT7530
Date:   Fri, 21 Apr 2023 17:36:45 +0300
Message-Id: <20230421143648.87889-20-arinc.unal@arinc9.com>
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

Setting this register related to interrupts is only needed for the MT7530
switch. Make an exclusive check to ensure this.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a66a762cb5db..ac1e3c58aaac 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2034,7 +2034,7 @@ mt7530_setup_irq(struct mt7530_priv *priv)
 	}
 
 	/* This register must be set for MT7530 to properly fire interrupts */
-	if (priv->id != ID_MT7531)
+	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
 		mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
 
 	ret = request_threaded_irq(priv->irq, NULL, mt7530_irq_thread_fn,
-- 
2.37.2

