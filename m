Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209AF55FC46
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiF2JlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbiF2JlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:41:07 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BEB39B8F
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:41:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSampyXJ6+KUgMLjTCRYBC8Rc8M/AVygsAqeQhpXo7JqJngOpRxo5CgWVqmQIwxUYmZrq8OTmq6WXRdRx8hXA6c60wZlc0kQJTXE2mlVJ84j+57Kr0c2RJJ3DjCl8ixmcq9XSA9G+TAD+zN8Uy7c8zgluUvI6oi9UEEMJl4SvKjOCvk9hDbh+F88Z7Z2tpVmCJcgc6BItJh0WnhTrFPiuW0jT+a4lt8OigFnIuIOLQ9FIRKv1eKr+R4Bm/Ol+wkjXg6y41ATt5Ymp2fqrkyF8oUQTrBUIC0oPzvzgYPN7deUqspQUDrT/moChxpxAgqIUs8khOkxuOrfmXB2EPnvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KQ8OOf4nfykdcKZd8G1UHAWzLBDM+eGlr0oum0kAj4=;
 b=E1oP0q3sw1+w0xPaQlVLLus8G8GGKZkLp4TSyUdFdVP63OPg/xJMnPxQg3dD0+kFaW+dvadCGpDLcNdlh+uQCFhfygZLmUBKBJH2gq97g1+WB9m370wOtXmXYaXnLAABPJSSnHhQfj2z8aP9EDnT3S4GLDxjPysCPidT18kuEamPd0KxhSTcCCENOY95XZ6WdY+f+2Y4eMk82yeQvZ6Xo1HPNYZy9h0IiGbPIZLh2kKTOJJhNfs/+HoFHjARtaCHLEOYHPCHPXFS4BPUEHsGCw+npmSVYhBjHhruyIiaV53ODwonNzJQGot38OZciIfA2o9DWJntEdtHv/Kef+60Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KQ8OOf4nfykdcKZd8G1UHAWzLBDM+eGlr0oum0kAj4=;
 b=YxpyC1tZJHc7HqncT6wYrRX0k4nIRr5emxEpnmLGdWnsFiZzyeW1yn9MR4/BdP1YSGOHHhxd/LtnNIpP0tLtBc4F0p6J9kKb7QAP4zohgbi5UkB20Wp4b7PNyM4Y0FsxYJMVmmzATW0BAtolU1eDh05FdgpSb8opp/7BQXEe3d1tE/XiLONcrIxM2D0QlMcjV6XyROIyhSTXR58WnrDugVCaQMBA0epO5Hu6K32KiT5DLzQg49+W2bEWPiD2oclsgwX8+2U2nBbl7+6pDTINZSMpOo9ISkb8EVZ0P1SH2w/baIjheMvhKGr/eXQ7F8b04vld6kQBc3yfLBjotwGDGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:41:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:41:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum_switchdev: Add support for maintaining list of ports per MDB entry
Date:   Wed, 29 Jun 2022 12:40:03 +0300
Message-Id: <20220629094007.827621-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0063.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d6c8c89-71a0-4a2e-7328-08da59b37c8e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gnbc/nnHGl4IR/siCsKl1VkbcC3cysfSQ6/+8WPyuOY8K8bTw0/+SW2C0R6sb4x9o4QXFICt7hynRRidovKmDnIdCR4aYn98Viv1W3lfq3f6UF7UCm7uEopR01yn0Ct5gPO95NMIXWyhqTtBuEom2UEhQwtg6K3ieIjEGHg+HxyMV1K/oagNGZH+oqAEztAN8RUEOcFQJksSYuRWI869RpT1OEsRcUnAr4fLpgfmdlUW8uD1KDjQy/SkGV++Rzq8ky7rvtzkHJw1M5eEhP7QECZ+DLwqs2f9pP4QqRtxr3brkwQScQc2NiYPJ0pvk3Ueh3M4QjZOJQhG9ZPb6OFnJRdzaPWDWsNEDLNuP+H/toTnUfQ+sFBkthLc35wvxi2HJ4fQUDPG+eHL+rN9qemVRSETPVgxwZ0vIK+GG0Hh0bXgblKN6up5/D5/OA7xtwdDlXwSdvRgFDqtM/9cqOj/heR2V6fnZzXGEotwxV90P8Z8EyrArmKAiJWPjSV8H6g4rq2vul0+Li7QAT7BNWocsKNYelVzRTbrPoXzrUZOU0wB0yAm/kRcQKEtL+2mpIgMDxdpyxETp9e4MNxcF6EvXrPmg7eEceyOlGaeoStvhEV2vecXytANF9eNYbtSxeiJDg11bozDc85DlfC8BQhTXhvC1C/srNra+RnL14r+kxRWG5rTO1YxpWU+Ag48bslGxA6bi3Dp6piy0+MsBsmoFPwYPuLtEPOOOVsunbpCeffQZ7l+kiDmD76tBQHJoGH8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(66574015)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JRIR/DQUG7Ulrd2lRUWQpqLuBj+RHW9WbW5pSVKgl82Za1Rybbx9A1vv6qtP?=
 =?us-ascii?Q?rK+3OO8xKXL7WrVfWKGw/0rnm8RqBb5YrcRWETQXV7cd4rjHsfn6YQhtJOvM?=
 =?us-ascii?Q?7Dnw9ChHc6DL9TAb49GzrR+kxdkLa/JNJBEITlVJp2dh+eSdy1NbHycG7DpT?=
 =?us-ascii?Q?bPKrBiNjgXzDkKA/FOWl3LcxF/MLvR3Dj/irBz/JumoPRvrRm/gRzauNNGIj?=
 =?us-ascii?Q?1lxXUBs5fCK6ZMBQPqlNyijSVNewiN5CH1CFKIsv+D/2l9Z2+zz+T8QGiiUd?=
 =?us-ascii?Q?T6enMPgjeJ30nNyYc0u2xvE3EcP7PSZP2TBHzH6Yje+hq8DGyhv3eZtuzD5G?=
 =?us-ascii?Q?ePY3abZbZLtaLJvDt96+2iiHjVLsBYe2iJ/PK8LbgijTljKdFTW0uiAaUprV?=
 =?us-ascii?Q?tkQ0DhfWNxBtP2V91QNGthpXAwv+yFa2SsHPdkT1Vnp4ZeShDfrOy0EtY5zh?=
 =?us-ascii?Q?iCeSupUH9FKfdNAn6rGswC/6892rCkuhQE6mFrA6YiaB9JdsbgMinXvnBs47?=
 =?us-ascii?Q?T/uUhDGyNGNYZahFe9rrCuFjG/qa+011dMTjvNL0AFw6WFuAImJh7psD7gtm?=
 =?us-ascii?Q?H2bYNZJCV2SnbChgRwYkoVdwAYTNj2ca3G7vWqM+kpzgSwClhJUPF3MOZU6m?=
 =?us-ascii?Q?EMPKiG0yM3K3q1UzgwrhwTY1ihixsXv0WCC1TYpZrnVwZXxrW7X4xVZeUWnu?=
 =?us-ascii?Q?wNd4Uwvd4ohEbMffcvV9WqucoU8lrVHMxPTzpKtMz5UkOH7ckCyD1+FoYc44?=
 =?us-ascii?Q?aMy+EPKTCWoqQRE77/ciZ3zT/xOIQmkv3Se4sInXqvP21dwZ/v9nKvBa8NoV?=
 =?us-ascii?Q?M4xNMXaANLPrTZikrHS2hAGwga3y6L1YNAeINbSpHMD915Q/dWaJ3wMvexJu?=
 =?us-ascii?Q?nJ4JfWNY2YULqlUIEQhUF3eguXga1aGgk3k8i7eNRAZtYA7vTXBbtFOxqPYY?=
 =?us-ascii?Q?6CXGngFDJYWaYQzk+fuwNpx13sRSOcac7ah0RA0EzeehLiZaQlGWV6/FrTH/?=
 =?us-ascii?Q?/YZ+6koNG5T+d+5bVT7NqauI22zt+WsCbGZb8F2MQUoGv3Su2DCV7NFg94Pl?=
 =?us-ascii?Q?035ztNhz9vFcnPeCselJusbYkTKfKHGVS7EWj2/NeFrfN5/iuBnCqv9fdW6h?=
 =?us-ascii?Q?Y0BLGB2Bd+itaWyd5q8K3PjTBwX9dfsAgjC+mqQGoIOL6fSuLnwOH10qqFD1?=
 =?us-ascii?Q?NtxoyXm3sHgj7OZkdVk2SgKIRE4LC8TSETWKU/JO0VjUCmoyuRpeKs4DgiOl?=
 =?us-ascii?Q?RgmDbCjpsJrR5y/zPlGruzukatFxpTCRP2xHwYUwOUTgLhnApN3A3rYpSAdA?=
 =?us-ascii?Q?q4Uma+ouvEKibcC1DiKNxTw17U2yF8scrJ+wlullr5IclyNlBjyTh7E1QSG5?=
 =?us-ascii?Q?U9aW1jlwqBGoGcdem2sX5pqlqfBtidcdqC+JdhtFdkvDGI17EEif21ldcSmn?=
 =?us-ascii?Q?Ov2WXQY0omX8nieCjLtqN3XcOMmESiBMGrLL0Yys94ZwXRswG00w9krmXsji?=
 =?us-ascii?Q?irQUgIQARlisF1maQHSgRxx4AMUFNFMGNMFB9q12Wx1cc9CMb8sY+H61joTz?=
 =?us-ascii?Q?ubD7vb4b2qRp+jL4CLq0aHiFeZInu4VLxJKuTj9C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6c8c89-71a0-4a2e-7328-08da59b37c8e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:41:05.0867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FXEEq5JcEu3GtBJm8MHTwIxl+O1Le1JWWiLBMedr6yxDMxOb5ghrT/BR3332D4goMx+Bz6ezsvOMf6Q2EuSEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3850
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As part of converting MDB code to use PGT APIs, PGT code stores which ports
are mapped to each PGT entry. PGT code is not aware of the type of the port
(multicast router or not), as it is not relevant there.

To be able to release an MDB entry when the there are no ports which are
not multicast routers, the entry should be aware of the state of its
ports. Add support for maintaining list of ports per MDB entry.

Each port will hold a reference count as multiple MDB entries can use the
same hardware MDB entry. It occurs because MDB entries in the Linux bridge
are keyed according to their multicast IP, when these entries are notified
to device drivers via switchdev, the multicast IP is converted to a
multicast MAC. This conversion might cause collisions, for example,
ff0e::1 and ff0e:1234::1 are both mapped to the multicast MAC
33:33:00:00:00:01.

Multicast router port will take a reference once, and will be marked as
'mrouter', then when port in the list is multicast router and its
reference value is one, it means that the entry can be removed in case
that there are no other ports which are not multicast routers. For that,
maintain a counter per MDB entry to count ports in the list, which were
added to the multicast group, and not because they are multicast routers.
When this counter is zero, the entry can be removed.

Add mlxsw_sp_mdb_entry_port_{get,put}() for regular ports and
mlxsw_sp_mdb_entry_mrouter_port_{get,put}() for multicast router ports.
Call PGT API to add or remove port from PGT entry when port is first added
or removed, according to the reference counting.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 153 ++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 617ec3312fd8..d1b0eddad504 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -113,10 +113,19 @@ struct mlxsw_sp_mdb_entry {
 	struct rhash_head ht_node;
 	struct mlxsw_sp_mdb_entry_key key;
 	u16 mid;
+	struct list_head ports_list;
+	u16 ports_count;
 	bool in_hw;
 	unsigned long *ports_in_mid; /* bits array */
 };
 
+struct mlxsw_sp_mdb_entry_port {
+	struct list_head list; /* Member of 'ports_list'. */
+	u16 local_port;
+	refcount_t refcount;
+	bool mrouter;
+};
+
 static const struct rhashtable_params mlxsw_sp_mdb_ht_params = {
 	.key_offset = offsetof(struct mlxsw_sp_mdb_entry, key),
 	.head_offset = offsetof(struct mlxsw_sp_mdb_entry, ht_node),
@@ -995,6 +1004,150 @@ static int mlxsw_sp_smid_router_port_set(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
+static struct mlxsw_sp_mdb_entry_port *
+mlxsw_sp_mdb_entry_port_lookup(struct mlxsw_sp_mdb_entry *mdb_entry,
+			       u16 local_port)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+
+	list_for_each_entry(mdb_entry_port, &mdb_entry->ports_list, list) {
+		if (mdb_entry_port->local_port == local_port)
+			return mdb_entry_port;
+	}
+
+	return NULL;
+}
+
+static __always_unused struct mlxsw_sp_mdb_entry_port *
+mlxsw_sp_mdb_entry_port_get(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_mdb_entry *mdb_entry,
+			    u16 local_port)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+	int err;
+
+	mdb_entry_port = mlxsw_sp_mdb_entry_port_lookup(mdb_entry, local_port);
+	if (mdb_entry_port) {
+		if (mdb_entry_port->mrouter &&
+		    refcount_read(&mdb_entry_port->refcount) == 1)
+			mdb_entry->ports_count++;
+
+		refcount_inc(&mdb_entry_port->refcount);
+		return mdb_entry_port;
+	}
+
+	err = mlxsw_sp_pgt_entry_port_set(mlxsw_sp, mdb_entry->mid,
+					  mdb_entry->key.fid, local_port, true);
+	if (err)
+		return ERR_PTR(err);
+
+	mdb_entry_port = kzalloc(sizeof(*mdb_entry_port), GFP_KERNEL);
+	if (!mdb_entry_port) {
+		err = -ENOMEM;
+		goto err_mdb_entry_port_alloc;
+	}
+
+	mdb_entry_port->local_port = local_port;
+	refcount_set(&mdb_entry_port->refcount, 1);
+	list_add(&mdb_entry_port->list, &mdb_entry->ports_list);
+	mdb_entry->ports_count++;
+
+	return mdb_entry_port;
+
+err_mdb_entry_port_alloc:
+	mlxsw_sp_pgt_entry_port_set(mlxsw_sp, mdb_entry->mid,
+				    mdb_entry->key.fid, local_port, false);
+	return ERR_PTR(err);
+}
+
+static __always_unused void
+mlxsw_sp_mdb_entry_port_put(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_mdb_entry *mdb_entry,
+			    u16 local_port, bool force)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+
+	mdb_entry_port = mlxsw_sp_mdb_entry_port_lookup(mdb_entry, local_port);
+	if (!mdb_entry_port)
+		return;
+
+	if (!force && !refcount_dec_and_test(&mdb_entry_port->refcount)) {
+		if (mdb_entry_port->mrouter &&
+		    refcount_read(&mdb_entry_port->refcount) == 1)
+			mdb_entry->ports_count--;
+		return;
+	}
+
+	mdb_entry->ports_count--;
+	list_del(&mdb_entry_port->list);
+	kfree(mdb_entry_port);
+	mlxsw_sp_pgt_entry_port_set(mlxsw_sp, mdb_entry->mid,
+				    mdb_entry->key.fid, local_port, false);
+}
+
+static __always_unused struct mlxsw_sp_mdb_entry_port *
+mlxsw_sp_mdb_entry_mrouter_port_get(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_mdb_entry *mdb_entry,
+				    u16 local_port)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+	int err;
+
+	mdb_entry_port = mlxsw_sp_mdb_entry_port_lookup(mdb_entry, local_port);
+	if (mdb_entry_port) {
+		if (!mdb_entry_port->mrouter)
+			refcount_inc(&mdb_entry_port->refcount);
+		return mdb_entry_port;
+	}
+
+	err = mlxsw_sp_pgt_entry_port_set(mlxsw_sp, mdb_entry->mid,
+					  mdb_entry->key.fid, local_port, true);
+	if (err)
+		return ERR_PTR(err);
+
+	mdb_entry_port = kzalloc(sizeof(*mdb_entry_port), GFP_KERNEL);
+	if (!mdb_entry_port) {
+		err = -ENOMEM;
+		goto err_mdb_entry_port_alloc;
+	}
+
+	mdb_entry_port->local_port = local_port;
+	refcount_set(&mdb_entry_port->refcount, 1);
+	mdb_entry_port->mrouter = true;
+	list_add(&mdb_entry_port->list, &mdb_entry->ports_list);
+
+	return mdb_entry_port;
+
+err_mdb_entry_port_alloc:
+	mlxsw_sp_pgt_entry_port_set(mlxsw_sp, mdb_entry->mid,
+				    mdb_entry->key.fid, local_port, false);
+	return ERR_PTR(err);
+}
+
+static __always_unused void
+mlxsw_sp_mdb_entry_mrouter_port_put(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_mdb_entry *mdb_entry,
+				    u16 local_port)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+
+	mdb_entry_port = mlxsw_sp_mdb_entry_port_lookup(mdb_entry, local_port);
+	if (!mdb_entry_port)
+		return;
+
+	if (!mdb_entry_port->mrouter)
+		return;
+
+	mdb_entry_port->mrouter = false;
+	if (!refcount_dec_and_test(&mdb_entry_port->refcount))
+		return;
+
+	list_del(&mdb_entry_port->list);
+	kfree(mdb_entry_port);
+	mlxsw_sp_pgt_entry_port_set(mlxsw_sp, mdb_entry->mid,
+				    mdb_entry->key.fid, local_port, false);
+}
+
 static void
 mlxsw_sp_bridge_mrouter_update_mdb(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_bridge_device *bridge_device,
-- 
2.36.1

