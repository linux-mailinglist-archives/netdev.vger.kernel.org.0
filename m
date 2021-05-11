Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8769379C86
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhEKCJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhEKCIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:38 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0542C06138F;
        Mon, 10 May 2021 19:07:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g65so10203220wmg.2;
        Mon, 10 May 2021 19:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e8E4taDWDkn6x+puoWyXqPUCXo9lK/+PWbdX0SI+nIU=;
        b=BdtAns+gVfXGYnRlXyAw9RttLuM3yJrBwDkrkYaScinXJSnI07sDZ8EokVjAPCTetN
         plemdZNJX2P/FPxnBZYtvbhYxqgg3HdJyD/bBuVg+XHnMhHCpdtO1jzGV6x/KFH1zhHE
         r0bpJ/av+6GfBKaLQBQP8f8K1HV+FQs4c4x2YNg5BEAR6vG5nOMeegk80AK2WmmPh13t
         YfTrmRXazvRkdO76GADuNG6F3MjcLym+jBkVBk7iQk9us7In8ZKCf16jlOOKSlziuQ5j
         KcUA5qBY6ccDeGGxEOfN2tYkPZoMSezyG9otXuZeqJRzhqE3oqfgLpsRl+dwh8IOh0BW
         n47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e8E4taDWDkn6x+puoWyXqPUCXo9lK/+PWbdX0SI+nIU=;
        b=AvdCf+uiNzK1zdlEWyJ8Xyy7F7ZTS35QDt4WZZZ6D1rL+5g4k5HxIhtMlfoYNlQSLl
         qDGVtCBul07uCSy1hTWYKu7UNNSG+MHW+0+d/tStTXZ3BwjtskolfOSftIPXtelrXeQm
         Cnemdh6Mm83QoX1Gds/dUeqdZya69Q0sP67XntNR2Q+YdKHFdWPCDKz0qhZgkcRgpRsw
         gxcne81lE0454oHN/81AREkQsmR3kXabq0G5xhwQAXrir+sST8MEj+16JJ4hC1JnAyb8
         Fa13oO1GnR8kZR+h0eX+swg9WOuPKw8HfBn5PYeygSD0TxAx9GnFqS5aRTWOEf61pyQ9
         Rd9g==
X-Gm-Message-State: AOAM532aE2Av+oQAx02s7PJYG0KwlDAE1KueJqW+0ZbE66XOspES/qx5
        mIo5iDD14PBDSLRuAZbTQ11fvzBWrm2kkw==
X-Google-Smtp-Source: ABdhPJx197/e6z6/PrLywhOMtln9HcOxCDMz85wjLcTiZRc+IZlhDOdaV8m7HjogVvhal3HNRg7whA==
X-Received: by 2002:a1c:f20d:: with SMTP id s13mr29553679wmc.92.1620698850446;
        Mon, 10 May 2021 19:07:30 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 08/25] net: dsa: qca8k: handle error from qca8k_busy_wait
Date:   Tue, 11 May 2021 04:04:43 +0200
Message-Id: <20210511020500.17269-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Propagate errors from qca8k_busy_wait instead of hardcoding return
value.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 409f6592048a..d4e3f81576ec 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -388,8 +388,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 		return ret;
 
 	/* wait for completion */
-	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
-		return -1;
+	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
+	if (ret)
+		return ret;
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_FDB_LOAD) {
@@ -468,8 +469,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 		return ret;
 
 	/* wait for completion */
-	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
-		return -ETIMEDOUT;
+	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
+	if (ret)
+		return ret;
 
 	/* Check for table full violation when adding an entry */
 	if (cmd == QCA8K_VLAN_LOAD) {
@@ -580,7 +582,9 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	if (ret)
 		goto exit;
 
-	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
 	if (ret)
@@ -670,9 +674,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	if (ret)
 		return ret;
 
-	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-			    QCA8K_MDIO_MASTER_BUSY))
-		return -ETIMEDOUT;
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+	if (ret)
+		return ret;
 
 	val = qca8k_read(priv, QCA8K_MDIO_MASTER_CTRL);
 	if (val < 0)
-- 
2.30.2

