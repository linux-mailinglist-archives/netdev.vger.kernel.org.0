Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5879379C79
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhEKCIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhEKCIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:34 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2C4C061760;
        Mon, 10 May 2021 19:07:27 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o6-20020a05600c4fc6b029015ec06d5269so371098wmq.0;
        Mon, 10 May 2021 19:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lOhZtmXqoRB7AbKYw3B3ViWwWTWCEQNKhNHuzYiWBKQ=;
        b=Z7DVqFr6vUqNoLQbRWHtgaM31u1Jd5UsklU2u5hrRm4SfbnGAPGMVxe4t92LLCa2Uj
         SfEoxu8zK1B9qPdS2bOCiDC5VNJ1VdoFTpWrsUVhrDpYbs42h0n0YvkZSGJyi6T7mnXJ
         SJxINngF2TGh5AEwvvGh9yIfuIxKC1kdN9HVFnRWOvuU/HmnAcp/vfXAKf9/NSEMV1jY
         6J+3ks+GR5B3vWQ+wT3olYX6vAmW36pm1lbo9hGe4b+F8kCJ4TJrTnxyNGU/pk1j2/Em
         wZMRT6aTEMMylG3Dv7+jzKn6MSSG24vkFET1v5jwpcSWt0WR7tQuVcwLZgi0rqxAeVaT
         vR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lOhZtmXqoRB7AbKYw3B3ViWwWTWCEQNKhNHuzYiWBKQ=;
        b=AeL5O2pWZsTAXjeXhwT1mJkUnlUMyW75JAAF9dG8Rb1hUylkDW3IgfiDtyVK0xRtjY
         pHHDpdbQ99xY2pIMfDNyOoDvrOS7XabaAeU6l4Anw6/7tA3Elf8KrUzzfuSTf8wfDTDa
         EpCtaRNTfldozZVitIk+CE9MEC5Hr83mYBuqCyAFSfex8W7vYykjM7jPLid9mUTTSMBG
         iYNluMz2CiBbcSYgi4ZrIog48t+KIzQephuY0jLYQrOk+CqGQjvf0PDLp9Nu9aTqKfLY
         GIY9JCgS3oYIVbiCj7655+2z3XK2kHr1oPBbk5vlfK77G/CI7uOUiIVnVZsTi/8gwElb
         pvQw==
X-Gm-Message-State: AOAM532Bx7PS/3tMZffiW8USmO0uCToi+CL8wYPGL59Ne0J8/I5ePzkY
        SinNod9uK8Qn2hgx1DHlgtk=
X-Google-Smtp-Source: ABdhPJycOkHe1MkE/UKKktWJ4oRTGdQBCnYZ7x5W/y59WmNWjS7K1RJ0SGM+OVYBgGqbBX3OxVWkcA==
X-Received: by 2002:a1c:1982:: with SMTP id 124mr30253383wmz.148.1620698846267;
        Mon, 10 May 2021 19:07:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:25 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 04/25] net: dsa: qca8k: handle qca8k_set_page errors
Date:   Tue, 11 May 2021 04:04:39 +0200
Message-Id: <20210511020500.17269-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a remote possibility, the set_page function can fail. Since this is
a critical part of the write/read qca8k regs, propagate the error and
terminate any read/write operation.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3c882d325fdf..c9830286fd6d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -127,16 +127,23 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 				    "failed to write qca8k 32bit register\n");
 }
 
-static void
+static int
 qca8k_set_page(struct mii_bus *bus, u16 page)
 {
+	int ret;
+
 	if (page == qca8k_current_page)
-		return;
+		return 0;
 
-	if (bus->write(bus, 0x18, 0, page) < 0)
+	ret = bus->write(bus, 0x18, 0, page);
+	if (ret < 0) {
 		dev_err_ratelimited(&bus->dev,
 				    "failed to set qca8k page\n");
+		return ret;
+	}
+
 	qca8k_current_page = page;
+	return 0;
 }
 
 static u32
@@ -150,11 +157,14 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(bus, page);
+	val = qca8k_set_page(bus, page);
+	if (val < 0)
+		goto exit;
+
 	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
 
+exit:
 	mutex_unlock(&bus->mdio_lock);
-
 	return val;
 }
 
@@ -163,14 +173,19 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page);
+	if (ret < 0)
+		goto exit;
+
 	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
+exit:
 	mutex_unlock(&bus->mdio_lock);
 }
 
@@ -185,12 +200,16 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
 
-	qca8k_set_page(bus, page);
+	ret = qca8k_set_page(bus, page);
+	if (ret < 0)
+		goto exit;
+
 	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
 	ret &= ~mask;
 	ret |= val;
 	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
 
+exit:
 	mutex_unlock(&bus->mdio_lock);
 
 	return ret;
-- 
2.30.2

