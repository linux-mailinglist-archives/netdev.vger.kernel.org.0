Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A9264EED3
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiLPQSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiLPQR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:17:56 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07E526F;
        Fri, 16 Dec 2022 08:17:55 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id a17so1837608wrt.11;
        Fri, 16 Dec 2022 08:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=af46cSNJUKc3RBIgzI62ckIW3TcyyLgIBROBWBavM6Q=;
        b=Mxasf2uzaZWv1fU10Eb5LPYsLs12MnXeOgOBKdheQ6Py7cesOELe2yQgchoKF2SWaC
         IhO1Bhdwv1Wt9DkHeWFi29YbmndG4+FSumJBWJ9wECFoMUTvAOdWQQx6FskDixqLiq06
         n5dBuFDT7sG1oL9PG5xbH9l4e7Gft3v8yzkzjM6NyLQpwVMoti1VcoFMTxW2CWgwEcth
         ctRL3k6UGuM+EFOZP0vdflirgdTtbhNT+Y7RqDvjW1LjKhCrN1Z817Mp140YMviU8M5D
         +89bsopQ2i418B+PIWy7HvAFyflHhFnb8NDI3DHRfJBO550vEMak3ak1peooKY4Ca6XY
         +r+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=af46cSNJUKc3RBIgzI62ckIW3TcyyLgIBROBWBavM6Q=;
        b=SkZp2UxbznOj+nZmtBKj1IfIAw0cYZkGWCREbzzBOHMb9Hj3JmPyMc4XfImoa3spck
         DYmb4GMBf4JV1MTl2r8qyJBUQipKsL3+/MbdSPc/pXaUOL1/FR/RpUGEqjB4DJeeUhZz
         O1URNwh/Vix+NYTnCff4WLKP6EgaVDVFX2riGS2OZSQFKOVSzGnpBIfBm7WhUD2HigU8
         ZTPwNFlX6z5Ug07VWJu4KIhfUtiu9JFgFVaFyfyh223HI5U3rBntfyKMNVxcCIN9LZoV
         tTtMl3MufLD8vP8moEJL15juwdZcbpZf+cGSCT0GhrT7RM8u+mjhDYBEbxpxbUwzi/xT
         ftcA==
X-Gm-Message-State: ANoB5pkuq6ThiR7NoGsqa66+dkpe5bpR6lVMBmHKKOtohdzwFZ0PRul/
        14vbykXu8o/ORbmEm+nocak=
X-Google-Smtp-Source: AA0mqf5Q6QAMMxYEvdQukjtnc8gYdBB8a113llRhzO8ReEJHJdsZ22y3U0Mo/SjGzaPFwEtv+r6Eaw==
X-Received: by 2002:a05:6000:10cf:b0:242:5ba8:d025 with SMTP id b15-20020a05600010cf00b002425ba8d025mr21862329wrx.39.1671207474276;
        Fri, 16 Dec 2022 08:17:54 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id bj19-20020a0560001e1300b002238ea5750csm3079720wrb.72.2022.12.16.08.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:17:53 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ronald Wahl <ronald.wahl@raritan.com>
Subject: [net PATCH 4/5] net: dsa: qca8k: introduce single mii read/write lo/hi
Date:   Fri, 16 Dec 2022 17:17:20 +0100
Message-Id: <20221216161721.23863-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221216161721.23863-1-ansuelsmth@gmail.com>
References: <20221216161721.23863-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may be useful to read/write just the lo or hi half of a reg.

This is especially useful for phy poll with the use of mdio master.
The mdio master reg is composed by the first 16 bit related to setup and
the other half with the returned data or data to write.

Refactor the mii function to permit single mii read/write of lo or hi
half of the reg.

Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 106 ++++++++++++++++++++++++-------
 1 file changed, 84 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index fbcd5c2b13ae..92c4bfef7c97 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -37,42 +37,104 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 }
 
 static int
-qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
+qca8k_mii_write_lo(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 {
 	int ret;
+	u16 lo;
 
-	ret = bus->read(bus, phy_id, regnum);
-	if (ret >= 0) {
-		*val = ret;
-		ret = bus->read(bus, phy_id, regnum + 1);
-		*val |= ret << 16;
-	}
+	lo = val & 0xffff;
+	ret = bus->write(bus, phy_id, regnum, lo);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit lo register\n");
 
-	if (ret < 0) {
+	return ret;
+}
+
+static int
+qca8k_mii_write_hi(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
+{
+	int ret;
+	u16 hi;
+
+	hi = (u16)(val >> 16);
+	ret = bus->write(bus, phy_id, regnum, hi);
+	if (ret < 0)
 		dev_err_ratelimited(&bus->dev,
-				    "failed to read qca8k 32bit register\n");
-		*val = 0;
-		return ret;
-	}
+				    "failed to write qca8k 32bit hi register\n");
+
+	return ret;
+}
+
+static int
+qca8k_mii_read_lo(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
+{
+	int ret;
+
+	ret = bus->read(bus, phy_id, regnum);
+	if (ret < 0)
+		goto err;
 
+	*val = ret & 0xffff;
 	return 0;
+
+err:
+	dev_err_ratelimited(&bus->dev,
+			    "failed to read qca8k 32bit lo register\n");
+	*val = 0;
+
+	return ret;
 }
 
-static void
-qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
+static int
+qca8k_mii_read_hi(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
-	u16 lo, hi;
 	int ret;
 
-	lo = val & 0xffff;
-	hi = (u16)(val >> 16);
+	ret = bus->read(bus, phy_id, regnum);
+	if (ret < 0)
+		goto err;
 
-	ret = bus->write(bus, phy_id, regnum, lo);
-	if (ret >= 0)
-		ret = bus->write(bus, phy_id, regnum + 1, hi);
+	*val = ret << 16;
+	return 0;
+
+err:
+	dev_err_ratelimited(&bus->dev,
+			    "failed to read qca8k 32bit hi register\n");
+	*val = 0;
+
+	return ret;
+}
+
+static int
+qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
+{
+	u32 hi, lo;
+	int ret;
+
+	*val = 0;
+
+	ret = qca8k_mii_read_lo(bus, phy_id, regnum, &lo);
 	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit register\n");
+		goto err;
+
+	ret = qca8k_mii_read_hi(bus, phy_id, regnum + 1, &hi);
+	if (ret < 0)
+		goto err;
+
+	*val = lo | hi;
+
+err:
+	return ret;
+}
+
+static void
+qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
+{
+	if (qca8k_mii_write_lo(bus, phy_id, regnum, val) < 0)
+		return;
+
+	qca8k_mii_write_hi(bus, phy_id, regnum + 1, val);
 }
 
 static int
-- 
2.37.2

