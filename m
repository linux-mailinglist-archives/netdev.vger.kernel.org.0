Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92D21A6BF9
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 20:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbgDMSQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387623AbgDMSQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 14:16:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238C0C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 11:16:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q16so3360246pje.1
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 11:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j21xT+HUPj9k0Z5f92Fd7xH9/e7CeRXmKM1ZoImCx5M=;
        b=VINHtc9xJ5GosVqAlvvnFCbxSWh7VJo+Vt6/AxIS7yJTchl8UEE7VePtda2FZUx74Z
         cA9hn1k1Kp27XdXed6dBn3CcwSb6QOq2z5WjFI3rRTholIStE8AmLYKgIe725zn8yMu+
         BIVy2Mtu9MotyhdJzavY5vouHXb38gb5qpfhojmTvrdKn2zTUcdtsd3S9iKTFxHNjrIs
         LtM8qtORM1PQGwFN9y343M+vC2LLd3zn3znmnaK9tsrZ7r2BxBPbWAlUSbdgGXtTzaec
         uygf7wg3FbsQAuvBWo07Qf41HVK/WPTHbj6oBkxKAqY+VYulNE3o6nrAJZdRsymLh8kL
         r5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j21xT+HUPj9k0Z5f92Fd7xH9/e7CeRXmKM1ZoImCx5M=;
        b=Qj3ApRDSJKTzqaQEeRpumt4YoTfuEdPuSPTq2r0p5qBYJvIcKmFpBX5uUtNBNX10Sl
         pZKQy5UW6/NRPgy0IGHHAPkZneeu6S2v0DYQffSfLK6sqyNHvMTOJVDlYj0jc6cz2ryU
         wjF7gp1wTiUClqQhOfIIJ4TH02wGHGkhKppia1HymRIi0PbkXCARGKwOU3vY6R/axzEI
         xgFlk3fPFUCpBPygewZiyLTL3ovBGTBW+RxgGj3iem1RqNcWVJAcskQ1Hq4E6D4K9kOd
         0mrV2E0NOaYC/mqgsJGxVx5bJN8buU+XN6pyCGBMlBMConQCvhrsWPEkDdvbw2g9MIxU
         NTVg==
X-Gm-Message-State: AGi0PuaXJHP0x92RV/zEpB1VN+yfUhQ0fcGVHBSPrxD8kCO9dNAU/TUJ
        qo9hk/iCDsiivhoGTR2nm3MuZ64hen0znQ==
X-Google-Smtp-Source: APiQypIqjWdZrIlMS6qfzHXhtbthjJ77+hCDdfA9q7bBcxvKnvDHxC6F7gXGYItH1WBJLUXa8FbzQg==
X-Received: by 2002:a17:90a:2526:: with SMTP id j35mr18830263pje.98.1586801777400;
        Mon, 13 Apr 2020 11:16:17 -0700 (PDT)
Received: from P65xSA.lan ([2402:f000:1:1501::7416:1d81])
        by smtp.gmail.com with ESMTPSA id y71sm9302109pfb.179.2020.04.13.11.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 11:16:16 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        Stijn Segers <foss@volatilesystems.org>,
        Chuanhong Guo <gch981213@gmail.com>, riddlariddla@hotmail.com,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Szabolcs Hubai <szab.hu@gmail.com>,
        CHEN Minqiang <ptpt52@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH net-next] net: dsa: mt7530: fix tagged frames pass-through in VLAN-unaware mode
Date:   Tue, 14 Apr 2020 02:16:09 +0800
Message-Id: <20200413181609.29566-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In VLAN-unaware mode, the Egress Tag (EG_TAG) field in Port VLAN
Control register must be set to Consistent to let tagged frames pass
through as is, otherwise their tags will be stripped.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 18 ++++++++++++------
 drivers/net/dsa/mt7530.h |  7 +++++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2d0d91db0ddb..951a65ac7f73 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -846,8 +846,9 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	 */
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 		   MT7530_PORT_MATRIX_MODE);
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT));
+	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_TRANSPARENT) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		if (dsa_is_user_port(ds, i) &&
@@ -863,8 +864,8 @@ mt7530_port_set_vlan_unaware(struct dsa_switch *ds, int port)
 	if (all_user_ports_removed) {
 		mt7530_write(priv, MT7530_PCR_P(MT7530_CPU_PORT),
 			     PCR_MATRIX(dsa_user_ports(priv->ds)));
-		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT),
-			     PORT_SPEC_TAG);
+		mt7530_write(priv, MT7530_PVC_P(MT7530_CPU_PORT), PORT_SPEC_TAG
+			     | PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 }
 
@@ -890,8 +891,9 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 	/* Set the port as a user port which is to be able to recognize VID
 	 * from incoming packets before fetching entry within the VLAN table.
 	 */
-	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK,
-		   VLAN_ATTR(MT7530_VLAN_USER));
+	mt7530_rmw(priv, MT7530_PVC_P(port), VLAN_ATTR_MASK | PVC_EG_TAG_MASK,
+		   VLAN_ATTR(MT7530_VLAN_USER) |
+		   PVC_EG_TAG(MT7530_VLAN_EG_DISABLED));
 }
 
 static void
@@ -1380,6 +1382,10 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_cpu_port_enable(priv, i);
 		else
 			mt7530_port_disable(ds, i);
+
+		/* Enable consistent egress tag */
+		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
+			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
 	/* Setup port 5 */
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ef9b52f3152b..aaf8b88c864f 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -172,9 +172,16 @@ enum mt7530_port_mode {
 /* Register for port vlan control */
 #define MT7530_PVC_P(x)			(0x2010 + ((x) * 0x100))
 #define  PORT_SPEC_TAG			BIT(5)
+#define  PVC_EG_TAG(x)			(((x) & 0x7) << 8)
+#define  PVC_EG_TAG_MASK		PVC_EG_TAG(7)
 #define  VLAN_ATTR(x)			(((x) & 0x3) << 6)
 #define  VLAN_ATTR_MASK			VLAN_ATTR(3)
 
+enum mt7530_vlan_port_eg_tag {
+	MT7530_VLAN_EG_DISABLED = 0;
+	MT7530_VLAN_EG_CONSISTENT = 1;
+};
+
 enum mt7530_vlan_port_attr {
 	MT7530_VLAN_USER = 0,
 	MT7530_VLAN_TRANSPARENT = 3,
-- 
2.26.0

