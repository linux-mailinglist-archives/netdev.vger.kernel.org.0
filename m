Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8456B54862F
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243559AbiFMP10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344792AbiFMP1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:27:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BBB13AF10
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:51:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHuSp1d989Mt9jG6atExnM5cfIVWqKiGRCXyr1kBo61Hw5K4JBRJgoSJntyFfGrJ2G9NZyDBpGvuAptBurBlohDR3B0t/4egpN6jbrFrdOtqm9H3QGp9B9I2qduGfFHz4DhD3MYtJdvdNYoOsfHVNrmvwgnBcNOIvui20eE+iQFrGoYZ2J7r3p2Di8IIeBIl41/A8eGMYUiroWL028lnSiKh+ZVVu0h+Jk+/803mk5QggANBuMRKilQEmaE1hJXr6lh0W2r0MSkvJ8bWDtTwHEOGgwDMCFBp6s/McI2IiskmO8p8ZHZGBm5QKnirYj4/jCOS7exG6buzY1/HaY496Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68nT8mESuLlHbVIstWKTH+dvCwH2ZnmKOCXtukaPSZw=;
 b=dolckB2thFmezhB2tpXMNcpm/1V9WdkffUynRpECgY7c/lf/1mvVimIjTHDybSwu1pOB4fH6Zr7lm6QTGPs6DEGd/oWkfXVgY36jo1RCcumdajUHNwxyBUO+s74kiWGBLAx60BjO5AUp4iEgwz4t9ICcrSIkmxZgg48msDXMWJZSzUR+cB8AP2OI0b9lfuFEEd52ZhKVs+QhsgcOZoLDFcBGoNEiRdEaAOKqXpSknLHsQqEkJb7m6NYKeRGhytIC78zgS4RPi68Wnu1KoON0BmzkJGjIvMGviNng+2LfJtR9r599krmywg2Cye3RpTgtz6ah9GR7V/nPmcO46P9nGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68nT8mESuLlHbVIstWKTH+dvCwH2ZnmKOCXtukaPSZw=;
 b=fUcBLi7B+VRafY9s62ZsVMeKcFVCKF0Z/9RiF3FQ+vgR21K2iPeEQTZpgp3fdCs5JxbHCIyEKtHMB92EMsCGuaaT4HYItdW+uLd5ozxz+iG/XAM4spSXOjEDp1FZ4NaDBkKILNyA8mvA2bQPFWLRAJsm0VvFuYxZqP/X5NxTum59UuCwBGLoLNt2skAB+udGW3joHvYtvAL38r99QmhVItplK1/85GcrnPjPoxJd70bHGCKyvG9cOWq67C8PWhQHg7pZhZOjV1LdGUcnqlVisFF29lzFZO8BbCjkTrCN4snGpMWI6DRhFXNrb5uvrkrNIs9XkKv5kaAglE+U6zWQ2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB2449.namprd12.prod.outlook.com (2603:10b6:207:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Mon, 13 Jun
 2022 12:51:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%7]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 12:51:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: spectrum_cnt: Reorder counter pools
Date:   Mon, 13 Jun 2022 15:50:17 +0300
Message-Id: <20220613125017.2018162-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0165.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b626b148-e3a5-4d1f-f5c5-08da4d3b61b1
X-MS-TrafficTypeDiagnostic: BL0PR12MB2449:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2449A07389F99B25FC83DE93B2AB9@BL0PR12MB2449.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DZReMLGXUvm5BGOwQa2H/nInZxnOkvdQOUUw6Yfe99eB6dyHfQELwcc8iZ5preQq0W3GQYRZvLAEC/ubt4S7Zee15aRe3K2FDw+3mnDiLwEGBe2asnjjFc0lSxnaJzZmJpWnEVOVjzruuO0o3pwisA47I1+1CWbNzTx0yKMlweivVNFZVz/rS6HIq03mE+v7kIhdt/3/AZao5YbW6FRyjq5UrSUrSlkd/kvfVdlAq5G+0iQHOPpmhJedakOxsfvX91v4Ajgj07UxH1eIyYt0WmqqKuTTe4kR1pl6eDTVniGqqX+lOMkM+K6zPWy+ROMQ0xU/eeG7wyFHyLFBF9GZU/r6v3pzoSJEVnHdyOwHNxN02wPUtFbUtHQHsQZsvGeli+beSyRTrVYTA73GaEqzhh3s7slg+5+MMDQlIhPBAws7zgQAWxGQCNMauVENP1HpigTfZBjyDSq8VWSMmcpMOV9BnEMs3GCKiB0Zb5rLTAhOrOTAIcf0bVZQOrgxx/4lwT3zeuoNkqxlvUENe6uM+69BBoYjm15TCNUb77zrVlvHDDKjKtknbDjVnFHIuMYb3a37vFDWf+6oHjVjd7OYM7hsefcgk8D+KabLdkuERA1Vgb9ZdLx+w9r52Q4Revksxyc79XJ4CBk9zodyB7M8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(6916009)(6666004)(316002)(26005)(508600001)(38100700002)(86362001)(6486002)(6506007)(186003)(1076003)(107886003)(6512007)(2616005)(83380400001)(8676002)(66556008)(4326008)(36756003)(2906002)(66946007)(66476007)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hM8R3EHoK1cS3LDbqvGSSrW4StwdRfRghS7YWYJntJmTh8dh9Uo7kLrySg7g?=
 =?us-ascii?Q?z/W845Ow3D4cy/rXLjjZYKIJX/yFEy6Iqen6gQNnSc2iWRe2lUYiqYr/SKgA?=
 =?us-ascii?Q?64sKIy0Kt+G4Or1ja6dOMB/y0JigUxbMElmQWar3jPCnfLKnWbnSFTTFPk0B?=
 =?us-ascii?Q?R6j2B1Pgi5u7q5nYPzVGYtY2Xci789Mdux2zujXLKZeBwSFZ7afumJvQTTYU?=
 =?us-ascii?Q?GW7BDPM4ecnn33KU4kNdEbVhhMw+BkiqcvsAKPhQMqK16G9r1Ayublwn+hyw?=
 =?us-ascii?Q?aw63WS63KOslbFtZ12HV6r5wSx0YkmP50Dbo7XurRW52Fqn2ABEwCAl6unqP?=
 =?us-ascii?Q?yHspcShc965k0VsHalq/Gid1ENqDsowUKFXR4MIc6nPeUDYYes007g8bo+gN?=
 =?us-ascii?Q?mdO5WmUztEmf7WUFICZwlJmKoCi0ZNlvpnbTVxEZidvNXWHWiU3WNjMKkjK9?=
 =?us-ascii?Q?brik01IcnXUWPqnM4x0sKt5yJznQT2vOiwiyxF9BuZnLMdDQgvKDmYIPUPGa?=
 =?us-ascii?Q?iqnelwIwJI6eGGfq+CHVailGOEnJ7m0IvAicnWr+HLr2ebPWiRGm/gB997UG?=
 =?us-ascii?Q?RjiSnfA9BhLhksXKz1rDTO0qBFLSvO2J54JWqIj4PrLUoDHLpj5MLS/YU2Tz?=
 =?us-ascii?Q?emC7UPzIrkqm8GWmjsNxPD8BNraMZ/v2L0javSRcYubcbrU/Qga/4OrMcZre?=
 =?us-ascii?Q?mi0O5gt+Uy2aDjpfR5mngOamEezTN8vusf6gJEjxZkp/tnUV8HAhEoAO7RiX?=
 =?us-ascii?Q?wxridm4guY+KM56RmuvBZv3wJpErVW+LsiQO07tImWWhtCYw8ltU1XQyH5pO?=
 =?us-ascii?Q?YpfrI7t07qHp+eiOj14vzrBmSIgX+PnS6Iph5ggFZarkUwyLwxhIzljH+/eT?=
 =?us-ascii?Q?rKLeIGYpJ40Am5gKuQVx+B8VhDuGYewUfkk0c/ZsoFQqHruCNCC4zbsnRtoa?=
 =?us-ascii?Q?O5AN5rk6fOjnmwsoNTJOO3/JKpqEW5t9cgAD4l43zh9pJR7LtW5JjHUFlSct?=
 =?us-ascii?Q?H6X7RPgrBPjqsIfj2Npe3mfkVwQTe15z7KddubLPe07vAuSBSbo4hw7Sqi7Q?=
 =?us-ascii?Q?8aPNo47O1lBF2iGL/Aft4g6IA/wX0UsUX0hzNZHxUEwn361nGNOWjHBvfZzE?=
 =?us-ascii?Q?N19NLBJF6dWa7IER064gbAcu5WX8O9YFlKBj2kg4zVnHqwPBLw9I481XaATs?=
 =?us-ascii?Q?M6xKpJXjMmqLVOskVyz42tPTizOAoDHZJsSXAEnlYVFXN0XO0cwie2fkPaFZ?=
 =?us-ascii?Q?g8RS6OBaMLJr4EM3uTQljHPzavOYBJb9VBIqz2hgmhK3l8vL3k2w3yy3Qios?=
 =?us-ascii?Q?8tTtX+LzSrLVMWoHD9wFO0SI4Wza4WEc9f47OTnr1brY2Hy5yktdQ6QC12Re?=
 =?us-ascii?Q?ov5IJ84OLKkDwC+Iy/Vd9D4wPXnQpDj8A+jKIq7TnEquOLchs7o7Y0qGjen5?=
 =?us-ascii?Q?16Kgf/AKmC+QF0rQiG4RWP7AxL8L+V3sYoHIfabsQV8vBJ8WUG3Rwc6AUr0T?=
 =?us-ascii?Q?4JdesKjLijr9ikqD8SRTYLngG8Oa85oxWd8YXXWU3apv/vZ8BjPLjwTsvAlG?=
 =?us-ascii?Q?kk4LZDJFrY4qkyJk/oYreQvEfAWTrF/MCJeBdLONIIgTcS6VfP2H2Rc3R3cF?=
 =?us-ascii?Q?NzmUtuyiAFVgb6rV+x21IcYWSiuQ9JY+Clt7UxpxwHJ/oT/hKMOtA3IsfQ6P?=
 =?us-ascii?Q?k9HIWxLvhGhNfHp7f0MOlu9OavfqGv9WdtfxcLtZqn7eZg3yBcB9LNKs9VKk?=
 =?us-ascii?Q?npqM9ja4rg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b626b148-e3a5-4d1f-f5c5-08da4d3b61b1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 12:51:06.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JskKUAuxf7ShdWAnvET6arZLTZ6Ykhn/sJPfhkOriin8Yp00q2kuX5VE6aPB9JZxBI1QegpaziC6DICQhzjSVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2449
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Both RIF and ACL flow counters use a 24-bit SW-managed counter address to
communicate which counter they want to bind.

In a number of Spectrum FW releases, binding a RIF counter is broken and
slices the counter index to 16 bits. As a result, on Spectrum-2 and above,
no more than about 410 RIF counters can be effectively used. This
translates to 205 netdevices for which L3 HW stats can be enabled. (This
does not happen on Spectrum-1, because there are fewer counters available
overall and the counter index never exceeds 16 bits.)

Binding counters to ACLs does not have this issue. Therefore reorder the
counter allocation scheme so that RIF counters come first and therefore get
lower indices that are below the 16-bit barrier.

Fixes: 98e60dce4da1 ("Merge branch 'mlxsw-Introduce-initial-Spectrum-2-support'")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
index a68d931090dd..15c8d4de8350 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.h
@@ -8,8 +8,8 @@
 #include "spectrum.h"
 
 enum mlxsw_sp_counter_sub_pool_id {
-	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 	MLXSW_SP_COUNTER_SUB_POOL_RIF,
+	MLXSW_SP_COUNTER_SUB_POOL_FLOW,
 };
 
 int mlxsw_sp_counter_alloc(struct mlxsw_sp *mlxsw_sp,
-- 
2.36.1

