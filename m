Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68297396A52
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhFAAfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhFAAfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:21 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA300C061756
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:39 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id df21so15215243edb.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ThyrI+ZCw3zKL0ZSLQt0NDkolebHrftsaYGgXIN2lf8=;
        b=n+NK8yeCboE//Gup5AjZndynRJJyyIGI1Grum55vGakg9+YnXaE9GgqSUQuDbb2Mst
         KQhq/vvtRn5mBckyuMJYvVMy36Ce0WwSjwcpHkapd0N3TAC9CU74bbGnVQhEo0bnRpJr
         qihtukkXZjDI/Pph2Lg74JKz7eq2RlcvALpTwTulmTLyGot88n6VA2b4ggCzATeatOxt
         WMoiAhi/eyf+mugqJDnjYPNUJH43LFFAMj1owokemtrUlI7zf9kFc/mL/5mfPLcqGGXx
         5fC2l/lq6y88xh086dO4k00/DyuRAUJ7YaGcYEojtyIAgsL+t/paLwWxZ2b48Nbq4MJk
         e79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ThyrI+ZCw3zKL0ZSLQt0NDkolebHrftsaYGgXIN2lf8=;
        b=dwp8XuzDumAdsX9m8le/+W22jvZvuNu2EjubWRGpobjFrqoHm/z80eoVaZpoxyTnDW
         CEUW2eBcD6bgM9pKrruQeI2lwh5WJFqrqCnrZdi1YzUHuSRoibrmD/vzqySUS4frV6Ba
         BTBvLO/H8ZFbu7YdzLKzyDH5drgiBY9BwM3Sqw/2Zds6169BhuH61vtPSmMMXDt0oeYe
         kLMVpyzBYoOFsRNnsUVhCynQGtOLowv4ZnDLinZNyxcS8HPEL6nC2maPqnn2yp9mRgF0
         TK9HRJEIYLfxG55WcwpAryPzmWfRCZoafLLNCJqHQplJ3wAaeJOP6vjxTzzjbwQbwzod
         xW8A==
X-Gm-Message-State: AOAM531wEFaYGvpil3G/Cykp4HzBon99il5gcvDY8bjX9KMUUiHoD1yY
        +ebyeZbNaNAnWG3Ce2/8j0g=
X-Google-Smtp-Source: ABdhPJwExV8i4NGoIGo5KMZgnVlMpoVQugfhzrSjUfupC4wYo2Txhw0CLh7/tbl9B1Py34FrRpCepw==
X-Received: by 2002:aa7:c7cc:: with SMTP id o12mr28630632eds.291.1622507618509;
        Mon, 31 May 2021 17:33:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 6/9] net: pcs: xpcs: export xpcs_probe
Date:   Tue,  1 Jun 2021 03:33:22 +0300
Message-Id: <20210601003325.1631980-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Similar to the other recently functions, it is not necessary for
xpcs_probe to be a function pointer, so export it so that it can be
called directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h        | 2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 +-
 drivers/net/pcs/pcs-xpcs.c                        | 4 ++--
 include/linux/pcs/pcs-xpcs.h                      | 2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 2d2843edaf21..5014b260844b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -619,8 +619,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_callback(__priv, xpcs, get_state, __args)
 #define stmmac_xpcs_link_up(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, link_up, __args)
-#define stmmac_xpcs_probe(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, probe, __args)
 
 struct stmmac_regs_off {
 	u32 ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index e293bf1ce9f3..56deb92a8430 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -521,7 +521,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 		for (addr = 0; addr < max_addr; addr++) {
 			xpcs->addr = addr;
 
-			ret = stmmac_xpcs_probe(priv, xpcs, mode);
+			ret = xpcs_probe(xpcs, mode);
 			if (!ret) {
 				found = 1;
 				break;
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 7cd057f43200..964433849ef8 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1005,7 +1005,7 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
-static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
+int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 {
 	u32 xpcs_id = xpcs_get_id(xpcs);
 	int i;
@@ -1028,12 +1028,12 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(xpcs_probe);
 
 static struct mdio_xpcs_ops xpcs_ops = {
 	.config = xpcs_config,
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
-	.probe = xpcs_probe,
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index ae74a336dcb9..1d8581b74d81 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -29,7 +29,6 @@ struct mdio_xpcs_ops {
 			 struct phylink_link_state *state);
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
-	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 };
 
 int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
@@ -38,5 +37,6 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 		    int enable);
+int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

