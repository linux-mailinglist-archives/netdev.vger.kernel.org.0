Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D6A379CA0
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhEKCKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhEKCJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC8BC061761;
        Mon, 10 May 2021 19:07:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h4so18458308wrt.12;
        Mon, 10 May 2021 19:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=olSMQ1MwxwUL2PsfEAXs3IBUQCNkghcxoNWT/9YeWVE=;
        b=oxb1IPlgN9yBkLiLcZcyf/WD7UMU/K0YNo7QTwlEd0684GFM1F7r+yot9zDK04Imps
         h04XMm0R1+6qMj3tgQDPTGoWvR9pUmH+naI6iBTRnEUqTM3dhfkod7aq/g5S/OvFEEwC
         kJi+F2OboCZCHMyGT5jxFtD8e6du5wRLqGJBvcmlMJpqOqoV6MvqbLpS5w4At0J9aCeK
         SsjbvgNNzgPi1OD39B9E7BeJvdpjiu7PU8C3krzRHfttG2laxkgsyN3WuH/ZptHCLUiD
         Pln4FUAqTwIFQ6QJOtv8aPiGrMrOut4vlLn/3e1CsopBCokPwljfTuW6kLcy1UHdXcv/
         oxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=olSMQ1MwxwUL2PsfEAXs3IBUQCNkghcxoNWT/9YeWVE=;
        b=c45hEAN9o9hPyj/+2y5KYjMpt+8Hyf/3d28uj8Yc7qs5d4SwiyHD7Or2rytl3lXmjb
         w4I4yFveQvANkeG6lCTyHsNyzla2kenSYxHlQXhU12FUcKTOktByWQtTbkXEr9m5HV2U
         Q78YjlWieXfR60mZOlw9GfdMa8AXw6ZRnLDuEz9GHid1wFZDN8JGs4HXMDQgSZ+y/y0w
         sAFCEbxk9Q8I9/0lfId6sOmXC9xIRZOQ9ZHIXHDf0eHlXyjSn+njkbALdKGFjrBlnAm6
         gabWx2ypg+AjpdMPWC3fmeZlFO3Jq0Gx5WLvWtCC9iVc/I/G3bPk2+WHLfBkjRkoU62i
         /PwQ==
X-Gm-Message-State: AOAM532l0bBRxGagjJM1gI4Np7rN4iC1YErq4JMQDU9iYgvaz8CGP1cv
        eF7IskRBdVK9gMeKQTBIgmI=
X-Google-Smtp-Source: ABdhPJxReXeFNCAoa7qxhkVLDCTrpXsFeRemqL6VH4N1tlPr9CRsgcSYDnCaqYWO26dCOxvLd/T0mA==
X-Received: by 2002:a05:6000:504:: with SMTP id a4mr35255806wrf.51.1620698859216;
        Mon, 10 May 2021 19:07:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:38 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 17/25] net: dsa: qca8k: clear MASTER_EN after phy read/write
Date:   Tue, 11 May 2021 04:04:52 +0200
Message-Id: <20210511020500.17269-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear MDIO_MASTER_EN bit from MDIO_MASTER_CTRL after read/write
operation. The MDIO_MASTER_EN bit is not reset after read/write
operation and the next operation can be wrongly interpreted by the
switch as a mdio operation. This cause a production of wrong/garbage
data from the switch and underfined bheavior. (random port drop,
unplugged port flagged with link up, wrong port speed)
Also on driver remove the MASTER_CTRL can be left set and cause the
malfunction of any next driver using the mdio device.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ff46d253e345..6f713289703b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -649,8 +649,14 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	if (ret)
 		return ret;
 
-	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
-		QCA8K_MDIO_MASTER_BUSY);
+	ret = qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+			      QCA8K_MDIO_MASTER_BUSY);
+
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
+	return ret;
 }
 
 static int
@@ -685,6 +691,10 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 
 	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+			QCA8K_MDIO_MASTER_EN);
+
 	return val;
 }
 
-- 
2.30.2

