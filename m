Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92EA342FEE
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 23:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhCTWf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 18:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhCTWfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:35:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08173C061574;
        Sat, 20 Mar 2021 15:35:22 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h13so14959554eds.5;
        Sat, 20 Mar 2021 15:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rw+kglmFcQnryQjzxMm2RqClK1crzr9d9kBr/GNKjX4=;
        b=neLfK1xDeWrLSdFFdduHV9nQShTeuPxiwxACh93SZIIqdSYfnc6JSNXXhLQGd8Tron
         R5m4p4OYU+yKoiv+Qd6jWaLHoSVwJUzYjUfS2gYRvCLA8c/LHkD1s23eGbpU3UYrpPYb
         HmLMdc3e7ZBkui38R8OY2eCoK4FXbtzOlrYlMwx7a5PvXeUd39kc5fPvX6/wE3+qldHd
         lNBusAVAZAVjX4wApkjEqQZ7oVJDyW7LdcWKIRA3przQ0VIHuB/GTK3tUyHA8YkevKUn
         pa+px6wr95gSEmpUsiWMxvk6/FUihzRY5aKWSx9c7k6GhP08ULQHqnhKFxRfpvBXScgK
         TjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rw+kglmFcQnryQjzxMm2RqClK1crzr9d9kBr/GNKjX4=;
        b=RfIS5RJA1i4MglIEpjxbCpr9SvCAPADowng89mwxFlKG9KGmk618jBz9ecxid8tXEZ
         NCPY7x17yrvsxS+ELPsdi5j4erbNmIchheG9W/n9d751J74S5k/1ldUs11P1GRTd+hmP
         QbQlbXDBaCa//MISMmhB675G/tSJSylCeIHYcJSHT+OUYiWR+7vhJqv6KDRYEjeve4zP
         tY5fdEbC7gbwJs0cReDBMwRjnGd5GLbMRXxo//QqT35t6QEXe96KqEYvTMesiDYlHtXA
         h6X/VYXG0EFKx9w2yGgAFYyDXc5jHodYJMHJ9NE9E6YOcREFtADwYv7p+1ao5yk+iGag
         /Y0A==
X-Gm-Message-State: AOAM5313ioZhkMZxnj8T6N3zpvzhustcXfd8oLlCD5lQMAlnZX6LHQE7
        xfxj3KgybujPoS3SphZ9vKo=
X-Google-Smtp-Source: ABdhPJxJ0FRWJboeCx54HGNCYeYOxE65AzmJ3ANIpTr4IgXa51k+WSaQaVHnnzUGvsWUFro03YttPA==
X-Received: by 2002:a05:6402:27d3:: with SMTP id c19mr17773003ede.129.1616279720799;
        Sat, 20 Mar 2021 15:35:20 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n2sm6090850ejl.1.2021.03.20.15.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:35:20 -0700 (PDT)
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
Subject: [PATCH v3 net-next 01/12] net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge
Date:   Sun, 21 Mar 2021 00:34:37 +0200
Message-Id: <20210320223448.2452869-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
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
---
Changes in v3:
None.

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

