Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FE0564D95
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiGDGOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiGDGOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:14:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04E165D4
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:14:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRF1nAa2XO5vCvDWIUy30PIJN5w2ZSxOftNpjk7cn4axHOyr7Q2E75wkGjA6xftxHOt0xHVNJa1zvQxu5QWvrMqXmt7O5U20U6/XStrEzXHz5VDMsJvFRQr5W3t0XB83EIzt+E9P7TEKroIho1X6xTRGF5/eN02RzX1/lPdNiXFHIoZXS13Naai7yNSF8pTBg+zz/v8s5hLEbisRlk/+eVvMdjzzrRdbtJa7GkcFMUStSENRIgCA4DJA0qaTY62gOGL4B6v3ya4u1e215Jc4hJ6ahZ2M0UmtDmr6hnCW3vWLHiyWI7HEaSezKUwjwO23OwJubr4OUyUTlHXPgtqibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDyfYEEFF/NinBjQas9Zomuur2bsLwUMaF3KQ+DVk8I=;
 b=JU9YvgQd6xBXYCMDiV0Wv3NvpvfCilBs2ltPUN4cT7I1+eNLP1yISMs0J7sbru4y+97mrBloZTD7tkxKEx9A5jmb5IjkvNAvVOh/YOWDxdW/QgcAwZNwFutHDttaoIZpt7j/i6/Kn0L4sMCnq6RlrvCThtEaQwDCHeaHdfgD4QGikAxRPvhEDyjHuUZrIjXoHwAtYqBygWQxocbxv6K5X/Qx2aX0hlIXHyr1knzcTbu0m+/HoNDnFmMft0kTRvMe2gbZuejcT7KyCXYAxcg4ZJgBUMrHx03OX6o2ZVYVu5tauy9Ir2H6J/9GXDdDH2aJ/a3gwDWFQe9qCLfLJgLJIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDyfYEEFF/NinBjQas9Zomuur2bsLwUMaF3KQ+DVk8I=;
 b=HPcpRFRxK8kPOnM4IZhMpusQuoXkVJU5T/xOyAIw1+AsST5kAZV+G5qNE6ckJm1pcD+CBNSh4b9ZFWfGoWFqFbJJ/7r91SQ/KhNcH2PkZ5mRqkEDKp0+lJ4el0ZmFaUpsGKG3NoXdGrbj66fxQDmIBkRYorw/v+sMyOVeN0mhOxHMoHLK6JfXyq/2Hu7AyZHhDinL0aHVw7XGQpEMPDTNSxUdDDhvS7IGSIUiwHqV7+Fj9ZdTcoCLjg199CkWz+VUKCJ0YOOZvDC0TzXuU+eMpAtIRbhXrwpF5knIDZHg6gEmrU00kR1z4jRlUjeNH6FjFH8KYa15xAx7BiUIYoXKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MWHPR12MB1726.namprd12.prod.outlook.com (2603:10b6:300:110::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 06:14:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:14:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 12/13] mlxsw: spectrum_fid: Remove flood_index() from FID operation structure
Date:   Mon,  4 Jul 2022 09:11:38 +0300
Message-Id: <20220704061139.1208770-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0181.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4172985b-0a6c-4f97-9fc9-08da5d846658
X-MS-TrafficTypeDiagnostic: MWHPR12MB1726:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5DrNfO5FWVs3v/BvAZRTg4DtodpezDXvlRepkveOABKPNt7Ub3wCpEsnD6zIxCeN9ygGQUBwyL+mKMsC63P5P+Cj406GTpD6IPTlpl/ZE7Cgq9H5lBmlREkN8p6h8xXSDQPq+4PNx6i01XmbhO8b1u7s6g1TTG5dwv+CXm/rrVNmuqb9DPhbSEs9gLk+N9R13bHiebFjsiVcguwhsMSZ8K0TpUrcX0oElKW/LT63MspTQ8bKnBezP70SD2qzqbNjPslBghjEWgwKNc6bRh3m5zy4Km4F38N07k4nFwrBzxI9R20s14l+sJMPbOtiqWZTHujXKlBsgnf+BH2yH8P1dUklBZCFfo/yZ2H1GVIVEBwz4mQP/oSas28ksQk9Y1wierumy/ilVD7On3K0dN7NqxlKVBTPXNQ07vJZzCBq0fMxRrGup+J3dPVP2FxavhoraYFu2zBRggrA23NFVzFrxiZCRHf0YDypNAJRdxAycX6YSEc0SWZf9PUgIrqHyGYm6OpVg0WpZDdBkFCgWS3gRISRIfH7f2ZKMELQb2jCslor1AcylFaZCsvzoWV+QDVplL4NmU8d9177SgsyjcSBnWH9EczAX/Vpow/igA0z3Ib8Ubw/dY1vhAifRltNT4pRCL3uy+TsCmdCZ3jAU+38BkOK9hdmGghRMKn9noIJbCHkkAg+G4tHfGEZ8WBcWDIMzep+BuxFjzuSCcD7C2UyrJTbUYJ6hArgS3bAuxB2Qi01WJz8BqOhGPZTGgoX49gxdV56GkDKqJIa9zLxENpgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(6486002)(478600001)(6512007)(66476007)(66556008)(6916009)(26005)(66946007)(316002)(6506007)(5660300002)(36756003)(86362001)(8936002)(2906002)(2616005)(8676002)(4326008)(83380400001)(1076003)(186003)(107886003)(6666004)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IXaiwGkhp7a5uvXS2ykjjImDIYicNfstS0mFhj72A+4AcdtDxD2V0RAqQ5jx?=
 =?us-ascii?Q?N/vs3U0WZ9vMNFz5pYv3Fxw6Lp2UTmX9GpLA3StKA/ddXPinWdpEs3w9okGI?=
 =?us-ascii?Q?F5t9t/oTUomzjTs03ad7rOUABhFFkzf/ZxkA7r6MBH+eTeISwz+ham2DYnlP?=
 =?us-ascii?Q?8P8YPc29vRIS1oPI62rBCbnsHroc/pE+MvQKyHaqk7KNkzeX/m22dOF4xWkR?=
 =?us-ascii?Q?hSEgoqgJKnr9CdsyYGBNXkiHrQ1CmyvftexpqBL95fzoRy3v2DN0IZXSMNz8?=
 =?us-ascii?Q?PkSgNxBlwOGF57/7NrxuKnkIt7Nz6o1ZAlVp9agDHfrQzn4EqIq8H9MaTRtd?=
 =?us-ascii?Q?20uFUhT/TYph2+1eQ1aXQJsnVcGuCuZx9qlG7GP2Tsd2Ay9KV9nPpGLe3beA?=
 =?us-ascii?Q?pRvGuOgI5aSrwnXHiTmsGCCbkD69Sfm7bGJdC/ljj9t3SyXwKtJdmxBdNF/V?=
 =?us-ascii?Q?hUEcD1RXXMyTNH2nFdYWpsujfc+RcwTr8Uyw6/c8veE6zQJR8V0cJb3XDuO7?=
 =?us-ascii?Q?h2kOqEtdulWdXA9Ri4BQP7bNFPFY0NDZUza/CHTiwc5ZZwRemZV9DtC755Jy?=
 =?us-ascii?Q?AzoxYvc50reqbDHeYVd+SRYm0iqDHpFjg6aMuK6TO3Ms3giwzlWVKBk8G6gg?=
 =?us-ascii?Q?/Ke9r9vVBzUVr0eMSHDpy278cAIwnGWmE+ED8ubfKHvOEC96xGmfV7S6dbr4?=
 =?us-ascii?Q?SgjGQdu4tDDBMNeb4PBnOWz4vWDGSvT8vMD3mRX5V/ydBpH55FZgjCbSw8ZD?=
 =?us-ascii?Q?qupr4sk4YjWo2H+rrrgaKIh+FVwwkwk3CSD5s75xhFzrkPSEJWkN3wX5NZ08?=
 =?us-ascii?Q?Q4+jesQ3EAjEPDRlGYlRooAWszzI4UJSAEV4dDTRw+/P7fmRZXd1owpnAPAQ?=
 =?us-ascii?Q?Kh/3hfoAHbzt1+BK2vbZBQGo4Cy4xrdOUIiG6qrLzEDkZe1hV/llAduyN+xx?=
 =?us-ascii?Q?sc2hboQmj7MULdsiaS7ydvNDyKmvIjS7ALIdF8HE6/0Bisy5sadynz3qYsY/?=
 =?us-ascii?Q?ONyftEUCPUGt/4C9PE1cgQt57lIILs8fsvW9zK21g786qZMtwHSN/7rrG3Zv?=
 =?us-ascii?Q?ns+a+JiFhSf05wDjqB6vusUV1/CvUIGNwe+qTzanVAEgCJONoiwj4mQVfoOp?=
 =?us-ascii?Q?xMG+2evATeMB3vOxGpbPilt++iAD7T0iU4QWL12yEoUEYMCzv1IBUtejm7MH?=
 =?us-ascii?Q?hMrPojIhyZB4hBySHgZJCmZYaeloa1R7v49CdujvWLabPK4iyPN42wsld4Az?=
 =?us-ascii?Q?PwD0rABt6PDvLvPu8BC5HDBZt9nh8GMFUR1T5k1kbhWCcTknH/6oGR4Pk0ut?=
 =?us-ascii?Q?SY3E+Ez3MB7+2DtDwrzuzouhQ4wI2cEtYiEnbx7tm+Xn2prPMTQ1CXOL9pBS?=
 =?us-ascii?Q?cvGEJZH7n1HEqE1YaznN87zwFIZ/WQP6zNLWCBG9cPH7WruIsrsivnNY6hl/?=
 =?us-ascii?Q?va9fj5zLWFjtvHFwL1OpUifSLrBNhZtjP2q0AuxElNe8v58cTWwpYBb8GXZ3?=
 =?us-ascii?Q?0Brl1/RFg7iXp57NaCZnx2UijYM67eK6lw8qjgbRn7EXNQ5XJQXsPppmpdxF?=
 =?us-ascii?Q?5Bk+jSYexQ7nBJ0wMTgX3XJ5DDnHfjMpxMJRST2L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4172985b-0a6c-4f97-9fc9-08da5d846658
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:14:06.2683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2f+M2SSqIKC9qcwXTTyEZ5RQH4+2ZxowkrvwDbtOEXh7ixmSaJk/7s6JHHEdvq+RZUJxj8qa4RYj8kUBMuARvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1726
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

The flood_index() function is not needed anymore, as in the unified
bridge model the flood index is calculated using 'mid_base' and
'fid_offset'.

Remove this function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 818e458eb3ad..da581a792009 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -83,7 +83,6 @@ struct mlxsw_sp_fid_ops {
 			   u16 *p_fid_index);
 	bool (*compare)(const struct mlxsw_sp_fid *fid,
 			const void *arg);
-	u16 (*flood_index)(const struct mlxsw_sp_fid *fid);
 	int (*port_vid_map)(struct mlxsw_sp_fid *fid,
 			    struct mlxsw_sp_port *port, u16 vid);
 	void (*port_vid_unmap)(struct mlxsw_sp_fid *fid,
@@ -348,11 +347,10 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 			   bool member)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	const struct mlxsw_sp_flood_table *flood_table;
 	u16 mid_index;
 
-	if (WARN_ON(!fid_family->flood_tables || !ops->flood_index))
+	if (WARN_ON(!fid_family->flood_tables))
 		return -EINVAL;
 
 	flood_table = mlxsw_sp_fid_flood_table_lookup(fid, packet_type);
@@ -815,11 +813,6 @@ mlxsw_sp_fid_8021d_compare(const struct mlxsw_sp_fid *fid, const void *arg)
 	return mlxsw_sp_fid_8021d_fid(fid)->br_ifindex == br_ifindex;
 }
 
-static u16 mlxsw_sp_fid_8021d_flood_index(const struct mlxsw_sp_fid *fid)
-{
-	return fid->fid_index - VLAN_N_VID;
-}
-
 static int mlxsw_sp_port_vp_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan;
@@ -1073,7 +1066,6 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 	.deconfigure		= mlxsw_sp_fid_8021d_deconfigure,
 	.index_alloc		= mlxsw_sp_fid_8021d_index_alloc,
 	.compare		= mlxsw_sp_fid_8021d_compare,
-	.flood_index		= mlxsw_sp_fid_8021d_flood_index,
 	.port_vid_map		= mlxsw_sp_fid_8021d_port_vid_map,
 	.port_vid_unmap		= mlxsw_sp_fid_8021d_port_vid_unmap,
 	.vni_set		= mlxsw_sp_fid_8021d_vni_set,
-- 
2.36.1

