Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4DA6040B9
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJSKNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiJSKN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:13:28 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC29F102DE3;
        Wed, 19 Oct 2022 02:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5D9Mkk7Iv253JwuSwRhdi2zC76T3YiOBg2LPo4BjMZCL9HYgNmVP7ttqj88DTJ/pFZm1QtIjX2GCs71ACRx1Fp+ynglvhKmpeSBjIjfMnbUjtIvvDeQUQxmyCK1kTEq4Agyq8ZFOL478xx2IqLhttj/0EGTL92CRjfarssdg1Il28bvx4FAqhQDN1NKodTMdQFbwfYvIgDk5Xj13ziCXjU/yV4wKv8VDIrWkOTYY8I3by2iekpTkW3et3ROt5ePKmPHOQ0xMWyCmg24Z/StGSHmW6/+FbC578DVA4Hy5UUrbJUmc1Ux0Py2StcRbsybq7v8f9W39wNHEGG0d/7hOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIg5wFjAm+WczYw6biolgdRWH4/nyORu7QqbfZnW0Sw=;
 b=VjmBmc+QazjC+b1LrBKos1CxzVbHBQORuOcsiAzgeJbXo5lDrYBgkJJWdZAfmxSKbYhtbEMpjVjqCyNGA0SQ3FYHXC1bg8tMmLMsxOxffuBGcln1dY/d21zOh1Yihltz/Ufy6e76uCkt5YPLWaoQT9CWCKO7gcjB2gCCHFRlzAu8POOgnMWdS+Ig/tHGjNFuc9O60JPXEImTYoktSh+dudgU2vaAtbtfKngreHYeWodiUKELPDofJlRR0nEqry4Sgg/iDhP5pGNPm9XkJ+kOAQEiXGdJLBMBYu+iRVNJHjqDpG7YejEmI4d0qx+hErkRYFnFco+z17InNyvWguravw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIg5wFjAm+WczYw6biolgdRWH4/nyORu7QqbfZnW0Sw=;
 b=AVyBamuF8Wq5/9y+ZGQS56Ae1FRlWxpVdcExoQggFofvJZfOIUn/0fZJS177PUOOE2coZo5WiAqTSbNXJb1E7zJYvSk6eUsKah1gwCSvY3jQarOQmtaFypoLPSe+qLY/6F50uuGxw5hgtp/0QeyGHhkM2CJOq8Vv4RVttO1egfjBs6G1RNbLTIyxn5OzQTclO1bPrfPVgy4dOdPD0AE0yDcu+hZVR+eE2l0p2OLIHf0a19CEZUudv4sYgWAkMmCctv/VhrUeqgg8zoQfB3+vCRXfYWAUsGpJYHAoghkY00Ubj5JqTKGyiIvaD4xKuuxvCf9IS0rsJZkYbNQRnt8q4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 09:12:00 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93%4]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 09:12:00 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 1/2] selftests: net: Fix cross-tree inclusion of scripts
Date:   Wed, 19 Oct 2022 18:10:41 +0900
Message-Id: <20221019091042.783786-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221019091042.783786-1-bpoirier@nvidia.com>
References: <20221019091042.783786-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:404:42::26) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 090f2fef-7495-4d1a-d297-08dab1b1fac2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /T4L971uApmRPlcG8E+HmIa9OEzSvE2IQ7AUuo2fYrQLeT7+xiqWnn3EZBtaGE4TEUI8xiq/zNaIs5brNu2p5pslCRgFWLxXDGsmksrWPzb4CvcouRyVYxzYtCVc/Ob+evYXX9r3ikNA25NvMQ17XQUZtlizfX2azkDU2SsIAfrAusux7pclHoHOEiqh8YRbj3Mrng+fsO4TaFvvZQAOZC64jSgqC/kiP8ybBHTWYEM8fO56BUGAhYE1yUAWSSzw3bRKxcisK5s4Lqw7X8VwXiRdVY32p4jxQB/w0OSW/ZYg0EV404zNwUdoKk2zaXJ/kuEE45jrKUxpRrLWGm+IZC2uXAADkq/zBHByum4GYtv7J1y2825mh1d+F4UrSOADNBl+gPldprW8AkJwkO85W7LsKIIFwq/COOUg+b/I1Beda0PW83uxflf8a4j2M+/fjXByxAVekjapmhIb8wJJmJ98QcnKaDjhe+akggEj6TsVbmg43qtqNnxkfYQ88npz3IMuueTREAChBHgV0A4nY/sVaxZGCRbWqAabLXcM1daGPpOOEDDmRaRSyHv1wBcqVlRiVsBGqvjMQW6mNJ7jFnFmRhkM2huDgpfuhoL9LIDhc2ugspx30HQVXn2sZvyz5J1wCyd6uL8wqpGC1SrYVAr5RWGLhURoshYu+Uc+HMnWfIyreal6fSy6ofda0KRR0DAwXNtF4wGY+swDC9Tvf3k3t/ch6MSvQZcqCcbxnSYhbGKQjVvzBanOY0BGMei87hKbxTEDOswyOMaH2qTMv9dKRL0vhoFxYA8GR7r4Z+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(316002)(38100700002)(7416002)(2616005)(26005)(8936002)(4326008)(6512007)(8676002)(36756003)(5660300002)(66476007)(66556008)(66946007)(6666004)(41300700001)(186003)(6506007)(86362001)(2906002)(1076003)(966005)(6486002)(6916009)(83380400001)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dZKKZtfwP2uFrH/K0aqU2Cowcc09OIdzyr8xWscyGRUUheh2LciKZB89lPz+?=
 =?us-ascii?Q?On2ugPVsswzwQP+6jp0FAu4F0/QBmsk2aNFMJnMfchricaz2NeoLIBdzUG04?=
 =?us-ascii?Q?X0XiVsJuEBKRV2EIpk3AjQQScm1OAVsVqiG3Uj86vL8DDMj6lpA71gluIZ6h?=
 =?us-ascii?Q?poNDHZQwURM1ivCaUVfbcHguTJ12kwOFUxdqwngVIXI3NvyT275+XKUk1W0t?=
 =?us-ascii?Q?Emlh0n5UbuL0RntwuPsV/STqOTEVWqqnQ4WpHQpc5Zbom9PZO2RhKixvN5UC?=
 =?us-ascii?Q?EcSpZTG3pC22G4k2XKhCCTGeye5wRPkyXWz1qv54T3qk8+fJlcnCnLiL2ZEZ?=
 =?us-ascii?Q?NMOWQQ9cSDvDiM1wCzrBmOWTUFvAjmhVx2uhY4CMA+g96mtR40LCH8LzFVpz?=
 =?us-ascii?Q?1V2EczKX+FU6VX2uxjKRqHxrH7B/DajPmWERxl4p85fHUW3zRCMl1DgjQdJH?=
 =?us-ascii?Q?s7++0WfdPDKBA3dimmKdg5AKKRqhMKjcofiBqAEOtvPBI3W+GI2xYfLem8Np?=
 =?us-ascii?Q?8rbKER6dyrPZBLlT/3ozxlqBZY9rj5bzTsI3y9ku2iQIyh4TyG7zp5EIZgLl?=
 =?us-ascii?Q?dQpR2J+so04jygK6hPg97c/gc8Ngl4ahTVSDruHzEM4rQcBx33aGfBTDTnim?=
 =?us-ascii?Q?uYO3pPNM3oKrg3tkuM9BSk0KOZ56VRiDstH1G1BvcJFasfDBsmkMK9D6R24F?=
 =?us-ascii?Q?ouaaUXPk8ICZ2xcGZQTghWjk2wR7k8OmwM1yQDPOHnZExreLmczL7DY0BrER?=
 =?us-ascii?Q?6SQ+BvWyj2jUU7jnscQwY/sPzIpobvRMQSj6HHNHP1eh0o71uq6xzfVueSbG?=
 =?us-ascii?Q?ezKnjUQfh8KH51l3LlMwxjXjjSYGpnArEcdiC2rnuUpz9Ahag7gZM7JwMkdz?=
 =?us-ascii?Q?egAJfBIlXDBOKdcjWpas1XZ3UPDbXpId3+mnXoIPfLJL1F986BkkFabInEmF?=
 =?us-ascii?Q?Tc4+z1fX08sxLo85xMzNhGENUat0brEZqCntzOiD6vxiRuvAp55xV/Dq/JTd?=
 =?us-ascii?Q?RIbk0W3fwm5rfxyJxK/BglXSP8x9p6pJCU4iyFRXBOLFm00qC3EuAKT1YkUJ?=
 =?us-ascii?Q?TpoD1A3jCJmzAkaU0POAkunMrCZCIvPvCxQASPWGEJoCYXab5zQr7rbTPu8x?=
 =?us-ascii?Q?G7yhbz9shjotSu2rn/nrFu+zfVaOxKOgbSXkI/RgwPEs6gdOWVfUibUwGu4U?=
 =?us-ascii?Q?/dWKgK+iA816i+nNKaerDW6qTsoyNfGIilGp5QrnIjQMmPNBB9a7Z8ZN423p?=
 =?us-ascii?Q?5mwZpgd0Vt5x7FgRWOWNVoe8HcJ0GaPdqbMl0KKKLb36DbUqwwRHaydjXeHB?=
 =?us-ascii?Q?HetP8Tz03ydKPJMrG+iDdr35/VYWh5boDC+fPkErTBJncWanzVJ+pnhhWNqt?=
 =?us-ascii?Q?mDp2NW9nxP5NwIAnHy+hpGfLE7B6RQ9Dc+MetmlVYNo76nkuIhpGW7Bb2IC2?=
 =?us-ascii?Q?kUZpu2iTaXfFfqIePVmxF+tlywQOLMb3jk0u1HU+krO4EeH81XSFD8eTx3+0?=
 =?us-ascii?Q?K6durMkFXDEGGOFEDtHRpbKFlGCiUsqbkDjl95b7ksXNFbfbAFpL0u5AysA9?=
 =?us-ascii?Q?c0QJ9N+djJHmtHWXhVV3tFfWQcmw8Vj7pBRJg0AE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090f2fef-7495-4d1a-d297-08dab1b1fac2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 09:12:00.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xQLoIP6Kho/Tj7gt3tX1+h+1J8t84wBZAVKska0hAp7kXyddD6idPmL31xmVpSqj0bZTsnxgGnn8g1HvM7qmlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When exporting and running a subset of selftests via kselftest, files from
parts of the source tree which were not exported are not available. A few
tests are trying to source such files. Address the problem by using
symlinks.

The problem can be reproduced by running:
make -C tools/testing/selftests gen_tar TARGETS="drivers/net/bonding"
[... extract archive ...]
./run_kselftest.sh

or:
make kselftest KBUILD_OUTPUT=/tmp/kselftests TARGETS="drivers/net/bonding"

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Fixes: eccd0a80dc7f ("selftests: net: dsa: add a stress test for unlocked FDB operations")
Link: https://lore.kernel.org/netdev/40f04ded-0c86-8669-24b1-9a313ca21076@redhat.com/
Reported-by: Jonathan Toppins <jtoppins@redhat.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 tools/testing/selftests/drivers/net/bonding/Makefile          | 4 +++-
 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh | 2 +-
 .../selftests/drivers/net/bonding/net_forwarding_lib.sh       | 1 +
 .../selftests/drivers/net/dsa/test_bridge_fdb_stress.sh       | 4 ++--
 tools/testing/selftests/drivers/net/team/Makefile             | 4 ++++
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh    | 4 ++--
 tools/testing/selftests/drivers/net/team/lag_lib.sh           | 1 +
 .../testing/selftests/drivers/net/team/net_forwarding_lib.sh  | 1 +
 tools/testing/selftests/lib.mk                                | 4 ++--
 9 files changed, 17 insertions(+), 8 deletions(-)
 create mode 120000 tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/lag_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index e9dab5f9d773..6b8d2e2f23c2 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -7,6 +7,8 @@ TEST_PROGS := \
 	bond-lladdr-target.sh \
 	dev_addr_lists.sh
 
-TEST_FILES := lag_lib.sh
+TEST_FILES := \
+	lag_lib.sh \
+	net_forwarding_lib.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
index e6fa24eded5b..5cfe7d8ebc25 100755
--- a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
@@ -14,7 +14,7 @@ ALL_TESTS="
 REQUIRE_MZ=no
 NUM_NETIFS=0
 lib_dir=$(dirname "$0")
-source "$lib_dir"/../../../net/forwarding/lib.sh
+source "$lib_dir"/net_forwarding_lib.sh
 
 source "$lib_dir"/lag_lib.sh
 
diff --git a/tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh b/tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
new file mode 120000
index 000000000000..39c96828c5ef
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
@@ -0,0 +1 @@
+../../../net/forwarding/lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
index dca8be6092b9..a1f269ee84da 100755
--- a/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
+++ b/tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
@@ -18,8 +18,8 @@ NUM_NETIFS=1
 REQUIRE_JQ="no"
 REQUIRE_MZ="no"
 NETIF_CREATE="no"
-lib_dir=$(dirname $0)/../../../net/forwarding
-source $lib_dir/lib.sh
+lib_dir=$(dirname "$0")
+source "$lib_dir"/lib.sh
 
 cleanup() {
 	echo "Cleaning up"
diff --git a/tools/testing/selftests/drivers/net/team/Makefile b/tools/testing/selftests/drivers/net/team/Makefile
index 642d8df1c137..6a86e61e8bfe 100644
--- a/tools/testing/selftests/drivers/net/team/Makefile
+++ b/tools/testing/selftests/drivers/net/team/Makefile
@@ -3,4 +3,8 @@
 
 TEST_PROGS := dev_addr_lists.sh
 
+TEST_FILES := \
+	lag_lib.sh \
+	net_forwarding_lib.sh
+
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
index debda7262956..9684163949f0 100755
--- a/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/team/dev_addr_lists.sh
@@ -11,9 +11,9 @@ ALL_TESTS="
 REQUIRE_MZ=no
 NUM_NETIFS=0
 lib_dir=$(dirname "$0")
-source "$lib_dir"/../../../net/forwarding/lib.sh
+source "$lib_dir"/net_forwarding_lib.sh
 
-source "$lib_dir"/../bonding/lag_lib.sh
+source "$lib_dir"/lag_lib.sh
 
 
 destroy()
diff --git a/tools/testing/selftests/drivers/net/team/lag_lib.sh b/tools/testing/selftests/drivers/net/team/lag_lib.sh
new file mode 120000
index 000000000000..e1347a10afde
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/lag_lib.sh
@@ -0,0 +1 @@
+../bonding/lag_lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh b/tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh
new file mode 120000
index 000000000000..39c96828c5ef
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh
@@ -0,0 +1 @@
+../../../net/forwarding/lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 9d4cb94cf437..a3ea3d4a206d 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -70,7 +70,7 @@ endef
 run_tests: all
 ifdef building_out_of_srctree
 	@if [ "X$(TEST_PROGS)$(TEST_PROGS_EXTENDED)$(TEST_FILES)" != "X" ]; then \
-		rsync -aq $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(OUTPUT); \
+		rsync -aLq $(TEST_PROGS) $(TEST_PROGS_EXTENDED) $(TEST_FILES) $(OUTPUT); \
 	fi
 	@if [ "X$(TEST_PROGS)" != "X" ]; then \
 		$(call RUN_TESTS, $(TEST_GEN_PROGS) $(TEST_CUSTOM_PROGS) \
@@ -84,7 +84,7 @@ endif
 
 define INSTALL_SINGLE_RULE
 	$(if $(INSTALL_LIST),@mkdir -p $(INSTALL_PATH))
-	$(if $(INSTALL_LIST),rsync -a $(INSTALL_LIST) $(INSTALL_PATH)/)
+	$(if $(INSTALL_LIST),rsync -aL $(INSTALL_LIST) $(INSTALL_PATH)/)
 endef
 
 define INSTALL_RULE
-- 
2.37.2

