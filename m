Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536575614FD
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiF3IZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbiF3IYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D49DF4D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiHF9Puz6UVv8WTwM+IvRKyTfbxtpsl64IwDZvu/wgKjXjkck3jGokUIz0HUo4ndKdsamAEtqqrLjQljNBv009WCe5yYRKQQw/aTJHvV7H52Hk1Cxn2p91sIrQ7/um/VpyzS2hvXyEd8zdDM5W66HlLc5rLcWurguWv06dm8STKd6LRERkWwMLLVLcUX4a59fv/U9g+4gmUVYI3oh+i/1XWpezgrnDfml2oGMs5HDEN5rJEflcx0QFQETRk67j9b3ZTBqYk0Y9YdNjfUAYcbR4iVHhGEf0k6IIWxr+hVKWehWhZNvXfPV/y60D/jg39rNgGtVjIh/0hLOxBU/CSY2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCHPoWPLn1qzvU8wqWsXK/cUBrFzl0jSLOpNkKzk6Mo=;
 b=CgeVYRzH9YyrN+17FOfxsTQEzMpiJA+4jfNr8votPG6pHHTfAontHxJEVtxqESLc1jAgPPGHwyvL3FRCjdFLJzdv9TO/OGF+NOIoTqn7zvqRdRBwtRx2/31CdWN78BLj0+qKVirZYV0fae/e5TXzpcy03jafhsF88uAh8OxeKPwuc19izGBkUckaeRHO5ff4v9GM99Pm3i4L+LyB0zvad85eBrq89FPLmoKkklgosG6uBU/n0LBbh1be1ECAqdh4in9vO/aVA0H3BUdOtqLwHZSQ8uhPk6NM/FjowtLXz2O/4nOBqgXxxb35mEPKoRG1znvsS9/SZwEXkqxzQO46jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCHPoWPLn1qzvU8wqWsXK/cUBrFzl0jSLOpNkKzk6Mo=;
 b=pmjAQzMUjk5Ck9/TR9Xyl3SC4rhEXi+k7j4TjLhT488+PnvP7JKvq404gvYAoB6jB83o9TotLaVChUACOyPTUaKcvfKHHhg5jlnC7Nj/z/BwA1x4wRO+DrELVMcGFeO/vrGTuxXwLnBjBXw0DIHliJhDpNfd2+ZDLWjxog/dVT0n0VZgOEpfI/F7OrLp7PgiRpJYarpGFtKKhayrnSsF1KiD+ssV9Ng31VQkLVErLRtv9Zalglw6VKGDeIK0nt/T0rTYVRVnMzHEeEpJiGWLPGDFm0HokZRxoB9+wytZDn8Zi8rB/zM8yAtOxyzZJz17BhGnwTYT09fH/4guWHRc4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:24:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:24:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/13] mlxsw: spectrum_fid: Remove '_ub_' indication from structures and defines
Date:   Thu, 30 Jun 2022 11:22:57 +0300
Message-Id: <20220630082257.903759-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0299.eurprd07.prod.outlook.com
 (2603:10a6:800:130::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8015fb5c-2c8c-412c-12fe-08da5a71f9e4
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K6N/V29YJK+zxvlRT0Bhp9ftNjuEKJEuaKM1lXc22TZVhd4SnHje8pGfZJTS/xWe/ML1FpKGy4fTBNkMyIwBlAesaAA7ypyYL0cevrvJOKtNfYk/9vQ67HABnZsBQrSwMPiA/lzHi2CJrQ+AIeNPg/XxKPnEoHP5Mqh20Yqm2lCBbgl6Nba37eRtPfwS18ga3j74XoqDpAqW07ZE8Aaek3xzOM9ShDvkSvb9047y1f20ukSx6UiTEpOqSaf++pHYvmf1JgD6uw4temh6goYj97BFFNf1GnFtQB7zPAQCGpR3sUrNwcWpi48C7Lvk22OfF2knKVHWw37bvQHVYCBk+v6iDL7ru7ngNQZrI0OSY/3EKkR9wIzPZTzSm+nSLCqFQnw3ZYzf6pkKn/MwYGzBvxhE2XZ8mFBfuJt3IMA+07FA67OFYBlpnSHcTAZn6M2mmkYD5yW55JGOA8XKzo40gD92/KAgYQ5fULnnDZ/p0iOjiGe/Ha7INzd1NM3HgtQIi+M2sqUTg/hXlIlukIm3PDZcFqlj1ywuU1Iw6KXnhykV2GP1qqZe11DiBff3TvlJaexBphfu4jmKVI/W5merGweY1InNqUwhMWWQb8qRVvzTutufd5KhoGNWSWMWeolmDYzqya1ZVI4quKB+oB3386Xc//ldyHyNVAgIzsqnFKvYkLbJzIt6wUM/IGCmvZZS92vIPO3KFqBvb3ukgWoPSh8KBUO3eUbqa11dJITzco56y/UEb5DvlzGcCDxqFxgnWN5UPbA0ydXDH+oi75EYUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FXNIxrh2MPu1Vz9OamjG80OaKYFI9VJm1hLlse2ae0ODTk681Aq89T+oAxxc?=
 =?us-ascii?Q?/BSugmlVkT50svO/G6dWQQfejwtcyz+OipObRIU/9U3A0CH9y/yLLeHhen1T?=
 =?us-ascii?Q?Z7qdf1Q6Wd4l2ba3x7Sit/IgJac4ikXr+YcPJvqTi1VI2l5VukDUyR5JdHrP?=
 =?us-ascii?Q?i+KZAP3YgVd+B/zhUjfcPI2Hw1LG7rp6x/dI+ilNr6EVEgoBCesG6ro4lUnZ?=
 =?us-ascii?Q?9mDIPwH+3GfsQEFcDw/gSHctPt+U+Ccz1N86zcuja7r+lx6071oOe1CZGPB7?=
 =?us-ascii?Q?xV+VJaE86A4APv+/sgxXuLsehn7/UDlc6fdIsI+aFHZCym1HN9jPzi9jJ4PM?=
 =?us-ascii?Q?abOpd7mlNx0BMdmlFLRa57kRETOJ1TeJmeMLKqDldt6wn19klkdfqeJl+YVe?=
 =?us-ascii?Q?pZgLF3M/7+MQCR16ZNwThyK3FbLW/RUF8JmRTryJbg5lMJNSn08aS0a3KnWv?=
 =?us-ascii?Q?QKPSU3ZppwvX2WrlZSd+u89w6uN/J+8wIXRAgCVVaN1lT2aPpmug69vFJYcx?=
 =?us-ascii?Q?LqyXx0LoPwVQ5FJ654Zk23NAgTwp3f2l9r003YRUG9+fG3tBxADzpPyrsCN6?=
 =?us-ascii?Q?FAQoojZlJ7cUw8zqvbjnX7g4x9i8bFT2c/d9QRNP6/L1TFrQJPxgVElmj15a?=
 =?us-ascii?Q?3Zqwh06N0GxfHGCAdKKu61PCO3nkFVeAKUosSTJjsDWntDWn2VLGosuwq2o0?=
 =?us-ascii?Q?pty1nLQBwwKJGsOSUVZW0wAT9Wj+pfjSv4UlzC79LzPTW/K0qq4FtDmMcEG3?=
 =?us-ascii?Q?kHDcXo08R6oF82FM65xrHk2FfQ/kmaxexj59FkPCjqQ2OLgd3BFcFLG6MkAR?=
 =?us-ascii?Q?fGmwikLa84ffUD7BV5SllxnI7fwPmrmoYyJncMFQtnjX5XxqGyASnge8FDis?=
 =?us-ascii?Q?vSR94gfJO3A4OLltXu2BZ4A6HcZgj/XqoGH2v89ony02ADfWH6GyLnXj8QmR?=
 =?us-ascii?Q?/ZMObTNYUXeU3w0M9mgmUdS6GDtHzAY+B4RD/mMXDTetgLpfTT0FvkgiBDFZ?=
 =?us-ascii?Q?ukEVT/+8sylBKEeYfronZAcNsl1uhbPoLs0URBFpmv2Lg44Fmfka9Mv5e2wT?=
 =?us-ascii?Q?bytXAUJPpntomMkxwC0ZGa6MiNBLDHcqs0ctfxbAjmRokUzdL9zJr9uNn3Rg?=
 =?us-ascii?Q?qBW2Hfc+Nw4s4l4V5bVChqwKkzvHvisDvl2pmGECSSIPEnnp8aZoezMYkBH1?=
 =?us-ascii?Q?QqfH2HpRqEQQQw49kVV0hBov3NVtBq01V304DbdElTUyuYOSUpZFaaEGvuuv?=
 =?us-ascii?Q?3A/jE2A70XUBt8eaqgfMU1n1PBHlvCam0imlhHU9YTc3ERAwGmpxr0Ankyfa?=
 =?us-ascii?Q?pAwYzEC3EzrVPYFqFq4v1DrCf76w+tX6NgzIKEHuy/Gn1m/QrquaBXOzoe3k?=
 =?us-ascii?Q?Xby4N/0m8KyPe2Jd39JptlqT6tZxKNbPY7Tvt2HvjSfJWrxEBzbj7hWAc3u1?=
 =?us-ascii?Q?MpshpB6y52i2/HWZlw1ZIiK9qQRkOaUo2yte70edw9yYd0xxiBVsAUj5cRe7?=
 =?us-ascii?Q?OOprZ6xpGyW+lx73vFm7ch6F61pPwkZljlIt1JS5WSj6PvSJa2HvWytw++B3?=
 =?us-ascii?Q?F2Hl4giuwctDSVhncq9+vgCHdJ0n9w9/DHlGxqpn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8015fb5c-2c8c-412c-12fe-08da5a71f9e4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:24:39.8811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xcJMwGr37PLksFr0Zmc5qMyfb0D1XS4sS/vWGReehptmdNhHGvVZ0WphLBG7KKEOjXLdhpvy184lzTdh1NOPag==
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

Some structures and defines were added with '_ub_' indication, as there
were equivalent objects for the legacy model.

Now when the legacy model is not used anymore, remove the '_ub_'
indication.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 94 +++++++++----------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index da581a792009..045a24cacfa5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -1077,11 +1077,11 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 };
 
 #define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
-#define MLXSW_SP_FID_RFID_UB_MAX (11 * 1024)
+#define MLXSW_SP_FID_RFID_MAX (11 * 1024)
 #define MLXSW_SP_FID_8021Q_PGT_BASE 0
 #define MLXSW_SP_FID_8021D_PGT_BASE (3 * MLXSW_SP_FID_8021Q_MAX)
 
-static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_ub_flood_tables[] = {
+static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	{
 		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
 		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
@@ -1416,30 +1416,30 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_ops = {
 };
 
 /* There are 4K-2 802.1Q FIDs */
-#define MLXSW_SP_FID_8021Q_UB_START	1 /* FID 0 is reserved. */
-#define MLXSW_SP_FID_8021Q_UB_END	(MLXSW_SP_FID_8021Q_UB_START + \
+#define MLXSW_SP_FID_8021Q_START	1 /* FID 0 is reserved. */
+#define MLXSW_SP_FID_8021Q_END		(MLXSW_SP_FID_8021Q_START + \
 					 MLXSW_SP_FID_8021Q_MAX - 1)
 
 /* There are 1K 802.1D FIDs */
-#define MLXSW_SP_FID_8021D_UB_START	(MLXSW_SP_FID_8021Q_UB_END + 1)
-#define MLXSW_SP_FID_8021D_UB_END	(MLXSW_SP_FID_8021D_UB_START + \
+#define MLXSW_SP_FID_8021D_START	(MLXSW_SP_FID_8021Q_END + 1)
+#define MLXSW_SP_FID_8021D_END		(MLXSW_SP_FID_8021D_START + \
 					 MLXSW_SP_FID_8021D_MAX - 1)
 
 /* There is one dummy FID */
-#define MLXSW_SP_FID_DUMMY_UB		(MLXSW_SP_FID_8021D_UB_END + 1)
+#define MLXSW_SP_FID_DUMMY		(MLXSW_SP_FID_8021D_END + 1)
 
 /* There are 11K rFIDs */
-#define MLXSW_SP_RFID_UB_START		(MLXSW_SP_FID_DUMMY_UB + 1)
-#define MLXSW_SP_RFID_UB_END		(MLXSW_SP_RFID_UB_START + \
-					 MLXSW_SP_FID_RFID_UB_MAX - 1)
+#define MLXSW_SP_RFID_START		(MLXSW_SP_FID_DUMMY + 1)
+#define MLXSW_SP_RFID_END		(MLXSW_SP_RFID_START + \
+					 MLXSW_SP_FID_RFID_MAX - 1)
 
-static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021Q,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
-	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
-	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021Q_START,
+	.end_index		= MLXSW_SP_FID_8021Q_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
 	.ops			= &mlxsw_sp_fid_8021q_ops,
 	.flood_rsp              = false,
@@ -1448,13 +1448,13 @@ static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021q_ub_family = {
 	.smpe_index_valid	= false,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
-	.start_index		= MLXSW_SP_FID_8021D_UB_START,
-	.end_index		= MLXSW_SP_FID_8021D_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021D_START,
+	.end_index		= MLXSW_SP_FID_8021D_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
@@ -1462,20 +1462,20 @@ static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
 	.smpe_index_valid       = false,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_family = {
 	.type			= MLXSW_SP_FID_TYPE_DUMMY,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_FID_DUMMY_UB,
-	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.start_index		= MLXSW_SP_FID_DUMMY,
+	.end_index		= MLXSW_SP_FID_DUMMY,
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 	.smpe_index_valid       = false,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_family = {
 	.type			= MLXSW_SP_FID_TYPE_RFID,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_RFID_UB_START,
-	.end_index		= MLXSW_SP_RFID_UB_END,
+	.start_index		= MLXSW_SP_RFID_START,
+	.end_index		= MLXSW_SP_RFID_END,
 	.rif_type		= MLXSW_SP_RIF_TYPE_SUBPORT,
 	.ops			= &mlxsw_sp_fid_rfid_ops,
 	.flood_rsp              = true,
@@ -1483,19 +1483,19 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
-	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp1_fid_8021q_ub_family,
-	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp1_fid_8021d_ub_family,
-	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp1_fid_dummy_ub_family,
-	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_ub_family,
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp1_fid_8021q_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp1_fid_8021d_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp1_fid_dummy_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021Q,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
-	.start_index		= MLXSW_SP_FID_8021Q_UB_START,
-	.end_index		= MLXSW_SP_FID_8021Q_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021Q_START,
+	.end_index		= MLXSW_SP_FID_8021Q_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
 	.ops			= &mlxsw_sp_fid_8021q_ops,
 	.flood_rsp              = false,
@@ -1504,13 +1504,13 @@ static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021q_ub_family = {
 	.smpe_index_valid	= true,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D,
 	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
-	.start_index		= MLXSW_SP_FID_8021D_UB_START,
-	.end_index		= MLXSW_SP_FID_8021D_UB_END,
-	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.start_index		= MLXSW_SP_FID_8021D_START,
+	.end_index		= MLXSW_SP_FID_8021D_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_flood_tables),
 	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
 	.ops			= &mlxsw_sp_fid_8021d_ops,
 	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
@@ -1518,20 +1518,20 @@ static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
 	.smpe_index_valid       = true,
 };
 
-static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_ub_family = {
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_family = {
 	.type			= MLXSW_SP_FID_TYPE_DUMMY,
 	.fid_size		= sizeof(struct mlxsw_sp_fid),
-	.start_index		= MLXSW_SP_FID_DUMMY_UB,
-	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.start_index		= MLXSW_SP_FID_DUMMY,
+	.end_index		= MLXSW_SP_FID_DUMMY,
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 	.smpe_index_valid       = false,
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
-	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp2_fid_8021q_ub_family,
-	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp2_fid_8021d_ub_family,
-	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp2_fid_dummy_ub_family,
-	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_ub_family,
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp2_fid_8021q_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp2_fid_8021d_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp2_fid_dummy_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 };
 
 static struct mlxsw_sp_fid *mlxsw_sp_fid_lookup(struct mlxsw_sp *mlxsw_sp,
-- 
2.36.1

