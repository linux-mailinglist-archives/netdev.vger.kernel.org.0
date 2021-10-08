Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1427A42617A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhJHAsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:48:42 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:55602 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhJHAsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:48:41 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1980LHeq006486;
        Fri, 8 Oct 2021 00:46:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=uUvbEgspi3Xq0v8zC8XZkdI9qve7bozrIvhNLdHZ0dk=;
 b=XJtQKJO3flxzsCLMOpBRe3vbncPxzaFWR6R4kiZyTp0YnUKEbd0lEohNO39EUT+5v777
 V0HAatj2WT3+gM2JnslASHhlJjmz52bhDIgkL34h7PpgRqW2Yvm7CN9U+2tXcWOOuIZY
 bvH9D1aKOXbvPthgTHKGDlpcEI1b80bRiZCJpsRnDqzBiEEy1FyCDYkW3m6udab7POHR
 76jXfib6M5Ul2vFs0FXaYGKXM1ELLpU3EyryHEuIrNUvBckl1G0jpkOsV7Rq5pzFp1xU
 IMpPynVKyTIMU21rIFd5dGdO+aJV1WWjGWFFrDypQrncZ5ecyFZzXT/sNMJlsVPesKjE 5w== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bj9sdg2n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 00:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ci2pHgUWJZjwX4Z9T59jCWMkFl0Q5KZEkZtkdKvEQ5m1GJrqZ28+XHpUeAB3lwGoO5F6VzCO0TuqckvRcuL+OKjG0kVyCpG1F0v5FW3IAuYTArkXgYCRBfyo7w8nzyg9JyXT9013UNgnbaPi4sq5uVmjdVqv1Pjg7ulCGiIgwCwdk8RKRnzyUt1xg0m5qSIgB7ml08TM0/tojfTBcEeKxhQbuPn8IwFcmw0XbUtyLk/nE2eUET0fV/bpxOH4hY1SMWlfPLdxTfgvXIBdylOOrNFeu3KCZFhHJY40j5ixAwxzVB1gchOtu19KI4u+WuRPyQ8pfwvFXkZzVdnG8Ti9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUvbEgspi3Xq0v8zC8XZkdI9qve7bozrIvhNLdHZ0dk=;
 b=JJsSwq+QxPzUnfPFkbo2ImG4E+JhdBNkyBWJ7sNz35l0OHiiyQxufgpgyKsPkeWZT8XgdxqW7iFyX2iOgbLTwO3q1MnMS3Qh6zo/QKJsREWoaarTqFHzxxNMk6gSqgmdfyDqlqCqXjRwsg68rci4yrPrqpm8SrR3W5jWXxhRC/KZaohqwdu49GKtypu65qWenb6cOTqfCSC4A33/9+pDUJhDz0MubcVn3vRfAFrpTJUK+uA3PxRFxj9RbVhdrmQXdUG3adTOKF+Q2istTEAK5TZHpAgp9tlBF59n8aumrRpvw5B+KZqytPrqGJtlpAtx1xpTxdydC79c/wm+FCOkrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM5PR11MB1770.namprd11.prod.outlook.com (2603:10b6:3:10d::10)
 by DM6PR11MB4675.namprd11.prod.outlook.com (2603:10b6:5:2ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 00:46:25 +0000
Received: from DM5PR11MB1770.namprd11.prod.outlook.com
 ([fe80::9505:3c79:555d:3bc]) by DM5PR11MB1770.namprd11.prod.outlook.com
 ([fe80::9505:3c79:555d:3bc%11]) with mapi id 15.20.4587.020; Fri, 8 Oct 2021
 00:46:24 +0000
From:   quanyang.wang@windriver.com
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>
Subject: [RESEND][PATCH] cgroup: fix memory leak caused by missing cgroup_bpf_offline
Date:   Fri,  8 Oct 2021 08:46:00 +0800
Message-Id: <20211008004600.1717681-1-quanyang.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0142.apcprd02.prod.outlook.com
 (2603:1096:202:16::26) To DM5PR11MB1770.namprd11.prod.outlook.com
 (2603:10b6:3:10d::10)
MIME-Version: 1.0
Received: from pek-qwang2-d1.wrs.com (60.247.85.82) by HK2PR02CA0142.apcprd02.prod.outlook.com (2603:1096:202:16::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 00:46:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f45e3c16-fd20-48fe-83d7-08d989f50dbc
X-MS-TrafficTypeDiagnostic: DM6PR11MB4675:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB46753AB91BB5ADB6011D421BF0B29@DM6PR11MB4675.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVYjazkOV3D+pmKUoFbIbZzSofjusrNd+qTni5AwSO8AQBuUzkyF2VKaTg7lXcFJaNwzkKw1abZB2IS1Dg466Bxg151Y+HZfhoFVb3dXGxLhRrrC2iT06cjXo1ct/uuDKiU8XN+AZl2QqzWXan3bKeUDU0I9csSBIeysxhVgMUe9R+9c0s/h27pPAAGQUJwQg8MpV9nONQ8mMAcUcXPqRaFLy1oMAPE36GTw+oXLbHZtRyoXToJRlGTm5/q9w3R9NfHawUWvQ2vXMwBd5w5FmMTjPTAHoTdhCvMd6MnkYNqBlhgHLJWKK3yIXQ8xh1QS158hQhzuKzBe8I9p0u6trG6gCdbaMYl7L61nLThYZBFZEuVqeZLGtllWbedIc08SIXmbhklAOCVUrez+JrhxBNDg6ReRz1JMaSX76zjiG76+frFArrsjqFXCB3xvRzr9tB7Mwk06g28IqtWllnZ3jz4o7jAhLeyIzMGSjFFt6Xeoy2AKs39ICqbl+MHA6m6knHrUx3IKVnlOgqqQLReMJ+qxBriGnw/osNlBR7pd4+tqMN89pM4K6RfIhXAUyOBv6FG+hxsdPmTRzXBjE7r+UZdv2n1LSMm/9iTL0NuXEa+JW5JvyVhr5J5qwzPmGRX46iUfhefsl76pXl3zYar8pGYrMfEfMXCM+u0ePycFvSXciRs1Y8UVDiMwaibgm+/N820gPK1lyxDrZk6iuqv4aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1770.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(6666004)(2906002)(316002)(36756003)(5660300002)(83380400001)(38100700002)(7416002)(186003)(1076003)(2616005)(6512007)(9686003)(508600001)(86362001)(26005)(956004)(66556008)(66476007)(66946007)(107886003)(38350700002)(8676002)(6486002)(6506007)(4326008)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hxRSWVLqSNDpOWxBQOTA8gim7mDxjPWMwTwPI9BRNUQ9TQur1HAscEMB3cFC?=
 =?us-ascii?Q?/ICBk8VGRgyeB4WiyeRmsfQx36BBBed0dgkqq23oi3O439tuHRiTHYnio3kn?=
 =?us-ascii?Q?Odnj8j0Z3QV7YiRxu3MqW5HcIDGLKsmpM+LJWgNmdNmRs1m7Bk+e7wM9qbt+?=
 =?us-ascii?Q?yH9JYn5a7NtLk8BR29JhQBYZV4llSeySsLi1Qsu4bniWCmRJ7eKy6nXAQ/th?=
 =?us-ascii?Q?uX2hDA7j2+6ZuG4P/QzG6y+9qJhf6uNlSVAP9PyLzkpmXISfqNmrmihVP1i2?=
 =?us-ascii?Q?sdOAQUHcrZJtB5FJwzBi4udyCS9WYsk3GwDMUkUR839m/t+BIec/jFzYp8LK?=
 =?us-ascii?Q?LaeurH/oeuqgLZh1b6qFqIlcP74oGkZADaUyTHyJD5oGinP9fKdEYfNxy8GB?=
 =?us-ascii?Q?kQbzymb/dgdp8w2M/XJzAKqGHbrOecUMsza9Xsto1Cyy9MbZMzxBCDtgHOkm?=
 =?us-ascii?Q?+WhLiZgdQjp/57gpzRi4iidIR1ZuAu/kLtXzzGqFf7lNYvXNx6ZuFkZq/xOB?=
 =?us-ascii?Q?4bNoLJ9DkXD5PcolykgNJwTE4Bp7jOsfIgMWdKafSecc2RAI+rAbNwc2/9Nv?=
 =?us-ascii?Q?b4+EKlKBYQnb8QiZiIK//TuUb5o3GbbLSGwUob5INgVoO5RTm1i1Luu2zvKr?=
 =?us-ascii?Q?0z7WxbuXTSpUKoXsE+FNQSDjESKs7VFX3/NFfwH8o8scWfgazpNxekA8tZpF?=
 =?us-ascii?Q?9O5cNNO1RLNY3ptNAhwNoIyZH0E/VTX1PLx7/GCkKFKFRHP2qdSqkT11PQcG?=
 =?us-ascii?Q?AInBCqVHFcU81sMY9HCLVkherYLqIfoXUqSN9c+K2KxRprcgs/BRdyIfnQEf?=
 =?us-ascii?Q?jfFxBdZU7V58uSpfiMJyoV6phBZLtlGiHIKkncJf4BwU+HENGqoC6g7vSUK9?=
 =?us-ascii?Q?J0jSIupjUcsWnyiKMY2jOb0JiiM261EtvUvnFZkdWra9Mdhy5/0vOWyxKe6K?=
 =?us-ascii?Q?f5TdnV0gbV1HNEgLr0AS+W75rUJhZfMfe5iXrQi8UEKnkapkFx02fShsoghT?=
 =?us-ascii?Q?owHmSmYr7VJ/00AOlme09ihwMngpiDavt2esM1JU3hSwIpoG6T1ZQ/Pcy48d?=
 =?us-ascii?Q?F0jn7Lv7GJbThMmtBWVjKvqr6BL3oRxFsp2Z5WLo2rSnE/IB7hst+6w3+ecU?=
 =?us-ascii?Q?eAXGH7TUxNmETZ4oExsdFjN+J/Mu8CYhPwPRsPUqEF7A0FDJqEp0cIiKzsu0?=
 =?us-ascii?Q?gm+/xgV5l7PuBVzrOdvAHnjBcHv4Ni6rQazpxYZ2vCDZcs/ITitNnldpGpas?=
 =?us-ascii?Q?vCvgKDNGVAyahBEvtJjMmfIIOsCKblxGMsAJfq9GMbQDe+be84PqdkOSzG4e?=
 =?us-ascii?Q?lVbiRZThaAVwcRr5e2b/9Xp1?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45e3c16-fd20-48fe-83d7-08d989f50dbc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1770.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 00:46:24.3065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1PQ47kokX+gz6cfp175PlkM0oHDvMcB+v0l6dPAraNRu+BQa3QYn4Ait6M9R9T3PW3obscBt7AFER1CnMvYXOZbxQm/OOTkGZXD72Ct6e0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4675
X-Proofpoint-GUID: Z6tcm0X-nlhJCnO29JLHTrwI_H4EbBMr
X-Proofpoint-ORIG-GUID: Z6tcm0X-nlhJCnO29JLHTrwI_H4EbBMr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
the command as below:

    $mount -t cgroup -o none,name=foo cgroup cgroup/
    $umount cgroup/

unreferenced object 0xc3585c40 (size 64):
  comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
  hex dump (first 32 bytes):
    01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
    00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
  backtrace:
    [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
    [<1f03679c>] cgroup_setup_root+0x174/0x37c
    [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
    [<f85b12fd>] vfs_get_tree+0x24/0x108
    [<f55aec5c>] path_mount+0x384/0x988
    [<e2d5e9cd>] do_mount+0x64/0x9c
    [<208c9cfe>] sys_mount+0xfc/0x1f4
    [<06dd06e0>] ret_fast_syscall+0x0/0x48
    [<a8308cb3>] 0xbeb4daa8

This is because that root_cgrp->bpf.refcnt.data is allocated by the
function percpu_ref_init in cgroup_bpf_inherit which is called by
cgroup_setup_root when mounting, but not freed along with root_cgrp
when umounting. Adding cgroup_bpf_offline which calls percpu_ref_kill
to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.

Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
---
One of the recipients' email is wrong, so I resend this patch.
Sorry for any confusion caused.
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a9..183736ad72f2b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2187,8 +2187,10 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * And don't kill the default root.
 	 */
 	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
-	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
+			!percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
+		cgroup_bpf_offline(&root->cgrp);
 		percpu_ref_kill(&root->cgrp.self.refcnt);
+	}
 	cgroup_put(&root->cgrp);
 	kernfs_kill_sb(sb);
 }
-- 
2.25.1

