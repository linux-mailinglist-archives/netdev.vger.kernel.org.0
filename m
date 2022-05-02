Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00661516C53
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359489AbiEBItv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359476AbiEBItt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:49:49 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A65926114
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:46:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORwQuOqxlMFc0rVdneC9snjGPBxKDbagHOX8JAtdOWex2wmqH7+uMW5291m6DCbj7rclVIoQxI/SoGdoP3aT3/s655xrlNXyby7zDk/As3JrdA0NidNha1X3yNDffetTLryW1I8XL9KhNa42NyycwH2Nx5cHcKtN65aCKTrTb8umHR5FLKZ9J8/Y/QcLnhszVaKWHd5gbIWqytEb8KNaL1qo7BfyGUzqU8s5EdpVJN+4qKt5ZrK8ot8lLPdur5S1cX/TA+amfRsPuvXxRo845lw9QOJ1xb8fWod+UY3caronGLrzSrFFKy+4Wl1NahbAhQWZ4v5UO3OzccWBzs/MrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+3ssMV+m6vl8b+zMh263iE9sZDOevOo4l+mzZYlEnA=;
 b=Olo+5R5CVdpJJAtGl946ty5KbdC8HCnXbtaC4lAIXD5VN1IDJEzCmkjL9Arj+8TDCl1GxaQFDJfDnpnQjliFSuWsrMDzC4HBM5DNiBolTRF9wRv89bIxncHNUff4x3ITMTVFt9B8mqAJ+WzeSH7txxcZJWYP0cc9v0GblEMwN/YVSnNYk0dM4sIf0pU4GcMgEofYGSDQtxJhIGy7V9wytUv6CFch3cLa6xY63GeAqhl59kj/Iqm8PMtGaz/E31wq/GE2PRsqNIAjEBF+gfCyYTiMBJGTLaFPdi7+oaF9mMGhJUTT9Jyz066Tame7gVtcvvpCW4AiVISZxD1zQeKeMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+3ssMV+m6vl8b+zMh263iE9sZDOevOo4l+mzZYlEnA=;
 b=Fxvyrxs2HqwYseKqzBRS/hDh97gp0Uz7JZfeSXaxwi6uabbohJBDy7arWV4FT0w8zsxJ0dBJo6oryrpahpiWE2/9D4hAC+2W+JcMataVANbBY7wdkd1v051cHkpXUWZ4bfAAPIYiO1L6tCdO+dNY8rM/qLlADmrDNECo497X4EZAPBby6BK1UdI7Hx2xthKXiN9ZqoIPVZdkXMKkoPPqkXmP3+1SoV1SOuBkM00nFXcqBK6sC5798VlO/vYKCZoyQe8BldO8tzO9u4B6BhNEoJRhYjNvpbheU9Lzegm8bRZdB6oa2jfDyMFUhHUyNg9NhoBW+HJhOoMfOM3JpFBy3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 08:46:16 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:46:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational
Date:   Mon,  2 May 2022 11:45:07 +0300
Message-Id: <20220502084507.364774-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0066.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::30) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60c8eb2e-f2ad-4dd3-ae16-08da2c18388c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50485BB1DFFDD8C7EDD157A3B2C19@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzG7eer3J5yCNUN0sRJvzVlfyj4Wsf3f4wwbrdXrzpbp1iDG8GpBrlMbzgk7cP2UqzPqttkTz8rMEeZdNu8G5w/sNJi/fMFUqm6ty8A5WsiElSPyPANJqSnYcbfR67ZIv3OdNgMAlswZMp2BxKZ/IK3APDTF4/UX42s1P5FuYtVmA78g4ooSkTQyRsM82NLHNKAgV95YfUa08SweEkICwz4CJdFIgbGMnt/Nq2V3Uz4d+bU5arbz8TCfw9hxfYkQc6j78/3cziNsu2mOMkmVw1BjWGxKggSykC09ExcLZPGsN1FsTrOf8Mw6aVsuA3nM79N+yzDFrQbBf+VmHrxjt6cXHO3Pzep3upL/AaUBFxY31sh/SiCYEHBwk4L+JCTXJpA8RxssQSa3BY0MjVJKrcWwrbnwBPFS3HlI/fZMD8JgGpOAXNs3Mn7SYQxWsoKe1vQz5pNRJVNAguQSwtxJ9w7L9CMZzQs0yf0P2+U6Yb8kMiR0V6uNEJYyaUB6Ksq/MZHB+lGNOgjZuPLkAxOB0+5I5wOBRmOasBeS2lVu22ddc4vbLhI3KRU5NWFNm2t5rbQHBzFbU99gZXIomY7XZpgc/WdjjHUMOmQMZenHu0xYlS2e+yrxWN7FZPLjFhJZciX/Ft5ISAJ9WRDNURyMGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(6486002)(508600001)(2616005)(86362001)(1076003)(26005)(6512007)(6506007)(38100700002)(6666004)(186003)(66476007)(316002)(66946007)(66556008)(2906002)(5660300002)(36756003)(8936002)(4326008)(8676002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QZF65pgboMzAtPUcAeRtqDVPyeNQ5pfIq+C6Hzaogs4XPW40k1m8luTjN6jy?=
 =?us-ascii?Q?61r0fX3fYbWTYOMGG6BpC2V0lFD15vW0uql6GifUOjY36nm4px9o5vK+Ct9g?=
 =?us-ascii?Q?J4fMjwT4WV/AjhWFa78KezXJHDtzXGdO6QaMEbvgPEbq3rZpxcZZ57XHdqw6?=
 =?us-ascii?Q?nvGWeAylecI82xRD4UQZ2L94O94U/e7DlK+LPs175BasjlY9j2PBNPBsYSIe?=
 =?us-ascii?Q?T5bmNnj+rg6fgbVhzdS3TJ51BvFTg+6iW4dayPwk/rDVytGuJPRB6Uo70OAg?=
 =?us-ascii?Q?0NY498NN2nJ1qLmtREYhdaamkC4z9MSzW/qfnjTP+9tj3LKs1PNzW5JGZ7zw?=
 =?us-ascii?Q?cQfI1iQYBDlSCkqyFgpviCjr3vL5dvmPp1QjUTIXxI6rN4fwWOHuNkmPOeqj?=
 =?us-ascii?Q?aeKV+uXQ+p0rbfSI9g/xgtQ7ocHHhF8hYqIzNHxaXsR1ORCRU4LedMsd3V9p?=
 =?us-ascii?Q?Jr1mqzRthbhERZaqjSGFYiEocQr3zxWy7+YaCiJnUQJ1zj2Akk5o7rv+Pu+X?=
 =?us-ascii?Q?+7kLit5bDeluypsVkt6U4+jJCI3h9kWlsVSJSi9c9EB1TZPYG0OXjrpnK00H?=
 =?us-ascii?Q?CGUmr8QRKFvM004+1ib+p0oE0UaW00Wok1JqbC6Wnnvo2OdpuEJoUAzVjkct?=
 =?us-ascii?Q?QPbJEn+m+/4gV3gkYh/8UFJCuUNlJ5UZkuqXGvwRBOJaQthRZQcK6+7AjtiN?=
 =?us-ascii?Q?0B1g28GpFmNuLzNICvHTRe9y8PIVGmMaB8woXn8kUtVy+J+l7KGWWuM78/VK?=
 =?us-ascii?Q?3+SXk+4fLNu1WjJG6WdYXeuU+gOKQMlhdzJryaqUcePjOr5PHnLcbeB42saP?=
 =?us-ascii?Q?DDpuezPWFxqHGLwagAccTK5J1Ly0dEgRyR+92p/FPR8NbNabGXzeuFYtS9r6?=
 =?us-ascii?Q?3pHrqXv2BpB3Yioz2P8vp8TPxcwqgm5MMRzLChQPkNMHO5bGcGsuigS5x7J0?=
 =?us-ascii?Q?rJOOHlhybuXMk7F+2zkNcmY+f296dLQ+pgEyFCvMfBr4hM1bQ8R+uA/0D9cw?=
 =?us-ascii?Q?0rSERQ9bt4bg1/KMPcPOYpiNRLRigu0JWFDibbcdQZ0Aaop/vFEtJXqxL5CE?=
 =?us-ascii?Q?7Vo9mbTin74mtaoD390qdOpMlYAEFgRS/B8doKoyq3GWMtfs9nwNiie7ryPU?=
 =?us-ascii?Q?DCIzZh8eYhm+M7+Xo03HjJAB5v6rZoR1KFZnw7jkci4SEvczgXnlDRw1qNet?=
 =?us-ascii?Q?WeRiUiyg9jbmq5kcCusUc8MVJKAjBvfbsDPCz/oJ4OrpX7KMlrQuGLp8ukaR?=
 =?us-ascii?Q?AAExLK/uCg3/xFpCylTxffVx8re8Hl5Qdb6zJtyyJsuqgX0rpBFA3s16SqgZ?=
 =?us-ascii?Q?AmyN4txyXk8KiqGb8f8L03KtAm67/fI7DqalayOh4JqHjqmB2YvktTYKSuk5?=
 =?us-ascii?Q?NzJWCZrOqWHB4eFsHN267HJICsMq0xBNoYitWk7yM8AzHyMQfz1o3MerJvzO?=
 =?us-ascii?Q?Zls5DXKiZWk+UF1W0JYiZ9G2gWwOndsXUGJ+UImUCuO+BYg+4FHORNUFrpTG?=
 =?us-ascii?Q?e+2f78YzYcEaHpzAi0AvtNxev7LRSkBhaVQStmBHc0Is0rZJMYAWRKpl6oPc?=
 =?us-ascii?Q?gNSjWmFcszuTt3lmWSVBRB+1+ez0522C+IyBvs6oGy/5Lo4OTaBXVbpN7om3?=
 =?us-ascii?Q?s8yXCBfypZPry8zHui1dA/DM6AFU0VtOw7pWuSgZSEumBDwM8b3MPwrMv3RG?=
 =?us-ascii?Q?lhMC3qIU05/KV5Tuy2l6I4780+COMF3V6fytZg6gx8Jn5i4wsgeUWDX8RHEj?=
 =?us-ascii?Q?KdSUs4l+ZA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c8eb2e-f2ad-4dd3-ae16-08da2c18388c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 08:46:16.7177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bvA92mZ9gHFJHk7BCYvkpjCM6Tu/JR4pjnc2B7SojMJvLSbBc/GL/oRb2Vpkza7CIvluG9h07IO71N96gv6OaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In emulated environments, the bridge ports enslaved to br1 get a carrier
before changing br1's PVID. This means that by the time the PVID is
changed, br1 is already operational and configured with an IPv6
link-local address.

When the test is run with netdevs registered by mlxsw, changing the PVID
is vetoed, as changing the VID associated with an existing L3 interface
is forbidden. This restriction is similar to the 8021q driver's
restriction of changing the VID of an existing interface.

Fix this by taking br1 down and bringing it back up when it is fully
configured.

With this fix, the test reliably passes on top of both the SW and HW
data paths (emulated or not).

Fixes: 239e754af854 ("selftests: forwarding: Test mirror-to-gretap w/ UL 802.1q")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
index a3402cd8d5b6..9ff22f28032d 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
@@ -61,9 +61,12 @@ setup_prepare()
 
 	vrf_prepare
 	mirror_gre_topo_create
+	# Avoid changing br1's PVID while it is operational as a L3 interface.
+	ip link set dev br1 down
 
 	ip link set dev $swp3 master br1
 	bridge vlan add dev br1 vid 555 pvid untagged self
+	ip link set dev br1 up
 	ip address add dev br1 192.0.2.129/28
 	ip address add dev br1 2001:db8:2::1/64
 
-- 
2.35.1

