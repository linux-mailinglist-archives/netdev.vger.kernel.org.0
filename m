Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D81504CDB
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiDRGsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbiDRGrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:43 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642B2D9B
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:45:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+fQHbNR9wdBDsMz9NvzJsYRDkKkGuOergYDB4ck5Z5m2Gg+krOugfZU3ZKAF8smxVpRlTA6jLUDxPBq2+1TQozXot5hJBbxiFElmhEkyzkC50urtaTeRFR94C8c+ultOhNflk4OiQtCmAf1Qm6opj8lHpjqlDJpjQ8mrnLRcCZuM3RvK9lxdSsQ9uTOUP4YqKj1SQKcLTmwOgt3ziIEunrn1PlWe8lqJzJceolIYN4K6zijt+yErDORUYYB//7KsdF2RWHf6g2yTx9KV32ILbChkvgR9H2fZJbFwZg1gAslGxabrpwhZsfodIElcbUzs5gXqmXt1c8oVMwh2G0IwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNdCEC5WT4nq+xlbrZyPjJDXEKYwHE6ODAqUvLi0WSo=;
 b=Vv0xgI8tjVos4qxCpttc4/MoDpApk3m3qjlsG1B/FdDC6WiED5dmvcXQmh93/tnTviAXRTXrxJotkNVCkPVyln2sQi3Bvw+Fn97VYdT3EotmtundZfGXO8BsBdcLRan7OdGYXhA74ufPqgBfYPrUb2Kp1zyNeAU2QJ56PztHGdJmsMslS4ytKjO4Vavx5ZErdpl7BT4O0/xJiiurE3/OR4T0Xb6WLhbbM2ZSZKpkC3TCZ6nb83WG/dNUCFVHRRZ/QiTYX3xgYCmCuWtVxnN6h5ykdMjVYc/YkJmtqmgfdkq+FmBI3jHMLYxf5NYG4hpzkYc1Bmw6UKZ4CQ4UzURCGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNdCEC5WT4nq+xlbrZyPjJDXEKYwHE6ODAqUvLi0WSo=;
 b=Dyqz2TyPer8DnB540NV9xz478YFjT+g5Vx5XhNna7BoMLITY3yIcACAZgFruzhF44T180ml+nIXCoqMgmZS2Li0n/FZ/M1kwa+1+UyDDpG/o6Ki41qo864cQoo9szbXj/+HTzcM/+8X6MYI7DsPoLh1xS5U+R/sjcsmCb/vTwXHJFrs1ZK698g85ILZoLuIbcNM/mwHN4dzoVMHGN28plcJ2WLzJ+xoVtIMflwNIYfjQSvwJFw4l+rdA8sL1E04jZnDcApY4L6xn/gJhk3MtY/otjfXnfJBQ8F6RrOcNn3LLsnaX9A0Vf9wiMAHLaXqxEzkFKnRaeslVRgDMS2rN3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:45:02 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:45:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 17/17] selftests: mlxsw: Introduce devlink line card provision/unprovision/activation tests
Date:   Mon, 18 Apr 2022 09:42:41 +0300
Message-Id: <20220418064241.2925668-18-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0401.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::29) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18a48747-6693-45c8-19a0-08da2106f6ef
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3664758D992694EDC6A0EF26B2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3bAD5xwVWIQWJ8bhSwvbhHT+GKTlueD3lo2mGC92ZjFVtSMNKD2hmsx4vtLenVadXCfY8czsVzLhHBKV6pSVOHmh4UfVGnOFON0nDxfGYVoyRnvMbczI6Gdm2GgMa9Lxue6bhH92c6KWW5C089nUIri5hxrmwJt7XVONkWFoOdOT+2ZTlnMjRQ72cKVboCGTUgzOl5qVIxkY94xyTqIZQaEeQb7OoZ5KeE/SZxvO3NVqIy+VaZKR4Ure9cq2U5ZVhvUMZhz2UR715mI8RT7qcRz9XhYNpmIEOf5kGGmqMj8DUlynY+qFpO2gwx9wO7UeTr3X9hLlBklknoiNZH61y5ievsbe+gBOAbUhjRRWQtMTdg72eZdzMH2hbhxTFCG3r4B9BJxg08abesitVqvlBpOBv19SQ24XYOhEUgIrAp/Ic9AMyXhMnC57Wa51S8xyuOncPURvFn+3e/YN3iZz8O0QMmJeNqm2BdNE3h3xpp0Nbi2DpTortbEXXTYmIAAoAIxLZcf5B1+IL5rx+1PwnTkl805fYfxrn/6v51BbOajcbiRqs9aYdY5Vjf0xmleUXoGzvcGZ/SDy5F/LZ2EJE7Gc966PesdT2432v6Li9n0Se+NJA1G4Z2t6pcq+k3cozZcN8iHvVHBllQwmk2YGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+r0za6YE/Fe8iSwNZQh2mvqgfttZtFHjFR+1gmp4eL7hPHLFOkYpom0MLGhn?=
 =?us-ascii?Q?gCFYJWlkGU+UihACe6pZkxUasIZSMquI89PlLzEJG6ZYX5xeF+YVqq+EydTm?=
 =?us-ascii?Q?hN0h79Ok2Ho32PtRPQY/8asK4iOtx9M5cmMLEWDmwU2q0X9BMSncMHLcLYSe?=
 =?us-ascii?Q?ZgUofvvSMAB5B65bx3b+pY6nEuCrZM3bkSk0CIPMWJi+piGBrPfRBvESpTsW?=
 =?us-ascii?Q?5PYwPfrkv4XiFWSXX3yk4ImnmxpWfQzLbKjoCo2uPN8GVkYkjiEivVozlXcX?=
 =?us-ascii?Q?TL+Q+5SWjjau1a860DXcNte7fKyz1AVQqUOXTfZgy8PtZ/mId2YmgFjFyhD8?=
 =?us-ascii?Q?6wjLoLTVWdESsFAzIMzmeFNYFB1k0usTRSM/9gDYL40KVmbNOitfl5y6gxd7?=
 =?us-ascii?Q?8v++7KO55SZVb7pSH8O9bN1i5khFFP3gq1lYjVuI1S0T3JDuzPzftPiwAiLV?=
 =?us-ascii?Q?aopXuhQrPJVxqK5tTqCa0M0WF3gyzvMHqnjnbTuCdwdWK/YFIPqdz3mEeD86?=
 =?us-ascii?Q?8t9IjQ1VuKSjJdmwbhZdKFXgnv+MfMVY1V+tGsbiW3bhP2jgfN5VgfG32D0T?=
 =?us-ascii?Q?ipBi4DejzoYgoE7t82YiTip+MbUUBlkxkEkato5x62TmQsFYOE/dLzTP4XDG?=
 =?us-ascii?Q?149al/WG6iMgFTxQaWKBQNvDyDsaqeDWfCVVpZDX+j7pLzP09aiW9jBBvgTU?=
 =?us-ascii?Q?K7Hr3qZzIInE9zw2e9zATHxRgBfx1Q6aqH2+RrsCXNitK2Z/FFbuqY4N9BHS?=
 =?us-ascii?Q?JUoLcvDSRL87BMqvIiQiei9abiIqea3JlDAwk3OaAGXrcWEGnd75oTEUUXxl?=
 =?us-ascii?Q?YYCnxOKSJWGNpqOPkyD0N1Es7H81ADlVE8xnkigNhhEnv8gHWRaJ0g1XkAUF?=
 =?us-ascii?Q?E2UAeqAa24nS0PnuXXu8nWyUsPlN0EES+Ic6xwGlFPOWsZl8Gl/XbTeDJlRz?=
 =?us-ascii?Q?XYTK5J/J21A+VL3rQzqCL+sL99+IsQbQHhm43LLefcK4oZQRmMv5GmW77yVP?=
 =?us-ascii?Q?gfdAlgDNP1MNUBc3HqIYswePnU+j9XcpyWhBDXoA3ZFPzLtZ8beOsGd4O5lI?=
 =?us-ascii?Q?UkeFyWmS6755278FbOCpP8WRcCYjPwI4rdmW/VIbxDBCtCV/VJkigdu2MJBI?=
 =?us-ascii?Q?GSo4JnzHWeLxFR33iXmrRyjoIGoCRHXnBohC7ZbTcYez+F6ntg02Kt6r0Fn2?=
 =?us-ascii?Q?aIryJlTyLydqC03sh6gCtLkRfpMe8Wr/BTVm8OCsOVxNG4FJC27G8zCMjDFj?=
 =?us-ascii?Q?6nVRQnDD8Dw9GXmnPxukWCEhNoDXUW0datbAIo99oUwrrkSFY+6WJACxpf8m?=
 =?us-ascii?Q?O/Eehx9l5iXB/GqwL6UA0kiZZAb38jT1RiL0EggUc+/v4UigqXN9WJDJ8tKt?=
 =?us-ascii?Q?ADiNFdx/gYbt3DFm5UkdLaMQj5s6WsH+BhqaNASdLIw0Inud569Psr+0MLlN?=
 =?us-ascii?Q?Lryry4XYvKv9byr2R7kf/oGB8sLTdo2Dn/TQ/buHj89AJ0d6a1BNVZlQQnvH?=
 =?us-ascii?Q?Bps9jzJT9NHlOPj9dR5CP/4rF4tIpCxQE/v1dGHv+hGAir2SPXjqjY8C3o+b?=
 =?us-ascii?Q?qsTGx0q/LxThlm6SI+UvhTiRARot+n54NNmlLUMTTBbM5/X5OSqX5AtcKDzf?=
 =?us-ascii?Q?Bq+9mnjlYiODDsshYyROaJ1NrHwmgCmDhqp08JUR4JATNb+aj/2Yp6hxf20X?=
 =?us-ascii?Q?UEMR0LMtVh9Wy5ifdSbw56sddX5VOYH+nJYM5fzCfQ/AQcEWLV4Ow/qTPif5?=
 =?us-ascii?Q?ehYLbKLuwA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a48747-6693-45c8-19a0-08da2106f6ef
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:45:02.4762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 59R7MfaeJyzt/R+WqrkA7pkX4+T+bltEGbJy7prIFBsPf0xos65+sU/egb1ZUev4i9scb4mc+3/W4aPJlSpggw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce basic line card manipulation which consists of provisioning,
unprovisioning and activation of a line card.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh     | 280 ++++++++++++++++++
 1 file changed, 280 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
new file mode 100755
index 000000000000..08a922d8b86a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -0,0 +1,280 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# In addition to the common variables, user might use:
+# LC_SLOT - If not set, all probed line cards are going to be tested,
+#	    with an exception of the "activation_16x100G_test".
+#	    It set, only the selected line card is going to be used
+#	    for tests, including "activation_16x100G_test".
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	unprovision_test
+	provision_test
+	activation_16x100G_test
+"
+
+NUM_NETIFS=0
+
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+until_lc_state_is()
+{
+	local state=$1; shift
+	local current=$("$@")
+
+	echo "$current"
+	[ "$current" == "$state" ]
+}
+
+until_lc_state_is_not()
+{
+	! until_lc_state_is "$@"
+}
+
+lc_state_get()
+{
+	local lc=$1
+
+	devlink lc show $DEVLINK_DEV lc $lc -j | jq -e -r ".[][][].state"
+}
+
+lc_wait_until_state_changes()
+{
+	local lc=$1
+	local state=$2
+	local timeout=$3 # ms
+
+	busywait "$timeout" until_lc_state_is_not "$state" lc_state_get "$lc"
+}
+
+lc_wait_until_state_becomes()
+{
+	local lc=$1
+	local state=$2
+	local timeout=$3 # ms
+
+	busywait "$timeout" until_lc_state_is "$state" lc_state_get "$lc"
+}
+
+until_lc_port_count_is()
+{
+	local port_count=$1; shift
+	local current=$("$@")
+
+	echo "$current"
+	[ $current == $port_count ]
+}
+
+lc_port_count_get()
+{
+	local lc=$1
+
+	devlink port -j | jq -e -r ".[][] | select(.lc==$lc) | .port" | wc -l
+}
+
+lc_wait_until_port_count_is()
+{
+	local lc=$1
+	local port_count=$2
+	local timeout=$3 # ms
+
+	busywait "$timeout" until_lc_port_count_is "$port_count" lc_port_count_get "$lc"
+}
+
+PROV_UNPROV_TIMEOUT=8000 # ms
+POST_PROV_ACT_TIMEOUT=2000 # ms
+PROV_PORTS_INSTANTIATION_TIMEOUT=15000 # ms
+
+unprovision_one()
+{
+	local lc=$1
+	local state
+
+	state=$(lc_state_get $lc)
+	check_err $? "Failed to get state of linecard $lc"
+	if [[ "$state" == "unprovisioned" ]]; then
+		return
+	fi
+
+	log_info "Unprovisioning linecard $lc"
+
+	devlink lc set $DEVLINK_DEV lc $lc notype
+	check_err $? "Failed to trigger linecard $lc unprovisioning"
+
+	state=$(lc_wait_until_state_changes $lc "unprovisioning" \
+		$PROV_UNPROV_TIMEOUT)
+	check_err $? "Failed to unprovision linecard $lc (timeout)"
+
+	[ "$state" == "unprovisioned" ]
+	check_err $? "Failed to unprovision linecard $lc (state=$state)"
+}
+
+provision_one()
+{
+	local lc=$1
+	local type=$2
+	local state
+
+	log_info "Provisioning linecard $lc"
+
+	devlink lc set $DEVLINK_DEV lc $lc type $type
+	check_err $? "Failed trigger linecard $lc provisioning"
+
+	state=$(lc_wait_until_state_changes $lc "provisioning" \
+		$PROV_UNPROV_TIMEOUT)
+	check_err $? "Failed to provision linecard $lc (timeout)"
+
+	[ "$state" == "provisioned" ] || [ "$state" == "active" ]
+	check_err $? "Failed to provision linecard $lc (state=$state)"
+
+	provisioned_type=$(devlink lc show $DEVLINK_DEV lc $lc -j | jq -e -r ".[][][].type")
+	[ "$provisioned_type" == "$type" ]
+	check_err $? "Wrong provision type returned for linecard $lc (got \"$provisioned_type\", expected \"$type\")"
+
+	# Wait for possible activation to make sure the state
+	# won't change after return from this function.
+	state=$(lc_wait_until_state_becomes $lc "active" \
+		$POST_PROV_ACT_TIMEOUT)
+}
+
+unprovision_test()
+{
+	RET=0
+	local lc
+
+	lc=$LC_SLOT
+	unprovision_one $lc
+	log_test "Unprovision"
+}
+
+LC_16X100G_TYPE="16x100G"
+LC_16X100G_PORT_COUNT=16
+
+supported_types_check()
+{
+	local lc=$1
+	local supported_types_count
+	local type_index
+	local lc_16x100_found=false
+
+	supported_types_count=$(devlink lc show $DEVLINK_DEV lc $lc -j | \
+				jq -e -r ".[][][].supported_types | length")
+	[ $supported_types_count != 0 ]
+	check_err $? "No supported types found for linecard $lc"
+	for (( type_index=0; type_index<$supported_types_count; type_index++ ))
+	do
+		type=$(devlink lc show $DEVLINK_DEV lc $lc -j | \
+		       jq -e -r ".[][][].supported_types[$type_index]")
+		if [[ "$type" == "$LC_16X100G_TYPE" ]]; then
+			lc_16x100_found=true
+			break
+		fi
+	done
+	[ $lc_16x100_found = true ]
+	check_err $? "16X100G not found between supported types of linecard $lc"
+}
+
+ports_check()
+{
+	local lc=$1
+	local expected_port_count=$2
+	local port_count
+
+	port_count=$(lc_wait_until_port_count_is $lc $expected_port_count \
+		$PROV_PORTS_INSTANTIATION_TIMEOUT)
+	[ $port_count != 0 ]
+	check_err $? "No port associated with linecard $lc"
+	[ $port_count == $expected_port_count ]
+	check_err $? "Unexpected port count linecard $lc (got $port_count, expected $expected_port_count)"
+}
+
+provision_test()
+{
+	RET=0
+	local lc
+	local type
+	local state
+
+	lc=$LC_SLOT
+	supported_types_check $lc
+	state=$(lc_state_get $lc)
+	check_err $? "Failed to get state of linecard $lc"
+	if [[ "$state" != "unprovisioned" ]]; then
+		unprovision_one $lc
+	fi
+	provision_one $lc $LC_16X100G_TYPE
+	ports_check $lc $LC_16X100G_PORT_COUNT
+	log_test "Provision"
+}
+
+ACTIVATION_TIMEOUT=20000 # ms
+
+interface_check()
+{
+	ip link set $h1 up
+	ip link set $h2 up
+	ifaces_upped=true
+	setup_wait
+}
+
+activation_16x100G_test()
+{
+	RET=0
+	local lc
+	local type
+	local state
+
+	lc=$LC_SLOT
+	type=$LC_16X100G_TYPE
+
+	unprovision_one $lc
+	provision_one $lc $type
+	state=$(lc_wait_until_state_becomes $lc "active" \
+		$ACTIVATION_TIMEOUT)
+	check_err $? "Failed to get linecard $lc activated (timeout)"
+
+	interface_check
+
+	log_test "Activation 16x100G"
+}
+
+setup_prepare()
+{
+	local lc_num=$(devlink lc show -j | jq -e -r ".[][\"$DEVLINK_DEV\"] |length")
+	if [[ $? -ne 0 ]] || [[ $lc_num -eq 0 ]]; then
+		echo "SKIP: No linecard support found"
+		exit $ksft_skip
+	fi
+
+	if [ -z "$LC_SLOT" ]; then
+		echo "SKIP: \"LC_SLOT\" variable not provided"
+		exit $ksft_skip
+	fi
+
+	# Interfaces are not present during the script start,
+	# that's why we define NUM_NETIFS here so dummy
+	# implicit veth pairs are not created.
+	NUM_NETIFS=2
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+	ifaces_upped=false
+}
+
+cleanup()
+{
+	if [ "$ifaces_upped" = true ] ; then
+		ip link set $h1 down
+		ip link set $h2 down
+	fi
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.33.1

