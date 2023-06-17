Return-Path: <netdev+bounces-11680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1619D733EB0
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 472E51C20FC6
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290984C7D;
	Sat, 17 Jun 2023 06:27:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFAE5C89
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:27:10 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A026CE66;
	Fri, 16 Jun 2023 23:27:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-51a270e4d57so2114760a12.3;
        Fri, 16 Jun 2023 23:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686983228; x=1689575228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k5fN3EkFghwlzEiC3xrHYKgc695PJWNEMXB0KcT9YJw=;
        b=WaIs+3+81vr1zsFAegdIECwEy3rUepcmk8CbeKzMxvTBRDxoEXE8tgh4D0UU2bsKSb
         9tlajdHoAn7fmMWiENSw02lGwGyBaLfbq3HTfG+lejGruNai6BcvwFBGh19igaNY0rym
         AS4n3W1BfhP8nDiAldXC+yBw+5CbiXT0oyIRibqkyx1lz/Q3yxPvwNa56y8IVf005pV7
         N98GO8vZ3CGw/5l0SUQuBa3XRkGad+qx9SDRuhl7NiF9+MB0WGDUH0BWOTU4D0ljURXt
         WG7gEawtpT7Ozdj7sv4ORXau/bdWtIWSiE4E4t1dmm1zCAL4Ju0Rlvv/x8SicMTJpMdu
         tiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686983228; x=1689575228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k5fN3EkFghwlzEiC3xrHYKgc695PJWNEMXB0KcT9YJw=;
        b=jkDUECa3vpxINKhabGCZf0oxm6YR/JEsklBzwa+NB0hxgOCKy22O8KwJiL2KO1XtsX
         r49X5FZEiEr85+7iQq9Nf3UpVP5CTeCVrIxmlFnjq3M81mUkkxdWRYl3PWNHdJUVD/i6
         /zLUAhACVyb8ft6iFgh6D/sTrE2gIXU6IymkNzUy1Nm+IFGcGWTD8Ge0RAMC9t9htP60
         o4HIYmGCEluwAokJVUvy0lupS7rub3qyWDhyc80KXAucxZlB9Cvoi06K9EjRKb8qKXWF
         ILw6cettWQ7FXjvDJhcVPVWGhQbItusbWZ9873ZFK6HYjA025zYbAVOopGCLHHHaFU5Z
         XSNQ==
X-Gm-Message-State: AC+VfDwCfqHV+8IPH5rmotCuj5FsyxdxSbOrMI7Bh9HdXundTksfXCsr
	QQf5LzkR5Ozg81FoyUoY10boi6FC+HdWXmMY
X-Google-Smtp-Source: ACHHUZ4zPj3j+dn7OU0YBDZ7fQBf4NLJ6n6rTnKf1MOCJHcwkPkHARayhhHP+DNG2EwpCrt1IGRZ7g==
X-Received: by 2002:aa7:c3da:0:b0:518:7902:d244 with SMTP id l26-20020aa7c3da000000b005187902d244mr2728423edr.6.1686983228095;
        Fri, 16 Jun 2023 23:27:08 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n6-20020a056402514600b0051a313a66e8sm1799638edd.45.2023.06.16.23.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 23:27:07 -0700 (PDT)
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
Subject: [PATCH net v6 3/6] net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
Date: Sat, 17 Jun 2023 09:26:46 +0300
Message-Id: <20230617062649.28444-4-arinc.unal@arinc9.com>
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

BPDUs are link-local frames, therefore they must be trapped to the CPU
port. Currently, the MT7530 switch treats BPDUs as regular multicast
frames, therefore flooding them to user ports. To fix this, set BPDUs to be
trapped to the CPU port. Group this on mt7530_setup() and
mt7531_setup_common() into mt753x_trap_frames() and call that.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8c9acf109a4e..5e4f6965cebd 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -985,6 +985,14 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static void
+mt753x_trap_frames(struct mt7530_priv *priv)
+{
+	/* Trap BPDUs to the CPU port(s) */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+}
+
 static int
 mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 {
@@ -2262,6 +2270,8 @@ mt7530_setup(struct dsa_switch *ds)
 
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
+	mt753x_trap_frames(priv);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
@@ -2361,9 +2371,7 @@ mt7531_setup_common(struct dsa_switch *ds)
 	struct mt7530_priv *priv = ds->priv;
 	int ret, i;
 
-	/* Trap BPDUs to the CPU port(s) */
-	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_BPDU_CPU_ONLY);
+	mt753x_trap_frames(priv);
 
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
-- 
2.39.2


