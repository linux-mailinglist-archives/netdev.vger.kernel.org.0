Return-Path: <netdev+bounces-11679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B3E5733EAE
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36854281927
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A074C8F;
	Sat, 17 Jun 2023 06:27:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0194C7D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:27:08 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BB5E66;
	Fri, 16 Jun 2023 23:27:06 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-51a200fc3eeso2073379a12.3;
        Fri, 16 Jun 2023 23:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686983225; x=1689575225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0TmHFX5MJGKVziIQt0gsGjAnYc/wjRnba9gkrJwLog=;
        b=ddplcb92+TtA1iBNeeDDBppuGzqMrRkcBbQJBV2l6Yx+1RADclXjZapDeaFOjqpKN7
         KpVp7I+8ML7xWVAgdFVn5j1lgd55ASElBrFotnUBQAMwhOxtClLfzjmwIBJIfgQbdOei
         zsabOmlWRXN45AGctCr4uttlS9IrXVsfokuL/o0sfy7A1CeQkW/flo8ePdFG2qXRJSo8
         rOZ3ntnD1pDEManpsfEMXWjn4/bkF/WHTvoCPjmR2BxaqQ8FeEPNsLzv20tz1RRzTFUP
         sG6D/zqF23Yd5LBqa8TXAqq38uRYaxAq4LZJSOv2v1L77kmgITGHmV09WHAp2yduC5Zy
         +LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686983225; x=1689575225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d0TmHFX5MJGKVziIQt0gsGjAnYc/wjRnba9gkrJwLog=;
        b=d2Ak7BaxSlIZWKdoxy8DmbB07lWc5TnRMFcA7IRDFqsYIZXmgW+8FBg4IFOyRnMJJu
         qEI4FIEKXEWdv68Gl2Uh/4VDmgvPpkxBDF1JYRH+Pc9FbodBhYWJ3sfr1YT/tilynNLS
         3GD2r2QDuHtfAsz75WDVT+JS4wsPIGFa8KS/r0qAKysvBYUmgYiSwRGykssm07F+H9vb
         3+FxDHErJeMFpks1h15AkJxzEtoLeD+2dcrSZk3wMW6cfrgzCd4UJ4DtQ+mxISHMaTr4
         d81XuezUbz1lIQxv2jteURRax+8nDsg6myDE47RNHXH88aqHj/PSLC4EUPE5ousoupL8
         FjlQ==
X-Gm-Message-State: AC+VfDx9vz4plo++CQ83rBNmlePbfszS9JE6FVivLGgdshEv35kDQalA
	C5I5T6hyOv1pR8QjBbtyHAE=
X-Google-Smtp-Source: ACHHUZ68Uj9Tfc9FKIpyHXL7KyLXD9DxuetacXrrVOugCWOATvVu6VPJ2mJU/wvTm6oqO1Wp3x6ZIg==
X-Received: by 2002:aa7:d912:0:b0:51a:3e94:b567 with SMTP id a18-20020aa7d912000000b0051a3e94b567mr2551978edr.11.1686983225191;
        Fri, 16 Jun 2023 23:27:05 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n6-20020a056402514600b0051a313a66e8sm1799638edd.45.2023.06.16.23.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 23:27:04 -0700 (PDT)
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
Subject: [PATCH net v6 2/6] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
Date: Sat, 17 Jun 2023 09:26:45 +0300
Message-Id: <20230617062649.28444-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230617062649.28444-1-arinc.unal@arinc9.com>
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
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

All MT7530 switch IP variants share the MT7530_MFC register, but the
current driver only writes it for the switch variant that is integrated in
the MT7621 SoC. Modify the code to include all MT7530 derivatives.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f8503155f179..8c9acf109a4e 100644
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


