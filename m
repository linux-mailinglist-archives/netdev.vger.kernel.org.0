Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEE66BB43C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjCONPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCONP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:15:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ADFC662
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:15:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLF6Dbstrd9xzTKBnnWlkFfwaREQN06tzZ9ik2DGbgk6mCZ7mxCpGQSM3I3DYkPMFjCnUQGS6ZjuDPmwi6G0Tc3KXXLVbXF+WXsMR4bCpwH1aN59/V3DlSEENP0xl8Jx76pqX3mnMsZus1Y7AbdyuPE+iVOsEs48desXn8TI9U/TuPiy+w/3p9hDLjlX+jycvrpaJ5ufDx1M89rgcN2uuanpfn9RIcmeksEU31n/2Eb/yEqLMOaFJY+kJSSlnZxtY5yNfFO3fp1K0G/dALA9M//BiMmMnRVIRAnXzcO67Al6Ht/ySIFtnWqeEZyRZWodCiWs5Vcvq+Xra7kulfpObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2PPy+b4QgnHmp4mb26qt3dgxivHQGOBKDomhDMRspU=;
 b=IpBaRqD/b4G8rMZkLwmHwCm7k6N5T2CdFuSthUeCpG2VA3hmn+8pENZjOP+2B1DaAWU+a6ibiYpyMiuRT6rbmBeNkXd2kgOApXm/DBBcPVoR69pnvcg4N7rVTPxAuqTSkCLs3fvDNyJhcjra4VcKSUmXTPm1WPz6t/vIPQwZXuPpyFvlIY94gqFhXlIhSf2kF0YtzwO4LvVEIK++40HU0UpMxUwaRvjZIJggih8riIBElFdJDSWmKjYDqqmCGeR3JBEgmEu4sVOCGQizX18tGaN6HAbq27VAxCwwWcq2MBdIdAsJ+dBReOcMTrInFm4pHwdzOUlq1ZOWsY8QAyWm1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2PPy+b4QgnHmp4mb26qt3dgxivHQGOBKDomhDMRspU=;
 b=hSR0wYjOwRip/5S/ZQEIVFemxWyegDe5C70gHMT1anCWUm9CopaDT3rAWZk0IdLfJovZE5+g6l8iXtbRpOfyIpwddApCoKqRtEUM4jYFHR33vd+3AOphf1epOFct7HWk55J9l7sFjSH8W8CAirETz/H0Y0pMw3nGRfcH+gUym+d8fj3nHhJHW6MCFzAihC41sqllToayJmeHkk4suQWdwd+ISAT7hBU33wKCtTKAMFvFu0o6/C8tO3b7CqQDXJkVSNw1MLstSA60ak2NsZ2HSUDnHhh7OqJmwOHPd/3aaFrpefH1kZExp82/AhuyQi6nOmSaxzTY97rr0TtBZ3yJag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 13:14:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:14:14 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 11/11] selftests: net: Add VXLAN MDB test
Date:   Wed, 15 Mar 2023 15:11:55 +0200
Message-Id: <20230315131155.4071175-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0186.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: c26b5961-7d0e-4596-fbb5-08db25572c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xaiAUsNpmzMb10EiCDWklPv1ctA3tnd6DKlfWi0iyfOSpkHMoaADtW6l41grx5oE5U6VDXd6mv81L/RH10Cpk4KJ9o4j9DvqPaePwWRmW8+gHUYBcmhqUaOFoWRGACIlJYXW4WjzQfaE3R1u1pzpmsBL5puYZS/pWloNzAytqNsIrzl6D6FVaTCQXb2Imdeuv85QkqtTxysgXcukGoHfTrThaE24XAdhkGNd65FrrBdcAqeqASp7RnXtxS6cNMj5A9FQbnun1sWWJdbd0AwXW7NDJVbZEklAcyCvYBkF9utAMrqNa7sl3E6NPDpXFBCbK3K9aHScEZAn/vLUtzcCF9SqSSD2yYSjwUSqzB6PaQyx9B/6GM7XrP5ucKmmDvd/T1KSVYe2a61FYIdveEk5OyqPSfab7zm33wtJonWa/4NTYtiEmY5UeQG++fAX0digCM2u9ZCpqrY1zDv6fydFXu5w2fbmak6/JRLUroIdx8+hajkFjj3WfOz7HSSIEZ2l00+7K+pAFyE47F0cFL3au7Je/qddlqVORCkyGqXzEx2DxrMvsaafkVslJA1buznnthN9akjzCh+DswdsbjSV5MZMgaAcBoG6Vy8Hr0FDxqWw6IJq8oryGSQJvjGa+Ii3LGQkNHOgXQmvzp0BRYKGN/E2hrkWLZbCr5XyryzQjbCMGbGWCVMmv/7dlluGf5E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(86362001)(36756003)(38100700002)(2906002)(30864003)(8936002)(5660300002)(41300700001)(4326008)(2616005)(1076003)(6512007)(186003)(6506007)(83380400001)(26005)(316002)(66476007)(8676002)(66946007)(66556008)(107886003)(6666004)(6486002)(966005)(478600001)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9KtZSdqN5BdX/kQo2gJBuzmzViRWq7o5nrsflqPqpjt1w6zqV6XmUg/5sHFR?=
 =?us-ascii?Q?NCGc5RyqgJRg4TT8tseXegGeQ8NeeOVIoyHUF4xmJnkCUpPLiFBaCbD6Iqi3?=
 =?us-ascii?Q?4/9dGYZ/kypKA0yV+c4ua9fPmeSqqdQtuwsvT7jAktpy0EijvZxyBLcz1v+w?=
 =?us-ascii?Q?Qqs1P5HJ+Tuf7CJzmHs2mdzDnkEwWEXsyHYXBaKKOJLcdzKSoEntNGW6Wiu9?=
 =?us-ascii?Q?stpiOGA+vWYS6Dvsi5/+RJ4rP9F7xXD+vwSHIhiGHTDrziMyn3R66GKNZKJ/?=
 =?us-ascii?Q?F/fP+lfe9w9lnk4zWUoWkcmHwzZbFObfwQNcQDN9Wdb83EbSzDY8b34srB6b?=
 =?us-ascii?Q?3h21oxMaqk7YQkUUtY5+64myNJrjv5JemkctG4ivCms//X9P3teAK+kB8WAq?=
 =?us-ascii?Q?L6GviGV1bbG0wC21d/SIjKal5UTPq8G0pnc0W7oxhjA4MI4sofaQrT8zc+HH?=
 =?us-ascii?Q?0Ja082fschdivyv+X7pYjlgKzGlJNbj6dae9xUH9qlHjle1kXjZ129V3o2fe?=
 =?us-ascii?Q?M/omIkQdh7+AMeZrwPK4WiN3Xbj0j3dIxFN/XjpnggXODedTsw3mP2mmp9av?=
 =?us-ascii?Q?1pEPbmeW8P9PWmJcY1opRnzRhVjSPUvOIPr+sRe9XLhRTc3CFvEdMPI4QEiT?=
 =?us-ascii?Q?/u5RqrnvWmHyeZF5E1oW2p3CiTyU+f5ogkBLzcIyg81FmfjuTbO0B2rn9Hfj?=
 =?us-ascii?Q?99WlBwIKqV5KRoNtJYxheOWe5yMgdzh3zW7DicCdPycT4WHHGFnTfroLf039?=
 =?us-ascii?Q?BO9fgLGQBo4SUcPonpbMeea3MUTK4PetzGl83nGj4NGVG3jUsaJPeOOPr408?=
 =?us-ascii?Q?X2e2WWHJLub+FCg9F1FMXQvqrdokJZqUAp6Usvi8uEbg45fPGqPQ4XPhCCwJ?=
 =?us-ascii?Q?5Fhk0F50MkTEhmjqCN2+ad9KvcH7MSt4z2fOIVRWeHal5xSZx0rXRNnMRBl2?=
 =?us-ascii?Q?lUWL3nt2IXfPHE5+VQtfPTmcNxnAmZKJYw3pe26sPBBDQSwg2S+ZAwM5VYb3?=
 =?us-ascii?Q?hBgbEbvvamdVOLn1LHCekc1eMluvGmtQVp2rp5ku/6LULzgVXF59fA5lNbDO?=
 =?us-ascii?Q?afbQU3j7SzORom5Col4ISHs7HN3j4fqRaxnkfSi588flNh7diVzFifiYSVS5?=
 =?us-ascii?Q?lHRojuN3lb0eDmzM7Dqt98wO6lkcKfbhMoJ+tfD5pgF4qMU74O6ZadVQ/PSP?=
 =?us-ascii?Q?XoxPI5wlfwV+ahcB2wJqT7Fa9QSJmyY3+GBXCfqGTpfSuPADAN++a/3p2s/r?=
 =?us-ascii?Q?dA+9u0zzsjI86OwKKNAaMBCWVL13xnBTFIQAGGoAADi4C90cvsZPETBoZwpr?=
 =?us-ascii?Q?u0TuyNEtJ2EkHTgASCP5+lP1LtEuBljy0rt+xa2v5sROquuK1q2H6kooHrfw?=
 =?us-ascii?Q?PTPKW/qxYgVl5k2ZeBWLdflBE2r9AfggSQGZfFI+Za8df28XWSbCItYpxOZ3?=
 =?us-ascii?Q?LWjcOmbRKxiB4/6z0qut98yi8PeXxUgXlcUmCOyFTHBRf3h2Bz3y0x1Updpr?=
 =?us-ascii?Q?nFeJ9/Dn9Sa8CQ+aIfloOTqQ1nsUF3tlmYdwg+AOGUX3Tve99kpiciY11k9H?=
 =?us-ascii?Q?Ov1Yl3tHx7f03Nah1BpA1NYoUQxiv8ROAqZ+bqlr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26b5961-7d0e-4596-fbb5-08db25572c8f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:14:14.7916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNy9VYrWaaITiH1Bbc43mi7R13RnZfw+KFuWTSeKNZ19vjl1B4PkU4zRpxLzJ/OdJFQ3/p9mGRWg0mUTjyMzHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test cases for VXLAN MDB, testing the control and data paths. Two
different sets of namespaces (i.e., ns{1,2}_v4 and ns{1,2}_v6) are used
in order to test VXLAN MDB with both IPv4 and IPv6 underlays,
respectively.

Example truncated output:

 # ./test_vxlan_mdb.sh
 [...]
 Tests passed: 620
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v1:
    * New patch.

 tools/testing/selftests/net/Makefile          |    1 +
 tools/testing/selftests/net/config            |    1 +
 tools/testing/selftests/net/test_vxlan_mdb.sh | 2318 +++++++++++++++++
 3 files changed, 2320 insertions(+)
 create mode 100755 tools/testing/selftests/net/test_vxlan_mdb.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 099741290184..a179fbd6f972 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -81,6 +81,7 @@ TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
 TEST_GEN_FILES += nat6to4.o
 TEST_GEN_FILES += ip_local_port_range
+TEST_PROGS += test_vxlan_mdb.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index cc9fd55ab869..4c7ce07afa2f 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -48,3 +48,4 @@ CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
 CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
+CONFIG_VXLAN=m
diff --git a/tools/testing/selftests/net/test_vxlan_mdb.sh b/tools/testing/selftests/net/test_vxlan_mdb.sh
new file mode 100755
index 000000000000..31e5f0f8859d
--- /dev/null
+++ b/tools/testing/selftests/net/test_vxlan_mdb.sh
@@ -0,0 +1,2318 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking VXLAN MDB functionality. The topology consists of
+# two sets of namespaces: One for the testing of IPv4 underlay and another for
+# IPv6. In both cases, both IPv4 and IPv6 overlay traffic are tested.
+#
+# Data path functionality is tested by sending traffic from one of the upper
+# namespaces and checking using ingress tc filters that the expected traffic
+# was received by one of the lower namespaces.
+#
+# +------------------------------------+ +------------------------------------+
+# | ns1_v4                             | | ns1_v6                             |
+# |                                    | |                                    |
+# |    br0.10    br0.4000  br0.20      | |    br0.10    br0.4000  br0.20      |
+# |       +         +         +        | |       +         +         +        |
+# |       |         |         |        | |       |         |         |        |
+# |       |         |         |        | |       |         |         |        |
+# |       +---------+---------+        | |       +---------+---------+        |
+# |                 |                  | |                 |                  |
+# |                 |                  | |                 |                  |
+# |                 +                  | |                 +                  |
+# |                br0                 | |                br0                 |
+# |                 +                  | |                 +                  |
+# |                 |                  | |                 |                  |
+# |                 |                  | |                 |                  |
+# |                 +                  | |                 +                  |
+# |                vx0                 | |                vx0                 |
+# |                                    | |                                    |
+# |                                    | |                                    |
+# |               veth0                | |               veth0                |
+# |                 +                  | |                 +                  |
+# +-----------------|------------------+ +-----------------|------------------+
+#                   |                                      |
+# +-----------------|------------------+ +-----------------|------------------+
+# |                 +                  | |                 +                  |
+# |               veth0                | |               veth0                |
+# |                                    | |                                    |
+# |                                    | |                                    |
+# |                vx0                 | |                vx0                 |
+# |                 +                  | |                 +                  |
+# |                 |                  | |                 |                  |
+# |                 |                  | |                 |                  |
+# |                 +                  | |                 +                  |
+# |                br0                 | |                br0                 |
+# |                 +                  | |                 +                  |
+# |                 |                  | |                 |                  |
+# |                 |                  | |                 |                  |
+# |       +---------+---------+        | |       +---------+---------+        |
+# |       |         |         |        | |       |         |         |        |
+# |       |         |         |        | |       |         |         |        |
+# |       +         +         +        | |       +         +         +        |
+# |    br0.10    br0.4000  br0.10      | |    br0.10    br0.4000  br0.20      |
+# |                                    | |                                    |
+# | ns2_v4                             | | ns2_v6                             |
+# +------------------------------------+ +------------------------------------+
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+CONTROL_PATH_TESTS="
+	basic_star_g_ipv4_ipv4
+	basic_star_g_ipv6_ipv4
+	basic_star_g_ipv4_ipv6
+	basic_star_g_ipv6_ipv6
+	basic_sg_ipv4_ipv4
+	basic_sg_ipv6_ipv4
+	basic_sg_ipv4_ipv6
+	basic_sg_ipv6_ipv6
+	star_g_ipv4_ipv4
+	star_g_ipv6_ipv4
+	star_g_ipv4_ipv6
+	star_g_ipv6_ipv6
+	sg_ipv4_ipv4
+	sg_ipv6_ipv4
+	sg_ipv4_ipv6
+	sg_ipv6_ipv6
+	dump_ipv4_ipv4
+	dump_ipv6_ipv4
+	dump_ipv4_ipv6
+	dump_ipv6_ipv6
+"
+
+DATA_PATH_TESTS="
+	encap_params_ipv4_ipv4
+	encap_params_ipv6_ipv4
+	encap_params_ipv4_ipv6
+	encap_params_ipv6_ipv6
+	starg_exclude_ir_ipv4_ipv4
+	starg_exclude_ir_ipv6_ipv4
+	starg_exclude_ir_ipv4_ipv6
+	starg_exclude_ir_ipv6_ipv6
+	starg_include_ir_ipv4_ipv4
+	starg_include_ir_ipv6_ipv4
+	starg_include_ir_ipv4_ipv6
+	starg_include_ir_ipv6_ipv6
+	starg_exclude_p2mp_ipv4_ipv4
+	starg_exclude_p2mp_ipv6_ipv4
+	starg_exclude_p2mp_ipv4_ipv6
+	starg_exclude_p2mp_ipv6_ipv6
+	starg_include_p2mp_ipv4_ipv4
+	starg_include_p2mp_ipv6_ipv4
+	starg_include_p2mp_ipv4_ipv6
+	starg_include_p2mp_ipv6_ipv6
+	egress_vni_translation_ipv4_ipv4
+	egress_vni_translation_ipv6_ipv4
+	egress_vni_translation_ipv4_ipv6
+	egress_vni_translation_ipv6_ipv6
+	all_zeros_mdb_ipv4
+	all_zeros_mdb_ipv6
+	mdb_fdb_ipv4_ipv4
+	mdb_fdb_ipv6_ipv4
+	mdb_fdb_ipv4_ipv6
+	mdb_fdb_ipv6_ipv6
+	mdb_torture_ipv4_ipv4
+	mdb_torture_ipv6_ipv4
+	mdb_torture_ipv4_ipv6
+	mdb_torture_ipv6_ipv6
+"
+
+# All tests in this script. Can be overridden with -t option.
+TESTS="
+	$CONTROL_PATH_TESTS
+	$DATA_PATH_TESTS
+"
+VERBOSE=0
+PAUSE_ON_FAIL=no
+PAUSE=no
+
+################################################################################
+# Utilities
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "$VERBOSE" = "1" ]; then
+			echo "    rc=$rc, expected $expected"
+		fi
+
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+		echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	if [ "${PAUSE}" = "yes" ]; then
+		echo
+		echo "hit enter to continue, 'q' to quit"
+		read a
+		[ "$a" = "q" ] && exit 1
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+}
+
+run_cmd()
+{
+	local cmd="$1"
+	local out
+	local stderr="2>/dev/null"
+
+	if [ "$VERBOSE" = "1" ]; then
+		printf "COMMAND: $cmd\n"
+		stderr=
+	fi
+
+	out=$(eval $cmd $stderr)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "    $out"
+	fi
+
+	return $rc
+}
+
+tc_check_packets()
+{
+	local ns=$1; shift
+	local id=$1; shift
+	local handle=$1; shift
+	local count=$1; shift
+	local pkts
+
+	sleep 0.1
+	pkts=$(tc -n $ns -j -s filter show $id \
+		| jq ".[] | select(.options.handle == $handle) | \
+		.options.actions[0].stats.packets")
+	[[ $pkts == $count ]]
+}
+
+################################################################################
+# Setup
+
+setup_common_ns()
+{
+	local ns=$1; shift
+	local local_addr=$1; shift
+
+	ip netns exec $ns sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec $ns sysctl -qw net.ipv4.fib_multipath_use_neigh=1
+	ip netns exec $ns sysctl -qw net.ipv4.conf.default.ignore_routes_with_linkdown=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.default.ignore_routes_with_linkdown=1
+	ip netns exec $ns sysctl -qw net.ipv6.conf.all.accept_dad=0
+	ip netns exec $ns sysctl -qw net.ipv6.conf.default.accept_dad=0
+
+	ip -n $ns link set dev lo up
+	ip -n $ns address add $local_addr dev lo
+
+	ip -n $ns link set dev veth0 up
+
+	ip -n $ns link add name br0 up type bridge vlan_filtering 1 \
+		vlan_default_pvid 0 mcast_snooping 0
+
+	ip -n $ns link add link br0 name br0.10 up type vlan id 10
+	bridge -n $ns vlan add vid 10 dev br0 self
+
+	ip -n $ns link add link br0 name br0.20 up type vlan id 20
+	bridge -n $ns vlan add vid 20 dev br0 self
+
+	ip -n $ns link add link br0 name br0.4000 up type vlan id 4000
+	bridge -n $ns vlan add vid 4000 dev br0 self
+
+	ip -n $ns link add name vx0 up master br0 type vxlan \
+		local $local_addr dstport 4789 external vnifilter
+	bridge -n $ns link set dev vx0 vlan_tunnel on
+
+	bridge -n $ns vlan add vid 10 dev vx0
+	bridge -n $ns vlan add vid 10 dev vx0 tunnel_info id 10010
+	bridge -n $ns vni add vni 10010 dev vx0
+
+	bridge -n $ns vlan add vid 20 dev vx0
+	bridge -n $ns vlan add vid 20 dev vx0 tunnel_info id 10020
+	bridge -n $ns vni add vni 10020 dev vx0
+
+	bridge -n $ns vlan add vid 4000 dev vx0 pvid
+	bridge -n $ns vlan add vid 4000 dev vx0 tunnel_info id 14000
+	bridge -n $ns vni add vni 14000 dev vx0
+}
+
+setup_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local local_addr1=$1; shift
+	local local_addr2=$1; shift
+
+	ip netns add $ns1
+	ip netns add $ns2
+
+	ip link add name veth0 type veth peer name veth1
+	ip link set dev veth0 netns $ns1 name veth0
+	ip link set dev veth1 netns $ns2 name veth0
+
+	setup_common_ns $ns1 $local_addr1
+	setup_common_ns $ns2 $local_addr2
+}
+
+setup_v4()
+{
+	setup_common ns1_v4 ns2_v4 192.0.2.1 192.0.2.2
+
+	ip -n ns1_v4 address add 192.0.2.17/28 dev veth0
+	ip -n ns2_v4 address add 192.0.2.18/28 dev veth0
+
+	ip -n ns1_v4 route add default via 192.0.2.18
+	ip -n ns2_v4 route add default via 192.0.2.17
+}
+
+cleanup_v4()
+{
+	ip netns del ns2_v4
+	ip netns del ns1_v4
+}
+
+setup_v6()
+{
+	setup_common ns1_v6 ns2_v6 2001:db8:1::1 2001:db8:1::2
+
+	ip -n ns1_v6 address add 2001:db8:2::1/64 dev veth0 nodad
+	ip -n ns2_v6 address add 2001:db8:2::2/64 dev veth0 nodad
+
+	ip -n ns1_v6 route add default via 2001:db8:2::2
+	ip -n ns2_v6 route add default via 2001:db8:2::1
+}
+
+cleanup_v6()
+{
+	ip netns del ns2_v6
+	ip netns del ns1_v6
+}
+
+setup()
+{
+	set -e
+
+	setup_v4
+	setup_v6
+
+	sleep 5
+
+	set +e
+}
+
+cleanup()
+{
+	cleanup_v6 &> /dev/null
+	cleanup_v4 &> /dev/null
+}
+
+################################################################################
+# Tests - Control path
+
+basic_common()
+{
+	local ns1=$1; shift
+	local grp_key=$1; shift
+	local vtep_ip=$1; shift
+
+	# Test basic control path operations common to all MDB entry types.
+
+	# Basic add, replace and delete behavior.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	log_test $? 0 "MDB entry addition"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\""
+	log_test $? 0 "MDB entry presence after addition"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	log_test $? 0 "MDB entry replacement"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\""
+	log_test $? 0 "MDB entry presence after replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+	log_test $? 0 "MDB entry deletion"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\""
+	log_test $? 1 "MDB entry presence after deletion"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+	log_test $? 255 "Non-existent MDB entry deletion"
+
+	# Default protocol and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \"proto static\""
+	log_test $? 0 "MDB entry default protocol"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 $grp_key permanent proto 123 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \"proto 123\""
+	log_test $? 0 "MDB entry protocol replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+
+	# Default destination port and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \" dst_port \""
+	log_test $? 1 "MDB entry default destination port"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 $grp_key permanent dst $vtep_ip dst_port 1234 src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \"dst_port 1234\""
+	log_test $? 0 "MDB entry destination port replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+
+	# Default destination VNI and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \" vni \""
+	log_test $? 1 "MDB entry default destination VNI"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 $grp_key permanent dst $vtep_ip vni 1234 src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \"vni 1234\""
+	log_test $? 0 "MDB entry destination VNI replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+
+	# Default outgoing interface and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \" via \""
+	log_test $? 1 "MDB entry default outgoing interface"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010 via veth0"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep \"$grp_key\" | grep \"via veth0\""
+	log_test $? 0 "MDB entry outgoing interface replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+
+	# Common error cases.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port veth0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	log_test $? 255 "MDB entry with mismatch between device and port"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key temp dst $vtep_ip src_vni 10010"
+	log_test $? 255 "MDB entry with temp state"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent vid 10 dst $vtep_ip src_vni 10010"
+	log_test $? 255 "MDB entry with VLAN"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp 01:02:03:04:05:06 permanent dst $vtep_ip src_vni 10010"
+	log_test $? 255 "MDB entry MAC address"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent"
+	log_test $? 255 "MDB entry without extended parameters"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent proto 3 dst $vtep_ip src_vni 10010"
+	log_test $? 255 "MDB entry with an invalid protocol"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip vni $((2 ** 24)) src_vni 10010"
+	log_test $? 255 "MDB entry with an invalid destination VNI"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni $((2 ** 24))"
+	log_test $? 255 "MDB entry with an invalid source VNI"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent src_vni 10010"
+	log_test $? 255 "MDB entry without a remote destination IP"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 $grp_key permanent dst $vtep_ip src_vni 10010"
+	log_test $? 255 "Duplicate MDB entries"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 $grp_key dst $vtep_ip src_vni 10010"
+}
+
+basic_star_g_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local grp_key="grp 239.1.1.1"
+	local vtep_ip=198.51.100.100
+
+	echo
+	echo "Control path: Basic (*, G) operations - IPv4 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_star_g_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local grp_key="grp ff0e::1"
+	local vtep_ip=198.51.100.100
+
+	echo
+	echo "Control path: Basic (*, G) operations - IPv6 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_star_g_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local grp_key="grp 239.1.1.1"
+	local vtep_ip=2001:db8:1000::1
+
+	echo
+	echo "Control path: Basic (*, G) operations - IPv4 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_star_g_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local grp_key="grp ff0e::1"
+	local vtep_ip=2001:db8:1000::1
+
+	echo
+	echo "Control path: Basic (*, G) operations - IPv6 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_sg_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local grp_key="grp 239.1.1.1 src 192.0.2.129"
+	local vtep_ip=198.51.100.100
+
+	echo
+	echo "Control path: Basic (S, G) operations - IPv4 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_sg_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local grp_key="grp ff0e::1 src 2001:db8:100::1"
+	local vtep_ip=198.51.100.100
+
+	echo
+	echo "Control path: Basic (S, G) operations - IPv6 overlay / IPv4 underlay"
+	echo "---------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_sg_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local grp_key="grp 239.1.1.1 src 192.0.2.129"
+	local vtep_ip=2001:db8:1000::1
+
+	echo
+	echo "Control path: Basic (S, G) operations - IPv4 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+basic_sg_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local grp_key="grp ff0e::1 src 2001:db8:100::1"
+	local vtep_ip=2001:db8:1000::1
+
+	echo
+	echo "Control path: Basic (S, G) operations - IPv6 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------------"
+
+	basic_common $ns1 "$grp_key" $vtep_ip
+}
+
+star_g_common()
+{
+	local ns1=$1; shift
+	local grp=$1; shift
+	local src1=$1; shift
+	local src2=$1; shift
+	local src3=$1; shift
+	local vtep_ip=$1; shift
+	local all_zeros_grp=$1; shift
+
+	# Test control path operations specific to (*, G) entries.
+
+	# Basic add, replace and delete behavior.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	log_test $? 0 "(*, G) MDB entry addition with source list"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \""
+	log_test $? 0 "(*, G) MDB entry presence after addition"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 0 "(S, G) MDB entry presence after addition"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	log_test $? 0 "(*, G) MDB entry replacement with source list"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \""
+	log_test $? 0 "(*, G) MDB entry presence after replacement"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 0 "(S, G) MDB entry presence after replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+	log_test $? 0 "(*, G) MDB entry deletion"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \""
+	log_test $? 1 "(*, G) MDB entry presence after deletion"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 1 "(S, G) MDB entry presence after deletion"
+
+	# Default filter mode and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep exclude"
+	log_test $? 0 "(*, G) MDB entry default filter mode"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode include source_list $src1 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep include"
+	log_test $? 0 "(*, G) MDB entry after replacing filter mode to \"include\""
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 0 "(S, G) MDB entry after replacing filter mode to \"include\""
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\" | grep blocked"
+	log_test $? 1 "\"blocked\" flag after replacing filter mode to \"include\""
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep exclude"
+	log_test $? 0 "(*, G) MDB entry after replacing filter mode to \"exclude\""
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 0 "(S, G) MDB entry after replacing filter mode to \"exclude\""
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\" | grep blocked"
+	log_test $? 0 "\"blocked\" flag after replacing filter mode to \"exclude\""
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+
+	# Default source list and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep source_list"
+	log_test $? 1 "(*, G) MDB entry default source list"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1,$src2,$src3 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 0 "(S, G) MDB entry of 1st source after replacing source list"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src2\""
+	log_test $? 0 "(S, G) MDB entry of 2nd source after replacing source list"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src3\""
+	log_test $? 0 "(S, G) MDB entry of 3rd source after replacing source list"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1,$src3 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src1\""
+	log_test $? 0 "(S, G) MDB entry of 1st source after removing source"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src2\""
+	log_test $? 1 "(S, G) MDB entry of 2nd source after removing source"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \"src $src3\""
+	log_test $? 0 "(S, G) MDB entry of 3rd source after removing source"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+
+	# Default protocol and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \"proto static\""
+	log_test $? 0 "(*, G) MDB entry default protocol"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \"proto static\""
+	log_test $? 0 "(S, G) MDB entry default protocol"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 proto bgp dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \"proto bgp\""
+	log_test $? 0 "(*, G) MDB entry protocol after replacement"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \"proto bgp\""
+	log_test $? 0 "(S, G) MDB entry protocol after replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+
+	# Default destination port and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \" dst_port \""
+	log_test $? 1 "(*, G) MDB entry default destination port"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \" dst_port \""
+	log_test $? 1 "(S, G) MDB entry default destination port"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip dst_port 1234 src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \" dst_port 1234 \""
+	log_test $? 0 "(*, G) MDB entry destination port after replacement"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \" dst_port 1234 \""
+	log_test $? 0 "(S, G) MDB entry destination port after replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+
+	# Default destination VNI and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \" vni \""
+	log_test $? 1 "(*, G) MDB entry default destination VNI"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \" vni \""
+	log_test $? 1 "(S, G) MDB entry default destination VNI"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip vni 1234 src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \" vni 1234 \""
+	log_test $? 0 "(*, G) MDB entry destination VNI after replacement"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \" vni 1234 \""
+	log_test $? 0 "(S, G) MDB entry destination VNI after replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+
+	# Default outgoing interface and replacement.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \" via \""
+	log_test $? 1 "(*, G) MDB entry default outgoing interface"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \" via \""
+	log_test $? 1 "(S, G) MDB entry default outgoing interface"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $src1 dst $vtep_ip src_vni 10010 via veth0"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep -v \" src \" | grep \" via veth0 \""
+	log_test $? 0 "(*, G) MDB entry outgoing interface after replacement"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep \" src \" | grep \" via veth0 \""
+	log_test $? 0 "(S, G) MDB entry outgoing interface after replacement"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep_ip src_vni 10010"
+
+	# Error cases.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $all_zeros_grp permanent filter_mode exclude dst $vtep_ip src_vni 10010"
+	log_test $? 255 "All-zeros group with filter mode"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $all_zeros_grp permanent source_list $src1 dst $vtep_ip src_vni 10010"
+	log_test $? 255 "All-zeros group with source list"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode include dst $vtep_ip src_vni 10010"
+	log_test $? 255 "(*, G) INCLUDE with an empty source list"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $grp dst $vtep_ip src_vni 10010"
+	log_test $? 255 "Invalid source in source list"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp permanent source_list $src1 dst $vtep_ip src_vni 10010"
+	log_test $? 255 "Source list without filter mode"
+}
+
+star_g_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local grp=239.1.1.1
+	local src1=192.0.2.129
+	local src2=192.0.2.130
+	local src3=192.0.2.131
+	local vtep_ip=198.51.100.100
+	local all_zeros_grp=0.0.0.0
+
+	echo
+	echo "Control path: (*, G) operations - IPv4 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------"
+
+	star_g_common $ns1 $grp $src1 $src2 $src3 $vtep_ip $all_zeros_grp
+}
+
+star_g_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local grp=ff0e::1
+	local src1=2001:db8:100::1
+	local src2=2001:db8:100::2
+	local src3=2001:db8:100::3
+	local vtep_ip=198.51.100.100
+	local all_zeros_grp=::
+
+	echo
+	echo "Control path: (*, G) operations - IPv6 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------"
+
+	star_g_common $ns1 $grp $src1 $src2 $src3 $vtep_ip $all_zeros_grp
+}
+
+star_g_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local grp=239.1.1.1
+	local src1=192.0.2.129
+	local src2=192.0.2.130
+	local src3=192.0.2.131
+	local vtep_ip=2001:db8:1000::1
+	local all_zeros_grp=0.0.0.0
+
+	echo
+	echo "Control path: (*, G) operations - IPv4 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------"
+
+	star_g_common $ns1 $grp $src1 $src2 $src3 $vtep_ip $all_zeros_grp
+}
+
+star_g_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local grp=ff0e::1
+	local src1=2001:db8:100::1
+	local src2=2001:db8:100::2
+	local src3=2001:db8:100::3
+	local vtep_ip=2001:db8:1000::1
+	local all_zeros_grp=::
+
+	echo
+	echo "Control path: (*, G) operations - IPv6 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------"
+
+	star_g_common $ns1 $grp $src1 $src2 $src3 $vtep_ip $all_zeros_grp
+}
+
+sg_common()
+{
+	local ns1=$1; shift
+	local grp=$1; shift
+	local src=$1; shift
+	local vtep_ip=$1; shift
+	local all_zeros_grp=$1; shift
+
+	# Test control path operations specific to (S, G) entries.
+
+	# Default filter mode.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp src $src permanent dst $vtep_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 -d -s mdb show dev vx0 | grep $grp | grep include"
+	log_test $? 0 "(S, G) MDB entry default filter mode"
+
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp src $src permanent dst $vtep_ip src_vni 10010"
+
+	# Error cases.
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp src $src permanent filter_mode include dst $vtep_ip src_vni 10010"
+	log_test $? 255 "(S, G) with filter mode"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp src $src permanent source_list $src dst $vtep_ip src_vni 10010"
+	log_test $? 255 "(S, G) with source list"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp src $grp permanent dst $vtep_ip src_vni 10010"
+	log_test $? 255 "(S, G) with an invalid source list"
+
+	run_cmd "bridge -n $ns1 mdb add dev vx0 port vx0 grp $all_zeros_grp src $src permanent dst $vtep_ip src_vni 10010"
+	log_test $? 255 "All-zeros group with source"
+}
+
+sg_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local grp=239.1.1.1
+	local src=192.0.2.129
+	local vtep_ip=198.51.100.100
+	local all_zeros_grp=0.0.0.0
+
+	echo
+	echo "Control path: (S, G) operations - IPv4 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------"
+
+	sg_common $ns1 $grp $src $vtep_ip $all_zeros_grp
+}
+
+sg_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+	local vtep_ip=198.51.100.100
+	local all_zeros_grp=::
+
+	echo
+	echo "Control path: (S, G) operations - IPv6 overlay / IPv4 underlay"
+	echo "--------------------------------------------------------------"
+
+	sg_common $ns1 $grp $src $vtep_ip $all_zeros_grp
+}
+
+sg_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local grp=239.1.1.1
+	local src=192.0.2.129
+	local vtep_ip=2001:db8:1000::1
+	local all_zeros_grp=0.0.0.0
+
+	echo
+	echo "Control path: (S, G) operations - IPv4 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------"
+
+	sg_common $ns1 $grp $src $vtep_ip $all_zeros_grp
+}
+
+sg_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+	local vtep_ip=2001:db8:1000::1
+	local all_zeros_grp=::
+
+	echo
+	echo "Control path: (S, G) operations - IPv6 overlay / IPv6 underlay"
+	echo "--------------------------------------------------------------"
+
+	sg_common $ns1 $grp $src $vtep_ip $all_zeros_grp
+}
+
+ipv4_grps_get()
+{
+	local max_grps=$1; shift
+	local i
+
+	for i in $(seq 0 $((max_grps - 1))); do
+		echo "239.1.1.$i"
+	done
+}
+
+ipv6_grps_get()
+{
+	local max_grps=$1; shift
+	local i
+
+	for i in $(seq 0 $((max_grps - 1))); do
+		echo "ff0e::$(printf %x $i)"
+	done
+}
+
+dump_common()
+{
+	local ns1=$1; shift
+	local local_addr=$1; shift
+	local remote_prefix=$1; shift
+	local fn=$1; shift
+	local max_vxlan_devs=2
+	local max_remotes=64
+	local max_grps=256
+	local num_entries
+	local batch_file
+	local grp
+	local i j
+
+	# The kernel maintains various markers for the MDB dump. Add a test for
+	# large scale MDB dump to make sure that all the configured entries are
+	# dumped and that the markers are used correctly.
+
+	# Create net devices.
+	for i in $(seq 1 $max_vxlan_devs); do
+		ip -n $ns1 link add name vx-test${i} up type vxlan \
+			local $local_addr dstport 4789 external vnifilter
+	done
+
+	# Create batch file with MDB entries.
+	batch_file=$(mktemp)
+	for i in $(seq 1 $max_vxlan_devs); do
+		for j in $(seq 1 $max_remotes); do
+			for grp in $($fn $max_grps); do
+				echo "mdb add dev vx-test${i} port vx-test${i} grp $grp permanent dst ${remote_prefix}${j}" >> $batch_file
+			done
+		done
+	done
+
+	# Program the batch file and check for expected number of entries.
+	bridge -n $ns1 -b $batch_file
+	for i in $(seq 1 $max_vxlan_devs); do
+		num_entries=$(bridge -n $ns1 mdb show dev vx-test${i} | grep "permanent" | wc -l)
+		[[ $num_entries -eq $((max_grps * max_remotes)) ]]
+		log_test $? 0 "Large scale dump - VXLAN device #$i"
+	done
+
+	rm -rf $batch_file
+}
+
+dump_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local local_addr=192.0.2.1
+	local remote_prefix=198.51.100.
+	local fn=ipv4_grps_get
+
+	echo
+	echo "Control path: Large scale MDB dump - IPv4 overlay / IPv4 underlay"
+	echo "-----------------------------------------------------------------"
+
+	dump_common $ns1 $local_addr $remote_prefix $fn
+}
+
+dump_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local local_addr=192.0.2.1
+	local remote_prefix=198.51.100.
+	local fn=ipv6_grps_get
+
+	echo
+	echo "Control path: Large scale MDB dump - IPv6 overlay / IPv4 underlay"
+	echo "-----------------------------------------------------------------"
+
+	dump_common $ns1 $local_addr $remote_prefix $fn
+}
+
+dump_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local local_addr=2001:db8:1::1
+	local remote_prefix=2001:db8:1000::
+	local fn=ipv4_grps_get
+
+	echo
+	echo "Control path: Large scale MDB dump - IPv4 overlay / IPv6 underlay"
+	echo "-----------------------------------------------------------------"
+
+	dump_common $ns1 $local_addr $remote_prefix $fn
+}
+
+dump_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local local_addr=2001:db8:1::1
+	local remote_prefix=2001:db8:1000::
+	local fn=ipv6_grps_get
+
+	echo
+	echo "Control path: Large scale MDB dump - IPv6 overlay / IPv6 underlay"
+	echo "-----------------------------------------------------------------"
+
+	dump_common $ns1 $local_addr $remote_prefix $fn
+}
+
+################################################################################
+# Tests - Data path
+
+encap_params_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local plen=$1; shift
+	local enc_ethtype=$1; shift
+	local grp=$1; shift
+	local src=$1; shift
+	local mz=$1; shift
+
+	# Test that packets forwarded by the VXLAN MDB are encapsulated with
+	# the correct parameters. Transmit packets from the first namespace and
+	# check that they hit the corresponding filters on the ingress of the
+	# second namespace.
+
+	run_cmd "tc -n $ns2 qdisc replace dev veth0 clsact"
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "ip -n $ns2 address replace $vtep1_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep2_ip/$plen dev lo"
+
+	# Check destination IP.
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep2_ip src_vni 10020"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $vtep1_ip action pass"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Destination IP - match"
+
+	run_cmd "ip netns exec $ns1 $mz br0.20 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Destination IP - no match"
+
+	run_cmd "tc -n $ns2 filter del dev vx0 ingress pref 1 handle 101 flower"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep2_ip src_vni 10020"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep1_ip src_vni 10010"
+
+	# Check destination port.
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip dst_port 1111 src_vni 10020"
+
+	run_cmd "tc -n $ns2 filter replace dev veth0 ingress pref 1 handle 101 proto $enc_ethtype flower ip_proto udp dst_port 4789 action pass"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev veth0 ingress" 101 1
+	log_test $? 0 "Default destination port - match"
+
+	run_cmd "ip netns exec $ns1 $mz br0.20 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev veth0 ingress" 101 1
+	log_test $? 0 "Default destination port - no match"
+
+	run_cmd "tc -n $ns2 filter replace dev veth0 ingress pref 1 handle 101 proto $enc_ethtype flower ip_proto udp dst_port 1111 action pass"
+	run_cmd "ip netns exec $ns1 $mz br0.20 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev veth0 ingress" 101 1
+	log_test $? 0 "Non-default destination port - match"
+
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev veth0 ingress" 101 1
+	log_test $? 0 "Non-default destination port - no match"
+
+	run_cmd "tc -n $ns2 filter del dev veth0 ingress pref 1 handle 101 flower"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep1_ip src_vni 10020"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep1_ip src_vni 10010"
+
+	# Check default VNI.
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip src_vni 10020"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_key_id 10010 action pass"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Default destination VNI - match"
+
+	run_cmd "ip netns exec $ns1 $mz br0.20 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Default destination VNI - no match"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip vni 10020 src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip vni 10010 src_vni 10020"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_key_id 10020 action pass"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Non-default destination VNI - match"
+
+	run_cmd "ip netns exec $ns1 $mz br0.20 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Non-default destination VNI - no match"
+
+	run_cmd "tc -n $ns2 filter del dev vx0 ingress pref 1 handle 101 flower"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep1_ip src_vni 10020"
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep1_ip src_vni 10010"
+}
+
+encap_params_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local enc_ethtype="ip"
+	local grp=239.1.1.1
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: Encapsulation parameters - IPv4 overlay / IPv4 underlay"
+	echo "------------------------------------------------------------------"
+
+	encap_params_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $enc_ethtype \
+		$grp $src "mausezahn"
+}
+
+encap_params_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local enc_ethtype="ip"
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: Encapsulation parameters - IPv6 overlay / IPv4 underlay"
+	echo "------------------------------------------------------------------"
+
+	encap_params_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $enc_ethtype \
+		$grp $src "mausezahn -6"
+}
+
+encap_params_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local enc_ethtype="ipv6"
+	local grp=239.1.1.1
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: Encapsulation parameters - IPv4 overlay / IPv6 underlay"
+	echo "------------------------------------------------------------------"
+
+	encap_params_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $enc_ethtype \
+		$grp $src "mausezahn"
+}
+
+encap_params_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local enc_ethtype="ipv6"
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: Encapsulation parameters - IPv6 overlay / IPv6 underlay"
+	echo "------------------------------------------------------------------"
+
+	encap_params_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $enc_ethtype \
+		$grp $src "mausezahn -6"
+}
+
+starg_exclude_ir_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local plen=$1; shift
+	local grp=$1; shift
+	local valid_src=$1; shift
+	local invalid_src=$1; shift
+	local mz=$1; shift
+
+	# Install a (*, G) EXCLUDE MDB entry with one source and two remote
+	# VTEPs. Make sure that the source in the source list is not forwarded
+	# and that a source not in the list is forwarded. Remove one of the
+	# VTEPs from the entry and make sure that packets are only forwarded to
+	# the remaining VTEP.
+
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "ip -n $ns2 address replace $vtep1_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep2_ip/$plen dev lo"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $vtep1_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 102 proto all flower enc_dst_ip $vtep2_ip action pass"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $invalid_src dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $invalid_src dst $vtep2_ip src_vni 10010"
+
+	# Check that invalid source is not forwarded to any VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $invalid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 0
+	log_test $? 0 "Block excluded source - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 0
+	log_test $? 0 "Block excluded source - second VTEP"
+
+	# Check that valid source is forwarded to both VTEPs.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Forward valid source - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Forward valid source - second VTEP"
+
+	# Remove second VTEP.
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep2_ip src_vni 10010"
+
+	# Check that invalid source is not forwarded to any VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $invalid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Block excluded source after removal - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Block excluded source after removal - second VTEP"
+
+	# Check that valid source is forwarded to the remaining VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 2
+	log_test $? 0 "Forward valid source after removal - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Forward valid source after removal - second VTEP"
+}
+
+starg_exclude_ir_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - IR - IPv4 overlay / IPv4 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_exclude_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_exclude_ir_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - IR - IPv6 overlay / IPv4 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_exclude_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_exclude_ir_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - IR - IPv4 overlay / IPv6 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_exclude_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_exclude_ir_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - IR - IPv6 overlay / IPv6 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_exclude_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_include_ir_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local plen=$1; shift
+	local grp=$1; shift
+	local valid_src=$1; shift
+	local invalid_src=$1; shift
+	local mz=$1; shift
+
+	# Install a (*, G) INCLUDE MDB entry with one source and two remote
+	# VTEPs. Make sure that the source in the source list is forwarded and
+	# that a source not in the list is not forwarded. Remove one of the
+	# VTEPs from the entry and make sure that packets are only forwarded to
+	# the remaining VTEP.
+
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "ip -n $ns2 address replace $vtep1_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep2_ip/$plen dev lo"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $vtep1_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 102 proto all flower enc_dst_ip $vtep2_ip action pass"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode include source_list $valid_src dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode include source_list $valid_src dst $vtep2_ip src_vni 10010"
+
+	# Check that invalid source is not forwarded to any VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $invalid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 0
+	log_test $? 0 "Block excluded source - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 0
+	log_test $? 0 "Block excluded source - second VTEP"
+
+	# Check that valid source is forwarded to both VTEPs.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Forward valid source - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Forward valid source - second VTEP"
+
+	# Remove second VTEP.
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep2_ip src_vni 10010"
+
+	# Check that invalid source is not forwarded to any VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $invalid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Block excluded source after removal - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Block excluded source after removal - second VTEP"
+
+	# Check that valid source is forwarded to the remaining VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 2
+	log_test $? 0 "Forward valid source after removal - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Forward valid source after removal - second VTEP"
+}
+
+starg_include_ir_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) INCLUDE - IR - IPv4 overlay / IPv4 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_include_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_include_ir_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) INCLUDE - IR - IPv6 overlay / IPv4 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_include_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_include_ir_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) INCLUDE - IR - IPv4 overlay / IPv6 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_include_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_include_ir_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) INCLUDE - IR - IPv6 overlay / IPv6 underlay"
+	echo "-------------------------------------------------------------"
+
+	starg_include_ir_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_exclude_p2mp_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local mcast_grp=$1; shift
+	local plen=$1; shift
+	local grp=$1; shift
+	local valid_src=$1; shift
+	local invalid_src=$1; shift
+	local mz=$1; shift
+
+	# Install a (*, G) EXCLUDE MDB entry with one source and one multicast
+	# group to which packets are sent. Make sure that the source in the
+	# source list is not forwarded and that a source not in the list is
+	# forwarded.
+
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "ip -n $ns2 address replace $mcast_grp/$plen dev veth0 autojoin"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $mcast_grp action pass"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode exclude source_list $invalid_src dst $mcast_grp src_vni 10010 via veth0"
+
+	# Check that invalid source is not forwarded.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $invalid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 0
+	log_test $? 0 "Block excluded source"
+
+	# Check that valid source is forwarded.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Forward valid source"
+
+	# Remove the VTEP from the multicast group.
+	run_cmd "ip -n $ns2 address del $mcast_grp/$plen dev veth0"
+
+	# Check that valid source is not received anymore.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Receive of valid source after removal from group"
+}
+
+starg_exclude_p2mp_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local mcast_grp=238.1.1.1
+	local plen=32
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - P2MP - IPv4 overlay / IPv4 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_exclude_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_exclude_p2mp_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local mcast_grp=238.1.1.1
+	local plen=32
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - P2MP - IPv6 overlay / IPv4 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_exclude_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_exclude_p2mp_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local mcast_grp=ff0e::2
+	local plen=128
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - P2MP - IPv4 overlay / IPv6 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_exclude_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_exclude_p2mp_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local mcast_grp=ff0e::2
+	local plen=128
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) EXCLUDE - P2MP - IPv6 overlay / IPv6 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_exclude_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_include_p2mp_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local mcast_grp=$1; shift
+	local plen=$1; shift
+	local grp=$1; shift
+	local valid_src=$1; shift
+	local invalid_src=$1; shift
+	local mz=$1; shift
+
+	# Install a (*, G) INCLUDE MDB entry with one source and one multicast
+	# group to which packets are sent. Make sure that the source in the
+	# source list is forwarded and that a source not in the list is not
+	# forwarded.
+
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "ip -n $ns2 address replace $mcast_grp/$plen dev veth0 autojoin"
+
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $mcast_grp action pass"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent filter_mode include source_list $valid_src dst $mcast_grp src_vni 10010 via veth0"
+
+	# Check that invalid source is not forwarded.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $invalid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 0
+	log_test $? 0 "Block excluded source"
+
+	# Check that valid source is forwarded.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Forward valid source"
+
+	# Remove the VTEP from the multicast group.
+	run_cmd "ip -n $ns2 address del $mcast_grp/$plen dev veth0"
+
+	# Check that valid source is not received anymore.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $valid_src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Receive of valid source after removal from group"
+}
+
+starg_include_p2mp_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local mcast_grp=238.1.1.1
+	local plen=32
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) INCLUDE - P2MP - IPv4 overlay / IPv4 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_include_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_include_p2mp_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local mcast_grp=238.1.1.1
+	local plen=32
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) INCLUDE - P2MP - IPv6 overlay / IPv4 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_include_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+starg_include_p2mp_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local mcast_grp=ff0e::2
+	local plen=128
+	local grp=239.1.1.1
+	local valid_src=192.0.2.129
+	local invalid_src=192.0.2.145
+
+	echo
+	echo "Data path: (*, G) INCLUDE - P2MP - IPv4 overlay / IPv6 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_include_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn"
+}
+
+starg_include_p2mp_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local mcast_grp=ff0e::2
+	local plen=128
+	local grp=ff0e::1
+	local valid_src=2001:db8:100::1
+	local invalid_src=2001:db8:200::1
+
+	echo
+	echo "Data path: (*, G) INCLUDE - P2MP - IPv6 overlay / IPv6 underlay"
+	echo "---------------------------------------------------------------"
+
+	starg_include_p2mp_common $ns1 $ns2 $mcast_grp $plen $grp \
+		$valid_src $invalid_src "mausezahn -6"
+}
+
+egress_vni_translation_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local mcast_grp=$1; shift
+	local plen=$1; shift
+	local proto=$1; shift
+	local grp=$1; shift
+	local src=$1; shift
+	local mz=$1; shift
+
+	# When P2MP tunnels are used with optimized inter-subnet multicast
+	# (OISM) [1], the ingress VTEP does not perform VNI translation and
+	# uses the VNI of the source broadcast domain (BD). If the egress VTEP
+	# is a member in the source BD, then no VNI translation is needed.
+	# Otherwise, the egress VTEP needs to translate the VNI to the
+	# supplementary broadcast domain (SBD) VNI, which is usually the L3VNI.
+	#
+	# In this test, remove the VTEP in the second namespace from VLAN 10
+	# (VNI 10010) and make sure that a packet sent from this VLAN on the
+	# first VTEP is received by the SVI corresponding to the L3VNI (14000 /
+	# VLAN 4000) on the second VTEP.
+	#
+	# The second VTEP will be able to decapsulate the packet with VNI 10010
+	# because this VNI is configured on its shared VXLAN device. Later,
+	# when ingressing the bridge, the VNI to VLAN lookup will fail because
+	# the VTEP is not a member in VLAN 10, which will cause the packet to
+	# be tagged with VLAN 4000 since it is configured as PVID.
+	#
+	# [1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast
+
+	run_cmd "tc -n $ns2 qdisc replace dev br0.4000 clsact"
+	run_cmd "ip -n $ns2 address replace $mcast_grp/$plen dev veth0 autojoin"
+	run_cmd "tc -n $ns2 filter replace dev br0.4000 ingress pref 1 handle 101 proto $proto flower src_ip $src dst_ip $grp action pass"
+
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp src $src permanent dst $mcast_grp src_vni 10010 via veth0"
+
+	# Remove the second VTEP from VLAN 10.
+	run_cmd "bridge -n $ns2 vlan del vid 10 dev vx0"
+
+	# Make sure that packets sent from the first VTEP over VLAN 10 are
+	# received by the SVI corresponding to the L3VNI (14000 / VLAN 4000) on
+	# the second VTEP, since it is configured as PVID.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev br0.4000 ingress" 101 1
+	log_test $? 0 "Egress VNI translation - PVID configured"
+
+	# Remove PVID flag from VLAN 4000 on the second VTEP and make sure
+	# packets are no longer received by the SVI interface.
+	run_cmd "bridge -n $ns2 vlan add vid 4000 dev vx0"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev br0.4000 ingress" 101 1
+	log_test $? 0 "Egress VNI translation - no PVID configured"
+
+	# Reconfigure the PVID and make sure packets are received again.
+	run_cmd "bridge -n $ns2 vlan add vid 4000 dev vx0 pvid"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev br0.4000 ingress" 101 2
+	log_test $? 0 "Egress VNI translation - PVID reconfigured"
+}
+
+egress_vni_translation_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local mcast_grp=238.1.1.1
+	local plen=32
+	local proto="ipv4"
+	local grp=239.1.1.1
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: Egress VNI translation - IPv4 overlay / IPv4 underlay"
+	echo "----------------------------------------------------------------"
+
+	egress_vni_translation_common $ns1 $ns2 $mcast_grp $plen $proto $grp \
+		$src "mausezahn"
+}
+
+egress_vni_translation_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local mcast_grp=238.1.1.1
+	local plen=32
+	local proto="ipv6"
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: Egress VNI translation - IPv6 overlay / IPv4 underlay"
+	echo "----------------------------------------------------------------"
+
+	egress_vni_translation_common $ns1 $ns2 $mcast_grp $plen $proto $grp \
+		$src "mausezahn -6"
+}
+
+egress_vni_translation_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local mcast_grp=ff0e::2
+	local plen=128
+	local proto="ipv4"
+	local grp=239.1.1.1
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: Egress VNI translation - IPv4 overlay / IPv6 underlay"
+	echo "----------------------------------------------------------------"
+
+	egress_vni_translation_common $ns1 $ns2 $mcast_grp $plen $proto $grp \
+		$src "mausezahn"
+}
+
+egress_vni_translation_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local mcast_grp=ff0e::2
+	local plen=128
+	local proto="ipv6"
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: Egress VNI translation - IPv6 overlay / IPv6 underlay"
+	echo "----------------------------------------------------------------"
+
+	egress_vni_translation_common $ns1 $ns2 $mcast_grp $plen $proto $grp \
+		$src "mausezahn -6"
+}
+
+all_zeros_mdb_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local vtep3_ip=$1; shift
+	local vtep4_ip=$1; shift
+	local plen=$1; shift
+	local ipv4_grp=239.1.1.1
+	local ipv4_unreg_grp=239.2.2.2
+	local ipv4_ll_grp=224.0.0.100
+	local ipv4_src=192.0.2.129
+	local ipv6_grp=ff0e::1
+	local ipv6_unreg_grp=ff0e::2
+	local ipv6_ll_grp=ff02::1
+	local ipv6_src=2001:db8:100::1
+
+	# Install all-zeros (catchall) MDB entries for IPv4 and IPv6 traffic
+	# and make sure they only forward unregistered IP multicast traffic
+	# which is not link-local. Also make sure that each entry only forwards
+	# traffic from the matching address family.
+
+	# Associate two different VTEPs with one all-zeros MDB entry: Two with
+	# the IPv4 entry (0.0.0.0) and another two with the IPv6 one (::).
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp 0.0.0.0 permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp 0.0.0.0 permanent dst $vtep2_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp :: permanent dst $vtep3_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp :: permanent dst $vtep4_ip src_vni 10010"
+
+	# Associate one VTEP from each set with a regular MDB entry: One with
+	# an IPv4 entry and another with an IPv6 one.
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $ipv4_grp permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $ipv6_grp permanent dst $vtep3_ip src_vni 10010"
+
+	# Add filters to match on decapsulated traffic in the second namespace.
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $vtep1_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 102 proto all flower enc_dst_ip $vtep2_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 103 proto all flower enc_dst_ip $vtep3_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 104 proto all flower enc_dst_ip $vtep4_ip action pass"
+
+	# Configure the VTEP addresses in the second namespace to enable
+	# decapsulation.
+	run_cmd "ip -n $ns2 address replace $vtep1_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep2_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep3_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep4_ip/$plen dev lo"
+
+	# Send registered IPv4 multicast and make sure it only arrives to the
+	# first VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn br0.10 -A $ipv4_src -B $ipv4_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Registered IPv4 multicast - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 0
+	log_test $? 0 "Registered IPv4 multicast - second VTEP"
+
+	# Send unregistered IPv4 multicast that is not link-local and make sure
+	# it arrives to the first and second VTEPs.
+	run_cmd "ip netns exec $ns1 mausezahn br0.10 -A $ipv4_src -B $ipv4_unreg_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 2
+	log_test $? 0 "Unregistered IPv4 multicast - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Unregistered IPv4 multicast - second VTEP"
+
+	# Send IPv4 link-local multicast traffic and make sure it does not
+	# arrive to any VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn br0.10 -A $ipv4_src -B $ipv4_ll_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 2
+	log_test $? 0 "Link-local IPv4 multicast - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Link-local IPv4 multicast - second VTEP"
+
+	# Send registered IPv4 multicast using a unicast MAC address and make
+	# sure it does not arrive to any VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn br0.10 -a own -b 00:11:22:33:44:55 -A $ipv4_src -B $ipv4_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 2
+	log_test $? 0 "Registered IPv4 multicast with a unicast MAC - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Registered IPv4 multicast with a unicast MAC - second VTEP"
+
+	# Send registered IPv4 multicast using a broadcast MAC address and make
+	# sure it does not arrive to any VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn br0.10 -a own -b bcast -A $ipv4_src -B $ipv4_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 2
+	log_test $? 0 "Registered IPv4 multicast with a broadcast MAC - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Registered IPv4 multicast with a broadcast MAC - second VTEP"
+
+	# Make sure IPv4 traffic did not reach the VTEPs associated with
+	# IPv6 entries.
+	tc_check_packets "$ns2" "dev vx0 ingress" 103 0
+	log_test $? 0 "IPv4 traffic - third VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 104 0
+	log_test $? 0 "IPv4 traffic - fourth VTEP"
+
+	# Reset IPv4 filters before testing IPv6 traffic.
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto all flower enc_dst_ip $vtep1_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 102 proto all flower enc_dst_ip $vtep2_ip action pass"
+
+	# Send registered IPv6 multicast and make sure it only arrives to the
+	# third VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn -6 br0.10 -A $ipv6_src -B $ipv6_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 103 1
+	log_test $? 0 "Registered IPv6 multicast - third VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 104 0
+	log_test $? 0 "Registered IPv6 multicast - fourth VTEP"
+
+	# Send unregistered IPv6 multicast that is not link-local and make sure
+	# it arrives to the third and fourth VTEPs.
+	run_cmd "ip netns exec $ns1 mausezahn -6 br0.10 -A $ipv6_src -B $ipv6_unreg_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 103 2
+	log_test $? 0 "Unregistered IPv6 multicast - third VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 104 1
+	log_test $? 0 "Unregistered IPv6 multicast - fourth VTEP"
+
+	# Send IPv6 link-local multicast traffic and make sure it does not
+	# arrive to any VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn -6 br0.10 -A $ipv6_src -B $ipv6_ll_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 103 2
+	log_test $? 0 "Link-local IPv6 multicast - third VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 104 1
+	log_test $? 0 "Link-local IPv6 multicast - fourth VTEP"
+
+	# Send registered IPv6 multicast using a unicast MAC address and make
+	# sure it does not arrive to any VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn -6 br0.10 -a own -b 00:11:22:33:44:55 -A $ipv6_src -B $ipv6_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 103 2
+	log_test $? 0 "Registered IPv6 multicast with a unicast MAC - third VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 104 1
+	log_test $? 0 "Registered IPv6 multicast with a unicast MAC - fourth VTEP"
+
+	# Send registered IPv6 multicast using a broadcast MAC address and make
+	# sure it does not arrive to any VTEP.
+	run_cmd "ip netns exec $ns1 mausezahn -6 br0.10 -a own -b bcast -A $ipv6_src -B $ipv6_grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 103 2
+	log_test $? 0 "Registered IPv6 multicast with a broadcast MAC - third VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 104 1
+	log_test $? 0 "Registered IPv6 multicast with a broadcast MAC - fourth VTEP"
+
+	# Make sure IPv6 traffic did not reach the VTEPs associated with
+	# IPv4 entries.
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 0
+	log_test $? 0 "IPv6 traffic - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 0
+	log_test $? 0 "IPv6 traffic - second VTEP"
+}
+
+all_zeros_mdb_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.101
+	local vtep2_ip=198.51.100.102
+	local vtep3_ip=198.51.100.103
+	local vtep4_ip=198.51.100.104
+	local plen=32
+
+	echo
+	echo "Data path: All-zeros MDB entry - IPv4 underlay"
+	echo "----------------------------------------------"
+
+	all_zeros_mdb_common $ns1 $ns2 $vtep1_ip $vtep2_ip $vtep3_ip \
+		$vtep4_ip $plen
+}
+
+all_zeros_mdb_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local vtep3_ip=2001:db8:3000::1
+	local vtep4_ip=2001:db8:4000::1
+	local plen=128
+
+	echo
+	echo "Data path: All-zeros MDB entry - IPv6 underlay"
+	echo "----------------------------------------------"
+
+	all_zeros_mdb_common $ns1 $ns2 $vtep1_ip $vtep2_ip $vtep3_ip \
+		$vtep4_ip $plen
+}
+
+mdb_fdb_common()
+{
+	local ns1=$1; shift
+	local ns2=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local plen=$1; shift
+	local proto=$1; shift
+	local grp=$1; shift
+	local src=$1; shift
+	local mz=$1; shift
+
+	# Install an MDB entry and an FDB entry and make sure that the FDB
+	# entry only forwards traffic that was not forwarded by the MDB.
+
+	# Associate the MDB entry with one VTEP and the FDB entry with another
+	# VTEP.
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 fdb add 00:00:00:00:00:00 dev vx0 self static dst $vtep2_ip src_vni 10010"
+
+	# Add filters to match on decapsulated traffic in the second namespace.
+	run_cmd "tc -n $ns2 qdisc replace dev vx0 clsact"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 101 proto $proto flower ip_proto udp dst_port 54321 enc_dst_ip $vtep1_ip action pass"
+	run_cmd "tc -n $ns2 filter replace dev vx0 ingress pref 1 handle 102 proto $proto flower ip_proto udp dst_port 54321 enc_dst_ip $vtep2_ip action pass"
+
+	# Configure the VTEP addresses in the second namespace to enable
+	# decapsulation.
+	run_cmd "ip -n $ns2 address replace $vtep1_ip/$plen dev lo"
+	run_cmd "ip -n $ns2 address replace $vtep2_ip/$plen dev lo"
+
+	# Send IP multicast traffic and make sure it is forwarded by the MDB
+	# and only arrives to the first VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "IP multicast - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 0
+	log_test $? 0 "IP multicast - second VTEP"
+
+	# Send broadcast traffic and make sure it is forwarded by the FDB and
+	# only arrives to the second VTEP.
+	run_cmd "ip netns exec $ns1 $mz br0.10 -a own -b bcast -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "Broadcast - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 1
+	log_test $? 0 "Broadcast - second VTEP"
+
+	# Remove the MDB entry and make sure that IP multicast is now forwarded
+	# by the FDB to the second VTEP.
+	run_cmd "bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp dst $vtep1_ip src_vni 10010"
+	run_cmd "ip netns exec $ns1 $mz br0.10 -A $src -B $grp -t udp sp=12345,dp=54321 -p 100 -c 1 -q"
+	tc_check_packets "$ns2" "dev vx0 ingress" 101 1
+	log_test $? 0 "IP multicast after removal - first VTEP"
+	tc_check_packets "$ns2" "dev vx0 ingress" 102 2
+	log_test $? 0 "IP multicast after removal - second VTEP"
+}
+
+mdb_fdb_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local proto="ipv4"
+	local grp=239.1.1.1
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: MDB with FDB - IPv4 overlay / IPv4 underlay"
+	echo "------------------------------------------------------"
+
+	mdb_fdb_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $proto $grp $src \
+		"mausezahn"
+}
+
+mdb_fdb_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local ns2=ns2_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local plen=32
+	local proto="ipv6"
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: MDB with FDB - IPv6 overlay / IPv4 underlay"
+	echo "------------------------------------------------------"
+
+	mdb_fdb_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $proto $grp $src \
+		"mausezahn -6"
+}
+
+mdb_fdb_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local proto="ipv4"
+	local grp=239.1.1.1
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: MDB with FDB - IPv4 overlay / IPv6 underlay"
+	echo "------------------------------------------------------"
+
+	mdb_fdb_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $proto $grp $src \
+		"mausezahn"
+}
+
+mdb_fdb_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local ns2=ns2_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local plen=128
+	local proto="ipv6"
+	local grp=ff0e::1
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: MDB with FDB - IPv6 overlay / IPv6 underlay"
+	echo "------------------------------------------------------"
+
+	mdb_fdb_common $ns1 $ns2 $vtep1_ip $vtep2_ip $plen $proto $grp $src \
+		"mausezahn -6"
+}
+
+mdb_grp1_loop()
+{
+	local ns1=$1; shift
+	local vtep1_ip=$1; shift
+	local grp1=$1; shift
+
+	while true; do
+		bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp1 dst $vtep1_ip src_vni 10010
+		bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp1 permanent dst $vtep1_ip src_vni 10010
+	done >/dev/null 2>&1
+}
+
+mdb_grp2_loop()
+{
+	local ns1=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local grp2=$1; shift
+
+	while true; do
+		bridge -n $ns1 mdb del dev vx0 port vx0 grp $grp2 dst $vtep1_ip src_vni 10010
+		bridge -n $ns1 mdb add dev vx0 port vx0 grp $grp2 permanent dst $vtep1_ip src_vni 10010
+		bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp2 permanent dst $vtep2_ip src_vni 10010
+	done >/dev/null 2>&1
+}
+
+mdb_torture_common()
+{
+	local ns1=$1; shift
+	local vtep1_ip=$1; shift
+	local vtep2_ip=$1; shift
+	local grp1=$1; shift
+	local grp2=$1; shift
+	local src=$1; shift
+	local mz=$1; shift
+	local pid1
+	local pid2
+	local pid3
+	local pid4
+
+	# Continuously send two streams that are forwarded by two different MDB
+	# entries. The first entry will be added and deleted in a loop. This
+	# allows us to test that the data path does not use freed MDB entry
+	# memory. The second entry will have two remotes, one that is added and
+	# deleted in a loop and another that is replaced in a loop. This allows
+	# us to test that the data path does not use freed remote entry memory.
+	# The test is considered successful if nothing crashed.
+
+	# Create the MDB entries that will be continuously deleted / replaced.
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp1 permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp2 permanent dst $vtep1_ip src_vni 10010"
+	run_cmd "bridge -n $ns1 mdb replace dev vx0 port vx0 grp $grp2 permanent dst $vtep2_ip src_vni 10010"
+
+	mdb_grp1_loop $ns1 $vtep1_ip $grp1 &
+	pid1=$!
+	mdb_grp2_loop $ns1 $vtep1_ip $vtep2_ip $grp2 &
+	pid2=$!
+	ip netns exec $ns1 $mz br0.10 -A $src -B $grp1 -t udp sp=12345,dp=54321 -p 100 -c 0 -q &
+	pid3=$!
+	ip netns exec $ns1 $mz br0.10 -A $src -B $grp2 -t udp sp=12345,dp=54321 -p 100 -c 0 -q &
+	pid4=$!
+
+	sleep 30
+	kill -9 $pid1 $pid2 $pid3 $pid4
+	wait $pid1 $pid2 $pid3 $pid4 2>/dev/null
+
+	log_test 0 0 "Torture test"
+}
+
+mdb_torture_ipv4_ipv4()
+{
+	local ns1=ns1_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local grp1=239.1.1.1
+	local grp2=239.2.2.2
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: MDB torture test - IPv4 overlay / IPv4 underlay"
+	echo "----------------------------------------------------------"
+
+	mdb_torture_common $ns1 $vtep1_ip $vtep2_ip $grp1 $grp2 $src \
+		"mausezahn"
+}
+
+mdb_torture_ipv6_ipv4()
+{
+	local ns1=ns1_v4
+	local vtep1_ip=198.51.100.100
+	local vtep2_ip=198.51.100.200
+	local grp1=ff0e::1
+	local grp2=ff0e::2
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: MDB torture test - IPv6 overlay / IPv4 underlay"
+	echo "----------------------------------------------------------"
+
+	mdb_torture_common $ns1 $vtep1_ip $vtep2_ip $grp1 $grp2 $src \
+		"mausezahn -6"
+}
+
+mdb_torture_ipv4_ipv6()
+{
+	local ns1=ns1_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local grp1=239.1.1.1
+	local grp2=239.2.2.2
+	local src=192.0.2.129
+
+	echo
+	echo "Data path: MDB torture test - IPv4 overlay / IPv6 underlay"
+	echo "----------------------------------------------------------"
+
+	mdb_torture_common $ns1 $vtep1_ip $vtep2_ip $grp1 $grp2 $src \
+		"mausezahn"
+}
+
+mdb_torture_ipv6_ipv6()
+{
+	local ns1=ns1_v6
+	local vtep1_ip=2001:db8:1000::1
+	local vtep2_ip=2001:db8:2000::1
+	local grp1=ff0e::1
+	local grp2=ff0e::2
+	local src=2001:db8:100::1
+
+	echo
+	echo "Data path: MDB torture test - IPv6 overlay / IPv6 underlay"
+	echo "----------------------------------------------------------"
+
+	mdb_torture_common $ns1 $vtep1_ip $vtep2_ip $grp1 $grp2 $src \
+		"mausezahn -6"
+}
+
+################################################################################
+# Usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+
+        -t <test>   Test(s) to run (default: all)
+                    (options: $TESTS)
+        -c          Control path tests only
+        -d          Data path tests only
+        -p          Pause on fail
+        -P          Pause after each test before cleanup
+        -v          Verbose mode (show commands and output)
+EOF
+}
+
+################################################################################
+# Main
+
+trap cleanup EXIT
+
+while getopts ":t:cdpPvh" opt; do
+	case $opt in
+		t) TESTS=$OPTARG;;
+		c) TESTS=${CONTROL_PATH_TESTS};;
+		d) TESTS=${DATA_PATH_TESTS};;
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		v) VERBOSE=$(($VERBOSE + 1));;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+# Make sure we don't pause twice.
+[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v bridge)" ]; then
+	echo "SKIP: Could not run test without bridge tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v mausezahn)" ]; then
+	echo "SKIP: Could not run test without mausezahn tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v jq)" ]; then
+	echo "SKIP: Could not run test without jq tool"
+	exit $ksft_skip
+fi
+
+bridge mdb help 2>&1 | grep -q "src_vni"
+if [ $? -ne 0 ]; then
+   echo "SKIP: iproute2 bridge too old, missing VXLAN MDB support"
+   exit $ksft_skip
+fi
+
+# Start clean.
+cleanup
+
+for t in $TESTS
+do
+	setup; $t; cleanup;
+done
+
+if [ "$TESTS" != "none" ]; then
+	printf "\nTests passed: %3d\n" ${nsuccess}
+	printf "Tests failed: %3d\n"   ${nfail}
+fi
+
+exit $ret
-- 
2.37.3

