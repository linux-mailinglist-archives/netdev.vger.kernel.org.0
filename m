Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8599254DF63
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiFPKpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376414AbiFPKon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:43 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE355E75C
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:44:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOClAtaykiUUpFP73Y0YXfUIyy/OfRRD04At521caFmtbMT7Sn/0DBw2bnn2ATB/W2qY+LgvqNDMdgdEPq96fgEOvuyCBYHPyrWMfOB2+j4VpOsqOirDOANucuCiCMvyOV9A5rawzBTDoVJVCsZazc4BUqe3k6bZshtt+ggzSZH+xBt/VzGEZ3ZB2PvoFT9qCeq/UgrGg/vpWZa95+1LcHHEn/Ecw4SkBxypFbpaFk4PtCcRcli5O0w2wvApfF79YK/CsHxK43GGgjXR6SCpVthDuY/8tiJHTBHqSedTv8fblCHxces48RUwNZRrn8Nqn5FIyPUwOOtfObYZeCubyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVXQG7dO/qZF0F9efAVeYLlBSrklp1SZlsNxVY5iecA=;
 b=jaiqZA7DFv8Rwsz6Kg8NlZQri3CE2tJP4MJTi01JSTqLXd4YxRkZjaoGgJfqOPYqbeK2bLQD9/ssABIpZd6HIbpbXWieW1uf4SSGmDp0TZ0UmQxmb0QP6BwQU5ZNWs2o7zAp17xJlpt72nZfnFUEBJBJJjCYrPjN5QNWsrq66902Kr5UgBriP0Yqy1tJF49cKVlHFiCxJiuvJ5AITd9g6DDrOIhC9az+9NIffzSbBHfeMWkwZSx1hEisXSIXx6GfT3xqRneJpYpcJ13bzVjeBpYqR4bSwSHUDoAJYThq2eH7fB8ka9KKbcgDqQ+jaAHqiNtn/ms0JOQ316HP7STXng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVXQG7dO/qZF0F9efAVeYLlBSrklp1SZlsNxVY5iecA=;
 b=Id1U6gnxipxZhIvT3xHYjYK731gxrGU3hI6qj+grDJY526EcmAYmvaG3rzKddMvGHMssYfft6YpgfwGVjry7qWTcyqp7++EC56RM66rREbZ4rvp+WU4AbW27zzs4LPkmNUEIQ1w8CatDhokemxVAk8jBG1RYm3EihxVNo2u76XXdWY3e1FB63N1+lKtanDRDitldp1Q4/8xGtL1ce2VbtfHxe0er3aVm3vY6iV9z/HRW3FFUfgmnV1n9OSGBmJywy5jiIyzLEKNMStBlPMmVhHY9S3iB0p7ZsiRFuBHsO8k2RSqJhzNhde5dZi69+uj9Ad5Z403Qe3FelC4GLxPJnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:44:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:44:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/11] selftests: mlxsw: Add a RIF counter scale test
Date:   Thu, 16 Jun 2022 13:42:44 +0300
Message-Id: <20220616104245.2254936-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0028.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b82cd811-8c91-488f-a0d1-08da4f853013
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2504BEC74AD35213501DD1F5B2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cf7E8e+T0HlGcH7gDkS8Ej4JpKbmJwQE7yTabGySwc9qamul0rhO3LAlX+cuDrgp2n9m8gtkrfuZ6cZZk5YOSHXfyUbIQMlAM9QlU1Ghw1MmBmH8TlbAG4wY58AkJRsZOQbTMWvQhdQBlG6dqkjcFt8XworAa/XMLvwg5wlgVgD92PAzqotVSMkG5Pr0e9f/FhdG6djyNAZuxFJUAdL7TXqgtIGK3aheTi+FW4N7Bqwc3LW08U0jjc1rt+EXA//AI8es09siZVqR6XAIY2r+rzZRAjuOtEIHkdlzKdQh5idSpKI28CuGDi+wHa2bXpieGVYPAcovwl61ifatlI0pMZnxNya5wlgOpWzs4C/qj2Jo+tJwJ9pS+DMAAk5NePPKCPhWOIiP0fdZfhGwBNf8Lm6CAb5ZtGPuFs7743vBqZlO5WbddoBvw+0MQLbM6OzkfaZi5F1hK74jtwjaZHtC0P67Un7Tk67FwMUSNNHDCI83uD1zKlmfuUqiGoQTNmB/kW127GntnzuvzRFcCfMI8T7wUBeAt3/v8TEVn5iYaISW0rKIrf67fIN2cJzyruHmDJ0YZUKkuok2yKe9mscZ/2u/PZNfaviA8LVqfHRAURVegGirGPEVg3oqO5Ud9oOKe5SlYp+cFTE4gw+LHPc3YA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(83380400001)(1076003)(6506007)(66946007)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(66574015)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t+Y37rm7Qk8WRhIQSsKq4FkxpeV4IpnTRoM/vspoFnZlDxrg6Hb0IdljQNl2?=
 =?us-ascii?Q?bpfI1nPlz7HwQJj1zHiiWZhZLIOgyiI138xMxA6j72rvx2m1YEOhPZ5Q+fbG?=
 =?us-ascii?Q?8lG3NSkcr0fdTG0bP7LvL7iUiTeUSYpwAWx/nMAQcj9/afh46yFcOsXfQlYD?=
 =?us-ascii?Q?Y8YDJciyXkUnmDFJXew43/Qs8bVKBEwxdZr+fQEaNQYHX+sleA6jUBRDNgPo?=
 =?us-ascii?Q?l3+djqQzXdBRgQrJgcvlZwLdhMRhZ+/5GtY4zWAFwlGaJkqRbxNN63gVPHdb?=
 =?us-ascii?Q?gGyLcRkYxpUdgZScxfp48CR1LulPM/o8FKVTHiE6MPoSMg+koyB9H4/yXuSi?=
 =?us-ascii?Q?zj0fk2+4/w3khiTDdpkrFYluE954bqoG5buT4JyAkyrN/1OHymUFugUGxl0N?=
 =?us-ascii?Q?AFBdjT27jCcDUgnCT3xfuDmnJieQlDzky5Xsf15kQUrNZqsDg4c++u727K5W?=
 =?us-ascii?Q?bmDIY7yc+VLGwqYiW0uwy11ZPFVSdXcCo365PRKmiofyvpbzpe/Bl5QUuudb?=
 =?us-ascii?Q?QG+G1f5bUaMgztJohTMQKMtsrgM2NjbeswSI3GLL1+fYCWoq7Wi3gFQAlHwe?=
 =?us-ascii?Q?kDlkcOinqyg+h0caUGp1RohNpAHPZxPUEKD2hGh8AwNqN28QIJAF3ZaSLHlM?=
 =?us-ascii?Q?bakadnx/sprI6BU650az61UqylWLSYPA1LSAx+RCcIbUq2/BOpWX4fPAyFF/?=
 =?us-ascii?Q?mPipsUoclQEaQ12cZG78pFFJSuOGfXzaF80tQhPbqA7NxEwDizitTVRB57BP?=
 =?us-ascii?Q?5d04Ko2OwK5OvTpribwH0kT/N1srkoTj1c/EslqJj9THsAfHnBwlHpoQaqnx?=
 =?us-ascii?Q?QzcKVoPBsTjLpZ+/PPmLeoaUGHGeimpqPCR6fsPtru64XNerF8EeuxQmcamz?=
 =?us-ascii?Q?PZxYh+NWGdeknJsA0inIVATE2yeN3XbtMnA72PXDSZqCbORDU5M8JTGrTkMf?=
 =?us-ascii?Q?HJvGGyuo/D0tsgLCJlEHddHGuY6tL0ziJ5uoRjj6uqpPd9OGROlF6Oyg3hge?=
 =?us-ascii?Q?Pv3Pc1C6hBmc8oKqnrCIuzky7qLo0+Fe+sR3jIHQily1pkyjTj+FleVZNnrM?=
 =?us-ascii?Q?zLW3OltFX+lpErsmTZTGFKjHZ79tV3IbbqtkZRlqPYyy+qR6Uc+Jzy81Fzdn?=
 =?us-ascii?Q?2e31L4g8pfouQOhTrEzpWgQefEE6+M5+lOGULD3ydRk6x9sMCOf5SS/aFXjk?=
 =?us-ascii?Q?GN7lPhsogMMtUun/bJ53ldpIQomsIkEy4QcMbotVYcSFrPiiF+bdgtUuh3SR?=
 =?us-ascii?Q?ATNvJxL2HvRzK1dH2fu/NUBKHWaXaPR2avwU6QMg0rXtQiGbMKEH7H9dG4iP?=
 =?us-ascii?Q?8wSGwi9I23kIlB+CVSXaSXbss3KRlHfvISbn7K/zmeQTzUVYoSWxHsN25sd0?=
 =?us-ascii?Q?8YhSr/yKEftBQiUGmly4y03t35DY6mkGQChPfK5B8agEFJqiqv38wB14j1ke?=
 =?us-ascii?Q?cvmjP07VHKUpmrhmeCM4msKVBkRju4yMWENHK0nRkpa3gLJBLNabvfguN83P?=
 =?us-ascii?Q?Ap9qoi4u56WGf/2e63BrlcQMZ1TMHa8ZFxMBX3nuuUAOSHlU/bkRpmhsbNbK?=
 =?us-ascii?Q?8D4T6bI8mO4/EKhuC1ZwlxPs/AmTXPY1Q/vRr7+bDZNmLdnBOVIN92xqTgkt?=
 =?us-ascii?Q?EhlL6g5+Rk96UpqAFLS72DtOFSlqItI27ddZGMFu39J6xHYDUkLRA0YSCLDQ?=
 =?us-ascii?Q?oaG04Fz4N/SWEH9bachLt3wfV9Jr9g7XlexYZk09UHrkVeQ9UiYZ9RretfnV?=
 =?us-ascii?Q?/w/FDF+h2w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b82cd811-8c91-488f-a0d1-08da4f853013
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:44:28.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5MbuQDZ8uTfaF7UJDseik6sSol5sVl60YnYwjQVk9BSGi6jC822nLjk5RqUAg+MM8IkUP6L4nnP/EQK75Sufg==
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

This tests creates as many RIFs as possible, ideally more than there can be
RIF counters (though that is currently only possible on Spectrum-1). It
then tries to enable L3 HW stats on each of the RIFs. It also contains the
traffic test, which tries to run traffic through a log2 of those counters
and checks that the traffic is shown in the counter values.

Like with tc_flower traffic test, take a log2 subset of rules. The logic
behind picking log2 rules is that then every bit of the instantiated item's
number is exercised. This should catch issues whether they happen at the
high end, low end, or somewhere in between.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/rif_counter_scale.sh    | 107 ++++++++++++++++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  11 +-
 .../net/mlxsw/spectrum-2/rif_counter_scale.sh |   1 +
 .../net/mlxsw/spectrum/resource_scale.sh      |  11 +-
 .../net/mlxsw/spectrum/rif_counter_scale.sh   |  34 ++++++
 5 files changed, 162 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/rif_counter_scale.sh
 create mode 120000 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_counter_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_counter_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rif_counter_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/rif_counter_scale.sh
new file mode 100644
index 000000000000..a43a9926e690
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/rif_counter_scale.sh
@@ -0,0 +1,107 @@
+# SPDX-License-Identifier: GPL-2.0
+
+RIF_COUNTER_NUM_NETIFS=2
+
+rif_counter_addr4()
+{
+	local i=$1; shift
+	local p=$1; shift
+
+	printf 192.0.%d.%d $((i / 64)) $(((4 * i % 256) + p))
+}
+
+rif_counter_addr4pfx()
+{
+	rif_counter_addr4 $@
+	printf /30
+}
+
+rif_counter_h1_create()
+{
+	simple_if_init $h1
+}
+
+rif_counter_h1_destroy()
+{
+	simple_if_fini $h1
+}
+
+rif_counter_h2_create()
+{
+	simple_if_init $h2
+}
+
+rif_counter_h2_destroy()
+{
+	simple_if_fini $h2
+}
+
+rif_counter_setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	h2=${NETIFS[p2]}
+
+	vrf_prepare
+
+	rif_counter_h1_create
+	rif_counter_h2_create
+}
+
+rif_counter_cleanup()
+{
+	local count=$1; shift
+
+	pre_cleanup
+
+	for ((i = 1; i <= count; i++)); do
+		vlan_destroy $h2 $i
+	done
+
+	rif_counter_h2_destroy
+	rif_counter_h1_destroy
+
+	vrf_cleanup
+
+	if [[ -v RIF_COUNTER_BATCH_FILE ]]; then
+		rm -f $RIF_COUNTER_BATCH_FILE
+	fi
+}
+
+
+rif_counter_test()
+{
+	local count=$1; shift
+	local should_fail=$1; shift
+
+	RIF_COUNTER_BATCH_FILE="$(mktemp)"
+
+	for ((i = 1; i <= count; i++)); do
+		vlan_create $h2 $i v$h2 $(rif_counter_addr4pfx $i 2)
+	done
+	for ((i = 1; i <= count; i++)); do
+		cat >> $RIF_COUNTER_BATCH_FILE <<-EOF
+			stats set dev $h2.$i l3_stats on
+		EOF
+	done
+
+	ip -b $RIF_COUNTER_BATCH_FILE
+	check_err_fail $should_fail $? "RIF counter enablement"
+}
+
+rif_counter_traffic_test()
+{
+	local count=$1; shift
+	local i;
+
+	for ((i = count; i > 0; i /= 2)); do
+		$MZ $h1 -Q $i -c 1 -d 20msec -p 100 -a own -b $(mac_get $h2) \
+		    -A $(rif_counter_addr4 $i 1) \
+		    -B $(rif_counter_addr4 $i 2) \
+		    -q -t udp sp=54321,dp=12345
+	done
+	for ((i = count; i > 0; i /= 2)); do
+		busywait "$TC_HIT_TIMEOUT" until_counter_is "== 1" \
+			 hw_stats_get l3_stats $h2.$i rx packets > /dev/null
+		check_err $? "Traffic not seen at RIF $h2.$i"
+	done
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 1a7a472edfd0..688338bbeb97 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -25,7 +25,16 @@ cleanup()
 
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre tc_police port rif_mac_profile"
+ALL_TESTS="
+	router
+	tc_flower
+	mirror_gre
+	tc_police
+	port
+	rif_mac_profile
+	rif_counter
+"
+
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	RET_FIN=0
 	source ${current_test}_scale.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_counter_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_counter_scale.sh
new file mode 120000
index 000000000000..1f5752e8ffc0
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_counter_scale.sh
@@ -0,0 +1 @@
+../spectrum/rif_counter_scale.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 70c9da8fe303..95d9f710a630 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -22,7 +22,16 @@ cleanup()
 devlink_sp_read_kvd_defaults
 trap cleanup EXIT
 
-ALL_TESTS="router tc_flower mirror_gre tc_police port rif_mac_profile"
+ALL_TESTS="
+	router
+	tc_flower
+	mirror_gre
+	tc_police
+	port
+	rif_mac_profile
+	rif_counter
+"
+
 for current_test in ${TESTS:-$ALL_TESTS}; do
 	RET_FIN=0
 	source ${current_test}_scale.sh
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_counter_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_counter_scale.sh
new file mode 100644
index 000000000000..d44536276e8a
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_counter_scale.sh
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../rif_counter_scale.sh
+
+rif_counter_get_target()
+{
+	local should_fail=$1; shift
+	local max_cnts
+	local max_rifs
+	local target
+
+	max_rifs=$(devlink_resource_size_get rifs)
+	max_cnts=$(devlink_resource_size_get counters rif)
+
+	# Remove already allocated RIFs.
+	((max_rifs -= $(devlink_resource_occ_get rifs)))
+
+	# 10 KVD slots per counter, ingress+egress counters per RIF
+	((max_cnts /= 20))
+
+	# Pointless to run the overflow test if we don't have enough RIFs to
+	# host all the counters.
+	if ((max_cnts > max_rifs && should_fail)); then
+		echo 0
+		return
+	fi
+
+	target=$((max_rifs < max_cnts ? max_rifs : max_cnts))
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
-- 
2.36.1

