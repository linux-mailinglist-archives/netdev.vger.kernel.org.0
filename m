Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E8854DF59
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiFPKoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359631AbiFPKnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:43:50 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94925DBF7
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFLVLcVs+Tsl55YK/gx3EComeGx0278D2EBYEkXzLL8bvHjBWk2Y812i35q3MlhM6Rv41Kc7SmipwCrwot+WvahDHnwESIzVISdLO3QTh7Vaks+Xncac8+ZgNYPsskKoyd0I8NOAsK6XpYSLhlnLbFuWu6435G89IVylunYjOTMMHs2gL9VGU1Kr1jpKTHYPROARbDcmBPhueGoAhPYzHtk39SLvledFrb2vFRp6idsZ031OsX6aOjHg3AL4LiJ0ybCrrOnqwnZz3eHcIJ+L8ojdDZZHysOr7pXHBHmNWngw5EkbcJstnjuFv7k2uDI2q0UFBL2P83/vAQDTDpvDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rA56Ts4Hxe5tYUl953pj+4KaAiLh89d6SrWBj7ony0=;
 b=FBBdyKntBTmi30xNWfq9YLCMBIkxGMyHRAxWk0wyhcAXX3drLAl400Uwe4JztH/pg+QWdEhW2n2D1s1wORh71POR+nI6dM8JE8h/vREIxloaLJmH/IPP0ejBRsHTDYiGuM3/AES1ZJTCdTOCH7eJCbv0EYMoG9ZAEsOb6GtE60yDkhIXnJzTy7CQmQ/1vF4Wyp6MKP4bnEKf+7kocY/xLrzgGMpsg0PbUaL62cSy8D+CQ3wp49wSibbv+5+H4Zt0ikXnw5Q72jG2VLIMjx0R+fMKmePb/EZQ+UOrVFoNBH2SSeydXmJ64xL96vWP8nRL+p/93ZmTxvps03oFTGVXLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rA56Ts4Hxe5tYUl953pj+4KaAiLh89d6SrWBj7ony0=;
 b=m/TcnXDsfJxMF4lYRI9rtZjNmUVHlk6hIxZKfgwbIi/1p41dWzG8vjPU41lSFO6A8ZkAaIVgqJmAeC1FwzudxkWuWEsVyi6xlZjDHdIDg5WwIXxFC5JGWmJRLM7JHrfyXHqQa409FYd95B70Nvc7afmDMGeIuMCkCrX8KbBAAkNNnDJRZFDxclSk2ePCB7xw5rRLR92izi4h42/0EJzacQkeETfVani/pqud2Nh91clDiTPf439EU2mCEw8HqHp7flaVC9pE91dfWDMQV718eLdjE5SEouc19CkYlm3k5eVaPJEXquuNaRivCZFb4E5h+vdvwTgPqUekTm/U7y9nvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN6PR12MB2670.namprd12.prod.outlook.com (2603:10b6:805:6b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 10:43:48 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:43:48 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/11] selftests: mirror_gre_bridge_1q_lag: Enslave port to bridge before other configurations
Date:   Thu, 16 Jun 2022 13:42:38 +0300
Message-Id: <20220616104245.2254936-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0180.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80229b6e-5d8d-4739-1c63-08da4f851812
X-MS-TrafficTypeDiagnostic: SN6PR12MB2670:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26708E5FD0B18A370DA61181B2AC9@SN6PR12MB2670.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ozTynXutTR3xDzsjl/bajnAhnC9gjE2LCl/PESTCn+t0JZ/AtOF6bYIo/YZcIYiP0sf6BvwNVdOcUM718EzblpdsnauiefXV3uaDDt2GvFaY8i7EWisU5zJtD1nMStWfQ77aHrs0hpPcXr4Q2nk/9DMt+AdJDxu22Y7C5KTcK2gyhAJYo5HJ0G3hYvn1dgQCQgQazbdIKChx301+0NqdwdRIaRSsJb5HwIcL2sxslvkO28v7dvAiwlW3rFB2f/URTAhdS93ioZNxNZ4IXlBsJt+dJeOxh+ODH8nsVicCUwVqO2fIX2M+2d+Ooj0u6ETocsf1n8YQ3cBUFTP1UQjj91Mxrby+qax4Fv6VncEvrPm2f+fBxf+UEmwG4VpO4qEymNZDY1PJu78htbfZmulkBBwvf/CN1pN7x3bVrGeZSELk/xiHj94lwWfLt+SneKoqOlpnfQjRJLJut1SqgT0u+zy9mFejkRwj5Xg6SQiY3ax6iUsuE3U8ZgfL01m9pQE9vBngihO168L/VqggEdpNGXY1vkgGHH5HMQ4RknLvlj7Ssr+/1tuu1t8QliKJTNmdo5g7P0QvhtsOmYY3wtARRraljTrzd207GgDGwYsZn4ZKhIotItMrOmm37WegAuDho1hSRa+lxX76M2DmvlYnUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(4326008)(508600001)(8676002)(66556008)(86362001)(66476007)(66946007)(316002)(6916009)(83380400001)(6486002)(186003)(6506007)(1076003)(6666004)(38100700002)(26005)(6512007)(2906002)(36756003)(8936002)(5660300002)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5Gv4wiobQiZl7yhKCHobFIdG3tWd5TwHSMo8ZJl/M9x5xS1IJ8DcFSdZtpf?=
 =?us-ascii?Q?tQtjATwxay9GJAGnG0isV7+gBWfSpc0bsC+hwTl4pEnIRxJBe/s8guh2H0a0?=
 =?us-ascii?Q?KAlf+Cu/EYLh0Vni04G2eDovM8N3AoSUFwg3oEsZFLE7iftg3B7d1JgsRMDN?=
 =?us-ascii?Q?mNkOCsvsc6C2sdPwgyYTDR9BOAaL00OwfxEqRQ5jutFo0kQ/38Cbiec50XCM?=
 =?us-ascii?Q?xfJFdOLDhhvhURrZcPdMMm1AtgaihxFZlPv01NoUNMjPjEdjRaHpSoJ9Pfdx?=
 =?us-ascii?Q?YYYwRUdcDUsduEX9YofAMUL27OD43TNesfJZSEXDlVIKvL+FlVQRS1j+ySjw?=
 =?us-ascii?Q?yNyoX3eQgQVY8LXVKPFV2cmQ1O0lfBLnstPXb1ubP7kYYMlzaLnw9g4ghw+N?=
 =?us-ascii?Q?SO/3xk/XthtE9OEaZdehWNQuB3hNg4gkYY/Q6wJvkt00Mm+FJbHj+2pVPz+r?=
 =?us-ascii?Q?8vE5c4bTZaBkbUQutB73YJYh1TD4Iri7XsEaPI4JBZnDrrxSFASMQS+b13E+?=
 =?us-ascii?Q?d8XhaXBnxQGgkkz2OPXexUzPZo2FrYmMmiomp4lpvB1qvqL9FM7GiPCSf7ar?=
 =?us-ascii?Q?I0VEWA+Tt+vPl8LAhf7wZCEbxS0iOHAJf/a7VAyVrToLt7RLcn0c/edce6nA?=
 =?us-ascii?Q?xUgXr8i1y0ck+5720W7GToIWcdWW4Hq5szuc9ffnIyt6qTM+lgI/tpBLhfxJ?=
 =?us-ascii?Q?A8rcLe+zMZfrqyxYQGmIH4jE9n1j5qkjO8VFe7wB31gus47a1S8ajr+Vy0Ly?=
 =?us-ascii?Q?xllcCqBaX9Q3bZb9lrRKBxRg6zDLCVahcM5QbMUd23hPMWybkfT3sTIftrbW?=
 =?us-ascii?Q?5/4YsskEVIi+vTjXkvyYYDdrETk1+nrMpNrdkvU8EvIdLxuzoQGvz036ryt2?=
 =?us-ascii?Q?7bXegRQ6EQnYG6YOV3c4f24FHC+TDjBtL6JMH2wyCiFn48xAXEcFFgsMaKPS?=
 =?us-ascii?Q?c9xkli6n47EnJ5FEs2v6XqQxE9MeXCGivdMV5sn5LdFYWUfx921KhGnZzuzb?=
 =?us-ascii?Q?Achsu7XirIeAKJnYShMRdU3b5MZrwawIddS1I7y/Hyf7Chyv4H8vzTaJUmA8?=
 =?us-ascii?Q?I+ToAgSpDfBp9wuRcudidrX5K97Oc18FO6/TBSuoCsWhooCv/4prQl8zOeCL?=
 =?us-ascii?Q?sW8kppkgOd8BBolU9eYvLgcbfKsURNFnW08T1YvC3/fTPwhUTkb5bvd8rAAd?=
 =?us-ascii?Q?rAUDNEorTCB/WFXSnEcM7wOzNKmpcHa9IJI67BDDY6Z+6IRrLIKBTIsSFPHM?=
 =?us-ascii?Q?OyY/6hDYDTxMXBuAqmb1JvKGB8PStktLSdeGiB8Lq+u9ASXWfFBKswCae2D7?=
 =?us-ascii?Q?+zsXa1QAHaAvQX9yyxe+j5UdL37tymPVp8reOm+wKRLarjfwTRDuV+6YG4Ye?=
 =?us-ascii?Q?G/IvS8bzyxFl9jgxTqfPIS9isKQVH192M9eZbr8jdMYSLTUNEpxIBTF1hLV6?=
 =?us-ascii?Q?wJRRqF0u3rlp2P9QuRuJIJm5SrEZTOOCLrQK6C7cH0kRZjXw5NwwkVdQCxOs?=
 =?us-ascii?Q?646gRA2OEfAa1u+MKU1eltiTJvjP12HSZZudoyQbOkU0Ix3GFoylKYGKLPYY?=
 =?us-ascii?Q?EpRHj22fkJMBzvg43wNdafm8gY+Van0IWyjNHXSN9+OAScUyzNAQKPRx6mqZ?=
 =?us-ascii?Q?Ga8jIuFsO+dIJ/xpNS7J1o2YckaQCoJp4HOGd7crzp8X0alH/ANqHfBXJRrR?=
 =?us-ascii?Q?cM5LbXwlh+j7+wvWYPG/HUdem0XDfXNddoiCB6HVUmy4/1HkX0AIp8/2r8dH?=
 =?us-ascii?Q?D7+El1BXyw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80229b6e-5d8d-4739-1c63-08da4f851812
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:43:48.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdftGOrb4JwtpUumD1/YmFXJ/DqQ6K0BrwmEX6PVeAaeERrYWBYzST+ovnfRMYZOsRRPpcd/N7BxAxeQhNflcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2670
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Using mlxsw driver, the configurations are offloaded just in case that
there is a physical port which is enslaved to the virtual device
(e.g., to a bridge). In 'mirror_gre_bridge_1q_lag' test, the bridge gets an
address and route before there are ports in the bridge. It means that these
configurations are not offloaded.

Till now the test passes with mlxsw driver even that the RIF of the
bridge is not in the hardware, because the ARP packets are trapped in
layer 2 and also mirrored, so there is no real need of the RIF in hardware.
The previous patch changed the traps 'ARP_REQUEST' and 'ARP_RESPONSE' to
be done at layer 3 instead of layer 2. With this change the ARP packets are
not trapped during the test, as the RIF is not in the hardware because of
the order of configurations.

Reorder the configurations to make them to be offloaded, then the test will
pass with the change of the traps.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh   | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
index 28d568c48a73..91e431cd919e 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
@@ -141,12 +141,13 @@ switch_create()
 	ip link set dev $swp4 up
 
 	ip link add name br1 type bridge vlan_filtering 1
-	ip link set dev br1 up
-	__addr_add_del br1 add 192.0.2.129/32
-	ip -4 route add 192.0.2.130/32 dev br1
 
 	team_create lag loadbalance $swp3 $swp4
 	ip link set dev lag master br1
+
+	ip link set dev br1 up
+	__addr_add_del br1 add 192.0.2.129/32
+	ip -4 route add 192.0.2.130/32 dev br1
 }
 
 switch_destroy()
-- 
2.36.1

