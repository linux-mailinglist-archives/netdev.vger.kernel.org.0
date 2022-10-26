Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190E360DB94
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 08:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiJZGuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 02:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiJZGuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 02:50:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325F32F021
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 23:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENxcU15x2Ou58rOavMkxsf+MPzRysBBI3riKR4BgV39o526RceEgQURb+S325EFBEORp99RrcYyCs3XaDoN3hYsqRd6cVNDFmCEstIg8Ye9gGLnlHUs/34pzmUHpGh7K2d0gOBYmcozQR8ZijjLLnCYa8sGT6DqHUBnhAtrmDq15nTBkXkL52JeK90B6YdVVTTDaLhLU/+i3TbVzZSB0zNtFNRiIoiW+Iqt8dvEv2PwDTJgUrbvlt5Xt3AhB4z5zNnUcV55yI31d+aeYyOLG/jlqdgmPYt6a/4jtZGlHwVNpq0s9AYxYJiu8NqVpVvjpemNJiP/6ocgUvggtK6VxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iylvrtMBa897ehxgJPRfDaHpJRwSrlKGmh/f+zqIF2c=;
 b=YR88KlHhFkReWQdcGE3aqdiAPc/62udAv4NNdCgr+mbQa5/Mm3pJvV38Dc7Tk4V0fcx9l3hCceUVdRO4EKZBeJiuMPgjp062UXzyIfVfKo7fsmDkS0kgeAGnqig7uoGSzMVauC9aPR/dp+LDSOehVVCDkIdOElVa07DB2xrISwKChQfwtvHSOj/yNm9/NxXHtyKe0+GW+L7oChqxSW6QRwxjEmXqNwLWpbBCCe7TvXwbwQmY1P/7Og5jrUcGUydiAU/ucWWV1dniAd70H95Z4UQCSOQHAqsxgBQps9Gj2uKI1yzSfquXT0l84Dr1QmnBAFSORMMe1EEqEHdUjlqYHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iylvrtMBa897ehxgJPRfDaHpJRwSrlKGmh/f+zqIF2c=;
 b=sw9LAHnwoBz1TldGEUWrFSrymsC4MrWvUkvNHGQyoZ3IIqtdPNojsWHT+/QtH++dCNexBxJLw+gp1oUwoxH6iXLUL6xfCV4xlvoMKogTeg5i5vQflr7FMZAhqtDmdwZ5/L2MTs7tivVx3r+CemepQZvHUap203PEWPK57wySOD6x0tFTOVAPKRhcfSJ3SwK8bqu3y01y2qAayOXac9utwCfhDI/FGDxdzDWLjLDK06B+ePgCkGrvTVIV2puQJig7ijICrGGi1MFEhlS0+HSn+ji10jv5NynRGOlVC2+fQetdz5VybePWcvGoGWTIrt2fYU0E1Xt1nbMslEKHYVpgSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CY8PR12MB7434.namprd12.prod.outlook.com (2603:10b6:930:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 26 Oct
 2022 06:50:09 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93%5]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 06:50:09 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 v2] ip-monitor: Do not error out when RTNLGRP_STATS is not available
Date:   Wed, 26 Oct 2022 15:49:07 +0900
Message-Id: <20221026064907.1209952-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221025202026.68d92100@hermes.local>
References: <20221025202026.68d92100@hermes.local>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::33) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|CY8PR12MB7434:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb1df31-7a2b-47a9-d366-08dab71e529c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SiNr5KwAwb6yIeIzg0GUaQtTeCjFgaVsILmGjMc+tBh14yxbWUrqt7ecCIJqW7nNeuY4ft3iF/FobjBka/6zXXGPCoTprmKTGuQbzj0ca4e6J/gsdMTqXb0soC1GXTC7JJD/6qOTpjT+MjXGAX3zPNMG5I63jioDlOvZX++Qs58HgPPqTZn2GQXvbbe+8NVm3rx6cVFxTYLW3LGJoRQlLXPB9YHhROzvHff8V/w7wrB04S63PhVpxp3ItADHdh79C6B3kFQn1SGD2X3udRwyzFgUroq47zc+U9r51BDiWUCqgIdxgzLzbw0VDCF6LW13Ip/IKZwyVsuDmyUbH9+8bCqZev1jAGpJV06DWVsmWjpEua99orWBEjh1gJ6IDD6BmWj9wWw0HZt3Gtsq9JpwaVcS208AKZB4FHVK1E8uqBQjetO4UEhviFWGf5TfSq6CaSdzHdVpcm0Q5WWwu89m4XsTRwEUCjLDve4UjQa6w6AOlDosFMghnWFkhhckBkG5PIR9dctDDwaWjVhApWHdTNYuFuug7Grq2m2154YvMauV5Pkddy15u3hHBFWlFnsb7MfPbld6lkdSvaj3rG1Md7hUoTJQJ+3wf6Q7eyfkLW2mZJslwKYOtBDKAr3+4zHADChQHtIKv86uA9tT7w/dD6hsVp3gTHtNTHm0Hk6ojEOJrX6+pl/iHBvZTH9f+eUQLTFtKzIo2yx4Zj67hbX43w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199015)(36756003)(2616005)(38100700002)(86362001)(83380400001)(1076003)(5660300002)(8936002)(6916009)(54906003)(6512007)(316002)(41300700001)(66946007)(6506007)(478600001)(6486002)(66556008)(107886003)(4326008)(8676002)(2906002)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wyVQGS+2ZxQ1UbNO05KbTyeWgEzJ47jr/DHwkG8eLdu38K2RBhXU+sWUcTKr?=
 =?us-ascii?Q?4YwRvSLIeksvosG764+K8kMxujqH7WBs4xsCn7q0Iv5rvZRjUAAlu/f21y6F?=
 =?us-ascii?Q?cKHnGLtbrcYIGY+Lm/47JGjFU34IwEoBMd8NO1uhWtyn3gtVzCD44PMo9WBn?=
 =?us-ascii?Q?TLfq7KtMGr9K96Wxij6sbWkHvPygT37O3UmSg6Rl2okrzVzgN4KhwXWNsm6y?=
 =?us-ascii?Q?CwwSkXOXRRcFqhAm5Z3+tdHmY0Gzb0tilR+4Ml6YQi4to9jTW9ESLsr1cTpp?=
 =?us-ascii?Q?wzYBzOMZw9WJe1Lm9ztbhXr5eSiGlDjfF6zP0gQIJnXqJbVll167vfffVWgF?=
 =?us-ascii?Q?wtKXJFoe0i99JQiwvF+QZvT8EwO3nmDWeg6w0PFlhF6hXSggpKhrKM7awTz7?=
 =?us-ascii?Q?Q5LBHiwKaqjaZI8bj75mRiePAQlfxTFq0ypfBSLqHy21cN3Oeee0h5nevVEj?=
 =?us-ascii?Q?mCRo0I6ysOESALZEDUC73udeiIJmWxxcRQ5HFr26jydr+sXTQ+mUW2nHWYXv?=
 =?us-ascii?Q?Cmys0g8uoiO+aU48wFuTDpjvT8FAUB3LFFDX4wJW6cNfy6gBPR9tiJ9NSI/0?=
 =?us-ascii?Q?iSVqbnbleiM/+bd+x8wCucqplQbCja9jP03AvCTEO8xXLh/T7NUwGqMaPVid?=
 =?us-ascii?Q?j8LwX+Ta1RNfpACQNmnm9BYKBPpSvSVUbJMXHvCYsPG3fbAacgtAyFqN1MWj?=
 =?us-ascii?Q?srE5Ue6Bo0aTORH7PU+XrkPTRi+HT99FaB7szvmuT1RbFRmSjY3rXeUrQL3N?=
 =?us-ascii?Q?mVMxtzoFq9SEUg+e8j8u/5vCUhY7kclMWA1bRIRdNalNBdplnqMNwRLG9f1S?=
 =?us-ascii?Q?VmlGTqfCoy/eymxh8wVehDMvzaizzoNnXTPs75ZgGgKifEf1nCe077/ll9Ab?=
 =?us-ascii?Q?a3MsgYncrkMAwQxSdOmQ9tejYPaJX+Ni4CsfXXWCxKzK8guPKM277E6PTMar?=
 =?us-ascii?Q?CdMdAnSBu+MyilYGdXLBLXqyU9t7jWe/GzNeJliKherq5RbZIXOwRiuosAfh?=
 =?us-ascii?Q?g2g/l/pUS4J8Hn3n2HNxcAh+LWO6wrtWaqgXCCxfjpyj6gKx9+LZVzLlkfWc?=
 =?us-ascii?Q?vbsgf8bxZCprobq86a2S5v03mmuStgylkuDM7i4Gn+PKVWtNMdtD1UW9ljDG?=
 =?us-ascii?Q?MclOmTgIm1uyB8B4rVRcoYiPbZeuF8gItHRq/SZUxBJx0uqc8t4cl0ysrT7G?=
 =?us-ascii?Q?qq4uT3fjL7fG+0FuZzZcxvz3YZNImG8uOQEAa58hov5iGWFW+xb1hct7oUt5?=
 =?us-ascii?Q?B4Cr6vlcWco30gZM8MvIVan/4whOAIG7dOdaQmsA2dV72/Io/S82ohzuwYK3?=
 =?us-ascii?Q?ImoNLdwTnHM0/2+VdhqfTclYxLKspEZiMtmYgKZSfxkz2P6NF1B5vTShwdW4?=
 =?us-ascii?Q?Wq0IygRyi2FcWe37e1ig1JW5SaR6KnfjJyPs0R1pXX+g6Qvl8kzoRF0w/Mgu?=
 =?us-ascii?Q?pgs42Jz9UvBtzUHzC1d3aCdsVuUus9RbbmYax7yrI9hGSsN0x5BabY0lMzHY?=
 =?us-ascii?Q?KLaWwEmvr5ThEnJ2jJZ9TJYtmt3wbQBFxUKn0MiDiqBYwps2EYtjzcUTibUq?=
 =?us-ascii?Q?yGWLpTdaLNUa2gyhfk2hHkRjFdz3VgDB6XgEvwWM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb1df31-7a2b-47a9-d366-08dab71e529c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:50:09.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b3r3OOj3DzkhhZemgokVJ+Ml/99P/pXyHa4URO+JXaGIiZjOg+9Y/iXCMLakPmtQP8ete3q3mNU1h0XA8VrybA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7434
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

When "stats" is not explicitly requested, ignore the error so that `ip
monitor` and `ip monitor all` continue to work on older kernels.

Note that the same change is not done for RTNLGRP_NEXTHOP because its value
is 32 and group numbers <= 32 are always supported; see the comment above
netlink_change_ngroups() in the kernel source. Therefore
NETLINK_ADD_MEMBERSHIP 32 does not error out even on kernels which do not
support RTNLGRP_NEXTHOP.

v2:
* Silently ignore a failure to implicitly add the stats group, instead of
  printing a warning.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Fixes: 4e8a9914c4d4 ("ip-monitor: Include stats events in default and "all" cases")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---

> There are two acceptable solutions:
> 1. Ignore the error, and never print any warning.
> 2. Don't ask for the stats feature with the default "ip monitor" and "ip monitor all"
> 
> Either way, it needs to be totally silent when built and run on older kernels.

Strictly speaking, the patch below is solution 1*:
  Ignore the error, and never print any warning ... when implicitly
adding the stats group.

Before 4e8a9914c4d4, `ip mon stats` used to error out if the stats group
could not be added. That behavior is preserved.


 ip/ipmonitor.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 8a72ea42..d808369c 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -195,6 +195,8 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 int do_ipmonitor(int argc, char **argv)
 {
 	unsigned int groups = 0, lmask = 0;
+	/* "needed" mask, failure to enable is an error */
+	unsigned int nmask;
 	char *file = NULL;
 	int ifindex = 0;
 
@@ -253,6 +255,7 @@ int do_ipmonitor(int argc, char **argv)
 	ipneigh_reset_filter(ifindex);
 	ipnetconf_reset_filter(ifindex);
 
+	nmask = lmask;
 	if (!lmask)
 		lmask = IPMON_L_ALL;
 
@@ -327,7 +330,8 @@ int do_ipmonitor(int argc, char **argv)
 	}
 
 	if (lmask & IPMON_LSTATS &&
-	    rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0) {
+	    rtnl_add_nl_group(&rth, RTNLGRP_STATS) < 0 &&
+	    nmask & IPMON_LSTATS) {
 		fprintf(stderr, "Failed to add stats group to list\n");
 		exit(1);
 	}
-- 
2.37.2

