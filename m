Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884C856D20D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 01:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiGJXyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 19:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJXyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 19:54:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2046.outbound.protection.outlook.com [40.107.212.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B34E6336
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 16:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EScz6rXx1NdE5QI0Zxol6KCKUnpD8TN6TXymhcz4DvjXGkT2XGKUw04e7/PkeyJ5Voxe3p5iz3ILz8l6NcQBkBjDdgEYL5Pill4NGzdotBgU0VUe3Wr1+HEZ2kFhIAhCHddWbdh0LGgh8imhUj0T9XPm7bitkn7ha+9GrhgsxUSsxXm22RzyzLm+1PkWWxFrYuhRc/R5aXLxmB8vhX3bwMzD5MpXr7R/qn6HEH4Ij8KxBQK5fEiz5oNsFNXCUG9bLre2IMQSLoQvuCdO9EBlaQATRtpL1jfEW1Lht6bc3t4pj3I2kD45Ya3NJRS07IW0pidpF0JeeobqD283tVokKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHyX09ttzXWVJD45Xlm7muR/RO9dB3sAwyow7mBLb/s=;
 b=e8zHJtmCxEF2P/WlOFl74mK37RlK5HcA1YwZbD+kNMMMsSt8aohJmickq7ycfb8QR+7RJfLQY6C+b+6yEpM3+ny5vTxqvSifj0LbdSaegRTNkV2/EV2l2nXLTYYTfJpHzlo2XUX1tTJ0s9V7acVauv98dfbdW/M87MpCgkkbeMYlEacWaBLEZ5s+zIX5eEp9OTAEBpH4OJYyl3JkDph7khML/dey9fQzUVUj7aN8aKhv6lF2uPHleBn5Z7cov2NY4mcdVfKnxu57FsJFv27ls2kXXz6EopcJakZxl7eVP1iJCOj+og8G2pHbaTW1ybiSZRBugtzombwQfsJsrreF4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHyX09ttzXWVJD45Xlm7muR/RO9dB3sAwyow7mBLb/s=;
 b=pny5JrwQI6prvf37DPcYbxKVx0vmbpaYuJew69n/cwOWj7+HSGCfptgg+3FEfyDdYnSCtIWJJrDccMw6AaOGcOUinbRx0+TFiEEdJRnhWDxKYA87fBqdVq8yHAxLd5d8kzRA8PTF4WDbD6eeJ05aNOPk10CaJo7xlqnUaqDpf65HtoD1tb+OY7GHcOGayertFfA+NdjFInxkH/Qw5P9FE0k3eUA0OMifNf0m3dZUX/LkmmBHCiObFBS8sF6c5MgV8uU1T1b/gBRpFK6xBOHlzYskCTxOvbdkgYzG6h268GhlQHUcqvMEOacIW9suvI0Mmn2D8dtK9xE7OoLYN4Vr0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (20.180.244.72) by
 BN6PR12MB1396.namprd12.prod.outlook.com (10.168.226.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Sun, 10 Jul 2022 23:54:00 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 23:54:00 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2 2/5] bridge: Fix memory leak when doing 'fdb get'
Date:   Mon, 11 Jul 2022 08:52:51 +0900
Message-Id: <20220710235254.568878-3-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220710235254.568878-1-bpoirier@nvidia.com>
References: <20220710235254.568878-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0055.jpnprd01.prod.outlook.com
 (2603:1096:405:2::19) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8bba92b-f959-4e41-5a71-08da62cf7616
X-MS-TrafficTypeDiagnostic: BN6PR12MB1396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DT4Xa31sdABNJqQbDA2nVoM6jLvTD1M3aLmXMvjmhJtThSkPDOd3Draxigt0qQjudZm8SI2Uw9EWfBPEx38tamGwIWad2cLTCc3Z87RqnY5HsccMtgFqyeyGtKqVVZt1dtBO+8QJsMzG+dQy45I1YZV/896xNtnL+EqkVgJ0gfaHiu/K36DCK6GUWB1kmglPFYlsLpfYDdI9TmIgUJqu59UmCZtDHgM5L4aqTYCCM0lfit9yXAirnmfvS8YRDk7hl7oLhDTI7e5r+kD11o1nGwrXtJWEN8umlI0+2hJPr6ZXEMuSnuJt5Z/K6BG1Qu9nFD5r4DclxNEb/GMo8p1Ep2vGXKBIHVSX6wl9yQuKVAx3onl+YMOKgDEdeheu+n/zeAzNq68m/YDhAsQd5FuzjTIKWjPIzc4q0YqCVVBCF70zGXt1tFYj0bTJ2pmP+xPBiYOCe/OLpxCF4qj9j0BbE3koLTa2rfCTJqYqOd+WFaigymqB1VqytFA1FvSvyIi8IJa/LLVA0Rve0EhQLrGqA1RFBp6DOsY8HVzqiVEwHXLy1n/qOdxrEeflgbQf4HaoOnm+ndoWB8GVIy4TvdZ0YLahjk+xIdrdrqtoJnpKPjG79VV0JbFU9Ia28wNU1xE1HaFhREtmzKNZNzGuceIWI8D9HAilymrjA2NKEMO2kNugqCKmlRD4flbQpTW2b5DwWjGDHCo143h+3M6bJcrKKaenQpcBmtNLcWzNaBJA91B9gRDi6x1Cfi6DQAn6GXZY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(8936002)(6506007)(6512007)(38100700002)(2906002)(5660300002)(83380400001)(316002)(4326008)(66946007)(6486002)(66556008)(66476007)(8676002)(186003)(1076003)(2616005)(36756003)(41300700001)(478600001)(86362001)(6666004)(26005)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BGPkBPTZmkG2VTkidJg5uDFtC52gK8jfT/Y1w7jETu9eQABin1GnTIslFz8F?=
 =?us-ascii?Q?Q6fawWENs70chbmwmLGOtVh0jctDM6jQB0bDlkvSGBaJsTi1a7gQyQ92mPGG?=
 =?us-ascii?Q?pRgUuQrK28qAFCyZF21xDkC+ESelKlVLWwNokKAcKRE6frXjBvgKfAeWXBKW?=
 =?us-ascii?Q?ONmqZek4to/UamY280oW1li/9MjfCM5Y2sNm45Ywvbb/RaICu2ItrF6dyP81?=
 =?us-ascii?Q?NvnkXeEmFS8Glx4i73avj++PYdAeRyVNG9LDWbWXd/hR+TZDKdj/8QFKj8T6?=
 =?us-ascii?Q?roV5whPvPEDwtr6agKF53hrmZhPwrf0PzIqPQeh3Vsw2hDv3YfLvGgSeKWQ4?=
 =?us-ascii?Q?jefXIxYUc5hqMT18lq+jb5usLAyq3zz/LM+rPsiLbEdIHFWpjyEIzfRQkszb?=
 =?us-ascii?Q?MK6mTRuS7EseqO3IDpoDhfn2Je8tryOjZL/VSJxPMv+Mcxrhorf5iVkEEEMV?=
 =?us-ascii?Q?H4zBV8fqqaSuiVH0HarprRejZ/tw8GJ1wOMV/kmQQxRG0YGBSfur3v42C9r+?=
 =?us-ascii?Q?VetPdFsV5MW0cwaLrbeLXsVKk564pWCosNWq5XFovJkwkW8d4Xv8/ZupJxt8?=
 =?us-ascii?Q?Z5Lx5Ixeku/ZxPlcaBW1sNLb47dD2GmHx+cZTI072+MReMuBoSjZ6WXrgp4x?=
 =?us-ascii?Q?LUh4r9JNq9mhOxxPEOygV0lmFLcLUXzeHb+V6cBGZ1R6i05wPyX5zpS3SLPi?=
 =?us-ascii?Q?lyv25b9lNKCrAQX9VvW02GicWFHZ+zVPBeUH2X7ydm3GlqwvdV3AMmUE8fTI?=
 =?us-ascii?Q?A00PQGP4WbdEz5RjWnlak7rRryYnjwGHk+5lh8BUBhrwzVbiavm+3tiVbzx5?=
 =?us-ascii?Q?0YKRkLckKsZF2332sI+7vptFNxTGnyry5pNYqaTr4ov0Th3GQsu2AqwP8hz/?=
 =?us-ascii?Q?2+2DlGepMeY0rH7ta1KGfveN0iCQFEL+Tk7LktgSJ1ISrvEYQC1nYbNrLcfq?=
 =?us-ascii?Q?Hh2ZFdf+3oqhcFoT2LHb1BRfJVHzeqYcNvHRiQTUxKCbvxfYHPpk/74WsvNU?=
 =?us-ascii?Q?9qjTrvU7R5LrzX+wU1YwapULROoHYbEAF06WF4aqZngic2JdxZEcYsM8v4tI?=
 =?us-ascii?Q?8l2UpmJbuZxSdzPkXOzq6p5MDWQCrQdrTPQig9l4/P1WwYJO3Li25TcUnwvj?=
 =?us-ascii?Q?Nx8nFaOwpWBXoCVD7HTxuNizL5kN9fU29NyDRkYwj1s+FcJuPDfK4XcxBSZe?=
 =?us-ascii?Q?GpxmxiLE1EOSdaBwMZ681bWt92wosnjhUftuQdL4U9Q0tzvb+f2CSSBc7IsO?=
 =?us-ascii?Q?VH1TiLPAfqy3eR8JXn4ELmNxjlqlBruVcoZ5o5Yd/IA2ltNnegojzn6krfAD?=
 =?us-ascii?Q?0xrB3+E4WlUmLbVHDLIcwBgpRpIROPdpdXqWll98TwZ/eOXf5Hg/jhIQNwok?=
 =?us-ascii?Q?6PU0qkncxMlqBU/HajbXpL2bQBSpOSoiKJH+TLCshTr7m3TLW0KwM9Dijd5b?=
 =?us-ascii?Q?Kv9gn7cjOFi103rJIHX8c6fF3rLeQ8oKVIbqDxQNkZrKOkB9tCHrFWkO6cp9?=
 =?us-ascii?Q?liHznPCy6qEkCligPVIuCPDmhzVxwUbu4S9V6mLGSexIBPALd/fckmeVQmaL?=
 =?us-ascii?Q?Jmq9vLmtzQoziW7hq977Vr0mEoyF5CpEBpdJPU4D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8bba92b-f959-4e41-5a71-08da62cf7616
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 23:54:00.6837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Byanw/PzVVcL1qul7adIyEHPNPSbMSmHtHePjanNHFzFpaqP9pTYr4Z4cgUJCVCJs1acuYcoY2qvs807sgyww==
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

With the following command sequence:

ip link add br0 up type bridge
ip link add dummy0 up address 02:00:00:00:00:01 master br0 type dummy
bridge fdb get 02:00:00:00:00:01 br br0

when running the last command under valgrind, it reports

32,768 bytes in 1 blocks are definitely lost in loss record 2 of 2
   at 0x483F7B5: malloc (vg_replace_malloc.c:381)
   by 0x11C1EC: rtnl_recvmsg (libnetlink.c:838)
   by 0x11C4D1: __rtnl_talk_iov.constprop.0 (libnetlink.c:1040)
   by 0x11D994: __rtnl_talk (libnetlink.c:1141)
   by 0x11D994: rtnl_talk (libnetlink.c:1147)
   by 0x10D336: fdb_get (fdb.c:652)
   by 0x48907FC: (below main) (libc-start.c:332)

Free the answer obtained from rtnl_talk().

Fixes: 4ed5ad7bd3c6 ("bridge: fdb get support")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 bridge/fdb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 8912f092..08f6c72b 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -571,6 +571,7 @@ static int fdb_get(int argc, char **argv)
 	char *addr = NULL;
 	short vlan = -1;
 	char *endptr;
+	int ret;
 
 	while (argc > 0) {
 		if ((strcmp(*argv, "brport") == 0) || strcmp(*argv, "dev") == 0) {
@@ -657,13 +658,15 @@ static int fdb_get(int argc, char **argv)
 	 * if -json was specified.
 	 */
 	new_json_obj(json);
+	ret = 0;
 	if (print_fdb(answer, stdout) < 0) {
 		fprintf(stderr, "An error :-)\n");
-		return -1;
+		ret = -1;
 	}
 	delete_json_obj();
+	free(answer);
 
-	return 0;
+	return ret;
 }
 
 int do_fdb(int argc, char **argv)
-- 
2.36.1

