Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9A247D28
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 06:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgHREE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 00:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgHREE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 00:04:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EBAC061389;
        Mon, 17 Aug 2020 21:04:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v15so9134918pgh.6;
        Mon, 17 Aug 2020 21:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GzZyrXpTY6F22/dmqRS9I8tt5+S2Aky6apouSMQ9NVw=;
        b=aSnr6OU+Rcr5yj8twqOw5CZZOy9CgaFVgDjpMQiGxUTa4ZL7X1cwWlMXbUOjyhdr4l
         eVKLDeF6vvGIQuY8I7ILh0qiejd09jiDlM3ZB9dYMmaYuQanxyJgaYXe7d5PjskpFgrW
         DDI2pytXA5zwS8b89EGEzt3rIZXOl0ivwdtM14gLIEfJD77pFCuCyRFl7uiyIPvVZnTF
         3EW367fHs/cs62n0b4OKxgyS+eW5ezO+O7ADcSse1cU55DAZUmCTtd4eXlCmTDEk/OTm
         /nwxlYkhPzHLXKF7sD2OxETQBYnqyOIyb3rGhbEKPCZJEJrcY86ozTdyEqV0821dUh4Y
         AIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GzZyrXpTY6F22/dmqRS9I8tt5+S2Aky6apouSMQ9NVw=;
        b=oGd3VZwpCe28cF8xoW1VwX4+OoL1p/59ATSIlr991YngDAR2vMSR6mHD/ti6IrfDA9
         AhCMex+l/AHEisHoMUA6amLHU4F6QYc8aagEiGOARmM9+2ZmzJmxNG8Bgkk+aZSAIg4M
         Db7SghBFZYCKlSRh8lg4qPJ54o1tTNUQRavkudxYI954tewIBc4PxNy/wx18c0ixGMDL
         lX/vZfITe0NCzq5ErOUt2YOTTv+YKM5XWVQCFEWZPF5tnRAYbhidZlABqkpmJjTMfJOY
         f5SnOYjPmYwWCaKBA35fuRJZ8poTMvTVG4RJYvxYYg187dybWsb0xjhzT2S/qWrP7nl0
         guUw==
X-Gm-Message-State: AOAM5330jJPucAFNZNRRaOXqOuUz8jMq0ltUw5btunGG3ByTohLnuhhb
        mgzrKMMnQ2lX1C3HVURtM9xQxnNNRHw=
X-Google-Smtp-Source: ABdhPJydBIRGIt26gN3g3+zaU0kRrvec1KgF1/ruYxo/RTU9GmIyVdQOBmUs6tvE84ORhq894pk3FA==
X-Received: by 2002:a62:8081:: with SMTP id j123mr14289522pfd.80.1597723466952;
        Mon, 17 Aug 2020 21:04:26 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k21sm19595450pgl.0.2020.08.17.21.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 21:04:25 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: loop: Return VLAN table size through devlink
Date:   Mon, 17 Aug 2020 21:03:54 -0700
Message-Id: <20200818040354.44736-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We return the VLAN table size through devlink as a simple parameter, we
do not support altering it at runtime:

devlink resource show mdio_bus/fixed-0:1f
mdio_bus/fixed-0:1f:
  name VTU size 4096 occ 4096 unit entry dpipe_tables none

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 47 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index eb600b3dbf26..474d0747d4ed 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -28,6 +28,45 @@ static struct dsa_loop_mib_entry dsa_loop_mibs[] = {
 
 static struct phy_device *phydevs[PHY_MAX_ADDR];
 
+enum dsa_loop_devlink_resource_id {
+	DSA_LOOP_DEVLINK_PARAM_ID_VTU,
+};
+
+static u64 dsa_loop_devlink_vtu_get(void *priv)
+{
+	struct dsa_loop_priv *ps = priv;
+
+	return ARRAY_SIZE(ps->vlans);
+}
+
+static int dsa_loop_setup_devlink_resources(struct dsa_switch *ds)
+{
+	struct devlink_resource_size_params size_params;
+	struct dsa_loop_priv *ps = ds->priv;
+	int err;
+
+	devlink_resource_size_params_init(&size_params, ARRAY_SIZE(ps->vlans),
+					  ARRAY_SIZE(ps->vlans),
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	err = dsa_devlink_resource_register(ds, "VTU", ARRAY_SIZE(ps->vlans),
+					    DSA_LOOP_DEVLINK_PARAM_ID_VTU,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_params);
+	if (err)
+		goto out;
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      DSA_LOOP_DEVLINK_PARAM_ID_VTU,
+					      dsa_loop_devlink_vtu_get, ps);
+
+	return 0;
+
+out:
+	dsa_devlink_resources_unregister(ds);
+	return err;
+}
+
 static enum dsa_tag_protocol dsa_loop_get_protocol(struct dsa_switch *ds,
 						   int port,
 						   enum dsa_tag_protocol mp)
@@ -48,7 +87,12 @@ static int dsa_loop_setup(struct dsa_switch *ds)
 
 	dev_dbg(ds->dev, "%s\n", __func__);
 
-	return 0;
+	return dsa_loop_setup_devlink_resources(ds);
+}
+
+static void dsa_loop_teardown(struct dsa_switch *ds)
+{
+	dsa_devlink_resources_unregister(ds);
 }
 
 static int dsa_loop_get_sset_count(struct dsa_switch *ds, int port, int sset)
@@ -243,6 +287,7 @@ static int dsa_loop_port_max_mtu(struct dsa_switch *ds, int port)
 static const struct dsa_switch_ops dsa_loop_driver = {
 	.get_tag_protocol	= dsa_loop_get_protocol,
 	.setup			= dsa_loop_setup,
+	.teardown		= dsa_loop_teardown,
 	.get_strings		= dsa_loop_get_strings,
 	.get_ethtool_stats	= dsa_loop_get_ethtool_stats,
 	.get_sset_count		= dsa_loop_get_sset_count,
-- 
2.25.1

