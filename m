Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFB5398FCF
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFBQWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFBQWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:22:23 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A869AC061756
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 09:20:40 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a11so4009624ejf.3
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCg9Dutw1JRzfj+NqxI+WdW2d+OdsEcix9C/qdUkoaI=;
        b=pEqFvvXCO2O1bfnMpxPql0NT9QLMEFzpnwZcmQJEEC/0MCs/Ml+mi2YtpKnlH/+qL9
         mrmleUuS3HEoKUf08wzvgm3vH248+boWpu85Npb+egvFIAE+j7YhDHrnh5Ci0QEbfVvE
         oxV6JtUZU5BbgrfwjsImlnMHrmz/b9yY/uMrNPE/e9w0kwXDEhmqVx3Swd/1eBWR90fR
         CXsvgvyH61h15YcaiPKAyB/4xS2T3Q05aDVYCN3iutqMzxm9tz3sjtOWb7BTt47w7zEa
         b4asKoLxFCbKZV4QiWxRq5FwxyPVvkGjhY5bjDGklsIgMz9frZaBotbxUbSKy1LnJXRN
         0LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCg9Dutw1JRzfj+NqxI+WdW2d+OdsEcix9C/qdUkoaI=;
        b=hS8GQ71ONSIbShLT7TeYWMmJu3lJtHfaCYh4+/SPkmUrzoASgWFnAzmWk0UBLnti7D
         aKs16X62P59y6vmRD+jZMw/JEWw8y1egXouzIAU7Z8gvhJlGSWN0qdxfdWzoRz1uc+gX
         ocYuGvsXNUmSD2bSjlwJn+1Ydhkq1mYyNQWirL6+sldiL6aVlC5jzE85ld7Eo02PGCm8
         9aiQVQNGT1RurU/A61Wx1MuIR6P1O7C9BCbmWxspUhMWsdTj8sZyRU7MNOoierpSidXK
         oaSowlkHuQwebcrXamec2yknjGgRohc8DEvFDlAA5lUcHWfmLjNUv+O9Xa7X4SgIg1Ib
         BzDA==
X-Gm-Message-State: AOAM532i01WTMmXxQpaEjCnUTjupbgBF3Gsi8lvLyHlTjme2FiLCZYx5
        EBjKlbmM0Tvm9Ydrf8RlB1UN4UsGslo=
X-Google-Smtp-Source: ABdhPJwrO1GqXAqfLADuvwCQUK0lUM2yLkQ82h/YTl+x0RQayK6aV1sp9dz91S9uLSnX6wu/szpTuw==
X-Received: by 2002:a17:906:8041:: with SMTP id x1mr13052671ejw.81.1622650839307;
        Wed, 02 Jun 2021 09:20:39 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 6/9] net: pcs: xpcs: export xpcs_probe
Date:   Wed,  2 Jun 2021 19:20:16 +0300
Message-Id: <20210602162019.2201925-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602162019.2201925-1-olteanv@gmail.com>
References: <20210602162019.2201925-1-olteanv@gmail.com>
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
v1->v2: keep passing the phy_interface_t argument to xpcs_probe
v2->v3: none

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
index 2f2ffab855aa..7f51eb4bbaa4 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1005,7 +1005,7 @@ static const struct xpcs_id xpcs_id_list[] = {
 	},
 };
 
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

