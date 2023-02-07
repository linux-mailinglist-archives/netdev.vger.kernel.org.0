Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02F68DA5E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjBGOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjBGOSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:18:42 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7093526F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:18:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOotcRfYku0GSgNQCPpi5QmVul9UGieXyHCEr42/aIPBQ1QlLaYvvnD7ZZFZJKAFOeIAJgT22alNbJirvV6vPgUBfSA34k8+TTQ8kgWoL9HM1uugiTpEHsVFeU2Kta3IWzOLsypsGD4MQHCP10nZtzV/wDM4wwPA+o/SEdvh5zlmGX4CZfMiDhu6+i47enaRFpvPq0qxLlerYPGZsm04TB4ryJx1O/VI1W00rO/32wNzDaAURbGK91/Z5r+cM8lpVBW2LxPMzW1wGwTRLNJclP7vdan1l3WjHHyVYTEvSU3/ltwSvvKffycMdEKhmWTZohqBHXFTilCPfB4FsekjEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHYC5lH8E7K/F7DkYIkgCKE4Xn//HHAyFP4TuCmeGM0=;
 b=QhK1Td2cuE+t+ymNz8DGgs7K4UwuH7uehH8I+A4ILeoDuS/LU8NW92D5SwkThdh7IJ4I6DEKqPn+v1HDr6evCUiFJjdqljezU0/lYH5ueA3p5gA8DHZne4i3ElZy8N2rSeDfidJ4UMStN8V3brzSKryrTQRktVhX/EA8m0H3C2KPUSr/mPMFxmeJEUz/a2qp1GxvKZC+JeBWKmJo5dN1PHIbwDZrRDSeeyZZm379mNefrgEJjoO/qnQup8UD05Q2cdjvkR/MKAVEqebqk9EIo4ktHSDLkWRFHnvzKaUP5gof9G/lDRK/QsjMb0hMM2JYC9mQ9BwmpI46xoiQCMK39g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHYC5lH8E7K/F7DkYIkgCKE4Xn//HHAyFP4TuCmeGM0=;
 b=p9n0JOjscdzUGH6nEfToDu3+D9wDQ0bpVDMrqRmlwa35NPC/CSigZcIMt2XrL4oD5vk/fIvYwNxRkP2z2LickMZwlp59Smy+Iaw6wN7ih2/zR/3FGr4knfmkxrzFWqCtEPcSbq9+6nPuvo5j3FycF1ppz8hk2F+jkGpLGUE172n/xbylhRHmHwLBHnu4j7bJKub6ZHsvGcX9pNjwPMWyJG9CxlGWSQIKfXmK5HDcX1E1t/ZGdMY97gUrB7E+dq/LM0ZxRU0C/7r1YyqIdwmX5iwnb41bj0YjN6uimmPov5ZziI65uFH4MaXIy+Gt3lt9cHmaFrvvQdp5lX/lY/c0SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB7312.namprd12.prod.outlook.com (2603:10b6:303:21a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 14:18:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.035; Tue, 7 Feb 2023
 14:18:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: Fix failing VXLAN VNI filtering test
Date:   Tue,  7 Feb 2023 16:18:19 +0200
Message-Id: <20230207141819.256689-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0089.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd243b5-0bcd-45a2-6095-08db09163350
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhHzY52nOputfFiDY6KbLjGOdXHOplt7kkIjsAsUfLbEzVcMReiqdFXXjcy9FKhpME9H4fukeuE9VdA4jmkGiRE8StxXK1IOCQIFlWuUiXjleYe3AoKEShI7c5YMhrYGS5kftbGa1RnR1KWvWAduRs1FFmWE6qib7LhCG3EPKPSTwp/lh/+EOj2dySe4qRNELAcxzwv7aep4LiYYvWk88rOiV3vE0J/QIhFzhg8yQmffzEBTRJEElndyas8DXfSYdA9vHasCl9fuDAtS0KWyBeXa4xC3ki1sTNgfzxkA7tDbPsTlAML1dmZ9pUguvIta6PYMdXXG1OoM5Y4teZ6pOs3+ne/LkG1w4JSOqiV0jXOkUP5iwCHikFGrILIDtSE14vIhC9PbaC+4gS7u6Xc/18/v/dPodplZ+RM7MPiDvwo0rVT/1Kb7BQzqwZcQavMwvIfXcUBF9ITwbl+z+q1hMUA7CO2IFuYFuY9HNUqUYKdF7NvFqXzEOjFWtk1VfbzrxgqAqP8MhZcCz+VcyMSNFHbn7cF1Bc9ftqsIV89iRvopk2iYGcR4aPrMRY2phpfKLZ6MwNHxbIfN67GLt+hHABlC9WbusT79unZqzP8+2/jzPtMy61jFeBUQ/3AuOvpKbn7BSd75jl15J+fEpPWd5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199018)(5660300002)(316002)(4326008)(66476007)(66556008)(8936002)(41300700001)(6916009)(66946007)(8676002)(86362001)(36756003)(38100700002)(6506007)(1076003)(6512007)(6666004)(26005)(186003)(107886003)(2906002)(2616005)(6486002)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UMXwzssr+MFa2xEl0taXxzy9EVcDqOa571TAPCQPo/4y81G17Pup1gjw3jHb?=
 =?us-ascii?Q?MxOuMZq1k7YGNuGyB1iLMu5pDhNGcGV0TZBYgEE631In8sk+/UUyLERRiz3o?=
 =?us-ascii?Q?nj5Bz9Q34452FDyX6b6Fss46nYSj6Jrq8IuAIK2eyfCd/SG4sfBjEptS/BsT?=
 =?us-ascii?Q?mVPx3BqZp1OmIaHBAgDXgvD8ubqXSHGROKLhk/bjaEW0z5FC9mZ8WhpjKfKO?=
 =?us-ascii?Q?wuuzw4aw513uKufVZpAYefBMC3HwSTWuzk4HbL3qEj5Bi3uit2n1NkdfAuxz?=
 =?us-ascii?Q?2+P2ZIvuPfhMGy4/UJQqXc2vyPQzvtx07BZgb2+nfZaGw+TqHBhTckRxgxLM?=
 =?us-ascii?Q?VD3lOuNfCB3Dj1MFYMUqLa7vdu7OiwgnjDwsVMEDC3GBnR99LLxkV6NX38R+?=
 =?us-ascii?Q?gq23ABo7qoIb0jUN6nUp3aUU0Vu+cfHrLRv8qJWSwgtu50p44WEwMRpMvpec?=
 =?us-ascii?Q?8DrqGqaUjhhFgzKfrMsH+YLHNHje0nb/poAqvMFlqAQmy0gBUhRf+g3/kpCq?=
 =?us-ascii?Q?lU6q4EDikBk6jbCUcGTnk2qWRg1RjTaeRAK5OYBfaqDQ2Wam/PjoEfVetp88?=
 =?us-ascii?Q?LwkxoPjvaGSmfGz2UerHo2XiIpAIZehak2YoqQY/9/DC6GxU1FkDJKp5ec6H?=
 =?us-ascii?Q?GiQsjXIsW9ppaXjCg/eJy8r6OKTvzoO8CxFDEJqr2tjkFoWmiWk4nJkx12Od?=
 =?us-ascii?Q?ox3hRMpQ31t1W66C9Cbm8McJ5aiD3ENK9Bn5wjQa9MoaiCxREnKfKGa543m7?=
 =?us-ascii?Q?AV/7k51QyPFou66tjyYX7YcG89EgjKe90E6jdkqOqjRQlKFk9vuKQFMM6EyW?=
 =?us-ascii?Q?0GrvjARNbVa0r9F6KlRrRwXGeFfBmKsY689o6TKykEmJpQTcTZLjTsnGyFVY?=
 =?us-ascii?Q?IHgckCPk8XFSdK66ddReUkbM1fnGTS4B8Uqa85HjU9FXCMHG/8geABnBmW53?=
 =?us-ascii?Q?hdU/cBnDyBcSY4+x2O35wrU8y5SCAwUqnOlBluhvrxSssPBDkSSZmCzklPlA?=
 =?us-ascii?Q?BagGenQtPA6gT6hDHxMeD2UAo2bzIa2JVPRKzgFCDixTQJHI8C5soy5qfDen?=
 =?us-ascii?Q?60R65iD3adRQZKb9PVjf4Dx7kGJyePygt5TwoRG4en3JGdYFu37J/ghhthId?=
 =?us-ascii?Q?IJMdbR5lPmQJq3AketdWr/J9s/N0gqtzSPkMOsik8OpBFF0M1u4Eh24qrsJl?=
 =?us-ascii?Q?CUwwAgZNb+CVhEsapHWkxsdxH3Nh8uCWIeXIY85ZcOeVxM5e22OYLPeebW9A?=
 =?us-ascii?Q?Y27aKk65XgJRppZ9pf75uIAmxGChOlgx8qBpVER+9CoWZEWMMINOMCwYVEyD?=
 =?us-ascii?Q?0yF10YhbwZvy+KySFSGS8SJyIAKBoVgcSh2gEE1eHZnnYaZYNXi8wpHX3i1o?=
 =?us-ascii?Q?ck1xAroYZTyQMoeBIR3Oe5VRO5B9HOo0J+7b27TcRgUS8Pb1pJRlnUmZkkZ3?=
 =?us-ascii?Q?rmuTf7XBotyPNOQNPXk4G9JrOgpo/bxJ1RihVgDn7K4iSAHTYBUDe3Nk0ZTa?=
 =?us-ascii?Q?oD5H9rFLF5B+5CwUVRgfVi6a6tt4rQnq3wsAAjlHEQ7dCjmv4gxM66AWOS61?=
 =?us-ascii?Q?K1ML0CC4coDwrJj4QB8ZhW0fLyIjQVsp9rCzUR27?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd243b5-0bcd-45a2-6095-08db09163350
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 14:18:35.8986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KaHGzOorEugYTprmhv7bYg1YROJus5mj09bWmnJSg1enU5wPDFtX2+P9YzUQZ2bOUPQ4JvroxEK4744WunJlqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7312
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute2 does not recognize the "group6" and "remote6" keywords. Fix by
using "group" and "remote" instead.

Before:

 # ./test_vxlan_vnifiltering.sh
 [...]
 Tests passed:  25
 Tests failed:   2

After:

 # ./test_vxlan_vnifiltering.sh
 [...]
 Tests passed:  27
 Tests failed:   0

Fixes: 3edf5f66c12a ("selftests: add new tests for vxlan vnifiltering")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/test_vxlan_vnifiltering.sh   | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
index 704997ffc244..8c3ac0a72545 100755
--- a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
+++ b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
@@ -293,19 +293,11 @@ setup-vm() {
 	elif [[ -n $vtype && $vtype == "vnifilterg" ]]; then
 	   # Add per vni group config with 'bridge vni' api
 	   if [ -n "$group" ]; then
-	      if [ "$family" == "v4" ]; then
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
-		 fi
-	      else
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group6 $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote6 $group
-		 fi
-	      fi
+		if [ $mcast -eq 1 ]; then
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
+		else
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
+		fi
 	   fi
 	fi
 	done
-- 
2.37.3

