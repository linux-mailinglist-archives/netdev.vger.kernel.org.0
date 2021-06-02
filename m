Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938B398FD8
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFBQXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:23:35 -0400
Received: from mail-ej1-f51.google.com ([209.85.218.51]:34529 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhFBQXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:23:31 -0400
Received: by mail-ej1-f51.google.com with SMTP id g8so4762821ejx.1
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bq4oZb2dKio7jhtcSXyjTHi6FvT3v8gKCUi4OjyUpAI=;
        b=SmG/q6ZFigw9LUv331lYY33G/RUbSmOSdZR4CqfUz1L85Ij5lNCo1VJ0dJrxdw98ah
         DankNTWBTBhppN6qHhxv5Jvg5jMxIM5btdBvYalztzI/BlbCNfKpCVBKNkT29xKTQafY
         aQyd/CR/D8tSWCBFnk1K/fbsh4X0tloeziC0Tv9CZDvAs12k+HmSG1HunP1YozGSniK9
         0nIbk5gQYKrhbh5z9k4yyFq6kyFgwIUDRVpDt5aD95ebXTqTyHGp9sB2L7xvjIJC5hdO
         zRjF/NtxwnNL0Am/qv1QPyIZpHLXipvC43u56rMPJnlDryIUYc9VrnsV4T32inAOkrIu
         OpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bq4oZb2dKio7jhtcSXyjTHi6FvT3v8gKCUi4OjyUpAI=;
        b=daGb+ooJwLzOkcT49Ho18ipoiH3w38hHIZgRvRXXJNL59DF81Y2Z1KsMEpmX3CdeFd
         AXSnqfOgddaVIWiVNAOnET3EGd5aE/6L+3kgY2NGPJlP2/O603UwOU/C7e8mhtRSZTfX
         iPf+W+22QJVp7sNFYfqqQQchKLZOcqcoa1NyHExhmhSp3LksrRllPpSRfRRe3Qr5z0n8
         FzINexd013rWtWXIDKWW13uSflzkagZT3dH+gLaAUNEIGwJOMyl9V9OthtRyTBNrJqvu
         PpQhgCRu2+xNFmpCD9+YCRoi4PPXIeiIgw7ac7xQN3WH75wWzxvL5lOzZ59KvI0790ep
         54EQ==
X-Gm-Message-State: AOAM533BK4AVqVTm6AY4wphp5Mt/GX4A8bo3hKK9Bi0+EOEzs+IK/tkH
        qXLpnwm8kEgKB+nDjurS4o4Wdy1OggA=
X-Google-Smtp-Source: ABdhPJzOZTcycaOCxrWxDDyxXlEJvGgvUmtBpEzsDgKIPKk1HcOmV1Jol4LW1bdLQJYOETAJpzZKKw==
X-Received: by 2002:a17:906:d297:: with SMTP id ay23mr27183959ejb.418.1622650836659;
        Wed, 02 Jun 2021 09:20:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:36 -0700 (PDT)
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
Subject: [PATCH v3 net-next 4/9] net: pcs: xpcs: export xpcs_validate
Date:   Wed,  2 Jun 2021 19:20:14 +0300
Message-Id: <20210602162019.2201925-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602162019.2201925-1-olteanv@gmail.com>
References: <20210602162019.2201925-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Calling a function pointer with a single implementation through
struct mdio_xpcs_ops is clunky, and the stmmac_do_callback system forces
this to return int, even though it always returns zero.

Simply remove the "validate" function pointer from struct mdio_xpcs_ops
and replace it with an exported xpcs_validate symbol which is called
directly by stmmac.

priv->hw->xpcs is of the type "const struct mdio_xpcs_ops *" and is used
as a placeholder/synonym for priv->plat->mdio_bus_data->has_xpcs. It is
done that way because the mdio_bus_data pointer might or might not be
populated in all stmmac instantiations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: guard against potential absence of xpcs on the port
v2->v3: none

 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++-
 drivers/net/pcs/pcs-xpcs.c                        | 11 ++++-------
 include/linux/pcs/pcs-xpcs.h                      |  5 ++---
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 75a8b90c202a..a86b358feae9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -613,8 +613,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_void_callback(__priv, mmc, read, __args)
 
 /* XPCS callbacks */
-#define stmmac_xpcs_validate(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, validate, __args)
 #define stmmac_xpcs_config(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, config, __args)
 #define stmmac_xpcs_get_state(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 129b103cd2b5..9f72e4dd1457 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -996,7 +996,8 @@ static void stmmac_validate(struct phylink_config *config,
 	linkmode_andnot(state->advertising, state->advertising, mask);
 
 	/* If PCS is supported, check which modes it supports. */
-	stmmac_xpcs_validate(priv, &priv->hw->xpcs_args, supported, state);
+	if (priv->hw->xpcs)
+		xpcs_validate(&priv->hw->xpcs_args, supported, state);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 610073cb55d0..2f7791bcf07b 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -685,9 +685,8 @@ static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
 	}
 }
 
-static int xpcs_validate(struct mdio_xpcs_args *xpcs,
-			 unsigned long *supported,
-			 struct phylink_link_state *state)
+void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+		   struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(xpcs_supported);
 	const struct xpcs_compat *compat;
@@ -698,7 +697,7 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 	 * advertising masks and exit.
 	 */
 	if (state->interface == PHY_INTERFACE_MODE_NA)
-		return 0;
+		return;
 
 	bitmap_zero(xpcs_supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 
@@ -713,9 +712,8 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 
 	linkmode_and(supported, supported, xpcs_supported);
 	linkmode_and(state->advertising, state->advertising, xpcs_supported);
-
-	return 0;
 }
+EXPORT_SYMBOL_GPL(xpcs_validate);
 
 static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 			   int enable)
@@ -1031,7 +1029,6 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 }
 
 static struct mdio_xpcs_ops xpcs_ops = {
-	.validate = xpcs_validate,
 	.config = xpcs_config,
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index c2ec440d2c5d..5ec9aaca01fe 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -23,9 +23,6 @@ struct mdio_xpcs_args {
 };
 
 struct mdio_xpcs_ops {
-	int (*validate)(struct mdio_xpcs_args *xpcs,
-			unsigned long *supported,
-			struct phylink_link_state *state);
 	int (*config)(struct mdio_xpcs_args *xpcs,
 		      const struct phylink_link_state *state);
 	int (*get_state)(struct mdio_xpcs_args *xpcs,
@@ -39,5 +36,7 @@ struct mdio_xpcs_ops {
 
 int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
+void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+		   struct phylink_link_state *state);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

