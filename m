Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748A457F3E6
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239767AbiGXIF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239302AbiGXIFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437746343
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FehXjB5m99NVhoieLeBx2aX8jk6bc0ZP0sqsAbhDG/VN3Uix9mmZwurnx7ONMWxUKAaUowgG3v4IMzOsy/f1QGQJVnx2GRfw/bxE/Smnnu6E45KIMR5e6wyaQGqSwpfb1gWSV5ms2biIegTuqFOBmCqcKaJEuqin3R2MAP1U5hCldErIzbhHITe5i9tXjR25Qzhu6aDvhxmr/9LAcKGNUdE1sTgfaQKioabF1gNA70jcd8tCrI1fOzP3s9zKKZRYWspvt+AqDqj76COr8GcnYrWmVDL7lRt5UN11d9ga2wefws7jm0Z4MMJwtTIeOlp8l68CkNntltkPngCd1XWJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yvs78+IulLzC1y9sZJqHpxUt95coGY58mM6gad/EuE4=;
 b=O0ZKenyvSsvMZ7/EtwiXoArcWryJuore2EZGccLV5gaVmnV7smc0LyIpogBBAtfhXfaS7Ss2t9I2BXkES24HA9WxwE+8DyZrDDoobw0w+62JslDlJAo97uMTpzrwr00rudqrYdCK3kZy8ZAh06JYaPYPcHuddcfVDDE1O/23d78Y1RrWDFfFm1+6rs2vqXvEwuKNXNXMCi0zJmlbfG7mVaFJwPXNDOby6dKuVEfvziQrSfRDev9K9Y+UvPZipCDq1ErqLExAnNcBekBlbbncZJnIvNbYOR2mzJ6ojntBNzydDCosG0qrAxHQbi9PX6tCOVzqcfteO4eTHBu1MRthPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yvs78+IulLzC1y9sZJqHpxUt95coGY58mM6gad/EuE4=;
 b=bwW/7TWxHwMD69t8hT/fcc3C9oG21/sJwr4ov3ZI35l7zaJ0lnDIpygqF5JzC8sfYfqC2Rpg0St6re4xyoOCSb44TFnXonwqEVB5A65wiTq34ON3BhoK91RSzyIeeJbjoy9Xq9Ls7+aS+yFU4EhjAJe79ckhZJM7NTcsX+Z73BWxIIDSYUxEjAwUlhkVELthriITT9Wa8EbBw9wS1H6zX5M0GFFRsm0WVGvprbSVSQUhQEBh4U382ox6eum+XdpoljTdMm0f+rYnIhNM7qpy7yoW++r4K9tDYYfWoXCDEpZTBuTnYF8+tQ6YuSY9rla/zifeFn9itby8qBzrODJbXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3877.namprd12.prod.outlook.com (2603:10b6:610:27::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 08:05:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/15] mlxsw: spectrum_ptp: Initialize the clock to zero as part of initialization
Date:   Sun, 24 Jul 2022 11:03:24 +0300
Message-Id: <20220724080329.2613617-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0582.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e74af3ce-911a-4973-84f1-08da6d4b3fa4
X-MS-TrafficTypeDiagnostic: CH2PR12MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q5Qg15w1E+O8RhwntN/7dRg7IpXY32MnN8vC8SCU4723xomkuVcHchvISYqO5zXpTAOEnV3HzSITeZ4uMKpJAZ6IxZ1rPoJnoyR5/exW8gmfOT3caTU5OxIQNAZkZ3mLN/FDLhfMUY1bQQsUYkC8ST850iFIRgO++hQ8yRN0a0TB7uJbMLv+36IzkF0RQha884GTXU8UbjCJKx/drCtQRTFjpm/S9yJF5DkWnhdpUl44r80T3G+qhBsqM77H7Ub5NsdnAG4jPm7KgVFPshSwJxz1i72kkuR6c1FLrL++2ZmxYRw+g4STYidJKavJqpirWof0JhYmEnSPUia0uB3b3xjMq72TNGSsYB9sQdNMxh8CU9TOJVcVxG4ZgllG/CT20fZy1TpIbGZAZAxs1O8Ow4KytRMSPoMfvgbd1+rSGPkfXPImyaFL6Hr+rFRQW+QNPnG1pGzKed54DeRPSUNlYXLW6X3e+AMCBBsWjQBkUfaDsNMLj6zturEst5eW2d04AL92f3Z0Tp+15ddP5E5s7JR83Ybm0qRmJUqePdoNYFMAQ4ARqMxOYfHjXF/+/ujapIqYGKGRiRI1fQ6mk2C3JWK5pYGI26TiUDK5MleDOP20YDO6D2FKpFB5dbnXZNDDBUMHWZFL8VZ/GoG7CWYp/iOr/CkEpsz4LvZLk2/ipsF5wemDw8Cs0IN4A0C5pvIVFtaCjYasqI6XNBoLdW2t3VVp07TwLX3oiQ7PtKwMBbmh0YbkvnfEPnUc1f2AHN3HGExmnBX+v0AkgnbTDEyJvyTA6JdD6NTEWlXf/dIC47UYBuAylcHMCvUC+cDNqOb4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(186003)(1076003)(2616005)(107886003)(83380400001)(4326008)(66946007)(66476007)(6916009)(8676002)(66556008)(36756003)(6512007)(41300700001)(6666004)(6506007)(26005)(2906002)(86362001)(38100700002)(5660300002)(316002)(8936002)(6486002)(966005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/c7MW2kv2QzpgSVXZsjLI+bw4pw+DS1ceRwMoHpVOHbFa91rC9FGyWCuATma?=
 =?us-ascii?Q?EBjmMQr8Ivklz3tpy4VNvlrbO2VezjaNh1yT4gY0OcJZ6ecTpxwz0vjsxmFq?=
 =?us-ascii?Q?FWnlYuiBU6Xtmad33uTJ7iZ8dTDayL+OD7nY09bzunSBKKqml1OpVqdtTTps?=
 =?us-ascii?Q?E6UjPhZ6v5Uat25RGVs7iMFA4yZ0xfOhyStLeY4bMfuWJ1V7a2NCJ/OLqYrZ?=
 =?us-ascii?Q?db27S3yalwulWssjDRyQ9bXOUpf5YhaRVgtKbvaDndzIFZieNRlN/10KBvej?=
 =?us-ascii?Q?K6vrIP4ngwJGk3LlEKiHyG1skky7wGh4kA8sw3iG7hEX42f7IA9PBWRpFdEw?=
 =?us-ascii?Q?27Eax5cVGw914xr72/sZzWAiNmq03RmzOxWRlXhDQhteMq96B6orPISnBlqV?=
 =?us-ascii?Q?gaahFf4NO+ikXKUQSvgTPWMxmXgzq03gl96gN8hOW25L716jyBm4q/p0ak+E?=
 =?us-ascii?Q?kX0J2geq3nJMjZGv4zaQlo+ZeUzlU/4+8jta6DtbNX++eSui7DjZdzoRxzu1?=
 =?us-ascii?Q?mhCpVMCba3JvDqw/zVbnSG05ZreMEp0RtglrcZs2PsVUyDjMj1J99+2EbX7i?=
 =?us-ascii?Q?i2yGrytszYkBGWGTDvgkts6GAihJeAixSiHp2t2cBz4PBRXdE+JQ8UBT7Uq+?=
 =?us-ascii?Q?87RBzyyypKzHxl+cmr7HKp1Qr/9YPWElBv7tOqW/MV3nHvWsljaf0zmrFuYN?=
 =?us-ascii?Q?swkF+VJDy+zIdJr/VtExRSqmL9ATf2ryMZy7prxVt3k0EJWtiwtgAbwEd4kX?=
 =?us-ascii?Q?3n5wHibQzYte54CeNDJDYP5Q0lNxIjInCu2r2PeLIhQsnpAVN02FlJrMm5G8?=
 =?us-ascii?Q?aP2vyzHbvuyO6ao7sFfRPIKSYjy3gqPBP7Y8GKZeMqxNVXA0fxABpHnXYkhO?=
 =?us-ascii?Q?P4OBfEpz28dhZMV5HwMX6w0RS93ncKCk2jMbnzC1lma6CkRkIrz2ThwdTq2G?=
 =?us-ascii?Q?PR4L+NMWHg7z98BViXdXN1Ah7MQvX8piN4byPht2CFu2EXPca49PVGyLqGHp?=
 =?us-ascii?Q?Q7U1v6Beojzqync80mBv8qMPafti6j8NsvhjiHW2Nv8w+ZKU1UFx2D5k0nyS?=
 =?us-ascii?Q?ePPMaCadO7zYhVlNYkSti6MROWmSPlwx/HS4kTAT1iRfRMAJyw5/nrUAzicx?=
 =?us-ascii?Q?wBZW/vQiH7cNVHUHlj5VdXupoZ2dUY56stp5wccG4DawMOVt6R1PxiUNw+v5?=
 =?us-ascii?Q?KzNE07C0gtBiHhjR7u0HpdwFH/30mWhg1FG7euCNf85n0BSuUWtRKFuu8FEo?=
 =?us-ascii?Q?pToauoeK4W9g492y6vCyPLlJ4dt2GI+z2ACyuOs6KrisRDYXpWWCw9my99A7?=
 =?us-ascii?Q?vWD81UKyyfyhRNOozahq2aLrlgbtIVehuTHV5uwc4WcIQKobvP7iduCTidW5?=
 =?us-ascii?Q?OnpanGrM6TEcWxmPPBs5Hvwog/XjfBceKA4FjDzlAvZQH6Rg9phPfKYASTdS?=
 =?us-ascii?Q?1TNMmCuFSlh8clBaTm58FmP/5vELfDBBbVQSI5Ei6YTyo8T8HGNreUZDtEQY?=
 =?us-ascii?Q?3qZH9DnA3GmsE/2Iwx6rvIAFVaf2Sg93JaIFrYdo4FtiAbQGJElr9qxqOy5p?=
 =?us-ascii?Q?CuFgBkyxA5TG2Dsl9XkoBFEVtSWkVzvuygYY9qtN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e74af3ce-911a-4973-84f1-08da6d4b3fa4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:18.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KjM5A3ZtzdX5m31WLEbyutQJyUbWwrafkLdRheiTA6sqs1xj0aGrD8wzeC9w3zL95GkY6ouuFsn7jh+buWUfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3877
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

As lately recommended in the mailing list[1], set the clock to zero time as
part of initialization.

The idea is that when the clock reads 'Jan 1, 1970', then it is clearly
wrong and user will not mistakenly think that the clock is set correctly.
If as part of initialization, the driver sets the clock, user might see
correct date and time (maybe with a small shift) and assume that there
is no need to sync the clock.

Fix the existing code of Spectrum-1 to set the 'timecounter' to zero.

[1]:
https://lore.kernel.org/netdev/20220201191041.GB7009@hoboy.vegasvil.org/

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 39586673b395..eab3d63ad2ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -267,8 +267,7 @@ mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 	clock->cycles.mask = CLOCKSOURCE_MASK(MLXSW_SP1_PTP_CLOCK_MASK);
 	clock->core = mlxsw_sp->core;
 
-	timecounter_init(&clock->tc, &clock->cycles,
-			 ktime_to_ns(ktime_get_real()));
+	timecounter_init(&clock->tc, &clock->cycles, 0);
 
 	/* Calculate period in seconds to call the overflow watchdog - to make
 	 * sure counter is checked at least twice every wrap around.
-- 
2.36.1

