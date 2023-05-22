Return-Path: <netdev+bounces-4253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B061B70BD4F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:17:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 855A41C20AC8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A536712B64;
	Mon, 22 May 2023 12:16:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979C1125DD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:39 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8424AE56;
	Mon, 22 May 2023 05:16:13 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96fffe11714so109776566b.0;
        Mon, 22 May 2023 05:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757752; x=1687349752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3GlYa/gtfioHyiBI/gLtS8VjxT1YVLAproZrb+Hou0E=;
        b=BgHNA/IgLsWdLuIeKOa8zdj4FeAFmGxSiYseC398PviO1oB4odqcU/Fy6xwJz6Z+xe
         QkjbiKKEogz0fAmjMPXXTbJlYwq9tsk33H/ouTCFbp2kQ2b5WCY+bB+CPyM4UOWf3E/3
         VZzR3UYCSFAAugbKGJgcNmUzz8sZLkVz03gOb7NqrvwJE7QhVGS4X3mi3y/cXJXtn3KK
         tu3fN7K9Nqw/XcA/4dCvTz1gR7yO/o/mr4SYMqROKTdTr9K5HoOCdgmfClfySWYtowsr
         e4N96toLkYBKv64gc3foWTYSGC5ICtn0EoUIQZNzU+SmjVK9t6rRUBrWtD7LYnH5kA8Q
         MpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757752; x=1687349752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3GlYa/gtfioHyiBI/gLtS8VjxT1YVLAproZrb+Hou0E=;
        b=Wl1n6AMGC8AcKsRe6ErNWuUtLY5wiDgB9b5Htz7NVr3FE4uCHjOdsnnhE146Mvdgmq
         hudiBCuxSP0klpY8Wi6RI+B+9zX6/GNYcjaCrv1iXGMnppPDVjtS9eu1cmjS4qgMJsYA
         hlj6qY+gVRXxADgBoyQIS1qMKv9iZGDbIUBBWan02Gc9inWAq/264juG+ZYFr9Xm4Pqr
         zCF9OGNGHRD+4otOao/Po7MwJXiBWnRPGLANYBH2591rc1FmGRms5S4hFuZSotffvhII
         HFYCHKR5bDiOWJSoVwLaxfu0oWMw1Snk9+Y6nJuE/TuBCDjzBe0HMIYXphb8Lkcul7bj
         01HQ==
X-Gm-Message-State: AC+VfDxJofA09jCbLViezCQhqq9hvfKr/cUE0X9DMkKPjeVcjBvy77TQ
	TN3WHW/upz4WtW6uwpvmB80=
X-Google-Smtp-Source: ACHHUZ5ALSJj0jSyx6S9HSdgBAy7lcuTZBOXYIWapLqX0i4YXHmwid/evs1keI+Wl2F7gyxCa8wGXA==
X-Received: by 2002:a17:907:d1c:b0:96f:df95:28a0 with SMTP id gn28-20020a1709070d1c00b0096fdf9528a0mr3477558ejc.55.1684757751614;
        Mon, 22 May 2023 05:15:51 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:15:51 -0700 (PDT)
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
Subject: [PATCH net-next 02/30] net: dsa: mt7530: use p5_interface_select as data type for p5_intf_sel
Date: Mon, 22 May 2023 15:15:04 +0300
Message-Id: <20230522121532.86610-3-arinc.unal@arinc9.com>
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

Use the p5_interface_select enumeration as the data type for the
p5_intf_sel field. This ensures p5_intf_sel can only take the values
defined in the p5_interface_select enumeration.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 845f5dd16d83..415d8ea07472 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -675,7 +675,7 @@ struct mt7530_port {
 
 /* Port 5 interface select definitions */
 enum p5_interface_select {
-	P5_DISABLED = 0,
+	P5_DISABLED,
 	P5_INTF_SEL_PHY_P0,
 	P5_INTF_SEL_PHY_P4,
 	P5_INTF_SEL_GMAC5,
@@ -768,7 +768,7 @@ struct mt7530_priv {
 	bool			mcm;
 	phy_interface_t		p6_interface;
 	phy_interface_t		p5_interface;
-	unsigned int		p5_intf_sel;
+	enum p5_interface_select p5_intf_sel;
 	u8			mirror_rx;
 	u8			mirror_tx;
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
-- 
2.39.2


