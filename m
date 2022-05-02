Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC65516C82
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383923AbiEBIyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383950AbiEBIyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:54:03 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B4DD9A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POtQ08OrYS41nNHvwCcb6z1GVbJBr/4nDQLDBy8RU5k38X3sk3HaS1DysMZNHpTLB1TNgxwd3uAPiiUBLFbiRE+LXSuVOPiTUeAULnNlUIjAlnhrAI5w2aUG9Addlw6JNE71ml0hNyCTAhpEbRhQWHqZyOX2iRcDy44y+s3gCHivYfzHetG8+DA2rtfK8HKecp8gvMoVmLwLs9GLWhekhIyX7E0X6CUv4RiHv4XAm/KHgE1j66FY4YKAfcgc0C1UU05HmwfNNeWDvCENzO/olR4NaIXNVTqTiikVQTvoO7KjiuToTBPtzXuTc/ySeeCmN8FD0hahuwbmlF8tU/p3GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSpL3pqIZ+qBv+uB82ueQTacUmnR7Poel38hjGqmhbY=;
 b=Qob2d+YfaWGRIPAkrXQZIcB6ZjAqhSjJcSnn98ICsjTDMfapAEgaqdTWWgtAM0U/yVkIrDoZJiiniBqZ5Ud8fBHrvghfTwvSV421TVzBHQDoOOkg1gzu63uT7IwGkjM59JSj780n0Rx0k3akI6PfKsnOLgBrAmH12djrJAYJ4ioztJRMumNZWCLwDRqa5HPXXEASCNP2ua/5Vx6jNpIicovbfOzwy9d5mI3qwAsWlSAG1EOIXh3mjVgZkd/XuWfTCv7OTgmkNQkhqOIZU21yi8C1HXKoqP4R1hTDfnltLk/oNppdHQERT2lnsRhpRi+zrWE8QAfTOyKIkrwigSc4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSpL3pqIZ+qBv+uB82ueQTacUmnR7Poel38hjGqmhbY=;
 b=RkYlhM764dmeyXy3ENbwJ35yqMuRairFEurSwKBecvAb6gBe1MEU+XdbKr8Ca8cAs9El9JJ1c34xHSmwVCP23osEOHC24Hiw2QNS19TvtR1VVsSqzDHhWBsFevdo0qCTSm84rF0fmDrt9iKeQO89BB/luOLehNkUqWay/Il3ScXOr6iydbjsyhJhwHB0Czi+OJZOEKeN/IqV/Y9uRjEGg70RA1lXVNNUCb0cuQBCc7pwOXS8McuNee+1Di9vCGsyCy8hSf8ITSmz24ln/Sg3aYEEggJTKePuuLa1mBi5WGyiVtTb3uGsuwT8g24VHfmCpLyV98pleM0Qb0Jmnk36Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 08:50:33 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:50:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] selftests: mlxsw: Add a test for soaking up a burst of traffic
Date:   Mon,  2 May 2022 11:49:26 +0300
Message-Id: <20220502084926.365268-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502084926.365268-1-idosch@nvidia.com>
References: <20220502084926.365268-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a06b66a-e0d9-4678-f655-08da2c18d148
X-MS-TrafficTypeDiagnostic: DS7PR12MB5912:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB59120F1AB4C248E9CE08B03EB2C19@DS7PR12MB5912.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: camR8LrRV9rC5Zg4gMflkbpvne2uVToUKa90DgSSTW3nUmMGstPlMwjpPr1+uxMnCix3t9GmqDM6hxO/7hLHwj7B0DlbfoD8Va7LZLuNHzoaDjRoLpjfCSxeaawnJuItrMlvNDPxLslFIAesV60dLWIqecv16upTcoE2/IHA11q4aJ6O2WNzrzGy3aH0grR04Q2zVGzRUFxEXorYN7NxKqt7ZMbwowvK8P4tqNHP1L+yFa+zFU9coDdqx8OUOMgQPJ047BwuAY5HLugTDVOBb7hKcYGMGrOojAuH3lEWlEY+ImNKPi9MO+dQyIz/9K/Yg2Wb7fXDv9p1FnoTVhaZdSuoSSiubStaGK7pdjKOTS8OwQ1rPMSdU1B74HLghZu96xfbaboh1uHb5wbbGQRRyjtHOCWR2Cpc/wIJcMCXz5XsZns3OLNnef5b99U3gJ3fpqFWIjdKGwlSoemwnguLxvclD8auMQZlzIP5VQa1vHTB5UfmGPXK7bRfEJ9a996HNw1ycxlylS/hVcTmPY0nLP+YB/m/U7yvQM26VNAtNIf0U+bn4/cOwteQAJYsEv19witxT1Tcgv3QZPqeRTq4ghfDxfyeOyyVvUhVb3oyVTIAgDA3zVi42cSgPcucQWJxBcQfxwR+eOY8b2d29ZGLVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6666004)(6506007)(66476007)(6916009)(316002)(30864003)(5660300002)(86362001)(66946007)(8936002)(508600001)(8676002)(6486002)(4326008)(26005)(66556008)(83380400001)(36756003)(2616005)(2906002)(186003)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?np82JQWsrKOBaD1rA435WU/RRmWziNLOFswpi4ICD3M+u5L/KNOmOW7XwnBw?=
 =?us-ascii?Q?urqS32l4YDdwnvjccRRTQGaxTn2fdg4GFv0Eurs4gWU0VmzQdVTBqHVfCM/J?=
 =?us-ascii?Q?znrku0Pu86IqNY2XYN6bQ2fBSbh+r9pwt+EgaUXMhkEf3ia5szqpsa7M9obn?=
 =?us-ascii?Q?/buUlaMsDst9/T5QlxC58g73gfkD/9DgOprFc/cLKFJdNRyJnoHFvS7KDeOV?=
 =?us-ascii?Q?uz74fxV3hqODVTXbF8p/8BqtUNPb1rQrvqbPkiabtzPbU9qMvdmSMcgFV3mE?=
 =?us-ascii?Q?XNMddH/Jj3m56GrVknWHhRizMcKKbjaMVAz9Np3IQFYY1xGv8UIKGdVf/eg4?=
 =?us-ascii?Q?NyjQDqXQQiVx1WF5nYm+CWN2iDiXb3R4907Rn5H0Fkt4LPxbv+FhuwzsZWKP?=
 =?us-ascii?Q?YFutccPfgDwXxy2BvUJBq7VrD7cajxEAAeTWMkXCa/bTvkxDEe8IJqg0dCns?=
 =?us-ascii?Q?J3X6scXqeNiIkHb3DU+VSHAJvf6Z0a3eB4mcWgOCOz9qJcvF6+lvD+4RV1f2?=
 =?us-ascii?Q?RY0On9bE0SlO5i/9mkoeStw3zAloQNXIAS39aZUlKATmMTBixYrpH7dhJDw/?=
 =?us-ascii?Q?9UAbZDSWZJ9ZfR7wttTLrte0QWMBQ3JoIgAVZ+K5+gq0WFD2O0JagTE83bnm?=
 =?us-ascii?Q?rMjlAzxWZzyiZFNRT241Tp2hlKV4ITbelBmMU97MfSjMszPtfRVG1flQH54f?=
 =?us-ascii?Q?oQwiZA+y6i2piHJjuo0P+afSbwABq8YzjItO/Ogryxa4hQrgl7b+Ugs/sj1H?=
 =?us-ascii?Q?jsR/bIOnjjyem0s2mFrUFYYBtg9GGBloiOLxYFGedJyql5QC+R6KycznRisx?=
 =?us-ascii?Q?+CPuRub92XRRgu+Ii3xtSh0A8Z5gbfjYogEyRxRuczD2cYQTfuurKycDAtAi?=
 =?us-ascii?Q?xdkhOw+D0wXmCC8AXj0a6yhVedv823ixZyhNR8vOGD6YMiYfWKkwR9sLfV7j?=
 =?us-ascii?Q?5snAWcjsz+RuOrcqibcNJn1Grq0TYTgB61MstxQOhnD6rDRoj/vDb5lu1kqk?=
 =?us-ascii?Q?zpB10pgvIovwPjCTNBN0+NcnHr/QYRshqwi7p7/qqWS0hoBrGKfaXxF2+bJu?=
 =?us-ascii?Q?CLnREZa9MXiBks26uzPqFgAovAU6hk7g+wo0T+CVNaXvwVopuRAfXIEZN+JP?=
 =?us-ascii?Q?7Y8husy+Fj83CTXbtdfWmUkMEdkoIaY0Bh5hKmB6nOwXb6RGb9jXb3fjWXus?=
 =?us-ascii?Q?og8VF276CLgdfpMh3VEK9ygffyyZogDS0hlFonA/7xPjYlBh+toKTPJ0M272?=
 =?us-ascii?Q?6bdhVPSw7xhJv5U9FojFS3a2vcxaD0c0UNSoATQ2cenX0azmE3z5OA3z1mSD?=
 =?us-ascii?Q?JoZKV7xDZB5aY1nszj2pw7LeUKGyjrwTbPDUqcY6AP43rExfwAg4TV+oXZLD?=
 =?us-ascii?Q?RvDcbi9nxCWWRW8N9JdDf5WHyOtEZpbIifrDbQUE8QuIYNvnFNg6OV1IByO6?=
 =?us-ascii?Q?Rr2x613pR+HD0YsK5IXpICEApV6MptdtNfGOlqZNeWFrl/sVE+ukhLkcMwge?=
 =?us-ascii?Q?UOFFktc+jkSU5QzDX1Vme0L4eFh1j1w3vbhTK8c3t8Kg8aEZ2ImP5bEIGxlB?=
 =?us-ascii?Q?4MJ/5q0sDIa1xeI8vA2wVgR4GPDwglU8K7p6YPEoxrLfJ+7IzwaY6NjB4udu?=
 =?us-ascii?Q?IMrY495bgW+r3H9f7pVcrezhmQKizMQzBedu9gpTqahPie366gopwif2dwgJ?=
 =?us-ascii?Q?Mygv33HOGi5j3Fa9wL0HBK7dE/bjPT0/bSp/4v3dBww4Miaff0/3E10BtcFP?=
 =?us-ascii?Q?PywtUPfmkQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a06b66a-e0d9-4678-f655-08da2c18d148
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 08:50:33.0590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xXahaERizqNyiGLmikYxwXoHd8Xu39RQZiGcgxEwboFvA+eKxljLF1piMx6VXBlu7ceT9WjM4ocjJnrg3Xcuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add a test that sends 1Gbps of traffic through the switch, into which it
then injects a burst of traffic and tests that there are no drops.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/qos_burst.sh  | 480 ++++++++++++++++++
 1 file changed, 480 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
new file mode 100755
index 000000000000..82a47b903f92
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
@@ -0,0 +1,480 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test sends 1Gbps of traffic through the switch, into which it then
+# injects a burst of traffic and tests that there are no drops.
+#
+# The 1Gbps stream is created by sending >1Gbps stream from H1. This stream
+# ingresses through $swp1, and is forwarded thtrough a small temporary pool to a
+# 1Gbps $swp3.
+#
+# Thus a 1Gbps stream enters $swp4, and is forwarded through a large pool to
+# $swp2, and eventually to H2. Since $swp2 is a 1Gbps port as well, no backlog
+# is generated.
+#
+# At this point, a burst of traffic is forwarded from H3. This enters $swp5, is
+# forwarded to $swp2, which is fully subscribed by the 1Gbps stream. The
+# expectation is that the burst is wholly absorbed by the large pool and no
+# drops are caused. After the burst, there should be a backlog that is hard to
+# get rid of, because $sw2 is fully subscribed. But because each individual
+# packet is scheduled soon after getting enqueued, SLL and HLL do not impact the
+# test.
+#
+# +-----------------------+                           +-----------------------+
+# | H1                    |			      | H3                    |
+# |   + $h1.111           |			      |          $h3.111 +    |
+# |   | 192.0.2.33/28     |			      |    192.0.2.35/28 |    |
+# |   |                   |			      |                  |    |
+# |   + $h1               |			      |              $h3 +    |
+# +---|-------------------+  +--------------------+   +------------------|----+
+#     |                      |                    |       		 |
+# +---|----------------------|--------------------|----------------------|----+
+# |   + $swp1          $swp3 +                    + $swp4          $swp5 |    |
+# |   | iPOOL1        iPOOL0 |                    | iPOOL2        iPOOL2 |    |
+# |   | ePOOL4        ePOOL5 |                    | ePOOL4        ePOOL4 |    |
+# |   |                1Gbps |                    | 1Gbps                |    |
+# | +-|----------------------|-+                +-|----------------------|-+  |
+# | | + $swp1.111  $swp3.111 + |                | + $swp4.111  $swp5.111 + |  |
+# | |                          |                |                          |  |
+# | | BR1                      |                | BR2                      |  |
+# | |                          |                |                          |  |
+# | |                          |                |         + $swp2.111      |  |
+# | +--------------------------+                +---------|----------------+  |
+# |                                                       |                   |
+# | iPOOL0: 500KB dynamic                                 |                   |
+# | iPOOL1: 500KB dynamic                                 |                   |
+# | iPOOL2: 10MB dynamic                                  + $swp2             |
+# | ePOOL4: 500KB dynamic                                 | iPOOL0            |
+# | ePOOL5: 500KB dnamic                                  | ePOOL6            |
+# | ePOOL6: 10MB dynamic                                  | 1Gbps             |
+# +-------------------------------------------------------|-------------------+
+#                                                         |
+#                                                     +---|-------------------+
+#                                                     |   + $h2            H2 |
+#                                                     |   | 1Gbps             |
+#                                                     |   |                   |
+#                                                     |   + $h2.111           |
+#                                                     |     192.0.2.34/28     |
+#                                                     +-----------------------+
+#
+# iPOOL0+ePOOL4 are helper pools for control traffic etc.
+# iPOOL1+ePOOL5 are helper pools for modeling the 1Gbps stream
+# iPOOL2+ePOOL6 are pools for soaking the burst traffic
+
+ALL_TESTS="
+	ping_ipv4
+	test_8K
+	test_800
+"
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+NUM_NETIFS=8
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+source qos_lib.sh
+source mlxsw_lib.sh
+
+_1KB=1000
+_500KB=$((500 * _1KB))
+_1MB=$((1000 * _1KB))
+
+# The failure mode that this specifically tests is exhaustion of descriptor
+# buffer. The point is to produce a burst that shared buffer should be able
+# to accommodate, but produce it with small enough packets that the machine
+# runs out of the descriptor buffer space with default configuration.
+#
+# The machine therefore needs to be able to produce line rate with as small
+# packets as possible, and at the same time have large enough buffer that
+# when filled with these small packets, it runs out of descriptors.
+# Spectrum-2 is very close, but cannot perform this test. Therefore use
+# Spectrum-3 as a minimum, and permit larger burst size, and therefore
+# larger packets, to reduce spurious failures.
+#
+mlxsw_only_on_spectrum 3+ || exit
+
+BURST_SIZE=$((50000000))
+POOL_SIZE=$BURST_SIZE
+
+h1_create()
+{
+	simple_if_init $h1
+	mtu_set $h1 10000
+
+	vlan_create $h1 111 v$h1 192.0.2.33/28
+	ip link set dev $h1.111 type vlan egress-qos-map 0:1
+}
+
+h1_destroy()
+{
+	vlan_destroy $h1 111
+
+	mtu_restore $h1
+	simple_if_fini $h1
+}
+
+h2_create()
+{
+	simple_if_init $h2
+	mtu_set $h2 10000
+	ethtool -s $h2 speed 1000 autoneg off
+
+	vlan_create $h2 111 v$h2 192.0.2.34/28
+}
+
+h2_destroy()
+{
+	vlan_destroy $h2 111
+
+	ethtool -s $h2 autoneg on
+	mtu_restore $h2
+	simple_if_fini $h2
+}
+
+h3_create()
+{
+	simple_if_init $h3
+	mtu_set $h3 10000
+
+	vlan_create $h3 111 v$h3 192.0.2.35/28
+}
+
+h3_destroy()
+{
+	vlan_destroy $h3 111
+
+	mtu_restore $h3
+	simple_if_fini $h3
+}
+
+switch_create()
+{
+	# pools
+	# -----
+
+	devlink_pool_size_thtype_save 0
+	devlink_pool_size_thtype_save 4
+	devlink_pool_size_thtype_save 1
+	devlink_pool_size_thtype_save 5
+	devlink_pool_size_thtype_save 2
+	devlink_pool_size_thtype_save 6
+
+	devlink_port_pool_th_save $swp1 1
+	devlink_port_pool_th_save $swp2 6
+	devlink_port_pool_th_save $swp3 5
+	devlink_port_pool_th_save $swp4 2
+	devlink_port_pool_th_save $swp5 2
+
+	devlink_tc_bind_pool_th_save $swp1 1 ingress
+	devlink_tc_bind_pool_th_save $swp2 1 egress
+	devlink_tc_bind_pool_th_save $swp3 1 egress
+	devlink_tc_bind_pool_th_save $swp4 1 ingress
+	devlink_tc_bind_pool_th_save $swp5 1 ingress
+
+	# Control traffic pools. Just reduce the size.
+	devlink_pool_size_thtype_set 0 dynamic $_500KB
+	devlink_pool_size_thtype_set 4 dynamic $_500KB
+
+	# Stream modeling pools.
+	devlink_pool_size_thtype_set 1 dynamic $_500KB
+	devlink_pool_size_thtype_set 5 dynamic $_500KB
+
+	# Burst soak pools.
+	devlink_pool_size_thtype_set 2 static $POOL_SIZE
+	devlink_pool_size_thtype_set 6 static $POOL_SIZE
+
+	# $swp1
+	# -----
+
+	ip link set dev $swp1 up
+	mtu_set $swp1 10000
+	vlan_create $swp1 111
+	ip link set dev $swp1.111 type vlan ingress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp1 1 16
+	devlink_tc_bind_pool_th_set $swp1 1 ingress 1 16
+
+	# Configure qdisc...
+	tc qdisc replace dev $swp1 root handle 1: \
+	   ets bands 8 strict 8 priomap 7 6
+	# ... so that we can assign prio1 traffic to PG1.
+	dcb buffer set dev $swp1 prio-buffer all:0 1:1
+
+	# $swp2
+	# -----
+
+	ip link set dev $swp2 up
+	mtu_set $swp2 10000
+	ethtool -s $swp2 speed 1000 autoneg off
+	vlan_create $swp2 111
+	ip link set dev $swp2.111 type vlan egress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp2 6 $POOL_SIZE
+	devlink_tc_bind_pool_th_set $swp2 1 egress 6 $POOL_SIZE
+
+	# prio 0->TC0 (band 7), 1->TC1 (band 6)
+	tc qdisc replace dev $swp2 root handle 1: \
+	   ets bands 8 strict 8 priomap 7 6
+
+	# $swp3
+	# -----
+
+	ip link set dev $swp3 up
+	mtu_set $swp3 10000
+	ethtool -s $swp3 speed 1000 autoneg off
+	vlan_create $swp3 111
+	ip link set dev $swp3.111 type vlan egress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp3 5 16
+	devlink_tc_bind_pool_th_set $swp3 1 egress 5 16
+
+	# prio 0->TC0 (band 7), 1->TC1 (band 6)
+	tc qdisc replace dev $swp3 root handle 1: \
+	   ets bands 8 strict 8 priomap 7 6
+
+	# $swp4
+	# -----
+
+	ip link set dev $swp4 up
+	mtu_set $swp4 10000
+	ethtool -s $swp4 speed 1000 autoneg off
+	vlan_create $swp4 111
+	ip link set dev $swp4.111 type vlan ingress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp4 2 $POOL_SIZE
+	devlink_tc_bind_pool_th_set $swp4 1 ingress 2 $POOL_SIZE
+
+	# Configure qdisc...
+	tc qdisc replace dev $swp4 root handle 1: \
+	   ets bands 8 strict 8 priomap 7 6
+	# ... so that we can assign prio1 traffic to PG1.
+	dcb buffer set dev $swp4 prio-buffer all:0 1:1
+
+	# $swp5
+	# -----
+
+	ip link set dev $swp5 up
+	mtu_set $swp5 10000
+	vlan_create $swp5 111
+	ip link set dev $swp5.111 type vlan ingress-qos-map 0:0 1:1
+
+	devlink_port_pool_th_set $swp5 2 $POOL_SIZE
+	devlink_tc_bind_pool_th_set $swp5 1 ingress 2 $POOL_SIZE
+
+	# Configure qdisc...
+	tc qdisc replace dev $swp5 root handle 1: \
+	   ets bands 8 strict 8 priomap 7 6
+	# ... so that we can assign prio1 traffic to PG1.
+	dcb buffer set dev $swp5 prio-buffer all:0 1:1
+
+	# bridges
+	# -------
+
+	ip link add name br1 type bridge vlan_filtering 0
+	ip link set dev $swp1.111 master br1
+	ip link set dev $swp3.111 master br1
+	ip link set dev br1 up
+
+	ip link add name br2 type bridge vlan_filtering 0
+	ip link set dev $swp2.111 master br2
+	ip link set dev $swp4.111 master br2
+	ip link set dev $swp5.111 master br2
+	ip link set dev br2 up
+}
+
+switch_destroy()
+{
+	# Do this first so that we can reset the limits to values that are only
+	# valid for the original static / dynamic setting.
+	devlink_pool_size_thtype_restore 6
+	devlink_pool_size_thtype_restore 5
+	devlink_pool_size_thtype_restore 4
+	devlink_pool_size_thtype_restore 2
+	devlink_pool_size_thtype_restore 1
+	devlink_pool_size_thtype_restore 0
+
+	# bridges
+	# -------
+
+	ip link set dev br2 down
+	ip link set dev $swp5.111 nomaster
+	ip link set dev $swp4.111 nomaster
+	ip link set dev $swp2.111 nomaster
+	ip link del dev br2
+
+	ip link set dev br1 down
+	ip link set dev $swp3.111 nomaster
+	ip link set dev $swp1.111 nomaster
+	ip link del dev br1
+
+	# $swp5
+	# -----
+
+	dcb buffer set dev $swp5 prio-buffer all:0
+	tc qdisc del dev $swp5 root
+
+	devlink_tc_bind_pool_th_restore $swp5 1 ingress
+	devlink_port_pool_th_restore $swp5 2
+
+	vlan_destroy $swp5 111
+	mtu_restore $swp5
+	ip link set dev $swp5 down
+
+	# $swp4
+	# -----
+
+	dcb buffer set dev $swp4 prio-buffer all:0
+	tc qdisc del dev $swp4 root
+
+	devlink_tc_bind_pool_th_restore $swp4 1 ingress
+	devlink_port_pool_th_restore $swp4 2
+
+	vlan_destroy $swp4 111
+	ethtool -s $swp4 autoneg on
+	mtu_restore $swp4
+	ip link set dev $swp4 down
+
+	# $swp3
+	# -----
+
+	tc qdisc del dev $swp3 root
+
+	devlink_tc_bind_pool_th_restore $swp3 1 egress
+	devlink_port_pool_th_restore $swp3 5
+
+	vlan_destroy $swp3 111
+	ethtool -s $swp3 autoneg on
+	mtu_restore $swp3
+	ip link set dev $swp3 down
+
+	# $swp2
+	# -----
+
+	tc qdisc del dev $swp2 root
+
+	devlink_tc_bind_pool_th_restore $swp2 1 egress
+	devlink_port_pool_th_restore $swp2 6
+
+	vlan_destroy $swp2 111
+	ethtool -s $swp2 autoneg on
+	mtu_restore $swp2
+	ip link set dev $swp2 down
+
+	# $swp1
+	# -----
+
+	dcb buffer set dev $swp1 prio-buffer all:0
+	tc qdisc del dev $swp1 root
+
+	devlink_tc_bind_pool_th_restore $swp1 1 ingress
+	devlink_port_pool_th_restore $swp1 1
+
+	vlan_destroy $swp1 111
+	mtu_restore $swp1
+	ip link set dev $swp1 down
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
+	swp3=${NETIFS[p5]}
+	swp4=${NETIFS[p6]}
+
+	swp5=${NETIFS[p7]}
+	h3=${NETIFS[p8]}
+
+	h2mac=$(mac_get $h2)
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+	h3_create
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+	h3_destroy
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+ping_ipv4()
+{
+	ping_test $h1 192.0.2.34 " h1->h2"
+	ping_test $h3 192.0.2.34 " h3->h2"
+}
+
+__test_qos_burst()
+{
+	local pktsize=$1; shift
+
+	RET=0
+
+	start_traffic_pktsize $pktsize $h1.111 192.0.2.33 192.0.2.34 $h2mac
+	sleep 1
+
+	local q0=$(ethtool_stats_get $swp2 tc_transmit_queue_tc_1)
+	((q0 == 0))
+	check_err $? "Transmit queue non-zero?"
+
+	local d0=$(ethtool_stats_get $swp2 tc_no_buffer_discard_uc_tc_1)
+
+	local cell_size=$(devlink_cell_size_get)
+	local cells=$((BURST_SIZE / cell_size))
+	# Each packet is $pktsize of payload + headers.
+	local pkt_cells=$(((pktsize + 50 + cell_size - 1)  / cell_size))
+	# How many packets can we admit:
+	local pkts=$((cells / pkt_cells))
+
+	$MZ $h3 -p $pktsize -Q 1:111 -A 192.0.2.35 -B 192.0.2.34 \
+		-a own -b $h2mac -c $pkts -t udp -q
+	sleep 1
+
+	local d1=$(ethtool_stats_get $swp2 tc_no_buffer_discard_uc_tc_1)
+	((d1 == d0))
+	check_err $? "Drops seen on egress port: $d0 -> $d1 ($((d1 - d0)))"
+
+	# Check that the queue is somewhat close to the burst size This
+	# makes sure that the lack of drops above was not due to port
+	# undersubscribtion.
+	local q0=$(ethtool_stats_get $swp2 tc_transmit_queue_tc_1)
+	local qe=$((90 * BURST_SIZE / 100))
+	((q0 > qe))
+	check_err $? "Queue size expected >$qe, got $q0"
+
+	stop_traffic
+	sleep 2
+
+	log_test "Burst: absorb $pkts ${pktsize}-B packets"
+}
+
+test_8K()
+{
+	__test_qos_burst 8000
+}
+
+test_800()
+{
+	__test_qos_burst 800
+}
+
+bail_on_lldpad
+
+trap cleanup EXIT
+setup_prepare
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.35.1

