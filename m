Return-Path: <netdev+bounces-11678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6F9733EAB
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4155528192B
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D8C46B2;
	Sat, 17 Jun 2023 06:27:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E914C7D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:27:05 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C896E5E;
	Fri, 16 Jun 2023 23:27:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-519c0ad1223so1933048a12.0;
        Fri, 16 Jun 2023 23:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686983222; x=1689575222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ETqwYFXP5yK+TdJrVYXjdQ9fA9ImE5ftxIHWarTd9o=;
        b=nHqrT9Mlkid+cur0QneFzCexGoIZbmibWBPkqs3PdPFkCbHzEGDi6tS3rW9MeMp7kA
         6xj70Fb6CgxwR48B1T1mDcmIy/JyPiYywgIlFblOxFBGXAMhk5bMU6JG2tXv9npBCfCW
         UvAlPILreEnqyS/vzi8/O7fEfhIIZIy7uy6cW5FaB+ySGofd61lLaXTnacpYa4OgQQuN
         c7rr0LtUsM+J0HeVb1W7uLk2CnUSZgV2crmL7b7MXZ2jpUAYRkCcX96NByV4jQQWOdu7
         HMw5meASQYoX/eebQ9I+wu0cApbRln6lktClpaz5G6ntgN/BbV6HTXS8uQ7dWqng+bcQ
         fI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686983222; x=1689575222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ETqwYFXP5yK+TdJrVYXjdQ9fA9ImE5ftxIHWarTd9o=;
        b=auNaCyZfN+qL5L5pLpDtbFg9Fb6OvS70iIRxiXcsFTe+iaBO2TRVyztfdkMBH6eZyI
         LwQUaW/SjjWXRJQvKn+olSaXGG81jfUxKJ9Fef5kLNJn6ZxeuTDFDDYeSjNEFXcc2k7L
         RT+YVu5oBM1f13CGI1rbjyeQgk47ajplw4wVoYq9g7KMPPBU//jS+A7OkM8vzdmeZ6JM
         Hpe0PGGLt2f+d6dMSenRgvMt5LMUcXbjGcZN2+Gn/2HurSZrU/oX04GM5ca2tB/wyh6M
         s8Qt9JVEId1WVCUPqCLONOtS0EQqKQON3mbBQDwAUrTNhEwOkqm5MWi8x8TnBodZFnsX
         +e9Q==
X-Gm-Message-State: AC+VfDwC+1PQgayrZCVH3uK7xmsRDwhc3BT2ZParG/bx0+4omYA0XmtB
	5fCcOhWZiPHJY1W2LBqd7As=
X-Google-Smtp-Source: ACHHUZ64/5pmb6uBvnL4fx+4nHvtRhpIfWy208CSYFEWvOTketFEdZ8wF29wkOF2XVlGxgs0tAvpAA==
X-Received: by 2002:a05:6402:1496:b0:504:8929:71ca with SMTP id e22-20020a056402149600b00504892971camr2580162edv.6.1686983222257;
        Fri, 16 Jun 2023 23:27:02 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n6-20020a056402514600b0051a313a66e8sm1799638edd.45.2023.06.16.23.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 23:27:01 -0700 (PDT)
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
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Landen Chao <landen.chao@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net v6 1/6] net: dsa: mt7530: set all CPU ports in MT7531_CPU_PMAP
Date: Sat, 17 Jun 2023 09:26:44 +0300
Message-Id: <20230617062649.28444-2-arinc.unal@arinc9.com>
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

MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
frames (further restricted by PCR_MATRIX).

Currently the driver sets the first CPU port as the single port in this bit
mask, which works fine regardless of whether the device tree defines port
5, 6 or 5+6 as CPU ports. This is because the logic coincides with DSA's
logic of picking the first CPU port as the CPU port that all user ports are
affine to, by default.

An upcoming change would like to influence DSA's selection of the default
CPU port to no longer be the first one, and in that case, this logic needs
adaptation.

Since there is no observed leakage or duplication of frames if all CPU
ports are defined in this bit mask, simply include them all.

Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mt7530.c | 15 ++++++++-------
 drivers/net/dsa/mt7530.h |  1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9bc54e1348cb..f8503155f179 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1010,6 +1010,13 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
+	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
+	 * the MT7988 SoC. Trapped frames will be forwarded to the CPU port that
+	 * is affine to the inbound user port.
+	 */
+	if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
+		mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP(BIT(port)));
+
 	/* CPU port gets connected to all user ports of
 	 * the switch.
 	 */
@@ -2352,15 +2359,9 @@ static int
 mt7531_setup_common(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
-	struct dsa_port *cpu_dp;
 	int ret, i;
 
-	/* BPDU to CPU port */
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
-			   BIT(cpu_dp->index));
-		break;
-	}
+	/* Trap BPDUs to the CPU port(s) */
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 5084f48a8869..e590cf43f3ae 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -54,6 +54,7 @@ enum mt753x_id {
 #define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & MIRROR_MASK)
 #define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
 #define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
+#define  MT7531_CPU_PMAP(x)		FIELD_PREP(MT7531_CPU_PMAP_MASK, x)
 
 #define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_CFC : MT7530_MFC)
-- 
2.39.2


