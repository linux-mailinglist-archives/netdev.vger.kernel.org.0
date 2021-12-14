Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A1547405C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhLNKWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:22:23 -0500
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:26272
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231277AbhLNKWU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 05:22:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMgOV6vbEsuZe5uYf7siUJ5Ye5AJ0/2MIop3R5FKgHHkAip9BAhUdS1rUr71ufw5iJFXaRVdGVpdMGHN2yYADGW2ftfbP9lv5W5cMitUFRo00ZEMauKeHners6Uh9zTloYkXouqR0o4+FO5pHGlOMku2B8OVvq/5afEFVoLYEBZRZbAJZJRxOOZms8DBftNnVqvOkUb7rm2VnG0Icpi/zX+4GamrNw08tiuEy5WifVgymFv11j6/GaqzRDSqmHeeh2xXQRwq+LwBfubsV2Wn1tvdXi9jzkSuuLhrF/M014v3zDHJMPSjbw7eriDBZpSaI1zOa/EbawXL+G6qkCbvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ulMIiQ+zknwvUtUgN7zXsgQyTg04J+yB8vI6HBrx4c=;
 b=Vinj/Q0bpl/LZGfJET7tPKqmDerpGQfjNaKpWPoNmaTc2DffEAqYlhNGtRet1cYszw2IRbpBkF/1yj2BAzrR7y2C5ZpKhtUFH1Suxg0+zprKhaZHV43FsX98S8rT54OayRgoSk+Cs4mzDbv/cWJXgF8SjT37nwK96LzOhzuH8FZLhWP977u2OuA/gVmKZn6B8pU+QdLYAvXoCIAMjhodvsptTCfij18dmS5NqnKjoT2SytQio8N4BBlSH8wjQBv78+awCIdIdkO8esHGtdjLgzi3Rfil3by+zRDAOGRQKvr6oP+nVsnsKZTeqLVw5QW/UaSs5y4Ahe1CqxmakvOaFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ulMIiQ+zknwvUtUgN7zXsgQyTg04J+yB8vI6HBrx4c=;
 b=ClMCDuhwgODEH1D5VLWvpNQBhtfRlmldS56uH7P+yVIkfPuq8UjPVoP7Pu1SoN+a0jLEo1XFSQroRNHjNqKwy6Cmmi4rpsFjIt0jlld5U0Kab1Q6MhdYqLfUuzY/CWZSU5YSorxtQxUKCgeScN/PzDiYPx2zeuEKk0QKmrnLaeqRomZE3Piz6LB/AN1yIE0fYegZIvxlasHu3DAM7w5uDdgYL1VkwNqA1R2xNpyGnZ0QRfmn9tU77U8H74HXybjsT3l4Wn5h9jZ/eW8NoOi4NwCqeJD/Q7MbqcZLGhFAqO1KY9sM76PjULzm8zuwWec4v+cnpoLk3S5SPG1GNy7U3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3079.namprd12.prod.outlook.com (2603:10b6:a03:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 10:22:18 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 10:22:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: mlxsw: Add a test case for MAC profiles consolidation
Date:   Tue, 14 Dec 2021 12:21:37 +0200
Message-Id: <20211214102137.580179-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214102137.580179-1-idosch@nvidia.com>
References: <20211214102137.580179-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0131.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::23) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0131.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:30::23) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 10:22:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 730aa42b-832f-4b3f-7949-08d9beeb9af4
X-MS-TrafficTypeDiagnostic: BYAPR12MB3079:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3079D711685CEAB3A714142CB2759@BYAPR12MB3079.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3o7IJiCgb2m3egEQFQLbdPGYmobAzpWCSelS5XAoowyepasIvNdHf5JJYdmW6LpwU27jzsHhyT3E5BJ90dAZmJ/8mApKcJdkFSvbcNouOuftDwV4bqWXj2/eeMeaYw26j1Vci+u0QY+pkVh4dHMdA7Z9re/iddIHM1VN7T3AfLtbrFOPXT9/Wgz34TU360X0DrWLHjSUYBrN+D5vIGAJycv/M1ZwKgJWel6lM5N6RjR2LoYqCvGK00wwJgZ/x6iqx54xIGJRAhj5b7H52rI+TciGXKfuFKfbB/WFvwlqKOy1S9EC6WQYkmT9ycjaZ4Pl6wIVdooGRFj/m7U5uJJe83tF55qTq+Zp4145o2Fl8D2fb79wjjPQo+8HHv+v0W6QMtdCqcqNYLcxPJIQFjnAUnefDQSkdec/dFHdN7JEgvPAr9GwN/6jweNuhyV2nD+q4i3P8wNY+vOh0NxVd4/UQ6PKJ5NqlHmHmLeCqqc6TlcK6bXWTs30yQ8VdVdBbP/x8ewfTtd7CamEWHeoroTz1PZkGo1npw51f/LWCtEoF4i4jcMZADQzd0YnoJ1AeF47EDsA3UdgQtQJ+gmcV7JRcyN1QfalXHNdL6HNromhYS6OSO+3EKjXivNr8shrrWpsTRx0f3j7JmkePSX5voR1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(508600001)(5660300002)(1076003)(107886003)(316002)(8936002)(8676002)(86362001)(83380400001)(2906002)(36756003)(6666004)(4326008)(6486002)(38100700002)(6496006)(2616005)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XaHk+NyyS6ToPR+LQv/z7qSrzJMWFegDYRqr5yONeGel1FY2SaCqJvwySLgS?=
 =?us-ascii?Q?nsYFNr4gDLSE7NUdLHVKPGwfoUWF2P1rWkXLAQlnZoLmv4doaG0zc5kCI9s5?=
 =?us-ascii?Q?dak2DOweNaJVSxUy6leYZebSUc6Ziyoy7JR0MwDO4S9/qLDXwzeYiUjNxaQA?=
 =?us-ascii?Q?564PZvDwBB9FyDhnVggkvl3piLj1bqq/CrPyzZtunAxU2EVRmTiMyVwg0Hls?=
 =?us-ascii?Q?PBktWWaGyAz0/mRlOloCtKmUoE+YPZhl1IDn3h8kemEJWOBD2gey0782iQVS?=
 =?us-ascii?Q?E1QbzdU83fcZv7zup6l/9m6CJ8F1LqjLFfHiQ23o6l7e7IWDMAesqq3drBL6?=
 =?us-ascii?Q?OTM6QAMPs43TgMoOsfCBQEmxzA7eGN0hwz2OdOMl+CkJHfF0fBZbziaa7pF9?=
 =?us-ascii?Q?ae01Z8RWM+CVQaUphM4VgN6V8dWaTTPdpg2jAisD4zgyNQ5KqcXOYM7CsNBa?=
 =?us-ascii?Q?+hLwfNzONKFqdJhbzE426e//esaYOB4sar3Guue8+GxK3e0ImHgNCUHdo97D?=
 =?us-ascii?Q?ZZY4VBDRbzI4WBcSn/8yTBYNYdwsnPYnM48zbZtZSsw1jU6Z0Dczhb4m4/Lj?=
 =?us-ascii?Q?ZFKLwsuxSlQgNfSzeNm73lk+Jr6J9YuFOPs5V19l/7d4cKA5gTFphan1VvyO?=
 =?us-ascii?Q?e8RmtY540ruiCUEO4mF4kl/oO5jlbcXHjBdv5DqhDOHdGHTaFQaOfi/a2z+8?=
 =?us-ascii?Q?GPcBGrtjuLoGrH5sMk9FFg817twX2eA1oAMS+HnHeyDUJYEsLsIUbSNQQ4F8?=
 =?us-ascii?Q?BRkMu5AfrajWh53HqQ3+lEVcCS2bn5NeiFRsSF3I/3VTtoYYOiS1tOR9RlDj?=
 =?us-ascii?Q?fYvcUiepbDdvuHrs5FE4xY1MiIsoRiOjKRiTe6uFg/DqIIfUtK7zdQ6q1nMP?=
 =?us-ascii?Q?iggyVKDGGz6FWyYUtW1m4UAPPUfq49zGxC3XJcUE6BD75gjZD6drRkty6GE3?=
 =?us-ascii?Q?u8Njxk1Cw2w2HxUwX2p0E0aEzO6XCukfJdK8vsZqboyg77Jbd89nfvmKIGQX?=
 =?us-ascii?Q?ru1UJ07yPWAZWSt2ahV6B/gCfbp6JXY5mTX0iBIZ9ntMF9mqAQrxLx/sLsuc?=
 =?us-ascii?Q?Q7TpcPvWA08/k0WtWY3zhSLY1RYgA7xOHch0ObWCbWZozI4etWlsoH2DL4nm?=
 =?us-ascii?Q?EUtJ2QFLH6hF/QuN7qQugbWAulaNBwQeE03AAC7qwzmwD6kO+D4bLCfEccjD?=
 =?us-ascii?Q?YqhYXyZ09kEpktDuVJohQNch/9R6xAC34Lg1FTtiCktEbyHfLvqL+vLstYz9?=
 =?us-ascii?Q?b50uLIIyLxlfSmfp5dPnckk10jCZH0pabZTRCSe0qw00KiO1KZhRxzQH8kCY?=
 =?us-ascii?Q?YoT86NfGmgGWjU8SYJkOrn5pHlZcQlwVDuGOZeEkonsy9AXS6kEBnx2N/0O1?=
 =?us-ascii?Q?hWJuvz3kcuuRZ6/jkh6NV0qtzJ+3kD3w6ey/21S+Kn+3w369bdkeINioB1oC?=
 =?us-ascii?Q?YJKnc0LjU6K0LFcZUXzYEL204fIPEkh0rYlB/p6vQctHotBiISLGbD4es/xB?=
 =?us-ascii?Q?AJlnQY4qCp+jnI/EM+86xZjSGifHr66H+ekgKDrhi2Rm/e45z3dq8DKIfiDA?=
 =?us-ascii?Q?io7eO6GIbGjnKqcJbl6U4o0pqh5FasM8BFivCTevuOG6hlGwp1Y+Ackt278k?=
 =?us-ascii?Q?6rOmfeRFRSjoMy4Xs85jkaLZ5kh8YzXYpx6zm8eaCpjRYZtW5FbfAW8Oio/g?=
 =?us-ascii?Q?bFQz5wJzPAvrQVA0ptKw4O5QY5o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 730aa42b-832f-4b3f-7949-08d9beeb9af4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 10:22:18.0159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA+oKzHuZJfzYtoXp5r5rygEoVbD0afHPG7zJquDeuHlDaDrVcFvLFS0kvhds4/dBoSednV5+1c380WjrcmxPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add a test case to cover the bug fixed by the previous patch.

Edit the MAC address of one netdev so that it matches the MAC address of
the second netdev. Verify that the two MAC profiles were consolidated by
testing that the MAC profiles occupancy decreased by one.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh b/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
index b513f64d9092..026a126f584d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
@@ -72,6 +72,35 @@ rif_mac_profile_replacement_test()
 	ip link set $h1.10 address $h1_10_mac
 }
 
+rif_mac_profile_consolidation_test()
+{
+	local count=$1; shift
+	local h1_20_mac
+
+	RET=0
+
+	if [[ $count -eq 1 ]]; then
+		return
+	fi
+
+	h1_20_mac=$(mac_get $h1.20)
+
+	# Set the MAC of $h1.20 to that of $h1.10 and confirm that they are
+	# using the same MAC profile.
+	ip link set $h1.20 address 00:11:11:11:11:11
+	check_err $?
+
+	occ=$(devlink -j resource show $DEVLINK_DEV \
+	      | jq '.[][][] | select(.name=="rif_mac_profiles") |.["occ"]')
+
+	[[ $occ -eq $((count - 1)) ]]
+	check_err $? "MAC profile occupancy did not decrease"
+
+	log_test "RIF MAC profile consolidation"
+
+	ip link set $h1.20 address $h1_20_mac
+}
+
 rif_mac_profile_shared_replacement_test()
 {
 	local count=$1; shift
@@ -104,6 +133,7 @@ rif_mac_profile_edit_test()
 	create_max_rif_mac_profiles $count
 
 	rif_mac_profile_replacement_test
+	rif_mac_profile_consolidation_test $count
 	rif_mac_profile_shared_replacement_test $count
 }
 
-- 
2.31.1

