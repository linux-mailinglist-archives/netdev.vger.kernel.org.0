Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34CD564D94
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiGDGNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiGDGNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:51 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E182A6336
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiRKC0vn2tF9O/sAz3R7seiQLgZpP7tX6KJWOwgRTObH4LVHDK9HRUtwJDY59G2pvFXhvm9Vi0B5IYcuVzJiaGTePc9IPlHlVwhHdiaxMGM2IMSkv8cUBkBsa6+Ia7Eu72XGy6X/t3NJLx9Hk+GfmvIHCdeW/3aOmV7gUYI44GUGy8rxuSJQbvmjvYj1AFaOc7jpp8R5bQsKAJR43kQB4ZPci+MEzv8YJ/NscfGAGjMf8TYqAovgHHLTm5wFqv72Lk6IO1vXVoi48VXwQ3fR90OtM0YqnZbdgEWxgtt/TpcJ6BiboZRn7mSo8L99XagtYpGojk5kbNUA/QC/ZHFDVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyRskEfZK0YuJy7KV/OaxIbV00lTh2jHHThWtumQbDQ=;
 b=dlgVCNR+KoeSwDrtVxgcJzUuMITaGqsZbWnDUasqi8w41uKmiEuUIUfuosH4SVkXFq+E6cUUXYavBsHUd5FVoawTU9FZSA1i2ZxfW5uyhtrhwhCT8K85IcDLY5RtIXOlUAW1RjbhhhzPrso93LeuqrLi7zc9fcCnQ28f4rQrj4o60Nsrs4ERN4w3EdE5eKGHTJXNghkQjshT9v0c1mGSSGEMFd99eJXIsWGLXwGE3hJWYBd3EyQVhy8mWLKxGw5exmonqXugCrmKtbGrxiC5+qSsZDF2S941u9KbWLd7NVh96cBivnvzs0GcLcaCu7kxs125QZRTQrBA2Eo1jwfkgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyRskEfZK0YuJy7KV/OaxIbV00lTh2jHHThWtumQbDQ=;
 b=iMgRsfokJoRSmFYegaX0jWwFKnv4BWMIZCDqRhio3ciEEMXrngsQJ2vaO6v5ny9JWEVIiUFD92dkA6O6GW67OqP6vdtiRdxNHuW/RdpTLiuNF3d0ZYZnck6ezDrVv7bZuXUVn8CY4f3WV5GvrZnVa7/gFsAsGya47lG8z3aY4NlvMsZSt+MBMw20SS94bsQ3zO1P6WtXYw6tR27NuMy9SF6zMOtRHBEYD4EroQfEG3+dBKl39MlcbJwYK4gs1kC8qwzZkGh9OIECbq4mPnTOAk/4dFxmLxZ6E5ijv5gSKU8QzoENYU7+EolEYsbtZ9xlJbLGo8F7LE/SP310YLJszg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1862.namprd12.prod.outlook.com (2603:10b6:903:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Mon, 4 Jul
 2022 06:13:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 09/13] mlxsw: Add support for 802.1Q FID family
Date:   Mon,  4 Jul 2022 09:11:35 +0300
Message-Id: <20220704061139.1208770-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52a8664b-4453-43ae-2772-08da5d845b51
X-MS-TrafficTypeDiagnostic: CY4PR12MB1862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGTjHPJOmGeW5M1LWNHNFRYvvK8x9bfibGAaAWAUUzHdgmC2pI6JYhzhZFD05ZgWbbsdjz1Q3M0zySAwWaBAt/ibNuEi/kqTXu7SBAKCkF3IKh3F32cSXoZBCDgrJYN9C0dNvWiPKnCVfp7lLOD9zO81SZ/SE7E9Dq1bk1Bn48S17Gb2BVVGsVSlJdzpEBz8DlHK39T58qxu3m71OErM61xLgitLH8hmKcfPqwlF6SgMZlr10Y/Pw3Pc/KCUFn6mMxlxBW5uZRAh7DAn+9MqiXHQiK4aNKCSrzua/B2OMpzdFjwJ4nKUB5kC6NbV0CzM32Ii4TFKBNABxMFWVc+dkVMwWTzbcMiLVH28UU1G/6HPr1jYnBczR+GN0WfZqTA+mTSi7TYTOQEDwkYKlNlpt0c1si+Ki9BfWsw6s36tTZYICA1p0O30EQlBwtmiRPZp02BaH2fLbnO7JY5krscZea3xpGR6cwUM1pFvUVfHR5jaVdbuQLDdh8LLZSwJcWrOtOrM+YuiaM5hYEyYhejLLLaaxEr5ayC/n2rMuSdSTyBtKkSyl182FokE9yTFaUBfH0g0IZsj7rgV4xaWTH7r2fZhkzv81ArVJxa5iWGWtiuHnX4rkN+66hg4KRDsBs4E7f2OHpTNt4peMlQ1AnuNwD7O0mW17ptwTjbZnUVAhYpNVkPHqS9fRmVjzXD5WDyCBv8hQjxnx3HoliVdKeKJNuOPSUHopbHK7Ysvaz85/eIedhFZLaz3xsXlNO6DsPA3YV8xMHHmTYP/71chj9hAmy770MotLiPjRel9EQckLXJpB5mPMIX9AJC7CpFN3OyB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(2616005)(38100700002)(66946007)(4326008)(8676002)(66476007)(66556008)(478600001)(6486002)(316002)(6916009)(26005)(6512007)(86362001)(41300700001)(6506007)(6666004)(8936002)(83380400001)(36756003)(66574015)(30864003)(2906002)(5660300002)(1076003)(107886003)(186003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sMoRlKKlu03ueFBaXiTWnXR5fEF86juIlcwcmlnfPfoQCOMqakYDg1w00++D?=
 =?us-ascii?Q?5BC0/3YD/Q2ZuMpBOnmIJRq9KkHomkiNcFgeFBy4ThWywiOKdKQb081L7tIM?=
 =?us-ascii?Q?vncH5mMfLfMSfZIH3xQUYXZ/5f1TqQFFVwveaafgKy+wvG4hQNpua2mVsX0N?=
 =?us-ascii?Q?JYqleiHVWfgSIkNXLU9rcSvcKfnC27VLjSSO7aoG9ldE81gJqnQuIF3a5fc7?=
 =?us-ascii?Q?6NEloDTAOXJZX1iY4y2kX8OpLoxbTg8Ih18Nyr6LzWMiUnHV+7suPlLzo643?=
 =?us-ascii?Q?gntuf58i8zdwOGW/HD7VL1FJ+DxERPQQm8SfpCQebDolkAIWyW9dCJiR5aUD?=
 =?us-ascii?Q?mFBxP2Y1363VIS1v4YpTvIESiumiwtuTXbmZilEGRyPcwoG6GHJuZFPk/Cu0?=
 =?us-ascii?Q?8UCaVy5s4sc+pH9yz4ShpNkKe7P3U548focJYgYSdHgzX2L0OIzovmUh8XLQ?=
 =?us-ascii?Q?KMy1ah8tWZzHDNh0XwbqL3+WleSu94Z91I0Un6CcoCCtmLEp8xCAHZXJutuA?=
 =?us-ascii?Q?LBbavp1qSZTtTuhSFq+pmXx2JtB1QPCR06JWecBcVJQVGzP4MK4/q7jE+SA1?=
 =?us-ascii?Q?+78L8lfmeVJVp+7e6MlaRuQv+pkkTZO0DEBFz8ZRJYCo7i5XgZQph8+B5jPT?=
 =?us-ascii?Q?u1ekRgxvnA1PgIsaZK4YzRoB7+HFpBrbGRGIhxORKGnQR1LeGVVPTtCqY+d6?=
 =?us-ascii?Q?7UTtRXgDMW5d/LVUVvc09UdGa35g1VylUSfsOz3GopGz0rxo8PaWAvzSj+tc?=
 =?us-ascii?Q?9c/OU+fRQ7BlZTShNmCOGV4KzN73d2JnkyUCAmwIduzY0fm0xlxqorwNo/w5?=
 =?us-ascii?Q?lJDT2uJVz1TJNlPt2eMtSmUr8P1UeIlV2LZgxZLbwFucC45Ixm3zrK819aoy?=
 =?us-ascii?Q?F8JB8h23soQW/ZNQG5gt9qbjubUdsupT/MqdlZVujJg2K70LS5SF5BPEwHNV?=
 =?us-ascii?Q?VlH+Ei/GYtg/NmaFqCLE5Iuz73u/SH2YknSR5SsQv4Tm39IdOb2r/32UCLyB?=
 =?us-ascii?Q?g7jkyzXVNrpgzqTWenmO/Wh/dUrht8UCz/StyoDGNRQnbKE771GERZuDahif?=
 =?us-ascii?Q?GCnI3zLGx9NVh7S7i2J+kHf8fjew7fnNgkqJoLM3J/TuDvRexuj4aTe3S5zC?=
 =?us-ascii?Q?+DN05+dkhcqp1QtHpSXluLTu82I/splYZ5S4R1ffx/P02DEZyfTmifYOfh+6?=
 =?us-ascii?Q?aA7tN6tvtcIaefoTdCJa2bCHiMjRaElaTyM6Xdwgv5uM7Fw1mXOLgUXVdrtc?=
 =?us-ascii?Q?ni/Fi5y875AAalrw+dmx54AzCwFGj1q8y7IFuupNWrbEyNJMt/puFgV8GkW5?=
 =?us-ascii?Q?L6TtktLC57kmjw6oj2EjOYcvYk7O65fTrKXlJ6RHo9JlDjxhAAjnvg9pUiPl?=
 =?us-ascii?Q?l4Z0feK1OfFgI/Ai2JMUq+sZbPYbj6axueEKmMcSU3QJqT91jLBtcLI9hvBi?=
 =?us-ascii?Q?kfmyDbiwIkWcpGw/x8rghT6w4VUcXK+yemwDeFNLx6e3Zwv4BtpNToFiIqz6?=
 =?us-ascii?Q?UdqXM+RBE6gajLxxPXRXQC+7uLKT47WJ9QSwP9MorAataNIGSQLTSpTS6xWr?=
 =?us-ascii?Q?dLOxNWTHUWNelEKbe/kCaCcCQrrEELcYICYqVVGy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a8664b-4453-43ae-2772-08da5d845b51
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:47.6395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ght/Y0eeBu5RkuTNql6Qu1pNQFpY96Q+IgEpTd7skAIdBq6IJe1iV2ZbmEW9X+jLFpluvdNImFQLQIxoJg/TvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1862
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Using the legacy bridge model, there is no VID classification at egress
for 802.1Q FIDs, which means that the VID is maintained.

This behavior cause the limitation that 802.1Q FIDs cannot work with VXLAN.
This limitation stems from the fact that a decapsulated VXLAN packet should
not contain a VLAN tag. If such a packet was to egress from a local port
using a 802.1Q FID, it would "maintain" its VLAN on egress, which is no
VLAN at all.

Currently 802.1Q FIDs are emulated in mlxsw driver using 802.1D FIDs. Using
unified bridge model, there is a FID->VID mapping, so it is possible to
stop emulating 802.1Q FIDs.

The main changes are:
1. Use 'SFGC.bridge_type' = 0, to separate between 802.1Q FIDs and
   802.1D FIDs.
2. Use VLAN RIF instead of the emulated one (VLAN_EMU which is emulated
   using FID RIF).
3. Create VID->FID mapping when the FID is created. Then when a new port
   is mapped to the FID, if it not in virtual mode, no new mapping is
   needed. Save the new port in 'port_vid_list', to be able to update a
   RIF in all {Port, VID}->FID mappings in case that the port will be in
   virtual mode later.
4. Add a dedicated operation function per FID family to update RIF for
   VID->FID mappings. For 802.1d and rFID families, just return. For
   802.1q family, handle the global mapping which is created for new 802.1q
   FID.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 192 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   3 +-
 2 files changed, 193 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 9dca74bbabb4..385deef75eed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -94,6 +94,8 @@ struct mlxsw_sp_fid_ops {
 	void (*nve_flood_index_clear)(struct mlxsw_sp_fid *fid);
 	void (*fdb_clear_offload)(const struct mlxsw_sp_fid *fid,
 				  const struct net_device *nve_dev);
+	int (*vid_to_fid_rif_update)(const struct mlxsw_sp_fid *fid,
+				     const struct mlxsw_sp_rif *rif);
 };
 
 struct mlxsw_sp_fid_family {
@@ -433,10 +435,15 @@ u16 mlxsw_sp_fid_8021q_vid(const struct mlxsw_sp_fid *fid)
 
 static void mlxsw_sp_fid_8021q_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	u16 vid = *(u16 *) arg;
 
 	mlxsw_sp_fid_8021q_fid(fid)->vid = vid;
-	fid->fid_offset = 0;
+
+	if (mlxsw_sp->ubridge)
+		fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
+	else
+		fid->fid_offset = 0;
 }
 
 static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
@@ -532,6 +539,35 @@ static int mlxsw_sp_fid_vni_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
 	return mlxsw_sp_fid_vni_to_fid_map(fid, rif, fid->vni_valid);
 }
 
+static int
+mlxsw_sp_fid_vid_to_fid_map(const struct mlxsw_sp_fid *fid, u16 vid, bool valid,
+			    const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char svfa_pl[MLXSW_REG_SVFA_LEN];
+	bool irif_valid;
+	u16 irif_index;
+
+	irif_valid = !!rif;
+	irif_index = rif ? mlxsw_sp_rif_index(rif) : 0;
+
+	mlxsw_reg_svfa_vid_pack(svfa_pl, valid, fid->fid_index, vid, irif_valid,
+				irif_index);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
+}
+
+static int
+mlxsw_sp_fid_8021q_vid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					 const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
+
+	/* Update the global VID => FID mapping we created when the FID was
+	 * configured.
+	 */
+	return mlxsw_sp_fid_vid_to_fid_map(fid, fid_8021q->vid, true, rif);
+}
+
 static int
 mlxsw_sp_fid_port_vid_to_fid_rif_update_one(const struct mlxsw_sp_fid *fid,
 					    struct mlxsw_sp_fid_port_vid *pv,
@@ -555,6 +591,10 @@ static int mlxsw_sp_fid_vid_to_fid_rif_set(const struct mlxsw_sp_fid *fid,
 	u16 irif_index;
 	int err;
 
+	err = fid->fid_family->ops->vid_to_fid_rif_update(fid, rif);
+	if (err)
+		return err;
+
 	irif_index = mlxsw_sp_rif_index(rif);
 
 	list_for_each_entry(pv, &fid->port_vid_list, list) {
@@ -582,6 +622,7 @@ static int mlxsw_sp_fid_vid_to_fid_rif_set(const struct mlxsw_sp_fid *fid,
 		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
 	}
 
+	fid->fid_family->ops->vid_to_fid_rif_update(fid, NULL);
 	return err;
 }
 
@@ -599,6 +640,8 @@ static void mlxsw_sp_fid_vid_to_fid_rif_unset(const struct mlxsw_sp_fid *fid)
 
 		mlxsw_sp_fid_port_vid_to_fid_rif_update_one(fid, pv, false, 0);
 	}
+
+	fid->fid_family->ops->vid_to_fid_rif_update(fid, NULL);
 }
 
 static int mlxsw_sp_fid_reiv_handle(struct mlxsw_sp_fid *fid, u16 rif_index,
@@ -1078,6 +1121,13 @@ mlxsw_sp_fid_8021d_fdb_clear_offload(const struct mlxsw_sp_fid *fid,
 	br_fdb_clear_offload(nve_dev, 0);
 }
 
+static int
+mlxsw_sp_fid_8021d_vid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					 const struct mlxsw_sp_rif *rif)
+{
+	return 0;
+}
+
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.setup			= mlxsw_sp_fid_8021d_setup,
 	.configure		= mlxsw_sp_fid_8021d_configure,
@@ -1092,6 +1142,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.nve_flood_index_set	= mlxsw_sp_fid_8021d_nve_flood_index_set,
 	.nve_flood_index_clear	= mlxsw_sp_fid_8021d_nve_flood_index_clear,
 	.fdb_clear_offload	= mlxsw_sp_fid_8021d_fdb_clear_offload,
+	.vid_to_fid_rif_update  = mlxsw_sp_fid_8021d_vid_to_fid_rif_update,
 };
 
 #define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
@@ -1341,6 +1392,13 @@ static void mlxsw_sp_fid_rfid_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 	WARN_ON_ONCE(1);
 }
 
+static int
+mlxsw_sp_fid_rfid_vid_to_fid_rif_update(const struct mlxsw_sp_fid *fid,
+					const struct mlxsw_sp_rif *rif)
+{
+	return 0;
+}
+
 static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.setup			= mlxsw_sp_fid_rfid_setup,
 	.configure		= mlxsw_sp_fid_rfid_configure,
@@ -1353,6 +1411,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_rfid_ops = {
 	.vni_clear		= mlxsw_sp_fid_rfid_vni_clear,
 	.nve_flood_index_set	= mlxsw_sp_fid_rfid_nve_flood_index_set,
 	.nve_flood_index_clear	= mlxsw_sp_fid_rfid_nve_flood_index_clear,
+	.vid_to_fid_rif_update  = mlxsw_sp_fid_rfid_vid_to_fid_rif_update,
 };
 
 #define MLXSW_SP_RFID_BASE	(15 * 1024)
@@ -1437,6 +1496,103 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 };
 
+static int mlxsw_sp_fid_8021q_configure(struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
+	int err;
+
+	err = mlxsw_sp_fid_op(fid, true);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_fid_vid_to_fid_map(fid, fid_8021q->vid, true, fid->rif);
+	if (err)
+		goto err_vid_to_fid_map;
+
+	return 0;
+
+err_vid_to_fid_map:
+	mlxsw_sp_fid_op(fid, false);
+	return err;
+}
+
+static void mlxsw_sp_fid_8021q_deconfigure(struct mlxsw_sp_fid *fid)
+{
+	struct mlxsw_sp_fid_8021q *fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
+
+	if (fid->vni_valid)
+		mlxsw_sp_nve_fid_disable(fid->fid_family->mlxsw_sp, fid);
+
+	mlxsw_sp_fid_vid_to_fid_map(fid, fid_8021q->vid, false, NULL);
+	mlxsw_sp_fid_op(fid, false);
+}
+
+static int mlxsw_sp_fid_8021q_port_vid_map(struct mlxsw_sp_fid *fid,
+					   struct mlxsw_sp_port *mlxsw_sp_port,
+					   u16 vid)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 local_port = mlxsw_sp_port->local_port;
+	int err;
+
+	/* In case there are no {Port, VID} => FID mappings on the port,
+	 * we can use the global VID => FID mapping we created when the
+	 * FID was configured, otherwise, configure new mapping.
+	 */
+	if (mlxsw_sp->fid_core->port_fid_mappings[local_port]) {
+		err =  __mlxsw_sp_fid_port_vid_map(fid, local_port, vid, true);
+		if (err)
+			return err;
+	}
+
+	err = mlxsw_sp_fid_evid_map(fid, local_port, vid, true);
+	if (err)
+		goto err_fid_evid_map;
+
+	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
+					     vid);
+	if (err)
+		goto err_port_vid_list_add;
+
+	return 0;
+
+err_port_vid_list_add:
+	 mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+err_fid_evid_map:
+	if (mlxsw_sp->fid_core->port_fid_mappings[local_port])
+		__mlxsw_sp_fid_port_vid_map(fid, local_port, vid, false);
+	return err;
+}
+
+static void
+mlxsw_sp_fid_8021q_port_vid_unmap(struct mlxsw_sp_fid *fid,
+				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 local_port = mlxsw_sp_port->local_port;
+
+	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
+	mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+	if (mlxsw_sp->fid_core->port_fid_mappings[local_port])
+		__mlxsw_sp_fid_port_vid_map(fid, local_port, vid, false);
+}
+
+static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_ops = {
+	.setup			= mlxsw_sp_fid_8021q_setup,
+	.configure		= mlxsw_sp_fid_8021q_configure,
+	.deconfigure		= mlxsw_sp_fid_8021q_deconfigure,
+	.index_alloc		= mlxsw_sp_fid_8021d_index_alloc,
+	.compare		= mlxsw_sp_fid_8021q_compare,
+	.port_vid_map		= mlxsw_sp_fid_8021q_port_vid_map,
+	.port_vid_unmap		= mlxsw_sp_fid_8021q_port_vid_unmap,
+	.vni_set		= mlxsw_sp_fid_8021d_vni_set,
+	.vni_clear		= mlxsw_sp_fid_8021d_vni_clear,
+	.nve_flood_index_set	= mlxsw_sp_fid_8021d_nve_flood_index_set,
+	.nve_flood_index_clear	= mlxsw_sp_fid_8021d_nve_flood_index_clear,
+	.fdb_clear_offload	= mlxsw_sp_fid_8021q_fdb_clear_offload,
+	.vid_to_fid_rif_update  = mlxsw_sp_fid_8021q_vid_to_fid_rif_update,
+};
+
 /* There are 4K-2 802.1Q FIDs */
 #define MLXSW_SP_FID_8021Q_UB_START	1 /* FID 0 is reserved. */
 #define MLXSW_SP_FID_8021Q_UB_END	(MLXSW_SP_FID_8021Q_UB_START + \
@@ -1455,6 +1611,22 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 #define MLXSW_SP_RFID_UB_END		(MLXSW_SP_RFID_UB_START + \
 					 MLXSW_SP_FID_RFID_UB_MAX - 1)
 
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021Q_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
+	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
+	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
+	.ops			= &mlxsw_sp_fid_8021q_ops,
+	.flood_rsp              = false,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_0,
+	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
+	.smpe_index_valid	= false,
+	.ubridge                = true,
+};
+
 static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
@@ -1498,11 +1670,28 @@ const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
 
+	[MLXSW_SP_FID_TYPE_8021Q_UB]	= &mlxsw_sp1_fid_8021q_ub_family,
 	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp1_fid_8021d_ub_family,
 	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp1_fid_dummy_ub_family,
 	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
 };
 
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021Q_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
+	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
+	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
+	.ops			= &mlxsw_sp_fid_8021q_ops,
+	.flood_rsp              = false,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_0,
+	.pgt_base		= MLXSW_SP_FID_8021Q_PGT_BASE,
+	.smpe_index_valid	= true,
+	.ubridge                = true,
+};
+
 static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
@@ -1534,6 +1723,7 @@ const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
 
+	[MLXSW_SP_FID_TYPE_8021Q_UB]	= &mlxsw_sp2_fid_8021q_ub_family,
 	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp2_fid_8021d_ub_family,
 	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp2_fid_dummy_ub_family,
 	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7186f6a33685..aeaba07c17b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7730,7 +7730,8 @@ u16 mlxsw_sp_rif_vid(struct mlxsw_sp *mlxsw_sp, const struct net_device *dev)
 	/* We only return the VID for VLAN RIFs. Otherwise we return an
 	 * invalid value (0).
 	 */
-	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN_EMU)
+	if (rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN_EMU &&
+	    rif->ops->type != MLXSW_SP_RIF_TYPE_VLAN)
 		goto out;
 
 	vid = mlxsw_sp_fid_8021q_vid(rif->fid);
-- 
2.36.1

