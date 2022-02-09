Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFF74AFF3B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiBIVbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:31:37 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiBIVbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:31:14 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D67C001F75
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:31:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id9QIdXYckEUFxKwYBdJkbnKzgEzAULcj2dnbzgpcimzDHVvGUSWCBDMzfWCkPOwPv5qEqpQR4raUYeP1ms9qVW/lrxB5In6J2blegOwbuaWxVe7Hs+b8VCuWBHU48tVVEVX0Zj2hHimq3HC5Ak8YfRzyljtPht6nXoWTIBkHWPP923mFXRdwfPWezZqEmmPfPLfrAIOm/VYTbCGK4rL6LWoqhPtCw1NcBBElGrGvHF6NDLXb/0sqZKtofG/W0oD6zjMqPKinrmKfrCAj7xxwuSPv0lP/yvXkp7oPlOeNFFQHbpGJ43O1ELOxLHu0sXF8gcjObmNtw+lHPakDaiimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6450RfRgdqTJ04Et3p2f6Eu7sYXgBYXHtz+FE2TKbU=;
 b=MHhmf3aKierRj7V7wIO/zvjhxefUtVMES1bn8G9MTYFO+LYMUjImI2vs6wGrJsU3++WCqoZeZljoyUdBOZ9t9bU/bnWkCFFvz09OrRnakF7HKNN1WlFZ7ekBmB2hp9Lun3MmQKbCweAA9iDYksnjQJjiXvL4WoOp1mASmM/+3+k1vActvZfD6i9GL9vXXgZPb4nsMWfyZ77B99SLn+ROnwjaxOnpMkCSCfDkmJXn2xtMKvBi3fGi5wfnK7ZKTy7uE0QgfUnNgbBqu8VcoGmXX8fcNChk0jmi7F0uv4WW4gnGTpfQljejSfjRnc1pKGlMQVLDFoJNHTbNfCriVKvPRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6450RfRgdqTJ04Et3p2f6Eu7sYXgBYXHtz+FE2TKbU=;
 b=ZSOZYGn55UFana/qq966zZzAfShxqXWh+dEgG8NxZ/5JD0kXAoul4QBCiuSMpxE2IjChDUhBeZUbPJagyOQ+mtzNnbIX/vxnxh3vZvEZHhMunSIQIWEHnTW7AXwnBV1f4AqohPK29YWsNX85wEchUVFvnl0XhqJOfAsktCFPuz4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:31:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:31:08 +0000
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
Subject: [RFC PATCH net-next 5/5] net: dsa: add explicit support for host bridge VLANs
Date:   Wed,  9 Feb 2022 23:30:43 +0200
Message-Id: <20220209213044.2353153-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0077.eurprd09.prod.outlook.com
 (2603:10a6:802:29::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21e04ff3-07c5-4f71-361d-08d9ec137c0c
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3481:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3481B0891B73FD746CFB3060E02E9@HE1PR0402MB3481.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VuArF/zPybE1TyARwHwYJKQVBGovMOmvz/f3QxWROnAd2zW3AIzwbjbspOJujJ4rQfgAqaiGIhb5N/SCVpISLdIDviagD89e3JpsFFVpj3BIbAxasa12WdEYRjzGSTdinss7q8WBUQXNMGs8vb+Zxu+jECVWVGG0cI6cQqsjockpUXytiQlF2sYlX7JhorVEHUHORSdfD+RoULC0G/wmIU02ha87LUpW7gvC01eSV4H0arfix9N3gv/brgIK2U76F0KIUrT06vesMQLplLGdMscvlMBMskXHahtl+Uot90hOhuj1HPkltoA50dGt7Sk88DhQ/zAY4PEDM5Ws1hoJgtDonrtjr79kaC3zf0/5r2+jwfqMZbbqAAn5ZeFGaIp7RniX1pHrDKYS5ITjngtf85KNNj4K3603ukekTzLqcPDV1ern2h1FfpTd8gHgwTUuwVqzltSGN6JtySBn86dO1C+XMN+vNF+kJHSXShDxANPN1ANzYcgBhyk1X4dW2+h+Nr0bMiSiewURLex36ozQciaXyQbc4bykkS5LdTLqT33sVruQ24g1cKHfNM95kNEDEWg/RHSo0z1NJBZe7zqy5soqRJs9QcwbzHBW4mfnTq5oXdkVnmk2r/kwSg7R2LMKhmS9MKYqhoM4pBLJ+I1IZCJ/v2ssHXHzMeJagyARgW9opJDXGaUsAHLd7XZFqqnrbPoBpqWfU5bUBFCtvmW7/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(6486002)(86362001)(508600001)(66476007)(6916009)(83380400001)(5660300002)(6512007)(44832011)(52116002)(8676002)(186003)(26005)(7416002)(1076003)(4326008)(6666004)(6506007)(54906003)(2906002)(30864003)(38100700002)(38350700002)(36756003)(2616005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/Gt06Oz56nowVDDIAbMRUa5Q3obnItm+4WLQcazpogU2JeThDsk7VdIpZ1q?=
 =?us-ascii?Q?TTHCSaegi9ntDG1ioQykLyGaPnt7gbss4qwKAVS+qW4pVtoTxb21Wck5dDZv?=
 =?us-ascii?Q?OurD3u8d78FlrpXwYoHbW81Xn1FkCWmW0p5176oGmflFru2m+U1HKP9PBgWj?=
 =?us-ascii?Q?q52YHHlo9a8f4XPn1sNinBRyS0eyg1+TdwH/wZ7c4Sw97uIH7/rAUUR2vhF3?=
 =?us-ascii?Q?JZXk7EpMZdC3DpzSRmXa/ZumdO/g0hNvqbderkGLeeUwegPHGwbeK5BSp5yh?=
 =?us-ascii?Q?TkB3dbRrgUveKTDb68ZaEaqHFkwuT5yd6VUR68njrYuEWhmbMM04kcSxoB4E?=
 =?us-ascii?Q?1RY3JSthZZ/fqsUPriNrSc0yU6G5sDCmyatEsOS7icJPXln6kkvFRnKqk9cx?=
 =?us-ascii?Q?7vYGG/q/KCdMRGwLi+Y35TORI8wTd+Fc126VqYaDqLl2Cam2mdDUiTgAJDCC?=
 =?us-ascii?Q?dduVuEXeL3I/9rdKDuxq4XQPcwznMe6UHfzHinR7Kv8ZSWAcH82os1TIB3d9?=
 =?us-ascii?Q?xl0vGBq+L4axmz652s/X46UpR44lxqU6aWMAGy8lfXPWlTuVN/V8IhIv2Kwh?=
 =?us-ascii?Q?lPI5+GcRDBw6zFKZasJG+4oaWFGbDUWiX7xlYiiMMIguiQqKUHsqwcwUlQMd?=
 =?us-ascii?Q?kEu63vDYtMyHa63BVD7bNXMfDilWky5hh+JSDZ06HqNGqXVudaLTBjfZqmoZ?=
 =?us-ascii?Q?LnTmzzYkmgSdXdNksmrBCHwN5gVlcREoV5B9eAbLsjzm1JhVkAdxgEJWMXSz?=
 =?us-ascii?Q?hGlH1UAwlQ3ufjF94/g3OIuyFBp1xHsiTm/004Y1ba6sHTwKrqyqfPhF+Vxa?=
 =?us-ascii?Q?aZCTzOFUUd+fZNClSjs/R6JPF/EGt+H7zl//4hChzDc0siFiQ++fM3hm83L3?=
 =?us-ascii?Q?CmVUDFQZvN0VuKWyPJnpCtKwqFr2WN0/1f9JP5EWfJXQ06E+9Md6RrQ/hRTl?=
 =?us-ascii?Q?GVw2iw0ujCxuoZg3IevHZ0wdEigpYL3BDXtYX8VFWf9qWid8FtMDGiypFlmV?=
 =?us-ascii?Q?V31zQXgK+/famTsBo7V79opxo2wUUj0YXWZeyRv0w6eEZTpZV6p3v8mmvO/R?=
 =?us-ascii?Q?TRPPrZ50QUCP7434Xzfcv0bSeZibAcSLHdsQIMhcsI+UF2KNH7L6SuQ5A5ci?=
 =?us-ascii?Q?DOFAK0M9URhzM0DcpEoIQBE6SSzdhUVk4Zfv3PaVfoP6R4blB0n//ScmyjrV?=
 =?us-ascii?Q?7wHdNngs3jV8IvkFwfQrgTieABVDldF7Q67Gqc+qWswJitHsPLF6ZfhDh1xy?=
 =?us-ascii?Q?mQkwO5ibOvpK8kgUuAWh6xRsBfob1X/NLrFiVVH3GXkS3d5qPFKdYeDmC5ex?=
 =?us-ascii?Q?spgQ+B6lF8X0d89XdtcGV0rthjSd05KKHb7yS0ZoiEzZ14dP6S8SbYiqzDDw?=
 =?us-ascii?Q?qsCa4SrnXXmWXqsCFVN92Srik+JRtJYvXLR7u8z/jBWr9/Xc3U2KiIXXhv4y?=
 =?us-ascii?Q?06SYAwVEXr+xXbp6jjW9k0c+c1UoKPAHfWKBVMd+VAqYLI78QP5IqOQ5RfvQ?=
 =?us-ascii?Q?hSBGrdTDlI5uKR1RqCq/4/lJ0J67kL7LsfRzjGlRinsVO4yPWg9QA11XhHmq?=
 =?us-ascii?Q?5xgb+g6MA+8RwE/+UehQ1TuSNUCi+04TQMj1zSFvyQNw94t4UdxSBcJOFt1k?=
 =?us-ascii?Q?0Ds1R9fbZ7omjTp/OyxoaT8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e04ff3-07c5-4f71-361d-08d9ec137c0c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:31:08.2000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSP6Y0IpFb/ohaysN4NRYwZ3EOsuhGvsTETYOkPaTM/O9OKHaRiJ9dQ+BJBvKJW7HHlzvYb3qlUAdS5sL4nsVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3481
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

- It is possible to artificially fill the VLAN table of a switch, by
  walking through the entire VLAN space, adding and deleting them.
  For each VLAN added on a user port, DSA will add it on shared ports
  too, but for each VLAN deletion on a user port, it will remain
  installed on shared ports, since DSA has no good indication of whether
  the VLAN is still in use or not. If the hardware has a limited number
  of VLAN table entries, this may uselessly consume that space.

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
 include/net/dsa.h  |  12 +++
 net/dsa/dsa2.c     |   2 +
 net/dsa/dsa_priv.h |   7 ++
 net/dsa/port.c     |  42 +++++++++++
 net/dsa/slave.c    |  97 ++++++++++++++----------
 net/dsa/switch.c   | 179 +++++++++++++++++++++++++++++++++++++++++++--
 6 files changed, 295 insertions(+), 44 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fd1f62a6e0a8..313295c1b0c6 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -312,6 +312,12 @@ struct dsa_port {
 	struct mutex		addr_lists_lock;
 	struct list_head	fdbs;
 	struct list_head	mdbs;
+
+	/* List of host VLANs that CPU and upstream-facing DSA ports
+	 * are members of.
+	 */
+	struct mutex		vlans_lock;
+	struct list_head	vlans;
 };
 
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
@@ -332,6 +338,12 @@ struct dsa_mac_addr {
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
index 2bbfa9efe9f8..6a3878157b0a 100644
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
@@ -234,6 +236,11 @@ int dsa_port_vlan_add(struct dsa_port *dp,
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
index 2b5b0f294233..769dabe7db91 100644
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
@@ -374,21 +373,33 @@ static int dsa_slave_vlan_add(struct net_device *dev,
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
 
-	/* We need the dedicated CPU port to be a member of the VLAN as well.
-	 * Even though drivers often handle CPU membership in special ways,
+	if (dsa_port_skip_vlan_configuration(dp)) {
+		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
+		return 0;
+	}
+
+	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
+
+	/* Even though drivers often handle CPU membership in special ways,
 	 * it doesn't make sense to program a PVID, so clear this flag.
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
 
-	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, extack);
-	if (err)
-		return err;
+	/* Skip case 3 VLANs from __vlan_add() from the bridge driver */
+	if (!(vlan.flags & BRIDGE_VLAN_INFO_BRENTRY))
+		return 0;
 
-	return vlan_vid_add(master, htons(ETH_P_8021Q), vlan.vid);
+	return dsa_port_host_vlan_add(dp, &vlan, extack);
 }
 
 static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
@@ -415,10 +426,17 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (netif_is_bridge_master(obj->orig_dev)) {
+			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
+
+			err = dsa_slave_host_vlan_add(dev, obj, extack);
+		} else {
+			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
 
-		err = dsa_slave_vlan_add(dev, obj, extack);
+			err = dsa_slave_vlan_add(dev, obj, extack);
+		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -444,26 +462,29 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
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
@@ -489,10 +510,17 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			return -EOPNOTSUPP;
+		if (netif_is_bridge_master(obj->orig_dev)) {
+			if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
 
-		err = dsa_slave_vlan_del(dev, obj);
+			err = dsa_slave_host_vlan_del(dev, obj);
+		} else {
+			if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
+				return -EOPNOTSUPP;
+
+			err = dsa_slave_vlan_del(dev, obj);
+		}
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
@@ -1405,7 +1433,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	}
 
 	/* And CPU port... */
-	ret = dsa_port_vlan_add(dp->cpu_dp, &vlan, &extack);
+	ret = dsa_port_host_vlan_add(dp, &vlan, &extack);
 	if (ret) {
 		if (extack._msg)
 			netdev_err(dev, "CPU port %d: %s\n", dp->cpu_dp->index,
@@ -1413,7 +1441,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		return ret;
 	}
 
-	return vlan_vid_add(master, proto, vid);
+	return 0;
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
@@ -1428,16 +1456,11 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
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
index 4866b58649e4..9e4570bdea2f 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -558,6 +558,7 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	return err;
 }
 
+/* Port VLANs match on the targeted port and on all DSA ports */
 static bool dsa_port_vlan_match(struct dsa_port *dp,
 				struct dsa_notifier_vlan_info *info)
 {
@@ -570,6 +571,118 @@ static bool dsa_port_vlan_match(struct dsa_port *dp,
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
+	/* No need to bother with refcounting for user ports */
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
+		return ds->ops->port_vlan_add(ds, port, vlan, extack);
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
@@ -581,8 +694,8 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_vlan_match(dp, info)) {
-			err = ds->ops->port_vlan_add(ds, dp->index, info->vlan,
-						     info->extack);
+			err = dsa_port_do_vlan_add(dp, info->vlan,
+						   info->extack);
 			if (err)
 				return err;
 		}
@@ -594,15 +707,61 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
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
 
@@ -764,6 +923,12 @@ static int dsa_switch_event(struct notifier_block *nb,
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

