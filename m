Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112E73F2BA9
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbhHTL7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:59:10 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:24941
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240246AbhHTL7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:59:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PK59jCD5+GOgVaEuEGjA6yAiu/Jc5G50CmMq/DjuNMxmv/apP+cCEtW7CrtzxV5ad2dW9xK11knKxRVH9L+Z8/Szw2iiv8Ye/1ShSJ70mp7mt3mr/wSFCjZdeuyyVlerzCujezlslN8ZXvEnGwlEjBOwXh3wYznyZ4z83WonCvYz9rxrLZe18dtHyCP7MqZF0OvZX3rY6uUCcOikKtudkiZHngWa2NM/eJ185Ujn6ZM3VCpYf3TnvLURaC3RU+fhiu591AvW0l0FoOHHrp9jGmBp19VkKkwVbJMOcloRyn0fhiB2IkINFqy7SSCvX/cI/smhata55CEAhyRlE+UnLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsvhRXyjwA+2KLhO2a/FBMdoDr5VRwW5ZoPNvj6BOnw=;
 b=FnH4bfh9huNusL4inZXqRmWaxHefXK5KPiLiwwGTnLg+adFhnJmLuzRAnwJZVPsonsb0nsKWml3fB3vD8vC1H2aSjpknWxYEzsvkq74Nz5YiVHW5TBTtLJFFS1VpwaWM20eBgQZ8ZtNeXWHkWANpvRrUBSjKtHIN4bQytT92WnC9UpEU8kj42e9b+AA205ryRXiUeMCNYVC6VJJqQ8N8Bp5ac5x4DKOVXBzDgdSD9bAHgFuqph+ZUWQkBbFTjxGpDr/qZJKmtgPEmRQP8VUkAiqPl+sD+aByRD1Q6P/fZa4KCNLBwsl3XeLWCSYxOj5SXUUdykVCQQQKOuPDe8lBZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsvhRXyjwA+2KLhO2a/FBMdoDr5VRwW5ZoPNvj6BOnw=;
 b=bfe8YUXeKLnIon9/kRcRb6M4cD2Ei2xsQRDkCdghLVmziq51us36XbVBJT+n9LN2cMF1YeixDSNhqvNjxfHKssAj9hiiOIaMzgPSPBW3cn5T3l1yKzMyqaK6QSrm2zb7p9NOM6QIHbybl6zE8KDDIBBC+l3Gm6ziq65pKHgrAlg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 net-next 7/7] net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
Date:   Fri, 20 Aug 2021 14:57:46 +0300
Message-Id: <20210820115746.3701811-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0010.eurprd04.prod.outlook.com
 (2603:10a6:208:122::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:58:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d8a81cd-6390-4e5f-5dea-08d963d1cee4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB38394FB376DA18E56000391FE0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXPSq7a5OUykutD3LNQEXC6VN4o6DBwi22o9ozi2vXXQ6AqCHR/p3OaoPE570o3Wkzp6vCL5/1Y9ckhahjRpJLcVXUGeZEBml+rlCaHGa8COhZINom3en4K9BBn1fsJVi2PD4P6u1vdzNgckNghLUZNN318z8JMknYDzNCDYUap8Uwr7QNApIdZ9d+IJxkU4UR6rKkgF/T7CrICuLkF9rdQlrYceMYiKHlndK1Osb461bUKjUpx+1K17MK0EHIVHWzJ5j95NHFqYBGTe4FHyrM+eLtb+VKn7THx+QOYHcSSn9QIp4kb9kpgUmQYgvAB2bIswA8g9k8DjZJ/Esaqe3r2AY7iT7lTogtQj0+p3c8jxUOB0eeOm5zAW2YTlxbvdSJaJTiAXq2fBnRIDUT46wQipU3PQgwvOeCwU83NgAgdrTCC7meLGuVqbqzzxUp8OzCKcDKf8YGmPWy4owhfxt5az4BX1D5DLvViZdf7hJLAlf2IHKA3ieJTsHcAbXglRllkpSaJCl16dZzv01Vh6Sdtaxwzgzp/2dJ0InhQOfDUdfrxCS+S4at46DvbjiNS+/6vGEVMrf/MRSwjK+bQb0ZZrTKOrFS6lncgv98vzEA+4H2lvEnklFZ8Hmqw9fzFLprcRVWNS1chKFf/sprWEJPnt5PgrfT8l87GkYW4xuQ3Qmzcitt+Pd6xE4YUzU93klryCPHRpahBVNQokWLXQKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WSmjlx3Sm0ugfpl54esyuN/iaMq6y9x210n+syI3QvlNUt7Ea/5Ah6Fv92zv?=
 =?us-ascii?Q?avbSbJ7UQgUGurrA3jLGXQJco/bKV+k5WShSNg68kCykozaXUfPwJVd2zY7K?=
 =?us-ascii?Q?TgqDbwh19nRih5fr3b8AiH3X17tYpfKkyvJ6pzUX9DirNedWVjexwiZxjhQ7?=
 =?us-ascii?Q?jtIUoXnU5WkYTyPNl3+3prQqjKDvo5pkuGzzh7mGmJRlr7c62iRxZtmnrtc8?=
 =?us-ascii?Q?3PjIRgjZABSN8Q8SFOQ4OdEX2kqG28DNCUysCL3lVOb/8uBmgOO6ZEJa9W5I?=
 =?us-ascii?Q?kxu8ZBtcE02GwtpWXe4JJ8eYkqni+X3HzQVqhOWN2pzzwbPljxJjKjG9Fy5X?=
 =?us-ascii?Q?Su3lpYH+xsWqo7d/8GkNwQDlNmb5W62m/jh5GEcEzVxdNViwTBLkpvwR4UxH?=
 =?us-ascii?Q?8xyKgvUgq3s0Zs0mIzukxmTt44N2qm8Y7oj/Gz4Ejs9pgLSjsySGHUniZTDk?=
 =?us-ascii?Q?tGTxoIxrLHPGOIWFw93VrDzMsb21vLmTTcmJMHDTArZa1mHqXnrpFWXf2cee?=
 =?us-ascii?Q?YalVaEUFDNcryEWTR3/69rrYbL69SsmlMrw8Q55E40iD2tYfqgwm6qGbzSml?=
 =?us-ascii?Q?dU2OJvVeV460QE7aRe8H9wJm0WT5T7x6t0T/CEXOJBikMJVHPmA6igXVXBkw?=
 =?us-ascii?Q?j5Ev8SC5pxwxCYoXRMfbgjxjoTRZye/1GfwQgun00DSuYrPs15kNBEmd3Ohs?=
 =?us-ascii?Q?I4YP8oCOzKwHiHEj7wQMeHyqOrw5vHqqadxijxJQdEHJo0tHXB7gscFieXqJ?=
 =?us-ascii?Q?sP6I4NgHJfKqzC0UQzgoSgC6nrIHXlFG1j91sRQXZ7/r9kEDvm4ZgwLLEEkA?=
 =?us-ascii?Q?d+2e8dV+vaZWF65A83WtJBtuZGUMYc20+1Qh4ZwAtoSpwpBus7G+raOZligl?=
 =?us-ascii?Q?Fc3o3MnbyEPSLVwDShPj4xtp9vi+nd4K3P2qfw17vNaJ7u6Le+HBQc1Ez0SY?=
 =?us-ascii?Q?Pfb9CF6ZXohExHdxYcNVQKH5r3+Gd4hE5BmcpNEI0pnpUeMnEOaqdQB38uRx?=
 =?us-ascii?Q?L2FLL9htPKiP2VMBfxhiWnz/1FF0SPVRiKYF8MnzIJFss9U0VHKSud/Z81/V?=
 =?us-ascii?Q?GgMZDoJ7UYiws7MbIM+7M0R6OA95984bn4OAwMH1YSEgSPkbcYsZ7O6YMiz1?=
 =?us-ascii?Q?STtv9PBFlzR/58xy0nmXq1IiIS94hvingY0NtcfqKhSBv5xXs3/fRRTiCBB5?=
 =?us-ascii?Q?ceQ4c5T00jOsEpIfIaZyjZsVjIwQM25tFl93s4s9Lgw5jUOsnysGVaBp1gZC?=
 =?us-ascii?Q?vavlW1fpHFD16MPLC7221VjbBHGCkfHDARrHcXdvMjahXCidhTjKApEi2VPU?=
 =?us-ascii?Q?YXYrj+AcYOpKwG3LjUZd4vqI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8a81cd-6390-4e5f-5dea-08d963d1cee4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:22.2421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HbYBGjee99xRlkTYa1YNQwQHvkflYHTDJDyiW5bbR0e/bvacT0AeTSREF+ksB+ah+xDoGLMU4griOnLtZJQARw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the switchdev FDB entry notifications are now blocking and
deferred by switchdev and not by us, switchdev will also wait for us to
finish, which means we can proceed with our FDB isolation mechanism
based on dp->bridge_num.

It also means that the ordered workqueue is no longer needed, drop it
and simply call the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none

 net/dsa/dsa.c      |  15 -------
 net/dsa/dsa_priv.h |  15 -------
 net/dsa/slave.c    | 110 ++++++++++++---------------------------------
 3 files changed, 28 insertions(+), 112 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1dc45e40f961..b2126334387f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -338,13 +338,6 @@ static struct packet_type dsa_pack_type __read_mostly = {
 	.func	= dsa_switch_rcv,
 };
 
-static struct workqueue_struct *dsa_owq;
-
-bool dsa_schedule_work(struct work_struct *work)
-{
-	return queue_work(dsa_owq, work);
-}
-
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
@@ -465,11 +458,6 @@ static int __init dsa_init_module(void)
 {
 	int rc;
 
-	dsa_owq = alloc_ordered_workqueue("dsa_ordered",
-					  WQ_MEM_RECLAIM);
-	if (!dsa_owq)
-		return -ENOMEM;
-
 	rc = dsa_slave_register_notifier();
 	if (rc)
 		goto register_notifier_fail;
@@ -482,8 +470,6 @@ static int __init dsa_init_module(void)
 	return 0;
 
 register_notifier_fail:
-	destroy_workqueue(dsa_owq);
-
 	return rc;
 }
 module_init(dsa_init_module);
@@ -494,7 +480,6 @@ static void __exit dsa_cleanup_module(void)
 
 	dsa_slave_unregister_notifier();
 	dev_remove_pack(&dsa_pack_type);
-	destroy_workqueue(dsa_owq);
 }
 module_exit(dsa_cleanup_module);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b7a269e0513f..f759abceeb18 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -125,20 +125,6 @@ struct dsa_notifier_tag_8021q_vlan_info {
 	u16 vid;
 };
 
-struct dsa_switchdev_event_work {
-	struct dsa_switch *ds;
-	int port;
-	struct net_device *dev;
-	struct work_struct work;
-	unsigned long event;
-	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
-	 * SWITCHDEV_FDB_DEL_TO_DEVICE
-	 */
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-	bool host_addr;
-};
-
 /* DSA_NOTIFIER_HSR_* */
 struct dsa_notifier_hsr_info {
 	struct net_device *hsr;
@@ -169,7 +155,6 @@ const struct dsa_device_ops *dsa_tag_driver_get(int tag_protocol);
 void dsa_tag_driver_put(const struct dsa_device_ops *ops);
 const struct dsa_device_ops *dsa_find_tagger_by_name(const char *buf);
 
-bool dsa_schedule_work(struct work_struct *work);
 const char *dsa_tag_protocol_to_str(const struct dsa_device_ops *ops);
 
 static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 196a0e1f4294..8507e0cd2b9e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2278,73 +2278,18 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void
-dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+static void dsa_fdb_offload_notify(struct net_device *dev,
+				   const unsigned char *addr,
+				   u16 vid)
 {
 	struct switchdev_notifier_fdb_info info = {};
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-
-	if (!dsa_is_user_port(ds, switchdev_work->port))
-		return;
 
-	ether_addr_copy(info.addr, switchdev_work->addr);
-	info.vid = switchdev_work->vid;
+	ether_addr_copy(info.addr, addr);
+	info.vid = vid;
 	info.offloaded = true;
-	dp = dsa_to_port(ds, switchdev_work->port);
-	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 dp->slave, &info.info, NULL);
-}
-
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
-{
-	struct dsa_switchdev_event_work *switchdev_work =
-		container_of(work, struct dsa_switchdev_event_work, work);
-	struct dsa_switch *ds = switchdev_work->ds;
-	struct dsa_port *dp;
-	int err;
-
-	dp = dsa_to_port(ds, switchdev_work->port);
-
-	rtnl_lock();
-	switch (switchdev_work->event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
-		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-			break;
-		}
-		dsa_fdb_offload_notify(switchdev_work);
-		break;
-
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
-		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
-		}
-
-		break;
-	}
-	rtnl_unlock();
 
-	dev_put(switchdev_work->dev);
-	kfree(switchdev_work);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev, &info.info,
+				 NULL);
 }
 
 static bool dsa_foreign_dev_check(const struct net_device *dev,
@@ -2369,10 +2314,12 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 			       const struct switchdev_notifier_fdb_info *fdb_info,
 			       unsigned long event)
 {
-	struct dsa_switchdev_event_work *switchdev_work;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	const unsigned char *addr = fdb_info->addr;
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
+	u16 vid = fdb_info->vid;
+	int err;
 
 	if (ctx && ctx != dp)
 		return 0;
@@ -2397,30 +2344,29 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (dsa_foreign_dev_check(dev, orig_dev))
 		host_addr = true;
 
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return -ENOMEM;
-
 	netdev_dbg(dev, "%s FDB entry towards %s, addr %pM vid %d%s\n",
 		   event == SWITCHDEV_FDB_ADD_TO_DEVICE ? "Adding" : "Deleting",
-		   orig_dev->name, fdb_info->addr, fdb_info->vid,
-		   host_addr ? " as host address" : "");
-
-	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
-	switchdev_work->ds = ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
-	switchdev_work->dev = dev;
+		   orig_dev->name, addr, vid, host_addr ? " as host address" : "");
 
-	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
-	switchdev_work->vid = fdb_info->vid;
-	switchdev_work->host_addr = host_addr;
+	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		if (host_addr)
+			err = dsa_port_host_fdb_add(dp, addr, vid);
+		else
+			err = dsa_port_fdb_add(dp, addr, vid);
+		if (!err)
+			dsa_fdb_offload_notify(dev, addr, vid);
+		break;
 
-	/* Hold a reference for dsa_fdb_offload_notify */
-	dev_hold(dev);
-	dsa_schedule_work(&switchdev_work->work);
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (host_addr)
+			err = dsa_port_host_fdb_del(dp, addr, vid);
+		else
+			err = dsa_port_fdb_del(dp, addr, vid);
+		break;
+	}
 
-	return 0;
+	return err;
 }
 
 static int
-- 
2.25.1

