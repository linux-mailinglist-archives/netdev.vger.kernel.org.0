Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6BA4BEC94
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiBUVY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234753AbiBUVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33F312611
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFHxqRMq/RqvfiECA/2FvzrD3Fl7DfPDO/7kF8iq9GKeljtou0O+O5x23Sb9+CrjiBzOlrRxbnfxM3E5lzMSudOAbwSDxwI9U5vKMXjzTO9dSKNgfTmB4LtUOz1Loh3gNuR4tM8u2Ae+NEY5z7vGMf/+Ew0TeViuBZzu6K3WlbXZJSDprQ5T/kxjJy4aCxiteflfRMFGAceDYnU/btJAlPJ+1xIi1MSNHHaN//k5z92GgOfDpUE6mfyUmi5gJ4E/uQTIFEAp4UrvMdaR1OBqFVLnDtO821xd4fYZYnVaiKHeLfcvh/Mpo78C76kYN3H0O07KdNq797VF3tjRnLC1BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKvnQD36M2wRfRo54U65rI8s2ww7CCIcaS7UtUUgmv8=;
 b=PoSrzkNBLI6y8l5LD5EBNZfLfyn34BCQ3QLRuG+M7idvMprisPcRpXyCNpm8qfO+WeZGaCHq7MnjngAqNXeaFW4LHWHALfhV7rV3dSgiVh/Fqkp4DayL+wq7zM4otfhjzdlcfd0BGbpoOLNP3THOpQL8TorZR0ViZENnsMMgV8wK6pzH2NuqtGXrTAPZzdLf8ghtMzeuiCgfVC+rhCLDHBWIvAJjxiWuvD3Eu+19W9CWCnSWRJgpSapGpBvokgz9weBDRa9GqRLJRFTfRqbTGQ55EufOMXYO6cIU0tPHe9RoIfzzFPMcRQTQ7fIkW3UNBY0BGB7RnOaNPRD08MwSMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKvnQD36M2wRfRo54U65rI8s2ww7CCIcaS7UtUUgmv8=;
 b=CFIl143igJkZLUgOP1iktWXIEMuTd5+LjM+purl5/fSlF7LGpr14F8bU11VnFHyKlnctF31S5gPSgCSHt6kn/RkimdVfiRBfaT7W0UK/ABiwHCFWU1foow6BagZzeSik71Sycu2hJdg/F02jium2z8Yie7h2mrkoPsYmZb01/A4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v4 net-next 07/11] net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_event_to_device
Date:   Mon, 21 Feb 2022 23:23:33 +0200
Message-Id: <20220221212337.2034956-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb002e6e-6256-467c-5942-08d9f58080d0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5645F049C7783DA3A996433BE03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIFh5L/xtB0S8K7g1IBUTaARGoKNDVaoTjTscQNJhEJ6dDkE2lWrMlyIv5V/s8ySq6PIwZDbTkE4A51fz+BwXaiWE7rtAr2Dh3h57TJ51jU1IUg2PQbXwU/jlGd8fVNC3R1umhwwnRT1TJnaRHr1+wv8JJ2ToctjSt0DNP2VOeA2Xv45dlo9cOkaebDMFIerrozaEHIM+GICqZfZn1WJazK1VY1c2S+MfBzBk99UHPX7ooLYZU8+W4xYpU0Hsw2HZiepbgv6t3HCZYFFuvrbmEp+Czog9nrkZbGoiL1uehy7BQtMkcdvBOeBI3LIXmBk6ME6EbJ9NYLcdgm/rx90LevHhda5WF/dRTPPxVaxrHMR9k/HhKRXvpQO74vsPcMUmOLadrSodSOT6R/HIYL0wAxgCih7oQN37No8gf+k7BKw6aZRRv6Q1/dGYfRPilm2qSGSgNFlEUr998q8Amo+uRoUxBIlUi76rJ3bgUgtIh5vvh9UDuaFmTlsESO73kCbypD9tuP8vJcnatGzXDYp7VZRzkto/n4c00qh0CPfj5/LwgYbfHlDg1w/0Aty4i3KF1NzxUFSzw0OeN2QpHHTTjOsYpO/cQSLpnnceM4uP1aLwNNq4ZIvh8K25TB6i2AmNKrXRLNHRZURjj9bgKTl9OY/gjn7nl0LCH8Fg/0+kKyE7xI0m2o6eRbwuAcLaVbwzmZA7SnbYhpnuuhisA1Rf2B7Lm173hCuPaHD6zzZYaVKS/QU6oVFrqeTcuhOfcpfQKWbsvPDa1JxWWOPlUa/9NNbHwTLnl7WbqZMYPrWH4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(966005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(30864003)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vbGAW53HDYVuc8DG1xB7QBD4Dcyp+3jsAffFKkQ2aLOnmdTm+WBYSVQEKF7w?=
 =?us-ascii?Q?/QDsC92nOKrYFqMr+PUYKAGEalZzO7OkNh2oNt+iZICgPUWIW5IyTge+urpk?=
 =?us-ascii?Q?OnoJWxWZdbb/+zFup+k26lZXEvkPmNwuskgLDcm+xgIhVFh2cQrUwhoKxii6?=
 =?us-ascii?Q?PpCql7cpW6X4athT4VzTn5DDneHm1JrPWq72SoQOMC+qUcOv7ASYnZUuXAGf?=
 =?us-ascii?Q?vuOPRh6cazGqrfFRsZCHpWzK7mllJsp+DXeWvIhfXoqVQHnzyNEvlB7DzLR1?=
 =?us-ascii?Q?6SGnSuXVCBUd1WvVx3TR1a4JLDKMaQlio1fCYfc7Y0ZQdKPMKvZvDLBkWuTt?=
 =?us-ascii?Q?dFqlxY9/8bLeO36r4jHXEwRUCnEu6KbOWk4bSTpm4UGq+t2temaN6t5Rt3wb?=
 =?us-ascii?Q?WpzLPbUFxFJ6QMRNYLVK6SCuNV1w97SL0RW3TPGNk+14e6IFXFME782czTAg?=
 =?us-ascii?Q?P4gujBYGIdbb+oXfH4z1UCwSRNeYExeCI2TrHRt15XaXF7s3HoVVpUThCqA0?=
 =?us-ascii?Q?kSz0aQfsDXmEzoPYYUsdKkN+Wa7UhvI4Br6zUInkRHCqfb2FtBCwCNXmWPyP?=
 =?us-ascii?Q?6CqzHPEy3Kx+ZW03jVGVAarse5PlAB97+1h/VBVLcQHsrPifEfExkEq4A6Eq?=
 =?us-ascii?Q?zatt1vt8ja0wzl/KBWqYnTpSVMop0LR4T0DuCNI7ZShBCJwnGTCcW+oys5Sw?=
 =?us-ascii?Q?jdI5Fp6G1lpesI9ajgUaEBpumVh1IEA01J4uEmjtGaQbt7uxGp3scuGV67mY?=
 =?us-ascii?Q?Pq+wuJL4agvVau3nb0Mg6AQn1e/B7vy6QDAoH8Tx9vldUoS1DskLspw/w6nz?=
 =?us-ascii?Q?M95dxjn3nP/nZ36FRZbOG84iTL9lS0JDYCt6DH8K5WVm08HI/CuxSCOHufOd?=
 =?us-ascii?Q?oNa6QBTVhIGw3pt5gYEA44VVRXTDiRHJDJzHzaYk6xkQTTTjcAJC0NLPSpXt?=
 =?us-ascii?Q?XqGbuvoswfsXvCZOvkvSDnEnoKkdDkbNLEmDsjTZ4lSsClz8OaoTrttBAihK?=
 =?us-ascii?Q?6Q2HEz+kQtr21a3LQ1ksZW+ndG0Ki4UtIUvp9NdiBfT98vTbGvHmyz8kLjIa?=
 =?us-ascii?Q?wSdSDmW9//fX8AlsQSXyrnF9RnBtRsLfWD6D8D7qehxVUVvucuSizYrPrujn?=
 =?us-ascii?Q?aPZIyTgbi72QCFWxtp9hKQG7elcH3V+eJOtDQ8Br7z9HvCDaL16pPjythc5O?=
 =?us-ascii?Q?3UEL62jh7acbiD+Nzlf/uXGpcNT9TCDruR2Y6xzcq8LUsc0/KZ8PvPsANSb3?=
 =?us-ascii?Q?bdRv4Dg+M2Pt0MVPt1SSz1wZPFPRVdxD11ysHtIIAEYt4x6qJDXVUZmoAKcm?=
 =?us-ascii?Q?z9uOFVCjpGdB9LaJNbYAij9JQbHR2mmOALkNlhyLLXOpPEjcoV4FHJfoQ3Bu?=
 =?us-ascii?Q?yD/yBqgADKGYgdy3mIhMK+qm02s4LGW5u7QOwu4XTuWR/AS7v11kSveb6+K+?=
 =?us-ascii?Q?9OtaZNLHeOwCXXfjkMFNvBxdqfDAhWISDlzX97DVvVAjBm3elVisWXhrFS8J?=
 =?us-ascii?Q?hGT4R7az1pqcL0CmrQCAdxpZlWldgM5ampOxb9eIMj7VoPg4O4h/DSrc3Vee?=
 =?us-ascii?Q?a1VCg3/ZLM+Bfd/3+GaVSRJDzyKyjkEOYkiCHUyqOkW2LZE3nRdJJhS8DTj+?=
 =?us-ascii?Q?PH9rVY7YN1e7gTFKeojUrL0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb002e6e-6256-467c-5942-08d9f58080d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:11.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJi4vaLR5RC/JKL/P5ZHSH/igrllDi0/v7RvtsIg7s+2C8baLbBsyfPpdWviAzO1W7e+liqmQ8KcK6lSmGAW2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the switchdev_handle_fdb_event_to_device() event replication helper
was created, my original thought was that FDB events on LAG interfaces
should most likely be special-cased, not just replicated towards all
switchdev ports beneath that LAG. So this replication helper currently
does not recurse through switchdev lower interfaces of LAG bridge ports,
but rather calls the lag_mod_cb() if that was provided.

No switchdev driver uses this helper for FDB events on LAG interfaces
yet, so that was an assumption which was yet to be tested. It is
certainly usable for that purpose, as my RFC series shows:

https://patchwork.kernel.org/project/netdevbpf/cover/20220210125201.2859463-1-vladimir.oltean@nxp.com/

however this approach is slightly convoluted because:

- the switchdev driver gets a "dev" that isn't its own net device, but
  rather the LAG net device. It must call switchdev_lower_dev_find(dev)
  in order to get a handle of any of its own net devices (the ones that
  pass check_cb).

- in order for FDB entries on LAG ports to be correctly refcounted per
  the number of switchdev ports beneath that LAG, we haven't escaped the
  need to iterate through the LAG's lower interfaces. Except that is now
  the responsibility of the switchdev driver, because the replication
  helper just stopped half-way.

So, even though yes, FDB events on LAG bridge ports must be
special-cased, in the end it's simpler to let switchdev_handle_fdb_*
just iterate through the LAG port's switchdev lowers, and let the
switchdev driver figure out that those physical ports are under a LAG.

The switchdev_handle_fdb_event_to_device() helper takes a
"foreign_dev_check" callback so it can figure out whether @dev can
autonomously forward to @foreign_dev. DSA fills this method properly:
if the LAG is offloaded by another port in the same tree as @dev, then
it isn't foreign. If it is a software LAG, it is foreign - forwarding
happens in software.

Whether an interface is foreign or not decides whether the replication
helper will go through the LAG's switchdev lowers or not. Since the
lan966x doesn't properly fill this out, FDB events on software LAG
uppers will get called. By changing lan966x_foreign_dev_check(), we can
suppress them.

Whereas DSA will now start receiving FDB events for its offloaded LAG
uppers, so we need to return -EOPNOTSUPP, since we currently don't do
the right thing for them.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: none
v2->v3: patch is new, logically replaces previous patch "net: switchdev:
        export switchdev_lower_dev_find"

 .../microchip/lan966x/lan966x_switchdev.c     | 12 +--
 include/net/switchdev.h                       | 10 +--
 net/dsa/slave.c                               |  6 +-
 net/switchdev/switchdev.c                     | 80 +++++++------------
 4 files changed, 42 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 85099a51d4c7..e3555c94294d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -419,6 +419,9 @@ static int lan966x_netdevice_event(struct notifier_block *nb,
 	return notifier_from_errno(ret);
 }
 
+/* We don't offload uppers such as LAG as bridge ports, so every device except
+ * the bridge itself is foreign.
+ */
 static bool lan966x_foreign_dev_check(const struct net_device *dev,
 				      const struct net_device *foreign_dev)
 {
@@ -426,10 +429,10 @@ static bool lan966x_foreign_dev_check(const struct net_device *dev,
 	struct lan966x *lan966x = port->lan966x;
 
 	if (netif_is_bridge_master(foreign_dev))
-		if (lan966x->bridge != foreign_dev)
-			return true;
+		if (lan966x->bridge == foreign_dev)
+			return false;
 
-	return false;
+	return true;
 }
 
 static int lan966x_switchdev_event(struct notifier_block *nb,
@@ -449,8 +452,7 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
 							   lan966x_netdevice_check,
 							   lan966x_foreign_dev_check,
-							   lan966x_handle_fdb,
-							   NULL);
+							   lan966x_handle_fdb);
 		return notifier_from_errno(err);
 	}
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index c32e1c8f79ec..3e424d40fae3 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -313,10 +313,7 @@ int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long e
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
+			      const struct switchdev_notifier_fdb_info *fdb_info));
 
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
@@ -443,10 +440,7 @@ switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e31c7710fee9..4ea6e0fd4b99 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2461,6 +2461,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
 
+	if (dp->lag)
+		return -EOPNOTSUPP;
+
 	if (ctx && ctx != dp)
 		return 0;
 
@@ -2526,8 +2529,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
 							   dsa_slave_dev_check,
 							   dsa_foreign_dev_check,
-							   dsa_slave_fdb_event,
-							   NULL);
+							   dsa_slave_fdb_event);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 28d2ccfe109c..474f76383033 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -458,63 +458,40 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *br, *lower_dev;
+	struct net_device *br, *lower_dev, *switchdev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev))
 		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
-	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
-			goto maybe_bridged_with_us;
-
-		/* This is a LAG interface that we offload */
-		if (!lag_mod_cb)
-			return -EOPNOTSUPP;
-
-		return lag_mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
-	}
-
 	/* Recurse through lower interfaces in case the FDB entry is pointing
-	 * towards a bridge device.
+	 * towards a bridge or a LAG device.
 	 */
-	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
-			return 0;
-
-		/* This is a bridge interface that we offload */
-		netdev_for_each_lower_dev(dev, lower_dev, iter) {
-			/* Do not propagate FDB entries across bridges */
-			if (netif_is_bridge_master(lower_dev))
-				continue;
-
-			/* Bridge ports might be either us, or LAG interfaces
-			 * that we offload.
-			 */
-			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
-							  foreign_dev_check_cb))
-				continue;
-
-			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
-								     event, fdb_info, check_cb,
-								     foreign_dev_check_cb,
-								     mod_cb, lag_mod_cb);
-			if (err && err != -EOPNOTSUPP)
-				return err;
-		}
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		/* Do not propagate FDB entries across bridges */
+		if (netif_is_bridge_master(lower_dev))
+			continue;
 
-		return 0;
+		/* Bridge ports might be either us, or LAG interfaces
+		 * that we offload.
+		 */
+		if (!check_cb(lower_dev) &&
+		    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
+						  foreign_dev_check_cb))
+			continue;
+
+		err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
+							     event, fdb_info, check_cb,
+							     foreign_dev_check_cb,
+							     mod_cb);
+		if (err && err != -EOPNOTSUPP)
+			return err;
 	}
 
-maybe_bridged_with_us:
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
@@ -522,12 +499,16 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
-	if (!switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb))
+	switchdev = switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb);
+	if (!switchdev)
 		return 0;
 
+	if (!foreign_dev_check_cb(switchdev, dev))
+		return err;
+
 	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
 						      check_cb, foreign_dev_check_cb,
-						      mod_cb, lag_mod_cb);
+						      mod_cb);
 }
 
 int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
@@ -537,16 +518,13 @@ int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long e
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	int err;
 
 	err = __switchdev_handle_fdb_event_to_device(dev, dev, event, fdb_info,
 						     check_cb, foreign_dev_check_cb,
-						     mod_cb, lag_mod_cb);
+						     mod_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 
-- 
2.25.1

