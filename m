Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B269381259
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhENVCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbhENVBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:48 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90995C06138D;
        Fri, 14 May 2021 14:00:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l1so562183ejb.6;
        Fri, 14 May 2021 14:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jFt2VT9tUs6BRhCixDiYcqW5dO1+LJygh4IawFXtMZI=;
        b=UjmF68vmEbEiF5Tr85D05MfTU4f6kK8x7Jc6fW+qSkWNMYr/29aWug4FyZebeqX7zA
         uC0LqwovzfT0rj7xINYQUU7GTuUviK7UxG84KMgR40TM6n9OVe5qIh3icfp2zHCO5A6q
         9pDZQ1Dw28DNxpCrioAKJlbSsb1WqzH9aAHZjhPfsd7ffTF4RhrcH1DrO4xXBxCrWCIJ
         8NSa9QUFE8QnIdX2SLT63tago0AnSkocc4gW3A6rDjcn2KtEWTAfrYqH+nzvWQMzPZz/
         pUWAxT0ar4zkGk39pMksVsMl/HBkzwRBRYoP31ppOp1o7u0twKSzg/+MHS4w6Jw23oHL
         DJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jFt2VT9tUs6BRhCixDiYcqW5dO1+LJygh4IawFXtMZI=;
        b=CppzOxTOBLxmxt/3fwyZkJ9YZFzoDUVZ0GQWn0p0d5hS+3pxwsqzajeT2OCk7Uho0p
         YmsBAhJF1XazYdJ+5dronMpjTdPJzykk4nDFMIW16Ugc7W1C+vHnufNdNpDQQgpiAGOo
         g+7+cxGU4nk+rmiiRzsFAY88yjIE5+MrOriR2uVYH1ypnLrFi/euIdlKQYAzkKoSOEy3
         AJJ5EkBSyfdbN5BR2vaK3ATHUsFeQ7dtg0ypZzthj9wQ3w89kAcqsJLxY6vCfG5xIwk2
         jSnA/9VdtnBOhOqHtu8wXUT4mbpZyM+FOtONAFGSEWu8vWh3DSUc5gVR2R1U0vsailcu
         qv3w==
X-Gm-Message-State: AOAM531pCb5cfBJHxiCrgrmUgBRAchF7Im4bxl2tYki4RHA5lkeWTLJ+
        Q9c4Q4B1+HHXMtXA/3R4mFZzA3WF+DbcWQ==
X-Google-Smtp-Source: ABdhPJx4q7V1mHkhu4bjQLCwccEsqYmzogZb36KtiAvAy0XyiJSk63RCuhBurN+bIdsc1xyPyhvE/g==
X-Received: by 2002:a17:906:a403:: with SMTP id l3mr51750104ejz.251.1621026033304;
        Fri, 14 May 2021 14:00:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:32 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 17/25] net: dsa: qca8k: clear MASTER_EN after phy read/write
Date:   Fri, 14 May 2021 23:00:07 +0200
Message-Id: <20210514210015.18142-18-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
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
index dedbc6565516..a2b4d5097868 100644
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

