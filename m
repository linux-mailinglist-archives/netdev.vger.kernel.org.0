Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674DF4311A7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 09:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhJRH7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 03:59:31 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:44414 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhJRH73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 03:59:29 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19I7pseo012852;
        Mon, 18 Oct 2021 07:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=9TVuZOiHz8mb3tbd2oqe6A5HkvbeAOX8Q/88ODx4zF8=;
 b=dEatw0dE3so/ouKyzrX0c8GDnMhHcgP3Iif1Uv/eTvViKoWm9+321STUD7pxKU85lHvc
 BjQ/NPlouLJREqWFd9IX1rdSEc8Y6kz4QiIlssVcXTYyJeXXPR9KsPJXWBLXt1a7cHz2
 W/+HkYL3RZajLnAPVPtGiInoORmA8UR7BWUX4uuGLUvn/Yv33phahsAOESTL8ZweoSI8
 bMQlL3nVS3XemUOlyr8V4RMuSnkPazD7rrigZGxpIlK/EOXeD+npnAhI43E+6eY90EJZ
 WcVCkla1QK25QRIHQytFYzEpZ+GEbOmt7TYbG/DhrZFt0zfgaKLrGxjKj805MUXoTzPj BQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bre05rm92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 07:56:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBF0pdFB3Oc/5DAi+1ztJ1ZxFz0oamwbj7X6xZQXBpRJ8qc3zL12e977stLbU65B0ImWhpDNeg73JpgrQpa5u5v2ljdZqNS48yMGAyY4nvKUzt+wZzujmQ/QybE23XIeTL1OWUC2mcMdJZ92Htaz6wgBIGvfPwvh1Y7zUgdHqHBgTUB4pz4FXl+T+DvqaqW5E1tiyjufyKLKi4Kcj1fDYPIvhfyXjNyL8wZqh+rvP4/ItS5IYWWkF8B+t7MnFW70SfTW/bHAYx0JfVuvf4grpJo7XfhQ5eGFnprf/HgiFjk9FsIHkCwE8p4u/yY8ydARqkBc63dAhSKhDovZ14Bqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TVuZOiHz8mb3tbd2oqe6A5HkvbeAOX8Q/88ODx4zF8=;
 b=eTpHh+2/CndZEdr7lcD8tqiLfITbZp6AvnEo0WRrPzgv/h3xQTHNm5gIVDa04IvSxSpBWIKdX6akzWV+9fxUkFQ+6mpEhcTCpXFiznCvMxtX3eE1QOpdZO8GtiREpJArsI5v+Ku6wv3SkYMa/2RVVHcW9jN0iEIKVZ5MM0VzlyVFH1jNPPfHknP/nIkr1qzDLELXywY3/GdsYnNfeuQOfgdBfllrefHj5CG+06shP7G0ehyt5aXoCpM4XAarT0NcNTK89+f4qjwo39dVOz53r75R36vEfXzL4vZn52XpA8sFA5aKHpY/RUCN+cKas5W7xHvdnNPBMUN6vI6nrDvfcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH7PR11MB5916.namprd11.prod.outlook.com (2603:10b6:510:13d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 07:56:43 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 07:56:43 +0000
From:   quanyang.wang@windriver.com
To:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Roman Gushchin <guro@fb.com>, mkoutny@suse.com
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>
Subject: [V2][PATCH] cgroup: fix memory leak caused by missing cgroup_bpf_offline
Date:   Mon, 18 Oct 2021 15:56:23 +0800
Message-Id: <20211018075623.26884-1-quanyang.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0217.apcprd02.prod.outlook.com
 (2603:1096:201:20::29) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from pek-qwang2-d1.wrs.com (60.247.85.82) by HK2PR02CA0217.apcprd02.prod.outlook.com (2603:1096:201:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 07:56:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea22325c-6177-47c4-b57a-08d9920cd32a
X-MS-TrafficTypeDiagnostic: PH7PR11MB5916:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR11MB59161D96E7F2E3C6A1C3A5E2F0BC9@PH7PR11MB5916.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YD8Q7E3FwniGZapaREbqFgq1kBKTs/srIJ6IGsTy24SNC8s3P9vVD+2bS3AcAPg42dcgrHQIhzeZd8EbGwHJF1PtHVRrg9AeqDvAx/eQhiObKVdp0XaJflBE766DkkambyGeFCkF72Yu76NA5DwlBVlTVsfb1k9xgb0Cs7d7weIHkVMAJr0vEZHgVl7udR/OCIfraR+93r+Fqtf2lr6X/yZJU8n9N59/ro2JlIyNQCPXg3oe68a9U59mIVf+OvfwJEakImK2Ol5o3eel9+3HeOe8Shf2iWTW7UvXrIqPXRShPZpyPrL/wi8BG2e8XC0FI0K9ONof/XKLmWVeO7aTi7ybM1687zDcHMCzikMO51z5b7T8XAWGmkQ6hqs0E114ZlnPM16qDvEcAAMa0UbCnep75wWRADk6r5SRgo/ULyOE5jXvTlXwvvZk6e76YV1wkXPIcuWfj8mIwYc2lky02K1MwMYEwS+uZU4X3TuYnm+qPLOu5UnCOjMMmqF/67bL8lYpHswtVGmUy+S+8osYrSiLCo146ZosWS9gVcBffZDnGVAbr5iqaXEeXMMw9goYhZA44vxRvq/LlZ5a+UDTfcEwpbBbkhP/vNVNdLzEgcYxsUcysC+cqkuIwYhc+xlqbYDVtOBHwULH1tae5W8KmJas3gSMTnqkRZI0DtHbSqytNrDjh5Ovl9On6z6FsvBl3zfqsfrIGcKKmsBvwBqyVw9azRHBUG06lW1KbdAU62E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(7416002)(508600001)(66476007)(66556008)(9686003)(921005)(83380400001)(36756003)(66946007)(6486002)(6512007)(1076003)(107886003)(26005)(5660300002)(86362001)(956004)(52116002)(186003)(2616005)(6666004)(110136005)(8676002)(316002)(6506007)(4326008)(38100700002)(38350700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R4gQI13ieZMMm/TLPhvMO4IKH4MxSiVrDCmH8u91YGNq8rxRNm4HNRUofH85?=
 =?us-ascii?Q?v/PIxkOpNb+2sSLps0UnW9K96cB/oGdAbEBcd2bkivB0M5bYBfxC43lODIeR?=
 =?us-ascii?Q?89QhylVkgwxn98NjOWUT9fNeK1r0yyU0jCUpcHx2/MqDOPhiuJPdQjSOmyF1?=
 =?us-ascii?Q?CKqH4bZLP2Ca92v6qpRuka0vK1/sP1yNYXw9atU3Fw+eZOrtlLXKolL8A4Un?=
 =?us-ascii?Q?J9rJDBLYBzf13+m8/fi2RlJjvd+ZLneqfLDCfqT3oHswDdMtx7QUT76wEUu2?=
 =?us-ascii?Q?h5XYAw8mGqVkY1+5bytCm26JvTzduYCYCQdHQkgpKquKmB9uJE+0AdDrzjes?=
 =?us-ascii?Q?UyfMiHdSORRM5g1Nw0mnLbyyilQu+It9YI79FrIi/J1fCKS2cUahRlSaWd44?=
 =?us-ascii?Q?xjICMMiUxZZrqjLHldXRGsRC7aEiTpXTv0fBXmkI2k2eAmRuuTa2RhXeI72r?=
 =?us-ascii?Q?LokdbqEcxuxfo9TM+mm3uZYCMVsj9X/0g2WArfsVbI1HjbDnq2p0Zj6uRPiJ?=
 =?us-ascii?Q?q34g14rgtpDLbUuxBTYGJlFdkM77V4ymR3FuixyCHLm4cTRMnBy7v0bAfuqZ?=
 =?us-ascii?Q?QQXqNd4ZwgBR7srn4mAVRaqCfAGrE4w45gpj1vn2Ivpt2suEOxzQ9jqtvwA3?=
 =?us-ascii?Q?Lgsrf7QQ+PCoNKUBEWzFRz4ULNNU74AePjvNaIUXA18NSYbq339sQurQtpbR?=
 =?us-ascii?Q?zLlBS71tCqw7u1k5ikxibRfrnuxRTlBZRsaUmkRfgNJdNEMnx7RvsIa8s7x2?=
 =?us-ascii?Q?YjyTzy28f8kbS0EI7EMC3N6VRCW/8i2TLhqLKR8LoUcXZ4B9xDK/LoV6TFtg?=
 =?us-ascii?Q?9TCpEclKVrLxrHFPbBWCrY/afvvaJzwNxkW4hTs+oQ/NboPvYMWNKmDPrCXU?=
 =?us-ascii?Q?gsrjVeQnQF517F+f6L1CB/28xNWsSyLG7lDBttAuL7X3xbExlaFBr808VAB5?=
 =?us-ascii?Q?DsfBD2VOSsP8Sw9rdYs6upb9DRLJ2j3YAzxirbB61AQiwNiuYZrBWu30q4E9?=
 =?us-ascii?Q?Vj28cJ5jjpTGjiBDWtPlW3axGmzVLRthI9IYWSBnHPnt5ca9j10p5j71nkOQ?=
 =?us-ascii?Q?+gDNr8U3KmpLRMwEfGeYS/pwuxEKLCpJrje7QlqUqSjv7Uuw6Ksbf2xLCFOA?=
 =?us-ascii?Q?19yjuwA9Jp+YegUL8aNXViK8CTu850KVSswWQzM4rehK/5PaN5rLG9obS/Lt?=
 =?us-ascii?Q?wGcrpaepFiwTyxbQAvng9LiY/kRRkV4m1L3P40tLMZwntAC4WE6zCtomyAjT?=
 =?us-ascii?Q?ctVO4fnOR5vZpCaMd4ZXmBu/7qtLvZNHK3FYF7ZfV4NKL9eUD6RJTI5VyNSl?=
 =?us-ascii?Q?/vnIKU9Fz5qOH5ob7xwc+/2c?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea22325c-6177-47c4-b57a-08d9920cd32a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 07:56:43.1671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhmT8DRqbx6RkQqvjHTc1BCkS/jPA723hPOlRf5Fflrlotvr7/52cKwOSG72/9uO1raJ6Y1tSlrDFiFsAoNFp+Z751s8VXzck1ToWLykQKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5916
X-Proofpoint-ORIG-GUID: 2YrmF-188GHRLY1BE-m4FjEXlQY6Xb6o
X-Proofpoint-GUID: 2YrmF-188GHRLY1BE-m4FjEXlQY6Xb6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_02,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1011 mlxlogscore=999 adultscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110180049
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

This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
is called by cgroup_setup_root when mounting, but not freed along with
root_cgrp when umounting. Adding cgroup_bpf_offline which calls
percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
umount path.

This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
cleanup that frees the resources which are allocated by cgroup_bpf_inherit
in cgroup_setup_root. 

And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
cgroup_put is at the end of cgroup_bpf_release which is called by
cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
cgroup's refcount.

Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
---
V1 ---> V2:
1. As per Daniel's suggestion, add description to commit msg about the
balance of cgroup's refcount in cgroup_bpf_offline.
2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
description about it.
3. Fix indentation on the percpu_ref_is_dying line.
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a..ea08f01d0111 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2187,8 +2187,10 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * And don't kill the default root.
 	 */
 	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
-	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
+	    !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
+		cgroup_bpf_offline(&root->cgrp);
 		percpu_ref_kill(&root->cgrp.self.refcnt);
+	}
 	cgroup_put(&root->cgrp);
 	kernfs_kill_sb(sb);
 }
-- 
2.25.1

