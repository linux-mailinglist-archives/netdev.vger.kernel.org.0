Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DC154DF5F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376343AbiFPKoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376562AbiFPKoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:19 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71C45DD27
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X7kYfQsqYxujYayFeRivRbzrY1cpbX2ugsVzokeopuWCU77WtQlJIf+zVAp248JbNvsYb5DwU6FyVmkEovXSOKxkbGjesvDiqBZ4iV9wbuWjgXNijwsXY0ENWq866KV970IlPNAtlLyMMLYPxAtKPThYQcN/6kYLYw5Am6m8jWig9bdNftzj4Xooo+aIzeJS6N8RAjlB7R7fl0hW8+yHwiGOf5/R/KHg6T54ZQIGwHHCR8ZFsOSFGbIdvrtNcHYwedAyiik21jUGWmdKB0OWd5KgH3kG8r5DsNoQMCVNZpsMtZYvcb6dsnOCbmnw3HHDTsRVu1ViUQKEVp2TUCN/Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSNBMQaEil1n3xahRudgQHw0afkL2VRZ/6KMoHt+xTI=;
 b=HN7z5dbt1f21C6VMsZPKRTimuv/7NHjoiWe0sGklvzguUS8LuCCWkeilU+oHKsZqbBFBydrgdOaQwjN0hjIpAFL0+r2ZdJa1lw7fY3cR7h9Pcrxb6csKzcAY8cnB+epad9sW4AK/O6xoCQtqe3TtuL6/lvdbfPDuv5ntWM8QHHxK7bSiNMLxR8cCRisqD6a6IHU/TgStyu+K3iMDb1gZufuiMqiAelhbcV5MXYNDq+3bH/r/p5TWYk6zKKQdGzgxAjIHfivrcqfwoyd8Wcdg3dmQ7enCZDsWSHC3YOVPU9SBZE4Wmf7U84Psk9gzPLk3/1Ik+dAt6TyiVHxqj1xVJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSNBMQaEil1n3xahRudgQHw0afkL2VRZ/6KMoHt+xTI=;
 b=QZKgtJEhvxm43w6fr13pXHoQi5/+FIjAgzYSTkz4K/lZws830N8vgJCNvEEINxVHi7w9UgBo2hIQtRwXDPvQ52LQMtxR66U1RUO92+w7ZGk79E9v1JaDHrgvztZlAh8TZj5tyL6ky8G8W5B6sPB/ys3mx/PCmKh3fkNqZQeO5cuZ1GLg5Mg8flvun8RE1AmZXWZYQp4HnED61oo5XNaSXRMXfbGAyzQ4TDOhKRWUwD28znIeWVaX1HHXZPB39GKYZnaImDcedUQexq4Dk18rU7Yx3CzjZIwu0OU9z1s2pNpYlB6GqXo3X9haqtytwFQqMqDjppGEzNJlq82yZDugag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:44:16 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:44:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/11] selftests: mlxsw: resource_scale: Pass target count to cleanup
Date:   Thu, 16 Jun 2022 13:42:42 +0300
Message-Id: <20220616104245.2254936-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0030.eurprd08.prod.outlook.com
 (2603:10a6:803:104::43) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c12a5bd-3832-42cd-3fb2-08da4f8528cd
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2504176E436C9F02C713C200B2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNpEs8D5ll25qccKJ5pLZ8Dp8lLMN+iRASo8Ea7gFPrZhVRqJZdjto3I85Db4rmjDf0LoyzOGWH1V/u8DoJSLQroDN5DkeTVCbVg4WG7GJBEVOnCTDa7+Vccx0+sYPWknzw+w030445r8fgYBSWfvX1u9EfxdKaz5qlhkt5zs6AzgOk9HJiuMphqPl//54z5axuf94R0D3du1r4o9cnNTS/2VrMvVCQof1PaTr3SGgomzLumdb1eBhIMfoMJ7nasBxNUzcaCvqjkq6T1u4iuVtNUh4ikuGFZ84IHl5ipYvVbHcqOHphrfQCoa6+MjDsohpLWdSVQt0rZi8HKBX722OXSZMvNa9ApgXE3O4pjoF/tC4liEsaBWmhHZyDmf6iX7CCqApfWjal+RAWaTVNAD/HW0G5/QG2ekwKU7A1G67VPNdWmVnEmhxjqkbLcKPjldOg3llXXn76FEkGjBxDrgO+TmH0ZyuP78FCZjMEp4/e5Wagt9OOABEcsbMZRn23qZemzg7MiUEBAL2pI9HpxMOjfhOvo8oMoXQKsUh3GP82Cp+qc9iEFbHvujMtLffQVzBg4XWJ6zDDUVJ5cqjw0NsKddXnNUbUgRDuSvC28QpyZskS47wVULMsn32fgPa0VWr3ovFYd5JLtgAvZIyHWEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(83380400001)(1076003)(6506007)(66946007)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cwjRctSWxHQs41FNqxZFDJfa4ra0e4ZdB11BqG3FnWtUvnamI7kesThE8rGN?=
 =?us-ascii?Q?TiVHWGrsMgv3YjABoGIzy61tDIDtt40Ey0MwHs/Iq+MsQtt/nbp5MLxXsDmC?=
 =?us-ascii?Q?rpyt62Ad6AX2wozR/nDzBzNUB7DR7zdShQ1JtwA1HbalPKw1H4g4sl+y42+c?=
 =?us-ascii?Q?GRDRz6Tg/J52AYE43BEHSwK7Fjz6G54p5tR5wIGQzhte0/4+lOiOrVlbfz6f?=
 =?us-ascii?Q?SzC4XQJT8H3vK6O0g/KxRshl+q9hNv5j96K0iLaOttk6QmsxSyFbgMddUIME?=
 =?us-ascii?Q?kctptdYua+6jErOxjmRvSVifIw6ulDuG73oJHoUmarAWWoe4xTvbh4cwYJP3?=
 =?us-ascii?Q?UIPMPrCpYCm9xJvRkpm+zL6iHx4CCwHFSxgRF50VwmGMhj2C3TkNOEYvXEv2?=
 =?us-ascii?Q?ikpVpA/440cYVTVKAhqO+nz0lCqXEhRKPNA+WBEy4azni4iaBdNI1LS3Z979?=
 =?us-ascii?Q?62jXZ7kAp7GvR6QoU0uXYfYAWww7IYfn2WEuFGhfmiU58my8JJDhG/62C76k?=
 =?us-ascii?Q?6GloDufMyi8F7+TNmEwHVjQD8NQ21wg9XCsekpEpPqUznX1yBGXxNLlYHwHT?=
 =?us-ascii?Q?JvWUM7R+Xy5JYxFFSq7Wxo+ZZNOJIzPkfYOUK1CZtg9Qz6f9zAaW5+9h4twj?=
 =?us-ascii?Q?unhJzUM5AxoFM7JS/Udm5WjtHhbhWjMHBld3+SuSN85KgbpDMuFygBUmGXIx?=
 =?us-ascii?Q?+1mOEGw3WkACDtDWKUhPcC6CcPIZ6jWBZ4pDKUJl2ohxPRkaBRLc9BOoAfov?=
 =?us-ascii?Q?c4WQcRJ90Sw9Av3ZHYhfp2+nDPtDkzX4BSbjyAiqngmxO3k0sEg8M04hR0/l?=
 =?us-ascii?Q?8bMBiUgkVw+Y83SpP1T3eJ6sa0xJDr7fLU2B3GL5ID5rEsWA8jLPexC7JC8y?=
 =?us-ascii?Q?pCDtSuyFly7671Az3/Hu0pug98Ce+7++5kEvKwyd81KD+GPrDKyVCKioYKnm?=
 =?us-ascii?Q?eIHfDSjkruasUvUsH3FLPag4wiju74yydMTROu9TeUUwObNWUFVDFnJqm4y4?=
 =?us-ascii?Q?sGDbC9lnaFz+XgGH1QdII6KXCNuLK+UXbwx2xasixPDTIqx5mg69gG40s/+l?=
 =?us-ascii?Q?ICzREZsXD3hBMg85ng2ug6UZgu1Haq/3zjCK/xx4OyNtp4JT8DF7zYqRdSgr?=
 =?us-ascii?Q?GyarakTi+xbMX9ElKcj+Rj+4SX78NTvFg0S9/tjruQB6QcDjoYDlh8csFdBD?=
 =?us-ascii?Q?YrpK65OHibc8tYruLLXHbKRUp+Dp3cSz3IxFP08/w+dM8cW5iSLclC2MXPgv?=
 =?us-ascii?Q?KUWdRHP7xzhAvrQTO9NMGEyKhvh6PairGvnUY38TaVWTu2wEeM/DWFbCq810?=
 =?us-ascii?Q?3/2WqANqC/yAA0KVDw2b5/yYyJ7WEkhuiA7/gzQvy1nCWKgU4G264uRoBX9G?=
 =?us-ascii?Q?VUEy+nEmen+ZamTfnu/aQ3Rj1mnjmZ1tAFqmdovVI5WWQ5RaaP4CUMJKIHfO?=
 =?us-ascii?Q?cGIPZlUDTYQMqGo7rDbp8gfcmNvUwjj/8grol9Ciwl7WDSyh5s+Twong30Nc?=
 =?us-ascii?Q?+2KtUeWaKtXH/OixXwtd5Oxnn5+8VIaTcnfk7kgdq+XTLwUaehOcw/0Y2Vi3?=
 =?us-ascii?Q?9qx7LBNKT4FpTePmQpoPCC8TwHqkwcQGZ1dI5QKbCMv6RgBKjx0c6m0sguEb?=
 =?us-ascii?Q?5iaOLF6/zibWYkhL9TG2ejzZqleiDaljOFDw2z1QsPDEVZ1Qft0sN/rkd8lV?=
 =?us-ascii?Q?cGCMhO0vqHGYoiKE5PI58eOj+VcSEHk6rrQ6QWlZnbVaP/UbEhLpIs2k0mCb?=
 =?us-ascii?Q?nDBtFsWUzA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c12a5bd-3832-42cd-3fb2-08da4f8528cd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:44:16.1224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +WzI+rQz1N+jmcPJ7b+tlxLmwdU4Q/EuQsp4Pf3ywse1Kqm62OlAQxcfQXrPbtt2D229C5cHQ5lCmtjmg32rnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2504
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The scale tests are verifying behavior of mlxsw when number of instances of
some resource reaches the ASIC capacity. The number of instances is
referred to as "target" number.

No scale tests so far needed to know this target number to clean up. E.g.
the tc_flower simply removes the clsact qdisc that all the tested filters
are hooked onto, and that takes care of collecting all the filters.

However, for the RIF counter test, which is being added in a future patch,
VLAN netdevices are created. These are created as part of the test, but of
course the cleanup needs to undo them again. For that it needs to know how
many there were. To support this usage, pass the target number to the
cleanup callback.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh    | 2 +-
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index afe17b108b46..1a7a472edfd0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -60,7 +60,7 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		else
 			log_test "'$current_test' overflow $target"
 		fi
-		${current_test}_cleanup
+		${current_test}_cleanup $target
 		devlink_reload
 		RET_FIN=$(( RET_FIN || RET ))
 	done
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index c0da22cd7d20..70c9da8fe303 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -65,7 +65,7 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			else
 				log_test "'$current_test' [$profile] overflow $target"
 			fi
-			${current_test}_cleanup
+			${current_test}_cleanup $target
 			RET_FIN=$(( RET_FIN || RET ))
 		done
 	done
-- 
2.36.1

