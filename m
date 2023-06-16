Return-Path: <netdev+bounces-11271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B4D732574
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B89B41C20F3F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F65817;
	Fri, 16 Jun 2023 02:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6316EC0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:53:43 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99802D54;
	Thu, 15 Jun 2023 19:53:41 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f8d2bfec9bso1628625e9.0;
        Thu, 15 Jun 2023 19:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686884020; x=1689476020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/TXTWeJTVoXuAKTeh8f1IhTxUfSJa+l8YgArHUf0S4=;
        b=ThPTTwZndntg5GQFV1BoU+8HZFGwk9ozDDKBt84BM3Zf9xiXy0jyMkhwsyRQpz0DhE
         tpiD4K+P93HcI9o/lqPEtJvg5dLWSXSvon3k2Gv9Fa0LKG2MzO7vTiAyJ4O++Mfz2fQK
         i+wnGIVtewWpUOoI/5W6ukcsc19fvEX9lsnUx249uxV8rFTGKoY7ApxORhwgwUvvxVfg
         CPkov//tFDmBmGjXs/hw3h3akvFI/dqxHTDNZArBQtw32DWJxwiq2nyqjTwSNoj7KV+G
         R71ON85rCzlKLz7zp+pyD/Hi8D2FUNiH8ajKGOkQA6g5MeEcWqPGp8qpKWYC/LgoL/d/
         QIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686884020; x=1689476020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/TXTWeJTVoXuAKTeh8f1IhTxUfSJa+l8YgArHUf0S4=;
        b=I0y0toAV2CmEKerLUGXA2ALYzn6Bex8HyuCl0dIWNQff5HPvZigJpZ9QItKdwzhsHT
         sGniJkU55+wkvHdn59Bs9jQUbBF+wjLvGBym6kUebBMvBDaEemmy2E41APbTUZVNSgcR
         3CIlxX4twwP0EcnoMeR1idJqI+S2NjolzsO8nUM3U9eH4jVdRIllGxjKspjxZzrzWsab
         xVZ0n6g14Dj8lE9E+eMe/WLAup+knl9LNllrZQahxocFV5YE5QtjGdE96Yshn70iHMYr
         74kQJxT8HJTvwIKP4ogyP4j3scBAqUEZHQVjye+HUFWmzysQAihye2Tp95VYPrgVd+47
         TRpw==
X-Gm-Message-State: AC+VfDx04KnnPlZXvfY9dVwmQhlC3XI/T0TbvykcrucOZFI+Oe7K7jSZ
	RUQeHK3GLhDJSLoF9psJQh4=
X-Google-Smtp-Source: ACHHUZ5m3yWS67ui0qIRpldwzOdvU3TkY97rT5RE0eglqoIcnhnwT5+gmeL631Pgtun6ClqmYTYI6w==
X-Received: by 2002:a05:600c:214d:b0:3f7:2a38:34b9 with SMTP id v13-20020a05600c214d00b003f72a3834b9mr591288wml.23.1686884019658;
        Thu, 15 Jun 2023 19:53:39 -0700 (PDT)
Received: from arinc9-Xeront.. (athedsl-404045.home.otenet.gr. [79.131.130.75])
        by smtp.gmail.com with ESMTPSA id v15-20020a1cf70f000000b003f8d770e935sm890328wmh.0.2023.06.15.19.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:53:39 -0700 (PDT)
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
Subject: [PATCH net v5 4/6] net: dsa: mt7530: fix handling of LLDP frames
Date: Fri, 16 Jun 2023 05:53:25 +0300
Message-Id: <20230616025327.12652-5-arinc.unal@arinc9.com>
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

LLDP frames are link-local frames, therefore they must be trapped to the
CPU port. Currently, the MT753X switches treat LLDP frames as regular
multicast frames, therefore flooding them to user ports. To fix this, set
LLDP frames to be trapped to the CPU port(s).

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 ++++++++
 drivers/net/dsa/mt7530.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 7b72cf3a0e30..c85876fd9107 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2266,6 +2266,10 @@ mt7530_setup(struct dsa_switch *ds)
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
 
+	/* Trap LLDP frames with :0E MAC DA to the CPU port */
+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
@@ -2369,6 +2373,10 @@ mt7531_setup_common(struct dsa_switch *ds)
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
 
+	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index e590cf43f3ae..08045b035e6a 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -67,6 +67,11 @@ enum mt753x_id {
 #define MT753X_BPC			0x24
 #define  MT753X_BPDU_PORT_FW_MASK	GENMASK(2, 0)
 
+/* Register for :03 and :0E MAC DA frame control */
+#define MT753X_RGAC2			0x2c
+#define  MT753X_R0E_PORT_FW_MASK	GENMASK(18, 16)
+#define  MT753X_R0E_PORT_FW(x)		FIELD_PREP(MT753X_R0E_PORT_FW_MASK, x)
+
 enum mt753x_bpdu_port_fw {
 	MT753X_BPDU_FOLLOW_MFC,
 	MT753X_BPDU_CPU_EXCLUDE = 4,
-- 
2.39.2


