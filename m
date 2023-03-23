Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904346C6E52
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjCWRCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCWRCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:02:50 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2320DA;
        Thu, 23 Mar 2023 10:02:48 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id p34so9040377wms.3;
        Thu, 23 Mar 2023 10:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679590967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bp/47FyfXWrv7YAHrhutabfG1x/VNQCETTStp/ikpF0=;
        b=YpzCEp3j8wt9o6oLxFHsOHKtoZ5POjoBAuNlnPA+IQIrdEE0ldt4CiFPy73P8Dp6Dj
         PpSUrpTMmsqcElS/p/MDEIqWc69Y4WLJUs+HV3lBxYSZeIW20h+Ytg2jiqTlkqrDWTME
         dky8zthLpZa/HAIBAimGTLjZ9rxAvGsMUrgTHA4p6SUH5IKgtRvGy37kn24cxen6K+3V
         AuTYI0iz3MdU/lRNsWuKW+Lbt5xarsRpK8q8lWn1fbYC7HbEdNpiR0v0sAHmnYgZTv3k
         T5jP+fviAYejXC9CiSS/bywBO0p1/It8m4XTX8x+Jp+/jWQtNvbhRE641rnktLGa8SuE
         hRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679590967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bp/47FyfXWrv7YAHrhutabfG1x/VNQCETTStp/ikpF0=;
        b=4Ekne2zE2hptEDu4yfHLShuooHYJEnRDhTon3VgqHKaQ9sDocSm7+DA4luRWJ9B9N7
         MXeP4GydKbwNSDRzwVLqcx1cBvg1xu2G+lKY0WVw60T+wz/mPVeaoBEsvQX8iFIAlRVD
         LRyTgGjbYbbPisqfyvcb7CfhKZEbseu0TtBVVNtpUSAJpZb8tkTW5DI+K6PZlJ7c2Dux
         gdxAnpOqri4iWmbswA8azCPEepYOsQV6ug+qoJBes0VWUiiTp8NTRzIIgODcVGuzIj2u
         BpiAutOrfwckQdwrPtH9f9/uRvhUuCBauMY9K+eW7dF11fDzADmMDiMpkHHDsX4kUkbX
         5BnA==
X-Gm-Message-State: AO0yUKWeZDuOp0EjVJGqdgSiX8SRkj+bYH/EKnPiLcfnmHWpl2HPEbia
        +oyCm8it8AgKq7drRP+IjzE=
X-Google-Smtp-Source: AK7set8pPNGQg+UcP0a9kYvkyJ+7YK0034Oo2O5j/vzz2t8hErZx4p3vywMm9OUoVpLHhCmZf2MGjw==
X-Received: by 2002:a05:600c:a0c:b0:3ee:90fa:aedf with SMTP id z12-20020a05600c0a0c00b003ee90faaedfmr1682671wmp.11.1679590967156;
        Thu, 23 Mar 2023 10:02:47 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id a2-20020a05600c224200b003ee63fe5203sm2395778wmm.36.2023.03.23.10.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:02:46 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 1/1] net: dsa: b53: mmap: add dsa switch ops
Date:   Thu, 23 Mar 2023 18:02:38 +0100
Message-Id: <20230323170238.210687-2-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323170238.210687-1-noltari@gmail.com>
References: <20230323170238.210687-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

B53 MMAP switches have a MDIO Mux bus controller which should be used instead
of the default phy_read/phy_write ops used in the rest of the B53 controllers.
Therefore, in order to use the proper MDIO Mux bus controller we need to
replicate the default B53 DSA switch ops removing the phy_read/phy_write
entries.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 22 +++++++++---------
 drivers/net/dsa/b53/b53_mmap.c   | 40 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_priv.h   | 11 +++++++++
 3 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 1f9b251a5452..9080506f2a9c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1096,7 +1096,7 @@ int b53_setup_devlink_resources(struct dsa_switch *ds)
 }
 EXPORT_SYMBOL(b53_setup_devlink_resources);
 
-static int b53_setup(struct dsa_switch *ds)
+int b53_setup(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
 	unsigned int port;
@@ -1134,7 +1134,7 @@ static int b53_setup(struct dsa_switch *ds)
 	return b53_setup_devlink_resources(ds);
 }
 
-static void b53_teardown(struct dsa_switch *ds)
+void b53_teardown(struct dsa_switch *ds)
 {
 	dsa_devlink_resources_unregister(ds);
 }
@@ -1253,8 +1253,8 @@ static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
 		phy_modes(interface));
 }
 
-static void b53_adjust_link(struct dsa_switch *ds, int port,
-			    struct phy_device *phydev)
+void b53_adjust_link(struct dsa_switch *ds, int port,
+		     struct phy_device *phydev)
 {
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
@@ -1356,8 +1356,8 @@ void b53_port_event(struct dsa_switch *ds, int port)
 }
 EXPORT_SYMBOL(b53_port_event);
 
-static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
-				 struct phylink_config *config)
+void b53_phylink_get_caps(struct dsa_switch *ds, int port,
+			  struct phylink_config *config)
 {
 	struct b53_device *dev = ds->priv;
 
@@ -1401,9 +1401,9 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	config->legacy_pre_march2020 = false;
 }
 
-static struct phylink_pcs *b53_phylink_mac_select_pcs(struct dsa_switch *ds,
-						      int port,
-						      phy_interface_t interface)
+struct phylink_pcs *b53_phylink_mac_select_pcs(struct dsa_switch *ds,
+					       int port,
+					       phy_interface_t interface)
 {
 	struct b53_device *dev = ds->priv;
 
@@ -2262,7 +2262,7 @@ int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 }
 EXPORT_SYMBOL(b53_set_mac_eee);
 
-static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
+int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 {
 	struct b53_device *dev = ds->priv;
 	bool enable_jumbo;
@@ -2277,7 +2277,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	return b53_set_jumbo(dev, enable_jumbo, allow_10_100);
 }
 
-static int b53_get_max_mtu(struct dsa_switch *ds, int port)
+int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
 	return JMS_MAX_SIZE;
 }
diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 7bb774368f64..45481db7a891 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/b53.h>
+#include <net/dsa.h>
 
 #include "b53_priv.h"
 
@@ -29,6 +30,44 @@ struct b53_mmap_priv {
 	void __iomem *regs;
 };
 
+static const struct dsa_switch_ops b53_mmap_switch_ops = {
+	.get_tag_protocol	= b53_get_tag_protocol,
+	.setup			= b53_setup,
+	.teardown		= b53_teardown,
+	.get_strings		= b53_get_strings,
+	.get_ethtool_stats	= b53_get_ethtool_stats,
+	.get_sset_count		= b53_get_sset_count,
+	.get_ethtool_phy_stats	= b53_get_ethtool_phy_stats,
+	.adjust_link		= b53_adjust_link,
+	.phylink_get_caps	= b53_phylink_get_caps,
+	.phylink_mac_select_pcs	= b53_phylink_mac_select_pcs,
+	.phylink_mac_config	= b53_phylink_mac_config,
+	.phylink_mac_link_down	= b53_phylink_mac_link_down,
+	.phylink_mac_link_up	= b53_phylink_mac_link_up,
+	.port_enable		= b53_enable_port,
+	.port_disable		= b53_disable_port,
+	.get_mac_eee		= b53_get_mac_eee,
+	.set_mac_eee		= b53_set_mac_eee,
+	.port_bridge_join	= b53_br_join,
+	.port_bridge_leave	= b53_br_leave,
+	.port_pre_bridge_flags	= b53_br_flags_pre,
+	.port_bridge_flags	= b53_br_flags,
+	.port_stp_state_set	= b53_br_set_stp_state,
+	.port_fast_age		= b53_br_fast_age,
+	.port_vlan_filtering	= b53_vlan_filtering,
+	.port_vlan_add		= b53_vlan_add,
+	.port_vlan_del		= b53_vlan_del,
+	.port_fdb_dump		= b53_fdb_dump,
+	.port_fdb_add		= b53_fdb_add,
+	.port_fdb_del		= b53_fdb_del,
+	.port_mirror_add	= b53_mirror_add,
+	.port_mirror_del	= b53_mirror_del,
+	.port_mdb_add		= b53_mdb_add,
+	.port_mdb_del		= b53_mdb_del,
+	.port_max_mtu		= b53_get_max_mtu,
+	.port_change_mtu	= b53_change_mtu,
+};
+
 static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8 *val)
 {
 	struct b53_mmap_priv *priv = dev->priv;
@@ -302,6 +341,7 @@ static int b53_mmap_probe(struct platform_device *pdev)
 	if (!dev)
 		return -ENOMEM;
 
+	dev->ds->ops = &b53_mmap_switch_ops;
 	dev->pdata = pdata;
 
 	platform_set_drvdata(pdev, dev);
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index a689a6950189..cd759b177c94 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -348,7 +348,16 @@ int b53_br_flags(struct dsa_switch *ds, int port,
 		 struct switchdev_brport_flags flags,
 		 struct netlink_ext_ack *extack);
 int b53_setup_devlink_resources(struct dsa_switch *ds);
+int b53_setup(struct dsa_switch *ds);
+void b53_teardown(struct dsa_switch *ds);
+void b53_adjust_link(struct dsa_switch *ds, int port,
+		     struct phy_device *phydev);
 void b53_port_event(struct dsa_switch *ds, int port);
+void b53_phylink_get_caps(struct dsa_switch *ds, int port,
+			  struct phylink_config *config);
+struct phylink_pcs *b53_phylink_mac_select_pcs(struct dsa_switch *ds,
+					       int port,
+					       phy_interface_t interface);
 void b53_phylink_mac_config(struct dsa_switch *ds, int port,
 			    unsigned int mode,
 			    const struct phylink_link_state *state);
@@ -396,5 +405,7 @@ void b53_eee_enable_set(struct dsa_switch *ds, int port, bool enable);
 int b53_eee_init(struct dsa_switch *ds, int port, struct phy_device *phy);
 int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e);
 int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e);
+int b53_change_mtu(struct dsa_switch *ds, int port, int mtu);
+int b53_get_max_mtu(struct dsa_switch *ds, int port);
 
 #endif
-- 
2.30.2

