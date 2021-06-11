Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12113A49E3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFKUJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:09:16 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:36359 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhFKUJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:09:15 -0400
Received: by mail-ed1-f52.google.com with SMTP id w21so38383469edv.3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9J82lfUtfOhld0+zQlTxDsuWpTNh0bxTBpmDmOlV2PA=;
        b=Alta6xDeTN7DRmmYxXL3IQ/X8sdytpS/n+GrYjjCG+93ybbRgoiTbtUlTuwrejXkS3
         37KscVpgba9Ajo8v4+ukFvsZdgCV3Eis4Y8B2w5+VmiMXmZSBqKI9yPFFwf6B3oaCvb0
         3XD+BX8twxmcSQJsUYyiRU+SvtCuan0UyDTDNXa0B/ASWbIOsHWj7WKXT0EZSUZKwZmx
         SVp8EzuSGVTqS4NY+MMh6HXNZEDfePGudBMp55S89oUIJHkuW0RfXCYZ8dsBNKJKJAVh
         Wx6dfaNXWSt91P3JjBsFl+UbfBuuy7yvPpt5gOWoAHBzCq4zRxb/RGNMCMWOO5grSWhb
         +hNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9J82lfUtfOhld0+zQlTxDsuWpTNh0bxTBpmDmOlV2PA=;
        b=HfNk1UWvVYVA5PH9lmA70xrMhuMqan1+kyWle6MPK7sQIXe05U1iNRxqQ7JlkKyYl+
         3QtSycAqfagteVxvVUZHIF4p3vZUbnMeXZeqy1qOdtjLYo4rKT3Nk3Wp4nWUVLzMIx3u
         mLwzAyVKuMHB+PZxQAAV6dhQPkglWgKmxl9MzDiXAwKo7544WO31AwS8ZB4ompLsUS4o
         JBRQA21itVMXU38+0CZ0SAHbrii7HR3Lgq+MM3m2NuO5MDGygJZ+GXAimqF/hvoTUv9g
         huWr2E/5v3sCtwyO7l3ylM5hjR7cxwjXVYaDvSkgL1mWsuI64Fy1l7368grcp8ADwn0K
         rWbQ==
X-Gm-Message-State: AOAM533kNUUATIoeu7+YiToE3x9xHmXxN2cpZtb7qM5zZuO38Wap56py
        pGSdwsXIQSGLXqDke/g2Q3o=
X-Google-Smtp-Source: ABdhPJxNlEpITTIafXz9TBGJwWkEwcqI6EwN3AZjuzC31TaR/L75yoR1cwbJcMlwbIx7aX9G5kR7UQ==
X-Received: by 2002:a50:ec08:: with SMTP id g8mr5549553edr.376.1623441959700;
        Fri, 11 Jun 2021 13:05:59 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:59 -0700 (PDT)
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
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 09/13] net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
Date:   Fri, 11 Jun 2021 23:05:27 +0300
Message-Id: <20210611200531.2384819-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
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
v2->v3: none
v1->v2: none

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

