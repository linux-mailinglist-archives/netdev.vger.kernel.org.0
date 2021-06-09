Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF013A1CF6
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhFISp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:45:28 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:37688 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhFISp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:45:26 -0400
Received: by mail-ed1-f45.google.com with SMTP id b11so29705030edy.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Em2Aa6J9F9kVM3gPQWlF7kYj4x4JvyM78lJMl8Zig3o=;
        b=JoSVQVFTNTAEeYjHGzozM7gQyg24oygZV7KkZt7iI7GlIADiwfPTg6I7QYepOfOQNk
         aB6Hho0cd+sBAuXZoV2T5XcK9yqrKwUuv3tLSCZ8nt6eZcupa3+DZlck363CM42RiBo8
         3vxnIIGXrdiDlgBXb1iuMzvZzdvioDtut273R2+I5oyRxhRQ1ycjUVJHbZfZ2IpdybHy
         EpkOieHxFz4ByGiRgTtTEmA0LSHf9V6qQoHgWuJ+o/ZUHkh5ntAsrhfkHvIfYPMeigKS
         idaDECsgD2Fft8wQR1LPA4jHfiUWAhHv+bVmy6HS8LnvN+X4aAOWVVBQYtn0Hj3vjLGW
         UTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Em2Aa6J9F9kVM3gPQWlF7kYj4x4JvyM78lJMl8Zig3o=;
        b=f7dNE6K/wY1WTq1i7BZvHfUcBPV2AvZVDi0BQ9bviaOUqQIA3BXHi2rcBfPOVMY5SX
         CI9j+bbs9p38WyRoC8ZmwFNblbEdtyMd3U6ke8sQem7eBZiuAEG3R4CeP6n+e4jIDYP0
         xbeSzsvlYpKrEL58hsE+vPVcvja26AHccUi9uc1/LaZLlfOl17lupgcxuSQHlYEzs/03
         8TKjiG9gslBh6CbRw8TpCmlzEnIihERsaiANdLPRkQEstHvAdUQWC4cldW+Ly9Eej/K5
         Ss/lHLIwH9eBk0iLoCU+wG7dn1B/FC11fQ+2/rSlhMNIePVmQ61AlSxz1Y4ZRm0P/upR
         ki9g==
X-Gm-Message-State: AOAM53125ybTlqGnukvqZFsNfXcgsY5J24+pO3apZKvncHAAP7/O+fip
        kdaU9hTGP7J6n43WyRAVdFc=
X-Google-Smtp-Source: ABdhPJw/5MfgzEKbAgmGT6YPTzNE8HTYTLO6hT0SrTjIkVUCJskE9HRcxvqZOxbPYLX/p9++tg5SXQ==
X-Received: by 2002:a05:6402:612:: with SMTP id n18mr765642edv.83.1623264143511;
        Wed, 09 Jun 2021 11:42:23 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:23 -0700 (PDT)
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
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 09/13] net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
Date:   Wed,  9 Jun 2021 21:41:51 +0300
Message-Id: <20210609184155.921662-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 hardware has a quirk in that some changes require a switch
reset, which loses all configuration. When the reset is initiated,
everything needs to be reprogrammed, including the MACs and the PCS.
This is currently done in sja1105_static_config_reload() - we manually
call sja1105_adjust_port_config(), sja1105_sgmii_pcs_config() and
sja1105_sgmii_pcs_force_speed() which are all internal functions.

There is a desire for sja1105 to use the common xpcs driver, and that
means that the equivalents of those functions, xpcs_do_config() and
xpcs_link_up() respectively, will no longer be local functions.

Forcing phylink to retrigger a resolve somehow, say by doing dev_close()
followed by dev_open() is not really an option, because the CPU port
might have a PCS as well, and there is no net device which we can close
and reopen for that. Additionally, the dev_close/dev_open sequence might
force a renegotiation of the copper-side link for SGMII ports connected
to a PHY, and this is undesirable as well, because the switch reset is
much quicker than a PHY autoneg, so we would have a lot more downtime.

The only solution I see is for the sja1105 driver to keep doing what
it's doing, and that means we need to export the equivalents from xpcs
for sja1105_sgmii_pcs_config and sja1105_sgmii_pcs_force_speed, and call
them directly in sja1105_static_config_reload(). This will be done
during the conversion patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c   | 10 ++++++----
 include/linux/pcs/pcs-xpcs.h |  4 ++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index b66e46fc88dc..63fda3fc40aa 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -757,8 +757,8 @@ static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
 }
 
-static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
-			  unsigned int mode)
+int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
+		   unsigned int mode)
 {
 	const struct xpcs_compat *compat;
 	int ret;
@@ -797,6 +797,7 @@ static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xpcs_do_config);
 
 static int xpcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		       phy_interface_t interface,
@@ -945,8 +946,8 @@ static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
 		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
 }
 
-static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
-			 phy_interface_t interface, int speed, int duplex)
+void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+		  phy_interface_t interface, int speed, int duplex)
 {
 	struct dw_xpcs *xpcs = phylink_pcs_to_xpcs(pcs);
 
@@ -955,6 +956,7 @@ static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 	if (interface == PHY_INTERFACE_MODE_SGMII)
 		return xpcs_link_up_sgmii(xpcs, mode, speed, duplex);
 }
+EXPORT_SYMBOL_GPL(xpcs_link_up);
 
 static u32 xpcs_get_id(struct dw_xpcs *xpcs)
 {
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index dae7dd8ac683..add077a81b21 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -27,6 +27,10 @@ struct dw_xpcs {
 };
 
 int xpcs_get_an_mode(struct dw_xpcs *xpcs, phy_interface_t interface);
+void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
+		  phy_interface_t interface, int speed, int duplex);
+int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
+		   unsigned int mode);
 void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
-- 
2.25.1

