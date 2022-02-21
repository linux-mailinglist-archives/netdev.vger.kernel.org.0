Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFF44BEA70
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiBUSri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:47:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiBUSr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:47:27 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3ACD90
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:46:40 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c192so10045985wma.4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 10:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AH3hQsUn1T/lXJhfiUYvUkUtkgFsibZK+A7UVJghwao=;
        b=WSZtf6kJssqO9GwX4qK8Qh9JEX+JYvAJ1+FTtvGEHvst/HhAgRyxq0kFXR72gUYGQD
         QEM9b4H7gq9fQfGB0rI6+nxkPcCmNj0lQjEWUZexPtM495o061WHgZOTztW1STWxr+e+
         Oq5VC4yZyD1KUfgsSSPrqRg+DqmVcmmtlpeYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AH3hQsUn1T/lXJhfiUYvUkUtkgFsibZK+A7UVJghwao=;
        b=O6H82o9sOnZucIpjmRBBakdug7Nk8e0wIlBArmR6zXZDoCq0ZHdTjNUE5t3cH/QvAR
         IrRpj9r/YL6Sal8SLJcThnLH5KDk/hhOHWFdi8Jq3ASeB1onhM0bddBXYlQz9ymJ6KZh
         WFvZUtp9hol+GgmJWj7WP8rEMdC+Qm2jxP+pswbFmLpu9AnVRDWJoecdBIQ61pNtboGg
         VeGJgVXJlaY/u5BIE7SLwxOTHD/JeaqJp1rN6pLFBpKjnHlSJcBACopatqxZkbV+QINe
         hKpO5MAla1CGy59egjhaAlzbCyWTtYK7WTwtKoxW7YsawqHWPOJiamLG2+8Plj55yB5r
         g06w==
X-Gm-Message-State: AOAM533e/ZmsvMIte2uwYdlX/LlKRB3IL939t958bxJolD26s4RV/Zri
        pDWpvaBTqKN2MyqSuX83L5zX5Q==
X-Google-Smtp-Source: ABdhPJzFJr/RI04JbZq+olBER4VkRgR4tdOFEEUnWO+9bdHCA5I7LVjDiUpLU1PcjQWhImbEEQcWfA==
X-Received: by 2002:a05:600c:3d98:b0:352:cdcf:ef7f with SMTP id bi24-20020a05600c3d9800b00352cdcfef7fmr301271wmb.28.1645469198812;
        Mon, 21 Feb 2022 10:46:38 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id 11-20020a05600c26cb00b0037ff53511f2sm140637wmv.31.2022.02.21.10.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 10:46:38 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: dsa: realtek: rtl8365mb: serialize indirect PHY register access
Date:   Mon, 21 Feb 2022 19:46:31 +0100
Message-Id: <20220221184631.252308-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221184631.252308-1-alvin@pqrs.dk>
References: <20220221184631.252308-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Realtek switches in the rtl8365mb family can access the PHY registers of
the internal PHYs via the switch registers. This method is called
indirect access. At a high level, the indirect PHY register access
method involves reading and writing some special switch registers in a
particular sequence. This works for both SMI and MDIO connected
switches.

Currently the rtl8365mb driver does not take any care to serialize the
aforementioned access to the switch registers. In particular, it is
permitted for other driver code to access other switch registers while
the indirect PHY register access is ongoing. Locking is only done at the
regmap level. This, however, is a bug: concurrent register access, even
to unrelated switch registers, risks corrupting the PHY register value
read back via the indirect access method described above.

Arınç reported that the switch sometimes returns nonsense data when
reading the PHY registers. In particular, a value of 0 causes the
kernel's PHY subsystem to think that the link is down, but since most
reads return correct data, the link then flip-flops between up and down
over a period of time.

The aforementioned bug can be readily observed by:

 1. Enabling ftrace events for regmap and mdio
 2. Polling BSMR PHY register for a connected port;
    it should always read the same (e.g. 0x79ed)
 3. Wait for step 2 to give a different value

Example command for step 2:

    while true; do phytool read swp2/2/0x01; done

On my i.MX8MM, the above steps will yield a bogus value for the BSMR PHY
register within a matter of seconds. The interleaved register access it
then evident in the trace log:

 kworker/3:4-70      [003] .......  1927.139849: regmap_reg_write: ethernet-switch reg=1004 val=bd
     phytool-16816   [002] .......  1927.139979: regmap_reg_read: ethernet-switch reg=1f01 val=0
 kworker/3:4-70      [003] .......  1927.140381: regmap_reg_read: ethernet-switch reg=1005 val=0
     phytool-16816   [002] .......  1927.140468: regmap_reg_read: ethernet-switch reg=1d15 val=a69
 kworker/3:4-70      [003] .......  1927.140864: regmap_reg_read: ethernet-switch reg=1003 val=0
     phytool-16816   [002] .......  1927.140955: regmap_reg_write: ethernet-switch reg=1f02 val=2041
 kworker/3:4-70      [003] .......  1927.141390: regmap_reg_read: ethernet-switch reg=1002 val=0
     phytool-16816   [002] .......  1927.141479: regmap_reg_write: ethernet-switch reg=1f00 val=1
 kworker/3:4-70      [003] .......  1927.142311: regmap_reg_write: ethernet-switch reg=1004 val=be
     phytool-16816   [002] .......  1927.142410: regmap_reg_read: ethernet-switch reg=1f01 val=0
 kworker/3:4-70      [003] .......  1927.142534: regmap_reg_read: ethernet-switch reg=1005 val=0
     phytool-16816   [002] .......  1927.142618: regmap_reg_read: ethernet-switch reg=1f04 val=0
     phytool-16816   [002] .......  1927.142641: mdio_access: SMI-0 read  phy:0x02 reg:0x01 val:0x0000 <- ?!
 kworker/3:4-70      [003] .......  1927.143037: regmap_reg_read: ethernet-switch reg=1001 val=0
 kworker/3:4-70      [003] .......  1927.143133: regmap_reg_read: ethernet-switch reg=1000 val=2d89
 kworker/3:4-70      [003] .......  1927.143213: regmap_reg_write: ethernet-switch reg=1004 val=be
 kworker/3:4-70      [003] .......  1927.143291: regmap_reg_read: ethernet-switch reg=1005 val=0
 kworker/3:4-70      [003] .......  1927.143368: regmap_reg_read: ethernet-switch reg=1003 val=0
 kworker/3:4-70      [003] .......  1927.143443: regmap_reg_read: ethernet-switch reg=1002 val=6

The kworker here is polling MIB counters for stats, as evidenced by the
register 0x1004 that we are writing to (RTL8365MB_MIB_ADDRESS_REG). This
polling is performed every 3 seconds, but is just one example of such
unsynchronized access. In Arınç's case, the driver was not using the
switch IRQ, so the PHY subsystem was itself doing polling analogous to
phytool in the above example.

A test module was created [see second Link] to simulate such spurious
switch register accesses while performing indirect PHY register reads
and writes. Realtek was also consulted to confirm whether this is a
known issue or not. The conclusion of these lines of inquiry is as
follows:

1. Reading of PHY registers via indirect access will be aborted if,
   after executing the read operation (via a write to the
   INDIRECT_ACCESS_CTRL_REG), any register is accessed, other than
   INDIRECT_ACCESS_STATUS_REG.

2. The PHY register indirect read is only complete when
   INDIRECT_ACCESS_STATUS_REG reads zero.

3. The INDIRECT_ACCESS_DATA_REG, which is read to get the result of the
   PHY read, will contain the result of the last successful read
   operation. If there was spurious register access and the indirect
   read was aborted, then this register is not guaranteed to hold
   anything meaningful and the PHY read will silently fail.

4. PHY writes do not appear to be affected by this mechanism.

5. Other similar access routines, such as for MIB counters, although
   similar to the PHY indirect access method, are actually table access.
   Table access is not affected by spurious reads or writes of other
   registers. However, concurrent table access is not allowed. Currently
   this is protected via mib_lock, so there is nothing to fix.

The above statements are corroborated both via the test module and
through consultation with Realtek. In particular, Realtek states that
this is simply a property of the hardware design and is not a hardware
bug.

To fix this problem, one must guard against regmap access while the
PHY indirect register read is executing. Fix this by using the newly
introduced "nolock" regmap in all PHY-related functions, and by aquiring
the regmap mutex at the top level of the PHY register access callbacks.
Although no issue has been observed with PHY register _writes_, this
change also serializes the indirect access method there. This is done
purely as a matter of convenience and for reasons of symmetry.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Link: https://lore.kernel.org/netdev/CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com/
Link: https://lore.kernel.org/netdev/871qzwjmtv.fsf@bang-olufsen.dk/
Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 54 ++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 2ed592147c20..c39d6b744597 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -590,7 +590,7 @@ static int rtl8365mb_phy_poll_busy(struct realtek_priv *priv)
 {
 	u32 val;
 
-	return regmap_read_poll_timeout(priv->map,
+	return regmap_read_poll_timeout(priv->map_nolock,
 					RTL8365MB_INDIRECT_ACCESS_STATUS_REG,
 					val, !val, 10, 100);
 }
@@ -604,7 +604,7 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
 	/* Set OCP prefix */
 	val = FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK, ocp_addr);
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_GPHY_OCP_MSB_0_REG,
+		priv->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
 		RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
 		FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK, val));
 	if (ret)
@@ -617,8 +617,8 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_priv *priv, int phy,
 			  ocp_addr >> 1);
 	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
 			  ocp_addr >> 6);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
-			   val);
+	ret = regmap_write(priv->map_nolock,
+			   RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG, val);
 	if (ret)
 		return ret;
 
@@ -631,36 +631,42 @@ static int rtl8365mb_phy_ocp_read(struct realtek_priv *priv, int phy,
 	u32 val;
 	int ret;
 
+	mutex_lock(&priv->map_lock);
+
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Execute read operation */
 	val = FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_READ);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(priv->map_nolock, RTL8365MB_INDIRECT_ACCESS_CTRL_REG,
+			   val);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Get PHY register data */
-	ret = regmap_read(priv->map, RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG,
-			  &val);
+	ret = regmap_read(priv->map_nolock,
+			  RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG, &val);
 	if (ret)
-		return ret;
+		goto out;
 
 	*data = val & 0xFFFF;
 
-	return 0;
+out:
+	mutex_unlock(&priv->map_lock);
+
+	return ret;
 }
 
 static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
@@ -669,32 +675,38 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 	u32 val;
 	int ret;
 
+	mutex_lock(&priv->map_lock);
+
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_ocp_prepare(priv, phy, ocp_addr);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Set PHY register data */
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG,
-			   data);
+	ret = regmap_write(priv->map_nolock,
+			   RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG, data);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Execute write operation */
 	val = FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_WRITE);
-	ret = regmap_write(priv->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(priv->map_nolock, RTL8365MB_INDIRECT_ACCESS_CTRL_REG,
+			   val);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_poll_busy(priv);
 	if (ret)
-		return ret;
+		goto out;
+
+out:
+	mutex_unlock(&priv->map_lock);
 
 	return 0;
 }
-- 
2.35.1

