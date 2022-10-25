Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1657060C984
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiJYKJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiJYKJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:09:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E0177E92
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWPIcNgVMWQwFgCxPBOjl+06icdhPbJFM+EpKUe86p0aaevfYL3XV45mjR/xxlg47QP2AsEC6XswLxbqlrp4g9YuddmEmxHA/Hj0S96WNsdGNeqjpM5JFmh9gGLv6MGvqyrCAR0RCP6v+cPxriUyjN//vt+TlABqPSULMiZgAMhoVQ0bhECVJ1wx8slyEYJtZ4Fopt/visHJnpNLH4QMtjc4+mq0Rtr64JaSLSVYnm47C467CpWIVmS2RG0wMMVMk3GevxBcuwoFtIKgp6Xed/CurbtDmDnIipHExRt66+wfP/a3DD1X9Yfb7UTa0ew8mfexKQq4Ha8LmZDQ9gtlHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3OAKlwUUhZ9nGBLi8a1/6yPNGuRKiiP0EOD6ENhYj0=;
 b=iKA/psN99fvZpVQPMWNeV6wignfBsuQiYYBlCZB7OP2oFdqBSxaCCTPYPnMpkKDGXQisOFlBtZgX3wZhgCPk3X8bg0Td5/Yq/X2+2zofllwsD9FbNWpVd3BiT8lHXq7q/CN3151eZus016Jb9WgVQ1FHAxggPRvyWQ0KMdLa++/FnTncTT8E7vvBMzAkczRw38rrIBReCaGGLJmK0PwJ3xTBxTpYnwCkliDYceGsQalea0kcKCU8PLTwUJz5aZFfqMtpDDG1rYJozbsHj0dyN1XsKUpHHf5Ad6WVocuU4mB0eHd4z7YxW3KzBm9h5CIqc6C1eOJ9uBjSCQBy+oa3Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3OAKlwUUhZ9nGBLi8a1/6yPNGuRKiiP0EOD6ENhYj0=;
 b=BVExyaObPRpcLpRIhNny5+MkLi81N81Ol6yVo4joijtTJRKJe5rKxVETUTcvdCR0H4hvT+qXF5PjoqRTP7QY/hmnHZD1KJK+D/K/GF7Mr3bguJGhH2Pc68psTxD8cE1FpPdSpGHvAEqDCos6jI7f/QApB9IKAKQJR+Z5URJc39bpP1F+G6Zv1RyX5YsyRDGy0qqYE1OWX3m+q6UmYafZFbVRIq2akL18OEPHpP4vvlfkMdlakQ24Ng4KCP9qfkEjdK6ZTKynj1ySvYyO7w0YgFtoKplvtu9s4xVvkQe/8iR/dE6WngUnbhxXq/8lG61NIZJ6JR/bGV7F80D8nEW9nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:02:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:02:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 15/16] selftests: mlxsw: Add a test for locked port trap
Date:   Tue, 25 Oct 2022 13:00:23 +0300
Message-Id: <20221025100024.1287157-16-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0229.eurprd08.prod.outlook.com
 (2603:10a6:802:15::38) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 106ac5ba-70a8-4a99-86c5-08dab6700944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2mPWzMCBgqdhOXUhVY0bsPoTbZo1Eh2ZgxOoyphcdm4IBAu2WE+xTGXhIDvNEPQG1n9j0au3Rk3rJpbmEyXpDPem1YEw+iCezOmAgf2MQPwzy0b7gX4BH93v2m3OkRHQvEIGNY6vZ1RYCg2TJB/WVzYw5uSHQDa4RY7cHNUgpBV3Mv3NLzhlWWD+41d74LFoauo6pSeMyBCw9B0NQ5ol2svzsB2MORktcqS+94SoKvRgC1a+wTx0+aXGRkEUFMtc0oRh7CaQQ1t6vVWRHGPC4bakxVNdIwnFBFaMXY4wtH3xl1Vl9g1VD64YZx89yFkl6uLkZff8DH+fo3F6vggpVe+y4H1VkSpgj3nubeO8qzINP/JSqUUU12ZKIcsH/TRtm0Yhbx6qLfl50YP3wpZtOw02i64ADWze/dqtqXoWeTq0CfvDdIlgF9bu6mjBozpP41JwFZnQysWvIwDQcs/og6pfXzdupn/ny5M+i6c7coS/H4+5YDoRNvD6/wAanGocA4kimKkkghucmbhSe5ryVU9N/KF+QiaNU4LYnxwnAAV2N+OyOBw5Do7S+QaqsjEUxjhCJOnMmEym2J2Acmm0DizaAKClfGW294yhJ/1fIAg1WASQhF/XYBCOMg1lgVGzMvuBUQxWraLIOsbOnJs/aPVuNNGSGDR75YiKx9nlhTEN04TU206aIS871fEXxHfnr4c5r2hMnukNh38IKgk54A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MEXei19gNmV43X7seN+nqG34kgIzmzn3hfhHD/j45p6QwT5KZq0NnnlP6dsQ?=
 =?us-ascii?Q?KfpsQ4zarkLZhnVEQfo9hdCerpNMu98C3EgqzhtYX+6CjddmDpdGDZLJeAs8?=
 =?us-ascii?Q?5KoEZsMlX7gYmRM/67+k1973Q+kYoAyBrOIDL8h8aKqe+czG4EVTRpTe7TeL?=
 =?us-ascii?Q?2/mYsl2JfFGrA79xRy90pbV73pzY1gV30mKd6cGmx2+vAdN5Wr5KBLN1y4Nc?=
 =?us-ascii?Q?gnPBKjJLMtLcyy9ooNsAiAQgY7D7uKBqjzQNP2ylecrhG/2lrVizIL6eclnK?=
 =?us-ascii?Q?pfOTtGP1mMEM8Lf8+ZHa68Nrkif/34a7t5zTAbhemrDUGIycyJZ5AYVgdOrt?=
 =?us-ascii?Q?J/XWaLx76yBYZ67611pBI2hTtivV/0BkSJQZOxGwu+czhOGtMXzZx9IM/WCD?=
 =?us-ascii?Q?51fWBP4R5VcZO+/19o0NQfssPz8MeJ61j7uRcnzZrWGvLySTAarp6RXNlmtb?=
 =?us-ascii?Q?NvuGqM22t4t55wQd1H2u6XCZD2Hd558wjPKE6S5U3slJRaxkI4piZwSe1CJG?=
 =?us-ascii?Q?+v57IAxtRfBiNqdsGsllDx2gZl2gT03jn4KUz2fwsj2d8w+ZPe9YAUVJxu1U?=
 =?us-ascii?Q?uQBfi7nTEWtTgm8J7Nj6mLYyWjMZI4ZsCqPhZeH/khWtsRqoOPewdQsWi306?=
 =?us-ascii?Q?z31sYYvvhyBd6y3sEs9rODlZtCQLYXh69R5JUAwbjJV5aiNpHP4FE7uTd1s2?=
 =?us-ascii?Q?aMZnOmucxQIrs+9ZWvhX4wGNiUUiGM4Pg1f4ZD+TSiuiq9Fqn9USJB67YKRM?=
 =?us-ascii?Q?h+oCkkextoaZuhXgUkQ1V39Y6nJn4DGALsp2LAXkzssuVcGzUeZ1brPkEWfj?=
 =?us-ascii?Q?ZMUY6EsQfARKd6RO6rXRejixhuvvd3wurZp/utTt+I9tmF5mcM9uiFSsdqTI?=
 =?us-ascii?Q?88t84XRGqnPLUw9cyKbS00Q021wVBTHXuwguXBhzc/5gDPKAnMRREymHXuoL?=
 =?us-ascii?Q?Yr/f0ujs63G8jLz1eZCyGO5e/X1bqcMHppSglYwk1ap+fOXwOUjV0OfgVylP?=
 =?us-ascii?Q?TFk0mnBbOXN6+/XDtrwVjeURLeuRdA0YX7ph5ukRp5YkfWARDWkKlSimJRdU?=
 =?us-ascii?Q?ddWYnwVYtwghW5Qg9asjHRyaXE0XUuZV+cFn/BirqJBTJCvFhIl+KK3QEg5p?=
 =?us-ascii?Q?308zLDhynGRr1KJjib0+TKAipqf8dtW6LmwgqVa4dQBHZauj6haMJirmgxlg?=
 =?us-ascii?Q?eVfWOHSuETv45EFtYbxywgw4CDS6zCRXNRBxV9KXfvOs60+dvVp2mokZJnn5?=
 =?us-ascii?Q?jatzVqP1q4hbKfi9EEWsjKKjkrTlGUM+86S18aNdcJ7H6Q89cLtW/ShROkdj?=
 =?us-ascii?Q?ueF3ibSKPN0MEoW9f2dGnoMxKDI/LvOXVzF0ZcAucBhiGR7gl/R8PFbXZszk?=
 =?us-ascii?Q?vQgqx2tWJzO8soPluyAwD8+89zAdHpEzFZTDkA0EyLej1iaSfYPcjLcsgNoB?=
 =?us-ascii?Q?qejobHn5AJMppO4mfS8dgcHth1rNgFEk5mn7T0dzUyPwkC/ZKg4BQnevnkze?=
 =?us-ascii?Q?IMzQ/68X7FoTYVL84uGPWxma2qLIsSoE7bJZgwDi9Bpltn29TBz7gdOBbN56?=
 =?us-ascii?Q?dFIpWGnb2mDTXufB1cKIAo+aNYZbgQBEoHPb+STI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106ac5ba-70a8-4a99-86c5-08dab6700944
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:02:33.6143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aSCw01IuaWKRa0wIfrE1ZCnQ6iRsrtTf7L9dCN0Dz1MutymBZyfdVyupCUvRiaD92a7KIeEbwjN7g5BQqAkaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that packets received via a locked bridge port whose {SMAC, VID}
does not appear in the bridge's FDB or appears with a different port,
trigger the "locked_port" packet trap.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
index a4c2812e9807..8d4b2c6265b3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh
@@ -14,6 +14,7 @@ ALL_TESTS="
 	ingress_stp_filter_test
 	port_list_is_empty_test
 	port_loopback_filter_test
+	locked_port_test
 "
 NUM_NETIFS=4
 source $lib_dir/tc_common.sh
@@ -420,6 +421,110 @@ port_loopback_filter_test()
 	port_loopback_filter_uc_test
 }
 
+locked_port_miss_test()
+{
+	local trap_name="locked_port"
+	local smac=00:11:22:33:44:55
+
+	bridge link set dev $swp1 learning off
+	bridge link set dev $swp1 locked on
+
+	RET=0
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased before setting action to \"trap\""
+
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_err $? "Trap stats did not increase when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased after setting action to \"drop\""
+
+	devlink_trap_action_set $trap_name "trap"
+
+	bridge fdb replace $smac dev $swp1 master static vlan 1
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased after adding an FDB entry"
+
+	bridge fdb del $smac dev $swp1 master static vlan 1
+	bridge link set dev $swp1 locked off
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased after unlocking port"
+
+	log_test "Locked port - FDB miss"
+
+	devlink_trap_action_set $trap_name "drop"
+	bridge link set dev $swp1 learning on
+}
+
+locked_port_mismatch_test()
+{
+	local trap_name="locked_port"
+	local smac=00:11:22:33:44:55
+
+	bridge link set dev $swp1 learning off
+	bridge link set dev $swp1 locked on
+
+	RET=0
+
+	bridge fdb replace $smac dev $swp2 master static vlan 1
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased before setting action to \"trap\""
+
+	devlink_trap_action_set $trap_name "trap"
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_err $? "Trap stats did not increase when should"
+
+	devlink_trap_action_set $trap_name "drop"
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased after setting action to \"drop\""
+
+	devlink_trap_action_set $trap_name "trap"
+	bridge link set dev $swp1 locked off
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased after unlocking port"
+
+	bridge link set dev $swp1 locked on
+	bridge fdb replace $smac dev $swp1 master static vlan 1
+
+	devlink_trap_stats_check $trap_name $MZ $h1 -c 1 \
+		-a $smac -b $(mac_get $h2) -A 192.0.2.1 -B 192.0.2.2 -p 100 -q
+	check_fail $? "Trap stats increased after replacing an FDB entry"
+
+	bridge fdb del $smac dev $swp1 master static vlan 1
+	devlink_trap_action_set $trap_name "drop"
+
+	log_test "Locked port - FDB mismatch"
+
+	bridge link set dev $swp1 locked off
+	bridge link set dev $swp1 learning on
+}
+
+locked_port_test()
+{
+	locked_port_miss_test
+	locked_port_mismatch_test
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.37.3

