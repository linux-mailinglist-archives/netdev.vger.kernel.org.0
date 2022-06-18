Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E975505E6
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 17:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiFRPwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 11:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233697AbiFRPwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 11:52:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8215313D19;
        Sat, 18 Jun 2022 08:52:15 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o16so9199019wra.4;
        Sat, 18 Jun 2022 08:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j25IktA0GRUlxfFc2WwUnwO0L6NRqPXuym+pEq9YmO0=;
        b=ddOLXmWCBJ7SB5wKU7m7FJQqT7AnpTmrj3g+3++ra5YRtOhlKH+vqMwVghb7nU9Zgt
         45dxHUnhoeIi3STGNEt7ZhOpUWVlb616T3W0GciPvz8+zcLksT875zXx7p3WTvst+Qve
         yz1SrKiPEzIivPGuVTEOD9BeXBK/xbQjiozOuBagkL2WLS9WF6aY2NCO5MoxhHf5JU5K
         VGkqgDQswI54mg128My4OX7MfAoHyoGda57iDlzvfHzZOd8endrigdDM1klceEcbFK/y
         8aHrGZYCaQuUAiQTKeUrWPdORFQQJp5gjFz9eJXx4FGa0xeontW+Jwds8Y69T+r5eBp/
         bdYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j25IktA0GRUlxfFc2WwUnwO0L6NRqPXuym+pEq9YmO0=;
        b=pKQvRc1iAckaqZCLqApe+ICViyfz0rdgP3bVmH017ebStNdA5kFSNiB3cSPdGlxztd
         COUKBCrw4ptzfnKAznw1UpWuUtAhGPH3+hfLUo33cune4gMgYsNknSZTZNShAhMSvOjl
         D8SIQK/R8LOWtnPLx1/sCBqsAwGaxnnlV12psBrtpZ3nrya3D3BKQCMkt1QXztTgt9l+
         wFQ+LOLdIXIND9Sx1TLQ/hfo3HZ1cBF6xrjeIWpJKiJLqLqkVTMvomp9UPaK0PFp/B7t
         0WgTe5WsddgOThA0YeK+HSiFeB4LytoSLRlYZquuERIu0rI5h9BtDEiAs3vVXLbnMSTE
         lfng==
X-Gm-Message-State: AJIora/S/1pUPqFnZhbdLBWnMj7dWYlFxvSuwhV2ZM/UBoDEPnH4SvN/
        +mQNTnYYP5eKEUUOsyQEJXU=
X-Google-Smtp-Source: AGRyM1vptSNipeAukI6wlHg/Sp5B5mTyyoHVvdLbfQpXcbBd4AJvEhxGEUc4bX+E75UFBSizttNBtQ==
X-Received: by 2002:adf:a51a:0:b0:21b:823c:ae02 with SMTP id i26-20020adfa51a000000b0021b823cae02mr6407253wrb.25.1655567533837;
        Sat, 18 Jun 2022 08:52:13 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id a8-20020adfed08000000b0020d106c0386sm1952188wro.89.2022.06.18.08.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 08:52:13 -0700 (PDT)
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
Subject: [RESEND net-next PATCH 2/3] net: dsa: qca8k: change only max_frame_size of mac_frame_size_reg
Date:   Sat, 18 Jun 2022 09:26:49 +0200
Message-Id: <20220618072650.3502-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220618072650.3502-1-ansuelsmth@gmail.com>
References: <20220618072650.3502-1-ansuelsmth@gmail.com>
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

