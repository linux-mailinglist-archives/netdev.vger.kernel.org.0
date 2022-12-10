Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D334A648F46
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLJO5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiLJO5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:57:34 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08C21A225
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:57:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ES/9kEY4efVCetKv6VHe6LQj0HXbCx+7TL9+xb4+9ZKvIC0CXzEuVw0fkSo+m1uecHEXvY22k7LuwgP+k7ze8ogLEdvm6JFUiA6v4Fw20m/2uJxfah8/wQNp2YZev7TuFApqyFu42VEpEFdogIiDyv2Xyj5bkxHlsV2WZOM0lxPpXk/HV9U4WHy4V70fwp1eoUgILe8+CPOy44mrcRc+MZWqpm/YA3ALtnqVcvT/cTlIW3tIE8uxXiwdQ4dy0I0eTbhAhNlR0qXN3RS2mrB+jB8I3BuP1l1akA+8bWL5Rdvi2I26jYWvK5M1FAM/CztIMsxT2Bn//m7AH+aBIQsPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTat1adZC/sbh7f8N77P/a0y0eW+413i0rOMlVSpHLY=;
 b=KxasTwTzZ18boXuIi1R4m0wS9l3DvioJCm0xNn+ecFZa8yNIClgOtFFXFgWa+zrVCfi1+74VOADd4p5utSxqO30Ay7CLWvKW79U+zTu9neG23lOL9yKVPMRynZk8YssY83ewpd4KbumkbSB/+zSyh4wwOzaBtBZPD3Eqh/2ATWeRWVAkrloXMD4RHrxilVVZQ35jtF/U9y06LH/wx/IdB3K7Dil+/cG2vgj2IJzHtoW3cR/1Ii4R81CoWNgH5VA2aNuaZRZcDYfFSHif2+trMoXMTg4plauW978E5Zu4s98awNBS+e93SItGMjB4AwvrIGBAVmBu0AJQ/4itXoDGxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTat1adZC/sbh7f8N77P/a0y0eW+413i0rOMlVSpHLY=;
 b=VH95BIlflj5Wzd2bON+zxto+Tj7jJP3SdQiRBE1tkboMUfxxaE0Mxc+ag9rQmBOrEoesTPeunIP1dT4ftI7fZGhuX02u5rsW0xJC0vp+onRqbwF4HZ1qOevmpC+kkuAId/L+qy7ZgNUpf5jbYZxffbtYfdQ0MR31qrVyBqiqpgoqC1krauBMf8L0fHQdcdmCGE7XslZdwtXA1RenbDChyxL5L6juItV3KV6KPlnKvoc3Tw12i9XeK2s10F1WNOOk21e96VP+aIW2IzolOAVOvNyZU4qv+qC6KTyuBJ9GSEr2mIrzesnRHvIDe7otDqCzf4i90uapKGE4HWY/ZA73nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:57:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:57:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 02/14] bridge: mcast: Split (*, G) and (S, G) addition into different functions
Date:   Sat, 10 Dec 2022 16:56:21 +0200
Message-Id: <20221210145633.1328511-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:800:60::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e170d4-98da-4ac3-465f-08dadabedcd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kfJ5PE4m4yVsN2iGrTv5ubJq2iUnLHdiWYiWgY8VDD8KnUR1p+q6e8k6crj7iO3w0T7A+FfXwhT+xGUJr84xvsx5pCITIS8EbaYSAEzgRAWlMwnOoIABcaZNZfz83ZmnkxiWukEMBDR8zz8EgCON3xdHryHlfWayoHeYYvzZvkUzrmrMtWc6IhzAsz+lbS+sySWweHMv5fAmUhwuIEETZjfS/NoZs1ft5N4Jly5tT/96o9TJzfBHN98oJBRKozAX/35mmr4kOs6feb8/kxTQYuN6Ns5jLfQqWujA56jn6L7aMZFBSVgc3yhON+R5tdWQjgg4fZGFOpNmj6R3AE/DjpFv1t93qnmpyIvnjyTiIRx7VbFxMgJ4iopIXU9yszcZXZ7gDHskyQe+pdJpZ2JhGphusDoPwL8aVIh8nQd0f530/ZiWSYRHahIBaA/r6v6Wn4hSlNsgQ7arSeQD0ksFEZX+xBPRX7ouGdEBLiP2W+M3NZaYvDqgbmzfFmkLeqL1M3wirkopKJxkObqUztz3DvTOSzpJBd6Gq/D2UK6ZkOIp4P7sh6BH1I6o5Qy/DePLGTtW+kMoq87ER/nGaFZ+RZ+ugAyzuMBe8k7R8++hNv3IJUraD3pnlpzZkm63ooHz4JG/Mb/v2a/0LocXOZSCgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?degoF/hfpW8/icNy9AcPdCAKjbqGQ+jZD0DlX63YSx2GbKBpBf5BhA3Ai+DD?=
 =?us-ascii?Q?G7mypaisFNeO8nnZveIJXH6Si8VuyzMxlJiXCo5bQT7vSt7Wm8ZwiFoyBdEw?=
 =?us-ascii?Q?u3OE1Tq6Zt8vZkf3xgxOm7IvclHpkR8GtGrdmDxzfhzM0EtU2gcIKDfLvVol?=
 =?us-ascii?Q?VnWw9Zn4DJ7fsiRyZlH+LOJAYEf0yK5vaPnwnbRVwESA7hvzH3/Xjyk3SLa8?=
 =?us-ascii?Q?vUnO/D+I6/KbeKr2WhonxYBP+liZpdfE+A+HAuVdB7eSPf1lRMykLce1Gx65?=
 =?us-ascii?Q?TIwK07byHeCFON2NNKcHSJ11+K/GxngMgXnPH49NvY3I5qS6xJam7Lwr+aga?=
 =?us-ascii?Q?oOLNmiPGpXaF0JoXTj+2NnJScobWWidcir0J1+cDCvSKPdw98vBfadrYtVLF?=
 =?us-ascii?Q?yL2h8jqIquaTDC541b0TVqtkMB1Lc5fWUJ/D82/LIqTIlfUycNWZWQIk5C02?=
 =?us-ascii?Q?20XKnQrsVlayU+A3hB4m10BgG2asSgj5h7dydetfl9UesB9g+IjT5woNwkHK?=
 =?us-ascii?Q?+6gclYw4855PuMk/5Qj/+Kfc0fRRrHmE8+nRQXjmxdZh0hTVSfQ18gAW1lFT?=
 =?us-ascii?Q?XoARKTDoXcIOz3RvrdJsS10F9zlnZiGBKAFaoGoYQKsoPm1j0+i81rJFcZzU?=
 =?us-ascii?Q?3C8Ggu6zqnIYt6mw2BS8qcZrs2G0a92aiwJI33M/nXlB4fJvN5f88+2K2rqA?=
 =?us-ascii?Q?TE70uwiWeAPrLsNb/z/xytEWfcHyJ1iTeH//+FW81JfImD23nGWK2VcfK1Vt?=
 =?us-ascii?Q?A7otPO7A6C0UsEZauEZggqB6/XCj2sDhBn5h04by0fmNHzbNoWoOoM1Q+RDf?=
 =?us-ascii?Q?z4vQ9l+BJfNNmoqQzVuDAJ9CJz+i6/d/Yi+3WftRPIC5bw0DJ8hqYAmw/OQk?=
 =?us-ascii?Q?bw3b0uQo69xhIxIHTV6mV0JVgXe6l3E81hvi8IWybcXX151our37WytNBIIx?=
 =?us-ascii?Q?VNbXGbgnzNtQYLLHesP5HYYnKVE6RszvWyRRO4xd8FtqurN/CwRMo05mhePI?=
 =?us-ascii?Q?IzhFsQpe9GNeo0+f6olFDIVagcfLBDXZdEoWggSkaA6YPpnLO9kMgAhU2qU6?=
 =?us-ascii?Q?SydT4ygDwDkIREMkhvhHAr5K8KzGHoKIqZbbP5FrmJBbVVbKBMRi+P2CkqZS?=
 =?us-ascii?Q?RhvqyNHWPY5PyUwMQ3usHugobumpWt6USVjW46rdrG1owXfqVbFl3fVjVsa9?=
 =?us-ascii?Q?w5f4+tjAyN3SfWLX718rr5kxnKzrFPquhP6E31+5eErQLanYFMAz5k65v6ED?=
 =?us-ascii?Q?DaATg+TlsksRmHW9rPiUmBLbFjIkXy7l+M60X0qHHD3/oNM5S0rPKKnn53ph?=
 =?us-ascii?Q?M3avnFpZ0FPaDt+oSDjYiYPI4PB6eLYv0salIAzVoyf/Z+zgl7IcJVh/mRBm?=
 =?us-ascii?Q?8oPc4pd/tGZ+cR3QbZhIXWSVS29Yvok6ApAR5s8eRsaUvlQnIVvtRVZbIpak?=
 =?us-ascii?Q?aqdWI4zR7UEo5075m4p1aoXDguAqsLD4h+VPmf5g3kvyogHPo0vnwqJLXBOm?=
 =?us-ascii?Q?fepQ+LpH8bR9n86NAI6AAwl0JVaBJ1szU03XRuxmXmhBhudLeCK0BJSkDvpr?=
 =?us-ascii?Q?yvU3npzMKL+XG60ZcFK8MKvXykcUHXlrZyWXKw/r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e170d4-98da-4ac3-465f-08dadabedcd9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:57:31.1152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRGAwL/fiNKheFrKGZPLMonfQj85jRE9R3GH1ZfKG7qFsEJIu2t8gqgsWSQyFCBDBDBmfxi+l9cMKung9FkkiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bridge is using IGMP version 3 or MLD version 2, it handles the
addition of (*, G) and (S, G) entries differently.

When a new (S, G) port group entry is added, all the (*, G) EXCLUDE
ports need to be added to the port group of the new entry. Similarly,
when a new (*, G) EXCLUDE port group entry is added, the port needs to
be added to the port group of all the matching (S, G) entries.

Subsequent patches will create more differences between both entry
types. Namely, filter mode and source list can only be specified for (*,
G) entries.

Given the current and future differences between both entry types,
handle the addition of each entry type in a different function, thereby
avoiding the creation of one complex function.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 145 +++++++++++++++++++++++++++++---------------
 1 file changed, 96 insertions(+), 49 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 2b6921dbdc02..e3bd2122d559 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -786,21 +786,107 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
+static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
+			       struct net_bridge_mdb_entry *mp,
+			       struct net_bridge_mcast *brmctx,
+			       unsigned char flags,
+			       struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+	unsigned long now = jiffies;
+
+	for (pp = &mp->ports;
+	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
+	     pp = &p->next) {
+		if (p->key.port == cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "(S, G) group is already joined by port");
+			return -EEXIST;
+		}
+		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
+			break;
+	}
+
+	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
+					MCAST_INCLUDE, RTPROT_STATIC);
+	if (unlikely(!p)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
+		return -ENOMEM;
+	}
+	rcu_assign_pointer(*pp, p);
+	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+		mod_timer(&p->timer,
+			  now + brmctx->multicast_membership_interval);
+	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
+
+	/* All of (*, G) EXCLUDE ports need to be added to the new (S, G) for
+	 * proper replication.
+	 */
+	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto)) {
+		struct net_bridge_mdb_entry *star_mp;
+		struct br_ip star_group;
+
+		star_group = p->key.addr;
+		memset(&star_group.src, 0, sizeof(star_group.src));
+		star_mp = br_mdb_ip_get(cfg->br, &star_group);
+		if (star_mp)
+			br_multicast_sg_add_exclude_ports(star_mp, p);
+	}
+
+	return 0;
+}
+
+static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
+				   struct net_bridge_mdb_entry *mp,
+				   struct net_bridge_mcast *brmctx,
+				   unsigned char flags,
+				   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+	unsigned long now = jiffies;
+
+	for (pp = &mp->ports;
+	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
+	     pp = &p->next) {
+		if (p->key.port == cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "(*, G) group is already joined by port");
+			return -EEXIST;
+		}
+		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
+			break;
+	}
+
+	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
+					MCAST_EXCLUDE, RTPROT_STATIC);
+	if (unlikely(!p)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
+		return -ENOMEM;
+	}
+	rcu_assign_pointer(*pp, p);
+	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+		mod_timer(&p->timer,
+			  now + brmctx->multicast_membership_interval);
+	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
+	/* If we are adding a new EXCLUDE port group (*, G), it needs to be
+	 * also added to all (S, G) entries for proper replication.
+	 */
+	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto))
+		br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
+
+	return 0;
+}
+
 static int br_mdb_add_group(const struct br_mdb_config *cfg,
 			    struct netlink_ext_ack *extack)
 {
-	struct net_bridge_mdb_entry *mp, *star_mp;
-	struct net_bridge_port_group __rcu **pp;
 	struct br_mdb_entry *entry = cfg->entry;
 	struct net_bridge_port *port = cfg->p;
+	struct net_bridge_mdb_entry *mp;
 	struct net_bridge *br = cfg->br;
-	struct net_bridge_port_group *p;
 	struct net_bridge_mcast *brmctx;
 	struct br_ip group = cfg->group;
-	unsigned long now = jiffies;
 	unsigned char flags = 0;
-	struct br_ip star_group;
-	u8 filter_mode;
 
 	brmctx = __br_mdb_choose_context(br, entry, extack);
 	if (!brmctx)
@@ -823,52 +909,13 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 		return 0;
 	}
 
-	for (pp = &mp->ports;
-	     (p = mlock_dereference(*pp, br)) != NULL;
-	     pp = &p->next) {
-		if (p->key.port == port) {
-			NL_SET_ERR_MSG_MOD(extack, "Group is already joined by port");
-			return -EEXIST;
-		}
-		if ((unsigned long)p->key.port < (unsigned long)port)
-			break;
-	}
-
-	filter_mode = br_multicast_is_star_g(&group) ? MCAST_EXCLUDE :
-						       MCAST_INCLUDE;
-
 	if (entry->state == MDB_PERMANENT)
 		flags |= MDB_PG_FLAGS_PERMANENT;
 
-	p = br_multicast_new_port_group(port, &group, *pp, flags, NULL,
-					filter_mode, RTPROT_STATIC);
-	if (unlikely(!p)) {
-		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
-		return -ENOMEM;
-	}
-	rcu_assign_pointer(*pp, p);
-	if (entry->state == MDB_TEMPORARY)
-		mod_timer(&p->timer,
-			  now + brmctx->multicast_membership_interval);
-	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
-	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
-	 * added to all S,G entries for proper replication, if we are adding
-	 * a new INCLUDE port (S,G) then all of *,G EXCLUDE ports need to be
-	 * added to it for proper replication
-	 */
-	if (br_multicast_should_handle_mode(brmctx, group.proto)) {
-		if (br_multicast_is_star_g(&group)) {
-			br_multicast_star_g_handle_mode(p, filter_mode);
-		} else {
-			star_group = p->key.addr;
-			memset(&star_group.src, 0, sizeof(star_group.src));
-			star_mp = br_mdb_ip_get(br, &star_group);
-			if (star_mp)
-				br_multicast_sg_add_exclude_ports(star_mp, p);
-		}
-	}
-
-	return 0;
+	if (br_multicast_is_star_g(&group))
+		return br_mdb_add_group_star_g(cfg, mp, brmctx, flags, extack);
+	else
+		return br_mdb_add_group_sg(cfg, mp, brmctx, flags, extack);
 }
 
 static int __br_mdb_add(const struct br_mdb_config *cfg,
-- 
2.37.3

