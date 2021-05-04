Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459BB37326A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbhEDWbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbhEDWan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9213DC061347;
        Tue,  4 May 2021 15:29:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b17so9255905ede.0;
        Tue, 04 May 2021 15:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=osqAi6pgCX1me63QVpuWQn0dxsiBs4bgo4pfRN02oxw=;
        b=Qded4/PfOpZwbNzKUKrQe1Nbw5Gr67Hic4I8Y/DZcRa96I8CnGuhr/obU/x1XAgUwz
         Z2AsL+tcc3Ug3s/tDQ+/qmm09vVOakDEfdJRH/nbObXojToh+IRBRa5VeXeOCJJ8DZcj
         sgr3v5XU+/yWkf5Dwb3sE8j04dE4WI1RmxTAOK97vo+GNQwCCjLyQoQVBoUk2M9KX0/+
         H6GPtCa0h6YeMe3hCWFpNACk1LNmnECm8nDISxMINhjbUKQ/hYxyIbu/r+VrV5AtkBbE
         H8FEAnt8iKd7xHV4Kmi8NC2NyFjyT7tMgcga6Y1cU+bImMeYUHcdu+f9hIi060piiJXG
         NDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osqAi6pgCX1me63QVpuWQn0dxsiBs4bgo4pfRN02oxw=;
        b=Hjkl3t8k+0wNq4e1N7stwFRw+VS3wNnTTXv7+lj6daQalg/TTdgJArGenOmwM09HPD
         BAy6z7F3+rLDFXwd30CsFqH3eCze5fzrAZBT04dj+VGyyPBdSsFeGi102lflVSOgRqx2
         YHuzMcTALU788xK9x3Y4J3Im1Vo/B+ydzKNDYR6qrHLY4z03sbCub94kXoH5fA6x+GQg
         Wr2/xyvd4fEUXtFgSZObTKLyyVDHB8mKbP+FYlnknNHoQdysWF7RI/U1CjkF9XozIOIH
         KiSrqe1oW7vsq1uokh+Zn2GB2Mc1a1IBuDpVvPs0q/39p+S76DLKNmLHgFuCBtqLJu1c
         Yeww==
X-Gm-Message-State: AOAM533M9OTxdk/YrwUk21vNUvmOQOOZDC1PxwktEe0Ae9TnJUVfM91A
        L7G8b3FhIVCFz8k6k11KLpLMXQUSJZ5Gqw==
X-Google-Smtp-Source: ABdhPJz06ae6JlDJosGHE4OiHL4U4AH3QHyhZbqMapsRFexFyFQQrf3dd25xQA8DDjbBPeb3MlGgWQ==
X-Received: by 2002:a05:6402:3079:: with SMTP id bs25mr28969670edb.146.1620167385252;
        Tue, 04 May 2021 15:29:45 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:44 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 11/20] net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
Date:   Wed,  5 May 2021 00:29:05 +0200
Message-Id: <20210504222915.17206-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch qca8327 needs special settings for the GLOBAL_FC_THRES regs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 10 ++++++++++
 drivers/net/dsa/qca8k.h |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9e034c445085..ce3606d8e6a4 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -933,6 +933,16 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
+	if (data->id == QCA8K_ID_QCA8327) {
+		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
+		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
+		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
+			  QCA8K_GLOBAL_FC_GOL_XON_THRES_S |
+			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S,
+			  mask);
+	}
+
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 34c5522e7202..5fb68dbfa85a 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -166,6 +166,12 @@
 #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
+#define QCA8K_REG_GLOBAL_FC_THRESH			0x800
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		((x) << 16)
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES_S		GENMASK(24, 16)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES(x)		((x) << 0)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S		GENMASK(8, 0)
+
 #define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
 #define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
 #define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
@@ -242,6 +248,7 @@ struct qca8k_match_data {
 };
 
 struct qca8k_priv {
+	u8 switch_revision;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

