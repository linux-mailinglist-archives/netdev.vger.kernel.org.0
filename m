Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED84744E4
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhLNO1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:27:12 -0500
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:38689
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232459AbhLNO1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:27:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cA9b51CP89A3rfOMeG5Z/dhPii5a3/Uvj9YXYpz+DvOQYLrOyKv12b8GP9QbYz2yi3W5mg+r6SiZRWEEM0wVlsI+9k9F0zHNBypuv/mggTBvHzJvni6oEW93a6sHaG/MNhBxE2LIIJqExJCBBxw2Th5Ts7lcHcxRbE4mpPDr9f6/OEZxJfvyVCJS1EeOXVcsYM43JXITkoX/EPTaXMh7wJPUUGrMTw4AWc1EtRINISy9qwpvTHXVzmXuWIcBr/EMe5F8Aging1Vy/NyM/x9IfaRE8UO88CrHKejp9/B/5xG0gJ5nf5kLLTJuxKVPtEv2dJ3Ff9eQ2QaDu7ceRTW5cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EynPtvCfFy6hU3turNJYELvASNWH3FYOeKA/cCRasQ=;
 b=B9HP9XORI9K3kO/GbpG4/NRGSiGkM6Ebw5qT0zvgt3lqeKql/JMCSMi0mlErCB+hNfzqf5DRJXjtfalila+ZGcyBNpui6czHafSXlZujKRNaObY9Vpp7C3wrrK/oVMQG15I3+cBlkCCupJXXaPITNaId7nBs6eyVsszDAVha99yza45fx5cKPuZPEXNRmugcnEKlc/lh8SklC4FAYMAc5lx1EHnAD9FNhaY/bFDsPiOvpuQGVBIkazyA9ukMymt6DO2IGHtJiypTxbHPrTVMRjo86xrR6QmoG5K4C9jpBtriQdW/62umvWOJJ4pptkquke0NGHpowcE0ARePfXHMbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EynPtvCfFy6hU3turNJYELvASNWH3FYOeKA/cCRasQ=;
 b=HCBjhADdHRVm9I1dMASLW7L7hk9hBCinZSv9hIB3E958JFforoSQlTJcJyO1HjRkYXaLOLD4nGfuNaNiWHSaxQ0NBXoyOBCcUfdVZx5hj9IwH3GyktFUE7b5/g7TMXIiltnY3AzUHCHK4VFXshB4OKM0syu1e3ZvXZVvtPFiAwXUdLsDV4CAYAzzI/E3OtOveK51tISw8MGCkoBGZrKwRIKpK0g7uSe973Sukw4vWxOcKrt0W7o9SrSX0SJR4/TKHhtc+TrQmMkllSZ6nJRqHp8n96fLRSUnGrqs2GetouikPPwXm6VJV06v2goWII2PLLP8fdJk0cw5EOTYf3O8vQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 14:27:03 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:27:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] selftests: mlxsw: vxlan: Remove IPv6 test case
Date:   Tue, 14 Dec 2021 16:25:51 +0200
Message-Id: <20211214142551.606542-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0179.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::18)
 To BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0179.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::18) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:27:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4456ad37-0f0d-440f-3db0-08d9bf0dcc41
X-MS-TrafficTypeDiagnostic: BYAPR12MB3031:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3031F82201A54F421926B035B2759@BYAPR12MB3031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSV7RoZqIL4Pweoc7Y6LsqsI4tKpu2kdIayufXw/7CyiQujC2aobpcxgmI0VGZ7aNu69wAvPkkwlAlxtVxxqMSdQUUQKRkTKvcfaocB1GUHgx1KIe7mSCD6zQ9vCquMCF8ksBHT7Rw1/dPGGBXINuvGNHWuktuZr1e71f+2US48DtFlHKt+dJphQEalhXxGH3TOKUfcHhtEZN/CMvu+16iiBbYJLlUUWulvlyTtESjZiTQyPt05jKYztuJpOGapK2jmqB8YGrhvtRax3vm9cHGbKA/Uw2nYBHPh1q/TTYg2L23eADaC7r7c+HmqRdwK3cY4zzlQ9P7GugJoZkKBhnLmpLxhK8Mn9mXiC8zfJ3ACPxbujSih2nGZ/8nqMzc6obAFZG78/ay2jVYvVuErJjBAVadD0dJUyfMPw3cZxNwsNzExEfFb0RgtkMdqEKyzJQLasxFb922Qc910CmQF1gPVlGxSYeYHEwlRM1mLkdPoGnbrvdsw/aNTQ/hVQeSbeijyk+14VhCS8GeLiMwlj2fdLYlq5zk7OteuO6hjEuk6CFogcMvsDSt1fOawcRR0DxE6fopHATUi0zXZ6PGfH7u3ewZ1f/ai3jDrVo/ld56bsf6wTYggdd14Wa11a8BqirlCxO6cXG2//7R4HwbK2TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66946007)(6496006)(508600001)(8936002)(83380400001)(107886003)(2906002)(66476007)(66556008)(86362001)(186003)(38100700002)(316002)(4326008)(8676002)(2616005)(1076003)(5660300002)(6486002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MyQItLZ7Qx4vBNxkrOM6OjYmF0dcveriYizZjZaiyLy8suqWxw0bKuIyxY6H?=
 =?us-ascii?Q?rmS0AEZxPpCyY5lbdZRT8ibowXZ+qyD5nnJn4XwGC7S+1MtwwI1QusVYeIWR?=
 =?us-ascii?Q?+mjn3q6M9c5yvx+BjCdjT+vL+t/hs2Hc00x/5nFvwKu9f6BOzzW5DqzSbicM?=
 =?us-ascii?Q?Zz+QiuBvNbVtmaUFbboxz8hxepADHEuRBz44i+71p+S6CZ08Kmkb+3XxytzJ?=
 =?us-ascii?Q?ETYCrhdu7IWpKBC0uc5AfZlIocr6/VyBngrE7ZYHrDOYVPAd/DTPn2oaZsDk?=
 =?us-ascii?Q?1hGs6/9fKi0G9S7ir5bzV5OqP9ScJMXhiyjuehRo/8v4ztYgv4/wG7dX9uCx?=
 =?us-ascii?Q?JVVtBWpTXctG1UjsJXkHkcS7eHdwWVzQCpg3/oam18PEvIdVZQ8L3YoHzHXp?=
 =?us-ascii?Q?ZlT6nlU3kjbk/3SO+JmgogcVUurAApq0yfcNg7uCAsbcg1TLi0RHo22kQ4mn?=
 =?us-ascii?Q?DgeX1NSRpU6ek4XGZpKjGNPUZfo8g5VWVvb0+KXRa6TPIQZpJ/d41WpCvQrc?=
 =?us-ascii?Q?K+6N4tn9prYl0Ja6h7Jt9SUwb9N+RC8WGfKqiD7+ofIkGe5si3zkWAWgmu36?=
 =?us-ascii?Q?wczz2qBuOtUTOfnIA+mwggi5JWK9pHUZ5UWRBZ+zz7wRObWd+DnyRXoCpMGd?=
 =?us-ascii?Q?0bZWzihuELj+mTtLz+N55C4yxBmDUh1uDKrBgT7g2NYOGSQ+vF9KjPLP1qhr?=
 =?us-ascii?Q?+4z3f9OQPw+xKCQffyFQYEwoOvNwtYMnQgI6SLZ95A7I/AwX7YYrll3VQ7dy?=
 =?us-ascii?Q?HoQtQgUjPGoPtVl7qLD2eqkcuFU222gAnpnA3ZqXLU8Jh5CZldGY5Gif/LRA?=
 =?us-ascii?Q?z4LgDCBhpmvX295QQQZ/JKB9UaxxWbpPJ34Icq1qoyFjnQJutpHI5Dut6XYq?=
 =?us-ascii?Q?Fwqf5P+t1b61XxaeLqA+YyhurSmDVOkH9zo3INfzJSSGHaM8dMTC14UxS1Ek?=
 =?us-ascii?Q?7kpWPXDOQlUEndfstBDN/IsRvnaj0TXHwo0H6PQjGiooBn51wjcz5aZ9bcOp?=
 =?us-ascii?Q?vGBE1KaPmHz94b4uxhFXWJ5tlOqoxp9xWX+r2bnfKGaXfMcP8KB9RJX/aOqt?=
 =?us-ascii?Q?S4d7FaMXj0u5faueRD2w6EoKm+0rloyKLh7tzW6nsSYTwwKb4nVsHKkuMIbl?=
 =?us-ascii?Q?DBTSxXUiox9DOPjDqH952iLi2ZqMe4c7bZP9KDwnOOHCKgCN4wYDlFvdAsM9?=
 =?us-ascii?Q?qkeX5SfivdnJBV4gbjobgAWplsMg52tY6BMyFoVDAxvvVNXyYD/KSk/4gv/a?=
 =?us-ascii?Q?0C9K9LL83qYhVE7Fv7q9V/eVenn4BtZ7Plo5UsfqLVL/4kYS5fmHv0wSSBUn?=
 =?us-ascii?Q?nXH5C6J0aLh8nfMraxOuJ+tFRjR1oVTgadFKmsQyVTt5UgT8NJHoALFRTRK0?=
 =?us-ascii?Q?hDDQZngoGGg+7PfYa7540W33MT1JgFM05NA59NRWU1tmbbnqFSv5F6ivSQHl?=
 =?us-ascii?Q?EEDxmQuTI47AATP8b2ZGrADsqOP4D8g7Xopwvr1hmABscvmPsYKBg7/iNxA6?=
 =?us-ascii?Q?BWTcqvwKJ5pHirSDlEH94ChRiAHvLhk698lJ8cBi6ea1V/og0LM9R9WnXr0s?=
 =?us-ascii?Q?fFfd6Ardxn3d5MQjnIMkqKS7BhXXsao+gM9gwCD5CPGAdIpug0t37F7gZY+f?=
 =?us-ascii?Q?ZeZ/l5OkuGNCzfwjaCHesLtIX1H/xfRqzk6BHFuonyBQ9RRNo3ZeQLIA5l2R?=
 =?us-ascii?Q?qmlWyLiAahKkX82BoDFpmAROMwg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4456ad37-0f0d-440f-3db0-08d9bf0dcc41
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:27:03.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUYicYCqh2yHrJcn8fUl+jgWPkLAz/JO0QpqDfXx3lPlj9Zui2EP4po2yEy4YYK7U3ohS1++kbfIjk0OLQnd5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, there is a test case to verify that VxLAN with IPv6 underlay
is forbidden.

Remove this test case as support for VxLAN with IPv6 underlay was added
by the previous patch.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/vxlan.sh       | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index 729a86cc4ede..3639b89c81ba 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -145,23 +145,6 @@ sanitization_single_dev_no_local_ip_test()
 	log_test "vxlan device with no local ip"
 }
 
-sanitization_single_dev_local_ipv6_test()
-{
-	RET=0
-
-	ip link add dev br0 type bridge mcast_snooping 0
-
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 2001:db8::1 dstport 4789
-
-	sanitization_single_dev_test_fail
-
-	ip link del dev vxlan0
-	ip link del dev br0
-
-	log_test "vxlan device with local ipv6 address"
-}
-
 sanitization_single_dev_learning_enabled_test()
 {
 	RET=0
@@ -276,7 +259,6 @@ sanitization_single_dev_test()
 	sanitization_single_dev_mcast_enabled_test
 	sanitization_single_dev_mcast_group_test
 	sanitization_single_dev_no_local_ip_test
-	sanitization_single_dev_local_ipv6_test
 	sanitization_single_dev_learning_enabled_test
 	sanitization_single_dev_local_interface_test
 	sanitization_single_dev_port_range_test
-- 
2.31.1

