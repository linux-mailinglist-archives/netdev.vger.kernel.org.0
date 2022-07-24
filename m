Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC057F3EB
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbiGXIF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbiGXIFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B23FD0B
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsTMZmXPjofQDho0vUic55avSfDXK/YT70+d2RRuTv1SDSCAiPRjusofFjCdsv442XCdO8GYIYOat84Am/uhHtmuIza2rFvFQ+mccAzODIIjDAkTTyCAhCSaJDwHqmd5lZsKryLq/eUOEj0u8WQF4MowrMCYTXXqAoxyiPOkFGijbX3jL2XB+7wxXmNUnpdJvoLXnSeo4ppAGpWTwpmGO9RIUupiwENFxaf5BmCNWo56GKBTQtCU9Ek3cUXctkZM9rHDXmKrhFyshTYI3ZYKHv1CuraBDa3fPsXpCUT0WgGoro7CDoJmWTSDE0z5iRcwyy2Ms0U5KsBnTLgpFyQVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMwb9icelO0mXlhaK+AoEqkt9YXe9wmftXBPQU4xRuY=;
 b=Pi8rMLaemQ1nafQfvZbTYsZCIGV+A+RKqf67ZXMm7halB8hUF7v4gtDGPn+k/N4Ka0SNuW6f9Hpr07WHTzf0AFRNziJqs9BNnBxN5jWKYeQCW3zaccqgrzZpInB6oK6OfRg8qjZc6rMrj9P6Y7wk2FxRTGCjhWOaAuEfAF6xcnmOTrdakatFBaIQUpK0T4G53XQcvUMVhphl9UzeMJky7x69WysFqMrh+pUEgBEUj+Gx+R1a1dSjfI5YvtE2mAt4BOk67nGiYdFxKGfqKmINywXjVOt+AY53mf4/U99S5ikqEg6e91ZiTr15k6V7BmMRsHaiE6LYC0HYMKCxBAFlaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMwb9icelO0mXlhaK+AoEqkt9YXe9wmftXBPQU4xRuY=;
 b=hc/WbblZuUkwZBEHWWVEiS8VuMykIfYjnFG+hX14IVwtgFv+mHTFEUQFDb5dMHDMsCszVW2sgOBVyW0eQ0hpeUWCO8tpm2inj+OH6Q4G5MuYLPHtGw81oYQ8jRk+E6x47lWskYjZNpI2YmizW3n82uLsYzrKTW7GA/8uDLIcUp3lfhHld7O8f0k2Rfzc5OkFL7ht7mBrfL0ojFkTqSZp4fHIyo3oMesx19k1sWizrp9gk7LeFxePhq2Sw6w2MbplRkJpy6J3qxlLi4Ty5CxQOAdbn0OzL2kJJCCL8NDK50DB6lV4SJKmoQQ7bWicU+2dnqtYSFHXTQeNWau1lFyZeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1915.namprd12.prod.outlook.com (2603:10b6:3:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sun, 24 Jul
 2022 08:05:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/15] mlxsw: spectrum_ptp: Rename mlxsw_sp1_ptp_phc_adjfreq()
Date:   Sun, 24 Jul 2022 11:03:29 +0300
Message-Id: <20220724080329.2613617-16-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a014d19d-5c7a-46de-edb9-08da6d4b50a8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s9XOTqJI/EvQ1tKM330ps+ZBoJfUhyzJdCbbd/QZ7yFtoVS16uDhFw7qWdmxc3Rk7qlywKw1cv4saWCUkv9LiCsx2JGPlMr+zbsUMgsjLiXtQxWde80nfNB4aYmrsslBPWC7Is1mA/Gizszs1rzUgK9egrAeoFXuFgesIr4Hl6Ho/jLHdu19G5hiIzGGD/LX5bFm1ArcXDoHXVvTy6PaiuZqiG3+sJVyKeSIoeDPlqVG6vBJ6oCvxEVkHCiRcKp/n/grjEU7I8aXd7rx8HnPAO3sxHwhXpiw1nix+QnFvbCDyaTwGuCTp5jchGhVLtLFs0mWcoY8AER8Lt7Pn6QTlofq3nEvMq7oztyaIAsMQFI3nalQGR4BgSVOlFkAbWH63qhAKwRY5AwhA0bHyu5LO8dwCQKrh1/bmKAUkLDPJ9FadfGiKyWNCwPHUmYVVF+lEiM1Oy97gon3Ol8+YgZUTLCiggbprLbpue7I1HZOfEXv9JajCtFdtgR0To9p4HFBQuIWQUgNbBSQ/4MHlbC/E7b19pdfDJrttyGjbasIxdRkG7U2MAJ6N3QszFQbI9xo5c5rogUA/zSOacWRYNTUYEa9V8sYc9t6HyeOXMX+akrSNID4PJ5Da/0wSPKeJHU+UsGXRSQ+2YMW9z8uuaJdBzGkjAuq7+kwmsqfffdeKVzGvDz89/XAFjP5WgoTolLfemIY5KAeprFcTVFf++tQR0qu4jEiTQ+MKbXSLGEORXeAaoXnF5xazv605DG7NLxE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(36756003)(86362001)(478600001)(38100700002)(6486002)(6506007)(6916009)(6666004)(2906002)(83380400001)(6512007)(8676002)(107886003)(186003)(66946007)(66556008)(4326008)(26005)(66476007)(8936002)(5660300002)(1076003)(2616005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UkP04GWJN2TQ8ZyenW01Enyt9RX6HCgYpXTiGETByiNaEaa8VLXEtssruS+W?=
 =?us-ascii?Q?QGl03dmjnkYGu4TGOXvm5sxxTyryLxbocfaZbtRn76BuSoKDFbBcpMdZ6aSo?=
 =?us-ascii?Q?U96lsO6jU0LFxmStz6KXFZ+HtzIdid2m0Ru6aJly5nk/oNRMktiu7CJ7PYS2?=
 =?us-ascii?Q?zRAW4E+kn5EZCmeRIvrg6FEJgH++SrlqVuhjJkOg4MkeG4dtIIO+JLRzG/yR?=
 =?us-ascii?Q?nl/GUdEiy6RaTjMarmenrw7RcYNGMGjJnShkl2JM7AnZFRVYkSBwC9uwGzaw?=
 =?us-ascii?Q?juiqg04RFSwUC4/FQfB82zrFsoyRlDQ0evmXPBg6kocvY2dIItzDH86p4sQc?=
 =?us-ascii?Q?MI6VNNTB/JPvttp2nyRgcvGq5+zk8SAPtpI4HqBJuWHllnRm84YwBgs15rK6?=
 =?us-ascii?Q?S91EjDQDI0i50T6QeRVrhZaVTNLoXl8VGLPn0irrhtVByBtYnd/l3k29nzGh?=
 =?us-ascii?Q?vqyCuNoqA7TNLofhZMBDM/AtCGJr8jFUKNngc0fqJkJLDDC65bLfZ5k8an/l?=
 =?us-ascii?Q?Nu6vjQE9Z3T27CBhwdYtG9cgFgUfjLlGsiSHrJyzIeUhxd/y2Q2m9DE+3ake?=
 =?us-ascii?Q?0Y6lOPCCGLFoYFjC4EpWP/KuhXlMfRrYUBwyRrCnE4oPBV3x4HxJxm3YJLAC?=
 =?us-ascii?Q?DVo001rFuUxNmVxOYhwyNF5VKuuNvIE2/6toD7TllIJ91YnE22TN3MIrzj1G?=
 =?us-ascii?Q?N2qq9fIdaq8gzir7J5utA/fubHUiyJ1iaX1FnnuDTlNisdas9NbkrqsOzePs?=
 =?us-ascii?Q?iH/VHZlurMp3/J/HQXUrVoxIrOjCWQGothcDhOD+tZqWmGMJomqefYFMIIPR?=
 =?us-ascii?Q?1NFfNvo7J3OB5peboCO3kTRxwfST/7gYFDUetKl/PHCXbeP2gJYqiIgyn0pI?=
 =?us-ascii?Q?QVH3VvzbnJ37i9P0/L8gGlYHcvsAOtrLiF50adIxBF4utcvJeyvZcrZjT6Jz?=
 =?us-ascii?Q?TRCq3T2Qkp5pZb/+mNm5gI/JT+tl8OmSZlkGpT9YIH3ZuA6hGskd4yRk3zAK?=
 =?us-ascii?Q?DmaJMQIk7YTyYHkEMJwnA5wNHdOQnCWs8LzNVbnlV8jnC47rHNiX9Y5m+eFB?=
 =?us-ascii?Q?6I7Frg1lA19YqF+d0q3/8BKByNzNxNVhOwqHcZuM4IIN+UU3lLjsGMqkQOu5?=
 =?us-ascii?Q?FY+6LstjFBknonFqmsRAyqBirVr1R2qKvui+oiEkpSpOrNa4X9dV6kexi0Mf?=
 =?us-ascii?Q?pLlUFbs4CXOzMjgvFHQQIw43EyVknvt3G75ZS15u8T8SrfgcC4hTHCKzkpYn?=
 =?us-ascii?Q?hk7FkiWzlQq2dKREBoqGqktACi3hU/AF2N7nVWSVekol+DLdPV+4tR0jOCnA?=
 =?us-ascii?Q?zfHLb6vdNGlDFiIMRL1YZ/FHIb3hiDesrum2RTTV5F3of9+0sqzhUGV3QZqz?=
 =?us-ascii?Q?HlLlzVfc+lJMXPh6xM/+iP/z8DFbiARSef2t5K51niOIzMqbstCxkYWpZNwp?=
 =?us-ascii?Q?smgyaSfd+3p+qWBEwVV78QOS3K/ysepIUc+ywtN1wQH/ve3XKqJOfwAgieDB?=
 =?us-ascii?Q?l/Usauo2UOXr4dV4yclLCMBH7eYi0ASmPIdOlupZJKseIidf3cIBB3JrfAl2?=
 =?us-ascii?Q?2vPbrI8eUpHa7XTGuLfXtY0RIjaKQI6mBsEUs0Aq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a014d19d-5c7a-46de-edb9-08da6d4b50a8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:47.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLiQ8AcBdExDNRrXxiBQjPCzTxPYNe5zA3XBbNwJfyThoCXfIiOIasU1Y6NwvSGwIPaTwLEQnziDo68Die10wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1915
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

The function mlxsw_sp_ptp_phc_adjfreq() configures MTUTC register to adjust
hardware frequency by a given value.

This configuration will be same for Spectrum-2. In preparation for
Spectrum-2 PTP support, rename the function to not be Spectrum-1 specific.
Later, it will be used for Spectrum-2 also.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 4df97ddbf5b9..5116d7ebe258 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -122,7 +122,7 @@ static u64 mlxsw_sp1_ptp_read_frc(const struct cyclecounter *cc)
 }
 
 static int
-mlxsw_sp1_ptp_phc_adjfreq(struct mlxsw_sp_ptp_clock *clock, int freq_adj)
+mlxsw_sp_ptp_phc_adjfreq(struct mlxsw_sp_ptp_clock *clock, int freq_adj)
 {
 	struct mlxsw_core *mlxsw_core = clock->core;
 	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
@@ -194,7 +194,7 @@ static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 				       clock->nominal_c_mult + diff;
 	spin_unlock_bh(&clock->lock);
 
-	return mlxsw_sp1_ptp_phc_adjfreq(&clock->common, neg_adj ? -ppb : ppb);
+	return mlxsw_sp_ptp_phc_adjfreq(&clock->common, neg_adj ? -ppb : ppb);
 }
 
 static int mlxsw_sp1_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
-- 
2.36.1

