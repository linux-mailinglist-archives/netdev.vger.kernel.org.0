Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F232330BABB
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhBBJQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:16:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39206 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhBBJNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:13:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11299kUr150203;
        Tue, 2 Feb 2021 09:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Dy3bLfgBUouag+csKtbcGCPr7spJ7xV16VYIphqLsd0=;
 b=rFhw6HQsyW5xq4dJAR484PMXyZm4NbZ8UT8nxymBg7VvSP34If9lmjM3UHCuutRNSQHA
 VMdKF6mM6lIuhCvTNlWouJapK427CAk6JUPNaliUXzONPQdDFrMhWkH8pCBCLAi2GVs5
 +14ROy+TwWmBvLuAv0Iawz0JMr0rAnu3ysldbA7/ITVwHK4RJvPJFSp5fDsgYimbmFdx
 G+1raoxWQ4Oqb/NTj/w0W7om1TWORVbl06RvW3FHgWtpWbGEQ+W36umBf38qXIk4GpUa
 w8CYUi8bn5UEBTfgJbMZGq0o5SttrYzrHc5ThEAVKQ7jcJlPONkZQcpZg0QaW1tcR/G5 bw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36cvyasu2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 09:12:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11299TWA073406;
        Tue, 2 Feb 2021 09:12:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 36dh1npbf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 09:12:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1129CltU030510;
        Tue, 2 Feb 2021 09:12:47 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 01:12:46 -0800
Date:   Tue, 2 Feb 2021 12:12:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: mscc: ocelot: fix error handling bugs in
 mscc_ocelot_init_ports()
Message-ID: <YBkXhqRxHtRGzSnJ@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020064
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several error handling bugs in mscc_ocelot_init_ports().  I
went through the code, and carefully audited it and made fixes and
cleanups.

1) The ocelot_probe_port() function didn't have a mirror release function
   so it was hard to follow.  I created the ocelot_release_port()
   function.
2) In the ocelot_probe_port() function, if the register_netdev() call
   failed, then it lead to a double free_netdev(dev) bug.  Fix this by
   setting "ocelot->ports[port] = NULL" on the error path.
3) I was concerned that the "port" which comes from of_property_read_u32()
   might be out of bounds so I added a check for that.
4) In the original code if ocelot_regmap_init() failed then the driver
   tried to continue but I think that should be a fatal error.
5) If ocelot_probe_port() failed then the most recent devlink was leaked.
   The fix for mostly came Vladimir Oltean.  Get rid of "registered_ports"
   and just set a bit in "devlink_ports_registered" to say when the
   devlink port has been registered (and needs to be unregistered on
   error).  There are fewer than 32 ports so a u32 is large enough for
   this purpose.
6) The error handling if the final ocelot_port_devlink_init() failed had
   two problems.  The "while (port-- >= 0)" loop should have been
   "--port" pre-op instead of a post-op to avoid a buffer underflow.
   The "if (!registered_ports[port])" condition was reversed leading to
   resource leaks and double frees.

Fixes: 6c30384eb1de ("net: mscc: ocelot: register devlink ports")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2: Part of the commit was missing

v3: The first version introduced a bug which completely broke the
    driver.  I moved the "ocelot->ports[port] = ocelot_port;"
    assignment in ocelot_probe_port() and that was wrong.
    Thanks to Vladimir for catching this.

    Also v3 has additional cleanups in mscc_ocelot_init_ports().

 drivers/net/ethernet/mscc/ocelot.h         |  1 +
 drivers/net/ethernet/mscc/ocelot_net.c     | 14 +++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 52 ++++++++--------------
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e8621dbc14f7..76b8d8ce3b48 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -121,6 +121,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
+void ocelot_release_port(struct ocelot_port *ocelot_port);
 int ocelot_devlink_init(struct ocelot *ocelot);
 void ocelot_devlink_teardown(struct ocelot *ocelot);
 int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 05142803a463..e6b33d9df184 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1283,7 +1283,19 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
 		free_netdev(dev);
+		ocelot->ports[port] = NULL;
+		return err;
 	}
 
-	return err;
+	return 0;
+}
+
+void ocelot_release_port(struct ocelot_port *ocelot_port)
+{
+	struct ocelot_port_private *priv = container_of(ocelot_port,
+						struct ocelot_port_private,
+						port);
+
+	unregister_netdev(priv->dev);
+	free_netdev(priv->dev);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 407244fe5b17..b52e24826b10 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1064,7 +1064,6 @@ static void mscc_ocelot_release_ports(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
 
 		ocelot_port = ocelot->ports[port];
@@ -1072,12 +1071,7 @@ static void mscc_ocelot_release_ports(struct ocelot *ocelot)
 			continue;
 
 		ocelot_deinit_port(ocelot, port);
-
-		priv = container_of(ocelot_port, struct ocelot_port_private,
-				    port);
-
-		unregister_netdev(priv->dev);
-		free_netdev(priv->dev);
+		ocelot_release_port(ocelot_port);
 	}
 }
 
@@ -1085,8 +1079,8 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 				  struct device_node *ports)
 {
 	struct ocelot *ocelot = platform_get_drvdata(pdev);
+	u32 devlink_ports_registered = 0;
 	struct device_node *portnp;
-	bool *registered_ports;
 	int port, err;
 	u32 reg;
 
@@ -1102,11 +1096,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 	if (!ocelot->devlink_ports)
 		return -ENOMEM;
 
-	registered_ports = kcalloc(ocelot->num_phys_ports, sizeof(bool),
-				   GFP_KERNEL);
-	if (!registered_ports)
-		return -ENOMEM;
-
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
@@ -1123,14 +1112,22 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			continue;
 
 		port = reg;
+		if (port < 0 || port >= ocelot->num_phys_ports) {
+			dev_err(ocelot->dev,
+				"invalid port number: %d >= %d\n", port,
+				ocelot->num_phys_ports);
+			continue;
+		}
 
 		snprintf(res_name, sizeof(res_name), "port%d", port);
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						   res_name);
 		target = ocelot_regmap_init(ocelot, res);
-		if (IS_ERR(target))
-			continue;
+		if (IS_ERR(target)) {
+			err = PTR_ERR(target);
+			goto out_teardown;
+		}
 
 		phy_node = of_parse_phandle(portnp, "phy-handle", 0);
 		if (!phy_node)
@@ -1147,6 +1144,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			of_node_put(portnp);
 			goto out_teardown;
 		}
+		devlink_ports_registered |= BIT(port);
 
 		err = ocelot_probe_port(ocelot, port, target, phy);
 		if (err) {
@@ -1154,8 +1152,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 			goto out_teardown;
 		}
 
-		registered_ports[port] = true;
-
 		ocelot_port = ocelot->ports[port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
@@ -1208,23 +1204,16 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 
 	/* Initialize unused devlink ports at the end */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (registered_ports[port])
+		if (devlink_ports_registered & BIT(port))
 			continue;
 
 		err = ocelot_port_devlink_init(ocelot, port,
 					       DEVLINK_PORT_FLAVOUR_UNUSED);
-		if (err) {
-			while (port-- >= 0) {
-				if (!registered_ports[port])
-					continue;
-				ocelot_port_devlink_teardown(ocelot, port);
-			}
-
+		if (err)
 			goto out_teardown;
-		}
-	}
 
-	kfree(registered_ports);
+		devlink_ports_registered |= BIT(port);
+	}
 
 	return 0;
 
@@ -1233,12 +1222,9 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 	mscc_ocelot_release_ports(ocelot);
 	/* Tear down devlink ports for the registered network interfaces */
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (!registered_ports[port])
-			continue;
-
-		ocelot_port_devlink_teardown(ocelot, port);
+		if (devlink_ports_registered & BIT(port))
+			ocelot_port_devlink_teardown(ocelot, port);
 	}
-	kfree(registered_ports);
 	return err;
 }
 
-- 
2.30.0

