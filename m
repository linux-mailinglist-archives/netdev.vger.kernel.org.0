Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC726423C2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiLEHn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiLEHnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:43 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147AD12761
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPrXFPtg7cwpbJtKtCPFGqfh+S4nu1SZSlvmJm3dupEfLG+vaMkb93n4WITieJ2kAYL72MtxWGK0yVk11ooBbxhVFZylbxk+lZb2WTVfnyb33od8dYET9PgpiTz7QCUi+EGC6yBdme4n1WrH2jJn4ihe1Qi7GjbQucwQ4Hxx6IMc86G29iznCEnL4tMT9cMqSCv/Np4+OdYP1IA7IGXuyoTglo8EH+oyrDC0tGeX2+rY1lOxzO43VA13cVFIVSYrbt5WSzAstr+SgaZ2TEQMTQSkn29DW+RcYMkBwDi7b2DXFlGHsKib5+8uFc6U85BoML9xEnnIru+AAjz/jA4sEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwVO3MdJewVwL++HqzQVhHQuzCLAJInR8kaZP71v4JY=;
 b=ejETNYkb2vxrxsaiw9OCBaKEbtsWgY5gkNcaMMm7hiSMnMViXszfU/5S3/VtZZjkf7XBCDbSpwe3gSRcxwQMLirHbDb4RpabSYCdrVMuHluzIx3RRM7CyyCM4/VXWOfGIXlQOkJ4SU63W9V1sG9Z+HKJmVgsL2nf58e58+H8TZuSIPodt3ggF+0OcCcLl7fVcZ8HzbXZPgOWAAhfcLVWSX4reFb12UgGMPOuY7AWIUwLcIab12yG43e15HJEDahDf9uryGsJEDinn1VAEkNo5xpIlwhjr3tS8lZEKWhOlzwoHINDIewSTymAIe/tsbx1+LAw8tJpgK2UXcuEn74mwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XwVO3MdJewVwL++HqzQVhHQuzCLAJInR8kaZP71v4JY=;
 b=iTgdTdDGO1zFfng4t8Et0w5fRjg0oSdD7UnLB3qYFMiio+S0oLDgw7pct2DsMO0Top19SKTGBZe6SjBIu6Pf9WfO39Y4oBs1OfGq/KfqhR/JFAvdWC/qKzrS5S/GPeOV2j6q4lWyK2XUsDCm9W7l9vAEVMMykaeOrvHnBvqhbZ81QQtMSNEKpjZXFiKDnVpTdxLC+mqaA2osfSPiH0FXYmshZfAtUjhOaz6EbzrPeafzhIznc07de4traaqz/Kei2wfLhrhx+LrUBrc3lzJx7LieBe47BZpXOSHfJV/IowPGgMXYr/IfQkjG961pnTGBi7sTTx0tnRvo24t31FZx2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 07:43:34 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] bridge: mcast: Use MDB configuration structure where possible
Date:   Mon,  5 Dec 2022 09:42:46 +0200
Message-Id: <20221205074251.4049275-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0326.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::7) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: d1685251-c4c5-47bb-8857-08dad6946977
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1CtjppiuPvnZLuxts/6NW4RVj8YDuy8yXVHNa2iLpUUaAiBsRaX6I7t7DpyE7ylhke1RPsTYVG7Qo2c/iOyVS3DsC4gklNlvGxh0NmUak/t052UfHdGx3+J/29rk5F/h5/sxMVwoQJMg22SDRBOf27xq/HEjExBBP6rbQnw6uFIAYDIzZJU+0weeVLQZ+VJZJkR5APxk5UYNGrND2hiGy3vfJYejnpdN68T9z9Ws7lb/1mpYrPo5XlArW4h4bOOS1iozOEK1BTUiARcRuYfiSvn5dmKNpAeys7xjuppPK0jDXTIxE4pGO1J7RaDNJM1+Sd9eY7PWhDA4jcHzzdoEtwVqZM+9FQyfRBh44WoR2i5SNpqLy8ipA5JMzJfjh8vMomqF+36K0KBzLla7ecBI+kxpUHbbP05iS20zcjFr3YTiuDxbmZX/vU50XJXH/ieyAzJXaAxNwMMgq1PFfTfDrm19dE1bxeMLwMReSBQfXKcx3gAk4FeinR5S753j75gMzJIUYtE32f5uZ78DKmXGu+Lo8URKa8CWlXzuMdGb7IUbcN/8S3v9dF3WZLy9bkYcAvxiGyn5XLcEO84NrVrZ4N2iPVoDAB1plZClcjQSP8Zb423gNgCACZ9e0vUl9k3QG0+tTeNPsFTeW+0hUvZYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36756003)(38100700002)(86362001)(5660300002)(2906002)(41300700001)(8936002)(4326008)(83380400001)(66476007)(66946007)(66556008)(478600001)(6486002)(316002)(2616005)(8676002)(6666004)(107886003)(1076003)(186003)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H028Kyem9jSAma6Vk8h0c+izdqXvySXbtxpYFhbJvg+qeJS2qhJMO/I09qK1?=
 =?us-ascii?Q?2ISZjWjHacTTSD32tfTdqZgYhxx3heGchf2Gon6udLkhEOKa4V+1DhObSLLD?=
 =?us-ascii?Q?djYh144KiLEgOo7GM6UHvPlTl/9MvEmre0YY7wZX7M89Xs5BcCeaCwia21Yz?=
 =?us-ascii?Q?UPoLixETPovbodCZyzPv6e7Fy4vYfdpSOB1DjhVuGCbkLCxHTbFakXrPxJTw?=
 =?us-ascii?Q?SE23hS/H1CPFY6cFCZ7hpKuXqN6YWf4IWCcyKpSI+NsAzlq6TMG1aA3A8Foy?=
 =?us-ascii?Q?jcQs/AT0R0ewZpS5gJhZnZ3XgCKp032c0FttTdZmMWOuoMxz86BSEy83Jc4t?=
 =?us-ascii?Q?X9sWmkPKZmifIC/cFx/YY7fj4CST1EIOmLr7twmb8KXrA8ZshN2nVI84tAnN?=
 =?us-ascii?Q?pEHpjaUSWpcXEGlchKVC9waMfZkDkzJuc3UeT+ddx5qxZHlWq+ndQCi1Munl?=
 =?us-ascii?Q?+bpDp3x6qXJdAtF9N3CDXzL6lGoyzGo36tj97QaegDQomt9ojVGYq6nTfITm?=
 =?us-ascii?Q?a2e/Km7Fl4qztSVXVpZkgRH5msqWJViJXCNuKCGPtDD5mAN0XGENIN4+Ollk?=
 =?us-ascii?Q?LwQH8oagvWBklpI2VOGTDFOmZROe0EcSTzoFHHycBIJjwyNHelukRLKk1w5x?=
 =?us-ascii?Q?uDUz7GPJ57Lcss0vFgWUDbUs+DyNeKFvR/wjTFrUdVO+xJe+pbxxPRqYPDju?=
 =?us-ascii?Q?/LMA/TiCUD2Sx8MX5F0BNZj3joMIUu+H9XeBwLJcXKBKY8B0c8I9d5cBfkG7?=
 =?us-ascii?Q?HbaTcUh5WGGXd8IJgVNfvGEiLxCRMOc8lr889fv1lGB6VpHlc2NJKDkDuzve?=
 =?us-ascii?Q?JHp4PpRKcOlhlA+sFFJ/mDD3/R46zKCto599Aw7L4P6ibP52VRMmegx1Cygz?=
 =?us-ascii?Q?Lfs8hV80qFHN9ljOVqUy5NSbb592GNH+TQ06u6P0nWFh4UTFZnXIIP99p0kG?=
 =?us-ascii?Q?YodBpsQHZrsFJuOOBA3lJnCju89vV/UEL9ACm3Ch4md/suFGgMbywT/vwQOd?=
 =?us-ascii?Q?slqx1wg0gI8bV2x9uExO00Ve+h8AE5ev7jj7IU3Llkden8O0Ufez0e/QXJ4j?=
 =?us-ascii?Q?Aa2n0gvli/CwuMktKDuo6D4nqvK8QzfXUXY2OTDGZQjSaOaY8A2kogR2hqLV?=
 =?us-ascii?Q?cghq0cC9QgKOONOn5PRd/fgR5b+N4YD5jd0kZEeIZGFrBlk7WsGQEvjl6S/G?=
 =?us-ascii?Q?rut2gqZUOaGRspFfcTrsp/eGEuCT1NjmMzKkNrMQjNp6+K8iLKdP34a2FOOQ?=
 =?us-ascii?Q?0Au/Zngyy9MVdByoQJ13gdxzkC9nsnpBHdHYeBCsPMT8f2diGeBMOUmNHsk5?=
 =?us-ascii?Q?gJsgouhNbGOk1YKi2r5iJ3S26IKbpQTIEjTAFkUXMHRhhTalGNCyOi9c5oVq?=
 =?us-ascii?Q?NcUj0eYX/19uqkWmiCyvBYXm6329x8Ec5F0TS9Yn8HMwmNDG6hF3laN7lK3j?=
 =?us-ascii?Q?wgxcxNPJazi7nV9rCH2+fkpt/vtkSKMCOOZBdNBFo0zE1xDM4RxQuKqYkjfp?=
 =?us-ascii?Q?v7aBuYYBNuyxhHvqXGNJeOoB4O481PWJLtAIV+tzGvQUcGWPTqncsTZkS5W0?=
 =?us-ascii?Q?H2uMsLh5hqijTfM6wtmei2JePmLTtYEQevGnpO5i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1685251-c4c5-47bb-8857-08dad6946977
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:34.0697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNSKkjnDyi4yJlRh+lADzxUSAvomUZLrbcQBJj+R6ArlKjQdLArpOULKcWovxtdl9axoqlOzvsq8NtgpE/KTkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDB configuration structure (i.e., struct br_mdb_config) now
includes all the necessary information from the parsed RTM_{NEW,DEL}MDB
netlink messages, so use it.

This will later allow us to delete the calls to br_mdb_parse() from
br_mdb_add() and br_mdb_del().

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 68fd34161a40..cdc71516a51b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1094,7 +1094,6 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	struct net_device *dev;
-	struct net_bridge *br;
 	int err;
 
 	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
@@ -1105,30 +1104,30 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	br = netdev_priv(dev);
-
-	if (entry->ifindex != br->dev->ifindex) {
-		if (cfg.p->state == BR_STATE_DISABLED && entry->state != MDB_PERMANENT) {
+	if (cfg.p) {
+		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
 			return -EINVAL;
 		}
 		vg = nbp_vlan_group(cfg.p);
 	} else {
-		vg = br_vlan_group(br);
+		vg = br_vlan_group(cfg.br);
 	}
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * install mdb entry on all vlans configured on the port.
 	 */
-	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			entry->vid = v->vid;
-			err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
+			cfg.entry->vid = v->vid;
+			err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry,
+					   mdb_attrs, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
+		err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry, mdb_attrs,
+				   extack);
 	}
 
 	return err;
@@ -1186,7 +1185,6 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	struct net_device *dev;
-	struct net_bridge *br;
 	int err;
 
 	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
@@ -1197,23 +1195,21 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	br = netdev_priv(dev);
-
-	if (entry->ifindex != br->dev->ifindex)
+	if (cfg.p)
 		vg = nbp_vlan_group(cfg.p);
 	else
-		vg = br_vlan_group(br);
+		vg = br_vlan_group(cfg.br);
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * delete mdb entry on all vlans configured on the port.
 	 */
-	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			entry->vid = v->vid;
-			err = __br_mdb_del(br, entry, mdb_attrs);
+			cfg.entry->vid = v->vid;
+			err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
 		}
 	} else {
-		err = __br_mdb_del(br, entry, mdb_attrs);
+		err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
 	}
 
 	return err;
-- 
2.37.3

