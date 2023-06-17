Return-Path: <netdev+bounces-11681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72AC2733EB2
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22A0D28193D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165494A15;
	Sat, 17 Jun 2023 06:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EDE63B0
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:27:15 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF671BC9;
	Fri, 16 Jun 2023 23:27:12 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-970028cfb6cso230701266b.1;
        Fri, 16 Jun 2023 23:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686983231; x=1689575231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzUSkHsCSsJmBb6bzGF4ZwyaQhgjnGKQWYEkiJxrxaM=;
        b=rYi/RtSyLqy5bWLqGt0ua8fuOhEhe8K7JBEXGi9K32coh6Vyow3MwESyU4oYq4U/Or
         2Uzdp6WX0f+qifPKKJqkkatcGM87eJBslx85vBKgiWwSzczCJZfbqzfbdFrEPWPcXEaA
         rYVQuqly74HU9tEmc7vMKkCxK24fPw7GcMKJL4IUCdQ6dbp22HHWgcX7ksI4qSyf4lIi
         vpz8xqE5bLl4gYJxcWcUXER0zcl3tAE0iXkBLlDl5g4i6bH9FC24no7NLVYuf07iac/I
         nNzRhFFyqXfPxZlNZrZKCpp34tQ3DEWpVYfeI6LNNb51N5+4Tmrh68KYWfzb6Q4Unbhq
         Yq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686983231; x=1689575231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzUSkHsCSsJmBb6bzGF4ZwyaQhgjnGKQWYEkiJxrxaM=;
        b=bsuFgmAQnHFN6gDF4Ipz5PvDMZ4rCo1zZ2B9o7/SVUa9yPmQyxHQL+IjV0FQo+pkc+
         TpbJSHEOAtIxuxXaEQZoyYANH4r6cKCA5HKYygwFRRH+DTHUK+uL0ZcL1x3VevATFhOQ
         ABIxBXBWzp+vhGxCTOH14eSk4PJMY7nXjJTVkT7ZkAJKpP7o1RfhJEP6605fC3BgpDzW
         n08oxN+drbEWZiG0B4ipRzfd2cvyTjfDwfcjGvBT+9Uws2X8/aejO2U8ZphKCNNb5YxK
         g2m5o5lsFbq80zAR+Iy7Ic+FlV5IoTBWwSsufNIWeC8sd2SElB+rIVBA5bJU4d9S72LB
         tKJg==
X-Gm-Message-State: AC+VfDxuYzTd5I5rgj6bomlwhKIvE8tvbfPsAwysenFfR9SzrMxlDRFW
	5nCxNkCwWeSvJMSu1dP/5Y4=
X-Google-Smtp-Source: ACHHUZ4mu9ZC+w/4oUQSxU3JhJ2Q5DNpED7Z8RdUfHgaWnIgkiFZ49jbu/IdKY2HZnYFIIK1MHECxA==
X-Received: by 2002:a17:907:9621:b0:982:26c4:e4b0 with SMTP id gb33-20020a170907962100b0098226c4e4b0mr5446197ejc.6.1686983231304;
        Fri, 16 Jun 2023 23:27:11 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n6-20020a056402514600b0051a313a66e8sm1799638edd.45.2023.06.16.23.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 23:27:10 -0700 (PDT)
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
Subject: [PATCH net v6 4/6] net: dsa: mt7530: fix handling of LLDP frames
Date: Sat, 17 Jun 2023 09:26:47 +0300
Message-Id: <20230617062649.28444-5-arinc.unal@arinc9.com>
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

LLDP frames are link-local frames, therefore they must be trapped to the
CPU port. Currently, the MT753X switches treat LLDP frames as regular
multicast frames, therefore flooding them to user ports. To fix this, set
LLDP frames to be trapped to the CPU port(s).

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 drivers/net/dsa/mt7530.h | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 5e4f6965cebd..6d6ff293900c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -991,6 +991,10 @@ mt753x_trap_frames(struct mt7530_priv *priv)
 	/* Trap BPDUs to the CPU port(s) */
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
+
+	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
+	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
+		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
 }
 
 static int
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


