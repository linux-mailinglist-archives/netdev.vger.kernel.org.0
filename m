Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCC16E0FBB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjDMOOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDMOOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:14:09 -0400
Received: from h1.cmg1.smtp.forpsi.com (h1.cmg1.smtp.forpsi.com [81.2.195.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD04D3AAB
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 07:14:07 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id mxi8pEi7aPm6Cmxi9pKcoR; Thu, 13 Apr 2023 16:14:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681395245; bh=d4RY8XHU9yr1d2C7YF4zciMiPeh9xjFTvv8n5kIJFCg=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=jHP1KzIJtaiYWVt32Li+nEIMNegwokCKrWVBGagI3+pzvSdLwhqZG0KdfJFIST938
         UfSP95+l/S516/Ntecy7CYWhCM8MAfN/nJZuDyn7sbGIA0vXNLfZeh/NPmpOYU93Rz
         jMMTwt0VWhbeqSz2B0Lq8pQvh/QN0MSpmKWSvCHB5LB9We+yXoRO+M1c7edzojUIWJ
         k1dYxg4zzAxw+QypoZ9kX/fSYFknfY536ySHm8zWOihQlaj4muM54RUEz8Dbovc4O4
         Pkc4XmS2fA2LxxJo/BJqPkLPq9HyEy2gjFymJ1Z/Jv6p7xAdE+29msMx9pKkf28OvO
         TeKVPjmqMuZ9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681395245; bh=d4RY8XHU9yr1d2C7YF4zciMiPeh9xjFTvv8n5kIJFCg=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=jHP1KzIJtaiYWVt32Li+nEIMNegwokCKrWVBGagI3+pzvSdLwhqZG0KdfJFIST938
         UfSP95+l/S516/Ntecy7CYWhCM8MAfN/nJZuDyn7sbGIA0vXNLfZeh/NPmpOYU93Rz
         jMMTwt0VWhbeqSz2B0Lq8pQvh/QN0MSpmKWSvCHB5LB9We+yXoRO+M1c7edzojUIWJ
         k1dYxg4zzAxw+QypoZ9kX/fSYFknfY536ySHm8zWOihQlaj4muM54RUEz8Dbovc4O4
         Pkc4XmS2fA2LxxJo/BJqPkLPq9HyEy2gjFymJ1Z/Jv6p7xAdE+29msMx9pKkf28OvO
         TeKVPjmqMuZ9A==
Date:   Thu, 13 Apr 2023 16:14:04 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <ZDgOLHw1IkmWVU79@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgNexVTEfyGo77d@lenoch>
X-CMAE-Envelope: MS4wfGHwwZS7Gk02EBad2RtgD3BzQprvwVOWYEp597MhjkvcfpbgvgIOuKGnZhOoMV21xs8mMfVr0nzK7NJkl7UwEmuxp4jrRveq7hurxt49iIbXvlC3DsAE
 EIgbcy43VJg1jeqdVVt3MUHjpk+5pakgDChGNvgnUj7G1rSFJ9l1VNutAC2EoIcr5SCdx4OEvF3rjsUKHsR5Q+v+WXhYSyG0KaoRmlATE0HNCNi7RPSwjgid
 BPWROsR80bOq2Mb784p7jJXdB8toFukFh7z1EeOg174KBLrPlg46QykBD7U7yLUh
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ladislav Michl <ladis@linux-mips.org>

Etherdev is allocated and then tested for valid interface,
then it is immediately freed after port is found unsupported.
Move that decision out of the port loop.

Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
---
 drivers/staging/octeon/ethernet.c | 114 +++++++++++++++---------------
 1 file changed, 58 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 949ef51bf896..466d43a71d34 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -799,18 +799,63 @@ static int cvm_oct_probe(struct platform_device *pdev)
 
 	num_interfaces = cvmx_helper_get_number_of_interfaces();
 	for (interface = 0; interface < num_interfaces; interface++) {
+		int num_ports, port_index;
+		const struct net_device_ops *ops;
+		const char *name;
+		phy_interface_t phy_mode = PHY_INTERFACE_MODE_NA;
 		cvmx_helper_interface_mode_t imode =
-		    cvmx_helper_interface_get_mode(interface);
-		int num_ports = cvmx_helper_ports_on_interface(interface);
-		int port_index;
+			cvmx_helper_interface_get_mode(interface);
+
+		switch (imode) {
+		case CVMX_HELPER_INTERFACE_MODE_NPI:
+			ops = &cvm_oct_npi_netdev_ops;
+			name = "npi%d";
+			break;
+
+		case CVMX_HELPER_INTERFACE_MODE_XAUI:
+			ops = &cvm_oct_xaui_netdev_ops;
+			name = "xaui%d";
+			break;
+
+		case CVMX_HELPER_INTERFACE_MODE_LOOP:
+			ops = &cvm_oct_npi_netdev_ops;
+			name = "loop%d";
+			break;
+
+		case CVMX_HELPER_INTERFACE_MODE_SGMII:
+			ops = &cvm_oct_sgmii_netdev_ops;
+			name = "eth%d";
+			phy_mode = PHY_INTERFACE_MODE_SGMII;
+			break;
+
+		case CVMX_HELPER_INTERFACE_MODE_SPI:
+			ops = &cvm_oct_spi_netdev_ops;
+			name = "spi%d";
+			break;
+
+		case CVMX_HELPER_INTERFACE_MODE_GMII:
+			ops = &cvm_oct_rgmii_netdev_ops;
+			name = "eth%d";
+			phy_mode = PHY_INTERFACE_MODE_GMII;
+			break;
 
+		case CVMX_HELPER_INTERFACE_MODE_RGMII:
+			ops = &cvm_oct_rgmii_netdev_ops;
+			name = "eth%d";
+			break;
+
+		default:
+			continue;
+		}
+
+		num_ports = cvmx_helper_ports_on_interface(interface);
 		for (port_index = 0,
 		     port = cvmx_helper_get_ipd_port(interface, 0);
 		     port < cvmx_helper_get_ipd_port(interface, num_ports);
 		     port_index++, port++) {
 			struct octeon_ethernet *priv;
 			struct net_device *dev =
-			    alloc_etherdev(sizeof(struct octeon_ethernet));
+				alloc_etherdev(sizeof(struct octeon_ethernet));
 			if (!dev) {
 				pr_err("Failed to allocate ethernet device for port %d\n",
 				       port);
@@ -830,7 +875,12 @@ static int cvm_oct_probe(struct platform_device *pdev)
 			priv->port = port;
 			priv->queue = cvmx_pko_get_base_queue(priv->port);
 			priv->fau = fau - cvmx_pko_get_num_queues(port) * 4;
-			priv->phy_mode = PHY_INTERFACE_MODE_NA;
+			priv->phy_mode = phy_mode;
+			if (imode == CVMX_HELPER_INTERFACE_MODE_RGMII)
+				cvm_set_rgmii_delay(priv, interface,
+						    port_index);
+			dev->netdev_ops = ops;
+			strscpy(dev->name, name, sizeof(dev->name));
 			for (qos = 0; qos < 16; qos++)
 				skb_queue_head_init(&priv->tx_free_list[qos]);
 			for (qos = 0; qos < cvmx_pko_get_num_queues(port);
@@ -839,64 +889,16 @@ static int cvm_oct_probe(struct platform_device *pdev)
 			dev->min_mtu = VLAN_ETH_ZLEN - mtu_overhead;
 			dev->max_mtu = OCTEON_MAX_MTU - mtu_overhead;
 
-			switch (priv->imode) {
-			/* These types don't support ports to IPD/PKO */
-			case CVMX_HELPER_INTERFACE_MODE_DISABLED:
-			case CVMX_HELPER_INTERFACE_MODE_PCIE:
-			case CVMX_HELPER_INTERFACE_MODE_PICMG:
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_NPI:
-				dev->netdev_ops = &cvm_oct_npi_netdev_ops;
-				strscpy(dev->name, "npi%d", sizeof(dev->name));
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_XAUI:
-				dev->netdev_ops = &cvm_oct_xaui_netdev_ops;
-				strscpy(dev->name, "xaui%d", sizeof(dev->name));
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_LOOP:
-				dev->netdev_ops = &cvm_oct_npi_netdev_ops;
-				strscpy(dev->name, "loop%d", sizeof(dev->name));
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_SGMII:
-				priv->phy_mode = PHY_INTERFACE_MODE_SGMII;
-				dev->netdev_ops = &cvm_oct_sgmii_netdev_ops;
-				strscpy(dev->name, "eth%d", sizeof(dev->name));
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_SPI:
-				dev->netdev_ops = &cvm_oct_spi_netdev_ops;
-				strscpy(dev->name, "spi%d", sizeof(dev->name));
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_GMII:
-				priv->phy_mode = PHY_INTERFACE_MODE_GMII;
-				dev->netdev_ops = &cvm_oct_rgmii_netdev_ops;
-				strscpy(dev->name, "eth%d", sizeof(dev->name));
-				break;
-
-			case CVMX_HELPER_INTERFACE_MODE_RGMII:
-				dev->netdev_ops = &cvm_oct_rgmii_netdev_ops;
-				strscpy(dev->name, "eth%d", sizeof(dev->name));
-				cvm_set_rgmii_delay(priv, interface,
-						    port_index);
-				break;
-			}
-
 			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
 				if (of_phy_register_fixed_link(priv->of_node)) {
 					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
 						   interface, priv->port);
-					dev->netdev_ops = NULL;
+					free_netdev(dev);
+					continue;
 				}
 			}
 
-			if (!dev->netdev_ops) {
-				free_netdev(dev);
-			} else if (register_netdev(dev) < 0) {
+			if (register_netdev(dev) < 0) {
 				pr_err("Failed to register ethernet device for interface %d, port %d\n",
 				       interface, priv->port);
 				free_netdev(dev);
-- 
2.32.0

