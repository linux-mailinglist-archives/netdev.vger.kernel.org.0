Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3019658F31
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbiL2QoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiL2Qn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:43:56 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FECB1E6;
        Thu, 29 Dec 2022 08:43:55 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id w1so5734840wrt.8;
        Thu, 29 Dec 2022 08:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=af46cSNJUKc3RBIgzI62ckIW3TcyyLgIBROBWBavM6Q=;
        b=VRaedYBi5jhxLC0TVNx9mlc4EsF3lGJ/8tt4aH8x4GKWJW88Uf7bytC7loWMWCxkOe
         G1ZM7ayuQKHaXCUgIXeHl6h1VHHytxlkBnRvk6fKt44tiM7UrySiUrI14N4j4WaKQ113
         ikOlmXzjRLafDrnfZKSExy/GDczrqJvdoyjJQmF7qS0w85MqcowYdlEA0UM/iK1tbaNA
         zXBVzbOy7ydMfHkxBWmwxjD8CaQTOR5WutZXwvYuNyAjs+whY9qAzwZ5DkLh/Q4+uP/l
         gBxRrqHcOku0dqOsPxLwPjvEyiF2T9jM4wC13C7AHr1fn3nWDfvCnSw5djXp/TdVTDQN
         wEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=af46cSNJUKc3RBIgzI62ckIW3TcyyLgIBROBWBavM6Q=;
        b=vQbbavrZ3wtBUHdSQqM2qQtrylAvC5QV1l0QrghieYVXTHCTuNRdeN2/zS+U/vgAa1
         tSULAllgBBJpFC2j8FAivFd0f1YTUBSL0cZhYeKhsweJt/KlHVjxQO65imLws6Ns33xn
         M2YwQXJKi4S8ZwNah0NgEKpAK4XdoRcXLy+PMlsU4ZoxqDAKjJ2Bm9bx+CrhMG82TfNH
         xY1DkXSxFmSAPs+aeyYKWinwQWdUZO/pDtbvleQLu4SOJ1iu3OAEwELYYoMLmRWFXQII
         q7ERpyuzeRvRgoVkMI2r56YZDZQ2v0ql14o43VfM5qUwkFI4WdNFsEEbcj9MuTQ1I19G
         JYEA==
X-Gm-Message-State: AFqh2kog8LXpvKwrHS0MW0xB188KWRqv+Ojxoe2iUG8eO5m037rAI/70
        tDjbqAGNxlVsGZBsBAvVGpk=
X-Google-Smtp-Source: AMrXdXsRf7N7NG1qY3ijFI7hlkIljIJob7+XrCpsnLvG/oJPKqzyFicTOMaiKY6IImktGKWEXuFIyw==
X-Received: by 2002:adf:ed4e:0:b0:242:2722:f08 with SMTP id u14-20020adfed4e000000b0024227220f08mr16959467wro.12.1672332233801;
        Thu, 29 Dec 2022 08:43:53 -0800 (PST)
Received: from localhost.localdomain (host-82-55-238-56.retail.telecomitalia.it. [82.55.238.56])
        by smtp.googlemail.com with ESMTPSA id t18-20020a5d42d2000000b00288a3fd9248sm4326586wrr.91.2022.12.29.08.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 08:43:53 -0800 (PST)
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
Subject: [net PATCH v2 4/5] net: dsa: qca8k: introduce single mii read/write lo/hi
Date:   Thu, 29 Dec 2022 17:33:35 +0100
Message-Id: <20221229163336.2487-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221229163336.2487-1-ansuelsmth@gmail.com>
References: <20221229163336.2487-1-ansuelsmth@gmail.com>
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

