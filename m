Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198D46DAE46
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjDGNth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjDGNsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:31 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B56B456;
        Fri,  7 Apr 2023 06:47:04 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536af432ee5so797706457b3.0;
        Fri, 07 Apr 2023 06:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jp4sFg0ojMV8MMU8A9Bkb7JvDbiYw4w687Rv39wQaSk=;
        b=TOUhN1sw9413O3hvkXKi4tiAzKCWvOwluTbxluC9j8C88WblzhCbho/Dk5P4XAU1+P
         ZubFWkyOtYOZtW/AxnhI3a6nI4p0P5f9bfdU8WUdmbYbHU52SjUvLxH+0xNzZw7esrBY
         l5nIjm5+OScM8+L85jpJn/j7bvDdZ3Ro0Kgki7dPysXovQrmRBx7zAp56l3CtQBNgl58
         mntxIIvtL+Ey+Gy4AXWY3up0oXMwVTJ6VvIAKNtLtuxEO4SJF/x6bHmAA9hM6Y85n5Od
         GKEHPPnWS+YmjplfK2EIwLbSJbNJCSD64VoAHgO+EaEogHy+xjLQ7bpFXOabnHiGHAdB
         LgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jp4sFg0ojMV8MMU8A9Bkb7JvDbiYw4w687Rv39wQaSk=;
        b=PZ7EnHzn06hyIZIs3+XpwZ4ZkiKpy2fKkj8xICfGPvBCguPFxd9Z8TUovz0wKKyvLs
         cjoen6N368hqkdexDSVpQSiJaU2e1RubeSfgjyvrM9a6Al/VP7YEcDTeUMHiLIHqq/+s
         ajig9lFWw7GfshcbJfjMl8hakpuSREv/ddY8gBwvrZL60NCUpL5Dw6rSpXMV/7s2THwj
         t2dZ+fjLVPSmVDv5/sRrZW6mNkSzQI3h7U1gYlTt3hb76b8rYU4450F5giwV8PV1+mtd
         ayLGOkv7v3yac2CFou+VGvOA5NsHmimvHDrsUv+LsmYlNb8j0gdijtjYHh024OCg/ZTU
         joqA==
X-Gm-Message-State: AAQBX9civIMJ8deVcgc1OIRoJxxrsXWC3ElvwK93Vm1YnBv3PQiYtFPj
        Fx1VvRtmbHsCjyQj+bOKXos=
X-Google-Smtp-Source: AKy350ZxZrKR79Xeu5PY9amkfV1wtIIIAzQArYlQx39guZ4hS+Y1gQEZVhjtgxGtIkelIQsB8n3fpA==
X-Received: by 2002:a81:918a:0:b0:54c:2852:d9a6 with SMTP id i132-20020a81918a000000b0054c2852d9a6mr1970355ywg.27.1680875218195;
        Fri, 07 Apr 2023 06:46:58 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:46:57 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 05/14] net: dsa: mt7530: remove p5_intf_sel default case from mt7530_setup_port5()
Date:   Fri,  7 Apr 2023 16:46:17 +0300
Message-Id: <20230407134626.47928-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407134626.47928-1-arinc.unal@arinc9.com>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
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

There're two code paths for setting up port 5:

mt7530_setup()
-> mt7530_setup_port5()

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()

On the first code path, priv->p5_intf_sel is either set to
P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4 when mt7530_setup_port5() is run.

On the second code path, priv->p5_intf_sel is set to P5_INTF_SEL_GMAC5 when
mt7530_setup_port5() is run.

Remove this default case which will never run.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fccd59564532..8a47dcb96cdf 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -943,10 +943,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
 		val &= ~MHWTRAP_P5_DIS;
 		break;
-	default:
-		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
-			priv->p5_intf_sel);
-		goto unlock_exit;
 	}
 
 	/* Setup RGMII settings */
@@ -980,7 +976,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	    priv->p5_intf_sel == P5_INTF_SEL_PHY_P4)
 		priv->p5_interface = interface;
 
-unlock_exit:
 	mutex_unlock(&priv->reg_mutex);
 }
 
-- 
2.37.2

