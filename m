Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0D55FC43
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiF2Jl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiF2JlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:41:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE6B3BA5A
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGczNdi5uaUCIRX5RbfuFsekEOKcLx37rG6jG+IQhEe3WqPlBH83PZEjzz8o01VYaNeQIycssb804em6ntrVYnUqKMONGcIaUNP6nB/thWbnSmU60sj5UOwfAzlq3DfdrUpSfgN0afeqCKFTEaHfb00yMgyd2KRgdnCR1WC+1knflDOZYYmKswQ3pzkJvPD1pF/BhVQSdV8Djh1ckfVWzcLcUuLvmJxz9BQiqFEj7lVMhZAe9hhXKSf3SSFe90hynS4iC2DTYYg3sbtqvH+NfsFSYGI6fnQCQj2Z2sCgOpTkHcxKUsNFDVXeRSQvDCvrkPFsxw07T5lZreVPBWZ8vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=own8Mj9/2MIG7rUYJSP0lBpFtKd4NRplV1J+RPjI/vY=;
 b=KBGasaK1aqBM1UacsMmp+9zvyzbSs079WjXMcPLYXZIzik+tn4YenkjFdQWRTjBTV7qjkrUy/gsfhZtJ4mkYllO/JOZTmGjZNoRq0aU99RWdHwmETYIeTJfGDOzEt326YqTT39qdvH/L3v+VYmQDsE16n8jps4s92wdWPmYs3VRAeEsp6DaXNPlia5/Tv+YXJ5xFwA4Dnyi0jXccPTpshG5qkWZJfobtthISpAmyUBxPoHLZVlyJjbPHVsHCRoupu2XQ0AUmcQf8wqfudloEW+H06xCRtESjwYVzL16WYouAL/0Tf+E7HB1zYSSXlkfkcPJ6DQuGCqtzvbIjqr4LtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=own8Mj9/2MIG7rUYJSP0lBpFtKd4NRplV1J+RPjI/vY=;
 b=s9w/ncCU2Q2ruGKTikvXrF+njTJcZ61NEa64+pJ4Vv61OIB4cQ9SzyDThXacLG/lJPeVV6UKdncXJdLN8EG447fC34ZAWMQivK+1YWAMX6C+jSIMa8ID43mIv9RedkwzTeDBSG0LUKjqFDO4IEifnNyNuAGlRl8QPwOKPy2yH85GpxfAVlwL+XP8+5ZdtgC3LnLKGVmUq1WIxW4WeuUF3wCYDD5detotHwIBYD9o4uYV4PcDHELV7axuWm7le18AGRw6F0b6kwsOFpg2Rlx1JdfrFr0FsgZIVePGBt3vuBf4NtjByR3kNuE4DCyAShPpkYl13dtWBmLnbhryY/w+gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:41:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:41:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum_switchdev: Add support for getting and putting MDB entry
Date:   Wed, 29 Jun 2022 12:40:05 +0300
Message-Id: <20220629094007.827621-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0029.eurprd03.prod.outlook.com
 (2603:10a6:803:118::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c90c979-ab7b-4a6d-5578-08da59b38789
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mc6TrJu6lT8NLa4aAzJkESpbqqrGTNfq4aXOPr4yRXA2tf0DSKiWHDwKOP/c8wO8pi5Xpd3vM3+heD7ejZu1i5Sv/j8O5NKrQZL/AlIi87q4fWtdiztH2fyYRBdHxAvLsiZL4NVl+/IyYezcrkh703FPluZXeCR328WNXufNkuPhMt0NSH3lGECe27Bia1973rU7XJbNb6Ps2ZV3z1RNG0iEd4+bBvZRErlP4R8ffThJ4wtRgIgd6IlHz/j+aM9PZMqeCbCm+Uf3jLfVQA0lXG2KRpY4yjI2jecRw7exP9uWFLelSEehJFQU6q4oINr2Q6xrCqxxKgKHfU2QB6vN4NPz35mYvy+Om64fOswju670mYNbN8BiCZ8uKrP1BZ11PdMl3W4IUkcr93KOIpbBFE68YWOHWJWsiqgNN3UUK5A38jBu0Z33ZcDU7+LvA53e3Ushe02Nz6rLcjWDWKnCb5y7gbe4T6NpQeDwQpaNnFfG4Xjw2oZrW7gheMqz4wLlEzB4H4WH2RR/CAuRyPvqUfm4H7ANNs190E2SIubP6e4hKqpGZhk+53F3phKWIj9sTer5F3KRqef0d0uScK2kPc4GQOX0BSOOIdxyoZzyap/dR5QntLeUdWVJqgg+sjAXbnQJ/acx7v8XG1/QuYgJzigJuX7+VzzzdRXkgA9Ow51W2r3LrlbUk/+z05vUPOFF+sGF3Z8bOXVghlwc383XgkwgPGgdlolzNo22yeFeJyvNb+cLcho9sE+ET+5FDb2n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(66574015)(186003)(1076003)(107886003)(6916009)(83380400001)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fXqHdaTFEPggVvf1d4cs9Ap6WhqDXGMLJRo4aqez9cisG4H9yJrD9ntSO2P6?=
 =?us-ascii?Q?KkfalE1R7D31uiUaPxSSfUABCV3DIETrsH9rH5MH8jWKbrSLUYUETo3gLazZ?=
 =?us-ascii?Q?+fIctT143JhT+a7VTAkvtkjtYXZeIXKIi2dQiZZcnDg19J42VhRlndtdYyKJ?=
 =?us-ascii?Q?XQz+lqguOUhiOc1EJyCm8cS7iBiUUv4x2+lYLzSSRyzR2SPXoULUnHY+HlOd?=
 =?us-ascii?Q?sH1Z1sFNXJt/1Q4w+2dFIK6yyRf7ivYlcexIR7kNJcdjpVqLZXxrra893lNI?=
 =?us-ascii?Q?vJxE+LWSZar2MsUc8JV0EzJ4MSWME6QT94sJ75FueSTT2i9QzO9BzvrPBqXo?=
 =?us-ascii?Q?b8zQV0T7xxwYwhjvocpRVC5A2C6cvVYI30B0lcEm5IX7PcEzg38Q3SO88hr1?=
 =?us-ascii?Q?EpAhhV1CUzOYjTt/g1IXQ/urgjhL0RyG3ldM5KqGlFiMKUlCELR3+4uWwK0p?=
 =?us-ascii?Q?X1NhjqQ2E6oeSZ4XpK8/a4fg/kWUhw5tY1No1T82KI3+5RjNCdvvw+h0nBgx?=
 =?us-ascii?Q?TCTkxN98KP+c14WwOzS8IM4PTL2jWJSo/ndawcRJkZOfrk+9rrKnhPUoMqLx?=
 =?us-ascii?Q?+z5Mv+Tp2R5TuwCSYURuVYINpGg8h9avvGLs4Vt8Sk0xjWCGcRC9bqQFgW/b?=
 =?us-ascii?Q?SmglZZLifrmjic9wGCOrBRc8Q6fUnk+5eSNvFI5qEQr1p2WK/UjyBk0wGsTQ?=
 =?us-ascii?Q?4vm2wa5hWOio/mi8MgyD5mCvRWRkCvhiM+uRYOMZ57KTH155KYwbmgquDlpu?=
 =?us-ascii?Q?bJ2UcCNpTjWVoNyEqyU1jKUEXeqD/DFCGLgj038IBFQh4BMCj6UlsSr5NKmz?=
 =?us-ascii?Q?DwbF1yur8lkDF85tBt9xWXusajyvThdxbQvW2Gm3yVEtMveDl076MDbGBMLu?=
 =?us-ascii?Q?UATUL1Qxe2YyyKQ/gFwPZHk0h9iddpDRqZOd7RXrtX6wCo1aAY4Et+/x8Pwl?=
 =?us-ascii?Q?lf7+pm8bGlwk2ehIJFQR51ZFoApd4v5BQZofdm2lrPFTDRkTC01lGeeVFsLL?=
 =?us-ascii?Q?pzATNw2OLVD730bi4h+99CKY1RhS/3PZlV+au/tc3NhU/PbEmdHT669/HNJq?=
 =?us-ascii?Q?bbfHrafUttddRnSw4DYBYIga6N1z8JzrZonFPfMsfygNg1vQxenYTpFmmPOq?=
 =?us-ascii?Q?ZuJFMP21xhj3+4NUBPwaaqG9Iwi2uzD22WvaEcMJpCKZr6JIVaQC1fhZv3nV?=
 =?us-ascii?Q?ITpD+JqCJgRHFb2/92+fIorx4+6Ye8bQlMjlXT2eQDI/NG5Hup55ckUtKR6g?=
 =?us-ascii?Q?ygfGJfsP2pMAAEv59sSrDsDGm3aiNpWYUwYggHiclJ42EU/546AYFEVFDFRV?=
 =?us-ascii?Q?xZs966vIQQS+b0V5hlgsK/YFglXPU75dkQ4H2siE+CpQgTcjsDiQacVPGVul?=
 =?us-ascii?Q?J9Ee+9n9t8ZEHYnrxqaPLEufxZ2OwnaPnnCySuurrB3j4/Y2kuRx7AYKHxv+?=
 =?us-ascii?Q?lCF0e+Fy82puTa3dF40/C1Iinm8364m2oc8yY5801iXKYbp3/pqOniP7U0zE?=
 =?us-ascii?Q?nIjEZMtL2BcviqzLWbsSHcSnqEHvzRoUeXOn5F8GX2hqEMGpFSAn6E6zjn/J?=
 =?us-ascii?Q?zGxkw9OMVjsPYP1bVJxFzVYbfiZheHLgO2z62SYm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c90c979-ab7b-4a6d-5578-08da59b38789
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:41:23.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7LVK/iGS19fzL4VASe7ptXKk7L5bk/txjMBLqMKounFFVQ3NZ2KwTDtKZLxfxdOhGGdnerfyn7M8WY/ACxo2IQ==
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

A previous patch added support for init() and fini() for MDB entries. MDB
entry can be updated, ports can be added and removed from the entry. Add
get() and put() functions, the first one checks if the entry already exists
and otherwise initializes the entry. The second removes the entry just in
case that there are no more ports in this entry.

Use the list of the ports which was added in a previous patch. When the
list contains only one port which is not multicast router, and this port
is removed, the MDB entry can be removed. Use
'struct mlxsw_sp_mdb_entry.ports_count' to know how many ports use the
entry, regardless the use of multicast router ports.

When mlxsw_sp_mc_mdb_entry_put() is called with specific port which
supposed to be removed, check if the removal will cause a deletion of
the entry. If this is the case, call mlxsw_sp_mc_mdb_entry_fini() which
first deletes the MDB entry and then releases the PGT entry, to avoid a
temporary situation in which the MDB entry points to an empty PGT entry,
as otherwise packets will be temporarily dropped instead of being flooded.

The new functions will be used in the next patches.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 80 ++++++++++++++++++-
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index bb2694ef6220..5f8136a8db13 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2131,7 +2131,7 @@ mlxsw_sp_mc_mdb_mrouters_set(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static __always_unused struct mlxsw_sp_mdb_entry *
+static struct mlxsw_sp_mdb_entry *
 mlxsw_sp_mc_mdb_entry_init(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_bridge_device *bridge_device,
 			   const unsigned char *addr, u16 fid, u16 local_port)
@@ -2194,7 +2194,7 @@ mlxsw_sp_mc_mdb_entry_init(struct mlxsw_sp *mlxsw_sp,
 	return ERR_PTR(err);
 }
 
-static __always_unused void
+static void
 mlxsw_sp_mc_mdb_entry_fini(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_mdb_entry *mdb_entry,
 			   struct mlxsw_sp_bridge_device *bridge_device,
@@ -2212,6 +2212,82 @@ mlxsw_sp_mc_mdb_entry_fini(struct mlxsw_sp *mlxsw_sp,
 	kfree(mdb_entry);
 }
 
+static __always_unused struct mlxsw_sp_mdb_entry *
+mlxsw_sp_mc_mdb_entry_get(struct mlxsw_sp *mlxsw_sp,
+			  struct mlxsw_sp_bridge_device *bridge_device,
+			  const unsigned char *addr, u16 fid, u16 local_port)
+{
+	struct mlxsw_sp_mdb_entry_key key = {};
+	struct mlxsw_sp_mdb_entry *mdb_entry;
+
+	ether_addr_copy(key.addr, addr);
+	key.fid = fid;
+	mdb_entry = rhashtable_lookup_fast(&bridge_device->mdb_ht, &key,
+					   mlxsw_sp_mdb_ht_params);
+	if (mdb_entry) {
+		struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+
+		mdb_entry_port = mlxsw_sp_mdb_entry_port_get(mlxsw_sp,
+							     mdb_entry,
+							     local_port);
+		if (IS_ERR(mdb_entry_port))
+			return ERR_CAST(mdb_entry_port);
+
+		return mdb_entry;
+	}
+
+	return mlxsw_sp_mc_mdb_entry_init(mlxsw_sp, bridge_device, addr, fid,
+					  local_port);
+}
+
+static bool
+mlxsw_sp_mc_mdb_entry_remove(struct mlxsw_sp_mdb_entry *mdb_entry,
+			     struct mlxsw_sp_mdb_entry_port *removed_entry_port,
+			     bool force)
+{
+	if (mdb_entry->ports_count > 1)
+		return false;
+
+	if (force)
+		return true;
+
+	if (!removed_entry_port->mrouter &&
+	    refcount_read(&removed_entry_port->refcount) > 1)
+		return false;
+
+	if (removed_entry_port->mrouter &&
+	    refcount_read(&removed_entry_port->refcount) > 2)
+		return false;
+
+	return true;
+}
+
+static __always_unused void
+mlxsw_sp_mc_mdb_entry_put(struct mlxsw_sp *mlxsw_sp,
+			  struct mlxsw_sp_bridge_device *bridge_device,
+			  struct mlxsw_sp_mdb_entry *mdb_entry, u16 local_port,
+			  bool force)
+{
+	struct mlxsw_sp_mdb_entry_port *mdb_entry_port;
+
+	mdb_entry_port = mlxsw_sp_mdb_entry_port_lookup(mdb_entry, local_port);
+	if (!mdb_entry_port)
+		return;
+
+	/* Avoid a temporary situation in which the MDB entry points to an empty
+	 * PGT entry, as otherwise packets will be temporarily dropped instead
+	 * of being flooded. Instead, in this situation, call
+	 * mlxsw_sp_mc_mdb_entry_fini(), which first deletes the MDB entry and
+	 * then releases the PGT entry.
+	 */
+	if (mlxsw_sp_mc_mdb_entry_remove(mdb_entry, mdb_entry_port, force))
+		mlxsw_sp_mc_mdb_entry_fini(mlxsw_sp, mdb_entry, bridge_device,
+					   local_port, force);
+	else
+		mlxsw_sp_mdb_entry_port_put(mlxsw_sp, mdb_entry, local_port,
+					    force);
+}
+
 static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 				 const struct switchdev_obj_port_mdb *mdb)
 {
-- 
2.36.1

