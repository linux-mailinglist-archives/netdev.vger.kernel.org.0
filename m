Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617C93410CA
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhCRXSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhCRXSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5BCC06174A;
        Thu, 18 Mar 2021 16:18:46 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bx7so8664781edb.12;
        Thu, 18 Mar 2021 16:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2nEuQXQSZPa2O9BuHPTkTA1vCCa7u77GxjLezyKfjVs=;
        b=Dsxq2VSAhK0cW1zCQjsTP9vk/z4kkq81BonBR9SXXv4KOPyWkZaAM/BzAKg8rqCorD
         dchL3i0oVNbAjqD9F1BIW/re2AVr0lRbyFZDgsLNPBD2VQjpGu0bea/GejUdSzRwofBK
         A98gZfKj7tZRZeb+eaYX0g8OeSbSwWpMglGiR81k4sM2wiMyWrzAnh6sW170fQTBNe0m
         5ckqRljt4bl0sLJlFXx+X+sNa6aOfuFEEFIAP0x+APv304q4qN/2MW2PwklMYV/X+/eS
         aDCEEeYuUhFnSSUYfkEVOpbiuzRKCE48sDwd2ieV6dnClysq+UyKv1yUUFPd5Iw3Mkpe
         4gFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2nEuQXQSZPa2O9BuHPTkTA1vCCa7u77GxjLezyKfjVs=;
        b=H+8xgI99FNPSSK27XOTliS6ySbafdP0QSIP7+MuCgQZ/AcuBaO9obdl0+YK6B5m57S
         OAnJmrTAbPKvPushRzT4h6u4/1DSDRwLQca1Q8BmXvbwnjnK+F497475TfpUE0UaPacu
         kcr5PDHY4OyRgLvtn/oUUtex4G1E0RRiitVRUMOjhhpbDfhKcN/KYhJ/VFZxS93ef4Jt
         711hqfZVcGk/DoNSXEOJYbHm8sdchrW71jZRtmWWCIvm+TWt+7vYH5KeEyc1jBS31w6z
         +TqjaRvAevvsVjd8v1TQLncdfPJA3hkef4EhzUaFbUVs5q90J8ClnPSOA4xSgKBZ1usV
         Dhfw==
X-Gm-Message-State: AOAM533AN5ss+3tH8H2wD1I21gqkBJ7ht7m5gxRpalR/+Fpe1J62WvId
        CAq0ruHMBrHwn+Yt53jrC4kJvvvzVqM=
X-Google-Smtp-Source: ABdhPJzEKtHww9E0Izfo3KlI6p9voYYGv5V4MSmGsJ/URgsInX2SKDO58BsHQmggv6IpKvzw+TxLdA==
X-Received: by 2002:a05:6402:cb8:: with SMTP id cn24mr6591957edb.105.1616109524890;
        Thu, 18 Mar 2021 16:18:44 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 01/16] net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge
Date:   Fri, 19 Mar 2021 01:18:14 +0200
Message-Id: <20210318231829.3892920-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
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

