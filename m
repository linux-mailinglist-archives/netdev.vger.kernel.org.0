Return-Path: <netdev+bounces-9893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0720672B0E2
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B62EF28147B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE523848A;
	Sun, 11 Jun 2023 08:39:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFC12595
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:37 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADD126B1;
	Sun, 11 Jun 2023 01:39:36 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f732d37d7cso32918305e9.2;
        Sun, 11 Jun 2023 01:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472774; x=1689064774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MawcVePra1qezae3jM9kLNrcTxxlCRgwx7hsVh8Pm7k=;
        b=T6xo+Zdt9hy/a3FOPQcorLiZmiUptS1PemQ75IHPcbz7eMZ5jRzmbVlKSvnohuHJmK
         1dN5QBnhDNGdE5lR8ZPpwdBZ4uMOEN0OxRkZOdi0P1y5OEK3cxUzJvJrM3NnEwnyrOtX
         RDBNUhlBB3IvEhkaEZdGOwam1Or/F6Qf/MOAomKky00Lh9fT/jqbRBfnbtNacKK244eY
         G2m3RJ3cBUwJFg8tE5fniVAXFGE/qemMMgaCI0mFdNmiEl7PG/5yshtQZMdtw34XMo6R
         CHSvHw1kA97pN/B/si3VIR/ADUq3oP33KwEya9+AQGgNoStrV7hGuV0bG34zomOG6lTr
         BwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472774; x=1689064774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MawcVePra1qezae3jM9kLNrcTxxlCRgwx7hsVh8Pm7k=;
        b=C1l3GcpyOB4x2mjyNXebf69+SAXH3M25xC0uTBngzVZOFs2+4Ainn5ONmJblge3aIg
         T9q/UafWFsKqU3PsKxFBguM0Tbs++8qqDPofz6yW0zV7mb5+tL0EILw5gDBHcuFIh3zZ
         S9RHPiqyv0RsEhKSrBuh8dxx22H3QVtg/H82gns7Y6SVXYFy65dkoi0TAjLTh6VTNI7v
         jrKkWPslsP+50FlLyvGvf/1mMa8y2TFcS+t6nOdOb6xjntVFhKQeTWLjtk7X5LmJsfYP
         IWr7joO1Lv8ebTJB2akAceAJEJgsJ8gvqnVU5Yj0Uo1MSmspscbnNeN9kLouSQCKbYLm
         pwaw==
X-Gm-Message-State: AC+VfDy2pYjGybdf1HLnYirzpf370HXsB1OEjKm6QPBvkTSmazssoR+W
	PAojl438svJQ0o5N/zjNR0M=
X-Google-Smtp-Source: ACHHUZ4OHnQrAXoJ6/BuM+FWQspwC/JIQ4feX6or84CeOcTTlPRSy8pKOgrR4bUD/OHBsM/HrrSJhg==
X-Received: by 2002:a05:600c:290:b0:3f7:f7d5:a07f with SMTP id 16-20020a05600c029000b003f7f7d5a07fmr5112604wmk.17.1686472774459;
        Sun, 11 Jun 2023 01:39:34 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:34 -0700 (PDT)
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
Subject: [PATCH net v3 5/7] net: dsa: mt7530: fix handling of LLDP frames
Date: Sun, 11 Jun 2023 11:39:12 +0300
Message-Id: <20230611083914.28603-6-arinc.unal@arinc9.com>
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

LLDP frames are link-local frames, therefore they must be trapped to the
CPU port. Currently, the MT753X switches treat LLDP frames as regular
multicast frames, therefore flooding them to user ports. To fix this, set
LLDP frames to be trapped to the CPU port(s).

The mt753x_bpdu_port_fw enum is universally used for trapping frames,
therefore rename it and the values in it to mt753x_port_fw.

For MT7530, LLDP frames received from a user port will be trapped to the
numerically smallest CPU port which is affine to the DSA conduit interface
that is up.

For MT7531 and the switch on the MT7988 SoC, LLDP frames received from a
user port will be trapped to the CPU port the user port is affine to.

The bit for R0E_MANG_FR is 27. When set, the switch regards the frames with
:0E MAC DA as management (LLDP) frames. This bit is set to 1 after reset on
MT7530 and MT7531 according to the documents MT7620 Programming Guide v1.0
and MT7531 Reference Manual for Development Board v1.0, so there's no need
to deal with this bit. Since there's currently no public document for the
switch on the MT7988 SoC, I assume this is also the case for this switch.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v2: Add this patch.

---
 drivers/net/dsa/mt7530.c | 12 ++++++++++--
 drivers/net/dsa/mt7530.h | 19 ++++++++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c2af23f2bc5d..97f389f8d6ea 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2261,7 +2261,11 @@ mt7530_setup(struct dsa_switch *ds)
 
 	/* Trap BPDUs to the CPU port */
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_BPDU_CPU_ONLY);
+		   MT753X_PORT_FW_CPU_ONLY);
+
+	/* Trap LLDP frames with :0E MAC DA to the CPU port */
+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
+		   MT753X_R0E_PORT_FW(MT753X_PORT_FW_CPU_ONLY));
 
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
@@ -2364,7 +2368,11 @@ mt7531_setup_common(struct dsa_switch *ds)
 
 	/* Trap BPDUs to the CPU port(s) */
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_BPDU_CPU_ONLY);
+		   MT753X_PORT_FW_CPU_ONLY);
+
+	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
+		   MT753X_R0E_PORT_FW(MT753X_PORT_FW_CPU_ONLY));
 
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 28dbd131a535..5f048af2d89f 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -63,16 +63,21 @@ enum mt753x_id {
 #define MT753X_MIRROR_MASK(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_MIRROR_MASK : MIRROR_MASK)
 
-/* Registers for BPDU and PAE frame control*/
+/* Register for BPDU and PAE frame control */
 #define MT753X_BPC			0x24
 #define  MT753X_BPDU_PORT_FW_MASK	GENMASK(2, 0)
 
-enum mt753x_bpdu_port_fw {
-	MT753X_BPDU_FOLLOW_MFC,
-	MT753X_BPDU_CPU_EXCLUDE = 4,
-	MT753X_BPDU_CPU_INCLUDE = 5,
-	MT753X_BPDU_CPU_ONLY = 6,
-	MT753X_BPDU_DROP = 7,
+/* Register for :03 and :0E MAC DA frame control */
+#define MT753X_RGAC2			0x2c
+#define  MT753X_R0E_PORT_FW_MASK	GENMASK(18, 16)
+#define  MT753X_R0E_PORT_FW(x)		FIELD_PREP(MT753X_R0E_PORT_FW_MASK, x)
+
+enum mt753x_port_fw {
+	MT753X_PORT_FW_FOLLOW_MFC,
+	MT753X_PORT_FW_CPU_EXCLUDE = 4,
+	MT753X_PORT_FW_CPU_INCLUDE = 5,
+	MT753X_PORT_FW_CPU_ONLY = 6,
+	MT753X_PORT_FW_DROP = 7,
 };
 
 /* Registers for address table access */
-- 
2.39.2


