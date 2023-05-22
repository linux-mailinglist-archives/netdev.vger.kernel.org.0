Return-Path: <netdev+bounces-4260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BC170BD6F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 101B9280FDA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B097A13ACC;
	Mon, 22 May 2023 12:16:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956BE14265
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:56 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FB51BC7;
	Mon, 22 May 2023 05:16:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-96f588bc322so587512966b.1;
        Mon, 22 May 2023 05:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757773; x=1687349773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/Tw7LJKMFy4PfANJoXoLwPDs0oFT2xt0A4+ifBliZA=;
        b=L82IXudeI6mBhpOZyX+3epgT5s/qYbgTVZ0c15cgRmJ4B8Qcq8HfmX7W1zl50r19J2
         3lq5YNf54zk9Rhy5VQ2jXk1SZiK1DVOhDoVJPRpKL7VvefgV3GzaQuduX2g+Iu45J/10
         LqiQo3mqh6r4CiR0pAfjqmA38ppuHeQhsHly8rO81WYC3b1YB2V/z0NdxredZoBq8wOO
         Xx6fP0d9TqQPxJiKuOMzeTbZd/HZRKmABNQQhew4UGBZrmFyXTdfNzIY6/Hfbt0T7jOd
         40BlFvdlOP6edz+m2PY9udaqGODPJpXD1G1vd2f13sZl21xXDHYaRnW1BfvnrNJjjBdt
         /SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757773; x=1687349773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/Tw7LJKMFy4PfANJoXoLwPDs0oFT2xt0A4+ifBliZA=;
        b=LgoNpe9Co5UQUbntdBD+zZ3jLsCtyBKd7GeZZfNgm1oaAknTQB2E73WPuZje/czK76
         l6AwF9kg6Nz2Uo75qIiozmgFk4FLKzNa29BrXDYBDQFf0Z6iRVqHQH4J91ZShwSAHsmq
         4YzycPk6GXiibIVioGJ/AQt2oNHgWrPSQKm3mhQ71GfCklou0LIf4twT6U5udzGm4uD4
         NqFDdYZXokytn5hOzeQkzo3oIYOGdZSkT10azPe2wwVOEFk9loQDStbXx9YDoAKc1xrc
         VDwPz1NjZVTHn/DpWVFdYzMzCXfvJQyTnApITfEV/c/ja5ft2GZnj3PKX4pgC2VQtsI4
         kVPw==
X-Gm-Message-State: AC+VfDyn7r3R3eINuWWJoaUwH6hWGKlUUr5PLMw2lTASYTGaIX/Q3yV8
	ZDll+Q/sW4Nq8Wp01JKBHhY=
X-Google-Smtp-Source: ACHHUZ5i6krWyAKq+V9C5ViAnF0f4cHYY7/Mvkb9MPaMzwFUcqw7iv+TmWOD1CiXzc8eLJq4avSdbQ==
X-Received: by 2002:a17:907:9629:b0:96f:8ea4:a72c with SMTP id gb41-20020a170907962900b0096f8ea4a72cmr9874454ejc.62.1684757773086;
        Mon, 22 May 2023 05:16:13 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:12 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
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
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 09/30] net: dsa: mt7530: empty default case on mt7530_setup_port5()
Date: Mon, 22 May 2023 15:15:11 +0300
Message-Id: <20230522121532.86610-10-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

Empty the default case which will never run but is needed nonetheless to
handle all the remaining enumeration values.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d837aa20968c..50f150ff481a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -930,9 +930,7 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		val &= ~MHWTRAP_P5_DIS;
 		break;
 	default:
-		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
-			priv->p5_intf_sel);
-		goto unlock_exit;
+		break;
 	}
 
 	/* Setup RGMII settings */
@@ -962,7 +960,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
 		val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
 
-unlock_exit:
 	mutex_unlock(&priv->reg_mutex);
 }
 
-- 
2.39.2


