Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0FE2D23FB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgLHHBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgLHHBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:01:16 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8665BC061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 23:00:36 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id f9so12414530pfc.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 23:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CfWeqWh61B0oRT0px5jYa6HR5aemQ0N4hQFEILa6eSc=;
        b=sTNj3vmB0ESAzGBue/fZBJ2VjpLAKFV/yTV93WLNRsKS/rxLfvRS6OYoBI4/IJs2b0
         44MA2Ajg1lxvI3JcsQmENW7BJei0HPXbsrHtDn+pG66J8nIjnVzgDOxCvQRU8QG56U3i
         09cwZLMKCGb5ps4ZBEu3FRRSQPB7PkakLkRSJ3ZAlsYxU/1739uWPXWxTtyM2X0auLel
         PLx18tCavjWtQf98KSTOV4YImc+r4ZthAPTMC3oOnhIY8GL1O6j1rODX9cSm/qa/Bqsr
         9CB3mjz7oIJ6u9MHBHb1IsXBU+lgGtwlpmaUJdxZLZ5ZDu31HaW35BU7R3iRAS+hhoD8
         Qk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CfWeqWh61B0oRT0px5jYa6HR5aemQ0N4hQFEILa6eSc=;
        b=bW6olmOzJ6VoEXWlcOkq1Q73EulM2MjynjsesSrw47vX+lCAUJZxBBZpxhWdMzTfme
         vytReXaE/HhSZNJ1lioon0hfYcwRreNET70LU4NPNeYUOTbWytyzyAZXhyuLKDPbHPK1
         gFNcqDKKShjLoZ4X1V2l+9m1lwxxBpP8iSRu8zC1fluKyNWR+C54RB2KjbBhNAFSlxzG
         9fgNmAga3ddRYIB2bUcEu5+dPxEIVtl24PFWNOzriIuYJYp+zqtFm0nTexXlGZdUZlHO
         yKAe1nVw5BPZweYCW0DNDqCah7zvIrzP/FWNYg+7YRq27kch0SOasbRsPQbUtZVgh2yg
         BqZw==
X-Gm-Message-State: AOAM531/6zy3OMnbvyOjFyyW+DFOIq4+fIjqrhjPiQ57UQJSlz+QGAm0
        CJ8cIJmX3PdI4+JLDz7+0R02XttkiHzD9oUv
X-Google-Smtp-Source: ABdhPJy23mkSUGG/pkx2q3rwy0qiTqQt1Pdz0w109V8bYUYR6mvqLkwen7oyQejVBZumcBi3g4haQg==
X-Received: by 2002:a62:aa06:0:b029:19d:f4d3:335e with SMTP id e6-20020a62aa060000b029019df4d3335emr9957570pff.60.1607410835733;
        Mon, 07 Dec 2020 23:00:35 -0800 (PST)
Received: from container-ubuntu.lan ([218.89.163.171])
        by smtp.gmail.com with ESMTPSA id a22sm13402414pfa.215.2020.12.07.23.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 23:00:34 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net-next] net: dsa: mt7530: support setting ageing time
Date:   Tue,  8 Dec 2020 15:00:28 +0800
Message-Id: <20201208070028.3177-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530 has a global address age control register, so use it to set
ageing time.

The applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 41 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 13 +++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6408402a44f5..99bf8fed6536 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -870,6 +870,46 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(mt7530_mib);
 }
 
+static int
+mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct mt7530_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	unsigned int tmp_age_count;
+	unsigned int error = -1;
+	unsigned int age_count;
+	unsigned int age_unit;
+
+	/* Applied timer is (AGE_CNT + 1) * (AGE_UNIT + 1) seconds */
+	if (secs < 1 || secs > (AGE_CNT_MAX + 1) * (AGE_UNIT_MAX + 1))
+		return -ERANGE;
+
+	/* iterate through all possible age_count to find the closest pair */
+	for (tmp_age_count = 0; tmp_age_count <= AGE_CNT_MAX; ++tmp_age_count) {
+		unsigned int tmp_age_unit = secs / (tmp_age_count + 1) - 1;
+
+		if (tmp_age_unit <= AGE_UNIT_MAX) {
+			unsigned int tmp_error = secs -
+				(tmp_age_count + 1) * (tmp_age_unit + 1);
+
+			/* found a closer pair */
+			if (error > tmp_error) {
+				error = tmp_error;
+				age_count = tmp_age_count;
+				age_unit = tmp_age_unit;
+			}
+
+			/* found the exact match, so break the loop */
+			if (!error)
+				break;
+		}
+	}
+
+	mt7530_write(priv, MT7530_AAC, AGE_CNT(age_count) | AGE_UNIT(age_unit));
+
+	return 0;
+}
+
 static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
@@ -2564,6 +2604,7 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.phy_write		= mt753x_phy_write,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
+	.set_ageing_time	= mt7530_set_ageing_time,
 	.port_enable		= mt7530_port_enable,
 	.port_disable		= mt7530_port_disable,
 	.port_change_mtu	= mt7530_port_change_mtu,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ee3523a7537e..32d8969b3ace 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -161,6 +161,19 @@ enum mt7530_vlan_egress_attr {
 	MT7530_VLAN_EGRESS_STACK = 3,
 };
 
+/* Register for address age control */
+#define MT7530_AAC			0xa0
+/* Disable ageing */
+#define  AGE_DIS			BIT(20)
+/* Age count */
+#define  AGE_CNT_MASK			GENMASK(19, 12)
+#define  AGE_CNT_MAX			0xff
+#define  AGE_CNT(x)			(AGE_CNT_MASK & ((x) << 12))
+/* Age unit */
+#define  AGE_UNIT_MASK			GENMASK(11, 0)
+#define  AGE_UNIT_MAX			0xfff
+#define  AGE_UNIT(x)			(AGE_UNIT_MASK & (x))
+
 /* Register for port STP state control */
 #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
 #define  FID_PST(x)			((x) & 0x3)
-- 
2.25.1

