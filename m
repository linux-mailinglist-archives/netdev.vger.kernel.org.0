Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813BB561501
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiF3IYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiF3IYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:11 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF67A1EED8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lz/ZsTi5NClmon9OcDguphSyPiG6QrDeGMvERlkyb99rXYazQgfSRWSVZWm/X8wqb74oLe82HEyMCT8p3kVSlP68lNSSjSzQKl2Wsp+lHqyG43SfL4szR99I8/Axen8o3xlBbgCtShjPrwLg9nmhg62rQiCYiX2LOM7kEamjX8qkWj6nVhhDvi1Cbe/u+T2k2vnNePe26xDBL+pZTPbBL/gxcMp4EKs1AUBkozZ+v6ANVizOw9QhYU8AmIfYlS3NmOSphJ9UZ4Jj7Z1Y57B/9+m0meHHErbmDlMM6xPiU0mKdbe3xgmgSTbR0Wp9KTp1SxdgZj3e8DXXwubNxRT2Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOP+MEv7QudGVnx2zgl1cN5g+7RGsk7LnHSfngj92Bw=;
 b=PVSCYV6GJ34rnJefgnJLzMe0wxIqCEDE+8+h332o63+CjqDAzJTYkYZaABwlkfWVo4IocN5QW0P+2TmEKm4EEtuZnYYLT9MsNOgUzEVUXzlWINVT+flHv8I7tays5LxWGfxX4uDrYYmutI6rZ617LoZD0o4wm6zEMKwxjH94EPkibYQmB1CDXwJj2thPrnZbjv/T7CWLUfnZuCT1l975cfCTc3Xh1j0VTcbf+R3weGE8296MaGKZqGMxctkCjjtELHFIiFhcIMjYgfUFlFJTvY4YfsaCB48JPG81o6yNhOyTEs9FPuJVOs1RJDLy04DdZGuV5Jx5IAJ+9t5yibZWHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOP+MEv7QudGVnx2zgl1cN5g+7RGsk7LnHSfngj92Bw=;
 b=PlfLYv3AR0kdzOAejMuCpxmgdd1Sv49rsNToJpawcqhr+QnrakNspBxAAePv+NCd1o5CcFoNfj+4kzKYVuknquyBfb2XBnoUfTbKtuRkXKdwTfnJYjru9jZNVm2zt7B8xM070MW1ieZ/9vf+BNRzQnGQheFqecxuYYdS4KOPZtCj3aM6J99qxoX26McoVqutbfGUlJmg2ClR8uOmmL3zbW8rzCsG0Q2UDvywzRNALIy6F9lnoxt8KRbC1FEKt74yJ4YVKKndvfgzRZ/GC6fTRxMmtP/UzNtROQAZniZiNaYBe0jOOpSyinDhL/LVKktopVXhJthF4FO7cSG8SIlOKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/13] mlxsw: spectrum_router: Do not configure VID for sub-port RIFs
Date:   Thu, 30 Jun 2022 11:22:49 +0300
Message-Id: <20220630082257.903759-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:802:16::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d7d442e-b0df-4adb-20ed-08da5a71db99
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFAoV9cni9HashtZ9N1CR0T6uFmiO6qwwmY8ocqEsqUfmDaTr2Mcj64quxveHDdeXLO5Y7MhahwQXBnfZEUYsou5fTA2cxATpxycbfQyBsFF3YlMjhg83trcb4HVkj1deCgYXyfSI5DtxFlO1IQEiX0swLuO/y87oF74jSYhtcivDnzDoUCAZSdkg5tzJ2x1JMVCYh3wLESRNl99FalTlGMt8SEQWCjGr3ANAV2YxGYmr7VOT3TN8uH38BkNO//NSnvHoDrfwOfiys9lM1Cdaa7qOVXMwplIYnLoSYCkj9hhhfObCRY9wivPv5UTcE6cNfrMJWIjBB5LzKu2299/Z8doBrRKowT3mbhEkzLgKNSZTEr1MdBsTScm8MeaYv1XXLOi+uAW9/OhJxR85/9y1jigRyMJXmmJHXymwDPvMWhZorcC3+IzBK8nzkLiuSG9xg0uJezftYHXD4RZvUXxmFigZj9amFTQMGEXdrkfWiSOI7h8c3Aa2t/+FdJI3kH9WLsfBd6vzeBP8EnL6vl9I3p5mBv56EFKOxK/Btg6PrFX51f5VkdTGKelUvGtt3AMczUULlPacbnnNRqXWoiThTcUW/M8ywpJLRWh7/NJ0yXj/MVxlDdkxlMwtZZ856nyz91zmwd+VBPJjfZJaA2EWEQFtSGpo2JByl8r8/QLUv6eeDrugRCczl5qJHbLkw4kmEDuXf6Cra84rQL8yoAhSYZq3WDN0en/VDEx0H5Ci9gMpwsJfsS2LKL6DkukQE8GNXA5/kUbjLAvtmj4enwcEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqOXceX7W7m8q0BzHPE/NuwuvoF83q7wz6SU0e7J9IjHcNZlEADCjgR2DjeQ?=
 =?us-ascii?Q?MoQ0GZDEQmlKfY7rxgsH3zTIHpIOYWnLjMgLIhdwQ+DXg/+oLPQa76e2+pO4?=
 =?us-ascii?Q?XPtjKfYuqj+pgJX41d2zDfncC1Srta80o3Qa51eR7+yyBDuXqjJOSaaHlHVV?=
 =?us-ascii?Q?xERK/JKDdAgPUaytWoOG1qCnYh3K+clgzxb+XMsx5h6ZnCtwjUbrmTUyFbpH?=
 =?us-ascii?Q?2OzaY7y/QfJPjB/c5abSQGX33HiXLTbvRIWpbOB8wiua6lsHVyPX1uLQDMtI?=
 =?us-ascii?Q?+m5ey9/cNGEW9rznFLuZtZ1r6al6dWPwPCvdyonDnp5sFzRXHcSb/oPdVdAz?=
 =?us-ascii?Q?f4/M56jJErUkdBoy85Q4H0+CF6fHCNdeDeQHdX4F1dg6oq2KmAN3XuxVCoIG?=
 =?us-ascii?Q?GiyhtJUZ4/PaPGdBFtGQfFVKnHjxA/pmC6FPxCaOPibj6y4/WZ6Elx5GW7lR?=
 =?us-ascii?Q?AXy7Xr6xotpbS+fHYp3frni3l8cqyaaKFUCuRLGpfn/3obcQG12/aXyur7+3?=
 =?us-ascii?Q?hkg9rC/LNsH8GF9sXxU9XnHYsodqlgnt2GrkglLeQMAKsyUQLUODhIIqxi5H?=
 =?us-ascii?Q?1pHqLBWdwmN2E+xdKE/OMDdXGY41XHOg63TlqJxQUMC2b1bL76kcae25uFM+?=
 =?us-ascii?Q?JATHgtlYBilif1SGj7OstxBf3RcoJAwYpHW+32/gGwtwB8kLhz5VwXKjVhNY?=
 =?us-ascii?Q?w7wK77hwV0aazqcIGAx6fo3R7vF65OIUEeaHA5kHQaE9eRSRM1mYgYRvo8b+?=
 =?us-ascii?Q?KeQ48PSVf3ZCtNdI0m7Tb4+UjDMIWxCcyXDJhnkONPz0PTXaWjKuKDJdlv0F?=
 =?us-ascii?Q?AAbGtXNJaHdbtDLkV6pb1hwDYiVjBKd8uH6C3HLujCjcXEXpBkp2icVXiHqa?=
 =?us-ascii?Q?Dn1Ew0FOQy64bkCApyxbNz8YCkaeHP8z7tB7oAzz4jzNshxfVSqPPB+LAWU9?=
 =?us-ascii?Q?5ANxcUSeKwG3S8KMaIMtwCNhykPnJGGt3BOP3zN5DvJZD9acp9T1OBr4q2vo?=
 =?us-ascii?Q?BRiiV0jDNN2Q6pikvs1jVTEQArjgEg08YbnpJBQPenkuw7OP4pX/5xhiMh2W?=
 =?us-ascii?Q?uJd95UCVJR1jxRMmgNa9GwLSEr8HPppFFnxt0SF0PxkUK7FPzEQiS5c5ZnYX?=
 =?us-ascii?Q?gGdNDoeLY2TGis0wlnVZWhCKvfPQiqbn0o8qzHS/kk0h7Y6W1ce/FBYOZ5Vn?=
 =?us-ascii?Q?TK9Olu7ZKBGhy/HOwYiTbC5uvuCEqeOdjhTkhPsqGbdiVRbrQB23B/t6a4iZ?=
 =?us-ascii?Q?1JdEyb5LzpsSOdsM3foQXjlfeO7RnvxQD9SouXPqCM0rV63OnjbV9jk2tTl2?=
 =?us-ascii?Q?zVGGDlKmLq8PHhtrH7vdLyuiWEzCjuk5EQYUeA+XYcKYKxWPPmpcMGQzjm7S?=
 =?us-ascii?Q?+5AT/IiQkez1WhHRDkC1bEXWnWGllZtjV/Xn8xa2SQJEFlQ7Yv8+399MZq4C?=
 =?us-ascii?Q?ZPXjDeS3TTpGAXN44KQKYBwP6eW1DJKFGtlVrB2k00dfQ7VrWQ+NNGzBtLmH?=
 =?us-ascii?Q?8RfarrhFUHIdx46l/famWRgR1aSuiDQRe9g81vK/h3M4cLgnmRFtO5vEH7eZ?=
 =?us-ascii?Q?PcIYuBPE0Splo5im27HUOJdfibmuwXsXlGzA75IZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7d442e-b0df-4adb-20ed-08da5a71db99
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:48.9490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7P5P0ypq5SssgaNmX3D3ErcKleMkbsY/6MCeeqYopZxq05yE5+XtISyf0TX8MSjT3cwlTaxrKo0TC94kTStT1Q==
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

The field 'vid' in RITR is reserved when unified bridge model is used
and the RIF's type is sub-port RIF. Instead, ingress VID is configured via
SVFA and egress VID is configured via REIV.

Set 'vid' to zero in RITR register for sub-port RIF when unified bridge
model is used.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4a34138985bf..fe3ae524f340 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9325,7 +9325,7 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 	mlxsw_reg_ritr_sp_if_pack(ritr_pl, rif_subport->lag,
 				  rif_subport->lag ? rif_subport->lag_id :
 						     rif_subport->system_port,
-				  rif_subport->vid);
+				  mlxsw_sp->ubridge ? 0 : rif_subport->vid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
-- 
2.36.1

