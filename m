Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1300647316
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiLHPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiLHPam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:42 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4EF7F8A0
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:30:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofgvGiNZgdE3gvToPPcFQn5UFnK/63NCblXFBlYVeqFsiaqoB1amQBQLGl2b2IpoDD664CbRm7mN90RExnH6ayR4gE8RQDFtlY7Vf4/9X6rETyuZ7n0K6Mt/hEmEozFMi0ePEA8TC//KEpJWKJN+e6CP6YAR9Ass7pCSyWuJ9L0sPmrMunIWWoveo+OHujNbvcasA3Nhb3DFQOcCqa8ycZglM+wXCHR9GXeSybnaGBxBaD1IERmhxej8yiqVLELRIuoc/dzYe7SB/iI/cq53+d6JEq44SJ6bczIVD+lT3pDhiVKAP95+U490t6ogbwX2Ddxi5lld03C2G8Pg/sDjRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8lhTzo510AWbiecDzLNBhelTS9ihWvXGIrkGkedIis=;
 b=kI8H5KeJS4zX9ySX4DixC7eSpOqB5mebynCjuFxPYnyqaCV49y8I2r75IvebqZNU8iSAnkzyKLuW9CNzUosALfR6mOiC/BIWY7B36QLBIMImIbG9q+4M0VLfGRLbwhzwqK1wptaJzgADnnUtNpPhxtNHVvLiyHgj5ySvGPTmwB39+Y4XO7ejk76CFJKT6cHWa/D1/2bLFVLqmjoVV85iZXeFq4CUxRv91hRcrpylwaVaDFAvhA5TQ16pIPhfdYLzJBFzjNd+U3h02sxoJKPX02Q10Um2KxDBdnNpfvTd8zxZAl56379nz0Lz5JArFrNNPZ98NjrEtxiYzXJwqYebtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8lhTzo510AWbiecDzLNBhelTS9ihWvXGIrkGkedIis=;
 b=EFerDIFRCxwFr3vpV5wDaIK5y4lBjry/d57NhfD6E1ofgCLq6visIKSvXjcCTR8aBME7bZvANVQfLz4FbsNhMgJE3CZHWuS9i4nFkL5sMeQ5nINh7GLzM0Qs3z2Mtzb52hmuK5x8NuOe51mwTRUi0NV5u5WrywcTVGSmycMYpXyyAwObwpL4kGRkwnpnIuU6F4854rQhT6pXbAY8tw+hDHrJ7QcoguFEQ5RxHTnjo1sI4zSHyDayo697scrztI2gJKF90gw2xmKiIFvih3mXCXD/PcP/JaYL+09ySpVDmcxclwBEunOwlUisuuRawZRMdlacyn4SXAzVdFX9ldXurw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB7216.namprd12.prod.outlook.com (2603:10b6:303:226::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 15:30:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:30:35 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/14] selftests: forwarding: Add bridge MDB test
Date:   Thu,  8 Dec 2022 17:28:39 +0200
Message-Id: <20221208152839.1016350-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0009.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: 5906250d-0ef2-4bb8-add5-08dad931266c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMhsxA5wd44ch6O3O2Ec3lqFW8dSIJYo/tKj2kgpC44/dukY/kHr8nItxj9CUetIuOH5+IIsF6spDP3LBh4JIDMVx8ZbWHxNKUCBytOjT5qoRuAm4Kj0x5CzKp4EfKJAdoIB6W+Pz2P5k2WB3Y9R1Gg5U+GnaSNhiLp7SzvApgPp4iFuSHL1WBg3dNSf5SXo/tKAspBIx9dVjH5MU58lxb4KjuCWQzO4nG+uYtRCJ92V3xPjVDXizr7rB694nUO6SICt3HRisxa6gp956uImsn5SpRdXx/x6OHt6VO6RMfkBW+PfBoVGHCezBG5bXBh+eEG2YZJr2GyqAnbss8Rc4AeMpoUVwvn0X4CCTvo1dkiMvlEyhBU4vPloVy7Bb8Si26SoeI8YvSVuNkukh+Jf3d71MZJTFPdmmuMWoq0iu4QIKKoDh4EeMnu1GlgMBvpBdeIc/zY6sbnI8pAA6BvE6Ll/HBa9PSh3lYaFogPpGK2Ps6mVjnBVKKDf076RnFXXonUszlrASdQ+ljb2+jrxkrdRwPUQHT4SJhsAt1v0MW87BNmlfQWd5zapkZaJwK9YiqIRMDF2LO3lSglih53MjdCtJPflryT3w8mWqYqg84CvEI2WCLCAy8A2QSqoMzxJEFMPiciH9a8RevA505elyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(66946007)(66476007)(66556008)(8676002)(4326008)(38100700002)(107886003)(478600001)(6486002)(86362001)(2906002)(186003)(6512007)(26005)(66574015)(6506007)(83380400001)(36756003)(8936002)(41300700001)(30864003)(5660300002)(2616005)(316002)(1076003)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9vZNUlG4SumA+j+GZxKAwY++Z0S0ViTJ6ahWpRtmTvBNR+YVzhWmCbJTC64t?=
 =?us-ascii?Q?Ob/vHk6di9hnq0RHMAWKQir/yIlO83icy5o7f7uEO/DtR7Vmg5nOPUfgd0L8?=
 =?us-ascii?Q?Sz57dZtLzkT2BLSyuReo2dO5s9vWfKulz6/GPDauAUxP6RUOwHcFa2YOKS/E?=
 =?us-ascii?Q?pteBKuM/zxhMAuIyTwKWV8jB2llDMltPPAwUiHZ4kFBOLa8FzmquG5LzVVh9?=
 =?us-ascii?Q?6WrFCSYJTBdcrhhDAMwh0szwOGsS8O2c3t2sOB94P80eO3su8oWOZGIfAPjK?=
 =?us-ascii?Q?Z6QYfypH1Iu7kYKYj6VyDpxu7dMGfucbxegdOqVjiVHYJaA5Zo5EIxHW39ZW?=
 =?us-ascii?Q?W1RNsuqJ3Ur7a/sQe5xporZy9PFiHXmqBzmjbIn9W5q2jsX1JnmmzPT2cdI4?=
 =?us-ascii?Q?1/U/dQcvmJu6GDA8+ruxM7WbbhmJXrTRPxeW8OmdR7CEQWd9DcOQduTKLAVH?=
 =?us-ascii?Q?CLims4eHt6qqBWbuMTGnqUtkCr6gsdSZhUbA5guWkr35xwxzEJK06KsE+7+R?=
 =?us-ascii?Q?imHAwzd/dJCjuLWGL2ixnMrI7MCyIIf6FCU5gIrh//8tdNJa68c+SNNHJSyz?=
 =?us-ascii?Q?6YuQC6XydbnfI8dPY6p/bz0eP84WDTAYJBikQbren90Rjfc8PBMpJ/unZKIg?=
 =?us-ascii?Q?kV+io37n9YfkAg2M4UcAoTsGQeUkyw3d97mdPWGff07AZPteO4o8TOXGzj2g?=
 =?us-ascii?Q?YB8nfVnRbxkbstNPAqtvOAxxXNmIAnPDuS0yGMHSnKIqmqzIMvzTbwJF1eUC?=
 =?us-ascii?Q?SRMsYybHRcXGb1Hc8JNmTSWlZCLOPpewkDr2gmx0aZSJ0Lq4YJw0ypMt+61n?=
 =?us-ascii?Q?5JgzB0ehJfsStKiJI6XN92JG/1ao8NhZdFi+PwBV5lB5mcq4o63jf63DmTAl?=
 =?us-ascii?Q?UA40ZPFt3TeSAiLYdDTXpahVvYkLUVH4kBkg/1PCcFB/p4GZcezafo/k60ai?=
 =?us-ascii?Q?J1WpyAPuYSr4L33klwENSbxFLm0EoZC+vtfoexKuYz6fGlTeGc+cCoZryEJJ?=
 =?us-ascii?Q?e7chDfy5VzAvuHELTyix/cisO5JMG0H7U/kB9EBF5/2y79KqSCgRBIqJ1j1j?=
 =?us-ascii?Q?o8YvVwwkR+RR+L+LdBvUtvdXIe+PhfTOfA0TDxDofaJvf9q/a8l531Iunh7X?=
 =?us-ascii?Q?fKZCKpI7HT+xaiosoEshdyNDG2dBGvux+nD27B8lXT/UWnt4iZsrpsIiGqsz?=
 =?us-ascii?Q?XkJzKVeORfclPLzeBqi3t68AnmGvEZxIzu8hVqFjrC3SqvjBjPV14Zkok66f?=
 =?us-ascii?Q?UFAyD4HG4izYOSJcQDL4IlBu4nAGl3zecQ1RieFsRn7vIR68NrpUfcEwZO1q?=
 =?us-ascii?Q?78eJNvf6OkI/Sg20Q1uYFnmM1rz3jkK7HQj3ZXwc3hVUiuRkPB/9Z4XlUJJx?=
 =?us-ascii?Q?sneiCe+K/ptaDjDiq5DKGfzC2BLtjlOXk0IxYlmmwU5CIBhjMOqPI4/M3ymi?=
 =?us-ascii?Q?r+cCBf17D58khm3/rPcU2SQEChGYMEousZ1WTBIwazeyCF0StIZGkHeravpF?=
 =?us-ascii?Q?EvejZrzlUnFRK07UOxlcR2nd83UGx5spEwbTpULLigzAA9FUt0KncRGBIxD2?=
 =?us-ascii?Q?K25c1bLCgvTd2LSN6zSikd5/SddXcm1tYxbkYDxk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5906250d-0ef2-4bb8-add5-08dad931266c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:30:35.7938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xwckc+gAbc3mBTPQXUCRsLUQV7aeFTmvV7X3Po48MMCtKPLZN36AVJvtT9LXV+c1p+MGMyD5HHW4imX0eG7kRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7216
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftests that includes the following test cases:

1. Configuration tests. Both valid and invalid configurations are
   tested across all entry types (e.g., L2, IPv4).

2. Forwarding tests. Both host and port group entries are tested across
   all entry types.

3. Interaction between user installed MDB entries and IGMP / MLD control
   packets.

Example output:

INFO: # Host entries configuration tests
TEST: Common host entries configuration tests (IPv4)                [ OK ]
TEST: Common host entries configuration tests (IPv6)                [ OK ]
TEST: Common host entries configuration tests (L2)                  [ OK ]

INFO: # Port group entries configuration tests - (*, G)
TEST: Common port group entries configuration tests (IPv4 (*, G))   [ OK ]
TEST: Common port group entries configuration tests (IPv6 (*, G))   [ OK ]
TEST: IPv4 (*, G) port group entries configuration tests            [ OK ]
TEST: IPv6 (*, G) port group entries configuration tests            [ OK ]

INFO: # Port group entries configuration tests - (S, G)
TEST: Common port group entries configuration tests (IPv4 (S, G))   [ OK ]
TEST: Common port group entries configuration tests (IPv6 (S, G))   [ OK ]
TEST: IPv4 (S, G) port group entries configuration tests            [ OK ]
TEST: IPv6 (S, G) port group entries configuration tests            [ OK ]

INFO: # Port group entries configuration tests - L2
TEST: Common port group entries configuration tests (L2 (*, G))     [ OK ]
TEST: L2 (*, G) port group entries configuration tests              [ OK ]

INFO: # Forwarding tests
TEST: IPv4 host entries forwarding tests                            [ OK ]
TEST: IPv6 host entries forwarding tests                            [ OK ]
TEST: L2 host entries forwarding tests                              [ OK ]
TEST: IPv4 port group "exclude" entries forwarding tests            [ OK ]
TEST: IPv6 port group "exclude" entries forwarding tests            [ OK ]
TEST: IPv4 port group "include" entries forwarding tests            [ OK ]
TEST: IPv6 port group "include" entries forwarding tests            [ OK ]
TEST: L2 port entries forwarding tests                              [ OK ]

INFO: # Control packets tests
TEST: IGMPv3 MODE_IS_INCLUE tests                                   [ OK ]
TEST: MLDv2 MODE_IS_INCLUDE tests                                   [ OK ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/net/forwarding/Makefile |    1 +
 .../selftests/net/forwarding/bridge_mdb.sh    | 1164 +++++++++++++++++
 2 files changed, 1165 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb.sh

diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
index f2df81ca3179..453ae006fbcf 100644
--- a/tools/testing/selftests/net/forwarding/Makefile
+++ b/tools/testing/selftests/net/forwarding/Makefile
@@ -2,6 +2,7 @@
 
 TEST_PROGS = bridge_igmp.sh \
 	bridge_locked_port.sh \
+	bridge_mdb.sh \
 	bridge_mdb_host.sh \
 	bridge_mdb_port_down.sh \
 	bridge_mld.sh \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
new file mode 100755
index 000000000000..2fa5973c0c28
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -0,0 +1,1164 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# +-----------------------+                          +------------------------+
+# | H1 (vrf)              |                          | H2 (vrf)               |
+# | + $h1.10              |                          | + $h2.10               |
+# | | 192.0.2.1/28        |                          | | 192.0.2.2/28         |
+# | | 2001:db8:1::1/64    |                          | | 2001:db8:1::2/64     |
+# | |                     |                          | |                      |
+# | |  + $h1.20           |                          | |  + $h2.20            |
+# | \  | 198.51.100.1/24  |                          | \  | 198.51.100.2/24   |
+# |  \ | 2001:db8:2::1/64 |                          |  \ | 2001:db8:2::2/64  |
+# |   \|                  |                          |   \|                   |
+# |    + $h1              |                          |    + $h2               |
+# +----|------------------+                          +----|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|--------------------------------------------------|-----------------+ |
+# | |  + $swp1                   BR0 (802.1q)             + $swp2           | |
+# | |     vid 10                                             vid 10         | |
+# | |     vid 20                                             vid 20         | |
+# | |                                                                       | |
+# | +-----------------------------------------------------------------------+ |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	cfg_test
+	fwd_test
+	ctrl_test
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1
+	vlan_create $h1 10 v$h1 192.0.2.1/28 2001:db8:1::1/64
+	vlan_create $h1 20 v$h1 198.51.100.1/24 2001:db8:2::1/64
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 20
+	vlan_destroy $h1 10
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	vlan_create $h2 10 v$h2 192.0.2.2/28
+	vlan_create $h2 20 v$h2 198.51.100.2/24
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 20
+	vlan_destroy $h2 10
+	simple_if_fini $h2
+}
+
+switch_create()
+{
+	ip link add name br0 type bridge vlan_filtering 1 vlan_default_pvid 0 \
+		mcast_snooping 1 mcast_igmp_version 3 mcast_mld_version 2
+	bridge vlan add vid 10 dev br0 self
+	bridge vlan add vid 20 dev br0 self
+	ip link set dev br0 up
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp1 up
+	bridge vlan add vid 10 dev $swp1
+	bridge vlan add vid 20 dev $swp1
+
+	ip link set dev $swp2 master br0
+	ip link set dev $swp2 up
+	bridge vlan add vid 10 dev $swp2
+	bridge vlan add vid 20 dev $swp2
+
+	tc qdisc add dev br0 clsact
+	tc qdisc add dev $h2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	tc qdisc del dev br0 clsact
+
+	bridge vlan del vid 20 dev $swp2
+	bridge vlan del vid 10 dev $swp2
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+
+	bridge vlan del vid 20 dev $swp1
+	bridge vlan del vid 10 dev $swp1
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+
+	ip link set dev br0 down
+	bridge vlan del vid 20 dev br0 self
+	bridge vlan del vid 10 dev br0 self
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+	forwarding_enable
+
+	h1_create
+	h2_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h2_destroy
+	h1_destroy
+
+	forwarding_restore
+	vrf_cleanup
+}
+
+cfg_test_host_common()
+{
+	local name=$1; shift
+	local grp=$1; shift
+	local src=$1; shift
+	local state=$1; shift
+	local invalid_state=$1; shift
+
+	RET=0
+
+	# Check basic add, replace and delete behavior.
+	bridge mdb add dev br0 port br0 grp $grp $state vid 10
+	bridge mdb show dev br0 vid 10 | grep -q "$grp"
+	check_err $? "Failed to add $name host entry"
+
+	bridge mdb replace dev br0 port br0 grp $grp $state vid 10 &> /dev/null
+	check_fail $? "Managed to replace $name host entry"
+
+	bridge mdb del dev br0 port br0 grp $grp $state vid 10
+	bridge mdb show dev br0 vid 10 | grep -q "$grp"
+	check_fail $? "Failed to delete $name host entry"
+
+	# Check error cases.
+	bridge mdb add dev br0 port br0 grp $grp $invalid_state vid 10 \
+		&> /dev/null
+	check_fail $? "Managed to add $name host entry with a $invalid_state state"
+
+	bridge mdb add dev br0 port br0 grp $grp src $src $state vid 10 \
+		&> /dev/null
+	check_fail $? "Managed to add $name host entry with a source"
+
+	bridge mdb add dev br0 port br0 grp $grp $state vid 10 \
+		filter_mode exclude &> /dev/null
+	check_fail $? "Managed to add $name host entry with a filter mode"
+
+	bridge mdb add dev br0 port br0 grp $grp $state vid 10 \
+		source_list $src &> /dev/null
+	check_fail $? "Managed to add $name host entry with a source list"
+
+	bridge mdb add dev br0 port br0 grp $grp $state vid 10 \
+		proto 123 &> /dev/null
+	check_fail $? "Managed to add $name host entry with a protocol"
+
+	log_test "Common host entries configuration tests ($name)"
+}
+
+# Check configuration of host entries from all types.
+cfg_test_host()
+{
+	echo
+	log_info "# Host entries configuration tests"
+
+	cfg_test_host_common "IPv4" "239.1.1.1" "192.0.2.1" "temp" "permanent"
+	cfg_test_host_common "IPv6" "ff0e::1" "2001:db8:1::1" "temp" "permanent"
+	cfg_test_host_common "L2" "01:02:03:04:05:06" "00:00:00:00:00:01" \
+		"permanent" "temp"
+}
+
+cfg_test_port_common()
+{
+	local name=$1;shift
+	local grp_key=$1; shift
+
+	RET=0
+
+	# Check basic add, replace and delete behavior.
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
+	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	check_err $? "Failed to add $name entry"
+
+	bridge mdb replace dev br0 port $swp1 $grp_key permanent vid 10 \
+		&> /dev/null
+	check_err $? "Failed to replace $name entry"
+
+	bridge mdb del dev br0 port $swp1 $grp_key permanent vid 10
+	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	check_fail $? "Failed to delete $name entry"
+
+	# Check default protocol and replacement.
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | grep -q "static"
+	check_err $? "$name entry not added with default \"static\" protocol"
+
+	bridge mdb replace dev br0 port $swp1 $grp_key permanent vid 10 \
+		proto 123
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | grep -q "123"
+	check_err $? "Failed to replace protocol of $name entry"
+	bridge mdb del dev br0 port $swp1 $grp_key permanent vid 10
+
+	# Check behavior when VLAN is not specified.
+	bridge mdb add dev br0 port $swp1 $grp_key permanent
+	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	check_err $? "$name entry with VLAN 10 not added when VLAN was not specified"
+	bridge mdb show dev br0 vid 20 | grep -q "$grp_key"
+	check_err $? "$name entry with VLAN 20 not added when VLAN was not specified"
+
+	bridge mdb del dev br0 port $swp1 $grp_key permanent
+	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	check_fail $? "$name entry with VLAN 10 not deleted when VLAN was not specified"
+	bridge mdb show dev br0 vid 20 | grep -q "$grp_key"
+	check_fail $? "$name entry with VLAN 20 not deleted when VLAN was not specified"
+
+	# Check behavior when bridge port is down.
+	ip link set dev $swp1 down
+
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
+	check_err $? "Failed to add $name permanent entry when bridge port is down"
+
+	bridge mdb del dev br0 port $swp1 $grp_key permanent vid 10
+
+	bridge mdb add dev br0 port $swp1 $grp_key temp vid 10 &> /dev/null
+	check_fail $? "Managed to add $name temporary entry when bridge port is down"
+
+	ip link set dev $swp1 up
+	setup_wait_dev $swp1
+
+	# Check error cases.
+	ip link set dev br0 down
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10 \
+		&> /dev/null
+	check_fail $? "Managed to add $name entry when bridge is down"
+	ip link set dev br0 up
+
+	ip link set dev br0 type bridge mcast_snooping 0
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid \
+		10 &> /dev/null
+	check_fail $? "Managed to add $name entry when multicast snooping is disabled"
+	ip link set dev br0 type bridge mcast_snooping 1
+
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 5000 \
+		&> /dev/null
+	check_fail $? "Managed to add $name entry with an invalid VLAN"
+
+	log_test "Common port group entries configuration tests ($name)"
+}
+
+src_list_create()
+{
+	local src_prefix=$1; shift
+	local num_srcs=$1; shift
+	local src_list
+	local i
+
+	for i in $(seq 1 $num_srcs); do
+		src_list=${src_list},${src_prefix}${i}
+	done
+
+	echo $src_list | cut -c 2-
+}
+
+__cfg_test_port_ip_star_g()
+{
+	local name=$1; shift
+	local grp=$1; shift
+	local invalid_grp=$1; shift
+	local src_prefix=$1; shift
+	local src1=${src_prefix}1
+	local src2=${src_prefix}2
+	local src3=${src_prefix}3
+	local max_srcs=31
+	local num_srcs
+
+	RET=0
+
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "exclude"
+	check_err $? "Default filter mode is not \"exclude\""
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check basic add and delete behavior.
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode exclude \
+		source_list $src1
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q -v "src"
+	check_err $? "(*, G) entry not created"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	check_err $? "(S, G) entry not created"
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q -v "src"
+	check_fail $? "(*, G) entry not deleted"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	check_fail $? "(S, G) entry not deleted"
+
+	## State (permanent / temp) tests.
+
+	# Check that group and source timer are not set for permanent entries.
+	bridge mdb add dev br0 port $swp1 grp $grp permanent vid 10 \
+		filter_mode exclude source_list $src1
+
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "permanent"
+	check_err $? "(*, G) entry not added as \"permanent\" when should"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "permanent"
+	check_err $? "(S, G) entry not added as \"permanent\" when should"
+
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q " 0.00"
+	check_err $? "(*, G) \"permanent\" entry has a pending group timer"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "\/0.00"
+	check_err $? "\"permanent\" source entry has a pending source timer"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that group timer is set for temporary (*, G) EXCLUDE, but not
+	# the source timer.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1
+
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "temp"
+	check_err $? "(*, G) EXCLUDE entry not added as \"temp\" when should"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "temp"
+	check_err $? "(S, G) \"blocked\" entry not added as \"temp\" when should"
+
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q " 0.00"
+	check_fail $? "(*, G) EXCLUDE entry does not have a pending group timer"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "\/0.00"
+	check_err $? "\"blocked\" source entry has a pending source timer"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that group timer is not set for temporary (*, G) INCLUDE, but
+	# that the source timer is set.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode include source_list $src1
+
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "temp"
+	check_err $? "(*, G) INCLUDE entry not added as \"temp\" when should"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "temp"
+	check_err $? "(S, G) entry not added as \"temp\" when should"
+
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q " 0.00"
+	check_err $? "(*, G) INCLUDE entry has a pending group timer"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "\/0.00"
+	check_fail $? "Source entry does not have a pending source timer"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that group timer is never set for (S, G) entries.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode include source_list $src1
+
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q " 0.00"
+	check_err $? "(S, G) entry has a pending group timer"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	## Filter mode (include / exclude) tests.
+
+	# Check that (*, G) INCLUDE entries are added with correct filter mode
+	# and that (S, G) entries are not marked as "blocked".
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
+		filter_mode include source_list $src1
+
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "include"
+	check_err $? "(*, G) INCLUDE not added with \"include\" filter mode"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "blocked"
+	check_fail $? "(S, G) entry marked as \"blocked\" when should not"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that (*, G) EXCLUDE entries are added with correct filter mode
+	# and that (S, G) entries are marked as "blocked".
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
+		filter_mode exclude source_list $src1
+
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "exclude"
+	check_err $? "(*, G) EXCLUDE not added with \"exclude\" filter mode"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "blocked"
+	check_err $? "(S, G) entry not marked as \"blocked\" when should"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	## Protocol tests.
+
+	# Check that (*, G) and (S, G) entries are added with the specified
+	# protocol.
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
+		filter_mode exclude source_list $src1 proto zebra
+
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "zebra"
+	check_err $? "(*, G) entry not added with \"zebra\" protocol"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "zebra"
+	check_err $? "(S, G) entry not marked added with \"zebra\" protocol"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	## Replace tests.
+
+	# Check that state can be modified.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1
+
+	bridge mdb replace dev br0 port $swp1 grp $grp permanent vid 10 \
+		filter_mode exclude source_list $src1
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "permanent"
+	check_err $? "(*, G) entry not marked as \"permanent\" after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "permanent"
+	check_err $? "(S, G) entry not marked as \"permanent\" after replace"
+
+	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "temp"
+	check_err $? "(*, G) entry not marked as \"temp\" after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "temp"
+	check_err $? "(S, G) entry not marked as \"temp\" after replace"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that filter mode can be modified.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1
+
+	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode include source_list $src1
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "include"
+	check_err $? "(*, G) not marked with \"include\" filter mode after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "blocked"
+	check_fail $? "(S, G) marked as \"blocked\" after replace"
+
+	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "exclude"
+	check_err $? "(*, G) not marked with \"exclude\" filter mode after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "blocked"
+	check_err $? "(S, G) not marked as \"blocked\" after replace"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that sources can be added to and removed from the source list.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1
+
+	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1,$src2,$src3
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	check_err $? "(S, G) entry for source $src1 not created after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src2"
+	check_err $? "(S, G) entry for source $src2 not created after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src3"
+	check_err $? "(S, G) entry for source $src3 not created after replace"
+
+	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1,$src3
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	check_err $? "(S, G) entry for source $src1 not created after second replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src2"
+	check_fail $? "(S, G) entry for source $src2 created after second replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src3"
+	check_err $? "(S, G) entry for source $src3 not created after second replace"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	# Check that protocol can be modified.
+	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1 proto zebra
+
+	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
+		filter_mode exclude source_list $src1 proto bgp
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
+		grep -q "bgp"
+	check_err $? "(*, G) protocol not changed to \"bgp\" after replace"
+	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+		grep -q "bgp"
+	check_err $? "(S, G) protocol not changed to \"bgp\" after replace"
+
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	## Star exclude tests.
+
+	# Check star exclude functionality. When adding a new EXCLUDE (*, G),
+	# it needs to be also added to all (S, G) entries for proper
+	# replication.
+	bridge mdb add dev br0 port $swp2 grp $grp vid 10 \
+		filter_mode include source_list $src1
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$swp1" | grep "$grp" | \
+		grep "$src1" | grep -q "added_by_star_ex"
+	check_err $? "\"added_by_star_ex\" entry not created after adding (*, G) entry"
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+	bridge mdb del dev br0 port $swp2 grp $grp src $src1 vid 10
+
+	## Error cases tests.
+
+	bridge mdb add dev br0 port $swp1 grp $invalid_grp vid 10 &> /dev/null
+	check_fail $? "Managed to add an entry with an invalid group"
+
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode include \
+		&> /dev/null
+	check_fail $? "Managed to add an INCLUDE entry with an empty source list"
+
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode include \
+		source_list $grp &> /dev/null
+	check_fail $? "Managed to add an entry with an invalid source in source list"
+
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
+		source_list $src &> /dev/null
+	check_fail $? "Managed to add an entry with a source list and no filter mode"
+
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode include \
+		source_list $src1
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode exclude \
+		source_list $src1 &> /dev/null
+	check_fail $? "Managed to replace an entry without using replace"
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	bridge mdb add dev br0 port $swp1 grp $grp src $src2 vid 10
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode include \
+		source_list $src1,$src2,$src3 &> /dev/null
+	check_fail $? "Managed to add a source that already has a forwarding entry"
+	bridge mdb del dev br0 port $swp1 grp $grp src $src2 vid 10
+
+	# Check maximum number of sources.
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode exclude \
+		source_list $(src_list_create $src_prefix $max_srcs)
+	num_srcs=$(bridge -d mdb show dev br0 vid 10 | grep "$grp" | \
+		grep "src" | wc -l)
+	[[ $num_srcs -eq $max_srcs ]]
+	check_err $? "Failed to configure maximum number of sources ($max_srcs)"
+	bridge mdb del dev br0 port $swp1 grp $grp vid 10
+
+	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode exclude \
+		source_list $(src_list_create $src_prefix $((max_srcs + 1))) \
+		&> /dev/null
+	check_fail $? "Managed to exceed maximum number of sources ($max_srcs)"
+
+	log_test "$name (*, G) port group entries configuration tests"
+}
+
+cfg_test_port_ip_star_g()
+{
+	echo
+	log_info "# Port group entries configuration tests - (*, G)"
+
+	cfg_test_port_common "IPv4 (*, G)" "grp 239.1.1.1"
+	cfg_test_port_common "IPv6 (*, G)" "grp ff0e::1"
+	__cfg_test_port_ip_star_g "IPv4" "239.1.1.1" "224.0.0.1" "192.0.2."
+	__cfg_test_port_ip_star_g "IPv6" "ff0e::1" "ff02::1" "2001:db8:1::"
+}
+
+__cfg_test_port_ip_sg()
+{
+	local name=$1; shift
+	local grp=$1; shift
+	local src=$1; shift
+	local grp_key="grp $grp src $src"
+
+	RET=0
+
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | grep -q "include"
+	check_err $? "Default filter mode is not \"include\""
+	bridge mdb del dev br0 port $swp1 $grp_key vid 10
+
+	# Check that entries can be added as both permanent and temp and that
+	# group timer is set correctly.
+	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "permanent"
+	check_err $? "Entry not added as \"permanent\" when should"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "0.00"
+	check_err $? "\"permanent\" entry has a pending group timer"
+	bridge mdb del dev br0 port $swp1 $grp_key vid 10
+
+	bridge mdb add dev br0 port $swp1 $grp_key temp vid 10
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "temp"
+	check_err $? "Entry not added as \"temp\" when should"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "0.00"
+	check_fail $? "\"temp\" entry has an unpending group timer"
+	bridge mdb del dev br0 port $swp1 $grp_key vid 10
+
+	# Check error cases.
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10 \
+		filter_mode include &> /dev/null
+	check_fail $? "Managed to add an entry with a filter mode"
+
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10 \
+		filter_mode include source_list $src &> /dev/null
+	check_fail $? "Managed to add an entry with a source list"
+
+	bridge mdb add dev br0 port $swp1 grp $grp src $grp vid 10 &> /dev/null
+	check_fail $? "Managed to add an entry with an invalid source"
+
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10 temp
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10 permanent &> /dev/null
+	check_fail $? "Managed to replace an entry without using replace"
+	bridge mdb del dev br0 port $swp1 $grp_key vid 10
+
+	# Check that we can replace available attributes.
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10 proto 123
+	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 proto 111
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "111"
+	check_err $? "Failed to replace protocol"
+
+	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 permanent
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "permanent"
+	check_err $? "Entry not marked as \"permanent\" after replace"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "0.00"
+	check_err $? "Entry has a pending group timer after replace"
+
+	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 temp
+	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "temp"
+	check_err $? "Entry not marked as \"temp\" after replace"
+	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
+		grep -q "0.00"
+	check_fail $? "Entry has an unpending group timer after replace"
+	bridge mdb del dev br0 port $swp1 $grp_key vid 10
+
+	# Check star exclude functionality. When adding a (S, G), all matching
+	# (*, G) ports need to be added to it.
+	bridge mdb add dev br0 port $swp2 grp $grp vid 10
+	bridge mdb add dev br0 port $swp1 $grp_key vid 10
+	bridge mdb show dev br0 vid 10 | grep "$grp_key" | grep $swp2 | \
+		grep -q "added_by_star_ex"
+	check_err $? "\"added_by_star_ex\" entry not created after adding (S, G) entry"
+	bridge mdb del dev br0 port $swp1 $grp_key vid 10
+	bridge mdb del dev br0 port $swp2 grp $grp vid 10
+
+	log_test "$name (S, G) port group entries configuration tests"
+}
+
+cfg_test_port_ip_sg()
+{
+	echo
+	log_info "# Port group entries configuration tests - (S, G)"
+
+	cfg_test_port_common "IPv4 (S, G)" "grp 239.1.1.1 src 192.0.2.1"
+	cfg_test_port_common "IPv6 (S, G)" "grp ff0e::1 src 2001:db8:1::1"
+	__cfg_test_port_ip_sg "IPv4" "239.1.1.1" "192.0.2.1"
+	__cfg_test_port_ip_sg "IPv6" "ff0e::1" "2001:db8:1::1"
+}
+
+cfg_test_port_ip()
+{
+	cfg_test_port_ip_star_g
+	cfg_test_port_ip_sg
+}
+
+__cfg_test_port_l2()
+{
+	local grp="01:02:03:04:05:06"
+
+	RET=0
+
+	bridge meb add dev br0 port $swp grp 00:01:02:03:04:05 \
+		permanent vid 10 &> /dev/null
+	check_fail $? "Managed to add an entry with unicast MAC"
+
+	bridge mdb add dev br0 port $swp grp $grp src 00:01:02:03:04:05 \
+		permanent vid 10 &> /dev/null
+	check_fail $? "Managed to add an entry with a source"
+
+	bridge mdb add dev br0 port $swp1 grp $grp permanent vid 10 \
+		filter_mode include &> /dev/null
+	check_fail $? "Managed to add an entry with a filter mode"
+
+	bridge mdb add dev br0 port $swp1 grp $grp permanent vid 10 \
+		source_list 00:01:02:03:04:05 &> /dev/null
+	check_fail $? "Managed to add an entry with a source list"
+
+	log_test "L2 (*, G) port group entries configuration tests"
+}
+
+cfg_test_port_l2()
+{
+	echo
+	log_info "# Port group entries configuration tests - L2"
+
+	cfg_test_port_common "L2 (*, G)" "grp 01:02:03:04:05:06"
+	__cfg_test_port_l2
+}
+
+# Check configuration of regular (port) entries of all types.
+cfg_test_port()
+{
+	cfg_test_port_ip
+	cfg_test_port_l2
+}
+
+cfg_test()
+{
+	cfg_test_host
+	cfg_test_port
+}
+
+__fwd_test_host_ip()
+{
+	local grp=$1; shift
+	local src=$1; shift
+	local mode=$1; shift
+	local name
+	local eth_type
+
+	RET=0
+
+	if [[ $mode == "-4" ]]; then
+		name="IPv4"
+		eth_type="ipv4"
+	else
+		name="IPv6"
+		eth_type="ipv6"
+	fi
+
+	tc filter add dev br0 ingress protocol 802.1q pref 1 handle 1 flower \
+		vlan_ethtype $eth_type vlan_id 10 dst_ip $grp src_ip $src \
+		action drop
+
+	# Packet should only be flooded to multicast router ports when there is
+	# no matching MDB entry. The bridge is not configured as a multicast
+	# router port.
+	$MZ $mode $h1.10 -c 1 -p 128 -A $src -B $grp -t udp -q
+	tc_check_packets "dev br0 ingress" 1 0
+	check_err $? "Packet locally received after flood"
+
+	# Install a regular port group entry and expect the packet to not be
+	# locally received.
+	bridge mdb add dev br0 port $swp2 grp $grp temp vid 10
+	$MZ $mode $h1.10 -c 1 -p 128 -A $src -B $grp -t udp -q
+	tc_check_packets "dev br0 ingress" 1 0
+	check_err $? "Packet locally received after installing a regular entry"
+
+	# Add a host entry and expect the packet to be locally received.
+	bridge mdb add dev br0 port br0 grp $grp temp vid 10
+	$MZ $mode $h1.10 -c 1 -p 128 -A $src -B $grp -t udp -q
+	tc_check_packets "dev br0 ingress" 1 1
+	check_err $? "Packet not locally received after adding a host entry"
+
+	# Remove the host entry and expect the packet to not be locally
+	# received.
+	bridge mdb del dev br0 port br0 grp $grp vid 10
+	$MZ $mode $h1.10 -c 1 -p 128 -A $src -B $grp -t udp -q
+	tc_check_packets "dev br0 ingress" 1 1
+	check_err $? "Packet locally received after removing a host entry"
+
+	bridge mdb del dev br0 port $swp2 grp $grp vid 10
+
+	tc filter del dev br0 ingress protocol 802.1q pref 1 handle 1 flower
+
+	log_test "$name host entries forwarding tests"
+}
+
+fwd_test_host_ip()
+{
+	__fwd_test_host_ip "239.1.1.1" "192.0.2.1" "-4"
+	__fwd_test_host_ip "ff0e::1" "2001:db8:1::1" "-6"
+}
+
+fwd_test_host_l2()
+{
+	local dmac=01:02:03:04:05:06
+
+	RET=0
+
+	tc filter add dev br0 ingress protocol all pref 1 handle 1 flower \
+		dst_mac $dmac action drop
+
+	# Packet should be flooded and locally received when there is no
+	# matching MDB entry.
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev br0 ingress" 1 1
+	check_err $? "Packet not locally received after flood"
+
+	# Install a regular port group entry and expect the packet to not be
+	# locally received.
+	bridge mdb add dev br0 port $swp2 grp $dmac permanent vid 10
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev br0 ingress" 1 1
+	check_err $? "Packet locally received after installing a regular entry"
+
+	# Add a host entry and expect the packet to be locally received.
+	bridge mdb add dev br0 port br0 grp $dmac permanent vid 10
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev br0 ingress" 1 2
+	check_err $? "Packet not locally received after adding a host entry"
+
+	# Remove the host entry and expect the packet to not be locally
+	# received.
+	bridge mdb del dev br0 port br0 grp $dmac permanent vid 10
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev br0 ingress" 1 2
+	check_err $? "Packet locally received after removing a host entry"
+
+	bridge mdb del dev br0 port $swp2 grp $dmac permanent vid 10
+
+	tc filter del dev br0 ingress protocol all pref 1 handle 1 flower
+
+	log_test "L2 host entries forwarding tests"
+}
+
+fwd_test_host()
+{
+	# Disable multicast router on the bridge to ensure that packets are
+	# only locally received when a matching host entry is present.
+	ip link set dev br0 type bridge mcast_router 0
+
+	fwd_test_host_ip
+	fwd_test_host_l2
+
+	ip link set dev br0 type bridge mcast_router 1
+}
+
+__fwd_test_port_ip()
+{
+	local grp=$1; shift
+	local valid_src=$1; shift
+	local invalid_src=$1; shift
+	local mode=$1; shift
+	local filter_mode=$1; shift
+	local name
+	local eth_type
+	local src_list
+
+	RET=0
+
+	if [[ $mode == "-4" ]]; then
+		name="IPv4"
+		eth_type="ipv4"
+	else
+		name="IPv6"
+		eth_type="ipv6"
+	fi
+
+	# The valid source is the one we expect to get packets from after
+	# adding the entry.
+	if [[ $filter_mode == "include" ]]; then
+		src_list=$valid_src
+	else
+		src_list=$invalid_src
+	fi
+
+	tc filter add dev $h2 ingress protocol 802.1q pref 1 handle 1 flower \
+		vlan_ethtype $eth_type vlan_id 10 dst_ip $grp \
+		src_ip $valid_src action drop
+	tc filter add dev $h2 ingress protocol 802.1q pref 1 handle 2 flower \
+		vlan_ethtype $eth_type vlan_id 10 dst_ip $grp \
+		src_ip $invalid_src action drop
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $valid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 1 0
+	check_err $? "Packet from valid source received on H2 before adding entry"
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $invalid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 2 0
+	check_err $? "Packet from invalid source received on H2 before adding entry"
+
+	bridge mdb add dev br0 port $swp2 grp $grp vid 10 \
+		filter_mode $filter_mode source_list $src_list
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $valid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 1 1
+	check_err $? "Packet from valid source not received on H2 after adding entry"
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $invalid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 2 0
+	check_err $? "Packet from invalid source received on H2 after adding entry"
+
+	bridge mdb replace dev br0 port $swp2 grp $grp vid 10 \
+		filter_mode exclude
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $valid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 1 2
+	check_err $? "Packet from valid source not received on H2 after allowing all sources"
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $invalid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 2 1
+	check_err $? "Packet from invalid source not received on H2 after allowing all sources"
+
+	bridge mdb del dev br0 port $swp2 grp $grp vid 10
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $valid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 1 2
+	check_err $? "Packet from valid source received on H2 after deleting entry"
+
+	$MZ $mode $h1.10 -c 1 -p 128 -A $invalid_src -B $grp -t udp -q
+	tc_check_packets "dev $h2 ingress" 2 1
+	check_err $? "Packet from invalid source received on H2 after deleting entry"
+
+	tc filter del dev $h2 ingress protocol 802.1q pref 1 handle 2 flower
+	tc filter del dev $h2 ingress protocol 802.1q pref 1 handle 1 flower
+
+	log_test "$name port group \"$filter_mode\" entries forwarding tests"
+}
+
+fwd_test_port_ip()
+{
+	__fwd_test_port_ip "239.1.1.1" "192.0.2.1" "192.0.2.2" "-4" "exclude"
+	__fwd_test_port_ip "ff0e::1" "2001:db8:1::1" "2001:db8:1::2" "-6" \
+		"exclude"
+	__fwd_test_port_ip "239.1.1.1" "192.0.2.1" "192.0.2.2" "-4" "include"
+	__fwd_test_port_ip "ff0e::1" "2001:db8:1::1" "2001:db8:1::2" "-6" \
+		"include"
+}
+
+fwd_test_port_l2()
+{
+	local dmac=01:02:03:04:05:06
+
+	RET=0
+
+	tc filter add dev $h2 ingress protocol all pref 1 handle 1 flower \
+		dst_mac $dmac action drop
+
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev $h2 ingress" 1 0
+	check_err $? "Packet received on H2 before adding entry"
+
+	bridge mdb add dev br0 port $swp2 grp $dmac permanent vid 10
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev $h2 ingress" 1 1
+	check_err $? "Packet not received on H2 after adding entry"
+
+	bridge mdb del dev br0 port $swp2 grp $dmac permanent vid 10
+	$MZ $h1.10 -c 1 -p 128 -a own -b $dmac -q
+	tc_check_packets "dev $h2 ingress" 1 1
+	check_err $? "Packet received on H2 after deleting entry"
+
+	tc filter del dev $h2 ingress protocol all pref 1 handle 1 flower
+
+	log_test "L2 port entries forwarding tests"
+}
+
+fwd_test_port()
+{
+	# Disable multicast flooding to ensure that packets are only forwarded
+	# out of a port when a matching port group entry is present.
+	bridge link set dev $swp2 mcast_flood off
+
+	fwd_test_port_ip
+	fwd_test_port_l2
+
+	bridge link set dev $swp2 mcast_flood on
+}
+
+fwd_test()
+{
+	echo
+	log_info "# Forwarding tests"
+
+	# Forwarding according to MDB entries only takes place when the bridge
+	# detects that there is a valid querier in the network. Set the bridge
+	# as the querier and assign it a valid IPv6 link-local address to be
+	# used as the source address for MLD queries.
+	ip -6 address add fe80::1/64 nodad dev br0
+	ip link set dev br0 type bridge mcast_querier 1
+	# Wait the default Query Response Interval (10 seconds) for the bridge
+	# to determine that there are no other queriers in the network.
+	sleep 10
+
+	fwd_test_host
+	fwd_test_port
+
+	ip link set dev br0 type bridge mcast_querier 0
+	ip -6 address del fe80::1/64 dev br0
+}
+
+igmpv3_is_in_get()
+{
+	local igmpv3
+
+	igmpv3=$(:
+		)"22:"$(			: Type - Membership Report
+		)"00:"$(			: Reserved
+		)"2a:f8:"$(			: Checksum
+		)"00:00:"$(			: Reserved
+		)"00:01:"$(			: Number of Group Records
+		)"01:"$(			: Record Type - IS_IN
+		)"00:"$(			: Aux Data Len
+		)"00:01:"$(			: Number of Sources
+		)"ef:01:01:01:"$(		: Multicast Address - 239.1.1.1
+		)"c0:00:02:02"$(		: Source Address - 192.0.2.2
+		)
+
+	echo $igmpv3
+}
+
+ctrl_igmpv3_is_in_test()
+{
+	RET=0
+
+	# Add a permanent entry and check that it is not affected by the
+	# received IGMP packet.
+	bridge mdb add dev br0 port $swp1 grp 239.1.1.1 permanent vid 10 \
+		filter_mode include source_list 192.0.2.1
+
+	# IS_IN ( 192.0.2.2 )
+	$MZ $h1.10 -c 1 -A 192.0.2.1 -B 239.1.1.1 \
+		-t ip proto=2,p=$(igmpv3_is_in_get) -q
+
+	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | grep -q 192.0.2.2
+	check_fail $? "Permanent entry affected by IGMP packet"
+
+	# Replace the permanent entry with a temporary one and check that after
+	# processing the IGMP packet, a new source is added to the list along
+	# with a new forwarding entry.
+	bridge mdb replace dev br0 port $swp1 grp 239.1.1.1 temp vid 10 \
+		filter_mode include source_list 192.0.2.1
+
+	# IS_IN ( 192.0.2.2 )
+	$MZ $h1.10 -c 1 -A 192.0.2.1 -B 239.1.1.1 \
+		-t ip proto=2,p=$(igmpv3_is_in_get) -q
+
+	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | grep -v "src" | \
+		grep -q 192.0.2.2
+	check_err $? "Source not add to source list"
+
+	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | \
+		grep -q "src 192.0.2.2"
+	check_err $? "(S, G) entry not created for new source"
+
+	bridge mdb del dev br0 port $swp1 grp 239.1.1.1 vid 10
+
+	log_test "IGMPv3 MODE_IS_INCLUE tests"
+}
+
+mldv2_is_in_get()
+{
+	local hbh
+	local icmpv6
+
+	hbh=$(:
+		)"3a:"$(			: Next Header - ICMPv6
+		)"00:"$(			: Hdr Ext Len
+		)"00:00:00:00:00:00:"$(		: Options and Padding
+		)
+
+	icmpv6=$(:
+		)"8f:"$(			: Type - MLDv2 Report
+		)"00:"$(			: Code
+		)"45:39:"$(			: Checksum
+		)"00:00:"$(			: Reserved
+		)"00:01:"$(			: Number of Group Records
+		)"01:"$(			: Record Type - IS_IN
+		)"00:"$(			: Aux Data Len
+		)"00:01:"$(			: Number of Sources
+		)"ff:0e:00:00:00:00:00:00:"$(	: Multicast address - ff0e::1
+		)"00:00:00:00:00:00:00:01:"$(	:
+		)"20:01:0d:b8:00:01:00:00:"$(	: Source Address - 2001:db8:1::2
+		)"00:00:00:00:00:00:00:02:"$(	:
+		)
+
+	echo ${hbh}${icmpv6}
+}
+
+ctrl_mldv2_is_in_test()
+{
+	RET=0
+
+	# Add a permanent entry and check that it is not affected by the
+	# received MLD packet.
+	bridge mdb add dev br0 port $swp1 grp ff0e::1 permanent vid 10 \
+		filter_mode include source_list 2001:db8:1::1
+
+	# IS_IN ( 2001:db8:1::2 )
+	$MZ -6 $h1.10 -c 1 -A fe80::1 -B ff0e::1 \
+		-t ip hop=1,next=0,p=$(mldv2_is_in_get) -q
+
+	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | \
+		grep -q 2001:db8:1::2
+	check_fail $? "Permanent entry affected by MLD packet"
+
+	# Replace the permanent entry with a temporary one and check that after
+	# processing the MLD packet, a new source is added to the list along
+	# with a new forwarding entry.
+	bridge mdb replace dev br0 port $swp1 grp ff0e::1 temp vid 10 \
+		filter_mode include source_list 2001:db8:1::1
+
+	# IS_IN ( 2001:db8:1::2 )
+	$MZ -6 $h1.10 -c 1 -A fe80::1 -B ff0e::1 \
+		-t ip hop=1,next=0,p=$(mldv2_is_in_get) -q
+
+	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | grep -v "src" | \
+		grep -q 2001:db8:1::2
+	check_err $? "Source not add to source list"
+
+	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | \
+		grep -q "src 2001:db8:1::2"
+	check_err $? "(S, G) entry not created for new source"
+
+	bridge mdb del dev br0 port $swp1 grp ff0e::1 vid 10
+
+	log_test "MLDv2 MODE_IS_INCLUDE tests"
+}
+
+ctrl_test()
+{
+	echo
+	log_info "# Control packets tests"
+
+	ctrl_igmpv3_is_in_test
+	ctrl_mldv2_is_in_test
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.37.3

