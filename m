Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CDC60C96F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiJYKIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJYKHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:07:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EEE112AAA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMzSLiv/mdXmLxyYH0A0OVR6nDbw3WwGNTXxreN4tMX1AWNVzgtO9+w6bAiOLlPwIRGeGRmdv7q1Ci3NJTrmHDB5RFxBy76oJtMzTvF74nhFzSqnQ3cjfIchec+9UWK4wxC0FazghivcoRXUNfhWv1tYmMI+0H8pvIU/pNtk5Y0V3u6p1PrwAyIpXnsRU8tvP407s3DmFrZSUJ0epaoZWnyn9YupBtb1JcRQlwrKHZLPI3RKWqhUVtBu6JQuqyBhSiujNPw8fc3dNLZchSpt8qLF3UTfS0GijVrvjuTxsnr9rGFr925ghTpPD4Sy1qAjatUnMMA/rsUdeakp0NEXSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IY2uysjvS0N9kmWplWmXyBaDDHG17l4WCjcNJi7lyho=;
 b=JYFhseC4735LrJGJjL8SnBuYOP1oaxN76x7Kdex6XyFQ6aSVxrsy1JBY7CiZahl46gVRuhm61EOk1fFvBzZxAjSEpQwk9wQB9ibTdxzh3dLYU7khGt5HBIEGgwTOdyCEXBM51Syv/Pqo6dpt3NGs390tR96dROEksq6vEq6RcP3BTEYTBdydbJ68KtRETlvmjNJN7Qvw4PywuU3wI/TCL5FEqY8Vdwpxz4coOx/0OL+yRmYcMdhI08usNGn6MhT3JYHRyTdJogkGMtPG3K821ujt0bw/KRwiLIvfYWbAZzBQGkkAnVIyJmirVOTdeGvy0LAUeuF5KJkRBHVEdqpT8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IY2uysjvS0N9kmWplWmXyBaDDHG17l4WCjcNJi7lyho=;
 b=F12/0dYiYIgDfquGuxF79kD+fPoyGYTgrR/WtcxyehzZtiaR0u2DHuE5Topl6HGElilSeGBUt01d1MZW+4bdz9btgfYV8WsBHzVqvaT9/ShEoPyClFuO0gg/NBgWzt00PNWX7TB7EsJQYbj1rrDO0ucs+3yMxSGtYJB4e6lSWdauQRIy1tgC0ftDbFQW6BPG97UNyJwfX+yUIPJnQ0IhjbBH1W/JMpkuUYp9uE3qWf5bPWxNmBL+54uf6lyNo9+V1+Ca7W27srkHCjjGWMNHwzleRdecpidp7FxD3bKWwRgAgkx9dYv21UT+bZMYlfKbzWF2YQsrVNTj5Uc9sN5S9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 04/16] bridge: switchdev: Allow device drivers to install locked FDB entries
Date:   Tue, 25 Oct 2022 13:00:12 +0300
Message-Id: <20221025100024.1287157-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0271.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::44) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: d714c52e-5d75-4187-b421-08dab66fda80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvXyg9YYwk+NoppuB399+mDSTnfVorzgOyChSYWU68/hbssLsUch2Nd8w0KMJaGLGHW+JDlI3AETOSRZN3Ecver9VX28aJmnL5C0Dvkor4YkN9eSRiEogaIOWLdXCO8wAotnIFAgccVdlQvzJlPQEbAyK+q594+VM/jbQFhon74SmlzNA+kb+KKj8rmtFEiEopa+hpOzh9bhbGlFy6IM2y8Z52sASvccVxsctNC8zVhxIp53eremcjV1LzGOackINdfJ0NmSFPD3k8bau5OSSFd3FuB9zkoty+qrVVEvTVbAyevYXyywueditaC77N8PrcvSr34o6W7MTBZwrnECETo3Ia03uw6bA+tEcUH7tx0Dlqb8BoTi/B4PiniNA4q7x+HuHinAQBxclNztkriSC1/U9MAShden5EGI98MKsRYO+p9syMPONbxKZ2vh5XZAdzlId82Ip+kV8KJbbtj6m70GQqGpKl9LXvzt7bMNgLwgNfUBv81cQID5V+jCGiKjw16EmHDxlaebi9V2GHQ5cB1ZJ07bB5jkll3XPZc8xL6gnQNT3as82XPcpCkCIOm86CkV7aI8tcRII1o86z8+ssZYg22mSTQFmNPwaxybzTDgBPsRMyJhlzZWQ4XzDszYcxtkcJ7BOgoVFsn6cFJ6/mQZnO+no0j+TrUXKIGT4/0kWv425f3ie8iShXobKosu5abzyVMghGgoS0wIu2m6Tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(36756003)(38100700002)(2906002)(5660300002)(8936002)(7416002)(83380400001)(1076003)(107886003)(6666004)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(8676002)(66476007)(41300700001)(66946007)(66556008)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UDkHILre+6vda4HEaDzbq5gVcPA2SpanLGNWRitrJ/NKEH8lnOg10oeOUmKM?=
 =?us-ascii?Q?qrz5aQmur67CQs27LqLRmh6yyxLOFcAa/BzGT8q9QYpvjPvZpXxt47UPuwjj?=
 =?us-ascii?Q?ny72qvHQ4RzCWfZffUHTxCOBPWp4e3uFiQFAGxHhBGV/uXtlaYpo1WDZ1XeX?=
 =?us-ascii?Q?c6amfRZglaw9lGwH/DuGWSLJzqvBdPH+aL4iVXRJ6ZsTV2/UCTN18E0SlKJu?=
 =?us-ascii?Q?ci8pkP4OMpxNC9UJA324j7SUIHDJjto48oamB9nYguD6OOusn1VaE0J19RgE?=
 =?us-ascii?Q?CJVQuWDL9NZ5z1qS2tfuXAjkCcQAKvjE6ORu0gC4+HV/vyk3cwKAViJkxdPk?=
 =?us-ascii?Q?ePHb6f+UYZbS1TfC/vMtvQuGKksTssbTxDMowlvpdOsuKDIPwWbacYYqb6rY?=
 =?us-ascii?Q?JEUBZRBzeNmi5T50XjMXPmugUHC9R7mCTXvbdPuSH//A+bRGMDTslMlRxr3t?=
 =?us-ascii?Q?6pbGCjuak/nY37U5RqVT3tOv2nQAHLVoYVsGU7KrFYeansMiwZ3VbytkWfu1?=
 =?us-ascii?Q?1PVq/oxW+/CVoYLRdcvBxqxTS0cf05IJS8d/4B3q2/+97VS4sP4lsw3J8uvC?=
 =?us-ascii?Q?qnDQZWaGH8GHssym8lyyLwYzUa1AbzFPZNnyBWmV7EBCM649+ZOjgO+u+X0y?=
 =?us-ascii?Q?9Bx2oxpxG3TAP752DraNv9IUC2Esf6sMXieXsaz5YRD45bow4tK0Xkm16scb?=
 =?us-ascii?Q?ef57hz5BZnax9x+7UbGBkMTsEFK2WGSwezorMOE6fFRhTiDEbbG7WglwoiL2?=
 =?us-ascii?Q?Jyio6bgx3JfQHLKiEAncy3wSagOn6jp2c2aSSSp5G4bo42I0x1rRVtw/0GZh?=
 =?us-ascii?Q?ByWHZsI6/o/K4CwYPv+JA8neUZqY+Sl03yxo9JJSYqWZzSp7k+vmQU16N4S9?=
 =?us-ascii?Q?tjpqUqr0W59gRq5xsGxv2dCzDyx2Wtw1b5ZQl/2Ve29bc/8vfC19z/TC8hMA?=
 =?us-ascii?Q?Oi1YFD4FjYpriMOt+rKHiGN+yNBFO7cAZIC5yTy4lFpZ8A6J5rKjtkfw597f?=
 =?us-ascii?Q?aV3+ZM3wG/1a6Li/B595NchVHQOjLK+R+X9xFZqb2ef98H3NsHYqD9lipw6y?=
 =?us-ascii?Q?O0Xtia3ubjn9MD3qGWW6nGGfcaiYbtL4W/0BWNscNP6JTwEbEWKU40fBemjA?=
 =?us-ascii?Q?kOArs56tmuQC9euqijsiPVRWHQRPDvvqIv24TzE2D3oh+4jhhZuhImtrFnJf?=
 =?us-ascii?Q?aQr0px17vVHDp+r8B8t5c6Y9S8WZrcVFcNZVsoBh/O/0+ZkloYyNHsJXaN91?=
 =?us-ascii?Q?YHX9bOYZuPxPYdVb12FW+Rc0mKRro9BW8+1iWmrRy8tb0eQLK+hXQLOCrhbX?=
 =?us-ascii?Q?LD7v71TgzWIaTcp8YeWYvY7lRAlv0511L5M/53dkTNwSxd2fsQwQBPj92xeo?=
 =?us-ascii?Q?GfeZ77iWjsEn7VfXmYL86VE6ELCPaj4Knuxt9hFs+Vlv5LImKKZl2d8t77qQ?=
 =?us-ascii?Q?fe2GwKWuDlf2xwYBoZwIhNjLoDmPrGPSAtgMKLwg6NFyNcLFDiR4bC2ykw4/?=
 =?us-ascii?Q?6x//GimQwcvXhfN/45Qbdl7dXTpgRSAgum6897hfcqRVNcYM+TS9Rk5ca0Wd?=
 =?us-ascii?Q?TyoI3wA8ZseoUYKPZldQYrT63k8K3BxOJbLmTy1a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d714c52e-5d75-4187-b421-08dab66fda80
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:15.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgXUL+6L2bucFP7nfu6dhQQCRirSvOvCLZnIQzup4TZwiI1HQy27X5H6kBlA1/IAN9deVVXo+XdsfCFu+lvmjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

When the bridge is offloaded to hardware, FDB entries are learned and
aged-out by the hardware. Some device drivers synchronize the hardware
and software FDBs by generating switchdev events towards the bridge.

When a port is locked, the hardware must not learn autonomously, as
otherwise any host will blindly gain authorization. Instead, the
hardware should generate events regarding hosts that are trying to gain
authorization and their MAC addresses should be notified by the device
driver as locked FDB entries towards the bridge driver.

Allow device drivers to notify the bridge driver about such entries by
extending the 'switchdev_notifier_fdb_info' structure with the 'locked'
bit. The bit can only be set by device drivers and not by the bridge
driver.

Prevent a locked entry from being installed if MAB is not enabled on the
bridge port. By placing this check in the bridge driver we avoid the
need to reflect the 'BR_PORT_MAB' flag to device drivers.

If an entry already exists in the bridge driver, reject the locked entry
if the current entry does not have the "locked" flag set or if it points
to a different port. The same semantics are implemented in the software
data path.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    Changes made by me:
    
     * Reword commit message.
     * Forbid locked entries when MAB is not enabled.
     * Forbid roaming of locked entries.
     * Avoid setting 'locked' bit towards device drivers.

 include/net/switchdev.h   |  1 +
 net/bridge/br.c           |  3 ++-
 net/bridge/br_fdb.c       | 22 ++++++++++++++++++++--
 net/bridge/br_private.h   |  2 +-
 net/bridge/br_switchdev.c |  1 +
 5 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 7dcdc97c0bc3..ca0312b78294 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -248,6 +248,7 @@ struct switchdev_notifier_fdb_info {
 	u16 vid;
 	u8 added_by_user:1,
 	   is_local:1,
+	   locked:1,
 	   offloaded:1;
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 145999b8c355..4f5098d33a46 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = ptr;
 		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-						fdb_info->vid, false);
+						fdb_info->vid,
+						fdb_info->locked, false);
 		if (err) {
 			err = notifier_from_errno(err);
 			break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 3b83af4458b8..e69a872bfc1d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1139,7 +1139,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 					   "FDB entry towards bridge must be permanent");
 			return -EINVAL;
 		}
-		err = br_fdb_external_learn_add(br, p, addr, vid, true);
+		err = br_fdb_external_learn_add(br, p, addr, vid, false, true);
 	} else {
 		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1377,7 +1377,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-			      const unsigned char *addr, u16 vid,
+			      const unsigned char *addr, u16 vid, bool locked,
 			      bool swdev_notify)
 {
 	struct net_bridge_fdb_entry *fdb;
@@ -1386,6 +1386,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 	trace_br_fdb_external_learn_add(br, p, addr, vid);
 
+	if (locked && (!p || !(p->flags & BR_PORT_MAB)))
+		return -EINVAL;
+
 	spin_lock_bh(&br->hash_lock);
 
 	fdb = br_fdb_find(br, addr, vid);
@@ -1398,6 +1401,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		if (!p)
 			flags |= BIT(BR_FDB_LOCAL);
 
+		if (locked)
+			flags |= BIT(BR_FDB_LOCKED);
+
 		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
@@ -1405,6 +1411,13 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 		}
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
+		if (locked &&
+		    (!test_bit(BR_FDB_LOCKED, &fdb->flags) ||
+		     READ_ONCE(fdb->dst) != p)) {
+			err = -EINVAL;
+			goto err_unlock;
+		}
+
 		fdb->updated = jiffies;
 
 		if (READ_ONCE(fdb->dst) != p) {
@@ -1421,6 +1434,11 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			modified = true;
 		}
 
+		if (locked != test_bit(BR_FDB_LOCKED, &fdb->flags)) {
+			change_bit(BR_FDB_LOCKED, &fdb->flags);
+			modified = true;
+		}
+
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4ce8b8e5ae0b..4c4fda930068 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -811,7 +811,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
-			      bool swdev_notify);
+			      bool locked, bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
 			      const unsigned char *addr, u16 vid,
 			      bool swdev_notify);
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8f3d76c751dd..6afd4f241474 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_bridge *br,
 	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
 	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
+	item->locked = 0;
 	item->info.dev = (!p || item->is_local) ? br->dev : p->dev;
 	item->info.ctx = ctx;
 }
-- 
2.37.3

