Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C604325EB8F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgIEWsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEWsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 18:48:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7EAC061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 15:48:53 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id k25so11915112ljg.9
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jv7wHZp0QThCjwMSw2235xeT/iK8nyUrVwycnCLbALc=;
        b=CGphtXCZ/J4OlTTRoFoEHVOu5uXKVYLoXIcKijwXGE2GjssldMNu7bxCIw3Rb7lbym
         0G1KPCwJYrgGgUPmD2w56mEiaoardRpbzHFOtx2VzIbCS9BuvS/R43V2oMHYykmBzCWz
         WVgc/NwRUaJzGJTjh2tzdEPKuK/QqykjLCabCk0k5Cq7iIvRsk/Zfo4ltXRH4WpC85cc
         k4AaWNnC4+2Vt4pXzu3elUGkXhY3BTwO/FMH4Ag5s3dqqLCV9L3i1VG8ufZxskMDKPGW
         6215d3AC1j3vkvrl9jP2IX+Oy6iJMBz2+BoHGgnFZSS/auJtE4Yv+PZOuU+YUFVO2yIB
         IgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jv7wHZp0QThCjwMSw2235xeT/iK8nyUrVwycnCLbALc=;
        b=kZlFabWEPDl5TGfRnBoSqDV805dwg9UW7qNLqyjBh537vldNwBzfasfH3Kin/mwKJE
         e7DSRPvPMI5v6l5dr2HdT9duipwRP4TGBhijpeWUvQXUbpbTxwOrKwLV/tmmgBnlohrT
         h+3VPlqOkagDFM+ZH1mHOqO2o28W5kT5a19H8w9o7sGS1xraHBBA6P1Lx++zAy9dB6ob
         VNCDJNgJqwsHAKvy4G2/dZDwcd7Sv49IuNu1xQacUeda1oUX95QeuR8/LysnxO9HXhYj
         OfcwskibYFwdN21ul0uYuXXJfBpvrRWrHhnBx5L3ojRsPKg7nTW7Wt3INwENj+PPigWF
         gcpQ==
X-Gm-Message-State: AOAM531xIeDB9YhveAcQIKKLF8tcnT3GyeoBKicNtBCZzKYAmGjIjA8t
        oVGXS+8RD4H1tOaYGrorCqSrTwnpVcd8GQ==
X-Google-Smtp-Source: ABdhPJzOVpYECClfVR/U1F4rzIioVT82q+3iNQGbCh2WvwwP2UW8RbYZ5qh1dJ78lSOzlxcXKoPHRA==
X-Received: by 2002:a2e:7014:: with SMTP id l20mr6683124ljc.162.1599346131502;
        Sat, 05 Sep 2020 15:48:51 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id u23sm1860414ljl.86.2020.09.05.15.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 15:48:50 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH] net: dsa: rtl8366rb: Switch to phylink
Date:   Sun,  6 Sep 2020 00:48:28 +0200
Message-Id: <20200905224828.90980-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches the RTL8366RB over to using phylink callbacks
instead of .adjust_link(). This is a pretty template
switchover. All we adjust is the CPU port so that is why
the code only inspects this port.

We enhance by adding proper error messages, also disabling
the CPU port on the way down and moving dev_info() to
dev_dbg().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366rb.c | 42 ++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index f763f93f600f..574e5e469966 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -969,8 +969,9 @@ static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_RTL4_A;
 }
 
-static void rtl8366rb_adjust_link(struct dsa_switch *ds, int port,
-				  struct phy_device *phydev)
+void rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+			   phy_interface_t interface, struct phy_device *phydev,
+			   int speed, int duplex, bool tx_pause, bool rx_pause)
 {
 	struct realtek_smi *smi = ds->priv;
 	int ret;
@@ -978,25 +979,51 @@ static void rtl8366rb_adjust_link(struct dsa_switch *ds, int port,
 	if (port != smi->cpu_port)
 		return;
 
-	dev_info(smi->dev, "adjust link on CPU port (%d)\n", port);
+	dev_dbg(smi->dev, "MAC link up on CPU port (%d)\n", port);
 
 	/* Force the fixed CPU port into 1Gbit mode, no autonegotiation */
 	ret = regmap_update_bits(smi->map, RTL8366RB_MAC_FORCE_CTRL_REG,
 				 BIT(port), BIT(port));
-	if (ret)
+	if (ret) {
+		dev_err(smi->dev, "failed to force 1Gbit on CPU port\n");
 		return;
+	}
 
 	ret = regmap_update_bits(smi->map, RTL8366RB_PAACR2,
 				 0xFF00U,
 				 RTL8366RB_PAACR_CPU_PORT << 8);
-	if (ret)
+	if (ret) {
+		dev_err(smi->dev, "failed to set PAACR on CPU port\n");
 		return;
+	}
 
 	/* Enable the CPU port */
 	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
 				 0);
-	if (ret)
+	if (ret) {
+		dev_err(smi->dev, "failed to enable the CPU port\n");
+		return;
+	}
+}
+
+void rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+			     phy_interface_t interface)
+{
+	struct realtek_smi *smi = ds->priv;
+	int ret;
+
+	if (port != smi->cpu_port)
+		return;
+
+	dev_dbg(smi->dev, "MAC link down on CPU port (%d)\n", port);
+
+	/* Disable the CPU port */
+	ret = regmap_update_bits(smi->map, RTL8366RB_PECR, BIT(port),
+				 BIT(port));
+	if (ret) {
+		dev_err(smi->dev, "failed to disable the CPU port\n");
 		return;
+	}
 }
 
 static void rb8366rb_set_port_led(struct realtek_smi *smi,
@@ -1439,7 +1466,8 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
 static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
-	.adjust_link = rtl8366rb_adjust_link,
+	.phylink_mac_link_up = rtl8366rb_mac_link_up,
+	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
-- 
2.26.2

