Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2855FC49
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiF2JlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiF2JlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:41:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC02C39812
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThbrW1xQsHaEzEenVp36gMmPLnjlDUTYe5TBNm7uU+sJsieLRl2d44pwzplSa8zvLmFFs1XwQJ4Way0GRzuXHU9pKueHtKLL60cGdBYqyQfACDvFwBkqNbI1fPAg8iuXSBW81OMFM6pC8DORVUc81m55dMpPcL7BJ0S7h3I1zLXkEjbxF+LxVETARl99A2yogcsYM3DfVPK4uSzEj3EZq4+Kly3J7NteOUd0QTt7lUsST/1CczZYbKfh1pWKtjgEvGJ/YPWv/DInkOR26LGuO+jr8BpvgTbSbSc8J3TZyoPoCp8s19CbXz85rfN+CTZR2jv1PEXkyUytPuSl7MeJdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrMIKiP0+kRRZu6V9vd/QbLBd1YDMCsDGHFv5Tp5bTU=;
 b=oJlnS8tJAHeGYHsDxSBbv4IHGMmkk68uAUnyptq61Dg4c6g/1seq/jp6YYZzVDUeuqzNkbUmEZcNoauHJEZbYnGcyIvV1LNiWc2/DLo2vRLLp/WHbIoa6c6EunPta+0tp9rqEFhM9c1Quc7+Pirvqu9YDQDQVa/5a1+55fXdDiB3E9FzAGnzHygpuJhMP0nnscsBPCj7LdvvRyP374UyFD0z3LylmlLB2BXFAnjnxxJVp/0hIrZ7/6YCh0Iqd52shYMSq09/48UH79+l4felV++349KG9R+cMs01k2Oamc7XVlJHOzAQBvpBbBoy60oI7gSlWLoEIBf5LyLOh6RZFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrMIKiP0+kRRZu6V9vd/QbLBd1YDMCsDGHFv5Tp5bTU=;
 b=RrS+Pl5ZkNvhjugyil8i5UWGqNnUxI3eymPQzmjcgf5VgDP3gVVDinKVdj5Jp+tq1N6INJpRDGvk2vl8Ol56lK2yt8rw9BY7nHIQF4maxbYtKHsYILZmCLaIDGcmlAdH2DsQCD252m4GS297p5rMNN3uURXVyl5NHyTE9V6O7zJ9Z9oPw2boggRipit/XteMnHDNEVQBHE+tpifXACayrJxC/EtH1Q3owVLiiyO8r5pCLS8EJ2AFOER6IDb4k1I5FlKjMVZqBPAeCgemeFtPnVuHrBP8umJqjT0VDibWLzVZvyzYz4Q2Ut95+kxO2cyQh1cXrAwxWHPni09AFo+x0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3850.namprd12.prod.outlook.com (2603:10b6:5:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 09:40:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 09:40:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum_switchdev: Add support for maintaining hash table of MDB entries
Date:   Wed, 29 Jun 2022 12:40:02 +0300
Message-Id: <20220629094007.827621-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220629094007.827621-1-idosch@nvidia.com>
References: <20220629094007.827621-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0090.eurprd04.prod.outlook.com
 (2603:10a6:803:64::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 383805c2-76a7-414e-a537-08da59b37866
X-MS-TrafficTypeDiagnostic: DM6PR12MB3850:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9GRFz+1rMerdGU5XQvgd0PldYd9Q6BRvmQvMCgGET0ZGx0Cp9JEw2N8t6wvdHqAsV7+rGIbMaUnxooes61P2ACmJuLkxsf9UE5hx5Yupo4l9o7QvvdAbAF8l5BmyvukwE4b3ng+mv5mGUpmUCpDArWFDja8yxEaIp/Q7elq1urpdZluEvJ3vg5QZZ930Fny2l+HrY6mWSecbpwLdfVUOJlrc/pjWHbqFM1Ac3ULfWbA8EPzUr8fxnAFk+LIOE0p69XlYz7OS0QzkFqBneqL6LnS3ragaovtum1uk/3zv5e0GjG1LeNUSCz+na/n2G01fRt3RpuRz8OQcAqF7bht0mVaoeaUgQCh324d2b/ke4Ju8YZCWaEqh+XNVtfvppTUceF4p8fLMr0bfgQOe8apJuiouPkX9FB+0g+mHhC44scaTyFBBtFCyrdX+cQtApJ8mh+pjOTtRIrURGX8SgQ7P7je9OXnruhTzjykrGHz7+cJoblbgTaRiIflkmviC1arfr9v91FAcGai9daz2SwLf6vSeF3eLIl+zTloihxpvkBw2eUIc4tKPggKqMT21HJOnPksBROnHEbsYpr8rYb/39eqANpcVY4lGw6pSi+v9ioyUA5B833IDIdD3RWLFRWCUtlz/U+hp0RLkerVPKeWMRyPDiHiyi+SUreU/hJnztV3+6ci1QaiJ2YYxbGslfHrxamXlkrAgD4VtLmw7ZPpGfEaEHRCgZemdqMVxTE265HXmE3K5OT5rhJPpoMxP7d9Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6506007)(2906002)(6512007)(26005)(38100700002)(6666004)(186003)(1076003)(107886003)(6916009)(41300700001)(2616005)(66556008)(66476007)(8936002)(4326008)(8676002)(36756003)(6486002)(478600001)(66946007)(86362001)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nRwbo4m65bmBcIANrTsjEeMnqam1iQ/SgaENo4PHSsbAhriZaILhIfDkgr5V?=
 =?us-ascii?Q?YD9kwz+op9/Wj/tNjxU65CTL1OfgBJjXBl9cTYjiBvBJHtaH5Ty6cAogXMGA?=
 =?us-ascii?Q?u5qFfDPnR1hLtIY/9x1shMAeLVR0pIAJDtxxuD6QtXF5XyWhh21gZDqtmmue?=
 =?us-ascii?Q?NpTlNm6cCb2RlPR/60Bzd65glHmXRGkrl10YKPSpIEfhQptqsUoE6DAiRAI3?=
 =?us-ascii?Q?cv08LWGVPcAE871nFhoHkX+9khPt+Yq3anN0rwb+p5C3Snev6xUr9FW4/01l?=
 =?us-ascii?Q?sSlENMwxAu4KK2WXi6cSPBI2RB65+u3cZn3h23O/6WXzMbklF0Qd4YTjLM3Q?=
 =?us-ascii?Q?d9p2PfeM0bXve5FEhdxzZimRy2Z7fwIJJ8tdIlIJHy467UHe+KPP++Ul+3Os?=
 =?us-ascii?Q?9mLB1Qhmqjk67tei5M/BUZDVyIV4wOkre5kRA+nIH12e9a0FoHMJSYaOVUR/?=
 =?us-ascii?Q?XZhW2OGW/qjVGZBaAgPqO/rW21XzrA5nl32Y3uvSfzpisxm0pJBIjYFHlLv2?=
 =?us-ascii?Q?zhLj7sVC6XablXntUznlya7MAWOxpiFo6uQeOCZq7hZNaoAAtbh2Re3vSAog?=
 =?us-ascii?Q?unfGo1n407rqgoqO9EQwRIM4M0jouKOJD1p8hHrZ6Hw9VW9Su1SgZbdX6BLK?=
 =?us-ascii?Q?lO9yUR8/W2P1NYPSZIuAUG+3po/n1IZLg1hEwrqV1jzRhhMzZDGulkPzpfP/?=
 =?us-ascii?Q?p7jQ5Ph9y4Y62Bkdz0Mr0/o9vOAfQs5D5Q9hwpGBH6OnCfNVi/XiHjD55sTD?=
 =?us-ascii?Q?Po9Kjs+OQIV+GRcdsAi6XT+Nfn9TJzHRB5G6NShh68TzHuxIsSd8pCgCpzUX?=
 =?us-ascii?Q?YX3xekihlfoA7hzRPE+1HnXYDknvYLpqaJaM0DWNXfXA9z68Z4/Gx8QCUI6/?=
 =?us-ascii?Q?d1lF57xibUmOFgH+7IHwakseJ9LcyD4N381zPP5raPMZtgSnHm5z/QSpntBT?=
 =?us-ascii?Q?AJ2Bu+aSbcEqaYL80Aa+LG03HHlD4ciHdQCfFq74uRelzq8nVVZcnKL9mvOe?=
 =?us-ascii?Q?0gwqrqnApjx9d8YmlwzpcobqbQ42MLVBVPv1mv+IFQZ+jE9zzMv+CDkEXAvq?=
 =?us-ascii?Q?na44DLmCP1SPMMnWluoyYSkNfhQVdDEep2m6s+hijJr+GmPfWFXKBdF4pF66?=
 =?us-ascii?Q?breLyPWcrpcF077FBWLIjz+q4GJ7NHBNIp6AZ4F621c9RkmRG5KJ1ncLA8IL?=
 =?us-ascii?Q?YIzgXoJ2gIufPY23wYE2cI1p1UB5RySdf7YkvjPf0Dn5I0O4CsCsLyQrEUCH?=
 =?us-ascii?Q?3vu3DNKZ2ZVlOv8fVWNu+rdKL37o/yWhTncgCp3CmL8c1pzNNIKb2Z8yZt+7?=
 =?us-ascii?Q?6d9Q2nl8Cm67KoL9zlQKbhcgz/l1BLpp3LFrTB7XBCT+frW3/9DE+1GCDS4d?=
 =?us-ascii?Q?U5frMkrlvZF5aIg7X8fKEGO5WKq7blwt/OdyeW5N6r6t+oxUcqbljquItty2?=
 =?us-ascii?Q?V444mz7I+hcBGdOa20DRvgQt02NZpcHhP21r0Unta6ED803YcZI97I60/Ke8?=
 =?us-ascii?Q?q0FekhB/H/7GILTDHYrRX3cnlaVXvhnpQl1c8SebuiQUl9CYd22XTs/K8FV9?=
 =?us-ascii?Q?nZSSvPRU9mpMtNP/o/TFxHrTR8lYj9EM4ORgng4A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383805c2-76a7-414e-a537-08da59b37866
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 09:40:58.1294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBZO/LueXlL2j/LR4jMoFx6/OpypF/0VA+meX9TCLZlagNMk9RzkyvmPI9UC4hvoe8ARGLy5Hlkx9oR7CrBpEQ==
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

Currently MDB entries are stored in a list as part of
'struct mlxsw_sp_bridge_device'. Storing them in a hash table in
addition to the list will allow finding a specific entry more efficiently.

Add support for the required hash table, the next patches will insert
and remove MDB entries from the table. The existing code which adds and
removes entries will be removed and replaced by new code in the next
patches, so there is no point to adjust the existing code.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index d1a1d55b0068..617ec3312fd8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -49,6 +49,7 @@ struct mlxsw_sp_bridge_device {
 	struct list_head list;
 	struct list_head ports_list;
 	struct list_head mdb_list;
+	struct rhashtable mdb_ht;
 	u8 vlan_enabled:1,
 	   multicast_enabled:1,
 	   mrouter:1;
@@ -109,12 +110,19 @@ struct mlxsw_sp_mdb_entry_key {
 
 struct mlxsw_sp_mdb_entry {
 	struct list_head list;
+	struct rhash_head ht_node;
 	struct mlxsw_sp_mdb_entry_key key;
 	u16 mid;
 	bool in_hw;
 	unsigned long *ports_in_mid; /* bits array */
 };
 
+static const struct rhashtable_params mlxsw_sp_mdb_ht_params = {
+	.key_offset = offsetof(struct mlxsw_sp_mdb_entry, key),
+	.head_offset = offsetof(struct mlxsw_sp_mdb_entry, ht_node),
+	.key_len = sizeof(struct mlxsw_sp_mdb_entry_key),
+};
+
 static int
 mlxsw_sp_bridge_port_fdb_flush(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_bridge_port *bridge_port,
@@ -250,6 +258,10 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 	if (!bridge_device)
 		return ERR_PTR(-ENOMEM);
 
+	err = rhashtable_init(&bridge_device->mdb_ht, &mlxsw_sp_mdb_ht_params);
+	if (err)
+		goto err_mdb_rhashtable_init;
+
 	bridge_device->dev = br_dev;
 	bridge_device->vlan_enabled = vlan_enabled;
 	bridge_device->multicast_enabled = br_multicast_enabled(br_dev);
@@ -287,6 +299,8 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 	list_del(&bridge_device->list);
 	if (bridge_device->vlan_enabled)
 		bridge->vlan_enabled_exists = false;
+	rhashtable_destroy(&bridge_device->mdb_ht);
+err_mdb_rhashtable_init:
 	kfree(bridge_device);
 	return ERR_PTR(err);
 }
@@ -305,6 +319,7 @@ mlxsw_sp_bridge_device_destroy(struct mlxsw_sp_bridge *bridge,
 		bridge->vlan_enabled_exists = false;
 	WARN_ON(!list_empty(&bridge_device->ports_list));
 	WARN_ON(!list_empty(&bridge_device->mdb_list));
+	rhashtable_destroy(&bridge_device->mdb_ht);
 	kfree(bridge_device);
 }
 
-- 
2.36.1

