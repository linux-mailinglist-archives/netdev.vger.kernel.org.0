Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F56271039
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIST3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 15:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgIST3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 15:29:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B0BC0613CE;
        Sat, 19 Sep 2020 12:29:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so8826043wrn.13;
        Sat, 19 Sep 2020 12:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6bE1UCN2SxEtk5wLlW6eDkNj/1eK18tXtibVyotZ7CQ=;
        b=Qf5i6PqwPm10hX6K72w6i3Ahe+JswP51uGU2ZDhEeloC8zDHKKHbTwO6Oa5pTuCoMO
         lOPJGpLpgSFa59xdGiw42TqlQdRFGFaYuYbmloe5jp/f4rfBe+bIqnpOEpuwoWpRlurZ
         HWa5NXPcJ5w1Cyd+tGdMpZ1rT+SIjERTam/2P1MkRvXBPXPxhIwhDqGZdZhxmkduQCsV
         KMoSYloh1ZHbmWyO+3qbiVZiQbsIenoWoQ5zy67rXJyWijVkDZyeBUx5O6WZLQZ8usV9
         l/miRQdSM5uvCUx0AwDI5t6k2A6R4w531OvHKxQ8aSwVewKcKoAb93DIO/66PQyQLHjR
         15CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6bE1UCN2SxEtk5wLlW6eDkNj/1eK18tXtibVyotZ7CQ=;
        b=N+ZLiTX0JcB4SAQVpkE9+QK0TK/EmuMaOK9IZUQD2SErshSH+0MaiGuvV1y+T63ADK
         w5Gd/gHKKahBl4UCwjifIGAPzamaMO6bPnf7nXKCXoWQjIG8R/+3OFetZfKMnplgOFXP
         0QvGpbwZYU/57fCota/Qe5pxpZJXToU/EN0xm+urIarWdWQ68LZH/VBeh0wBmWn2aPn0
         G9G40e1AOBSDXoFCxK1jEDRw9yOn2vBafJWCH2ayuyuS5Il/VIKO+eh/PT/IXa7eSlkq
         xGXxjKlQoleDQYsC2Z75xiaL98NAYczJS7eJ8YjmbBzOEQI4uX+T84kFHBrH/3hzk0ZG
         m5ew==
X-Gm-Message-State: AOAM533sQ9i9PEY+pSltQOY5XCsFSX2/rAM5hyZn4PekzBk+Nli7SJsC
        dAqFxg/11z+0k3CdVDlQlJP3srv9fEs=
X-Google-Smtp-Source: ABdhPJxJ9woUCR9Om7Bguc63A/yyUADe7XauqnL2X/Pm4GtRnBNgoucoc9eAGjR2SMG2I8/nYhoOeQ==
X-Received: by 2002:adf:fc0a:: with SMTP id i10mr43825459wrr.111.1600543784422;
        Sat, 19 Sep 2020 12:29:44 -0700 (PDT)
Received: from localhost.localdomain (92.40.169.140.threembb.co.uk. [92.40.169.140])
        by smtp.gmail.com with ESMTPSA id h2sm12642069wrp.69.2020.09.19.12.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 12:29:43 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: dsa: mt7530: Add some return-value checks
Date:   Sat, 19 Sep 2020 20:28:10 +0100
Message-Id: <20200919192809.29120-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1600327978.11746.22.camel@mtksdccf07>
References: <1600327978.11746.22.camel@mtksdccf07>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mt7531_cpu_port_config(), if the variable port is neither 5 nor 6,
then variable interface will be used uninitialised. Change the function
to return -EINVAL in this case.

As the return value of mt7531_cpu_port_config() is never checked
(even though it returns an int) add a check in the correct place so that
the error can be passed up the call stack. Now that we correctly handle
errors thrown in this function, also check the return value of
mt7531_mac_config() in case an error occurs here. Also add misisng
checks to mt7530_setup() and mt7531_setup(), which are another level
further up the call stack.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Addresses-Coverity: 1496993 ("Uninitialized variables")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
v2:
	- fix typo in commit message
	- split variable declarations onto multiple lines (Gustavo)
	- add additional checks for mt753*_setup (Landen)

 drivers/net/dsa/mt7530.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 61388945d316..cb3efa7de7a8 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -945,10 +945,14 @@ static int
 mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret;
 
 	/* Setup max capability of CPU port at first */
-	if (priv->info->cpu_port_config)
-		priv->info->cpu_port_config(ds, port);
+	if (priv->info->cpu_port_config) {
+		ret = priv->info->cpu_port_config(ds, port);
+		if (ret)
+			return ret;
+	}
 
 	/* Enable Mediatek header mode on the cpu port */
 	mt7530_write(priv, MT7530_PVC_P(port),
@@ -1631,9 +1635,11 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
 			   PCR_MATRIX_CLR);
 
-		if (dsa_is_cpu_port(ds, i))
-			mt753x_cpu_port_enable(ds, i);
-		else
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = mt753x_cpu_port_enable(ds, i);
+			if (ret)
+				return ret;
+		} else
 			mt7530_port_disable(ds, i);
 
 		/* Enable consistent egress tag */
@@ -1785,9 +1791,11 @@ mt7531_setup(struct dsa_switch *ds)
 
 		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
 
-		if (dsa_is_cpu_port(ds, i))
-			mt753x_cpu_port_enable(ds, i);
-		else
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = mt753x_cpu_port_enable(ds, i);
+			if (ret)
+				return ret;
+		} else
 			mt7530_port_disable(ds, i);
 
 		/* Enable consistent egress tag */
@@ -2276,6 +2284,7 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	struct mt7530_priv *priv = ds->priv;
 	phy_interface_t interface;
 	int speed;
+	int ret;
 
 	switch (port) {
 	case 5:
@@ -2293,6 +2302,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 
 		priv->p6_interface = interface;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
@@ -2300,7 +2311,9 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	else
 		speed = SPEED_1000;
 
-	mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+	ret = mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+	if (ret)
+		return ret;
 	mt7530_write(priv, MT7530_PMCR_P(port),
 		     PMCR_CPU_PORT_SETTING(priv->id));
 	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED, interface, NULL,
-- 
2.28.0

