Return-Path: <netdev+bounces-7510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0BD7720811
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5204928194A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65619332FE;
	Fri,  2 Jun 2023 17:02:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5157A332EE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:02:35 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4326D1A2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:02:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9707313e32eso349663466b.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685725352; x=1688317352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y4tc9+ToBZ7DB46rYcbz7Px2nRIdmT2YMmYU+bB1Gyk=;
        b=n2RV7tQmbalaEm2G4XjiNpvDhUZF+FAdHrqRGZUeAccd0C0h80YuVgOwT+LZwU7+TU
         LpypMAFW53uaLygGNsf9tiqsV56HkR0sf/t2Y2irBiBybHGo3byokROFvjBkCBsfYvFK
         35MIXBRdsThEkF6CKBlDIbaijINa1th+XDUS8Snx3p2ZughZUI/y3K66AJkMF3zEYm23
         bJcjBgubWzSNwJm48yDY1omAJZ+WIZrujOBqBM/0ifALsu7YhCdpdkMYXhA+IF4N7D4y
         GK5uUclKl9dl/EheY1TGOjG/PRSoqifljAXMTk3i9Zl5nodvEdOSjtQr7bVBgWTnsPAc
         zjaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725352; x=1688317352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y4tc9+ToBZ7DB46rYcbz7Px2nRIdmT2YMmYU+bB1Gyk=;
        b=IVGV5l9ItXjpje40bMRJROQe1QGzJ2akLoB+YqHsOC5bot0wgQ+2aO5YPr2A/j5RAm
         6n9ZGRKxIuRKYE3Vd2aeEEwcZsTNpWrtKnSzq7M/AQK9KqgjasLPcmJlIInd1V6MhEh2
         P6aLCmGJRlWtps1w6Knnh0RUuMb//Tdz9BobEG6JjAPPtTEYWImbeKtKHBcpPgaD9WK8
         2lx+N9TERG3PiE5WjNg4gHD7f44N+ATk7NEZbomZVcbF58tXZcIGhXpLCIAMeoEreB5H
         136JhA0XsxceTsvvWvMkeg17wThbxHs4fNMv0wd+MxU9rtDx1ni74DogBevKCCyXyfYW
         DTHw==
X-Gm-Message-State: AC+VfDzlFPA1mDJNQy0EMpN75Mgbrx/TAUqav7CVGfb2EvzTVeAMrEmt
	wYzkrI3WpUiK79ljHlol+6lIwKQ7SHU=
X-Google-Smtp-Source: ACHHUZ7gKoJiMZN4ymjYnS8LU0+++0nqa684iEHzL1cng6FpaDgTRP3DSJGXKYjnXmY3N9oNdgBGTQ==
X-Received: by 2002:a17:907:268e:b0:973:93d6:18aa with SMTP id bn14-20020a170907268e00b0097393d618aamr11332632ejc.62.1685725352538;
        Fri, 02 Jun 2023 10:02:32 -0700 (PDT)
Received: from shift.daheim (p5b0d7936.dip0.t-ipconnect.de. [91.13.121.54])
        by smtp.gmail.com with ESMTPSA id la24-20020a170906ad9800b009745482c5b7sm957868ejb.94.2023.06.02.10.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 10:02:32 -0700 (PDT)
Received: from chuck by shift.daheim with local (Exim 4.96)
	(envelope-from <chuck@shift.daheim>)
	id 1q58AZ-001MI6-1n;
	Fri, 02 Jun 2023 19:02:31 +0200
From: Christian Lamparter <chunkeey@gmail.com>
To: netdev@vger.kernel.org
Cc: alsi@bang-olufsen.dk,
	luizluca@gmail.com,
	linus.walleij@linaro.org,
	andrew@lunn.ch,
	olteanv@gmail.com,
	f.fainelli@gmail.com
Subject: [PATCH v1] net: dsa: realtek: rtl8365mb: use mdio passthrough to access PHYs
Date: Fri,  2 Jun 2023 19:02:31 +0200
Message-Id: <0df383e20e5a90494e3cbd0cf23c508c5c943ab4.1685725191.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

when bringing up the PHYs on a Netgear WNDAP660, I observed that
none of the PHYs are getting enumerated and the rtl8365mb fails
to load.

| realtek-mdio [...] lan1 (unini...): validation of gmii with support \
|   0...,0.,..6280 and advertisement 0...,0...,6280 failed: -EINVAL
| realtek-mdio [...] lan1 (uninit...): failed to connect to PHY: -EINVAL
| realtek-mdio [...] lan1 (uninit...): error -22 setting up PHY for
|   tree 0, switch 0, port 0

with phytool, all registers just returned "0000".

Now, the same behavior was present with the swconfig version of
rtl8637b.c and in the device's uboot the "mii" register access
utility also reports bogus values.

The Netgear WNDAP660 might be somewhat special, since the RTL8363SB
uses exclusive MDC/MDIO-access (instead of SMI). (And the RTL8363SB
is not part of the supported list of this driver).

Since this was all hopeless, I dug up some datasheet when searching
for solutions:
"10/100M & 10/100/1000M Switch Controller Programming Guide".
It had an interesting passage that pointed to a magical
MDC_MDIO_OPERATION define which resulted in different slave PHY
access for the MDIO than it was implemented for SMI.

With this implemented, the RTL8363SB PHYs came to live:

| [...]: found an RTL8363SB-CG switch
| [...]: missing child interrupt-controller node
| [...]: no interrupt support
| [...]: configuring for fixed/rgmii link mode
| [...] lan1 (uninit...): PHY [dsa-0.0:01] driver [Generic PHY] (irq=POLL)
| [...] lan2 (uninit...): PHY [dsa-0.0:02] driver [Generic PHY] (irq=POLL)
| device eth0 entered promiscuous mode
| DSA: tree 0 setup
| realtek-mdio 4ef600c00.ethernet:00: Link is Up - 1Gbps/Full - [...]

| # phytool lan1/2
| ieee-phy: id:0x001cc980 <--- this is correct!!
|
|  ieee-phy: reg:BMCR(0x00) val:0x1140
|     flags:          -reset -loopback +aneg-enable -power-down
|		      -isolate -aneg-restart -collision-test
|     speed:          1000-full
|
|  ieee-phy: reg:BMSR(0x01) val:0x7969
|     capabilities:   -100-b4 +100-f +100-h +10-f +10-h -100-t2-f
|		      -100-t2-h
|      flags:         +ext-status +aneg-complete -remote-fault
|		      +aneg-capable -link -jabber +ext-register

the port statistics are working too and the exported LED triggers.
But so far I can't get any traffic to pass.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
Any good hints or comments? Is the RTL8363SB an odd one here and
everybody else can just use SMI?

So far, I'm just reusing the existing jam tables. rtl8367b.c jam
tables ones don't help with getting "traffic". There are also the
phy_read in realtek_ops, but it doesn't look like realtek-mdio.c
is using those? So I left them as is.
---
 drivers/net/dsa/realtek/rtl8365mb.c | 78 +++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 41ea3b5a42b1..6c00e6dcb193 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -825,15 +825,85 @@ static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regnum,
 	return 0;
 }
 
+static int rtl8365mb_mdio_phy_read(struct realtek_priv *priv, int phy, int regnum)
+{
+	unsigned int val, addr;
+	int ret;
+
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
+
+	if (regnum > RTL8365MB_PHYREGMAX)
+		return -EINVAL;
+
+	mutex_lock(&priv->map_lock);
+	ret = regmap_update_bits(priv->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
+				 RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK, /* 0xA40 */
+				 FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
+					    FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK,
+						      RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE)));
+	if (ret) {
+		mutex_unlock(&priv->map_lock);
+		return ret;
+	}
+
+	addr = RTL8365MB_PHY_BASE |
+	       FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK, phy) |
+	       regnum;
+	ret = regmap_read(priv->map_nolock, addr, &val);
+	mutex_unlock(&priv->map_lock);
+	if (ret)
+		return ret;
+
+	dev_dbg(priv->dev, "read PHY%d register 0x%02x, val <- %04x\n",
+		phy, regnum, val);
+
+	return val & 0xFFFF;
+}
+
+static int rtl8365mb_mdio_phy_write(struct realtek_priv *priv, int phy, int regnum,
+				    u16 val)
+{
+	unsigned int addr;
+	int ret;
+
+	if (phy > RTL8365MB_PHYADDRMAX)
+		return -EINVAL;
+
+	if (regnum > RTL8365MB_PHYREGMAX)
+		return -EINVAL;
+
+	mutex_lock(&priv->map_lock);
+	ret = regmap_update_bits(priv->map_nolock, RTL8365MB_GPHY_OCP_MSB_0_REG,
+				 RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
+				 FIELD_PREP(RTL8365MB_GPHY_OCP_MSB_0_CFG_CPU_OCPADR_MASK,
+					    FIELD_GET(RTL8365MB_PHY_OCP_ADDR_PREFIX_MASK,
+						      RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE)));
+	if (ret) {
+		mutex_unlock(&priv->map_lock);
+		return ret;
+	}
+
+	addr = RTL8365MB_PHY_BASE |
+	       FIELD_PREP(RTL8365MB_INDIRECT_ACCESS_ADDRESS_PHYNUM_MASK, phy) |
+	       regnum;
+	ret = regmap_write(priv->map_nolock, addr, val);
+	mutex_unlock(&priv->map_lock);
+
+	dev_dbg(priv->dev, "write (%d) PHY%d register 0x%02x val -> %04x\n",
+		ret, phy, regnum, val);
+
+	return ret;
+}
+
 static int rtl8365mb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnum)
 {
-	return rtl8365mb_phy_read(ds->priv, phy, regnum);
+	return rtl8365mb_mdio_phy_read(ds->priv, phy, regnum);
 }
 
-static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum,
-				   u16 val)
+static int rtl8365mb_dsa_phy_write(struct dsa_switch *ds, int phy, int regnum, u16 val)
 {
-	return rtl8365mb_phy_write(ds->priv, phy, regnum, val);
+	return rtl8365mb_mdio_phy_write(ds->priv, phy, regnum, val);
 }
 
 static const struct rtl8365mb_extint *
-- 
2.40.1


