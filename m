Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19A5614F6
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiF3IY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiF3IYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:14 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7C9631F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:24:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VORl4n9DT+n2SWGx58c+ABy8oOBK1hoSKroubtaCPLYjvoogwubCSEsQXes6C9j4SANqv10bkJDpZEzrboMXKj2y8O/VgDs/qTNwkYD1inXTz/aMgB6c2zTUGTFccdy6U6qnafYP/az+hYH6yH4iBucWWKs5Qbj36r/TenPaBjoT5ep5S2R4t7uxlflrEALGII4SXy4hRANEJmMpt1nFCAvfPsqSCGfVJwv3hz7mEf5CSQsP9PSrgARiVMgSIcNd6rXbFxY5kvkBYPIDJNI19c5PU+ZypM0ZBHuz3fZh65+RJf9UlCdYjb+U6I0NAKNnQ8+aMfpGslmOX0PadCJ7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUlb8jJrW445v8tpwo6AAq6q4gbjV1nmsS0Wn1DcEkY=;
 b=n1nff6nSZMm5+K1yAISEhU/50bXR/5Kli2o81Ck+j+G1TrrOrtpu4uyA8lZ3wtjx/cPgjcQ3+4nnzRpACycGTqfmDwr5mzqS6e7HpfTSRz/HK4SeoGveNlIbi9zxdN2bKFp+NB3aT6huMLsPdPjPgbwiJTUxNHlSslH6YhtKN/hRefuV7q6+r2x9CTNY80gbxmt0S9AG6DA5R9veWV6/dJc85reLByVsdGcfZ+Y7fKKsaOUhk2aSjZkd0+5bH2GMy+ZWZ29C1bq5o6Pv50R4cuUb23l9+pWcT9DcaIDPZiypQDH5scQN4XAMVRCXGwl073Ye25x7xQZC9ZLArKRlCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUlb8jJrW445v8tpwo6AAq6q4gbjV1nmsS0Wn1DcEkY=;
 b=nPEbDJdJS9TgPdLLW/Ksq6e4B+0oClm/aHPoojfU+QG7HrNvbITUNcEYzoT/vpt/tILlrOonelX1yZoUxlU5J0S7ES68PJNU6JlH3d9PWYgtXTvw3y2z9UZ6uMMqQvn4WKcSq9oUQkJ9FOsN00FO8+XaMiXaA2JUc3w3KFPiQBeCzR3CHax2cB3s1lhGSmhNF0LErn1QDk5Eicyo1rVZdbknaAip/pR6SsS16BPIIy03njRo+NXCVlEpOSFLw6hLl55UxOG2Fjcc4Pdvfv/5mQUOMRNRzuHHIJd05Hnw3i0kRbc+6kni8xVLJQQj3yzVgCP/RG5sg70AYItVdCxa4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:24:01 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:24:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/13] mlxsw: Add support for VLAN RIFs
Date:   Thu, 30 Jun 2022 11:22:51 +0300
Message-Id: <20220630082257.903759-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5af94455-ba47-4c82-44bd-08da5a71e2c4
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QzSEWkhU96+qDf5AIsSDwTpYBH2OgnSz1+hbB7oGSCCcXPjgY9QcSoYh1Q5n0m4A0cjwmHFAj/LGIuECWdbPS0nMILPRH69kFWTZ9yDtnDtZHdbBEXOfJqaIEPQd+tmOIXeaQNrnKpjE7KE2HwMHh8RsyJsIXKfpOSuI0RVsxzvWz7dCcb8emNf7EgGzlUa8+nhXCyyfRYssAKBVlSb8n0LaMIX5UpDxdtkTzAebw8oIbvwTM26zPcoAMWKtFce6ZmmszowJH/ZolQC6RvzEZ7iuBPVthULgQsTg4Idjtb8T+m+2lm2qdWldK68Sag70QhjWfJFsqnmtHFEDTHSITqo3ak3x2f5iJQoqat/E/YzLTl1/g2Wfr246Gy6hmQX3xAE9tA76nElP92XTIE2JWmfSKippK9tf2Z4jf5XQDY5axdNAqKx/zKEFzKGEULJNgvE8qLecGMlbLxzawbgWhRNXUzm99k0nAChMY3Icwd566ubmDNtXuHi9zInCu5KLweo8gwJM21moLCjdgdbe2myki5XTOc+SutH/St8sCuRanWNILmS57WZs19oIQYX63jief4rEJiF1fvnLf3BQBIe6P3m/oI3ILRbWXqLD/10Av8PvPpPgEKGF/P5hPM7QcZFhxh1LjTptk2aEL06UqPHTdqEyx89pWtOqJZg2RWwZyj8XH+QkIZoEo3SvtrSRGm7F6gaNYpyR9lGbJ4pvnl5dn6gLS9NAB8IOm+y1ymzYnFufPyB5O9wwQvZIrwvqDswwE0Lfmoyvkiy563ciQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(26005)(41300700001)(107886003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AqYdVABuuOx575SRm4cIoPoPKSwKix4UQjQiYgYk0+0bmB4NOcHFpm4dZAof?=
 =?us-ascii?Q?wBGply/g1bQ1al7FhCw0uKP93qwCdqvhhEvyobUa39aT/uYVe87oUlHVQE7m?=
 =?us-ascii?Q?fpCbIYcC5shpBY51BnNrQb7D1MIlmRniXdwY1p3Uf7PIvBMj/MKkBbB+03YA?=
 =?us-ascii?Q?qSQg203uST2LlhLew8jKg3w0POXVltzTRcbCTJer4zoE1UEIwD8Su0qJUrln?=
 =?us-ascii?Q?Jc4B2lnUwmVt2F7RoZbmkHXVaVLuQozQNKnFgwVFjpalUwx3Qmg1Gdj2HBq0?=
 =?us-ascii?Q?XsD2mI4U6klkOM8hRfgicSOaQ8kf4NLqMxYbd2gGfo/tnWFWheJDlaUaokyf?=
 =?us-ascii?Q?ZnxFVdSsg6Q9YwTjYbPygjXh8Ojm5e9BU6+sbL8qr+n7//JCmU8sKlReb6B9?=
 =?us-ascii?Q?WxhCQTRaFO9BUnaZVd/9+ZnQMLC/W5xuhpeeWKwkM01PJ8dYZCdxg7fBFEYm?=
 =?us-ascii?Q?dE79YeA/yswgy2YuvdPehE95W4I6cunaPZ/NGVwu7+hVF2uVRw/kmugGVPux?=
 =?us-ascii?Q?omB+0ux19w04zTNy8/NB9TEmIvcG8ZCkQ/cxjY+PPqz3/bcCQZJqOMuDCxFk?=
 =?us-ascii?Q?rWZaUUDKjEPJVpXIy5RbYb0ekPnAnyZe+TQXAiIcSlVARRx+bpUFbCq4P09k?=
 =?us-ascii?Q?Dj+a9/fIWIrO6tI4xUU1nt9tVwT10hq9PcBpCfa4m1nfTAMsR02UKQVFX7Ny?=
 =?us-ascii?Q?sFSbxoiEHrkiMyOIkyM5PoguYGMB3TPcEmg2IgmblYLdvehB1NvzBjeqpCcf?=
 =?us-ascii?Q?g/Eqoxm5eFRSBNd8sKkvKsD1n+rb/FTJTFf7xP2+3VtWHHo3T5bVWwyo6nsQ?=
 =?us-ascii?Q?+peJNHZ4TTYqQZSZdGEnYb/LtgqpCwpvNYbtWN2bgbeFZ6wVkrUAfgK0Qewa?=
 =?us-ascii?Q?wgOzkesoc7EikEq1qwS+gQxIG31vej8xxzun9Yc0NNV2RXFiDuDDhKszpFdN?=
 =?us-ascii?Q?XQW2BINAoTTz1TL8tT3zNOlBd6uBVb8FLDuFzyOwE1FwGmOJgExju+h2yvfc?=
 =?us-ascii?Q?y0bw4tIFKKO3Rf6NcaTgvo6Q7BnBgBD0YN6ybgOydMgDSTzWUng2pp3/5oE3?=
 =?us-ascii?Q?2Udr8p0Zib/vKvXDm/Xh5ATfd4aeSXQZll7EwjwcTgs2PkBIiH+Uqv/qUMnS?=
 =?us-ascii?Q?3lV69UBQPB/g0ZD85lAWWm7rDvR+Lfq3upQEOsKT86cIue6RddgNnsDlwTtX?=
 =?us-ascii?Q?wRa0y6ppbRGK8dsQfj1vdGNEno1Nczv5n9XdIkXM0LmeKMPNU/AMgrsY3IE9?=
 =?us-ascii?Q?ujsVgLQt4m0wPNccjTVXYZpT+MONrVNPEYhFC/O7sAG1MEspiSA67UDCBXrH?=
 =?us-ascii?Q?E79FUEmuVeigMPgfG3hDg7rWQqvIb9zJsWtwHQwViuB+GtzhEaOOHP3ecuZE?=
 =?us-ascii?Q?H5/1e7zSUAmFEO9VaEqQ/UtpvnxO3JXKwsuojbMvzRosOa+cgGcRnjYYy0ya?=
 =?us-ascii?Q?AQMeEV4QmIBVs51eb7T8WcsrbK7tFs/+ZFflybtJJ9sDY99tfx5HFvA46Ijw?=
 =?us-ascii?Q?9ooXnimbXehAI0aX1rdbX1j1yNopa9h2IQThziJwlWB/Xg6AdtxWV9HqdPP1?=
 =?us-ascii?Q?uMdKvz9WD3GbhdnWP0+OjSgwQ9/qyKVH/+ot6wup?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af94455-ba47-4c82-44bd-08da5a71e2c4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:24:01.1800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3I84Y0OadMS1stDlgeCvvcSTZITI33OI6ys1zatwJuBXya69b2+gVZRJvVOMMhRHiUrbL0t+QE1NssQP6NuZcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
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

Router interfaces (RIFs) constructed on top of VLAN-aware bridges are of
'VLAN' type, whereas RIFs constructed on top of VLAN-unaware bridges are of
'FID' type.

Currently 802.1Q FIDs are emulated using 802.1D FIDs, therefore VLAN RIFs
are emulated using FID RIFs. As part of converting the driver to use
unified bridge model, 802.1Q FIDs and VLAN RIFs will be used.

The egress FID is required for VLAN RIFs in Spectrum-2 and above, but not
in Spectrum-1, as in Spectrum-1 the mapping for VLAN RIFs is VID->FID,
while in other ASICs it is FID->FID. The reason for the change is that it
is more scalable to reuse the FID->FID entry than creating multiple
{Port, VID}->FID entries for the router port. Use the existing operation
structure to separate the configuration between different ASICs.

Add support for VLAN RIFs, most of the configurations are same to FID
RIFs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 119 ++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b1810a22a1a6..c67bc562b13e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -85,6 +85,7 @@ struct mlxsw_sp_upper {
 enum mlxsw_sp_rif_type {
 	MLXSW_SP_RIF_TYPE_SUBPORT,
 	MLXSW_SP_RIF_TYPE_VLAN_EMU,
+	MLXSW_SP_RIF_TYPE_VLAN,
 	MLXSW_SP_RIF_TYPE_FID,
 	MLXSW_SP_RIF_TYPE_IPIP_LB, /* IP-in-IP loopback. */
 	MLXSW_SP_RIF_TYPE_MAX,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index eec4fb0561e9..7186f6a33685 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9573,6 +9573,123 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_vlan_emu_ops = {
 	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
 };
 
+static int mlxsw_sp_rif_vlan_op(struct mlxsw_sp_rif *rif, u16 vid, u16 efid,
+				bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	char ritr_pl[MLXSW_REG_RITR_LEN];
+
+	mlxsw_reg_ritr_vlan_if_pack(ritr_pl, enable, rif->rif_index, rif->vr_id,
+				    rif->dev->mtu, rif->dev->dev_addr,
+				    rif->mac_profile_id, vid, efid);
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
+}
+
+static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif, u16 efid,
+				       struct netlink_ext_ack *extack)
+{
+	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	u8 mac_profile;
+	int err;
+
+	err = mlxsw_sp_rif_mac_profile_get(mlxsw_sp, rif->addr,
+					   &mac_profile, extack);
+	if (err)
+		return err;
+	rif->mac_profile_id = mac_profile;
+
+	err = mlxsw_sp_rif_vlan_op(rif, vid, efid, true);
+	if (err)
+		goto err_rif_vlan_fid_op;
+
+	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
+				     mlxsw_sp_router_port(mlxsw_sp), true);
+	if (err)
+		goto err_fid_mc_flood_set;
+
+	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
+				     mlxsw_sp_router_port(mlxsw_sp), true);
+	if (err)
+		goto err_fid_bc_flood_set;
+
+	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+				  mlxsw_sp_fid_index(rif->fid), true);
+	if (err)
+		goto err_rif_fdb_op;
+
+	err = mlxsw_sp_fid_rif_set(rif->fid, rif);
+	if (err)
+		goto err_fid_rif_set;
+
+	return 0;
+
+err_fid_rif_set:
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
+err_rif_fdb_op:
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+err_fid_bc_flood_set:
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+err_fid_mc_flood_set:
+	mlxsw_sp_rif_vlan_op(rif, vid, 0, false);
+err_rif_vlan_fid_op:
+	mlxsw_sp_rif_mac_profile_put(mlxsw_sp, mac_profile);
+	return err;
+}
+
+static void mlxsw_sp_rif_vlan_deconfigure(struct mlxsw_sp_rif *rif)
+{
+	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+
+	mlxsw_sp_fid_rif_unset(rif->fid);
+	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
+			    mlxsw_sp_fid_index(rif->fid), false);
+	mlxsw_sp_rif_macvlan_flush(rif);
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
+			       mlxsw_sp_router_port(mlxsw_sp), false);
+	mlxsw_sp_rif_vlan_op(rif, vid, 0, false);
+	mlxsw_sp_rif_mac_profile_put(rif->mlxsw_sp, rif->mac_profile_id);
+}
+
+static int mlxsw_sp1_rif_vlan_configure(struct mlxsw_sp_rif *rif,
+					struct netlink_ext_ack *extack)
+{
+	return mlxsw_sp_rif_vlan_configure(rif, 0, extack);
+}
+
+static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_vlan_ops = {
+	.type			= MLXSW_SP_RIF_TYPE_VLAN,
+	.rif_size		= sizeof(struct mlxsw_sp_rif),
+	.configure		= mlxsw_sp1_rif_vlan_configure,
+	.deconfigure		= mlxsw_sp_rif_vlan_deconfigure,
+	.fid_get		= mlxsw_sp_rif_vlan_fid_get,
+	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
+};
+
+static int mlxsw_sp2_rif_vlan_configure(struct mlxsw_sp_rif *rif,
+					struct netlink_ext_ack *extack)
+{
+	u16 efid = mlxsw_sp_fid_index(rif->fid);
+
+	return mlxsw_sp_rif_vlan_configure(rif, efid, extack);
+}
+
+static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_vlan_ops = {
+	.type			= MLXSW_SP_RIF_TYPE_VLAN,
+	.rif_size		= sizeof(struct mlxsw_sp_rif),
+	.configure		= mlxsw_sp2_rif_vlan_configure,
+	.deconfigure		= mlxsw_sp_rif_vlan_deconfigure,
+	.fid_get		= mlxsw_sp_rif_vlan_fid_get,
+	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
+};
+
 static struct mlxsw_sp_rif_ipip_lb *
 mlxsw_sp_rif_ipip_lb_rif(struct mlxsw_sp_rif *rif)
 {
@@ -9644,6 +9761,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp1_rif_ipip_lb_ops = {
 static const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
+	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp1_rif_vlan_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp1_rif_ipip_lb_ops,
 };
@@ -9832,6 +9950,7 @@ static const struct mlxsw_sp_rif_ops mlxsw_sp2_rif_ipip_lb_ops = {
 static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 	[MLXSW_SP_RIF_TYPE_SUBPORT]	= &mlxsw_sp_rif_subport_ops,
 	[MLXSW_SP_RIF_TYPE_VLAN_EMU]	= &mlxsw_sp_rif_vlan_emu_ops,
+	[MLXSW_SP_RIF_TYPE_VLAN]	= &mlxsw_sp2_rif_vlan_ops,
 	[MLXSW_SP_RIF_TYPE_FID]		= &mlxsw_sp_rif_fid_ops,
 	[MLXSW_SP_RIF_TYPE_IPIP_LB]	= &mlxsw_sp2_rif_ipip_lb_ops,
 };
-- 
2.36.1

