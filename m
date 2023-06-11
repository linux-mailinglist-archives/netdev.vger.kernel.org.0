Return-Path: <netdev+bounces-9883-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A990A72B0C0
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDF4D2813B7
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C65B5233;
	Sun, 11 Jun 2023 08:16:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1109053B5
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:16:15 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F9E2D70;
	Sun, 11 Jun 2023 01:16:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f7353993cbso23664445e9.0;
        Sun, 11 Jun 2023 01:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686471372; x=1689063372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMifJN4jd3TEuoV/A1C1hcI6+kLjQwx0MeZB39jRuMI=;
        b=PthLKHnGGkr2WcYkatNv4TnPl2TKewQFjocvu7QOVpW6epdBarlwxXnzjs67lNFm8z
         G51Em619D6KwVfuvv2GEQVUkBgfxOX9dtP7gJXDppNwmnOZmfNez9WzIwj7FemJUXC1j
         qC9GuZWA5ArVZbWYoXjGnP/Q2mZ3LExHhNJpL9rAKmne/k3DpirZWNwpYupx2Z3Ko5hU
         L3AeX1wezoLpPdRO060JOgp1sRtXiwovfxaeZJ6/uDs36q72Cwe+4bNtOOo7gnSSv3CJ
         SpJBFbqst6h2HuQQC112Yxmbk+Ak+mNp2iTSx7HRQRhnJ53qjpuI5enEGCoh4gdHRkxt
         LT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686471372; x=1689063372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMifJN4jd3TEuoV/A1C1hcI6+kLjQwx0MeZB39jRuMI=;
        b=QTkazCaTq0Kz9RRtfiHorTo7AK5OULmBtu8K1O+jmc3XPcEi18upDJI9mTArE4TXZU
         bZnqtCdV+e+mJ+JLbkUz6DTr0Ci5feYTQO1t4Em48lVU8mjdTm8vqQNNvr2hwYb+dVxc
         5sQM+51KIwjHb2stjmjW1B0rT/mDkMAclHT5ExFrGLCnEVHa6QiTL8/InFG/8DZJHl3J
         ha1MrE83nr58EU0MaukoG5nIy195xS28qmOn01z4pUK5ihdBphPYZF7Q3REovmIRX9DW
         /+eLrOEoFmMVp7fQ/hJZxnmiLHJ1Hb55m5tt8Cq23yhYrghrgKdyP+wxIOOhnFBLQtni
         8d8g==
X-Gm-Message-State: AC+VfDy+wAoIL1HnfML/OJuVza5zTVcxjfwKdE831/1OkYFt1q7xt2iP
	wZ/J3nvAlLbJpmBl7FQpCD0=
X-Google-Smtp-Source: ACHHUZ6RmdHmQyBkYL2UEpNAmKo5OiBthmTIpkl+PptirHvfGBelRvLejq6lO9XGvVBfdNBRgCRBWQ==
X-Received: by 2002:a7b:c7da:0:b0:3f7:a20a:561d with SMTP id z26-20020a7bc7da000000b003f7a20a561dmr5316499wmk.8.1686471372137;
        Sun, 11 Jun 2023 01:16:12 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id s5-20020a7bc385000000b003f6132f95e6sm7748979wmj.35.2023.06.11.01.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:16:11 -0700 (PDT)
From: "=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?=" <arinc9.unal@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
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
Cc: Landen Chao <landen.chao@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net v2 3/7] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
Date: Sun, 11 Jun 2023 11:15:43 +0300
Message-Id: <20230611081547.26747-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230611081547.26747-1-arinc.unal@arinc9.com>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
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

The check for setting the CPU_PORT bits must include the non-MT7621 SoC
MT7530 switch variants to trap frames. Expand the check to include them.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index da75f9b312bc..df2626f72367 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3073,7 +3073,7 @@ mt753x_master_state_change(struct dsa_switch *ds,
 	 * the numerically smallest CPU port which is affine to the DSA conduit
 	 * interface that is up.
 	 */
-	if (priv->id != ID_MT7621)
+	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
 		return;
 
 	if (operational)
-- 
2.39.2


