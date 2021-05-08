Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F029B376DC5
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhEHAbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbhEHAaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABB9C061574;
        Fri,  7 May 2021 17:29:37 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h4so10842301wrt.12;
        Fri, 07 May 2021 17:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nIxHNmyeWsGG00RmLkvPUBT8RdWEEbTr8lmBCb8DBrk=;
        b=MnPwvLVCtjpd+6BffzjxuDm8/yeXzUPZuUL24wfWqDFMtbnElQJ7MFPVJorS6NPfU6
         H0CR+p05O20QJC0uiTLJzxmaWHHyZy1BqzvnZMuxRNmC0+Gz+vFBAc+Dd9uGPByXTibd
         C6/7OfPpQcafZl8J9/iVFFzKixgBDMWrU+6lVYP0SH3TU7bMwEWd2CIVK/rudcCl2ZKP
         p31hGn63AJdQkERmEijaxuV3HaFNBumkqyUPpow3r4NFP4Ilso5cmejLliSwFfxMs1Oq
         05/vAdySsrrf0jplDoaZspLRU+C2l7YdFXFh8MvqljCyqWSqaLsI5DqipzgYdsZdi1cs
         G3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nIxHNmyeWsGG00RmLkvPUBT8RdWEEbTr8lmBCb8DBrk=;
        b=RHne6X3PFmDJYVPsjV65rHXm9/4j8KFctC9UP37nxsL4d1OtgrMjG9ZKds6smpDYrK
         9mIQUjP1uDYkbA4msJP1o3s1dOk2gNHcQmMHkgCXWZq+VGr3pCcVkSw+9V7AuRBMaBCU
         5GBB8nYvG0KNfaH/ORx6jVl5ZEfgXEifr8sduzqeu/qlBXKrrc5xYu+ZBwCZ57TMAzEh
         sPaGPFWdSNi0Um5aknHxeIiKyhYD7MsO6seUNLGJbUFhDYxJDRLlSbBHWJ0JEnPXHB6S
         VmXBEEC67iMNV4mqE/QM2psVs72PGpdB0JqTcieg5EEkCSwZCt1jSA9kgY2kG5fBSeK6
         RBPQ==
X-Gm-Message-State: AOAM5336PAwvTvpE97R6dMGD72QCEy1Km0a/iOexcrL9ZCPRnfjLGlBS
        nephQtLwH84qyFCpIf6Bxo4YNzNl7cC6ow==
X-Google-Smtp-Source: ABdhPJy3uxQM8EF/5R0xi5CTzAQecacq2oz9G68dUZXgr5rIfQUWrV3hrAM+FIghs8Mj5TkjYigr4A==
X-Received: by 2002:adf:da51:: with SMTP id r17mr3448958wrl.232.1620433776296;
        Fri, 07 May 2021 17:29:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:35 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 16/28] net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
Date:   Sat,  8 May 2021 02:29:06 +0200
Message-Id: <20210508002920.19945-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
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
index 612fa77164ae..301bb94aba84 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -942,6 +942,16 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
+	if (priv->switch_id == QCA8K_ID_QCA8327) {
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
index 42d90836dffa..eceeacfe2c5d 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -168,6 +168,12 @@
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

