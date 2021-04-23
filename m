Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9667368AA5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhDWBtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240322AbhDWBss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:48 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADB1C06134A;
        Thu, 22 Apr 2021 18:48:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g17so55027461edm.6;
        Thu, 22 Apr 2021 18:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sSWmtFvTcUAZu/Zb+36JfrIL3vEfr0W+ZYt4KTD5sQM=;
        b=S7VkY6eDOfAseD9WyrX1cyhew8QjBP+pKNWaQTg4fPmLL2YhXW5UzZn/fzGAval254
         zlu23OTvPXXWTavEWDwPqqBD+ybqrwL2jsa+cM3g/PLYnIy0uo5krmlc8fppEX5CrnY4
         6hF8sdAnzbqiJKKyDGkks9fH0SmFlck+M1rv5ZpgblCPQqOLohGqkTT1heVIiPjetJyz
         9E1ixKvUPZuj8P7mPKOd3tZdxiD7bW2bsvZekavwE5AOl6OQDH91HkYzl+bQLSL3TzD+
         GjpahMj/K+O55w7gQyLrjt1kFcDpiqDz6dknntH7awbP5OK11DgpoXBWxkYPzdoMtHuw
         /jWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSWmtFvTcUAZu/Zb+36JfrIL3vEfr0W+ZYt4KTD5sQM=;
        b=q+BNs4sTj9T0MFgeFLqPnsq+PY4RBu+gtt4piFkkF+aKemCp30D3wkwwfkBnCh3zf6
         idX1/MsJB8Pqj4JJnM/VMgEKT1GYo3eK4tpYDu18F3W8RGvb6SbVE4kSIcfBHcZjvmq3
         sa43a3CYCr2vT8EyLccC2XnjXPPhjI/6jAi+XqsoqUVUGvL7EwPDnzNDmN79hXXw3EcX
         zAvAKwsSjBE810t2INvmjjwfZEYqOn/JoyqIfW/m+1xofiN4dW5HixxAhz3q2AVm5+Aw
         BvFvoh/yULl9DrgMUdBsBp7oTJuNqS0uYedaR4gX0qxxz7w6uQ5f9KfxwNZ5sqlF9AyT
         xZEg==
X-Gm-Message-State: AOAM532K3HL5WChUl02s4JCG6+daAVKtsMeyltMxaesEUAK6n5ow14N7
        ioeWXFb9m0q1rd1arypacPg=
X-Google-Smtp-Source: ABdhPJyT+DAXNLhDhs/FyopZmzjpTUBhfWFz2AEKPioUQPtd8d0sow/raI2BMAcdJd8pSOUcXdZsQA==
X-Received: by 2002:aa7:d78a:: with SMTP id s10mr1571068edq.310.1619142484127;
        Thu, 22 Apr 2021 18:48:04 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:03 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] drivers: net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
Date:   Fri, 23 Apr 2021 03:47:34 +0200
Message-Id: <20210423014741.11858-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch qca8327 needs special settings for the GLOBAL_FC_THRES regs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 10 ++++++++++
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 19bb3754d9ec..d469620e9344 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -833,6 +833,16 @@ qca8k_setup(struct dsa_switch *ds)
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
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index d94129371a1c..308d8410fdb6 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -165,6 +165,12 @@
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
-- 
2.30.2

