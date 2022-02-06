Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB96A4AB04B
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbiBFPhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 10:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244020AbiBFPhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 10:37:40 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371CDC043189
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 07:37:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO374YcKiiTRU21Okzu2FB/+bCN5QZEyuYULRMEYEduoUMYe/qigw/w7M/vuT3qz/nhTlngY0NXL8CNgydqKvibGJtPg9oBIuK0L/bZ0yBkVgaw9xgrtpP15ZWoPA+KMiFoIpZ7qOVo3tr6fDH7Ft4akLHrCeIRuFiGMejXgNkN0TEJcsmskp31A1d87DhjdLz+Muz4vcrMfdfM2hHARF9IlUalepXU9q67lAHIdggiMIah+N0bYigtOZTbMoIp813d4m4BphrRPOa7o9c/d/cKF6k/ngu4oJQjyn2q1pn77g1FO92Xe9IjMryuTQVmhdtX9Dqo4O+4xn29dqdr03A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGNysapJmQG4vrxgE2eKWvUNBAwgLkYOCBw7uNwQs6g=;
 b=JKW4sFmz/78r5Qz81/xGTIjCIHwAcbgGhYIxl/RoYL+aapqEy8DHXvfK6YKR6+zFhroyQzWFeLUeIzn/V2YjrEddKNGEt3EwGF+TnBOPAeA0ZH9FHsoTr15rA426h3aYD7B2v6XiqPNjRNsf/QAI1BmydmnDoTDstUoKU78ZjQ8RkEnzu2jBYSEXjj7aUeXwHX/dQhZFYYQhVqr88vnj9z7yuQh17O483HqaVH+Ya9Qv97xbiA2bl5XbuNFSzid/cLo9wW96/FnnnQHwZY7weWO1fJd2+oyXoSVzjrBH6zL9A4lTxCbnMkHwIHIgnw6xV/c4qhIislSGUZPvw6+BDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGNysapJmQG4vrxgE2eKWvUNBAwgLkYOCBw7uNwQs6g=;
 b=nmPTyMMep185hTvcUduQq8h0p+I8mU/GjnrKSD9/C+adSEP8jWq/QfK08U2OGOpCheilHLwx97kZeoDcKhpvR4OrVC2NvOJSuu0emJf+SZ22ZKIuEnzKmyBA1WKn3/DHeHUpdLLZZfzsDOnKzg6N6PV5lKEGuGns+HI/pmYK8eMtYdgYodnr/519xW9JaLGPOKZ8yn7wbX0v6V7Z8pi5K0Wfym2wmQW71IzSab5gqqC+8EdYxmGvDdBGfRJnp/H+oXw7RvQFdmM8dLDEP2S+aS0Qz7cGO4r/HwvR/V7sP6behb7vYZMe0Ti0daKxr67icPTDMVsEgChLhJW5hJBGlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN8PR12MB3395.namprd12.prod.outlook.com (2603:10b6:408:43::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sun, 6 Feb
 2022 15:37:36 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::5cff:a12b:dfa4:3eff%3]) with mapi id 15.20.4951.018; Sun, 6 Feb 2022
 15:37:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] selftests: forwarding: Add a test for pedit munge SIP and DIP
Date:   Sun,  6 Feb 2022 17:36:13 +0200
Message-Id: <20220206153613.763944-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220206153613.763944-1-idosch@nvidia.com>
References: <20220206153613.763944-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0026.eurprd07.prod.outlook.com
 (2603:10a6:800:90::12) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a28f4d15-1a49-4d59-a766-08d9e98699d1
X-MS-TrafficTypeDiagnostic: BN8PR12MB3395:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB33959B755551C430C56ABE87B22B9@BN8PR12MB3395.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7FCxa6AR5Kt85VkFV+cLt/JLXI1pMLP58s6OsHpkpffhmdMEdFVPj6qX1MxQxBpfrL2NhxiaKAV8yG9YQAQnO2zVbhnACqTuwXY33fKd/EqjugAstPBcqXS6+Kb+HBoD24BIBHlkj0E2KGhrMNf4u4A0+nmsJxjKW5dol/MZ9UEqfv8+0Ii6dkxI0BJW23egILtsiqe39i/UIIlnwAXMairk1VwJvgjSrYmyJXgO4bxeU/z7LQEyW+KlLK0plizHkVo5yBf9XXn1CclQtBlmXyMSX5gkUNv+NL5e1iN97B9rikA0oufiIbSceN6WrAKNC4PVOt5ij6qTFo56ekh1gmOwLkOhjOv6JWnng1/am0ghhZGoOjekTXgQeq5ZTn+cydt9GfXPLlsRbO7UdJemchx3fsEzmpO73rTxfIzAAxKefAMzjwXSZyw+6FbfnA/xl/4VTt3McFlw3eWb3p8rXz0quup0XAsLUxy91Zbe4iL1mbffYDpk0m9HJWTPBMDP5/OA87H2108jnm7sjdeO1tnQoj01UHkQQucfb2XlmiYcmQ1f+3AT66USX+o4k3DOa9k39ADIJ/umbLx45N2NyPESb3hxXLkdsPhTlpuORWc7EkzsBgSgJrV5T9aSGXjeKIPrasW+raJ/XYXReZUGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(26005)(186003)(6506007)(6666004)(6512007)(5660300002)(6916009)(316002)(36756003)(8676002)(4326008)(2906002)(66556008)(66476007)(86362001)(8936002)(66946007)(508600001)(107886003)(1076003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqszi9w6deIG7T5E2jXTTCtL0vNe8XRzafDLZWtgosjhQcxblL3aOBZGYXjC?=
 =?us-ascii?Q?3PfD09UV/+dhwIE1fuqVzPv8mWVoioKxV9o03pR4RQp5wFMkgLFA8SWuiWD0?=
 =?us-ascii?Q?gMEQ5kbSYNAN8V+rWsPgJ9DssrNNDKKzmJBP+koIDKa3xVNob7cIWmJroPC8?=
 =?us-ascii?Q?5GhrcQLwgaKWGLwDOXpfdw/iv4ciGcYjnJIyVgBl7Yn5Ihm9gGPWrOn5KFMv?=
 =?us-ascii?Q?IIswuVZv1MLkGCh+JvLAolO7PWjEMYmWpphXWyXKz32LqZgrguonZ/E+Lbfu?=
 =?us-ascii?Q?jjzfUxOcwiOaBJnuFVdKArDQTvjr4SwsZxkjt5g3nIGn+bkPIbDQbZmwbMUi?=
 =?us-ascii?Q?9pm8HEM/Og0CaEkCNi+PsWc8GgYblISlxFHkg2VW9fXhaeUZi8uld89G4eKj?=
 =?us-ascii?Q?fLtrEamaio2rv3vmyhfWTDDRHOe/ywAN1xXfnetsKIEWCZ/Mcn6CKrde8BBD?=
 =?us-ascii?Q?EDU29FbdVSUuX22JCB/5iKHk2PIGFEHNeWwBbh8pwDaempf6b7LGQBB+jPxs?=
 =?us-ascii?Q?OKIeW1/dA1Yaex8gvrome+nA54lRalrkPy7mWMy5NcpD5GFJhyqew0Mb97jK?=
 =?us-ascii?Q?ACI5SosT64EJDJvcXTEO2h/Mxhi6CVJ6U89NFHSNnBS8JMMJE+6tag3vOJjw?=
 =?us-ascii?Q?5pSyKHkkTBndy7Z3w+yBmzymTMK9Pm1ZJQtDSs22YhqlIxLdR30SUjKCAsha?=
 =?us-ascii?Q?cFotEvywNA4En+IQh42tU/qOyJDTiWuvpQSZasnsdMTzkTj3vSemOR6mAfaT?=
 =?us-ascii?Q?zjj91TjHpEl9d2++1+G7GCz5BbfLYR1Q4xXaWTqtwI0TUtzI0bEEJkR04xHn?=
 =?us-ascii?Q?Gf67yLcjBRAu6ZwWTmvONsDtscgIHsUWkr3KvJ81wGXET/trbFmXZ9bYZKFW?=
 =?us-ascii?Q?0NCb2Qzt0Qzom/aX+ahhH8VtccIFsL5tZ4APcZwkCnXoPnfu4cNFo3t6FQKL?=
 =?us-ascii?Q?uBhpAHJwhO9X/QrHtTnIlwYX/aAPQqLmoVLJ3RqG7UZamgyoe6bC/9Uy4sRI?=
 =?us-ascii?Q?C7wXHpJ+0U8f97Fz3icOCf8yuECTRCMEVpNow1WwNmN3dKv46hM9CIf7p631?=
 =?us-ascii?Q?GMWCGw6ek1r2Z43s/ZpTnMDbo8MF4trW3rmmxa3ISrpZMuErU12xXm4URftS?=
 =?us-ascii?Q?EPHZ7fQ3ki/2dLly9K6CUH5zvu6X7LvX+P1VbtqKT29uGciwfX0nBNdRYOzv?=
 =?us-ascii?Q?M7wO+O4eOutTgW0YH0+gZhi1ndl55RZ0PV2Nw5PZ9UvYSvUQ/eVlE++zSGCT?=
 =?us-ascii?Q?q5HTuwpDMVoeZf0TcIzCOBo+B0/+NSKjv56wwYHaUoRtCRUde6N9t7YXpaP9?=
 =?us-ascii?Q?CmAzuGBIEmt7NVe2RrytviSqCEUCd3K68AG9lnULntfQF4G4I0k+R4vpIhJd?=
 =?us-ascii?Q?zWVojDbxPKmPU6dHYfLbJnPRw3t5q2AvuvepJWT8VJq71ci+41+lC5NGTBte?=
 =?us-ascii?Q?aZisQ4IvLRs5jvksVNrn1YjMY5YLlbuNmllxUEKrhKvr9F5RBfvxHydQMQiu?=
 =?us-ascii?Q?z/j6JPXxuf3vGzxty3Q/GVvKuAhq5Beu8uxC19cCba9Hkxt6d1PiRaOcRsRj?=
 =?us-ascii?Q?vsmpvuakpWjD8zP0C304FR32r34nyn6V+3vZNLXZWGF+KWqMX1B46+mGz+Vz?=
 =?us-ascii?Q?bcqeRbzSv2zLGPcqMUx1YFo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28f4d15-1a49-4d59-a766-08d9e98699d1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2022 15:37:36.7210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vg/MRmu0EnUspNnlXgXv5lHRKa3xG2dN5QNoUjDFKCKtPWEgvYpG5drFA5+jDLi2jVOhYLtItn0eM7xNabLeow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3395
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add a test that checks that pedit adjusts source and destination
addresses of IPv4 and IPv6 packets.

Output example:

$ ./pedit_ip.sh
TEST: ping                                                          [ OK ]
TEST: ping6                                                         [ OK ]
TEST: dev swp2 ingress pedit ip src set 198.51.100.1                [ OK ]
TEST: dev swp3 egress pedit ip src set 198.51.100.1                 [ OK ]
TEST: dev swp2 ingress pedit ip dst set 198.51.100.1                [ OK ]
TEST: dev swp3 egress pedit ip dst set 198.51.100.1                 [ OK ]
TEST: dev swp2 ingress pedit ip6 src set 2001:db8:2::1              [ OK ]
TEST: dev swp3 egress pedit ip6 src set 2001:db8:2::1               [ OK ]
TEST: dev swp2 ingress pedit ip6 dst set 2001:db8:2::1              [ OK ]
TEST: dev swp3 egress pedit ip6 dst set 2001:db8:2::1               [ OK ]

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/pedit_ip.sh      | 201 ++++++++++++++++++
 1 file changed, 201 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_ip.sh

diff --git a/tools/testing/selftests/net/forwarding/pedit_ip.sh b/tools/testing/selftests/net/forwarding/pedit_ip.sh
new file mode 100755
index 000000000000..d14efb2d23b2
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/pedit_ip.sh
@@ -0,0 +1,201 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test sends traffic from H1 to H2. Either on ingress of $swp1, or on
+# egress of $swp2, the traffic is acted upon by a pedit action. An ingress
+# filter installed on $h2 verifies that the packet looks like expected.
+#
+# +----------------------+                             +----------------------+
+# | H1                   |                             |                   H2 |
+# |    + $h1             |                             |            $h2 +     |
+# |    | 192.0.2.1/28    |                             |   192.0.2.2/28 |     |
+# +----|-----------------+                             +----------------|-----+
+#      |                                                                |
+# +----|----------------------------------------------------------------|-----+
+# | SW |                                                                |     |
+# |  +-|----------------------------------------------------------------|-+   |
+# |  | + $swp1                       BR                           $swp2 + |   |
+# |  +--------------------------------------------------------------------+   |
+# +---------------------------------------------------------------------------+
+
+ALL_TESTS="
+	ping_ipv4
+	ping_ipv6
+	test_ip4_src
+	test_ip4_dst
+	test_ip6_src
+	test_ip6_dst
+"
+
+NUM_NETIFS=4
+source lib.sh
+source tc_common.sh
+
+h1_create()
+{
+	simple_if_init $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 192.0.2.1/28 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 192.0.2.2/28 2001:db8:1::2/64
+	tc qdisc add dev $h2 clsact
+}
+
+h2_destroy()
+{
+	tc qdisc del dev $h2 clsact
+	simple_if_fini $h2 192.0.2.2/28 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	ip link add name br1 up type bridge vlan_filtering 1
+	ip link set dev $swp1 master br1
+	ip link set dev $swp1 up
+	ip link set dev $swp2 master br1
+	ip link set dev $swp2 up
+
+	tc qdisc add dev $swp1 clsact
+	tc qdisc add dev $swp2 clsact
+}
+
+switch_destroy()
+{
+	tc qdisc del dev $swp2 clsact
+	tc qdisc del dev $swp1 clsact
+
+	ip link set dev $swp2 down
+	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
+	ip link set dev $swp1 nomaster
+	ip link del dev br1
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
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
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
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.2
+}
+
+ping_ipv6()
+{
+	ping6_test $h1 2001:db8:1::2
+}
+
+do_test_pedit_ip()
+{
+	local pedit_locus=$1; shift
+	local pedit_action=$1; shift
+	local match_prot=$1; shift
+	local match_flower=$1; shift
+	local mz_flags=$1; shift
+
+	tc filter add $pedit_locus handle 101 pref 1 \
+	   flower action pedit ex munge $pedit_action
+	tc filter add dev $h2 ingress handle 101 pref 1 prot $match_prot \
+	   flower skip_hw $match_flower action pass
+
+	RET=0
+
+	$MZ $mz_flags $h1 -c 10 -d 20msec -p 100 -a own -b $h2mac -q -t ip
+
+	local pkts
+	pkts=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= 10" \
+			tc_rule_handle_stats_get "dev $h2 ingress" 101)
+	check_err $? "Expected to get 10 packets, but got $pkts."
+
+	pkts=$(tc_rule_handle_stats_get "$pedit_locus" 101)
+	((pkts >= 10))
+	check_err $? "Expected to get 10 packets on pedit rule, but got $pkts."
+
+	log_test "$pedit_locus pedit $pedit_action"
+
+	tc filter del dev $h2 ingress pref 1
+	tc filter del $pedit_locus pref 1
+}
+
+do_test_pedit_ip6()
+{
+	local locus=$1; shift
+	local pedit_addr=$1; shift
+	local flower_addr=$1; shift
+
+	do_test_pedit_ip "$locus" "$pedit_addr set 2001:db8:2::1" ipv6	\
+			 "$flower_addr 2001:db8:2::1"			\
+			 "-6 -A 2001:db8:1::1 -B 2001:db8:1::2"
+}
+
+do_test_pedit_ip4()
+{
+	local locus=$1; shift
+	local pedit_addr=$1; shift
+	local flower_addr=$1; shift
+
+	do_test_pedit_ip "$locus" "$pedit_addr set 198.51.100.1" ip	\
+			 "$flower_addr 198.51.100.1"			\
+			 "-A 192.0.2.1 -B 192.0.2.2"
+}
+
+test_ip4_src()
+{
+	do_test_pedit_ip4 "dev $swp1 ingress" "ip src" src_ip
+	do_test_pedit_ip4 "dev $swp2 egress"  "ip src" src_ip
+}
+
+test_ip4_dst()
+{
+	do_test_pedit_ip4 "dev $swp1 ingress" "ip dst" dst_ip
+	do_test_pedit_ip4 "dev $swp2 egress"  "ip dst" dst_ip
+}
+
+test_ip6_src()
+{
+	do_test_pedit_ip6 "dev $swp1 ingress" "ip6 src" src_ip
+	do_test_pedit_ip6 "dev $swp2 egress"  "ip6 src" src_ip
+}
+
+test_ip6_dst()
+{
+	do_test_pedit_ip6 "dev $swp1 ingress" "ip6 dst" dst_ip
+	do_test_pedit_ip6 "dev $swp2 egress"  "ip6 dst" dst_ip
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.33.1

