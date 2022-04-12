Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8714FE725
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358292AbiDLRf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358183AbiDLRfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:35:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4177A57B0F
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i27so38741809ejd.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sITlTL+kuRHKI1MXNipizR8/OsadxizPlkHPEYeP2BQ=;
        b=UDFDMaVQ3pZZ2Yyybqej3tMqSIDkzgrk/NVYkS5iuStXL6Pjaki2cSs0g26TwocwAa
         lL+g3XKSnAW3WvQs/KwSw8h7CP1gE7TfuaHbtiOKp2llO8AREI/M9xH1E7Bb//nV49yp
         2rxkwuFvsSDzPPse2LrB8HTnNxMxgd9O/UOnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sITlTL+kuRHKI1MXNipizR8/OsadxizPlkHPEYeP2BQ=;
        b=HfpmZ85sZ5lvDWI/eKXyl4ib9MVgYg7M5eTm0/txiV1M1uKXdBJrNAHc8k9VqtHE/3
         1qFFy+elIXiese5ObUqI03CgZ4kvxI/x7BSEd3JNyccvmI0pabSUR4NRkPaJfnfevU0W
         XTn6z0n2nuw3aMEkS8nMQ2TMo1cGiRyiaSMx0TkCqei91bbwoOJGT5LI5KDZCfY3BMRs
         TDvuJzrq3SNM0hNZnUGPKxLr4Eut8jdyTHqJFGilKcq4maM3HLeG/C6ugi8ArXey4qLI
         gSfIyNnhaOn0aT8ZQrSepQXBkJy/ZBoNscCWgP/ssq8l5ee6b+crjFukiLQno57XUt7x
         ugLw==
X-Gm-Message-State: AOAM530ZKQ0JiGEYXUWeQThHW/p4bznWAp/TpJOU1dO6iPWQfVnXQ4xL
        X6L1xclCvJ6GQgKVVFY7bOYGnQ==
X-Google-Smtp-Source: ABdhPJwFPI/ox/lPs49z9zHMgMlcR3UeYkq5NDbVc8Jdy2KbVrRJWtJ6zTVnhpWzp9nVBBwJdMEokQ==
X-Received: by 2002:a17:907:1c19:b0:6e8:322f:cdd7 with SMTP id nc25-20020a1709071c1900b006e8322fcdd7mr25355296ejc.493.1649784797756;
        Tue, 12 Apr 2022 10:33:17 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7dd43000000b00419db53ae65sm56142edw.7.2022.04.12.10.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:33:17 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH stable 5.16+ 2/3] net: dsa: realtek: rtl8365mb: serialize indirect PHY register access
Date:   Tue, 12 Apr 2022 19:32:51 +0200
Message-Id: <20220412173253.2247196-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412173253.2247196-1-alvin@pqrs.dk>
References: <20220412173253.2247196-1-alvin@pqrs.dk>
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

[ Upstream commit 2796728460b822d549841e0341752b263dc265c4 ]

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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[alsi: backport to 5.16: s/priv/smi/g]
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 54 ++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 48c0e3e46600..3b2d5058b434 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -565,7 +565,7 @@ static int rtl8365mb_phy_poll_busy(struct realtek_smi *smi)
 {
 	u32 val;
 
-	return regmap_read_poll_timeout(smi->map,
+	return regmap_read_poll_timeout(smi->map_nolock,
 					RTL8365MB_INDIRECT_ACCESS_STATUS_REG,
 					val, !val, 10, 100);
 }
@@ -579,7 +579,7 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_smi *smi, int phy,
 	/* Set OCP prefix */
 	val = FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK, ocp_addr);
 	ret = regmap_update_bits(
-		smi->map, RTL8365MB_GPHY_OCP_MSB_0_REG,
+		smi->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
 		RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
 		FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK, val));
 	if (ret)
@@ -592,8 +592,8 @@ static int rtl8365mb_phy_ocp_prepare(struct realtek_smi *smi, int phy,
 			  ocp_addr >> 1);
 	val |= FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_OCPADR_9_6_MASK,
 			  ocp_addr >> 6);
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG,
-			   val);
+	ret = regmap_write(smi->map_nolock,
+			   RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG, val);
 	if (ret)
 		return ret;
 
@@ -606,36 +606,42 @@ static int rtl8365mb_phy_ocp_read(struct realtek_smi *smi, int phy,
 	u32 val;
 	int ret;
 
+	mutex_lock(&smi->map_lock);
+
 	ret = rtl8365mb_phy_poll_busy(smi);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_ocp_prepare(smi, phy, ocp_addr);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Execute read operation */
 	val = FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_READ);
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(smi->map_nolock, RTL8365MB_INDIRECT_ACCESS_CTRL_REG,
+			   val);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_poll_busy(smi);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Get PHY register data */
-	ret = regmap_read(smi->map, RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG,
-			  &val);
+	ret = regmap_read(smi->map_nolock,
+			  RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG, &val);
 	if (ret)
-		return ret;
+		goto out;
 
 	*data = val & 0xFFFF;
 
-	return 0;
+out:
+	mutex_unlock(&smi->map_lock);
+
+	return ret;
 }
 
 static int rtl8365mb_phy_ocp_write(struct realtek_smi *smi, int phy,
@@ -644,32 +650,38 @@ static int rtl8365mb_phy_ocp_write(struct realtek_smi *smi, int phy,
 	u32 val;
 	int ret;
 
+	mutex_lock(&smi->map_lock);
+
 	ret = rtl8365mb_phy_poll_busy(smi);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_ocp_prepare(smi, phy, ocp_addr);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Set PHY register data */
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG,
-			   data);
+	ret = regmap_write(smi->map_nolock,
+			   RTL8365MB_INDIRECT_ACCESS_WRITE_DATA_REG, data);
 	if (ret)
-		return ret;
+		goto out;
 
 	/* Execute write operation */
 	val = FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_CMD_VALUE) |
 	      FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_CTRL_RW_MASK,
 			 RTL8365MB_INDIRECT_ACCESS_CTRL_RW_WRITE);
-	ret = regmap_write(smi->map, RTL8365MB_INDIRECT_ACCESS_CTRL_REG, val);
+	ret = regmap_write(smi->map_nolock, RTL8365MB_INDIRECT_ACCESS_CTRL_REG,
+			   val);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtl8365mb_phy_poll_busy(smi);
 	if (ret)
-		return ret;
+		goto out;
+
+out:
+	mutex_unlock(&smi->map_lock);
 
 	return 0;
 }
-- 
2.35.1

