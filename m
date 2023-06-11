Return-Path: <netdev+bounces-9891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 419AE72B0E0
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77E96280A4F
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E76523D;
	Sun, 11 Jun 2023 08:39:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1879F3
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:33 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E07B2136;
	Sun, 11 Jun 2023 01:39:30 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f7e7fc9fe6so32652105e9.3;
        Sun, 11 Jun 2023 01:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472769; x=1689064769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f09kXODUN5iNYLPQ79n740eNlnLbhpMepUm6pYfWMww=;
        b=C/fGGl6ASR0cY/wWkKRZtQQ4KpGLYV9M+zANFT52eDrclJ0wCbtsjkKhWrzWrDHd/n
         u2JbTgb6Kz4l2JhvVw+5y5dJGCqblfSdv28SbtY6yrGrE9dL8GV7OX9RkE4m6khAV4oL
         HZtbLbpQCn/WhcdT3BrfJaagczpFAP1FLELKkbi/DMGkx9c6lLMP7kEe9CbKTd4GrQ1r
         CxnTbVrYwNm19qtPAfPJKnlODci+4HHRa2ToVubD6L1UjRIw0PYfqAmSNxfmnCgucJAv
         NRvBwU3AHH0cFNx6UmSY3vhvGhMfAerb0MUMU/aIaU6Wd6r+AGxkii3D9b3GFFFMhfQk
         nsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472769; x=1689064769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f09kXODUN5iNYLPQ79n740eNlnLbhpMepUm6pYfWMww=;
        b=aW8ui1dc5zfCTdHxGg5iP5nv3EJvp1EMmzHDOAIDt6Ya+srfrd5oJQoLt3YlRcMkLq
         L1A+Dhh23JKxKgOfMXMAzjGny8CbT4mpO3KHC8qLe6CIB3aTXuJRowmrqE8NZxciYrEn
         Q1uBC02XDcfIdWZqU+X0si+gOubsA+EM512BnvPEYWpH1FQKHg43jDhjuGT6UG+klutH
         6HVcY4c6MjZ/C5jIQKNIZu11kAEqc8aypm+fhPpHnc5B7FJDNEMym9Sx+64F7XT+OLNt
         xhg8HZpY2IDz8y0eDDmQsalWDyBv8awoJewnkN6P5GkttRWnTAg98BGZmzvVSKhJ9db3
         1L4g==
X-Gm-Message-State: AC+VfDyido0MOT1sZaq0V7ToiN3lvtUzIQcXNL9EAf09kpcKLXeLM9Om
	3x9wqbUZkmrJNh2CJ1GsmjU=
X-Google-Smtp-Source: ACHHUZ6I7W3aULN9NVIUPkKt8BHEZeda5LOSEjeuWyIokENebTg8/N4IOGkT5DCztsx5csgtjhw8ug==
X-Received: by 2002:a05:600c:ac7:b0:3f7:38e1:5e5a with SMTP id c7-20020a05600c0ac700b003f738e15e5amr4744827wmr.33.1686472768980;
        Sun, 11 Jun 2023 01:39:28 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:28 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
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
Subject: [PATCH net v3 3/7] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
Date: Sun, 11 Jun 2023 11:39:10 +0300
Message-Id: <20230611083914.28603-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230611083914.28603-1-arinc.unal@arinc9.com>
References: <20230611083914.28603-1-arinc.unal@arinc9.com>
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


