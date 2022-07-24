Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7EA57F3E9
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbiGXIFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiGXIFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23384E019
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNH/VMLHLWRR+TEXt7XdkLuHbeWZ+BqCcSmHjgtzIePCiSlOB3I0LBBLBJ/v7vSX/XTWxKp8awWkOG3irUIgC3z9i7QhZsRFulI4QE9CFccij4CWbgtxHN2CIPijIPXawhgdk2fr5TElQLjwjSwNSR7XkEnRxBZ6BapSH76V0bxqdU/PrzQmh5PSsslhk8AOTZPg2zV4oP85x+SQBmkgDRcRbz5T2yEz/EH47sRI46LXyFfoGKH1Ugu1QBI3LuJCG7qEVAHXgKQuzoOllX9FIO+iOzgWCF4Xwvlpi5M2LYP2SeEcnrsRVXAyVRIQxic8i1qQpdyXRGgQBqmMV2b5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQYtjYi0Ag8ksZvZGcMum5T5FVObyy8WajAowceKP50=;
 b=TSEUm/+bsCxjKu00LF514yPEJ/g6a+AmoSSw/BfAYwk+nfv5pBRwUhFSHNMN4do8IZq/cxQmlqLwDIUeXd0821gRrqN6w4NG0VCmYa4MrHG2QuUSwrlB/X4w++6TyBw7tm/Wosl++2YHMNXosZB8Rujyu5rYFOA2icYbsWmZCpB+TZOn+ur7ABzkwPk2Jb5sXnMAlnkXp7uSNd7JHUtCjFSHizFjFR0Uid9JrzNH3ay1TgDT1i+wrGYsB/0NCiH1QuqKwuFM+8rfnDmF6Ei8wVr0mjDdnyVWAr2wHrptd/j/T5zko6TDsDwlfvlDeqqFRQ6uCKKfyDe1oEx/IXimfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQYtjYi0Ag8ksZvZGcMum5T5FVObyy8WajAowceKP50=;
 b=Jt6I+ABoPAaHOPnoQkXVUUyDSOXcPoMbsZbPk4oJbzJYdbLzmyLk3sehRUdWjZDXjhSzfxs6ETb8Yk9RamgsoJ1qY/5Ci5seXpavlthDkkGtN+KIzd4ZyHtwjfnfDftTGRaCt3LJRLGa3VlJyp0onswzGuQQ9KJhE35i9BWeG+websmprpVCwj3cLVL58ht1RMJONqZt7Cfs4bClFo/NMe1mRK0z3OuhbmbwfXaGv6jUScehv1g9emTE4FBV8KcNa/rB9jbsyG0GFLoKq7C29RExZDWGPh9fnnvnmFGG1m7H1tXU1ZhDyrIX2EybkSo5T/DTy23t2DAtKhQufCMM0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1915.namprd12.prod.outlook.com (2603:10b6:3:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sun, 24 Jul
 2022 08:05:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/15] mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_clock' per ASIC
Date:   Sun, 24 Jul 2022 11:03:27 +0300
Message-Id: <20220724080329.2613617-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0465.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfcd002b-0661-4c44-5aa9-08da6d4b4903
X-MS-TrafficTypeDiagnostic: DM5PR12MB1915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0/o+uJrCSLw+E6gzjqMHMBc1bmNZdXIPqX6azBYHW8l4wMUoDWyXw9KjKVPgf5anHRPsSS3Z0r7Mvotr7g7lmGOT5ZGyKS/K6jR2cwHItufF3PBubb/ufJj1YBF9EV2jippJtNiadNj2f+mSh5kN0a4errdXI8/su6OowzkY/eGAj1YWXKDnbU2UC4VbybYEUaLeCU3MY8ktuNyxo7SkvsueVrFiO+ILM3/n4S6e35rQjG4LlehF85baWaFAK6FazebSOeiOrhKcKMVaSwRLqhSN39ryDaQrHeh1ZVtq6PDOD8VM9I2ya3PvoYtk+SiCOj4sXnh0HBDqrjObhdrNhLV1EuhODE8ma+HXlkXWccFHT6pyIGn/cDoB/QErw3WoF5omC97WkIa9a/3GHcfnUMY6iyhZxIVQ5ntbfVCZ3PhxXgcVGZ9A656ur5MiAb/Y5BgurCCKWYWtHcq1wdZ/85nrSMV9jDhcCFZIi7qCiKlT1/ePiwT2P+1W1XVNTwu9R8qu/TmD6m+7Isuubj8nC42vET+1byM3P9JWbCb0MLnrylu48ud2vLtMeJfeKNqf9jN63WO1JC+F6uuJ/p51bjWZA2flcRSXVvqxI27bsUavOwp0XKoG05DGtDwwy8tpqcjuJVrOZCu+xEXyNEy8lIV8K8Lo+WuHI8t0MrFSmMetKWGNyAuzyLz41d7uhb5+qri++MOpV9zKV/6maya29UZ2GCkjca5t/TElQHP+YnFnOxd6g35lX5glSZoeoKH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(36756003)(86362001)(478600001)(38100700002)(6486002)(6506007)(6916009)(6666004)(2906002)(83380400001)(6512007)(8676002)(107886003)(186003)(66946007)(66556008)(4326008)(26005)(66476007)(8936002)(5660300002)(1076003)(2616005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v5WGvtfF4MuRsT9GnfX0Py21OS/Sx2rA7B4ILOkd6tlvlAZXLvFoWWLk4PxI?=
 =?us-ascii?Q?KBz42FQmZiexzwZ2rUSbGkKiDgrgyhq1v2gwOI4xMG9AI8x8gB/Rn/L6lidL?=
 =?us-ascii?Q?JlUlSPxRK0HfeA8gHk+jHzWAzKY0u8I4zL80jq7NHhyfRnzB0MC/Sv4bYgv1?=
 =?us-ascii?Q?UDZQzqBgpt7dAGWgOxLzBgURkzomaxOzKI814ACUpvJYS8ej1uy2ZvI3lM/+?=
 =?us-ascii?Q?vezBTAN+KT/HAlXkZwqujNKgba7FaT7pqcVdQP6klkVUylHscGvZz1y56AUN?=
 =?us-ascii?Q?3VBfKL+ViYxU2Ddx3VMnW+f/H972yzFyj8USa6yvoo2fmcWvp63b5/YKMnL2?=
 =?us-ascii?Q?69fcZmUI4/XftY/uDzEb5KLGuF1/U69UpSGcxiKkBL3OEkjz1Etni6IP38xR?=
 =?us-ascii?Q?//a6s/cEM17dM5ngq+mk7UBj2ltoeWpKQbNzu+iDyEpwu4J8/oJPGeGSxoDz?=
 =?us-ascii?Q?EXCVi/5i7SVp/0EBM3D9nhYkJqU6Ab2qCTDAMQL6kzYZe7UhBESaBXVZ1VSk?=
 =?us-ascii?Q?8ZfdRdIbX/EsRC/OiXS0geCub5951+Mv7UQYPH0OKywrYVNZtniH1MriNZgy?=
 =?us-ascii?Q?x0IYJoiKr6zIDyCLrih0m7dTrzI8ea3LjqJBjcvkd7N3p4Y6oXhtWZlLyMsD?=
 =?us-ascii?Q?5uplp53PG3r8ajYSDE+Qn0KIlqwUuZyVvhk+5x/1pXIdrLHB4mwOq0KjkbTu?=
 =?us-ascii?Q?bg9ko6Fz0zx3/Cfh4RsFsboiOAo4Kc1DMxVK+xKkLkKmH002pf1DFfdl/uHO?=
 =?us-ascii?Q?2UKGTGt6ogO/AHkBI8QkdcQBFgZiwX02d77a6zRKKnCO6OnbbDb5Lk8B8Ekm?=
 =?us-ascii?Q?F/ZVBjzBt4cinxncNnOOAVBP14joM/xjpsqzcR9Dk5CVaJgJw7h4oebiQIth?=
 =?us-ascii?Q?DzbPOVUTNvUvCwqxEq/RBHaNGHIDyk6ln0lI6R5PWY2cFweVNhC3sZdZjcSS?=
 =?us-ascii?Q?JQwcPSOqgWMeVGMBdgUvNNaU54JL5G/CbgpyuNyUsom3cOTDNQalSBllzT7F?=
 =?us-ascii?Q?yXXYtdmuVSYownLGrkfYRmJ5/W2ujwyniM3sl+U5RWQyCbRhVIAtYPKO0jtt?=
 =?us-ascii?Q?5DnwGbwP0RX1P8xn/YT9aTV4CcObfBqxCTmutY0cd4Uuc5t7zYIIBdxM5Cvn?=
 =?us-ascii?Q?dVafTtrYlATxG9Mim44Py7/q99z7D2oHDg3Pr9YRNiwn7TyDfblGeQP20F0K?=
 =?us-ascii?Q?7AOaqvOuZO0AWTsnz/vA75vG6BhGIrp0MmoZAEOJYaQipblUcav5K/nWjPx7?=
 =?us-ascii?Q?c/uJFRsr6aoKnAXG8iwrARcFW2c6cFm0EQidtfc04IVG66IBcPJLHMk9vrjj?=
 =?us-ascii?Q?q6RooyQMvQfzeWVt7EUzd2YjPcvwQpW/vabtBAsh1dSMmHatsjawlJFLCGjf?=
 =?us-ascii?Q?PJGu3YdyxPSar7TBK+fWrQ0vylm5A6tZNhnix9/0JnAkao3jauN47gofx/x2?=
 =?us-ascii?Q?u46Bl8vmlo0+/zLkG8hZZVp7qI5iavw5OlDwSwz/LK2LzPeSXA6qQoQHYAMI?=
 =?us-ascii?Q?7jA7GHpEObKhuRmwF90dnxyMzfMuMXHKMU9JjnnXJ+u9mA6N9TgA0Xh9i2ad?=
 =?us-ascii?Q?xQZU17cz4mFNPo1q6TREz+iADsb+TdiEkeGxMmAA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfcd002b-0661-4c44-5aa9-08da6d4b4903
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:34.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4OE5z0zpQKDjOcSVvNKXtF227ZVhu2nPnI9fn4jQ/z5WnGnBfJgvi4R1p8tn+J1ZFrlqPtdhqFnaNnP9vWtVA==
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

Currently, there is one shared structure that holds the required
structures for PTP clock. Most of the existing fields are relevant only
for Spectrum-1 (cycles, timecounter, and more). Rename the structure to
be specific for Spectrum-1 and align the existing code. Add a common
structure which includes the structures which will be used also for
Spectrum-2. This structure will be returned from clock_init() operation,
as the definition is shared between all ASICs' operations.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 75 +++++++++++--------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index c5ceb4326074..99611dcc5474 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -64,12 +64,16 @@ static const struct rhashtable_params mlxsw_sp1_ptp_unmatched_ht_params = {
 
 struct mlxsw_sp_ptp_clock {
 	struct mlxsw_core *core;
+	struct ptp_clock *ptp;
+	struct ptp_clock_info ptp_info;
+};
+
+struct mlxsw_sp1_ptp_clock {
+	struct mlxsw_sp_ptp_clock common;
 	spinlock_t lock; /* protect this structure */
 	struct cyclecounter cycles;
 	struct timecounter tc;
 	u32 nominal_c_mult;
-	struct ptp_clock *ptp;
-	struct ptp_clock_info ptp_info;
 	unsigned long overflow_period;
 	struct delayed_work overflow_work;
 };
@@ -81,10 +85,16 @@ mlxsw_sp1_ptp_state(struct mlxsw_sp *mlxsw_sp)
 			    common);
 }
 
-static u64 __mlxsw_sp1_ptp_read_frc(struct mlxsw_sp_ptp_clock *clock,
+static struct mlxsw_sp1_ptp_clock *
+mlxsw_sp1_ptp_clock(struct ptp_clock_info *ptp)
+{
+	return container_of(ptp, struct mlxsw_sp1_ptp_clock, common.ptp_info);
+}
+
+static u64 __mlxsw_sp1_ptp_read_frc(struct mlxsw_sp1_ptp_clock *clock,
 				    struct ptp_system_timestamp *sts)
 {
-	struct mlxsw_core *mlxsw_core = clock->core;
+	struct mlxsw_core *mlxsw_core = clock->common.core;
 	u32 frc_h1, frc_h2, frc_l;
 
 	frc_h1 = mlxsw_core_read_frc_h(mlxsw_core);
@@ -105,8 +115,8 @@ static u64 __mlxsw_sp1_ptp_read_frc(struct mlxsw_sp_ptp_clock *clock,
 
 static u64 mlxsw_sp1_ptp_read_frc(const struct cyclecounter *cc)
 {
-	struct mlxsw_sp_ptp_clock *clock =
-		container_of(cc, struct mlxsw_sp_ptp_clock, cycles);
+	struct mlxsw_sp1_ptp_clock *clock =
+		container_of(cc, struct mlxsw_sp1_ptp_clock, cycles);
 
 	return __mlxsw_sp1_ptp_read_frc(clock, NULL) & cc->mask;
 }
@@ -133,9 +143,9 @@ static u64 mlxsw_sp1_ptp_ns2cycles(const struct timecounter *tc, u64 nsec)
 }
 
 static int
-mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
+mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp1_ptp_clock *clock, u64 nsec)
 {
-	struct mlxsw_core *mlxsw_core = clock->core;
+	struct mlxsw_core *mlxsw_core = clock->common.core;
 	u64 next_sec, next_sec_in_nsec, cycles;
 	char mtutc_pl[MLXSW_REG_MTUTC_LEN];
 	char mtpps_pl[MLXSW_REG_MTPPS_LEN];
@@ -161,8 +171,7 @@ mlxsw_sp1_ptp_phc_settime(struct mlxsw_sp_ptp_clock *clock, u64 nsec)
 
 static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
-	struct mlxsw_sp_ptp_clock *clock =
-		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	struct mlxsw_sp1_ptp_clock *clock = mlxsw_sp1_ptp_clock(ptp);
 	int neg_adj = 0;
 	u32 diff;
 	u64 adj;
@@ -185,13 +194,12 @@ static int mlxsw_sp1_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 				       clock->nominal_c_mult + diff;
 	spin_unlock_bh(&clock->lock);
 
-	return mlxsw_sp1_ptp_phc_adjfreq(clock, neg_adj ? -ppb : ppb);
+	return mlxsw_sp1_ptp_phc_adjfreq(&clock->common, neg_adj ? -ppb : ppb);
 }
 
 static int mlxsw_sp1_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
-	struct mlxsw_sp_ptp_clock *clock =
-		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	struct mlxsw_sp1_ptp_clock *clock = mlxsw_sp1_ptp_clock(ptp);
 	u64 nsec;
 
 	spin_lock_bh(&clock->lock);
@@ -206,8 +214,7 @@ static int mlxsw_sp1_ptp_gettimex(struct ptp_clock_info *ptp,
 				  struct timespec64 *ts,
 				  struct ptp_system_timestamp *sts)
 {
-	struct mlxsw_sp_ptp_clock *clock =
-		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	struct mlxsw_sp1_ptp_clock *clock = mlxsw_sp1_ptp_clock(ptp);
 	u64 cycles, nsec;
 
 	spin_lock_bh(&clock->lock);
@@ -223,8 +230,7 @@ static int mlxsw_sp1_ptp_gettimex(struct ptp_clock_info *ptp,
 static int mlxsw_sp1_ptp_settime(struct ptp_clock_info *ptp,
 				 const struct timespec64 *ts)
 {
-	struct mlxsw_sp_ptp_clock *clock =
-		container_of(ptp, struct mlxsw_sp_ptp_clock, ptp_info);
+	struct mlxsw_sp1_ptp_clock *clock = mlxsw_sp1_ptp_clock(ptp);
 	u64 nsec = timespec64_to_ns(ts);
 
 	spin_lock_bh(&clock->lock);
@@ -248,9 +254,9 @@ static const struct ptp_clock_info mlxsw_sp1_ptp_clock_info = {
 static void mlxsw_sp1_ptp_clock_overflow(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
-	struct mlxsw_sp_ptp_clock *clock;
+	struct mlxsw_sp1_ptp_clock *clock;
 
-	clock = container_of(dwork, struct mlxsw_sp_ptp_clock, overflow_work);
+	clock = container_of(dwork, struct mlxsw_sp1_ptp_clock, overflow_work);
 
 	spin_lock_bh(&clock->lock);
 	timecounter_read(&clock->tc);
@@ -262,7 +268,7 @@ struct mlxsw_sp_ptp_clock *
 mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 {
 	u64 overflow_cycles, nsec, frac = 0;
-	struct mlxsw_sp_ptp_clock *clock;
+	struct mlxsw_sp1_ptp_clock *clock;
 	int err;
 
 	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
@@ -276,7 +282,7 @@ mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 						  clock->cycles.shift);
 	clock->nominal_c_mult = clock->cycles.mult;
 	clock->cycles.mask = CLOCKSOURCE_MASK(MLXSW_SP1_PTP_CLOCK_MASK);
-	clock->core = mlxsw_sp->core;
+	clock->common.core = mlxsw_sp->core;
 
 	timecounter_init(&clock->tc, &clock->cycles, 0);
 
@@ -296,15 +302,15 @@ mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 	INIT_DELAYED_WORK(&clock->overflow_work, mlxsw_sp1_ptp_clock_overflow);
 	mlxsw_core_schedule_dw(&clock->overflow_work, 0);
 
-	clock->ptp_info = mlxsw_sp1_ptp_clock_info;
-	clock->ptp = ptp_clock_register(&clock->ptp_info, dev);
-	if (IS_ERR(clock->ptp)) {
-		err = PTR_ERR(clock->ptp);
+	clock->common.ptp_info = mlxsw_sp1_ptp_clock_info;
+	clock->common.ptp = ptp_clock_register(&clock->common.ptp_info, dev);
+	if (IS_ERR(clock->common.ptp)) {
+		err = PTR_ERR(clock->common.ptp);
 		dev_err(dev, "ptp_clock_register failed %d\n", err);
 		goto err_ptp_clock_register;
 	}
 
-	return clock;
+	return &clock->common;
 
 err_ptp_clock_register:
 	cancel_delayed_work_sync(&clock->overflow_work);
@@ -312,9 +318,12 @@ mlxsw_sp1_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 	return ERR_PTR(err);
 }
 
-void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock)
+void mlxsw_sp1_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock_common)
 {
-	ptp_clock_unregister(clock->ptp);
+	struct mlxsw_sp1_ptp_clock *clock =
+		container_of(clock_common, struct mlxsw_sp1_ptp_clock, common);
+
+	ptp_clock_unregister(clock_common->ptp);
 	cancel_delayed_work_sync(&clock->overflow_work);
 	kfree(clock);
 }
@@ -451,12 +460,16 @@ static void mlxsw_sp1_packet_timestamp(struct mlxsw_sp *mlxsw_sp,
 				       struct sk_buff *skb,
 				       u64 timestamp)
 {
+	struct mlxsw_sp_ptp_clock *clock_common = mlxsw_sp->clock;
+	struct mlxsw_sp1_ptp_clock *clock =
+		container_of(clock_common, struct mlxsw_sp1_ptp_clock, common);
+
 	struct skb_shared_hwtstamps hwtstamps;
 	u64 nsec;
 
-	spin_lock_bh(&mlxsw_sp->clock->lock);
-	nsec = timecounter_cyc2time(&mlxsw_sp->clock->tc, timestamp);
-	spin_unlock_bh(&mlxsw_sp->clock->lock);
+	spin_lock_bh(&clock->lock);
+	nsec = timecounter_cyc2time(&clock->tc, timestamp);
+	spin_unlock_bh(&clock->lock);
 
 	hwtstamps.hwtstamp = ns_to_ktime(nsec);
 	mlxsw_sp1_ptp_packet_finish(mlxsw_sp, skb,
-- 
2.36.1

