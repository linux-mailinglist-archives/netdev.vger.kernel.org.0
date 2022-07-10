Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AADE56D209
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 01:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGJXx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 19:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJXx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 19:53:56 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C5562E2
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 16:53:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9ee4KLMebCJ0f8imO22Fc4P4OrW09DoPC8zhOeZGlyw3WTBTwRcj5M2cN+mnk/WIjj+rKPrs5UPQ9YAsrfJ+7mmxbZ2aqqnCc1/O4+/O4N0FUuekEoqCYMRj2twmeNHrzyD4XibfS6ZHGQ8RAig//NOv+eD7OJU5CH4Ma/P0UdH6CqfJRxbXFkihnRWa8y10ZXZRMvY+JKW4EstcGvXna2z0/N5C2pCxAgd2SnurNjQCdCVZE5W40CJ0xaj8fiThCidXxX2DGjBQIlHu8p0W8L44dv6/K9hHUmuLFzoV0GPEBveXMS2KmRU7FbubWjWb4SZWk+juoXFXpfTFtxY+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qIdT+Hp3hstPwCD/ZRVOfhA22EUTJm+gmpYhjDyqss=;
 b=T/rU3IXqJO1ZwJD1efJo+3mBYapHoL2yGqSifW4EHxotvlzHTjIKFL4BMo0pew6mSh7VB0A5A8bvOBgjMgufZNszozOcv/t7RR0hWb9PjfO4VAgptVlnENpQGg7a4o35o+CdjyW2jYSQZeD2csuMiLW1leQ4zMEgbhaW5bVnbOdH7OTUcJNFfO0j6vCrPLW7AWdLhZp9EaekUAQuUBhBjN/nIzejgq9WpbY69wpcvzRSplVFn+FSHV27ehgz1Ch9e/MQEnyOq4MhL+hY9Vv7/Fz5xBJNU3VY0EQWMPP4wiP+oXX4Rpsgct3yo1mu1bukYpwZs+Tqu0S2OkTRsIW3DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6qIdT+Hp3hstPwCD/ZRVOfhA22EUTJm+gmpYhjDyqss=;
 b=jUH+QrvrpnjbMB4FPfmU9SxfBCrO/1mATliy6lVZLcduVkrb1G6My/9DqztjTqfuTiH+fGxc0E8ePXXTjfzRrrTr3+AvHThxlYPI0lmZAypxTVkGjtFkOV/Kk3z2kGjNy+BmU3MPcieTVNt+RXy1q7HjEO+FfHRqe3GNPiN7CIPTLydvH7m+Ypbf3aw4ooxSTTiWkreJdPxRfBdZ4kVW4lahiP1Enuqt6lY7AgET1t91S2K1nFOr3UJhCWw06MRpNbYl0Mb5rL3mUqJRRWceKSANNcsVWLFs+GQI2Xa3p4EyplRfsQg70P/7264HIj6fA4zr0jdDT8/FyU01kjnscg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (20.180.244.72) by
 BN6PR12MB1396.namprd12.prod.outlook.com (10.168.226.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Sun, 10 Jul 2022 23:53:54 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 23:53:54 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2 1/5] ip address: Fix memory leak when specifying device
Date:   Mon, 11 Jul 2022 08:52:50 +0900
Message-Id: <20220710235254.568878-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220710235254.568878-1-bpoirier@nvidia.com>
References: <20220710235254.568878-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0039.jpnprd01.prod.outlook.com
 (2603:1096:405:1::27) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b292dbb6-8424-4509-072f-08da62cf7225
X-MS-TrafficTypeDiagnostic: BN6PR12MB1396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZZyDEG3OyOxkddPim5Pd8idZM1m9Fin8EpPiOW0RMDNJx++3AWeLwZqniH9AnAnPkuXHMis3GMx/D9+SXgEAL3gQFGF1Xb6NzD0QENhX+T3CWD/4iKPQJtFIc9fTBK407KnDAs+f5RsoimF5Wz/zp+HUAy4arPkiV2xqqIDhYInOieJ4rO80PnHKBiJto3myCIVjruh0UwOg7HKzSJjOBx/U9zxGxT1zHViI7ppqyXhpkspvxoTDH87QbR5XPtoFoYcb7+wsRF3QtkbIB6uzOYuzX9VRGUJuNbG/dMlGmAFpIVfzSsV7PTzS4uvx8BmIhaBhbWYA5kE3BTwrHaDTRBfOxUTwS2UyoCFZAqhwqt60gLCi6555aFxG6c9tjSNoJl3Zkk+13LreY81MOyeO5xfG9MHzDBwbNU/nls6j5ulCFaVHopZ8n5jnxDmnU26FER9Z5VOUM7gT2zueebaDwGA73bZVHVIyPUB4NPVnXM2Gb+4XiIk2vNGBzskdwgnkd3c0j8Oe6wpPs0JpGHHyhVU7sA/ee6X1x2QaFvmPtscS/1EcmFaYrnmmeG/u/Mq88AAFFpHUhzpxwhRq8yv2HonruTwPpf9+Fm+27COPGgjYkxSBhbuHCAktmRoO/4KqjwnFufmkVErT22XEQYNTd51a27MlMnrCaXPB7NEk5Fe9KY941yw62DCVbe4lM0oM38IiBYrnNlw9MOXz4RIU3cDzzgCPpq2ttL1txKtYSYUAN+KaMLdzQ12uwxgBfw8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(8936002)(6506007)(6512007)(38100700002)(2906002)(5660300002)(83380400001)(316002)(4326008)(66946007)(6486002)(66556008)(66476007)(8676002)(186003)(1076003)(2616005)(36756003)(41300700001)(478600001)(86362001)(6666004)(26005)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hg76pO2OCVMj+th5VTJGmy2xPTe+1GX7uUEQP3S225EzZyRprUXJQlc3mr6Q?=
 =?us-ascii?Q?H5F9J74JL5P+Mc9WeK/BZt9dDQWOIa52BX6dU3oYnJ22CilzYsrxR6HwqmnK?=
 =?us-ascii?Q?SXdXrLl9Qqs2iVRG+PScsUQJJo0AzNdpl8MXeX9bXKJDrwKfPK5zj6HtHWiv?=
 =?us-ascii?Q?mFG6sO9JTYmC71wKNxFH4P0e6E9ICGTlupBYyI0A6+1DZjXherw9qb85gp2W?=
 =?us-ascii?Q?r/BWl2KLcp5UUcYbLe1gb91gVeMtVrzP6O3W8oM02+Vfn9WWjIQNLQWELkAo?=
 =?us-ascii?Q?ko+XQuAaiARpa1hCf0hApqm41/hIKU/IuSJMrdNWG544DBtODlzXrjrC6quB?=
 =?us-ascii?Q?PGezqxnHVsp7Pzdx67/fpy6jBaWZNQz8dXBZzdD8uY7tiQKqmRvDdcrcwkwm?=
 =?us-ascii?Q?0m0Bpc0OsJnAIClLQuesoxeIVyR/wtHYCHLDyFjU1rk7WOoRI5K3bg/5Fh+k?=
 =?us-ascii?Q?FZXMk0KxUBdp0M/ohIqIKMaf9w4VOqBoW6RpfuT8oXRl13RtKtSwzLNflqCD?=
 =?us-ascii?Q?chIYVvl0d7snxJbHJKGGg/81xvRMUEUsN8O5IgpbXa2gv1d4N00/6AaxU20a?=
 =?us-ascii?Q?DPqIKbxrLVy1DfHAAnFKb9Mr5XwK0yOjPYyW4Wj7NpSrk3rxnYBbIqyS3942?=
 =?us-ascii?Q?/Hw93uza3esHZCqA/sByTRXe/WYNJZOFKL5NgYn3IVniyp2d1mgpTXSql4hf?=
 =?us-ascii?Q?lfT2R2T6ZShRd0+dyIIdMRCutm3lPpxVFB6JgKbMc07ImguhrAiluUBdyNK5?=
 =?us-ascii?Q?BK6RdW9bBTGzo+/8Uxq94ZKaZovlV3H0p4eH/r9YbHN2gXYitrvD6sHsszlZ?=
 =?us-ascii?Q?Fs5EI34eSFsZZos6+qxcJJ9j8b22yJ3WPY5wPAgdHciN6BBUuP5DflyFJrmS?=
 =?us-ascii?Q?Ek96LqwyrStmWT1GWso/Tksn8rQROSgFSUWhr1+7puVZYbrQLzQH8UOXNm07?=
 =?us-ascii?Q?huslVncYxTgmc6XIGdpoR8tmmvX1eTAVWKluBArimUqo1LX7EQwcIe/YNm3q?=
 =?us-ascii?Q?vfPiUwo9WDZ41Z+AiDeQnQAOq1y6O93OCtBPpkkt6riUyKs/wMtVh6QQYKOa?=
 =?us-ascii?Q?s+M+ljn27sYH4TtQuooess6NOGs0dDY2nBz+eOGn93pr2Oj4h5oPAB1PJ6VH?=
 =?us-ascii?Q?NvAbV/ygfrE8GYRr4JXK2kZchGTqIV1FbzJ/o6pS/KU0UcoNLRTYdVYI8q7P?=
 =?us-ascii?Q?8tSjyXNXYUkyqZMCLuJl3RF5SCLIjcgkpniV/9yc+Zrqil9SDJ11Nr9puzg2?=
 =?us-ascii?Q?5MxB7mlf97p30SuwlKRDamWADX5G3lLCDYV1aA1+4oavFArkM/xJgndjY0Gk?=
 =?us-ascii?Q?/uBiP3OZve0U7tl/NYvRNIs/ZsDhdv5tTdLsq1dhsZBySsVT+CZvNMJYul0O?=
 =?us-ascii?Q?1I1VPy3EiESq2i0IE0tDm6XJ/lur4PDNj54tTXzVlrf1lT6gPB4BO0vewEef?=
 =?us-ascii?Q?WPXiO9Jf1k0bj3jbPMFx63RaF3wvm0lOKAJW2ZuzEhs8zFQnKTIfiHDdQ8gU?=
 =?us-ascii?Q?fihg7AhCV3IMPspTz5nQz9Az9WPBMUdCiebJvMjRfwUGYeNy4XTZefi+29Fm?=
 =?us-ascii?Q?Qo7laLyHUB6/j2B0qJzw3Bp+1cvp3lNw2NsE2Vs4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b292dbb6-8424-4509-072f-08da62cf7225
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 23:53:54.1170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O50Abcb74G0Wy/Y4OPvs0L/lkv9TIBgfW2qimgmplntyKJ4vaWu6GNJkX9VHCkPQLxQL7m8Q2XR7xYiZ2zAEIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1396
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running a command like `ip addr show dev lo` under valgrind informs us that

32,768 bytes in 1 blocks are definitely lost in loss record 4 of 4
   at 0x483577F: malloc (in /usr/lib/x86_64-linux-gnu/valgrind/vgpreload_memcheck-amd64-linux.so)
   by 0x16CBE2: rtnl_recvmsg (libnetlink.c:775)
   by 0x16CF04: __rtnl_talk_iov (libnetlink.c:954)
   by 0x16E257: __rtnl_talk (libnetlink.c:1059)
   by 0x16E257: rtnl_talk (libnetlink.c:1065)
   by 0x115CB1: ipaddr_link_get (ipaddress.c:1833)
   by 0x11A0D1: ipaddr_list_flush_or_save (ipaddress.c:2030)
   by 0x1152EB: do_cmd (ip.c:115)
   by 0x114D6F: main (ip.c:321)

After calling store_nlmsg(), the original buffer should be freed. That is
the pattern used elsewhere through the rtnl_dump_filter() call chain.

Fixes: 884709785057 ("ip address: Set device index in dump request")
Reported-by: Binu Gopalakrishnapillai <binug@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipaddress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index a288341c..59ef1e4b 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2030,8 +2030,10 @@ static int ipaddr_link_get(int index, struct nlmsg_chain *linfo)
 
 	if (store_nlmsg(answer, linfo) < 0) {
 		fprintf(stderr, "Failed to process link information\n");
+		free(answer);
 		return 1;
 	}
+	free(answer);
 
 	return 0;
 }
-- 
2.36.1

