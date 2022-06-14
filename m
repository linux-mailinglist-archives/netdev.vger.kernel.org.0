Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA43A54AD4E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 11:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiFNJZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 05:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiFNJZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 05:25:36 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86E3BB
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 02:25:35 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id l18so9006615lje.13
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 02:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=NUnNqs5BWBRw5HkDi4UFw7CWZZjMxEc5U/JahmS/1Yk=;
        b=idOdSvvdb9OD8raYxuUWxg/rCkCTKPMeJA9MK6YWw8WIO0vDA+MzZ3/R58UiWt7iTn
         tst7nOw0oOZcrWll2QRu7k8Yh0Kqo9Hno4PWfDIiwAsx92vDLtqfJrnTNFX7hco5w0m6
         43KCaW/CWCg81gqlZsbUBTDve4hk7ikm80BYZVwxtoevqg3vE61G+OUnk5svxr/TFkQs
         jDyczD4s35xDv/2Y1ZUgzMvtJDSZlApBj5Ent7eCYYyp+aoGo2NYXbTb4oxOJRKoplVW
         qouaLojlfLzfSX1l4c3ynLVhPFupikTT0Cazej8FKisDIyWgvi3jNnFSXr/Szp+4xpDQ
         De4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=NUnNqs5BWBRw5HkDi4UFw7CWZZjMxEc5U/JahmS/1Yk=;
        b=Eca3W40LiJ9Bwf/ZxC+xWIHGCeJCyBFKwluqLJGNtY0KU1svHsKnYHL/VEdLWCilMc
         0UcZXYLZP7LwM0q2E8Hth4IOcNP/MeO/BpRIEezO9z+kSDnGFJDV6q2Nxk0yJp1gG608
         DffgAymOCaSseyzqZXWMjkxFvOxJknwm6hUKkdLKZRRng7+Zq6vviuJgDEt8gX9n5Jt2
         4TiziTj4Zfk1TZBlXM/qy/nnD5s2asKRvrWSw4DlGtXcEHeQKQJb+8Z+3WN4acaoOwvt
         l+dHbME1ohbTzT46Q98kyjVJ5m3+eh+3TUgZ4GnEc5CuwKyCIMkkDftTLvIRPWQMmFPh
         PBgA==
X-Gm-Message-State: AJIora8CmzqcfIhAZCkzygUP5h9EjDv8n5pJImoVx9g2/eImNxBKOJw5
        4ZWA8CnrG690pAm86TgWfhU=
X-Google-Smtp-Source: AGRyM1slWfexxGNwu/aKFSOS2SSHrca1Ma8N98bR28HlHPzVmZVyt8VCOEWP/WFsEGVjFCVQvuQFCg==
X-Received: by 2002:a2e:a552:0:b0:255:a378:72db with SMTP id e18-20020a2ea552000000b00255a37872dbmr1963997ljn.504.1655198734036;
        Tue, 14 Jun 2022 02:25:34 -0700 (PDT)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id a25-20020a05651c031900b002554dde32bfsm1298799ljp.47.2022.06.14.02.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 02:25:33 -0700 (PDT)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: sparx5: Allow mdb entries to both CPU and ports
Date:   Tue, 14 Jun 2022 11:25:32 +0200
Message-Id: <20220614092532.3273791-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow mdb entries to be forwarded to CPU and be switched at the same
time. Only remove entry when no port and the CPU isn't part of the group
anymore.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 .../microchip/sparx5/sparx5_switchdev.c       | 55 ++++++++++++-------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 3429660cd2e5..40ef9fad3a77 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -394,12 +394,10 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 	struct sparx5 *spx5 = port->sparx5;
 	u16 pgid_idx, vid;
 	u32 mact_entry;
+	bool is_host;
 	int res, err;
 
-	if (netif_is_bridge_master(v->obj.orig_dev)) {
-		sparx5_mact_learn(spx5, PGID_CPU, v->addr, v->vid);
-		return 0;
-	}
+	is_host = netif_is_bridge_master(v->obj.orig_dev);
 
 	/* When VLAN unaware the vlan value is not parsed and we receive vid 0.
 	 * Fall back to bridge vid 1.
@@ -416,17 +414,33 @@ static int sparx5_handle_port_mdb_add(struct net_device *dev,
 
 		/* MC_IDX starts after the port masks in the PGID table */
 		pgid_idx += SPX5_PORTS;
-		sparx5_pgid_update_mask(port, pgid_idx, true);
+
+		if (is_host)
+			spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
+				 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
+				 ANA_AC_PGID_MISC_CFG(pgid_idx));
+		else
+			sparx5_pgid_update_mask(port, pgid_idx, true);
+
 	} else {
 		err = sparx5_pgid_alloc_mcast(spx5, &pgid_idx);
 		if (err) {
 			netdev_warn(dev, "multicast pgid table full\n");
 			return err;
 		}
-		sparx5_pgid_update_mask(port, pgid_idx, true);
+
+		if (is_host)
+			spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(1),
+				 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
+				 ANA_AC_PGID_MISC_CFG(pgid_idx));
+		else
+			sparx5_pgid_update_mask(port, pgid_idx, true);
+
 		err = sparx5_mact_learn(spx5, pgid_idx, v->addr, vid);
+
 		if (err) {
 			netdev_warn(dev, "could not learn mac address %pM\n", v->addr);
+			sparx5_pgid_free(spx5, pgid_idx);
 			sparx5_pgid_update_mask(port, pgid_idx, false);
 			return err;
 		}
@@ -463,13 +477,8 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *spx5 = port->sparx5;
 	u16 pgid_idx, vid;
-	u32 mact_entry, res, pgid_entry[3];
-	int err;
-
-	if (netif_is_bridge_master(v->obj.orig_dev)) {
-		sparx5_mact_forget(spx5, v->addr, v->vid);
-		return 0;
-	}
+	u32 mact_entry, res, pgid_entry[3], misc_cfg;
+	bool host_ena;
 
 	if (!br_vlan_enabled(spx5->hw_bridge_dev))
 		vid = 1;
@@ -483,15 +492,21 @@ static int sparx5_handle_port_mdb_del(struct net_device *dev,
 
 		/* MC_IDX starts after the port masks in the PGID table */
 		pgid_idx += SPX5_PORTS;
-		sparx5_pgid_update_mask(port, pgid_idx, false);
+
+		if (netif_is_bridge_master(v->obj.orig_dev))
+			spx5_rmw(ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_SET(0),
+				 ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA, spx5,
+				 ANA_AC_PGID_MISC_CFG(pgid_idx));
+		else
+			sparx5_pgid_update_mask(port, pgid_idx, false);
+
+		misc_cfg = spx5_rd(spx5, ANA_AC_PGID_MISC_CFG(pgid_idx));
+		host_ena = ANA_AC_PGID_MISC_CFG_PGID_CPU_COPY_ENA_GET(misc_cfg);
 
 		sparx5_pgid_read_mask(spx5, pgid_idx, pgid_entry);
-		if (bitmap_empty((unsigned long *)pgid_entry, SPX5_PORTS)) {
-			/* No ports are in MC group. Remove entry */
-			err = sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
-			if (err)
-				return err;
-		}
+		if (bitmap_empty((unsigned long *)pgid_entry, SPX5_PORTS) && !host_ena)
+			/* No ports or CPU are in MC group. Remove entry */
+			return sparx5_mdb_del_entry(dev, spx5, v->addr, vid, pgid_idx);
 	}
 
 	return 0;
-- 
2.30.2

