Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D468C55058B
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiFROsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 10:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiFROs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 10:48:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5327317A99;
        Sat, 18 Jun 2022 07:48:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id v1so13548602ejg.13;
        Sat, 18 Jun 2022 07:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j25IktA0GRUlxfFc2WwUnwO0L6NRqPXuym+pEq9YmO0=;
        b=CBoORK+LlmkTZ53Rm4y2UAYg9Mx2iKFymD1TX82DuhRxaXTUTK7ZLpAmH+c/4gVBob
         hQN/r86H+FII8luY3Vh/Qxn3bRKj/YPtzrdpLDx+boOGv5eNSeQ8X494aftDjD8Su1aH
         4F1U86yTzAJmLPsMgDeLkhoIgxsWkfAf12mE7pu/yuVWadWGrIKoz87ZJrvriohLnaji
         6H4In3ghxRtEspH3U6fRWmUBBsGwDdYE/NG0tEAUI03rNMa7XpcImRnb1YvbXbr71G1b
         hk8r7lQfKySFKi2KP+LSW8ohNfAjDYWQCxrP5dwMdvOFpjzhkzWLtds11V2TJk/5dgJm
         SCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j25IktA0GRUlxfFc2WwUnwO0L6NRqPXuym+pEq9YmO0=;
        b=0ZFLzqVFKy+BsuM1fnONBMOW8dtTkDyX1KMtRZhQCh7Ekasl0pCdo4zx6Qww+e6CSi
         s3mSDv9pWWs0Pc3l68ep1Un1ZpHduIjINn5z+IjNKT3MN0jQ0jfeD+aQGvNbqvw4XWbz
         aVQElSFTL/Fyc2xD0D0k3YxxTkcxSGr+MyBoWbb6ygwlfeDI8BhDJY5eepYDtcSgjplk
         bv05pFTV2aBbNWxIKCo8ztdpKMF4De2gnmVF+ZbxailputTYc/JgUcz/iP3XkqO4+vGe
         NCht1vi3MdaQjQtgJLxEcBsQNAE4qU9VXhWzazdhIO+CT5gDxG4FGPwm57ED0vWTARZi
         jf1Q==
X-Gm-Message-State: AJIora9wCEdgDSoROkY+XYSIAf0sgoe/JQfyXtAUjZR2YqGdOBDCTmXz
        3BcRkfC3pd1iCQngjx0v5mc=
X-Google-Smtp-Source: AGRyM1sn5gxncMQnt3aTSNamrjRk8bXBQNtKYXu+zN9Kfabg8QHfnQ9M+lweRJI5CLq489htvunqIA==
X-Received: by 2002:a17:906:73de:b0:715:784d:2cdd with SMTP id n30-20020a17090673de00b00715784d2cddmr13623487ejl.273.1655563705751;
        Sat, 18 Jun 2022 07:48:25 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id h20-20020a1709070b1400b006fe7d269db8sm3450296ejl.104.2022.06.18.07.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 07:48:25 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [PATCH 2/3] net: dsa: qca8k: change only max_frame_size of mac_frame_size_reg
Date:   Sat, 18 Jun 2022 08:22:59 +0200
Message-Id: <20220618062300.28541-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220618062300.28541-1-ansuelsmth@gmail.com>
References: <20220618062300.28541-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we overwrite the entire MAX_FRAME_SIZE reg instead of tweaking
just the MAX_FRAME_SIZE value. Change this and update only the relevant
bits.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 8 ++++++--
 drivers/net/dsa/qca8k.h | 3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2727d3169c25..eaaf80f96fa9 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2345,7 +2345,9 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		return 0;
 
 	/* Include L2 header / FCS length */
-	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, new_mtu + ETH_HLEN + ETH_FCS_LEN);
+	return regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
+				  QCA8K_MAX_FRAME_SIZE_MASK,
+				  new_mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -3015,7 +3017,9 @@ qca8k_setup(struct dsa_switch *ds)
 	}
 
 	/* Setup our port MTUs to match power on defaults */
-	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	ret = regmap_update_bits(priv->regmap, QCA8K_MAX_FRAME_SIZE_REG,
+				 QCA8K_MAX_FRAME_SIZE_MASK,
+				 ETH_FRAME_LEN + ETH_FCS_LEN);
 	if (ret)
 		dev_warn(priv->dev, "failed setting MTU settings");
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ec58d0e80a70..1d0c383a95e7 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -87,7 +87,8 @@
 #define   QCA8K_MDIO_MASTER_MAX_REG			32
 #define QCA8K_GOL_MAC_ADDR0				0x60
 #define QCA8K_GOL_MAC_ADDR1				0x64
-#define QCA8K_MAX_FRAME_SIZE				0x78
+#define QCA8K_MAX_FRAME_SIZE_REG			0x78
+#define   QCA8K_MAX_FRAME_SIZE_MASK			GENMASK(13, 0)
 #define QCA8K_REG_PORT_STATUS(_i)			(0x07c + (_i) * 4)
 #define   QCA8K_PORT_STATUS_SPEED			GENMASK(1, 0)
 #define   QCA8K_PORT_STATUS_SPEED_10			0
-- 
2.36.1

