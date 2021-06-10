Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADDC3A32DD
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFJSRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:17:55 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:43538 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhFJSRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:17:54 -0400
Received: by mail-ej1-f42.google.com with SMTP id ci15so576534ejc.10
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gTAsY/sJNmf1jHF8Wa07cWzf4MZlEGX3+GdJQ4nlawE=;
        b=GJqLnR0OiD8YXY+dc6c38VP0TDV0hK+wB7MrCaEuPHOhlX/QbeK49E6NAb3SKyEvb+
         puUC7s3KcJHAFDQ4pVuBdXrfzxTBvsZ1YxLAqNfaesA9k4eGeJsiwp9aKCGATd0KhY5q
         DefMGejWJFsszJdlYq0PVz10Js55yHSVXv+m+OaFy56qF6NhgZP3naek0K8UGJOzHDCJ
         kJ+ymkxnOjec9e08b5K94iC7h5fW1ItcwqGJS9Er5dQLmTwU39UYEHsyFeKBtjvQuvhU
         zgNPMTfE5l9bmHQD8V8mDbd3mu3ugeWVcoBDG50BZUkEgmOS62Exk2iixvcDMH9ZeMPJ
         maCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gTAsY/sJNmf1jHF8Wa07cWzf4MZlEGX3+GdJQ4nlawE=;
        b=GY5p+BgM2lxhdGMpc8zxYy19vOVmWeSg/v20/4cwKR9G1cEtmB59cR/yNsLTP/XilJ
         lbQi5DyR7ipK4NXB8BuwdK5D6FTyXllz3RO47ut2ol5fN9Jb9ZOfAje+0Ngg0LKRe4OQ
         dIXgo6x+xlvEJJsOb5O9OViaHYPs8SMTBI/09YXyWyvcitf+HG3QxoKcmdbKKR7EvWBh
         2ZN6lAaNwM5is5BjyCDH/BdycAaSohgk5kr62t3/SG7o+WxTJ6kI41bifTsMKRti3R6f
         FmU6C7+pvu+GKH8YZGM/CQOVP3uZymShNHpn2tgdtaSGNOVLHBOBFRNlgxXGLTs4NtbC
         j9NQ==
X-Gm-Message-State: AOAM531k09w/9ARhylc58cAsOn7ufQzDp9+1fE6hEjeML01brEr/JwJz
        c2hIH/CF1R9n/4WL324JoVo=
X-Google-Smtp-Source: ABdhPJzWUCONu4Kci0lduScsiGdAnby3UNb4T7mMSUMH3pCPgNdLQSSsiyUYirqVhVApYjMboh6XUQ==
X-Received: by 2002:a17:907:1de6:: with SMTP id og38mr808156ejc.471.1623348886471;
        Thu, 10 Jun 2021 11:14:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:45 -0700 (PDT)
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
Subject: [PATCH v2 net-next 09/13] net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
Date:   Thu, 10 Jun 2021 21:14:06 +0300
Message-Id: <20210610181410.1886658-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
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

