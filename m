Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8716E4B5E4D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiBNXcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:32:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiBNXcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:32:25 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CDE1110B9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:32:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIqOfuc/dVqfX4Ry7CrQtSpoQjt23Ftw2JVtHz+7lIweMelc3DkOKkDp6zCwAAFLO8HRlIrRFn25srgo/+miL97uWjADp17jKtSF1DXohK2PTgxFO83kKxfO3mD3CxzW8/QowO35Ry5p/U68nYwlS1Z5TaVNYIpETI/uEcbrN035XOtbesoIVDQ/wBpfbd/Xt9E3uAArV/7BOasXgJVgBQkiDpHnA8Jmo7Z0AoiQ5o4GprzA6AoNZjEuL61KsjTVpn5DqljmbVKTOVfPCtPOisQKOPt2P4xx2txoRt1YYLNqKx/6QzxEWBUWomNHqisQzZ1QIdxxMD6RRABn5qsVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uphg5VGv14IwgUmtWt8xOssIRftstlD8L87mBwSOlcs=;
 b=nR0SuXcAZVr8aYFLlnQCKDCRkTWesoqcdEFCsBy/YfOtNNELIZIUYKvd7kPTVeeYvjQVMbwrvZ/14WrAXdSE3ezoFp5+RihWskHIbrfSCYaozpBtQEjpOyvyhJsZrqmoOJoMiwIOgkICJ7rFc39dSysRTyA8rye0UXe/ZgcTIacs1vEWpqL/1sEuS8crcnpPZ3QgXFUdNkB9VWEZ+dqtoHY7I1zIucBug1ZV+G6PkByWJCsF6coAXbBLjzUhUXUJLCTmsVD8LK+LPmip683eX8dVthK3boPzh6NPCqMEc7vORA0nF5YLYfHFJiC+cAf9nAUDT1d2JevK7Ha2rBxr3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uphg5VGv14IwgUmtWt8xOssIRftstlD8L87mBwSOlcs=;
 b=F9ZN1LsZ733CcEIdAVGaM3adTt7/pPnSA7YHzPJ0BCEIr57HQimKYQBcza1HZ2XYZFSCWjwZK19s5mAfjcywP4fSUsJwGKSjuyjyeJFq2DKF2kD5jpzZLUQQuWO5vVX1fvnEri7yoVBBTkKMY1G9b445h/kZjm0j7Ehxb8QOEGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 23:32:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 23:32:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 7/8] net: dsa: add explicit support for host bridge VLANs
Date:   Tue, 15 Feb 2022 01:31:10 +0200
Message-Id: <20220214233111.1586715-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0377.eurprd06.prod.outlook.com
 (2603:10a6:20b:460::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c39d0b1b-1449-472b-a26d-08d9f01239c1
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504A9D1AB31C54AF0645A4FE0339@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHuhwuL0c2fR0ckiLECiSFPH22xRf+lpD02xeHMsKj9gs06H5v/BDi13k4u8Yiwx9hJBfW1lyLNFyUXuqF2WRpHypCiq+toM8EFbl0pSX/vS5hwVSRQfMNv9v9I1JT1Z3Ofssdl37fJJTG8kEXMKdmOFgdFccbqVhkMlPpDmCYZkGyKmg0F8Zo+//ASacsA5pzAj2z6tBSvGPly8CKbCwM+/R9niMylhEqstc3V/pR8fD89ZSe6S4kDQYdWM5M/et7fofc4VsfdaR0tlYOZ4HXRASzwZardzjIEipjr9nLmGPFBQ4hUcIyJgsteFuqtsmS1G8jyosyTgTsjSLRSX1GR1T0e2ENvVPSmI1Y1GWl7g+jnWX+/+5UoDdJmpM8gDlBqWJsDr7DpWoBVzEw+VxhJ3niHv7CFkSzCWMWTQlibEu2NTZpB1+h36/aGJseuuWzKUr0vIJuZMB/ESKg0zUMHvSVCfL5rwXRdxhtgW9+ANwvNWQN2UNr3c7g3Vq1nx/IV/lRBUHiCaepuWfRvdIkGe1r+544fi/tRYnZ1GOsrirLSDm563PL8hBJ6j8ffb6ObIl9tCYU5QMLH94O1NUU2UNIgwhhCObnJN2VlQ/acvlAbll1e9rIaYy8paw0RlSuRDeyimCM9y0bEjpZwNUz3ZlU7k03RlgXRQSXVxq5U9nWlNwUUVXNIXgz/wvozSZv3LKOxn9LSaw3nArgyBng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(66556008)(6512007)(2616005)(54906003)(30864003)(508600001)(6506007)(52116002)(6486002)(8676002)(6916009)(2906002)(4326008)(44832011)(36756003)(83380400001)(316002)(26005)(186003)(1076003)(66476007)(86362001)(38350700002)(38100700002)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6KQdrYuoweVX4nW0L3ZgpNzu0POvX0WdmWAH4JLstoG+Guy4nkZnISGoM8Mt?=
 =?us-ascii?Q?/OU/H7e/WQHJhhCL9i8BIwg1WgFdWQb05KZr5TNcxVA/EQ/Ijll4fkBaxCCL?=
 =?us-ascii?Q?kTkfVojewbp9XkK9toon6XrmQOZI9AFMybrWWVANYbaWml9saibr0ytWb4eC?=
 =?us-ascii?Q?+vKs9WIgsyV/SQPEPjv7vb/NBZ29ZLl3EkGIVIyNuXqdYaJAugUPRxjrmxdL?=
 =?us-ascii?Q?onmVwUzEgixw/IyIOkA9CTfJ1YOETUvN8zja1S6CnNxFnXRzuXEqr1tcdcDP?=
 =?us-ascii?Q?Hrv4eeiSYtnfKKPGYRsuU7UNB10oYuCDy8wN54wwYKcUI7MgjfyQQYGaH37J?=
 =?us-ascii?Q?TllncVSJnzk8VUjcsitxUvGys1A6Yv+kRuwAht7TjYT9LmZOfGOamIHhr/dH?=
 =?us-ascii?Q?JQ4m4INsejMn+hs6PXQJPN35A63Yxq2t6AzkfqV6q6uE0Xg8DTjkGcQ0cyTq?=
 =?us-ascii?Q?ZkluIOO1JztQQ3yuEIYnrSFrcki3FVDk5UM0YiG3Mqvb5XmbZnCPgYtBQdxI?=
 =?us-ascii?Q?6QLf2m9DAvlJfZ/avB6iqy+1cSRG8+RbfQfUa1gd5h6dSgoTj2u5Hq+Q5x8f?=
 =?us-ascii?Q?NtYRoitY26nXpHEo6UJfcM1ELAGZGjhAcYiT66OMYfZDERU7ab8Tj+WuQS20?=
 =?us-ascii?Q?GTCFvNAOJincjmmQs8efVEo79wJf5e19acjHJBmJQNQ9Pw8ZYcomNWL8kjtT?=
 =?us-ascii?Q?cEnJ2xVKVu0l13gNEd0ln84xL8ZzFhhfII8kgwEbmkoym0VA8ONondKKdbVy?=
 =?us-ascii?Q?AVnp5W8kCU3vZ8iKq1wl1BC2Xr6t2cLMGAXIYMIR2/91OeQAg+dH+204/X8q?=
 =?us-ascii?Q?nUKns3V1td0JBLP9z5iKeHjjtsI/7ZZWr6iMDF9nhb3qvhcIDXp6T0VUY0K5?=
 =?us-ascii?Q?SisCm7QtN7j/r8lQoMuaPa0M4UPk+tYtmqg1cEYRSFD1vkFhvxPCwiR4IQej?=
 =?us-ascii?Q?1Vr3xvN6rjNX5XZ3J/Ebj9b8KO3+X7XLhDT0B975NEKn0BbHLp/odYxInoCP?=
 =?us-ascii?Q?QbQMBRmtjzCL+G6g4WJGh31YiN3oV7X2hccOJ2smsZjwbtId+u7Ug3T9PQAS?=
 =?us-ascii?Q?ehNAFFfr5R7+mGXEXvfkZYIS2r6/CplZSeG4wR3O4DMgKJ29bkBEZn49Ag8F?=
 =?us-ascii?Q?NeXxMayJ8znlQQa3gVktLUXs/KqJgOnKV+8m2YbS454y2aTEJ583xurQ490g?=
 =?us-ascii?Q?DBELYD71zDtXY0SND3aWBiH4EPdKsSvKZsxPk9sx/jG9jsdeiROMFUxGeLec?=
 =?us-ascii?Q?jL9e6DRVOCPZzO1kKdFLReXCwnnL4OQDNkuGBAK2GWsCrT9dLF06RJxNKrzY?=
 =?us-ascii?Q?mMRQTv80Mtjm9K9FefjqPJBS2PHPeRrRKo3U/PhOOIsaOVzMziaIqWD37oAJ?=
 =?us-ascii?Q?U/oVfXaMCL5iMooK01GuM1zumUTpNldfoCtuEQrea+3GIIozDWCl1a/KECsM?=
 =?us-ascii?Q?EPnjPOdUUvxTducLdQ464/JyLskMqyGLBrrEOB4rftlvNb6xMsXjlDCe/9rM?=
 =?us-ascii?Q?llvZUubhvzjODMbKpjlrqXNlzHK9UT013jlzvTN4y+SeVAqAChMAeK6pPYnY?=
 =?us-ascii?Q?Xs227aBpqFfIP+lVPdCJh/4dt03EHhb5vUVzEqSRjJUeufYREYUlBrHFDUPw?=
 =?us-ascii?Q?sdXJcDoRf41lB7u2PRDhC58=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c39d0b1b-1449-472b-a26d-08d9f01239c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 23:32:11.9954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHhGmOSS9IK8tR6P4Yj3ZpYH28pNjhjfULi0XeWvDi8U8xjruSwhQl0dPVij4VHQZw+zEVFgiRKwElFFzAO16A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, DSA programs VLANs on shared (DSA and CPU) ports each time it
does so on user ports. This is good for basic functionality but has
several limitations:

- the VLAN group which must reach the CPU may be radically different
  from the VLAN group that must be autonomously forwarded by the switch.
  In other words, the admin may want to isolate noisy stations and avoid
  traffic from them going to the control processor of the switch, where
  it would just waste useless cycles. The bridge already supports
  independent control of VLAN groups on bridge ports and on the bridge
  itself, and when VLAN-aware, it will drop packets in software anyway
  if their VID isn't added as a 'self' entry towards the bridge device.

- Replaying host FDB entries may depend, for some drivers like mv88e6xxx,
  on replaying the host VLANs as well. The 2 VLAN groups are
  approximately the same in most regular cases, but there are corner
  cases when timing matters, and DSA's approximation of replicating
  VLANs on shared ports simply does not work.

- If a user makes the bridge (implicitly the CPU port) join a VLAN by
  accident, there is no way for the CPU port to isolate itself from that
  noisy VLAN except by rebooting the system. This is because for each
  VLAN added on a user port, DSA will add it on shared ports too, but
  for each VLAN deletion on a user port, it will remain installed on
  shared ports, since DSA has no good indication of whether the VLAN is
  still in use or not.

Now that the bridge driver emits well-balanced SWITCHDEV_OBJ_ID_PORT_VLAN
addition and removal events, DSA has a simple and straightforward task
of separating the bridge port VLANs (these have an orig_dev which is a
DSA slave interface, or a LAG interface) from the host VLANs (these have
an orig_dev which is a bridge interface), and to keep a simple reference
count of each VID on each shared port.

Forwarding VLANs must be installed on the bridge ports and on all DSA
ports interconnecting them. We don't have a good view of the exact
topology, so we simply install forwarding VLANs on all DSA ports, which
is what has been done until now.

Host VLANs must be installed primarily on the dedicated CPU port of each
bridge port. More subtly, they must also be installed on upstream-facing
and downstream-facing DSA ports that are connecting the bridge ports and
the CPU. This ensures that the mv88e6xxx's problem (VID of host FDB
entry may be absent from VTU) is still addressed even if that switch is
in a cross-chip setup, and it has no local CPU port.

Therefore:
- user ports contain only bridge port (forwarding) VLANs, and no
  refcounting is necessary
- DSA ports contain both forwarding and host VLANs. Refcounting is
  necessary among these 2 types.
- CPU ports contain only host VLANs. Refcounting is also necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: figure out locally within DSA whether to bump the refcount or
        not for a VLAN, based on the new "changed" and "old_flags"
        properties.

 include/net/dsa.h  |  10 +++
 net/dsa/dsa2.c     |   2 +
 net/dsa/dsa_priv.h |   7 ++
 net/dsa/port.c     |  42 ++++++++++
 net/dsa/slave.c    | 112 +++++++++++++++++----------
 net/dsa/switch.c   | 187 +++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 313 insertions(+), 47 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3f683773aaf6..1456313a1faa 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -312,6 +312,10 @@ struct dsa_port {
 	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
+
+	/* List of VLANs that CPU and DSA ports are members of. */
+	struct mutex		vlans_lock;
+	struct list_head	vlans;
 };
 
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
@@ -332,6 +336,12 @@ struct dsa_mac_addr {
 	struct list_head list;
 };
 
+struct dsa_vlan {
+	u16 vid;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	struct device *dev;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e498c927c3d0..1df8c2356463 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -453,8 +453,10 @@ static int dsa_port_setup(struct dsa_port *dp)
 		return 0;
 
 	mutex_init(&dp->addr_lists_lock);
+	mutex_init(&dp->vlans_lock);
 	INIT_LIST_HEAD(&dp->fdbs);
 	INIT_LIST_HEAD(&dp->mdbs);
+	INIT_LIST_HEAD(&dp->vlans);
 
 	if (ds->ops->port_setup) {
 		err = ds->ops->port_setup(ds, dp->index);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6076d695a917..a37f0883676a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -34,6 +34,8 @@ enum {
 	DSA_NOTIFIER_HOST_MDB_DEL,
 	DSA_NOTIFIER_VLAN_ADD,
 	DSA_NOTIFIER_VLAN_DEL,
+	DSA_NOTIFIER_HOST_VLAN_ADD,
+	DSA_NOTIFIER_HOST_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
 	DSA_NOTIFIER_TAG_PROTO_CONNECT,
@@ -233,6 +235,11 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct netlink_ext_ack *extack);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
+int dsa_port_host_vlan_add(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan,
+			   struct netlink_ext_ack *extack);
+int dsa_port_host_vlan_del(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_mrp_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp);
 int dsa_port_mrp_del(const struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..cca5cf686f74 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -904,6 +904,48 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
+int dsa_port_host_vlan_add(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan,
+			   struct netlink_ext_ack *extack)
+{
+	struct dsa_notifier_vlan_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.vlan = vlan,
+		.extack = extack,
+	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+
+	return err;
+}
+
+int dsa_port_host_vlan_del(struct dsa_port *dp,
+			   const struct switchdev_obj_port_vlan *vlan)
+{
+	struct dsa_notifier_vlan_info info = {
+		.sw_index = dp->ds->index,
+		.port = dp->index,
+		.vlan = vlan,
+	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
+
+	return err;
+}
+
 int dsa_port_mrp_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2f6caf5d037e..314628c34084 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -348,9 +348,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 			      const struct switchdev_obj *obj,
 			      struct netlink_ext_ack *extack)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct switchdev_obj_port_vlan vlan;
+	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
 	if (dsa_port_skip_vlan_configuration(dp)) {
@@ -358,14 +357,14 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 		return 0;
 	}
 
-	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
 	 * the same VID.
 	 */
 	if (br_vlan_enabled(dsa_port_bridge_dev_get(dp))) {
 		rcu_read_lock();
-		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
+		err = dsa_slave_vlan_check_for_8021q_uppers(dev, vlan);
 		rcu_read_unlock();
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
@@ -374,21 +373,44 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 		}
 	}
 
-	err = dsa_port_vlan_add(dp, &vlan, extack);
-	if (err)
-		return err;
+	return dsa_port_vlan_add(dp, vlan, extack);
+}
+
+static int dsa_slave_host_vlan_add(struct net_device *dev,
+				   const struct switchdev_obj *obj,
+				   struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan vlan;
+
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
+		return 0;
+	}
+
+	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	/* Skip case 3 VLANs from __vlan_add() from the bridge driver
+	 * (master VLANs with no brentry created yet, just for context).
+	 * I've no idea why the bridge even notifies these.
+	 */
+	if (!(vlan.flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return 0;
 
-	/* We need the dedicated CPU port to be a member of the VLAN as well.
-	 * Even though drivers often handle CPU membership in special ways,
+	/* Because we've skipped master VLANs while they weren't yet
+	 * brentries, we need to treat the flag change towards brentry
+	 * as a new VLAN, and refcount it in dsa_port_do_vlan_add().
+	 */
+	if (vlan.changed &&
+	    (vlan.flags ^ vlan.old_flags) & BRIDGE_VLAN_INFO_BRENTRY)
+		vlan.changed = false;
+
+	/* Even though drivers often handle CPU membership in special ways,
 	 * it doesn't make sense to program a PVID, so clear this flag.
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
 
-	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, extack);
-	if (err)
-		return err;
-
-	return vlan_vid_add(master, htons(ETH_P_8021Q), vlan.vid);
+	return dsa_port_host_vlan_add(dp, &vlan, extack);
 }
 
 static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
@@ -415,10 +437,17 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (netif_is_bridge_master(obj->orig_dev)) {
+			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
 
-		err = dsa_slave_vlan_add(dev, obj, extack);
+			err = dsa_slave_host_vlan_add(dev, obj, extack);
+		} else {
+			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
+
+			err = dsa_slave_vlan_add(dev, obj, extack);
+		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -444,26 +473,29 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 static int dsa_slave_vlan_del(struct net_device *dev,
 			      const struct switchdev_obj *obj)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
-	int err;
 
 	if (dsa_port_skip_vlan_configuration(dp))
 		return 0;
 
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-	/* Do not deprogram the CPU port as it may be shared with other user
-	 * ports which can be members of this VLAN as well.
-	 */
-	err = dsa_port_vlan_del(dp, vlan);
-	if (err)
-		return err;
+	return dsa_port_vlan_del(dp, vlan);
+}
 
-	vlan_vid_del(master, htons(ETH_P_8021Q), vlan->vid);
+static int dsa_slave_host_vlan_del(struct net_device *dev,
+				   const struct switchdev_obj *obj)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_vlan *vlan;
 
-	return 0;
+	if (dsa_port_skip_vlan_configuration(dp))
+		return 0;
+
+	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	return dsa_port_host_vlan_del(dp, vlan);
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
@@ -489,10 +521,17 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (netif_is_bridge_master(obj->orig_dev)) {
+			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
+
+			err = dsa_slave_host_vlan_del(dev, obj);
+		} else {
+			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
 
-		err = dsa_slave_vlan_del(dev, obj);
+			err = dsa_slave_vlan_del(dev, obj);
+		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -1347,7 +1386,6 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
@@ -1367,7 +1405,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	}
 
 	/* And CPU port... */
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &extack);
+	ret = dsa_port_host_vlan_add(dp, &vlan, &extack);
 	if (ret) {
 		if (extack._msg)
 			netdev_err(dev, "CPU port %d: %s\n", dp->cpu_dp->index,
@@ -1375,13 +1413,12 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		return ret;
 	}
 
-	return vlan_vid_add(master, proto, vid);
+	return 0;
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
-	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.vid = vid,
@@ -1390,16 +1427,11 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	};
 	int err;
 
-	/* Do not deprogram the CPU port as it may be shared with other user
-	 * ports which can be members of this VLAN as well.
-	 */
 	err = dsa_port_vlan_del(dp, &vlan);
 	if (err)
 		return err;
 
-	vlan_vid_del(master, proto, vid);
-
-	return 0;
+	return dsa_port_host_vlan_del(dp, &vlan);
 }
 
 static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4866b58649e4..0bb3987bd4e6 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -558,6 +558,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	return err;
 }
 
+/* Port VLANs match on the targeted port and on all DSA ports */
 static bool dsa_port_vlan_match(struct dsa_port *dp,
 				struct dsa_notifier_vlan_info *info)
 {
@@ -570,6 +571,126 @@ static bool dsa_port_vlan_match(struct dsa_port *dp,
 	return false;
 }
 
+/* Host VLANs match on the targeted port's CPU port, and on all DSA ports
+ * (upstream and downstream) of that switch and its upstream switches.
+ */
+static bool dsa_port_host_vlan_match(struct dsa_port *dp,
+				     struct dsa_notifier_vlan_info *info)
+{
+	struct dsa_port *targeted_dp, *cpu_dp;
+	struct dsa_switch *targeted_ds;
+
+	targeted_ds = dsa_switch_find(dp->ds->dst->index, info->sw_index);
+	targeted_dp = dsa_to_port(targeted_ds, info->port);
+	cpu_dp = targeted_dp->cpu_dp;
+
+	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
+		return dsa_port_is_dsa(dp) || dp == cpu_dp;
+
+	return false;
+}
+
+static struct dsa_vlan *dsa_vlan_find(struct list_head *vlan_list,
+				      const struct switchdev_obj_port_vlan *vlan)
+{
+	struct dsa_vlan *v;
+
+	list_for_each_entry(v, vlan_list, list)
+		if (v->vid == vlan->vid)
+			return v;
+
+	return NULL;
+}
+
+static int dsa_port_do_vlan_add(struct dsa_port *dp,
+				const struct switchdev_obj_port_vlan *vlan,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	struct dsa_vlan *v;
+	int err = 0;
+
+	/* No need to bother with refcounting for user ports. */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_vlan_add(ds, port, vlan, extack);
+
+	/* No need to propagate on shared ports the existing VLANs that were
+	 * re-notified after just the flags have changed. This would cause a
+	 * refcount bump which we need to avoid, since it unbalances the
+	 * additions with the deletions.
+	 */
+	if (vlan->changed)
+		return 0;
+
+	mutex_lock(&dp->vlans_lock);
+
+	v = dsa_vlan_find(&dp->vlans, vlan);
+	if (v) {
+		refcount_inc(&v->refcount);
+		goto out;
+	}
+
+	v = kzalloc(sizeof(*v), GFP_KERNEL);
+	if (!v) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ds->ops->port_vlan_add(ds, port, vlan, extack);
+	if (err) {
+		kfree(v);
+		goto out;
+	}
+
+	v->vid = vlan->vid;
+	refcount_set(&v->refcount, 1);
+	list_add_tail(&v->list, &dp->vlans);
+
+out:
+	mutex_unlock(&dp->vlans_lock);
+
+	return err;
+}
+
+static int dsa_port_do_vlan_del(struct dsa_port *dp,
+				const struct switchdev_obj_port_vlan *vlan)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index;
+	struct dsa_vlan *v;
+	int err = 0;
+
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_vlan_del(ds, port, vlan);
+
+	mutex_lock(&dp->vlans_lock);
+
+	v = dsa_vlan_find(&dp->vlans, vlan);
+	if (!v) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (!refcount_dec_and_test(&v->refcount))
+		goto out;
+
+	err = ds->ops->port_vlan_del(ds, port, vlan);
+	if (err) {
+		refcount_set(&v->refcount, 1);
+		goto out;
+	}
+
+	list_del(&v->list);
+	kfree(v);
+
+out:
+	mutex_unlock(&dp->vlans_lock);
+
+	return err;
+}
+
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
@@ -581,8 +702,8 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_vlan_match(dp, info)) {
-			err = ds->ops->port_vlan_add(ds, dp->index, info->vlan,
-						     info->extack);
+			err = dsa_port_do_vlan_add(dp, info->vlan,
+						   info->extack);
 			if (err)
 				return err;
 		}
@@ -594,15 +715,61 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 static int dsa_switch_vlan_del(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
+	struct dsa_port *dp;
+	int err;
+
 	if (!ds->ops->port_vlan_del)
 		return -EOPNOTSUPP;
 
-	if (ds->index == info->sw_index)
-		return ds->ops->port_vlan_del(ds, info->port, info->vlan);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_vlan_match(dp, info)) {
+			err = dsa_port_do_vlan_del(dp, info->vlan);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int dsa_switch_host_vlan_add(struct dsa_switch *ds,
+				    struct dsa_notifier_vlan_info *info)
+{
+	struct dsa_port *dp;
+	int err;
+
+	if (!ds->ops->port_vlan_add)
+		return -EOPNOTSUPP;
+
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_vlan_match(dp, info)) {
+			err = dsa_port_do_vlan_add(dp, info->vlan,
+						   info->extack);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
+static int dsa_switch_host_vlan_del(struct dsa_switch *ds,
+				    struct dsa_notifier_vlan_info *info)
+{
+	struct dsa_port *dp;
+	int err;
+
+	if (!ds->ops->port_vlan_del)
+		return -EOPNOTSUPP;
+
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_vlan_match(dp, info)) {
+			err = dsa_port_do_vlan_del(dp, info->vlan);
+			if (err)
+				return err;
+		}
+	}
 
-	/* Do not deprogram the DSA links as they may be used as conduit
-	 * for other VLAN members in the fabric.
-	 */
 	return 0;
 }
 
@@ -764,6 +931,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_VLAN_DEL:
 		err = dsa_switch_vlan_del(ds, info);
 		break;
+	case DSA_NOTIFIER_HOST_VLAN_ADD:
+		err = dsa_switch_host_vlan_add(ds, info);
+		break;
+	case DSA_NOTIFIER_HOST_VLAN_DEL:
+		err = dsa_switch_host_vlan_del(ds, info);
+		break;
 	case DSA_NOTIFIER_MTU:
 		err = dsa_switch_mtu(ds, info);
 		break;
-- 
2.25.1

