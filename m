Return-Path: <netdev+bounces-9999-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF53972B9A3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0CAA2811A8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24BB2DF55;
	Mon, 12 Jun 2023 08:00:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B49156D8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:38 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871C430CA;
	Mon, 12 Jun 2023 01:00:15 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f7378a75c0so28734205e9.3;
        Mon, 12 Jun 2023 01:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556813; x=1689148813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mLW++ExiYAGpOz1SvoxKGSu8dCoNxeqmwP2JI3jkkqk=;
        b=TB5gK2LoPlad2fwaIMbNsaorwK4JMuQF4hEQz6lkF+6MfTMprD/hNo48ZK+rkVy803
         IUQXBkZv2p36nvtg7DM2gIW/CYlR52uRA9UQYu/LizZ1ClbYWqO1M8tZhkj+DgQMmeKL
         Ixz0LTGVJO0XflWusap3fnAQS/0W4ihd5shyfctOPWQJTK+SMep9c3Yb5hsTcpeeW69a
         EFvoOQbMoS1Xoq8CBsVR0Daeckou8qvPBXsgKQew52g9gE9GIYV287H5Ejm+o281Hu0M
         Vvtz0tSr21n5pCy3h+21fiZV1g0hL82mUBPg4Z5yqml0VkcmHoyk+94T8qCWTs1d69oS
         HzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556813; x=1689148813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mLW++ExiYAGpOz1SvoxKGSu8dCoNxeqmwP2JI3jkkqk=;
        b=NOmZ+W9PS7ETFnhS7kTEyVPyfDT6D300RpnziAgsRY/ckj5CDKnwy9HwCyp9KBV4fR
         JXq5RzFCu/hrlwCiA87JHWq4v/9lyfzp5YupU6b9fPMP+CONsIQu8vJrnkEfHVZ8BNk9
         1o2bfm6gpahEy9ZVO4EfOynHk/fPO4ERSjXw3IXtEOL9AgmigNz94tIv2dWpKF1sOjw1
         kdKyLI1CezHlhuS5AdU7a1webD8itazmUKaFLQEkeDuZOeQyKiWmV+UYTTkRcrECdD7R
         sAUxsXd/640mbyupIck5jkNtRPZ9cej3t5l1640D8TMDRJuMvID7m7mdpzx6M3Xz0w5h
         a55w==
X-Gm-Message-State: AC+VfDyEwr6Sk7tVUYUzAq9bkACquQwp59kmRUpQMKkrYtskc1tb0pQY
	+bAjEDoMvDlubdGitHH+gwE=
X-Google-Smtp-Source: ACHHUZ4l6TALNkEBoJCoecWyLHZ2LIBS6+pRHp+GOMFIS6KGwt6s8wmCcHTyPMswS5F64jta3/wmsg==
X-Received: by 2002:a1c:7414:0:b0:3f6:d2f:27f7 with SMTP id p20-20020a1c7414000000b003f60d2f27f7mr5777447wmc.17.1686556813335;
        Mon, 12 Jun 2023 01:00:13 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003f7f2a1484csm10552195wmj.5.2023.06.12.01.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 01:00:13 -0700 (PDT)
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
Subject: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
Date: Mon, 12 Jun 2023 10:59:43 +0300
Message-Id: <20230612075945.16330-6-arinc.unal@arinc9.com>
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
user port will be trapped to the CPU port that is affine to the user port
from which the frames are received.

The bit for R0E_MANG_FR is 27. When set, the switch regards the frames with
:0E MAC DA as management (LLDP) frames. This bit is set to 1 after reset on
MT7530 and MT7531 according to the documents MT7620 Programming Guide v1.0
and MT7531 Reference Manual for Development Board v1.0, so there's no need
to deal with this bit. Since there's currently no public document for the
switch on the MT7988 SoC, I assume this is also the case for this switch.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 12 ++++++++++--
 drivers/net/dsa/mt7530.h | 19 ++++++++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e4c169843f2e..8388b058fbe4 100644
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


