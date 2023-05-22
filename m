Return-Path: <netdev+bounces-4279-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E80670BDF2
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B4181C20A86
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19EE16433;
	Mon, 22 May 2023 12:17:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B064F1640D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:23 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFE9170E;
	Mon, 22 May 2023 05:17:10 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f6e83e12fso489794466b.1;
        Mon, 22 May 2023 05:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757830; x=1687349830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqRoVOW5ATPKkmSDchjmJB2cTgfNIDW4SGp9tBnvP0Q=;
        b=pUw4uKIUNJh5QEQn8is2R/h6lUbhpzqig1b4ddexVTPPD9XVIqJ9g/wMetQyRjn/s7
         iyIKR2mc40MhSUcoC26nUXn9ZJgchgDimE5YicIDCx2k72qNqSvIfXw8XSbIm0nZjI/2
         ZNKZvbWbdT7tUqstSqQQuknQZ+KQVxgJljPqP8DsyHGp00yDl/FmeJ2tOO0QVn8LfqJ8
         cqNZjEBvuMLPRx7VkW9vxZESHTDhL0JR4mrys+CwGHuaM5WfD4PDegQPyLj2RuAJ7gEi
         DDtuYHcfsS9wxf8QoW7c3BS6C0EvcavSrBErQHu0xHwiqKp/M7qqwKR5whWOaTBjpIav
         mMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757830; x=1687349830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqRoVOW5ATPKkmSDchjmJB2cTgfNIDW4SGp9tBnvP0Q=;
        b=JYvSQoeJaF5xismkStu+24We8S7Z4j8kAWCLCE/rt39gtgqYAllnXg/Ll9NGPA+WQM
         euqgUMtAL72AcGA60jSeylaSJk6k4WFE1Q5X5LsyNgBPFmOkJHHHfrYpXjr1WVNHs/TR
         WEUBGnPkvRazRFy4wXARb+lTi/HAjEsOy0VjAq/1W1nNo1gEfDKBn+2G4ChS98lcRX40
         dWa8gHdStfLiE+JII9LRoVAfkyDrlLZOayfI+ysiaekLPrZT7PrQxPGJbX5iNPaDV5r6
         7UfNWgvJ3N5f5PgoDNWD1z5gMeX+rN2eTvTA8xgdj4nfXocCgvRARa99UTs6CmEJrUWQ
         5gvg==
X-Gm-Message-State: AC+VfDzspjaMGd4wpfXww6p25Ma8KvUrtOuKW9qVT3pqxNpSRlO+2I0S
	x37zDW81wpfbsEcANLUCQnE=
X-Google-Smtp-Source: ACHHUZ7S5doXEQbzc7jj+Nwm/KeUfeIBOBxtvMLCkdUE7EEsyV+Swmuat4wLSM2bpWQovi+wxudbjQ==
X-Received: by 2002:a17:907:25c2:b0:96f:8439:6143 with SMTP id ae2-20020a17090725c200b0096f84396143mr7741710ejc.40.1684757830174;
        Mon, 22 May 2023 05:17:10 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:17:09 -0700 (PDT)
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
Subject: [PATCH net-next 28/30] net: dsa: mt7530: introduce LLDP frame trapping
Date: Mon, 22 May 2023 15:15:30 +0300
Message-Id: <20230522121532.86610-29-arinc.unal@arinc9.com>
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

The MT753X switches are capable of trapping certain frames. Introduce
trapping LLDP frames to the CPU port(s) for the MT753X switches.

For MT7530, LLDP frames will be trapped to the numerically smallest CPU
port which is affine to the DSA conduit interface that is set up. The LLDP
frames won't necessarily be trapped to the CPU port the user port, which
these LLDP frames are received from, is affine to.

For MT7531 and the switch on the MT7988 SoC, LLDP frames will be trapped to
the CPU port the user port is affine to.

The bit for R0E_MANG_FR is 27. When set, the switch regards the frames with
:0E MAC DA as management (LLDP) frames. This bit is set to 1 after reset on
MT7530 and MT7531 according to the documents MT7620 Programming Guide v1.0
and MT7531 Reference Manual for Development Board v1.0, so there's no need
to deal with this bit. Since there's currently no public document for the
switch on the MT7988 SoC, I assume this is also the case for this switch.

Remove the ETHSYS_CLKCFG0 register which doesn't exist on the said
documents, and conflicts with the MT753X_RGAC2 register.

The mt753x_bpdu_port_fw enum is universally used for trapping frames,
therefore rename it and the values in it to mt753x_port_fw.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 12 ++++++++++--
 drivers/net/dsa/mt7530.h | 23 ++++++++++++-----------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2fb4b0bc6335..8f5a8803cb33 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2225,7 +2225,11 @@ mt7530_setup(struct dsa_switch *ds)
 
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
@@ -2325,7 +2329,11 @@ mt7531_setup_common(struct dsa_switch *ds)
 
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
index 52e5d71a04d3..2664057b3cd2 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -25,10 +25,6 @@ enum mt753x_id {
 
 #define TRGMII_BASE(x)			(0x10000 + (x))
 
-/* Registers to ethsys access */
-#define ETHSYS_CLKCFG0			0x2c
-#define  ETHSYS_TRGMII_CLK_SEL362_5	BIT(11)
-
 #define SYSC_REG_RSTCTRL		0x34
 #define  RESET_MCM			BIT(2)
 
@@ -63,16 +59,21 @@ enum mt753x_id {
 #define MT753X_MIRROR_MASK(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_MIRROR_MASK : MT7530_MIRROR_MASK)
 
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
+#define  MT753X_R0E_PORT_FW(x)		(((x) & 0x7) << 16)
+#define  MT753X_R0E_PORT_FW_MASK	MT753X_R0E_PORT_FW(~0)
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


