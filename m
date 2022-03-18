Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071304DD9FE
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 13:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiCRMyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 08:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiCRMyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 08:54:53 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CAD3191F
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:53:34 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id r22so11190467ljd.4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=b76rCDnXLzMy8Mz6/t1JOjyUy2GNIxCMmQvWAHS6ovs=;
        b=KyZiHS0dM5VeD0uDEf9L9nHebCp1uo2pRVUJ5gWY/MTKX9DyaduLwZoBWyZVcoFcgh
         haO7ruifO62XT0o/OZWcPt+8ti1nwdrdqdxXOXrvA3YuM6f1G8ETpAdJy4xyEhoYIfTD
         +pDbSpd7f6ZOebM4D/VrUrdzaskJmoNux5b6W2BkdPKfCjLMqWMFKTNMvWuPF2esxT9D
         UOvb1sEhtvX7im3uFavXcsvMy1XlKhIasU3CeeBblYQF9ePk0iybH45+wYcxQ+Oj3yiv
         hMIm9jx0aaM3NI0QJUIdprfhHOYonaHzqO/pXtVnfjEzId4P1kizuuMT2yLLwTn4Aj5h
         aONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=b76rCDnXLzMy8Mz6/t1JOjyUy2GNIxCMmQvWAHS6ovs=;
        b=vxxPJ4HdhUnxWcvyg6SGMTVqdQ1UjNNQ5JoijCzBwe92w9Q67ptCfueqPvqQqb/pUR
         PPmCb4CynvjQ8qGlFEuva71ahyzhq3DA8PIdnu4Ubdn3dn6o4AMaZbDUOVtUyJcb5MLJ
         1tc29LKNgT4fBwxsBmABSI5g21rbvVJASSt6db3OuyBVv+QDSjTE6VSCBaMw5bm904Dx
         qZrzHX7Nu0f9FVTEAC5+O+fFWsEgJkPAF4V7zGLvg5TU8XEZlV3oY5/6He0wxrfon+92
         +9uuFbguXzG3Z9ZxhhV0gXKXwIGnbTB1KizyXig/jY8d/t+KU3DhWyKAtzZGB5nkifS/
         cLUw==
X-Gm-Message-State: AOAM532lMRgK5f9XjwTBDc2bv6G4l+hOaEP3ehDePBr9gWyL5wCKUjxf
        eNXTStPbTMqiJdC0at1UjM4=
X-Google-Smtp-Source: ABdhPJxHpsh5Ml2iEyRpgTvgqp38LMQSsMVNWsdaGJCvBMZyz69J/DemlkStb0boXc9MWcJ3lOLrRA==
X-Received: by 2002:a2e:80ce:0:b0:249:5e85:2965 with SMTP id r14-20020a2e80ce000000b002495e852965mr5647043ljg.129.1647608012959;
        Fri, 18 Mar 2022 05:53:32 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q27-20020a05651232bb00b00448b43e2bc7sm837662lfe.64.2022.03.18.05.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:53:32 -0700 (PDT)
Date:   Fri, 18 Mar 2022 13:53:31 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sparx5: Use vid 1 when bridge default vid 0 to
 avoid collision
Message-ID: <20220318125331.53mdxhtrrddsbvws@wse-c0155>
Organization: Westermo Network Technologies AB
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standalone ports use vid 0. Let the bridge use vid 1 when
"vlan_default_pvid 0" is set to avoid collisions. Since no
VLAN is created when default pvid is 0 this is set
at "PORT_ATTR_SET" and handled in the Switchdev fdb handler.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../microchip/sparx5/sparx5_switchdev.c       | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 2d5de1c06fab..8b69c72ff807 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -102,6 +102,11 @@ static int sparx5_port_attr_set(struct net_device *dev, const void *ctx,
 		sparx5_port_attr_ageing_set(port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		/* Used PVID 1 when default_pvid is 0, to avoid
+		 * collision with non-bridged ports.
+		 */
+		if (port->pvid == 0)
+			port->pvid = 1;
 		port->vlan_aware = attr->u.vlan_filtering;
 		sparx5_vlan_port_apply(port->sparx5, port);
 		break;
@@ -137,6 +142,9 @@ static int sparx5_port_bridge_join(struct sparx5_port *port,
 	if (err)
 		goto err_switchdev_offload;
 
+	/* Remove standalone port entry */
+	sparx5_mact_forget(sparx5, ndev->dev_addr, 0);
+
 	/* Port enters in bridge mode therefor don't need to copy to CPU
 	 * frames for multicast in case the bridge is not requesting them
 	 */
@@ -165,6 +173,9 @@ static void sparx5_port_bridge_leave(struct sparx5_port *port,
 	port->pvid = NULL_VID;
 	port->vid = NULL_VID;
 
+	/* Forward frames to CPU */
+	sparx5_mact_learn(sparx5, PGID_CPU, port->ndev->dev_addr, 0);
+
 	/* Port enters in host more therefore restore mc list */
 	__dev_mc_sync(port->ndev, sparx5_mc_sync, sparx5_mc_unsync);
 }
@@ -249,6 +260,7 @@ static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
 	struct sparx5_port *port;
 	struct sparx5 *sparx5;
 	bool host_addr;
+	u16 vid;
 
 	rtnl_lock();
 	if (!sparx5_netdevice_check(dev)) {
@@ -262,17 +274,25 @@ static void sparx5_switchdev_bridge_fdb_event_work(struct work_struct *work)
 
 	fdb_info = &switchdev_work->fdb_info;
 
+	/* Used PVID 1 when default_pvid is 0, to avoid
+	 * collision with non-bridged ports.
+	 */
+	if (fdb_info->vid == 0)
+		vid = 1;
+	else
+		vid = fdb_info->vid;
+
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (host_addr)
 			sparx5_add_mact_entry(sparx5, dev, PGID_CPU,
-					      fdb_info->addr, fdb_info->vid);
+					      fdb_info->addr, vid);
 		else
 			sparx5_add_mact_entry(sparx5, port->ndev, port->portno,
-					      fdb_info->addr, fdb_info->vid);
+					      fdb_info->addr, vid);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		sparx5_del_mact_entry(sparx5, fdb_info->addr, fdb_info->vid);
+		sparx5_del_mact_entry(sparx5, fdb_info->addr, vid);
 		break;
 	}
 
-- 
2.30.2

