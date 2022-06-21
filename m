Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7A1552D17
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346857AbiFUIe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347193AbiFUIew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:34:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E565E222BC
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrFyHdmSMPqUB8L48WUmHAI4p7CYbj9Om1Em+0dlpxi0azlkTH978z8EHkntPPJ9BPh3ZjY3060vTbUHU4lLrCizATBfimqBy6S7iIHnLczf0NAuUZFGGLisE3lt1rjC96yRQ+lx9c51yRNoZ+TZ5AgJV+FYX+jGCE1j2S+1+PSTRUzm+THDKZBXEb8xPdBvXpk2dhO56a0oUBo6fLt/87Sory/HJaGdwZIcvvWXjNON0DdjzmxPeg/GQt3ZC2ssLtzXtFq1Z3Yv+MdtNSv9kLOEG/9NXDMJ/V4867siEfftOMk0Kpe6VM710TdCGYFC/wt/ipNu3cU/xrurAst8lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQh8FgzhEcLlMEslhHsTtVwlXte6Bnpjw/u9x2cMGf4=;
 b=T/dsuri/oxgww6jZSWmt1PpZ78BJCC6M+R25JHDd17FZNur7nYXX19P6MBHqcaYM1SMja6Z/u0kZKaM7Tip4Y+on3V2F/7FPmZn8kLPTYA5EZWB4GDTW/2Kzz0ElXLlNdjC3EhqSU0M6/sKj68T6LXH53ZYKZyiD4tq55XpMtWEDApGENb8jHYKUeCA3v4kDzz6uL4fIlZdQ71z9yW9v3Pf7JErrQh9ZYhETJ+4WwlU/Anx02WCi7CBvy/or30eYw0xYE0woREtpW9d38jx19zPjlqKenEL+8xLZz6/G0Kd3BSKhCRQDVraHz9tVjiwpryJqWv76tereuSVmEhIqyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQh8FgzhEcLlMEslhHsTtVwlXte6Bnpjw/u9x2cMGf4=;
 b=HNBZQHGqjpE11NbzXPEPAuqczakMlsz9OFxQtk5I6w+ZhBhyNvVmLQtJGfr0CADRqEtRXoMOiDyDrvlaUJrXkOd8ESZpAY/KfywHVREhNYDEHJkuL53jcqxyJWkKK6IVbrhvEzZWKXcH965lPUBs1INVdQmSYGCiewYI1rn8P2Nd/sUNvb0g6mgvvsSidZxFbE2wYA2hfudbMGkcgIz8oz36Zi84QojHmHnMyGB4AGiri6W7ajEELAPrs0bBWBmhgEd9kcjiV5whctyivLPfBwoyWWxyYdRZv900DQPdxui08yvJIuXrg4oocblWCajDiaZupRcy/lOKtzacw8bzLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:34:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:34:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/13] mlxsw: spectrum_switchdev: Pass 'struct mlxsw_sp' to mlxsw_sp_bridge_mdb_mc_enable_sync()
Date:   Tue, 21 Jun 2022 11:33:34 +0300
Message-Id: <20220621083345.157664-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0035.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::48) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cab1a8b9-c6da-4f32-01d2-08da5360e615
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832F955D7F46D7FEFE7F29EB2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9oxiX9AjAtYdtdSIKRVt4AaPgUavqlkjKgdIJaD6iJDlxzUOdi5EjdfsS1riJBuuElOc+4j7DgXbyMNMAVO82K4TqD2wicAoXwSdtnnA1rx4WlGAxbTE0FLEVTT7BnbwEU9vrCnD5HB2G8dMDv2/OrWD/ulzSSck2Zx/sZvWftjEMu3pCrSuCVbw7sFlJ7GdZohdt6zMQiFEJSeMQOcB+d67/k/SvbufpvimXHtlOBOuzxlfYck2MffVdgtu7eLcYgUeM6xPvguOVee9L2oRLNIrYIJj5w9tSICnECQGV5lmA/LTIBADyIr1ZZvZShnGqwOkcSefSdj+yW0L+XNQKqlrGeBA8NQJ5yhqEqvoycMqbNN/TfusG6flAx6CFu8ZaC7maNdfawAYX3RUbD7EZA8/msGWzR6IXOtcvF+ZhZ3rxfk/Z7bWYLKXyq7zU58MB/bRYAXe6Ok6xcPzwInB3FGfXXF57ndQW46DYdGABgi845Xfjloadj5gU1dgLSON0q1ws5ZBtSYwTdGZK0/c8sVL6U+YdMp0w3Ea1QUIj/cCA/cSJbm7rtvPYbp+bXKvqBG3aljj60l6rXi0yPIvANuJ0ZpwqJYQmY/7FpOpK8yD8yUFq4wLS/4Cn53H0R1CScfKimxzw9ED7o4QuIBqCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gFdEOHyXoD3TD2pfdbq9m3dInn/olSdRETclbg6HdV8GoBLPtwQLf5xbt+n/?=
 =?us-ascii?Q?BWfykZCWucaHOB7FB1ObQ/2Cn5jqtyGoi5Sy3FvZlOSR+QAkbOsvzdZdGpiA?=
 =?us-ascii?Q?gDgde6C0apX1jqZK3WXw8C89L4h27x3K0LainX0jH3l8PmFd7Q8hABglldiE?=
 =?us-ascii?Q?aBlo7BUutmTwzPz6xDrZrIskH8uFNam9KqeyYj7W0y+/Ekq0SLy+F1VVyBaM?=
 =?us-ascii?Q?KydRuw41CiNq8rQT3ZbeGr+LThCClIH7FcTdq370rnMZTaLTMf4JcBl9mLyF?=
 =?us-ascii?Q?J7LUzCJb2dwI5ldAW4WWuJX1g22rQkUi/VCIvLmdJF1GNVH5TLRnSc9zw8XX?=
 =?us-ascii?Q?9OqMO2KYcHLzrzeXOjqTAwsc5fMFqQKRG8H6wNvYwoNtlbqeyoWG/KLkOx6Q?=
 =?us-ascii?Q?+f+U9bhZnpcl01JXh63ny6v5OZeibD4loG5GFSLLjv0Ax39tW7NScVjl9PyO?=
 =?us-ascii?Q?Es4QgLY+DuEhKLsU1+FX3vUY81dZzzlKtWdUWzFPph4T/hB6KBA2uP9gldbt?=
 =?us-ascii?Q?TB9M9+LuSCIVTqIvqWV83/6XPiWUhi+LmJMDLValpCSB5TM1uhpeP3hDfytB?=
 =?us-ascii?Q?3SZo3nriEKuADgxIftj8SeELvTloLcSiQGDpP1e/2YffFgebsJl+Bf9enJWe?=
 =?us-ascii?Q?f/QxfPRrSba9J098IC2cMDKBSJIyln2YpbPa0V+DQAYCf4pJb6z/9ZyqEkOL?=
 =?us-ascii?Q?BWmvGrCDcJyj0OcilFtKMz6b3l54IXz+Bqpa5pGVo1V2xkktS0hIvzX44SrH?=
 =?us-ascii?Q?LSvgDeMu3uy0DXIoFPp+yVGE3uVJGvCcEWS8SXubBqqC24c67B6NhWwQZblb?=
 =?us-ascii?Q?AOdNfaIzDrTB4D1cNFSdQIiyLjF+FBLJw/l75cblOcz4KACzMmFpAQnyNEt+?=
 =?us-ascii?Q?zRepvd/v/BulozZGGQY2R4C5z6PNNRnyEg2bmV3bFO9uKkVg6/TyRgJYPQzz?=
 =?us-ascii?Q?RQ2Hrr30ou0pOHTe4z15/B/1PSzrjM9e3zpMs68sID8ELhFtaZOZY+PLkEHL?=
 =?us-ascii?Q?q99hhbvO/yNv/vPiQTezjhmL0Tda/UgdFzP/t4I3AQQoSMhcGgeGDyqtUB2L?=
 =?us-ascii?Q?dPe9rEzmm69NVozsYqnaDQMWP44zdlw3RNGMjOal8u14bTKcWdF18rlYalr3?=
 =?us-ascii?Q?SSwftaSR1Bd3uv1bKLVO06myCkC2y0hhFOR8/nA8mIP/hr0ls6mMx+MBZ6bp?=
 =?us-ascii?Q?VBtpsS9/KVVGiZ9Ukk1SKXmbljlokz+Gt4Mf7gmdpoql+gTufqJPaRTjdnKm?=
 =?us-ascii?Q?gFL6YewUj3Z+WV7osxV4qX60DfDFfZwrsJ8siCCq0gSbsr8sj92/3OvuWTGE?=
 =?us-ascii?Q?cFzlgQXE8qB/Y1cOXx1maTI+7hZwrU4JRh7Gbv1/EQmMrxuCd99xJni35xcJ?=
 =?us-ascii?Q?+ehuG4MbVAxLncX+FY0mqcM5UMTy2u3PxvJgDc46F0JwYEQCdd+z7rG/E7ao?=
 =?us-ascii?Q?IA0wavCGx+tQBfXDk6NMcBWXE8lgZ/ylogY9W+ALJ5ZQRtFT/APUT9n7035t?=
 =?us-ascii?Q?1t1nigHOX2qUxqNOHUO2CXjuwSL+cNlePFpubRA49oWXQemLB8nTCBJFjmrX?=
 =?us-ascii?Q?iEJRpzfFFHiPvOWuf1S91hrlbOEwHw7vA2TboNk9g7LaYgVhP1LIDXJsX0gg?=
 =?us-ascii?Q?jGBGap/voPbOFkqZfLJ1spfMJ2uv3xBTsb5BJAev2Ew5NECZby3v0KYV2A9m?=
 =?us-ascii?Q?bLedpwrT/qbV1dVwUyOaQH8jzHnfwVnjxmCPvIdw21PAfV3SkZWn178AkVT9?=
 =?us-ascii?Q?yXhfVk0SmQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab1a8b9-c6da-4f32-01d2-08da5360e615
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:34:47.2198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ywv7MvCmS+Er53W+VjET7GzwgMBozdmOt3mJc2leAPzpwTKNtnTfPxcLP+NT0UiGS/PqBgMLVgVjZG5x+zXWSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently the above mentioned function gets 'struct mlxsw_sp_port',
while the only use of this structure is to get 'mlxsw_sp_port->mlxsw_sp'.

Instead, pass 'struct mlxsw_sp'.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c  | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index bc84bf08c807..099ecb594d03 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -112,7 +112,7 @@ mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_bridge_port *bridge_port);
 
 static void
-mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp_port *mlxsw_sp_port,
+mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_bridge_device
 				   *bridge_device);
 
@@ -856,8 +856,7 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	if (bridge_device->multicast_enabled != !mc_disabled) {
 		bridge_device->multicast_enabled = !mc_disabled;
-		mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp_port,
-						   bridge_device);
+		mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
 	}
 
 	list_for_each_entry(bridge_port, &bridge_device->ports_list, list) {
@@ -1841,11 +1840,9 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static void
-mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp_port *mlxsw_sp_port,
-				   struct mlxsw_sp_bridge_device
-				   *bridge_device)
+mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_bridge_device *bridge_device)
 {
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_mid *mid;
 	bool mc_enabled;
 
-- 
2.36.1

