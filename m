Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11A860D726
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiJYWb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiJYWb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:31:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9402649C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 15:31:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRQdF6qSiie72fN9gSAhv6BIsZuAJAyUr0PP3Nf0J+Z03+7umuWHBisSQJ0/Ak2LSRTfVYw8Z9HFNoJtv01Cmmz5aIX2thMoD7hS1Fz435P6R3JY45QpzqmICDEZHAImJjTBsQ3JapxZVsl3IFJYoO4yKvLbciicKlvjYsrZhXHE2JkI6d2ozK9N6JGwKWCxqSeXI2wkOuTGyznOsBLUfhkCCMFWqQpvSu7Ack/mBdFfl8dtLYYsYuWaqFcP3eIFAPBc/UdQU4olDZX352GU57/QkdU7ZHc1D9jNfdJ7nQQSUgbH3e2jnnky+cSQWXKsggqITr6Yk7tCEU6qKujRGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0t91Q5E5l1x1fpRBbKBJRFwYVp/mALQi2aSfLS1y7s=;
 b=GDVUt1FmaGL7TJSW8DIgRucBgo91pG8BwMjeRsgBbHFVPLXt+ZYIEdnv9CG/eEEcMEnY+5IpG+GL3E3+nlu6piigRA5mLrUj7Bw7D0JBeamXlkITrYpGriZV0zAZdGuCRvuYmhXYiL4Q3y7ryOQesDcIh8X2hB1FAe/KAeRpLUTeKRZw6WfcR/JFTdTfwikRaae8MWcNsBfdDvUaRlMvA8sU/nrXBpsW0gta7UTvlt3sKEU6a29/0+xZFN6Vbt+gBKnO3sKyNCqBYO5RPrJw/RRR1K4nqKrLrIjky2PR9HDzZCJq+7gou6hUWPT8D+EGzLkZPJzLpBfKHmpxEOp9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0t91Q5E5l1x1fpRBbKBJRFwYVp/mALQi2aSfLS1y7s=;
 b=S6eV5rZA41DNPmqK7V2pAYnVHfEkztHd9vCCHMwma1fdhIT2HMaQ73Fs0SfC3Kv/nx+FyMX2O/tqCWO7Us2v7M4A5NqSoHAAGVUYPbvluFQxZkHkkGFav3j2xiV3Zq9oy9kq+kpqS0GB6/Qrq8dnDeJe6VYVY9agKva2U806Dv8wfmbZtmZADQRaPTn1WvbcOy0CUylDNj7LY3AWkA5jAkemFfztyxFEeJ1BelalM1Onw6obhdcXj0gDRmX2bo60XHVhFIwwgHkungK81c/8aHf+k0fDLa4dik3w9+Cgqqpn51cLZWXraGv1bkeZo/XmArUaKWl7T+UD7sH0rWyEgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by MN2PR12MB4519.namprd12.prod.outlook.com (2603:10b6:208:262::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 22:31:25 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 22:31:24 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2] ip-monitor: Do not error out when RTNLGRP_STATS is not available
Date:   Wed, 26 Oct 2022 07:29:09 +0900
Message-Id: <20221025222909.1112705-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220922082854.5aa1bffe@hermes.local>
References: <20220922082854.5aa1bffe@hermes.local>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0088.jpnprd01.prod.outlook.com
 (2603:1096:405:3::28) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|MN2PR12MB4519:EE_
X-MS-Office365-Filtering-Correlation-Id: aa91944f-0348-42f8-92c6-08dab6d8a633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXbd80Up8PmYzb0hKEFFaptZQjxzCQ+rxqlImWPKayxV98/2uygznB9CrH9/o6nwJqwW8agdz6h5QtwD1knRyypoXw4CMNv8/5ckFUQwrZU1cYRiIVAisul4rvlvYPfU7aCQzQeM9DuhnF0xMW3s9P+Tj/plNXNkyF7G2TU3ZHWTc7OZMJ+fINKoOFp4z8QjqY3YIACFhq0jV2Fl3jvaEst4PHsBxnKlZwazn85KKEL66l0YCbLqqFHSTcy2jFoBSmXlA0OTYC1ond6xEHslEyl4v1CTPcIrn1jQ1o/SypZJS2NvoV0ad+4XSQEINw3IM+f2zE8aGdLEIee/QG2xClnhiSPdpMF+SjERWgKXU2iszPWpcHY/Rbz8WK56Yfv1on8g6Vxe9+PNyU/D4k3Bg1xJrcvE6bXY3xsLgWg+6eNA02dlE3Hkoo/EPwYjm96XVJPwfEcFmoF90Ym7yXmYR23oZUWN5V6Ks/2erv6l5Ls9kw20imgWxj4nIgDSG1x3u55U4zcf5QfDyUoao/S1koFcyZ/P/EcPA+4Ts3GWHWbfZw9G53Yf+IO/EMGDWBgEz+OwfYPOI5VT+Ek5v89ktD8Ja7tLwpdODFE3U7yPcgXr9sDSx0FdKjTzlKAngyHT/wHjoldIl9MNH33LTkEbXllamlTZyf3DMRDKdhbnPmxum4cDnabtWjObHl/E3MhBVbUgwUji8WXSdo5Ch01XAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(1076003)(186003)(26005)(6486002)(2906002)(38100700002)(86362001)(36756003)(6506007)(83380400001)(6512007)(2616005)(316002)(8676002)(4326008)(478600001)(6666004)(107886003)(41300700001)(54906003)(6916009)(5660300002)(8936002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ipn2+22snzsvMDR1OUnBrDmc2TjMrpZELYnsiSk1b+Rzlv6Zq+LgrqI9Iv7b?=
 =?us-ascii?Q?hSJkA8bWPuxI10YQ9TeX6cAt6f4UCjC2Dwq98tBdEF2AW1BHPhds7j4mSC5i?=
 =?us-ascii?Q?4O2Ph/L3+CyVdhDVG3pK45tKpb63nG7ExMUU43TFQWFtsN6/JiJx5GiZvUKq?=
 =?us-ascii?Q?3zJ/alzFCG9tcYtarOeHchFxFAdsknyr8ya1aJjVxAWZFMhLH2C0NbazQ8E6?=
 =?us-ascii?Q?gwEVzR8WyeQwx+Zo6imzjBMBYGYtZPRcef1F4b87XMpqk5un8Bffl1AuoNxr?=
 =?us-ascii?Q?8xtypklNNE9vEe+tjIav4X4x6WruMPDiX+/Mpe1igWlPL4G5vf++WmOqpsz5?=
 =?us-ascii?Q?qSywb9Bp/7D1YwNEnluTremOySV/KQN64LOGEMkTt0SFQcgqzHYpyrZ2wW6I?=
 =?us-ascii?Q?BKZ3kERIciNpMGKBBcNeMEGpN3kATKCTmM22Z6KHV/AQ3slZAzuoTiWz399C?=
 =?us-ascii?Q?1771xJzXMz3EDY1K5yUePUZHbjItjW/L9WGAlaX4LuYufraRV9ON8C5Shhzm?=
 =?us-ascii?Q?6jPWt6Ad5yk5MfXmHXNft01FYFRrTffgSYT4879f9IWoWbsDUiJRTfXba7I7?=
 =?us-ascii?Q?CtYzpUI9urs5t7QwhDrqbBuxNKlu3pz1xHf38LJC2bxbD+RDVJCYfO0uE5sy?=
 =?us-ascii?Q?z7TXC2cGyJl6BgNkyYeutGvE3md+bhD7JhrLkFGOSunBb6K+w0na8qFpyuZ8?=
 =?us-ascii?Q?jXdVKFihtep0MyMZwS2/PVahVJLgeh6ew9fTgtpUwEOQUHDhp12j/KFPbsu0?=
 =?us-ascii?Q?sr53IquAKkfXAxvm0fGwgfsQ/O9y7IuB4axkDwAZpOg9NxcYNjmfHjcqObAz?=
 =?us-ascii?Q?t+oPxcihD894dAlSUkTXE8535SBoBlYYvtkHFwUaLykFQk/+jDbZOFDul9Fw?=
 =?us-ascii?Q?gqfHEkkoXvwzjH7Hbc+i5dkxysU3o0moN8V+MrjWp6hTa9AteiNMHaQxogr2?=
 =?us-ascii?Q?vOyjOAm1Zd6lmVokTFEBROGUonRNxWqht6aLEMia2tBte5IOm52e2zHvgIFo?=
 =?us-ascii?Q?uu/OWJWrmWcvEvOm/f82EDgNEcZ6k+vHoGEbmQjAkT5zRf5P7e/aQuH+xNpu?=
 =?us-ascii?Q?yU4cbBb/U1ftewUClArasVyWhEOqewpvmS4oGU9KisOokzWJ9pvJovUGA9Kx?=
 =?us-ascii?Q?aLPubxWakeX1r+E7MRSD50gL4aac3qyDcsTICyQhwN6NMmEFRbIWY7kjgrp2?=
 =?us-ascii?Q?0mL/yxAhCbwYaHf3PY0N/JWWGuOY/HzWKXpWDPVQ/ghfOzq/5zGg87FDxXKp?=
 =?us-ascii?Q?8yGr6YiYid5KdN8OmNztBa2qNjMrNxdHAy/TykFvtpIfFi4JNY6EiGJ9tfo1?=
 =?us-ascii?Q?HeTdm6AvR4h1bFMhCcCgpL8YS2/4GhVqzqh0/Bupcq41TtovYQthajWLtrG8?=
 =?us-ascii?Q?9xzNoKols+xHHyM+AjwbQR2atTVcnEZj9+sMkG1cWL1Ur72R9R9oxXzmhMKP?=
 =?us-ascii?Q?kp6UXh7lS66AgmJofay5+Jcc5A7Jt50GH8yVF6l52ntjdYZE1ZvjlVEVnulk?=
 =?us-ascii?Q?vcCvBPoXJD9xbjgBlIEK1cnN/8E3QvQmwOyxPWp11HJFMqWP4T6Uxka97WVr?=
 =?us-ascii?Q?R0pGyH9/cNijK3uNVVuityVovQQXidYrpjqMpP39?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa91944f-0348-42f8-92c6-08dab6d8a633
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 22:31:24.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNdODsKxD8z1DYwnr29vicQV1POMGVjfny0wpcksMEJ3Gy/wmHvYFPkONcIGV3/YpF3kpF65yfFLZXWRFTg4BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4519
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following commit 4e8a9914c4d4 ("ip-monitor: Include stats events in default
and "all" cases"), `ip monitor` fails to start on kernels which do not
contain linux.git commit 5fd0b838efac ("net: rtnetlink: Add UAPI toggle for
IFLA_OFFLOAD_XSTATS_L3_STATS") because the netlink group RTNLGRP_STATS
doesn't exist:

 $ ip monitor
 Failed to add stats group to list

When "stats" is not explicitly requested, change the error to a warning so
that `ip monitor` and `ip monitor all` continue to work on older kernels.

Note that the same change is not done for RTNLGRP_NEXTHOP because its value
is 32 and group numbers <= 32 are always supported; see the comment above
netlink_change_ngroups() in the kernel source. Therefore
NETLINK_ADD_MEMBERSHIP 32 does not error out even on kernels which do not
support RTNLGRP_NEXTHOP.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Fixes: 4e8a9914c4d4 ("ip-monitor: Include stats events in default and "all" cases")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 ip/ipmonitor.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 8a72ea42..45e4e8f1 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -195,6 +195,8 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 int do_ipmonitor(int argc, char **argv)
 {
 	unsigned int groups = 0, lmask = 0;
+	/* "needed" mask */
+	unsigned int nmask;
 	char *file = NULL;
 	int ifindex = 0;
 
@@ -253,6 +255,7 @@ int do_ipmonitor(int argc, char **argv)
 	ipneigh_reset_filter(ifindex);
 	ipnetconf_reset_filter(ifindex);
 
+	nmask = lmask;
 	if (!lmask)
 		lmask = IPMON_L_ALL;
 
@@ -328,8 +331,11 @@ int do_ipmonitor(int argc, char **argv)
 
 	if (lmask & IPMON_LSTATS &&
 	    rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0) {
+		if (!(nmask & IPMON_LSTATS))
+			fprintf(stderr, "Warning: ");
 		fprintf(stderr, "Failed to add stats group to list\n");
-		exit(1);
+		if (nmask & IPMON_LSTATS)
+			exit(1);
 	}
 
 	if (listen_all_nsid && rtnl_listen_all_nsid(&rth) < 0)
-- 
2.37.2

