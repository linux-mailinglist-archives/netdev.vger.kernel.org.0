Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72174CA9F1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbiCBQQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241428AbiCBQQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:16:14 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831B1CD331
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:15:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UG7Xq+As3QSNA90SNfiNauK6FQGmoGioK61lrKZ6QhwLLjvlD/SQlp2m0YUY+WFrCSQodcWQ4pT+dexz5OGrTphfp4Nw193whVZ/tNlqyqZELhMkzYaRld0TJyPVfgE+VPlP8p8mn9WqgOteEUP8cota8/n5UpfmFCgjaYbBM5Abe4s46MR4nMTQeARVkiSaf51R2hBkzrO11pnWjOVO1D4CfO74duLS46nC8sYPPpC/H2jsAoYn6ddWFu3DsdZN1mtMAiisSLKsh4RZj50gorv07E7tSW5tXgbK1PNu3TiluFSA0MlaeaHcrOZP+SDhsnpFOBdX6KeWXBfg3JOmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkaQZwCNGlz+FfxSIA7yUgR9WxIHtZDfqPCavE2rNBM=;
 b=OKO8jGGMKfU7Sdmz+4wmv8Da81BxQ8btGbulLAy1Pwe/tXUw8mtQxiTVPIJbTbNzmV3x4gVAiL6rOje/KooJo8jNeujrcPd56t6S/JCOa/6B587iih8KSV4xSFpK+1m5ERUcAO1rQN/GHeNh0XHEGlkSVyP14BfioPS/MI4+wVptUpRSi3GT2/hGnjURRBmfyiYHUV4resqEcsb8rl6mszeR0VEySA4Dn2UPdfkHXm9fYmL04AxQd+Pgiaeogpjka/zuYen5H7VhtyV2soZQcd6Hm1Frvzt0H7EtisEPwWqFWvRIdPPS8lmX91qNNgx5cl72n2w2ZGJLT9RLcORLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkaQZwCNGlz+FfxSIA7yUgR9WxIHtZDfqPCavE2rNBM=;
 b=HbfcLWGZ+2LklfYYtmsMINQFhy1truUbb/mJ2bZp+bUV9vbhvzXasVfawSGFwpiyz9o2UYLnXBMQNk8x1zY8EBztBN6ZZsOpaIqxjGLMiisbJwrpFpMV/dgvR4F5WRRRWxd9LN+Ztq42f0fRbDyvr6CEa/lBhyttfZNCNIYSqlFDomAteHYCKR3w3D9nvvLhTR0Y5Vz4+jp35SjV/0e5rKLf6hH0T1OECH/ZJqn9BRqu4kXLPOGuyFCAEgzclm1v9sW9kmaUtExoP0rRl/LJPIY6AZUAiT0Jgb8iI2t/CeT69B1QxBKPR+59EMgGZG1z4fneRbORYheoNUUTWEbV2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 16:15:29 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:15:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: mlxsw: resource_scale: Fix return value
Date:   Wed,  2 Mar 2022 18:14:47 +0200
Message-Id: <20220302161447.217447-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302161447.217447-1-idosch@nvidia.com>
References: <20220302161447.217447-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0137.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41d0056c-679e-4a8d-82e3-08d9fc67de6a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB513647C8558B4F9416ECA390B2039@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlhTdUwAghYU9e9ay0Xjug/ojTICXbRqIeO+qR6c3lrPbxyPyhHiY8fyS8MTnlKKc3ROmy+jNLE6oi/fnHa+vdg174eD3nRLXV3m3ASlHmBUoeW/OagpkdOudnLzUk9xkyjm4fEWZx1b6w3YDPhIv4DREgJMhTnPNgWhIU3cGux2rS5+QNm7Th1eF5ClUu2pUj5YuIWJWuFXRMwDMD53JgAx2cOLBsCgftbFtMyPUrRuG/Km1mYLBK0dFX+XJmRTjChXtr8lYBxniDhPFE6Lu7/dW+Rd/J1WapL15VIoLseTRoRGCn4fuxex+GSjHlMj/CvL8AnLvHNiqx9RUX/8iHPfUIlb7Ksvpgg57EdjInSKT0e+XSgUvJ0eATib1Vs6gEzaGrg2A0vZjsGsrbDXAa/Mpi4277vVEY1uqWc0BQYmVHFJEO8ryb93O6I+QmC+qVsg2+SB+dpAJT+IIYpE0P1Ir6pnahkGzaePJisii0Bg5xMvft5RNvOmi6FaTn0eOM9SZyo4efRM6Ot20msfzuMUKk+j3JDRtBRh+n8luNar3Q3KXj6OhLY1iLToGedamv/6cOzFDjQ4o9eBpy69pob3bLHeUZRLNDsAcmVFHJSdFLq18c+DuBMzlc38OYypyDDebbcjTLxL2BQ/U8R89A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(107886003)(6506007)(38100700002)(36756003)(6916009)(186003)(2906002)(6512007)(5660300002)(26005)(6666004)(8936002)(1076003)(2616005)(316002)(508600001)(6486002)(4326008)(86362001)(8676002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hi0uD488Wh6ELtbbXCwET84lJUyL4y0YKxIV4DvJm89o6VcmHtInpImbpLFD?=
 =?us-ascii?Q?YMWJooPEGdsyC/yXuanlzDjxPornhYa3bwXnS861Hn+pDg7YEAYGRFu0tz/4?=
 =?us-ascii?Q?U2ZMWdpor86zYku2Ud5UjbCMR0HVIHAYNEkHaopOZ2ZANur48p09r4/ZVF++?=
 =?us-ascii?Q?sSDIgn4pWRt1bOCSFs4K/MPHYq4tbDFeBOEfu/605ZKlo98A2JMy064tJqkW?=
 =?us-ascii?Q?7RpZ91MWQ1C5Db5Vcq/z37xrxHLSJmWtf8QU5PUsZp8pPXlwnXMtGEwCD++6?=
 =?us-ascii?Q?0oRvxJSBwUhQHP385YdylEdZDe8Ei0rdFlpdOyO8i9FJkn4+MmstkjhweCLU?=
 =?us-ascii?Q?hy92WfN9JA3LNbRr6o1bOUHQxO5hC6U1pvMtKmc8oe4xazv4xzz2b0DK29vH?=
 =?us-ascii?Q?tdwfbm1v5neLwn7aWRcVlGvPFkqCEpGwlcQCpdkKVhZOBerpCKrTfmj8NqqK?=
 =?us-ascii?Q?++rYrlP6TbO/nMpcT+IFEfbnu7SRwFHWgYV0cQe9TONSkAivSU1bw2FEa9x+?=
 =?us-ascii?Q?OoLFe8DxSz7y+Bq+VJccqXTN5obG8oy9zC4lFpixBT1eldxQnIv3l+ZMivi3?=
 =?us-ascii?Q?PJgBQA74yCsU36z03DsCLJEe1wgUgpAQ4k60zH9rYmosj+2TetJUw6bTbNYV?=
 =?us-ascii?Q?ijfpSZ8GHKBxdOQPTbWGbVO6lTvHGmWUePL0qow2q+8ktdtSguW6RfWiKaxg?=
 =?us-ascii?Q?H7LRqncsGNN7C3jmOnsvXy1dpKQFvLkJzNEZ0cdxJ4NT2Ag+ZtKhLZ0ZMjte?=
 =?us-ascii?Q?N87gvILQTA0WgYG7frbnTl+AVPsXpZcdJE49zXEqvtN8eqfUhyLioarVo4yb?=
 =?us-ascii?Q?dwC5BaoiLEiFZIqNsT6pl/eVx5QTJLT1/pccJadRxEs5ydjuKxqeCvvWOf/K?=
 =?us-ascii?Q?2PJW7iSRq3++wrihH7+Pi4sNl1RfI9Y+gyN7FNxeQN7LW2JXDcq6TLdxZnpd?=
 =?us-ascii?Q?KgP4diYARhJJFR8IeP7MwxBwqOr0He7E7xpAT+pjKAathsfBRxIATswefK0D?=
 =?us-ascii?Q?fhSy9ziBtKzA3VlpMmC+NmOP4e9xeAbvBQ7KTqCrkWICmCxSA1oUYceFXrmZ?=
 =?us-ascii?Q?weAtjimLyuMu2rXBmTFCiFTvpmepv8J12XlZmYTwzndoB+ZMv7JjF3YQGi9l?=
 =?us-ascii?Q?4SfBmIYNJVuIMEpyDh+PG4AV3+VAzy8PBb8VM/cYpQwsPS7qbgU3a36FkEg/?=
 =?us-ascii?Q?mJdYDRP6Kjx43vTaNHXZ0KTvf1Ls5MB4dLtIGA/XDpBFBc1jxcUUR2dcehNV?=
 =?us-ascii?Q?LsQZDWmZ3lStH0Zs10gZQQ0Kc+iGyF4h3CllJbr1ZUNxV1FsARzpfIm1boCY?=
 =?us-ascii?Q?TFduTTqyU6PcQk98fbHP5JT5UbwEzS8RM9u9ZOenfw7rp/RQAw8wt2zBkYue?=
 =?us-ascii?Q?nIrtPfBHdrdIl/AyUJumDb3MnaXNEEJlSjLxtNt0tCLggXpLU+kWydq/Kyst?=
 =?us-ascii?Q?meSvVYNH1+Ij57/3iiCJIXDj7UX2tSi41TH0N13x2yjKfAA7XthtiXCVE1uv?=
 =?us-ascii?Q?JvC2eP8P2zhR7irf0H2y9uhGJhWq2JqNQLGvaOiBBM2oyH52xz3LMwFB3NqJ?=
 =?us-ascii?Q?PGksuzH/dvqQLH0cDii+DKtsnXZIp8A7vqinDJYhXPBQmpIME7VCTXzcdaPk?=
 =?us-ascii?Q?6nHmFMlarF8S6kJlGZ6SqeU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d0056c-679e-4a8d-82e3-08d9fc67de6a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:15:29.4238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aY9Nm2B4fA1+OHTcqHRJ1JsD+FI46kesk88yWHy7teXZVIbPjHAeiT470PilcqLPHGBCLZoRkpCnTLmLlgZVQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
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

The test runs several test cases and is supposed to return an error in
case at least one of them failed.

Currently, the check of the return value of each test case is in the
wrong place, which can result in the wrong return value. For example:

 # TESTS='tc_police' ./resource_scale.sh
 TEST: 'tc_police' [default] 968                                     [FAIL]
         tc police offload count failed
 Error: mlxsw_spectrum: Failed to allocate policer index.
 We have an error talking to the kernel
 Command failed /tmp/tmp.i7Oc5HwmXY:969
 TEST: 'tc_police' [default] overflow 969                            [ OK ]
 ...
 TEST: 'tc_police' [ipv4_max] overflow 969                           [ OK ]

 $ echo $?
 0

Fix this by moving the check to be done after each test case.

Fixes: 059b18e21c63 ("selftests: mlxsw: Return correct error code in resource scale test")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index bcb110e830ce..dea33dc93790 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -50,8 +50,8 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 			else
 				log_test "'$current_test' [$profile] overflow $target"
 			fi
+			RET_FIN=$(( RET_FIN || RET ))
 		done
-		RET_FIN=$(( RET_FIN || RET ))
 	done
 done
 current_test=""
-- 
2.33.1

