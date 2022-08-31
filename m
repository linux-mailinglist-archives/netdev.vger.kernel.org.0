Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04D85A7436
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiHaC72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiHaC70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:59:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8376BB56FB;
        Tue, 30 Aug 2022 19:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGy3lV3rynmqJ5Vu3B9stw2PqSIdwek821mAtgvDwCnGYkgvV0Vl5T9C86YnPqotfeuX/E3wf5LGlc5GyXpa+t7kAXgy00+smaBO9J93hQVVW6wflnWoaDFVTVWXnhbEyFsuUl8bdZsLNk4pE1UKZvBduLQHgbM+uTygJVpFmDbcLfclulJSy5ZoEbIPauCuUUTMZydwf6GxOym2FAmVjWZk7ugw20dJ0iGMfsXNFSQR9dKI9QIZhhLdqExZqDwh19WNAoYwKhYUXxk82d31b5ERBaCv3fDR2mZ3Wor/2g3QfZNtipLP+k5Ik66NppkqpL3vlQV+FV8yAbZTxhmkog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S4rrlL0je31tPSEyRiWpmXzm6AyMdVez0qD29O4WVeQ=;
 b=c/fRDh7KrjU2XsvFwSeQRDsWXG0S4w4FfBtXibobwnSzVVuyFmcVfig8AcM1fuPtk8Hy+F956eqs9wy8uKNAAyf6Z+mnKQD3/7WExlATZBP1+QXW/H12Wo7MHFti/FAYAnPVY9hlZrrsQUVbJehN4XbFWrkO8zc5ogEtpZBqBAbQg9INaXZDrvxXD+mrkEMHXpXSZ8a9NaIu9wVRE3NDml6zuLBwsGCDjiNs0SQASDnvt3ArZ8jdusDe5q0wKZVrPOkITnYMZtpQovKPYI7tmP6v2GFU/BS5jlmS8bonXxvItYE3VyrrjPhl+D4ymjxwLdrtnTbsHHg5XcQjUtJeLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4rrlL0je31tPSEyRiWpmXzm6AyMdVez0qD29O4WVeQ=;
 b=L3Tb2b+mf3kbThzSRW3aZed/ORV6QtM9d7702QakE7j4k9KAgNOx0NLaJW5RyEhiRqL6jgh0IrPyP05U4XcAZth2Thc0nVxABxmAt36CBUhAKqGqCELFxxF+TDwZf5vuG6x9eoqW4jP9Y7T/JafHS2jL/WXpt0HumzvSJpFK/Jppj1Am0LycT2gNvv8XuM5+/jE2ZESXs7nE0FJiCL3cslPg8PTwbPemePPzLwC96TuFn/4Vhjp3/c80K+s23kqZ1YzDUurG6t+VsMWMjI9F5VqvCKXHIS+DObnDpTms60ULDQw0M0QGhN6zvyjCsX4CRfsz4kfa94kOKMNmy/BT5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 02:59:20 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 02:59:20 +0000
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
        Benjamin Poirier <bpoirier@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 3/3] net: Add tests for bonding and team address list management
Date:   Wed, 31 Aug 2022 11:58:36 +0900
Message-Id: <20220831025836.207070-4-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220831025836.207070-1-bpoirier@nvidia.com>
References: <20220831025836.207070-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0004.jpnprd01.prod.outlook.com (2603:1096:405::16)
 To MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1728689f-83f1-438a-3dab-08da8afccd3e
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CJlMLzn8COIf23tjqI+NVMfIPCp0jBMhSD+FEDXrrCVpDVMHuQ5DMs0hu4ebqVsiotq2O2e1yXN+DjDvE41JSQKTDqBIi7pg3phuhk23dH3HRBwn+nW1B2tosX6m0kqTNFla0TpFmyVvKJ27sJERxQAGSMiNB7Y/g2YQSLs2A0ySvijPIHOKUdKDpbVxjQT6HI3olvx/g9lLekUSYNArZrdq0RMfG1qUWxze6S0pGL1mfgraqWClUtYWkv4I/kT9dTxTecgXw3EyWaG9u43QjGkidLzMWVevLh2GnsJaT2jxhdOeSfymUJGqJSdiUzAVlbae1FN15dG+K95RaLPLpif7Uf0cv3p2U8lNqzP/sIm45EgMyspo27+sxwiDLR6ozLFOQcsv9R2Lj7XLhmXOJ+KwgG2BGlfJ6rX06YtrNan/figho9pk3klyNj0I9WfK97Pp7q7fq4oPVCiqNGBN2i6LzplNeFrxrTMaY0AUyIuX6zRQwJd49Y0lZ5lQO3sGIvvPa9cu6uFbPSJVQ1Ubh8uK60yRDl+cAdVCQn9XS5DwgA6Co5EpRunJBDnHnB5opphkHuCGtoQsmuecNuYJBSBY5LS7/SxUQ7+y3BC0xpX92PN4kEnnqM/uJ0/6hJwFfNMYqBc9lajyLTrcb0oga44x1b5C+gk9SXk5cAMgABpOjsaZRmyAfhhg1DAzrT5A8BTSJy2pj+VjXcxl/k12uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(186003)(38100700002)(2616005)(1076003)(26005)(2906002)(6512007)(6506007)(86362001)(83380400001)(66476007)(66946007)(66556008)(316002)(6486002)(8676002)(478600001)(4326008)(6916009)(54906003)(8936002)(6666004)(36756003)(7416002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ajul7r5hrq0rI/TKkdx2ngM0GStN7Lgdj/CQYYDTMdO7gfIXYh+Sa78jfXTE?=
 =?us-ascii?Q?ZFJFlgxU8qCw65pL0XCj64Ak/IJyow9jgOZDHcPR8gW34kS4uMjNz6yZHkH1?=
 =?us-ascii?Q?8P2EuB9bQqO1AUn8PwQGQ69QtQNJAzEJyppJrE6tyTvLnP1DJlEWpFoIgbTW?=
 =?us-ascii?Q?vpupZOqnVrE0FaK4sHdpDI2nCwj9FWdg3FaUoUPCCneHhBdq7w93ISu+3e6/?=
 =?us-ascii?Q?gn8OLttTbEEAKym/KB616emGpwiZRSigMwCiNsmkOuZGaRk3W+fTKB3WlX0S?=
 =?us-ascii?Q?HvgIpwe6wdKVKE0SIJ093nTxdpZqbWhyN/4SlyNYBqDS4zvu3lQEvnULKEjN?=
 =?us-ascii?Q?eRms0Xyxe4UuCA1dnk+D2b8HidSdPjkNkgioECoD/+UKdH5X/NNhnZifYEry?=
 =?us-ascii?Q?dOJX/b9SCJJlo0EhaJLlJ1m4f+hrg/FzdPeIQfrlPqPi4EI1j7dV2pTxLhp/?=
 =?us-ascii?Q?F+cNbnRrOJ6UNDjg8liPKWAgnlqFFTnyxtayrjdx7p15+d/AJk2gMaFybFEl?=
 =?us-ascii?Q?d1dxH50I/LyJ1SEwlQgmKlkcZFEtO5WXNqGf7Lni9WnZz0J6zSjV39/d2Yl3?=
 =?us-ascii?Q?7YnBgt6BmxxLCyEsklqqRBbRy4WMbtOxQ1FLQA/MdSp3Lcq06Fif5WZphGVa?=
 =?us-ascii?Q?JBQa2zmCCRJx/a2fATeOTEu0Wi9OnREWDZGltaoNg5hJSNwlvJXJeoDCptTE?=
 =?us-ascii?Q?Vu7O8eth7+e8/KYufL3GbFvi4dU0hkbfDnUYD2oDNDYd8PPRIQ6OwLqUWJhE?=
 =?us-ascii?Q?YCBFRNlsldWIkGmOzbEx8psHYtm/29UAO3x0fbglnuAUOXbT8WbHHsKpK2ho?=
 =?us-ascii?Q?BrMplP6n4dITpyVmML1qXqFY0MQ3FClxjysRThxVApzD3E/97b/fIkD7kGvB?=
 =?us-ascii?Q?vBOmUSenj/vG3lGwYfbN8DZA1iwl5GfamJr0i1Qt3H4qYJOzY6Zhbro/cJJe?=
 =?us-ascii?Q?7T2gVxb2TV02zYKi9Pihc/fm3Mw/4EnyI8/I3mHr/DUFnaIF8762MYKyfb4U?=
 =?us-ascii?Q?sYC+n1qvxV9HOQr0YrnmYj3x094ns1PPU9pd4gY9y4Xh6uTYImvjUYPAf/Nu?=
 =?us-ascii?Q?fqjdNLWzobYwY4izexjr+8zjzcnnt55STA7LWMw8XoUvznjGEbE8RQ5mKtnJ?=
 =?us-ascii?Q?zJ+WnQ5F1F4BqClgoyWd+zYtHlumh7iSyHg+mSpnQ9BOZ9mQolTO2nji9Q7P?=
 =?us-ascii?Q?0N0YXuofGZldNPQI396gMuzc5dQWGIrkqEOaQys1x7BwqfmuSdu1G+u7vhVV?=
 =?us-ascii?Q?jet1dyXi9qMZHxuHTSzCVogNEHcpX7bABMmv96eY9Z37O4PtxibVsuopRFva?=
 =?us-ascii?Q?cfKYFDrQ2P+QP9MpxTtRaQXpOjHADmFrbtaIPjhoMf+ArVHlr+YuQOaF+cHy?=
 =?us-ascii?Q?Jt6DBHB2CilY1AKtmi0PsVCvzjKVXnrgZ20IdwmArPpRhy0F3f0UUHFIivI2?=
 =?us-ascii?Q?COiERRz11uMRQfVfW1phm/3pWbVH3s/vlrdFFc1o2exuN5deMzJgMB11T7vW?=
 =?us-ascii?Q?0eB2fe4Sp2S9BgpaCFrbJ0Ktg/6qpLjvKs9/uA/QFYPPxKXFKbjj1fhGrdKY?=
 =?us-ascii?Q?UHi29u2zHZoycJYmWyYt+Ggf255XpTAq+nAh0mHU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1728689f-83f1-438a-3dab-08da8afccd3e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 02:59:20.7395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzrcWkWEyy27BH5SPUSXpZEUz7OCQjGqUJfNwW1D/U29/yEM3q2MS/7IYGOn55ivkIFBBXHVt0w87bo5hy4eqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
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

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 MAINTAINERS                                   |  1 +
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../selftests/drivers/net/bonding/config      |  1 +
 .../drivers/net/bonding/dev_addr_lists.sh     | 89 +++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh  | 63 +++++++++++++
 .../selftests/drivers/net/team/Makefile       |  6 ++
 .../testing/selftests/drivers/net/team/config |  3 +
 .../drivers/net/team/dev_addr_lists.sh        | 51 +++++++++++
 9 files changed, 217 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/team/config
 create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index af4848466a08..a672a649ddc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19935,6 +19935,7 @@ S:	Supported
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
index ab6c54b12098..bb7fe56f3801 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for net selftests
 
-TEST_PROGS := bond-break-lacpdu-tx.sh
+TEST_PROGS := bond-break-lacpdu-tx.sh \
+	      dev_addr_lists.sh
 
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
2.36.1

