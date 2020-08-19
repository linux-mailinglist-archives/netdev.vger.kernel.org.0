Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4050E249424
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHSEcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgHSEc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:32:28 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DC1C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:32:28 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d22so11037118pfn.5
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 21:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8tB8VRE+vOzIcRHL3ieI3BC5TtkmDCzIxoMsJ/Kt1Po=;
        b=GXjpn1dJF/u6IBYXu7EH+96Fpa3QG5NnE8e8sHLHl5YHM6okCAKpbjSOKDLd2b/8r4
         3vvjEZQ/QRAuvcoNRWX5L/wBkS+PPFzePsx/3qpQUhaP3LmtSNKj2Xq5pWp83kHIbTWH
         CfwCYXCCny3GLoV2pd2w6J5997STysQRIKKT0rDcakUyQwwTYiQFeHcuDeyWX4NCGWX1
         6IX3Znu6B6aMq/J9sn9NhBuhBztSFfADz6ezrDX8IlQ5+Ix2uzUGzor6o7YvsJQ70AlH
         EsScjR5NAoI0p72AixXn9IH92X/6UbIH355QjeV70QJNuhbzRXHmyu0aniOFjp9qbsMK
         daiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8tB8VRE+vOzIcRHL3ieI3BC5TtkmDCzIxoMsJ/Kt1Po=;
        b=DA8sPh9vqrmxuzrKN25pXy6Fcq9D+bVajxUJesRMaLHWQYUwnDV1/zct79SAO+q8/w
         pLm+90q66PVHwLq0uCLMx6+O9NW6OHVdYCLoKfUrFx4+N9dMF6RX5/gPS9R1jDR6hb70
         DWk2fIJNRVCaKbzQHTT8nSj9FfFjgtgC3BbuqCUJwNwjddTsmOGZtqTgKl8jAoqXEv3X
         hAvV8T7Ie+F9AXLo6jipYduvccIVLqtzIIBnEBQDI0+JTdtiMPf9/O+I2WEeoxhBgJ2D
         f9Q8qf3je9EBytRtCx6T/b2BfHH5gT0NpadXaEF30AZP4+t/q8dztHZGrgwfIgWCXNW9
         mX/A==
X-Gm-Message-State: AOAM532WMEDHzhaMgpRhUGtiIFMlVbXZBqpy3F1hvFSvSkinjGx1LDL9
        0ymdJZW9UyonYN4aQti5mbdVj7ev0zk=
X-Google-Smtp-Source: ABdhPJzLINyMUdGsu2B4ZiUhLa6KgiJqFU/4rWysnmlga8oEzkje0pXMG5bqVN5Aa02ph8Ow9Gcmyg==
X-Received: by 2002:a62:64c6:: with SMTP id y189mr17381621pfb.147.1597811547149;
        Tue, 18 Aug 2020 21:32:27 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y65sm25942468pfb.155.2020.08.18.21.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 21:32:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 2/2] net: dsa: loop: Return VLAN table size through devlink
Date:   Tue, 18 Aug 2020 21:32:18 -0700
Message-Id: <20200819043218.19285-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819043218.19285-1-f.fainelli@gmail.com>
References: <20200819043218.19285-1-f.fainelli@gmail.com>
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
  name VTU size 4096 occ 0 unit entry dpipe_tables none

and after configure a bridge with VLAN filtering:

devlink resource show mdio_bus/fixed-0:1f
mdio_bus/fixed-0:1f:
  name VTU size 4096 occ 1 unit entry dpipe_tables none

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 55 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index e6fc4fec9cfc..b588614d1e5e 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -28,6 +28,53 @@ static struct dsa_loop_mib_entry dsa_loop_mibs[] = {
 
 static struct phy_device *phydevs[PHY_MAX_ADDR];
 
+enum dsa_loop_devlink_resource_id {
+	DSA_LOOP_DEVLINK_PARAM_ID_VTU,
+};
+
+static u64 dsa_loop_devlink_vtu_get(void *priv)
+{
+	struct dsa_loop_priv *ps = priv;
+	unsigned int i, count = 0;
+	struct dsa_loop_vlan *vl;
+
+	for (i = 0; i < ARRAY_SIZE(ps->vlans); i++) {
+		vl = &ps->vlans[i];
+		if (vl->members)
+			count++;
+	}
+
+	return count;
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
@@ -48,7 +95,12 @@ static int dsa_loop_setup(struct dsa_switch *ds)
 
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
@@ -243,6 +295,7 @@ static int dsa_loop_port_max_mtu(struct dsa_switch *ds, int port)
 static const struct dsa_switch_ops dsa_loop_driver = {
 	.get_tag_protocol	= dsa_loop_get_protocol,
 	.setup			= dsa_loop_setup,
+	.teardown		= dsa_loop_teardown,
 	.get_strings		= dsa_loop_get_strings,
 	.get_ethtool_stats	= dsa_loop_get_ethtool_stats,
 	.get_sset_count		= dsa_loop_get_sset_count,
-- 
2.25.1

