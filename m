Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655DD5AFE59
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiIGIBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiIGIA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:00:56 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20602.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A4C6265;
        Wed,  7 Sep 2022 01:00:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xy5lg5G8Dnb46XMH/QAZr6fgVGpL9/xsn782mfNs+pRIse5MNyrcINf+REIGVKZ6EqSRWMiFa9jAGiH/wsjET8w5rl1CIuI3rF/SSLV7XvXRYvmkuAHZMDD6RiKI/5PCvk/asg9INu26Fn3RptIEGh3SkHDwAiOXw/Cw1auhH2Mkj/xAhZlxqM7mYk5eEBIaYi/Vmk7sqCJwsbBlSFL8Pvjqd1uMRIewOMYo7Mg+EYbc1bfDVy3JDmR0jLX+czYPgi080/nMjRxupIOz76qJZAnAno2fuVOY8WBT4ldkzIwjL18jV5CgEHenYQuuJH923BQOfgtKHJmdg9Yusl/wQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1B6ud6q1XCCrN6bz9awYFuF47bAx3Jw5c5XtEjQSFo=;
 b=WBUEF0Tfha3eI6KtH4DccV/DnGaIyNUhcWfrIxUit6laHFjIVDSk9ye/z/kXjgyClnyYapb/FO4NoTspapJV5QZrdDZLin/eCV0d/hs4pCHSZiuTrruGxcv0VUIfb7VT0LAuXWxmlTro4qip6bShttq1gz7+/2RWee7KiV5Yg5m+YQ3v7LOq0t0ZKLB+ad9XT4OFMYNApIR1alqNxxZbVApzMRkGRia7Y5FjolQKVx6aHKKOa0BsuM3HpB2dEBd0kYMUMe0I3bPcCtBJbDobH0zvr7RAUv0O0hrAJiAkormPqmsOshHKL5i3kRVGkBXROIcOffTDijH6iCXNwy+ZNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1B6ud6q1XCCrN6bz9awYFuF47bAx3Jw5c5XtEjQSFo=;
 b=Ug4HHtN1RsSwaO0al7cAoZDCJX86CowAaSaeJHU7aaJFEgBnGPkfKPpcQsiwf+hSDfVy+7NgwJoE5xbd13imMlEDX58Fmqv1YMf/FYEEGSiUQVFjrOjD/DSONIElPq+sV0CLa9jlGHsKSo9ValXwk21ZakicW/KQKtrkcTTgL4SNpm8fxw+DaLYDUA9nizgaJM+5jHRV4yRlZG+JOAYU2oWKaMsNWQp3zDJCnOc7J08Dos212tSI1ovhuWJfdikFkaiCdSzgoDVimyOQbON/an/9Xe1b+zHoKCrkwGVKG7kVyUBMSx8owyhIvFWM+bDcDyKI1LuXWWhvNhvRX7CAiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 08:00:50 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 08:00:50 +0000
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
Subject: [PATCH net v3 4/4] net: Add tests for bonding and team address list management
Date:   Wed,  7 Sep 2022 16:56:42 +0900
Message-Id: <20220907075642.475236-5-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907075642.475236-1-bpoirier@nvidia.com>
References: <20220907075642.475236-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:404:f6::23) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b21960d4-2bd3-4207-3d1f-08da90a71480
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tUdnB+40/PSO2ngED+8B19IomqfbWpmxpNN4Ymd8hiUBEfS8ANwa00HAaLADmqPuiEWFTJXkvt4hYtgMhJBFQ+aHdBwNdQc2iMVD1LikCVZCknZyxS9N+JJS4sUhQH3ZFAf4cUx/Fn2g6+JIq1EFUcoeyLNyPCcBaf/OUA6X/x5VcgWWSIK22QlEXe7xgaFoY7pnw/VDHucIh6kRxYCw79ShCPOUPkaQQyaDhyEzWiLgMgzDsbdNNvykZaLJeJqb4pj8TXR1Mh5FlOGQSA4YDKRhhXIDcvcnsmZHTvxrw05EVOuXGE9ujqVqTy1JOqtItoifJmbf0BpTEUYxdUlf/hd00s2fq343fJ7E8O4sjgbwdny6mxLKIFRs6G/skDuE7Igvslvqf0yJr2K0p6mYt27VsNahk9ogxrifwf7c+1FZgZw41Psx6OMuiP6MPQHC5KkpmdPkP9QkmrPUBnQ8bM+UBL36UBBO7j3k+WoJx7vO6ghl9dJkCXDuSaYUBaWKyZBpzXQKyel1v/i+ikp7XucR+Cp1qIUHSDiz62hK5urn5jaNdblFs0x14mVJh4Fn4kHzOhwfHAp+mRnog3FH0FBZzlVnkittVPn3q0WEcPiLM+jsXdnX/B2eucYoyRw9ZgOuJuKRanyRjAiHCKEgGhx1qvi4YnM+txtSVwJMu6b1FqTDTUz784l4BI3TQm41pYb5tCIeNr5nqyUEHmq+tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(2906002)(5660300002)(7416002)(38100700002)(6486002)(8936002)(478600001)(6506007)(6666004)(41300700001)(316002)(6916009)(54906003)(4326008)(66556008)(83380400001)(66946007)(66476007)(8676002)(1076003)(26005)(6512007)(186003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dj0yiack/GTax/dD/pndzc1a2RGXWeT2DHD6RA3RF810NFudCUH6hFe49Ums?=
 =?us-ascii?Q?XevgylthOvR4JqA9ZN7JJZTftz414z3/ovhF4FkyHideC9gb+FjBAh0Gk8NR?=
 =?us-ascii?Q?e88b0hEfnynl4U+TOhg/JZbL4WdT4hyn5ihsz4KA40IMUPj67fkMDes1JGyF?=
 =?us-ascii?Q?0K2q8P+oYUGZlHtluF8YToypYCfY0d+Nm5DvLjjlyju3LvUPmdXOHPimEg0I?=
 =?us-ascii?Q?cOeo6RL/97nXLGWJIy9wU6V6MuhRFWh741ZWVJkTx3vLr56JMmbUpJnT+JCT?=
 =?us-ascii?Q?ANYxXcVTulo71IZehTXOnPBV3oAvSk49zHl4d2dBWw7+EzjbPDyeO4UYvt9m?=
 =?us-ascii?Q?quDUpCB3NwLn4W61r1wuwBvSsK/nPWXCMjsmZe3Nuhavdf6bn/ypKkBW3ZN7?=
 =?us-ascii?Q?xDrALzFI98ZxtOZlWmwLfNnW3XzkKsECZT91nn0t27ka26JPwgSYcr9VXysn?=
 =?us-ascii?Q?8qsCxuxB1Xvzwn3so1nHRek2WhrEoV1/FPVQbBMrLT16kPHXkdSM/mC4MijK?=
 =?us-ascii?Q?KEmCCc77wGnd0JNqL9gjEE71u6878kOUE7bQCuC2pt+BoVxFK7fVkH60UwTW?=
 =?us-ascii?Q?YP183DPQc1kRpJhbdB9cvyoz0kgOnuBzf9RQ4hif+ur9unMXztVmVpbGa3aK?=
 =?us-ascii?Q?bu4vuHrBsOqMzS+pGn2SZwLU8eeshzrCUWeLnGaLg7P87iAg+ADsLTXGNd1h?=
 =?us-ascii?Q?5p13fQ1GEhOYi36972yY5vP3UyJWGnNmcfiSOLURz68qhLyDxvd7ApsUB488?=
 =?us-ascii?Q?DEt2Nx/KWJpcgDjldDCPm0ohIuAsXxY3gaGsoYRDLtyYXBtF7TVzSYDHOE8o?=
 =?us-ascii?Q?jBiW1Iq8UcVAfd061qkNCBUGakt8gKNQmwJTX5fAK3IrPoQw3jZpBIz5r0Xq?=
 =?us-ascii?Q?Nk4HOhi4PbytHAWGJOU0FoR8+OxhUryd1Xq0nSdP7It+46JVii08mXTSMWcm?=
 =?us-ascii?Q?uWevKDLuOCQ5LCx6UG2MfkbNyiYv6bD8F84BDJyj8kbqVK4mLR4upL+Wy+lr?=
 =?us-ascii?Q?ysaOzcHGF8J1PEQeU1jTpYFf6+gDfWe/ymLISDkKy5Sq/dHA4leCLA2IDJqO?=
 =?us-ascii?Q?QdNtKfGeb2UKo4qxh/1TMSxzr5cjkeDUNs7gkIcVqHi3S9Bh0QSg7r9eDDJS?=
 =?us-ascii?Q?Rt5tBcN53nSJZSKsgLngYQS4HdjJ1/WbTmJr5qFs0WBoxR60qWaJVOWz7SRU?=
 =?us-ascii?Q?X0QVcsJMlF0xQGmKZqO+Jnle73quRUAfiwpydtF4Yuo+1kST04zUKppqwyx1?=
 =?us-ascii?Q?kIhuwLCgR3S3aO1oGEZI0+ENnd8Y9CCU7tqm4hGp8+5m6KKYsX3trqhUW8gF?=
 =?us-ascii?Q?94FZtWDjZ8h21TKlrd58tXF5EpYph3dVh+uJa1ntKolQLDLTSQWijIQBJhtM?=
 =?us-ascii?Q?FhA+YP5ytYH8CM3sbGBgVxbI1LxRPF4WUKRKtHZkOwh6O1lSvGdaR/Gz8KVE?=
 =?us-ascii?Q?9VTvI1rrNTu9HZ0xiBc8CtTuMhJz07gcYjOQnOpccPMY+FLzBV4TT4nsSycz?=
 =?us-ascii?Q?wIrCn+UjFoiGxTIYDNWyVLAqioec+JlGs/icbRQbBXDtt3RQKTeweFqQkmV0?=
 =?us-ascii?Q?a5GJlO1KDBZg14fKB3vyDm6hoWPBpKmG6m94RgIs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21960d4-2bd3-4207-3d1f-08da90a71480
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 08:00:50.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LFDCArG3cSZVC64oNbmHzqGUlVryoEF6K7YkzuFcUodnt1k9+hmOGImZYYZJD08dkN0pz28GBIJACw7PpDIEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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

v3:
* extend bond_listen_lacpdu_multicast test to init_state up and down cases
* remove some superfluous shell syntax and 'set dev ... up' commands

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/drivers/net/bonding/Makefile    |   5 +-
 .../selftests/drivers/net/bonding/config      |   1 +
 .../drivers/net/bonding/dev_addr_lists.sh     | 109 ++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh  |  61 ++++++++++
 .../selftests/drivers/net/team/Makefile       |   6 +
 .../testing/selftests/drivers/net/team/config |   3 +
 .../drivers/net/team/dev_addr_lists.sh        |  51 ++++++++
 9 files changed, 237 insertions(+), 1 deletion(-)
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
index 000000000000..e6fa24eded5b
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
@@ -0,0 +1,109 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test bond device handling of addr lists (dev->uc, mc)
+#
+
+ALL_TESTS="
+	bond_cleanup_mode1
+	bond_cleanup_mode4
+	bond_listen_lacpdu_multicast_case_down
+	bond_listen_lacpdu_multicast_case_up
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
+	# Initial state of bond device, up | down
+	local init_state=$1
+	local lacpdu_mc="01:80:c2:00:00:02"
+
+	ip link add dummy1 type dummy
+	ip link add bond1 "$init_state" type bond mode 802.3ad
+	ip link set dev dummy1 master bond1
+	if [ "$init_state" = "down" ]; then
+		ip link set dev bond1 up
+	fi
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
+	log_test "bonding LACPDU multicast address to slave (from bond $init_state)"
+}
+
+# The LACPDU mc addr is added by different paths depending on the initial state
+# of the bond when enslaving a device. Test both cases.
+
+bond_listen_lacpdu_multicast_case_down()
+{
+	RET=0
+
+	bond_listen_lacpdu_multicast "down"
+}
+
+bond_listen_lacpdu_multicast_case_up()
+{
+	RET=0
+
+	bond_listen_lacpdu_multicast "up"
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
index 000000000000..16c7fb858ac1
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/lag_lib.sh
@@ -0,0 +1,61 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Test that a link aggregation device (bonding, team) removes the hardware
+# addresses that it adds on its underlying devices.
+test_LAG_cleanup()
+{
+	local driver=$1
+	local mode=$2
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

