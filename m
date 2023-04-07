Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9246DAE55
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjDGNuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbjDGNtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:49:55 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98760B46D;
        Fri,  7 Apr 2023 06:47:39 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-54c17fa9ae8so76386017b3.5;
        Fri, 07 Apr 2023 06:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVB9ML0qQp6Ot62697wF9RTVP+Z+z2Q4uGeODmUSaHg=;
        b=i1K1FdocxtQzLTFUEHSuQBjYbF+13pH0uYQGzYUPZOMq1Iu/dGJPy12Qm6mARCEzCm
         YHLL/WqShe6RMe50LWVBE77YnhHGRcC1fEN3mEmKn7NDQ0LYUEkBZxKolKnW/1jRh5cf
         fIrVPtKD1jIC7U69xs4HxVstnyINJxYrt4DUjIdzBJHPwF2ADOt5xzUN0e/J+pWcksyR
         oviPikrbAOtyY5v0zfDuvdX6p7b5Cz4/hw2hP2Wj7eVatoxYMShivAMISsrG7OP+Asb7
         /neG+24jv6/svx9gQZtmBy1JfbrIJYSS9jWZ8RBKUMmXTNPPv2UMMLPCBr0dLBTg8Vus
         2Zjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nVB9ML0qQp6Ot62697wF9RTVP+Z+z2Q4uGeODmUSaHg=;
        b=fFEMAdtw7SHdVPKpKKTkwQyXCglz8HScHpI7pw/xtDkgfwal8MW2+Nuzdf6WcD+MeW
         VVKYoA/Vy+/H1PkoEttK/NTHQdxGFATdGa7eiD/5Ft6oKVZ2eMMoluuiVJSsAbC1aKW1
         dfAQ8UH2CcpLoSCVNc27S+8GuuSgkvYEvuvnBUYXyuRlr0/FsaQjkS/QaHCnx9d2YPv0
         mzWsh0U8EFaEZ5qDsEiHgpvJq+y48ys28t8C7uAHo274HE+uEjR6E3z7PQ+AgS3DnMPp
         QTAp9oYjvlfAIlozLYxzUKC+ZjsQbr2fsFnhvOjQinpVALmf96GXnXqQ3nvBy8Q3JOSH
         FmZg==
X-Gm-Message-State: AAQBX9eOgySVcYCW/TwF2uuPk/SLQ0KMTxXyUxZ4ElhzHpYHOx2cHNhz
        A0bLhUFYdEwqjOKrIU//0ms=
X-Google-Smtp-Source: AKy350Yh3scr9hlZNm5vfl4Uwkod/y7R0genEKiw6tURE/R+/iDGLj049Si28KBdTKTzjdBw6CY86A==
X-Received: by 2002:a81:5c56:0:b0:544:9180:3104 with SMTP id q83-20020a815c56000000b0054491803104mr1809711ywb.34.1680875258782;
        Fri, 07 Apr 2023 06:47:38 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:38 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 14/14] net: dsa: mt7530: remove .mac_port_config for MT7988 and make it optional
Date:   Fri,  7 Apr 2023 16:46:26 +0300
Message-Id: <20230407134626.47928-15-arinc.unal@arinc9.com>
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

For the switch on the MT7988 SoC, the code in mac_port_config for MT7988 is
not needed as the interface of the CPU port is already handled on
mt7988_mac_port_get_caps().

Make .mac_port_config optional. Before calling
priv->info->mac_port_config(), if there's no mac_port_config member in the
priv->info table, exit mt753x_mac_config() successfully.

Remove mac_port_config from the sanity check as the sanity check requires a
pointer to a mac_port_config function to be non-NULL. This will fail for
MT7988 as mac_port_config won't be a member of its info table.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Co-authored-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 903e39b7b772..dd2221e839d9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2629,17 +2629,6 @@ static bool mt753x_is_mac_port(u32 port)
 	return (port == 5 || port == 6);
 }
 
-static int
-mt7988_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
-		  phy_interface_t interface)
-{
-	if (dsa_is_cpu_port(ds, port) &&
-	    interface == PHY_INTERFACE_MODE_INTERNAL)
-		return 0;
-
-	return -EINVAL;
-}
-
 static int
 mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
@@ -2680,6 +2669,9 @@ mt753x_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct mt7530_priv *priv = ds->priv;
 
+	if (!priv->info->mac_port_config)
+		return 0;
+
 	return priv->info->mac_port_config(ds, port, mode, state->interface);
 }
 
@@ -3123,7 +3115,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
 		.cpu_port_config = mt7988_cpu_port_config,
 		.mac_port_get_caps = mt7988_mac_port_get_caps,
-		.mac_port_config = mt7988_mac_config,
 	},
 };
 EXPORT_SYMBOL_GPL(mt753x_table);
@@ -3151,8 +3142,7 @@ mt7530_probe_common(struct mt7530_priv *priv)
 	 * properly.
 	 */
 	if (!priv->info->sw_setup || !priv->info->phy_read_c22 ||
-	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_config)
+	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps)
 		return -EINVAL;
 
 	priv->id = priv->info->id;
-- 
2.37.2

