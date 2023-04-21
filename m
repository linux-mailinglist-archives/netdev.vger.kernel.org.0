Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02B56EAD33
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbjDUOjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjDUOiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:38:23 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33E2146D4;
        Fri, 21 Apr 2023 07:37:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5050497df77so2590070a12.1;
        Fri, 21 Apr 2023 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087850; x=1684679850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZ8YgUYPk1BlgEuRR44l+Fg104ZW02BZsA3SV8H37Js=;
        b=U5NHcKalC4+8sMwdwp4mGjS2snuxVPW3Sugcax6GJMa+CeydeXKVqrErLFqKrDVhVN
         3uNX7HHL0dyhzkWY2Y/lc80X+qcMts66PadQIDeNLn/hvpm6un2kHwLRz14Jv0JX/2Vl
         lNnKIvyDaIjxleo+ixSeNoxEPUcOwNvxMJ7860/DchZ/nUQnNkMNBj4dK+bD/UQvgoRN
         bA/IB4W/AvS7ZYwFC+JWqhbFS/zwsFQyV3REmIlx356/ZbBSRPc8QOJcIup1ZLcmxcK+
         CgGqdv6/WM4RuOi1zpaFuMyrTpym1krNVMGyZl3ztXQ43Tyy6rSP1RRSOY+fVgWnP06T
         U5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087850; x=1684679850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZ8YgUYPk1BlgEuRR44l+Fg104ZW02BZsA3SV8H37Js=;
        b=j3Zzyw4unjEviEsWCCLr6yCnhZAOWQDD7yhquCYG13fCf1U8uXjmppMSv9aW6zHgdm
         l+4OPs4xUhB6T6TZfDvpE4nTFxKw/4sIhGn2+neUWg1YtqMAxc7xzRMhD7eIzOBJjiuY
         UmYv87CZyNL58GNnIHl5RwQNLWXfXDKEvTlIAyhfq0KDz3IhbWx8PJhsdoumjzHAStwT
         DNMAI6o4wHPMabgSynGBx6CYeBzgFWNvP7Uqp/TlYNKdp6+NyOGLYp0KEvqsp0T8uEy3
         LgaTte+Ywt6sktwBf37tkPcHQzADhsevUVgWE+1Ygg3W/DT5DmGb9Kp8oQqL88U8LXLr
         G8sA==
X-Gm-Message-State: AAQBX9d0mklPr7xzBJmnQnX6bLZj4HxRVSjN+iueGNu/harEYJd97HhM
        kMsWlDTfF72WB+8fUIdi5uI=
X-Google-Smtp-Source: AKy350Yn9RipJy2SbwmUEVL08A6pIXKIY+5qeS1WhOyzZ8b43mMhNv+4vGwG7GeisZVmC8rSXNgzdg==
X-Received: by 2002:a17:907:9603:b0:94e:6dc8:7ba7 with SMTP id gb3-20020a170907960300b0094e6dc87ba7mr2959685ejc.34.1682087850021;
        Fri, 21 Apr 2023 07:37:30 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:29 -0700 (PDT)
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
Subject: [RFC PATCH net-next 16/22] net: dsa: mt7530: move lowering port 5 RGMII driving to mt7530_setup()
Date:   Fri, 21 Apr 2023 17:36:42 +0300
Message-Id: <20230421143648.87889-17-arinc.unal@arinc9.com>
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

Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
driving of trgmii on port 6 on mt7530_setup().

This way, the switch should consume less power regardless of port 5 being
used.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 029d3129bb8b..5466259fd99b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -938,10 +938,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* P5 RGMII TX Clock Control: delay x */
 		mt7530_write(priv, MT7530_P5RGMIITXCR,
 			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
-
-		/* reduce P5 RGMII Tx driving, 8mA */
-		mt7530_write(priv, MT7530_IO_DRV_CR,
-			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
 	}
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
@@ -2214,6 +2210,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower P5 RGMII Tx driving, 8mA */
+	mt7530_write(priv, MT7530_IO_DRV_CR,
+			P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
+
 	/* Lower Tx driving for TRGMII path */
 	for (i = 0; i < NUM_TRGMII_CTRL; i++)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-- 
2.37.2

