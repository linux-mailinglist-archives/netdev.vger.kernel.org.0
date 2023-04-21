Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A5E6EAD2E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjDUOj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjDUOim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:38:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174AD6A64;
        Fri, 21 Apr 2023 07:37:36 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-95316faa3a8so290889866b.2;
        Fri, 21 Apr 2023 07:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087854; x=1684679854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jH8yEvnmoXsEC6mwOHxF9ajbBlURmLh7zMT6HCy7q6s=;
        b=ENF4e5isJoqDkxBVkvDe8GJi2ftvSaFaD9Evi4Dpli45lx1araC/pu5qZV+/ri9OtW
         aLau62aVwy1AxwQ40Q861kxGjJrGhSrI1L4hqchjhCa90Ei2Ilsgnjfz9Z95jOiSfSYn
         f6UXow6rBZMOv2mKFxv/FKlTe6VZ2HfQHmnuKMaVE6tKv6oyVGmqx+QH2UQEDTeJSn0p
         ep5Ni6mPdJFC95jJgJK0wy4PHbT/ixsdvFwW7mRUDeUb7AlmtPDOmfvt236IFJLLXMeH
         wrDdQUbMEHPFIOhUAAz9tAIca0emd32Y/WkYY/01pNXqm+JlfHzGj/rNQmTURFQWIHMT
         UKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087854; x=1684679854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jH8yEvnmoXsEC6mwOHxF9ajbBlURmLh7zMT6HCy7q6s=;
        b=IUulgBCUdvnzRjf/ZxlTQOq0Y3SQN8/ZaxUa7hY9sZvSS7lZPwwfXEvI0r/pIuzHgy
         BoI8dZZEz+Lrz8zdSD3DjEAZZOa/8ludBnNc6oe2TOchv8f5XYcJQ+BrtF6HPsTdmakQ
         I0dxg+b/BqjrkMlyxQA++lSGUtZA9LOqTBD7sp7/HIebjh5rRMDchydlkF09EgbvXccs
         Zu+UTKh77X+yEsSMz5AsZjQDeExdpsaiyjZsyxZm0QJsklJ1t4hFx3tsQkGyzo1k2Ccf
         mHVKs1omC5h/zq3b5hJT4G6VZvJlZPhXnUuURd0e1JeC7XvXnMVpOfS8b5ixSjWLS0ZY
         /iHQ==
X-Gm-Message-State: AAQBX9dm7o1Xxvi3p1fKBeG7FrP0u2j4hc0kzh2wez9Ba5d9KxFclhKx
        8Ta8FP5dtCZNKoLjgkeC1eQ=
X-Google-Smtp-Source: AKy350b2NWrqoFCF1UDO3y+zEU6fJrF42fw4MyZhMWLq7M5pUTgsmJD+/3oPcIpL57kyJxjWUvr7Mg==
X-Received: by 2002:a17:906:9b45:b0:94e:5679:d950 with SMTP id ep5-20020a1709069b4500b0094e5679d950mr2004270ejc.72.1682087854350;
        Fri, 21 Apr 2023 07:37:34 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:34 -0700 (PDT)
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
Subject: [RFC PATCH net-next 18/22] net: dsa: mt7530: remove .mac_port_config for MT7988 and make it optional
Date:   Fri, 21 Apr 2023 17:36:44 +0300
Message-Id: <20230421143648.87889-19-arinc.unal@arinc9.com>
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
index 899fc52193e1..a66a762cb5db 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2619,17 +2619,6 @@ static bool mt753x_is_mac_port(u32 port)
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
@@ -2670,6 +2659,9 @@ mt753x_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct mt7530_priv *priv = ds->priv;
 
+	if (!priv->info->mac_port_config)
+		return 0;
+
 	return priv->info->mac_port_config(ds, port, mode, state->interface);
 }
 
@@ -3113,7 +3105,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
 		.cpu_port_config = mt7988_cpu_port_config,
 		.mac_port_get_caps = mt7988_mac_port_get_caps,
-		.mac_port_config = mt7988_mac_config,
 	},
 };
 EXPORT_SYMBOL_GPL(mt753x_table);
@@ -3141,8 +3132,7 @@ mt7530_probe_common(struct mt7530_priv *priv)
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

