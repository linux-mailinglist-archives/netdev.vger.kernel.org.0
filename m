Return-Path: <netdev+bounces-11269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9E7A732572
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E5282815E9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8D87E4;
	Fri, 16 Jun 2023 02:53:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B5063A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:53:38 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C29B2954;
	Thu, 15 Jun 2023 19:53:37 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so170115e87.3;
        Thu, 15 Jun 2023 19:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686884015; x=1689476015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JH9rgnoje5CiNXWobY3ZLpf7/bXY7kCTB8+Con2/+OA=;
        b=nbAUKxqkROBMD6br9cgrAZn8uavT1rxIO62rQiLnqdRERiQ41WRJ1ZoRrz+JwNhpWO
         COQeiWJ17QHdyIBU+7Kl4Uy3mNsxqZ1+ySu1e05uA31KPc/5XLADq7OKx4c/IBD7dxxn
         PINZKSsz14Hvfa0J+1MPAteXtXocCojlIAg12dKW6an3DInGDCeBcBNIum/rSrBaS0vt
         +P67NDJ6avMMTxEtLw7VGE5IH+6Z8pGYAnVlB8ItIzZUVwclykbcQgJM/iZQ9awFRMt9
         yBWMZSuf6pSQ30YQtqNusfmSSu8pA7HCpyoQx6IhyTuOuwQ7hLfX5l5xL1PD7xOF7+mo
         lEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686884015; x=1689476015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JH9rgnoje5CiNXWobY3ZLpf7/bXY7kCTB8+Con2/+OA=;
        b=Gw7YThxGSFFJ3koxMVPL+J3KUxC2Ob+5DBP4hzJrG9DmuQy29creyike0+IRIkhPxw
         yKNiOiKzcK9eCtoaiJXeROp7S2pzdNoQxkL5rnKgOSsMWGze0j2V2kx4d1JwGbXfqq91
         X/mECSx5tbyJPr7uygN/PK8wn8oA/quGU/SkPDiTNXsJdNjwvHiZhUr294l3qfCq6xCI
         cFEidTH2KoVlPLrbrxhLxe9Fdh06BB7c90HlmOCulRvhuU8piWEIHYIdZ/Yur/Dquwnp
         ad4ZMbIgHgAUJfkh/Bx3QqHRue+FZvrnVoBgUfve3qulIaHmCb7H6mB3Tgz0yhJJxnE+
         BMPQ==
X-Gm-Message-State: AC+VfDwGrMMAou8M1GCqRGyNHBr68CTyvXpRdbTiX3wnP+ICmNjXyc9r
	M43N8K8Xx0c3FGTn92+yDuU=
X-Google-Smtp-Source: ACHHUZ7vBZhrlqunY+9yGIC8576odQqD9NlYAC3uEM3FtxIRkY8j4u0HkMS7Zd9Ziv7asuFwukz1Hw==
X-Received: by 2002:a19:8c4a:0:b0:4f3:8f3a:f98d with SMTP id i10-20020a198c4a000000b004f38f3af98dmr257461lfj.45.1686884015414;
        Thu, 15 Jun 2023 19:53:35 -0700 (PDT)
Received: from arinc9-Xeront.. (athedsl-404045.home.otenet.gr. [79.131.130.75])
        by smtp.gmail.com with ESMTPSA id v15-20020a1cf70f000000b003f8d770e935sm890328wmh.0.2023.06.15.19.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:53:35 -0700 (PDT)
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
Subject: [PATCH net v5 2/6] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
Date: Fri, 16 Jun 2023 05:53:23 +0300
Message-Id: <20230616025327.12652-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616025327.12652-1-arinc.unal@arinc9.com>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
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
index 0a5237793209..e9fbe7ae6c2c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1007,7 +1007,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 		   UNU_FFP(BIT(port)));
 
 	/* Set CPU port number */
-	if (priv->id == ID_MT7621)
+	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
 	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
-- 
2.39.2


