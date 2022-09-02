Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8485AA53B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 03:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiIBBqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 21:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiIBBqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 21:46:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F5E52836;
        Thu,  1 Sep 2022 18:46:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjM2xa9SZZASavsNUIdMDTKoV6TJFFxsXMRwnERDyq+c1oMjbMhQs2dB79m/hQN96FabDnTVuWje3m2bEN36yOW7/MlvT5GF7Jp7gsM0scJUCe4YuJTsZd8eJINC5gExUM+/kAWlpLkQKpNIqITtoQl61e9B705/rzkoHGbj5dE40GmYvBLbHcFbxqBKQcpr/NUzYLGNeFt0QhHFumhbryuAxQz/mi7EXWXW81UNx8brdzZLoU9NontGhH6dSg7BGXuRAAuPwRkzBmmatqCNa5D33sg9CGFvSH2TGo+8GEZ7jEan/kthbcrhL2lcL16qfjVbrxRf37KYkxQiEB1trA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTqQ9IldZBmOjxAWJDSVhg7YAZi0DO0DgbP3ZO5o9es=;
 b=Y9oRo0VD+gX/Dnv+IDbZXXlbkjXTfCcEmZ69nxQ98UKV/QPTiDne+XO39Px7XKg49OuioJD8cS90fvnX4Gsc1LwCRUbFuYotnRealtJI4EQHjeKWhOibFUzRLSer22gxU+JJL5cen17ZpyBioOkBRBXWqM35ESKOuA7rGS7DhU8ZnsgD9Iaw0FKUMJhSDz5v1dLosK+lBeOnOZFu+03s3ZRmzFbvmbrcZU8vQDKy1NsEbqv7dkOmsHE08vmlPQkncIk9YGFC4BS1wIhFCM3QH/qNyMaXMsDQF8+ll5oygwRRyBjisc0PNJ+n4xfHxEOx3xBJqy7op27buMcBYgFx+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTqQ9IldZBmOjxAWJDSVhg7YAZi0DO0DgbP3ZO5o9es=;
 b=Bv9fQgvFd9PNvbuqDR5AipSCv9rCuxNgg7HIlzn/ZOWby/LR9jGkatEo8t92tlKSuRCX7r2EuLkHBJJykQM6EAikUBsMg5OAsBJyuw2WIYvlfH5OaxLupTQzkd7MVlMEOJaCjJMPqPPmPsP4WZK4L64jCh0vauy5Xr1aDCp7wuPPWQDJ/nYG9fyQmbdkGZJPSJKpTD84tNSlw6LIKkQ9UpCE8ln+dIG++m4pITfzTZs3uTMAYnOIN7/vywVfbtRDMLgQXbLbxurKWZ5f4ur1zIkQwsqY2DkXyWQERRtWw064jMQ8BiL9MTwRb21YSdEweJtUjcmWV+huw//E+HC2jA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA1PR12MB6728.namprd12.prod.outlook.com (2603:10b6:806:257::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Fri, 2 Sep
 2022 01:46:12 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 01:46:12 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 3/3] net: Add tests for bonding and team address list management
Date:   Fri,  2 Sep 2022 10:45:16 +0900
Message-Id: <20220902014516.184930-4-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220902014516.184930-1-bpoirier@nvidia.com>
References: <20220902014516.184930-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0225.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::21) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29ba24d6-97ac-4de3-9c87-08da8c84ea66
X-MS-TrafficTypeDiagnostic: SA1PR12MB6728:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaCpj0qPVzdfB5QqXqm397HD5d6pYcPOGXLgowQOftUkQSp3AbxmobYHg8JtfoRbuJClPXYzZKew9QJxBNRPpYteobsjjnaIdCH2q0GuszXOtXRiONvSxPaOULp0Q0n+tV3/viSaOkODpX26qllkeajk3b8Qu2JFBFvtouq1X9c63YaGvleq4xT40JIruY8Zjr/MM+n/3DnzdUmd2NYw5gC8xLFsuSevh6dmZDQCl5dj9pI5TYmh7dbnONshHikrK/jlE0AjEeK1kfdoLBCgHt/yfqTq2A3o1u+1iCUoFQKCWQBrApi9bwDfZY0J7F9EUh7K2nupEnaZohMqOCJOxfuTYVwUJ+m/BUpfmwH3BXmASfPqndAGkUVStF0hHN3nXLajl79n5YXaIDljV1KW3pjU3FXQrjaRSfvMFDTDnRmGm/yY+MjvoUruY1TekYSXsLgwXYzROd/+PprQiwXfRkEI0simI/OjjZ1HNr8hRN5zGjOKRyaswj7oFSNjWX6RJ+fRTwU65DCe4SFAV2Uau9X4Jyla3Lhl9LUoQcNnNHDHEbMO12elQCpZDvzBSC38fOjNKah1MbSSTAi9w8xv7Uwm7uM7iG3/oO9q6+SKEJ0/cCoKXSKkHQWgxI8ZdpVBf4RZXKwn3S5j2O5h9bWNV/SkKv+fwVLbWkkCMlEN1/+ZIAo4+LEFf6Nkjf6ci/iv1IXINHi6EWxL3azUItJWkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(8936002)(5660300002)(6916009)(66946007)(66556008)(66476007)(8676002)(2906002)(36756003)(4326008)(316002)(54906003)(478600001)(7416002)(6486002)(41300700001)(83380400001)(26005)(6512007)(86362001)(6506007)(2616005)(186003)(1076003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jVEOEN3aqRZQywfalVwE0Q8/TVmMqM3MS07eSm2CjC6S/dzZnoIK4LS+apo8?=
 =?us-ascii?Q?vxHGSiNMTZs9fSDoE516kW0jR37CPpGqS4VGZf/Yor84twjzDUeA7yoYKMgn?=
 =?us-ascii?Q?qraNP4E+Pxhyy40SnXwwAd56h+ZcQGxmIpfJ77jEZBs62dCretb8ewMsi2Uq?=
 =?us-ascii?Q?J0kpdCZRvMuj7SNN2wMrt+v2H4KsL4j+rrxetLsxhr6MY5Ib/F5ITHt+xToP?=
 =?us-ascii?Q?5f+LEmj0ZEzRIetJVP8ApR24nykIu0Q9O16IasMqm61Qp3M3GqvvBNo2eyBv?=
 =?us-ascii?Q?SakGTVfmUvngosWvBNbOZb0n2vTkowDAi3L+pC+FaQNI/gWID/iNy3yYUS3S?=
 =?us-ascii?Q?wAyvD51eTE37Pz7RSllUuxKxMrVQwHBgh7loCP3kpKoFR/XEk3YoEb+jrD1N?=
 =?us-ascii?Q?29VJ4djw1wMSWziSzAyE86CjfcKGk1P9mGRuwEOBvT3c+fKf0azOpulp9pAa?=
 =?us-ascii?Q?Uca6n8Psf8zIE7EpyYw+1AJJz+64fe/STWGhmPEGVqHDI//lxN1+MEg6EEf3?=
 =?us-ascii?Q?3b10cB/HZfUVks2C3CA9KCjdo3ezhzAzBFdnPIaQ5BEJH5INEL/zVBzVVAU2?=
 =?us-ascii?Q?oCkkOKekrQKPnd83cTaXzo84xnab8uF1HoyqhhHh//vfZPMUFSv3jtChcegK?=
 =?us-ascii?Q?VjOml4J8C8V7FAqZtTX8ECeAhXq3kIDjPvPNVht+6I4sjDPJU7jA/EL+51wQ?=
 =?us-ascii?Q?AYk2vNYmw7M00f1+uXMGsbkMlrNIx2/N4uFBoIFJMN8uIuNnV4ZGYSeu7ox9?=
 =?us-ascii?Q?zVLsm+Gn0pf9NGIvXJJ3URaiRGLaBquGsHVqODiELdDOTTI4qEapcyTvN5lW?=
 =?us-ascii?Q?ys1IbmJpVRx3GoPR9L/8+NLznJmb6gdUiwpMvPXD+llc7JsoCyKZ96w1j8sv?=
 =?us-ascii?Q?qftmrKg/7zKXlFODnyulsup7P6s5NcHCLmsjmCg+WX//ccaJ/akCGYuZwDMu?=
 =?us-ascii?Q?bsiccQofPpkNXBFfv7AKOTU/CiFhr7aye1yxkag/RXtKHAijPFh3l6nnRUjP?=
 =?us-ascii?Q?T4PMfyRZcOzaaadLr4a3K3r23fsx+vYCu0gywTY/SJNr9ZV3qG7HbkMwtlYw?=
 =?us-ascii?Q?KVlc4IQh8WUSMVOTkRDya7HQW7loKhZv0GcRtrzEaVinSR/OWxzH9Atz9Tvp?=
 =?us-ascii?Q?TSce4cBpbjBnKJU3rtQvKXbSRTBll47WSyQdQZx41aU28N5MNpAN6ahEkHi4?=
 =?us-ascii?Q?l/Ly68kO5g9p0w8CJ3cWZz5xuiom7/VqJufTU0z4Y82yvzWtdXWRcDzsLBIH?=
 =?us-ascii?Q?34EUJ9fFSx1jNUNk8ynmYI0Fm1fAv5DxYL2TtqXbpLoGsefGW2zGGGzDGFyE?=
 =?us-ascii?Q?ezTARPUXQ0up9oZY/QJcjRn1X276HTszHxE2wgZGd9eaQ2CwdF0cI9JjZUfH?=
 =?us-ascii?Q?/c1xKy1no54UVwG2CGqSqZ2WVCvkkhEAmd9Dj2TMTZ6y5Wcj4TfzNFSgHWq3?=
 =?us-ascii?Q?uYjbZpdMVtvGuRBfMy9syayMAaL7JkYzU5N+diFvzQT9957GKEHUQcmuFYLY?=
 =?us-ascii?Q?ckkY9HCZem3/awDsRR19DN6SOyuujZ4TRdQFxo8lNUQ3rTXaZd2q+p/5/58m?=
 =?us-ascii?Q?XHcppSwfodnv2pRPBZS8MP+TV1Rosujcpryxm4su?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ba24d6-97ac-4de3-9c87-08da8c84ea66
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 01:46:12.5479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUjQBuY7Rwr+FvLDqXEtaMWSs9VTv+AHTDouvw42xojUlbAjJL5OEzgqBiXohy63JY6fHDbslvuzUCe1DPvTwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6728
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that the bonding and team drivers clean up an underlying device's
address lists (dev->uc, dev->mc) when the aggregated device is deleted.

Test addition and removal of the LACPDU multicast address on underlying
devices by the bonding driver.

v2:
* add lag_lib.sh to TEST_FILES

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 MAINTAINERS                                   |  1 +
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  5 +-
 .../selftests/drivers/net/bonding/config      |  1 +
 .../drivers/net/bonding/dev_addr_lists.sh     | 89 +++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh  | 63 +++++++++++++
 .../selftests/drivers/net/team/Makefile       |  6 ++
 .../testing/selftests/drivers/net/team/config |  3 +
 .../drivers/net/team/dev_addr_lists.sh        | 51 +++++++++++
 9 files changed, 219 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/team/config
 create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 589517372408..4194f44e7bb9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19937,6 +19937,7 @@ S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
 F:	include/uapi/linux/if_team.h
+F:	tools/testing/selftests/net/team/
 
 TECHNOLOGIC SYSTEMS TS-5500 PLATFORM SUPPORT
 M:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c2064a35688b..1fc89b8ef433 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -13,6 +13,7 @@ TARGETS += damon
 TARGETS += drivers/dma-buf
 TARGETS += drivers/s390x/uvdevice
 TARGETS += drivers/net/bonding
+TARGETS += drivers/net/team
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += filesystems
diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index ab6c54b12098..0f9659407969 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -1,6 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for net selftests
 
-TEST_PROGS := bond-break-lacpdu-tx.sh
+TEST_PROGS := bond-break-lacpdu-tx.sh \
+	      dev_addr_lists.sh
+
+TEST_FILES := lag_lib.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/config b/tools/testing/selftests/drivers/net/bonding/config
index dc1c22de3c92..70638fa50b2c 100644
--- a/tools/testing/selftests/drivers/net/bonding/config
+++ b/tools/testing/selftests/drivers/net/bonding/config
@@ -1 +1,2 @@
 CONFIG_BONDING=y
+CONFIG_MACVLAN=y
diff --git a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
new file mode 100755
index 000000000000..47ad6f22c15b
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
@@ -0,0 +1,89 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test bond device handling of addr lists (dev->uc, mc)
+#
+
+ALL_TESTS="
+	bond_cleanup_mode1
+	bond_cleanup_mode4
+	bond_listen_lacpdu_multicast
+"
+
+REQUIRE_MZ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/../../../net/forwarding/lib.sh
+
+source "$lib_dir"/lag_lib.sh
+
+
+destroy()
+{
+	local ifnames=(dummy1 dummy2 bond1 mv0)
+	local ifname
+
+	for ifname in "${ifnames[@]}"; do
+		ip link del "$ifname" &>/dev/null
+	done
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	destroy
+}
+
+
+# bond driver control paths vary between modes that have a primary slave
+# (bond_uses_primary()) and others. Test both kinds of modes.
+
+bond_cleanup_mode1()
+{
+	RET=0
+
+	test_LAG_cleanup "bonding" "active-backup"
+}
+
+bond_cleanup_mode4() {
+	RET=0
+
+	test_LAG_cleanup "bonding" "802.3ad"
+}
+
+bond_listen_lacpdu_multicast()
+{
+	RET=0
+
+	local lacpdu_mc="01:80:c2:00:00:02"
+
+	ip link add dummy1 type dummy
+	ip link add bond1 up type bond mode 802.3ad
+	ip link set dev dummy1 master bond1
+	ip link set dev dummy1 up
+
+	grep_bridge_fdb "$lacpdu_mc" bridge fdb show brport dummy1 >/dev/null
+	check_err $? "LACPDU multicast address not present on slave (1)"
+
+	ip link set dev bond1 down
+
+	not grep_bridge_fdb "$lacpdu_mc" bridge fdb show brport dummy1 >/dev/null
+	check_err $? "LACPDU multicast address still present on slave"
+
+	ip link set dev bond1 up
+
+	grep_bridge_fdb "$lacpdu_mc" bridge fdb show brport dummy1 >/dev/null
+	check_err $? "LACPDU multicast address not present on slave (2)"
+
+	cleanup
+
+	log_test "Bond adds LACPDU multicast address to slave"
+}
+
+
+trap cleanup EXIT
+
+tests_run
+
+exit "$EXIT_STATUS"
diff --git a/tools/testing/selftests/drivers/net/bonding/lag_lib.sh b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
new file mode 100644
index 000000000000..51458f1da035
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
@@ -0,0 +1,63 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test that a link aggregation device (bonding, team) removes the hardware
+# addresses that it adds on its underlying devices.
+test_LAG_cleanup()
+{
+	local driver="$1"
+	local mode="$2"
+	local ucaddr="02:00:00:12:34:56"
+	local addr6="fe80::78:9abc/64"
+	local mcaddr="33:33:ff:78:9a:bc"
+	local name
+
+	ip link add dummy1 type dummy
+	ip link add dummy2 type dummy
+	if [ "$driver" = "bonding" ]; then
+		name="bond1"
+		ip link add "$name" up type bond mode "$mode"
+		ip link set dev dummy1 master "$name"
+		ip link set dev dummy2 master "$name"
+	elif [ "$driver" = "team" ]; then
+		name="team0"
+		teamd -d -c '
+			{
+				"device": "'"$name"'",
+				"runner": {
+					"name": "'"$mode"'"
+				},
+				"ports": {
+					"dummy1":
+						{},
+					"dummy2":
+						{}
+				}
+			}
+		'
+		ip link set dev "$name" up
+	else
+		check_err 1
+		log_test test_LAG_cleanup ": unknown driver \"$driver\""
+		return
+	fi
+
+	ip link set dev dummy1 up
+	ip link set dev dummy2 up
+	# Used to test dev->uc handling
+	ip link add mv0 link "$name" up address "$ucaddr" type macvlan
+	# Used to test dev->mc handling
+	ip address add "$addr6" dev "$name"
+	ip link set dev "$name" down
+	ip link del "$name"
+
+	not grep_bridge_fdb "$ucaddr" bridge fdb show >/dev/null
+	check_err $? "macvlan unicast address still present on a slave"
+
+	not grep_bridge_fdb "$mcaddr" bridge fdb show >/dev/null
+	check_err $? "IPv6 solicited-node multicast mac address still present on a slave"
+
+	cleanup
+
+	log_test "$driver cleanup mode $mode"
+}
diff --git a/tools/testing/selftests/drivers/net/team/Makefile b/tools/testing/selftests/drivers/net/team/Makefile
new file mode 100644
index 000000000000..642d8df1c137
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for net selftests
+
+TEST_PROGS := dev_addr_lists.sh
+
+include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/team/config b/tools/testing/selftests/drivers/net/team/config
new file mode 100644
index 000000000000..265b6882cc21
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/config
@@ -0,0 +1,3 @@
+CONFIG_NET_TEAM=y
+CONFIG_NET_TEAM_MODE_LOADBALANCE=y
+CONFIG_MACVLAN=y
diff --git a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
new file mode 100755
index 000000000000..debda7262956
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test team device handling of addr lists (dev->uc, mc)
+#
+
+ALL_TESTS="
+	team_cleanup
+"
+
+REQUIRE_MZ=no
+NUM_NETIFS=0
+lib_dir=$(dirname "$0")
+source "$lib_dir"/../../../net/forwarding/lib.sh
+
+source "$lib_dir"/../bonding/lag_lib.sh
+
+
+destroy()
+{
+	local ifnames=(dummy0 dummy1 team0 mv0)
+	local ifname
+
+	for ifname in "${ifnames[@]}"; do
+		ip link del "$ifname" &>/dev/null
+	done
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	destroy
+}
+
+
+team_cleanup()
+{
+	RET=0
+
+	test_LAG_cleanup "team" "lacp"
+}
+
+
+require_command teamd
+
+trap cleanup EXIT
+
+tests_run
+
+exit "$EXIT_STATUS"
-- 
2.37.2

