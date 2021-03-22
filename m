Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46289345352
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCVXwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhCVXwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:52:11 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6437DC061574;
        Mon, 22 Mar 2021 16:52:10 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u21so6148014ejo.13;
        Mon, 22 Mar 2021 16:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/92wVBAP5j4BB+u+puYhzxAdKb4svuqVtkB4xOs7jA=;
        b=TN8RWZO8zeXHI7/VmJtYlbV9gi2Qw9YB8otq/GrgWsCCGMIrSPOhS4IAmr+LDXqcFB
         /RV5AU5vSZaFz762Yj2pwZKQ2g7n6uzhbzLssdGB0Tv9f194CR4/e2fxli/ekKJYnosL
         iv5jstSxKBI2zefLyXgMK0uymv28iYmVhcKaZ3XibVZQ0bIrTXOAKazcyTIH7DAQdqI1
         QyICvPcaobpZds8WZi1M9pEFHlwx1T5ioPX0/I0NAuvhD2nRdOKJlQxjsAsPEGnd6XDB
         ApTQXxI6KMFsiVUYsPUa9DzbukYiCqpqWB4fybLvaA/cw+K/ycK6W/3bYpWw26yX9Laf
         2XpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/92wVBAP5j4BB+u+puYhzxAdKb4svuqVtkB4xOs7jA=;
        b=aTm4B1A6Z7D75fgO/ALZVyPeKKoUFKxubnC+AxvLPyYV9Q8/JBsKWL4LU5If+2W1X4
         tDPjV8u30WSVzp7PDBgZHf+hXGGgDS6PVnawtPF2UM1BJzIr+MxSvRzwu9Z5daCMlwUK
         QvDjTSARAC3Q7Wa9p/kFAs7vI7r/H96cdGhnilsigsJWPKbxen/jdUyvQgF16Vr9qxC9
         lwoRZl+RveVQpZ+SON/cO3Guss4ZpDN/VLfbwgpuqoGNTOwsO7NFMzORcrxLRYxosOZN
         9MDbNPtfAvS0T9RNZIdAG5wqaPoL1oxSzUly5h/b2AKBYL96QPTCDla8OOwSPGjb51Ph
         3meA==
X-Gm-Message-State: AOAM530vu2luSxMxE+66KXwLbb+oPlJdKTqHiYGDvWQ0nMXixNeQtg+2
        4lx2L2Je8bfICKQJQhqVdMM=
X-Google-Smtp-Source: ABdhPJzOBT60AjgajvsZsximQS+6UzbcLDK+RWlOrorpC2WPfXahYTh6YvZj/y6+hiuOaGmm/LDbLg==
X-Received: by 2002:a17:906:18a1:: with SMTP id c1mr2108709ejf.62.1616457129211;
        Mon, 22 Mar 2021 16:52:09 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm12436933edv.61.2021.03.22.16.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:52:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 06/11] net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge
Date:   Tue, 23 Mar 2021 01:51:47 +0200
Message-Id: <20210322235152.268695-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322235152.268695-1-olteanv@gmail.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA can properly detect and offload this sequence of operations:

ip link add br0 type bridge
ip link add bond0 type bond
ip link set swp0 master bond0
ip link set bond0 master br0

But not this one:

ip link add br0 type bridge
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0

Actually the second one is more complicated, due to the elapsed time
between the enslavement of bond0 and the offloading of it via swp0, a
lot of things could have happened to the bond0 bridge port in terms of
switchdev objects (host MDBs, VLANs, altered STP state etc). So this is
a bit of a can of worms, and making sure that the DSA port's state is in
sync with this already existing bridge port is handled in the next
patches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/port.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index c9c6d7ab3f47..d39262a9fe0e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -249,17 +249,31 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 		.lag = lag,
 		.info = uinfo,
 	};
+	struct net_device *bridge_dev;
 	int err;
 
 	dsa_lag_map(dp->ds->dst, lag);
 	dp->lag_dev = lag;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
-	if (err) {
-		dp->lag_dev = NULL;
-		dsa_lag_unmap(dp->ds->dst, lag);
-	}
+	if (err)
+		goto err_lag_join;
 
+	bridge_dev = netdev_master_upper_dev_get(lag);
+	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
+		return 0;
+
+	err = dsa_port_bridge_join(dp, bridge_dev);
+	if (err)
+		goto err_bridge_join;
+
+	return 0;
+
+err_bridge_join:
+	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
+err_lag_join:
+	dp->lag_dev = NULL;
+	dsa_lag_unmap(dp->ds->dst, lag);
 	return err;
 }
 
-- 
2.25.1

