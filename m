Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B825EF5F4B
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfKINDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52004 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfKIND3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id q70so8821671wme.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VUvpR+5F+/feZDo8xe2PGrDrm/t0O8q53kVISy55Zz8=;
        b=CLt4jzLJ6vjbywnZ8thypcWw+KWLYzuI+uxiTDQGE30ti9QJ5XhBcwUHo/c+BSEf1h
         K1fUlkxR+sM1MLNyfRSS2CadOvva4jO7eRPvFMQMA1JWzjCj3dmoGHmCku7o0vxO0JtX
         1kVncdtmIjbcOBYd+BKU8BTMsdeUvCpBuFF9j7MQMK8jlEG6KRkr+rIT+stV3GLczTiI
         XQZfBJCzfla1RQ3OI+ZIvgdUhRaBLUOf2lxWa1Hd9dcEbzpnwFIjNVZNe5N961g1AGG5
         BBu/PnjI06coSooa44rDj5PNQDKYMPime205MFb+lOvVXX9LGBbbzPwe+TkV8gePD1Mn
         bf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VUvpR+5F+/feZDo8xe2PGrDrm/t0O8q53kVISy55Zz8=;
        b=cVQ867HY6p+WAAtJL2kr/yanbNrLrPnNd4o3QfduQWYdrE3RB725X137Bu+DQ2vdLG
         wC8RI9hTdjP7PznhFV4gdg0SVBI4K2WhC1JLchF8WcQGy6E8rW8SPRkLZC3gX/bFPqfe
         3/jtk2m1o6IDo+6iavJguFDR0ivFoeVBpR8YEMzD1r8Z1HYGIx+ufhMVrNK/2YijU/BD
         9CdqWqe3IZ2hUoU66O9//eNiSDJ/jNH4HEUuPBgEeJg8vHDGPYa0HrF8st+i2pphjABr
         XLii2OLYavohBOe21yjfRwdlUx3M4o7UtjfH87HiGTNMCa368K+I+U/3BgYpZ6NvALFx
         iY2A==
X-Gm-Message-State: APjAAAW/YaQElRMafhStfQynUlARZxUkCOtaXAx21bcxUgns9bmm/R7H
        gAmooMA2QsqUlkWyQSf6mKw=
X-Google-Smtp-Source: APXvYqwP+h7CooRFqsgVIN5iCx8XHGy+L4O2HyJlUnN4RVCZ4S50R7X8/vzlbBnTNQRRyRYiNZXfNQ==
X-Received: by 2002:a7b:c632:: with SMTP id p18mr12855974wmk.73.1573304605268;
        Sat, 09 Nov 2019 05:03:25 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:24 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 05/15] net: mscc: ocelot: change prototypes of switchdev port attribute handlers
Date:   Sat,  9 Nov 2019 15:02:51 +0200
Message-Id: <20191109130301.13716-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is needed so that the Felix DSA front-end can call the Ocelot
implementations.

The implementation of the "mc_disabled" switchdev attribute has also
been simplified by using the read-modify-write macro instead of
open-coding that operation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 88 +++++++++++++++---------------
 1 file changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8b7d46693e49..ba8996bf995e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1285,26 +1285,20 @@ static const struct ethtool_ops ocelot_ethtool_ops = {
 	.get_ts_info		= ocelot_get_ts_info,
 };
 
-static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
-					  struct switchdev_trans *trans,
-					  u8 state)
+static void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port,
+					u8 state)
 {
-	struct ocelot *ocelot = ocelot_port->ocelot;
 	u32 port_cfg;
-	int port, i;
-
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
+	int p, i;
 
-	if (!(BIT(ocelot_port->chip_port) & ocelot->bridge_mask))
-		return 0;
+	if (!(BIT(port) & ocelot->bridge_mask))
+		return;
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG,
-				   ocelot_port->chip_port);
+	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
 
 	switch (state) {
 	case BR_STATE_FORWARDING:
-		ocelot->bridge_fwd_mask |= BIT(ocelot_port->chip_port);
+		ocelot->bridge_fwd_mask |= BIT(port);
 		/* Fallthrough */
 	case BR_STATE_LEARNING:
 		port_cfg |= ANA_PORT_PORT_CFG_LEARN_ENA;
@@ -1312,19 +1306,18 @@ static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
 
 	default:
 		port_cfg &= ~ANA_PORT_PORT_CFG_LEARN_ENA;
-		ocelot->bridge_fwd_mask &= ~BIT(ocelot_port->chip_port);
+		ocelot->bridge_fwd_mask &= ~BIT(port);
 		break;
 	}
 
-	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG,
-			 ocelot_port->chip_port);
+	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
 	 * a source for the other ports.
 	 */
-	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (ocelot->bridge_fwd_mask & BIT(port)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+	for (p = 0; p < ocelot->num_phys_ports; p++) {
+		if (ocelot->bridge_fwd_mask & BIT(p)) {
+			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
 
 			for (i = 0; i < ocelot->num_phys_ports; i++) {
 				unsigned long bond_mask = ocelot->lags[i];
@@ -1332,7 +1325,7 @@ static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
 				if (!bond_mask)
 					continue;
 
-				if (bond_mask & BIT(port)) {
+				if (bond_mask & BIT(p)) {
 					mask &= ~bond_mask;
 					break;
 				}
@@ -1340,47 +1333,55 @@ static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
 
 			ocelot_write_rix(ocelot,
 					 BIT(ocelot->num_phys_ports) | mask,
-					 ANA_PGID_PGID, PGID_SRC + port);
+					 ANA_PGID_PGID, PGID_SRC + p);
 		} else {
 			/* Only the CPU port, this is compatible with link
 			 * aggregation.
 			 */
 			ocelot_write_rix(ocelot,
 					 BIT(ocelot->num_phys_ports),
-					 ANA_PGID_PGID, PGID_SRC + port);
+					 ANA_PGID_PGID, PGID_SRC + p);
 		}
 	}
+}
 
-	return 0;
+static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
+					   struct switchdev_trans *trans,
+					   u8 state)
+{
+	if (switchdev_trans_ph_prepare(trans))
+		return;
+
+	ocelot_bridge_stp_state_set(ocelot, port, state);
+}
+
+static void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
+{
+	ocelot_write(ocelot, ANA_AUTOAGE_AGE_PERIOD(msecs / 2),
+		     ANA_AUTOAGE);
 }
 
-static void ocelot_port_attr_ageing_set(struct ocelot_port *ocelot_port,
+static void ocelot_port_attr_ageing_set(struct ocelot *ocelot, int port,
 					unsigned long ageing_clock_t)
 {
-	struct ocelot *ocelot = ocelot_port->ocelot;
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
 	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
 
-	ocelot_write(ocelot, ANA_AUTOAGE_AGE_PERIOD(ageing_time / 2),
-		     ANA_AUTOAGE);
+	ocelot_set_ageing_time(ocelot, ageing_time);
 }
 
-static void ocelot_port_attr_mc_set(struct ocelot_port *port, bool mc)
+static void ocelot_port_attr_mc_set(struct ocelot *ocelot, int port, bool mc)
 {
-	struct ocelot *ocelot = port->ocelot;
-	u32 val = ocelot_read_gix(ocelot, ANA_PORT_CPU_FWD_CFG,
-				  port->chip_port);
+	u32 cpu_fwd_mcast = ANA_PORT_CPU_FWD_CFG_CPU_IGMP_REDIR_ENA |
+			    ANA_PORT_CPU_FWD_CFG_CPU_MLD_REDIR_ENA |
+			    ANA_PORT_CPU_FWD_CFG_CPU_IPMC_CTRL_COPY_ENA;
+	u32 val = 0;
 
 	if (mc)
-		val |= ANA_PORT_CPU_FWD_CFG_CPU_IGMP_REDIR_ENA |
-		       ANA_PORT_CPU_FWD_CFG_CPU_MLD_REDIR_ENA |
-		       ANA_PORT_CPU_FWD_CFG_CPU_IPMC_CTRL_COPY_ENA;
-	else
-		val &= ~(ANA_PORT_CPU_FWD_CFG_CPU_IGMP_REDIR_ENA |
-			 ANA_PORT_CPU_FWD_CFG_CPU_MLD_REDIR_ENA |
-			 ANA_PORT_CPU_FWD_CFG_CPU_IPMC_CTRL_COPY_ENA);
+		val = cpu_fwd_mcast;
 
-	ocelot_write_gix(ocelot, val, ANA_PORT_CPU_FWD_CFG, port->chip_port);
+	ocelot_rmw_gix(ocelot, val, cpu_fwd_mcast,
+		       ANA_PORT_CPU_FWD_CFG, port);
 }
 
 static int ocelot_port_attr_set(struct net_device *dev,
@@ -1389,22 +1390,23 @@ static int ocelot_port_attr_set(struct net_device *dev,
 {
 	struct ocelot_port *ocelot_port = netdev_priv(dev);
 	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = ocelot_port->chip_port;
 	int err = 0;
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		ocelot_port_attr_stp_state_set(ocelot_port, trans,
+		ocelot_port_attr_stp_state_set(ocelot, port, trans,
 					       attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		ocelot_port_attr_ageing_set(ocelot_port, attr->u.ageing_time);
+		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port_vlan_filtering(ocelot, ocelot_port->chip_port,
+		ocelot_port_vlan_filtering(ocelot, port,
 					   attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
-		ocelot_port_attr_mc_set(ocelot_port, !attr->u.mc_disabled);
+		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.17.1

