Return-Path: <netdev+bounces-9998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3277E72B99F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73E441C20A9F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 016C011C95;
	Mon, 12 Jun 2023 08:00:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A46D53C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:29 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E99B2718;
	Mon, 12 Jun 2023 01:00:11 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f6e1394060so27082295e9.3;
        Mon, 12 Jun 2023 01:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556809; x=1689148809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqs6PYWxr6amVjehvnSXauf3IGKKl/o67YTmLBa8zfM=;
        b=g8HorBvM1wg+Ji9yD1iaXxMTCzu3O62g8IEei/WOCAk1IsVunXoaEDC93zw5FcMVjQ
         wTPO+ZTDs0wjLtMi/Pxj/5XimnMAyjsbI8tvY7dt3VvlUVsTtW00rtkzdscf4Ts6vsI1
         Xl37VM5txiVUIB4Jr2OZxHQRqVgo0Iba5rt0uqvFqx/QaozD+/1ZdiNRBoLjAhFDGeqY
         R58mBBJ9wlW9zOhMbYHM8ALz47dnr9FLYaHIoTt1h1VXy8M6vwxmLisQVM4p+MdjxZY3
         +3v6fL4BuZex1E1wHJIVEYiYRnV4U1Z8HICfIKqVisA01JiOLCkA6FrsUlGCm7NSojAu
         ONCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556809; x=1689148809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqs6PYWxr6amVjehvnSXauf3IGKKl/o67YTmLBa8zfM=;
        b=FDB/bsqtLnrZhLVD5xowDnhG1tCJd+80yiAR4GlwH5exl/R0dku4E2CLFOXeeDcOOM
         HnQsJx3Ha7BsGpbapfv3Gi+M2giGQEfXPE0rWW39XgMoOYTrLAlvu9Iequ6onuTaqAvz
         ITIEU5SII/Mm5HD/NKaneoNpb4+Wee+1awt5lt89DZSD4Y2u1/HX4RdgDOxQxe/LaOO3
         PNSHtR3Db4ZRTgllBi9ddqNS0JWaM9MWe7GERPJWdlzDyxa4DEJa7FLFojRiFpNbW1Uy
         ZA5Efpyk2BAg8R5qPiHgr3L8AboubwLMrTH8VwmqbFPeVtvCeSofL780cGbXpDkvkUyI
         tOaA==
X-Gm-Message-State: AC+VfDy9PberNEe/5mGFcR1InWIbtFUj22HxAyd3FRwE7G+9/4ai9otP
	TwwxonWVB5acC41X3vst4IQ=
X-Google-Smtp-Source: ACHHUZ5WWo5mumZUNHSMZNQhMahI8vGuVUxNK9aDqqjEC7z0u4he/ff4mw2n+jFIhEw7/PKQJ3rg4g==
X-Received: by 2002:a1c:4b14:0:b0:3f7:f2d0:b8fc with SMTP id y20-20020a1c4b14000000b003f7f2d0b8fcmr5237120wma.34.1686556809458;
        Mon, 12 Jun 2023 01:00:09 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003f7f2a1484csm10552195wmj.5.2023.06.12.01.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 01:00:09 -0700 (PDT)
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
Subject: [PATCH net v4 4/7] net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
Date: Mon, 12 Jun 2023 10:59:42 +0300
Message-Id: <20230612075945.16330-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612075945.16330-1-arinc.unal@arinc9.com>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
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

BPDUs are link-local frames, therefore they must be trapped to the CPU
port. Currently, the MT7530 switch treats BPDUs as regular multicast
frames, therefore flooding them to user ports. To fix this, set BPDUs to be
trapped to the CPU port.

BPDUs received from a user port will be trapped to the numerically smallest
CPU port which is affine to the DSA conduit interface that is up.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2bde2fdb5fba..e4c169843f2e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2259,6 +2259,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
+	/* Trap BPDUs to the CPU port */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-- 
2.39.2


