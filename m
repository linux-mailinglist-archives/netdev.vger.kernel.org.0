Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3044252D8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhJGMS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:18:58 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:27898 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232984AbhJGMS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 08:18:57 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197C0IBK025033;
        Thu, 7 Oct 2021 05:16:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=0M17u7nBGRmZAB+OlhuQ+eS7eccgkEkbHkBeG1wUEZ0=;
 b=rwg0P+pc/9YsPFEi07u1kDrebYFMEdZtpi9Mmoss7YrtfeTckFhOlwhv7AES1mm0IVAW
 NnHBcZzRVUM/91zvo28ENOJDOLGzZ/2skbLqIZ/fN2ykxKrynegBpxY8MBUNnl7bnDQb
 VQhKyMp4s7kmB0SovLYuC/4A9597VnuP5binNzx9EwV96KYCby5bgp9jy00Dat/9SPkC
 mBlYOJkqvJbiKFa6XHngjlbhOP6mbrg9sewbNU4AN7CLuF51dRTZdpADKbZm4vMQAA3G
 0g4DwFhU9dHipwiKairLyGDnDaINDMYufiiCDStDT/6C9PJN7NVP8h6mDQPZys7mybXK yQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bhkbvgjpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIwfIF38hS4mOqaMDAsJRVv+LrKHiXA3ROE5HyqufDPhJ/aNluQ4zfSyrupsnmaZELuaQ5Rwfsu3JhpjKd2JGObFvlNiL7h+EClCEtzNw0dXHF1GZ46BwmdG8Lx9G6qqd8PuOfN3L3PPwKD2fR0YPzJuPnG2X8rMnFISxVpB/z1qAtfPG32ZxbX0GjHe/kE88cGrmI/sGmESks9L9Qr1IpjoSv30ZUc/xEu00PAnMRTjQXOXDresaun7THNQDBAd6dUXiiWE0RsV4IHb2EsQPi/hLt8PmTqSU1okT+F1HWZVXg7xjd49UmaF92KIw0RnfRHTiPsV92RF4mY1P59NmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0M17u7nBGRmZAB+OlhuQ+eS7eccgkEkbHkBeG1wUEZ0=;
 b=N9KinLG4FFoF4Rf45gSmyAH9bHhxHrs7g3ZKagkIyCIoHwYAvpYmas61ZXJELzxeuVbb4wrPA2e6ksnHp4u7xpWE67oJFpKHem7nfCYXFM0tD7GPDPMKT+h1ieNASEUbMnG1izy11LmNsK1MJQF0NbvO4PoH55tI9D3yVZUMAJgRLrjwlF+XxYLrPYjst4FvWqm/qDcaaQCp7WDAjw/5jWEGWDpF6Q3KntDtR7Ri14vTa5eyLwJlf7R2vPUgI1WwaN8Urhdvyux6j8qGKFjDQbo1tNeLvlGd7JqAezCF9Gr8TOcVN+KVHOBPG9lr4WunxDFLTjjPtwDmDorpcD6NuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM5PR11MB1770.namprd11.prod.outlook.com (2603:10b6:3:10d::10)
 by DM6PR11MB4705.namprd11.prod.outlook.com (2603:10b6:5:2a9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 12:16:25 +0000
Received: from DM5PR11MB1770.namprd11.prod.outlook.com
 ([fe80::9505:3c79:555d:3bc]) by DM5PR11MB1770.namprd11.prod.outlook.com
 ([fe80::9505:3c79:555d:3bc%11]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 12:16:24 +0000
From:   quanyang.wang@windriver.com
To:     Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>
Subject: [PATCH] cgroup: fix memory leak caused by missing cgroup_bpf_offline
Date:   Thu,  7 Oct 2021 20:16:03 +0800
Message-Id: <20211007121603.1484881-1-quanyang.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0118.apcprd03.prod.outlook.com
 (2603:1096:203:b0::34) To DM5PR11MB1770.namprd11.prod.outlook.com
 (2603:10b6:3:10d::10)
MIME-Version: 1.0
Received: from pek-qwang2-d1.wrs.com (60.247.85.82) by HK0PR03CA0118.apcprd03.prod.outlook.com (2603:1096:203:b0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Thu, 7 Oct 2021 12:16:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 065ef29f-6937-4579-70a3-08d9898c47b8
X-MS-TrafficTypeDiagnostic: DM6PR11MB4705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB47052AE4E308477FEEC05617F0B19@DM6PR11MB4705.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvdm/0h33DSm87X/3FdY7eOOImAdqCcRhV7/ZFfxcGOUDbDHx3rhH5lQfo2zuwa+qOrj0OUGteuDbuWNbfVD85A602shNUw/alnCVvVs2Dhf9ei8+GQvTWnObZAL1PUem4R0rB9EKuU71v1X8x3wWNFhg6ussnTivRjLrISD4ro/eYkxHUX2ohSRXzyxBs71nyzVF4c/VbK0DwmoVxAOGZ5QILWAeNDhflslI5kLt/8chPku/zw0p+9wUF+j5NzMWIJ5awTE9kZGpr7XvENzf2Piw9fe+q9i0fKt4avv0ZpntmDSRUpzv0m9io6fmQEiO4kLHd6gq0ARyfk0eZ1OSfkzhmC0aqCRgvbRDEpicry3QRdipuSbWwvrDkzG6ck2zl8+V8IMkitoCuU/WmkpAJ3mot1m/IJbDfrBFFk39WtAIeSRZARzCSfTpr5oBHsLYXMIPOOvTZeia0IevM2EPPXEK/7p9JmAOCeEVygaUvuOf74y7CvjIwQ9qiQoJ7lKiioP+zNDB/WIHQiipuImA189Uqfztx6Tx2/GLmeTdbhZRh01ZMfolT/GtPpWHwfSewfAirvVyNAuR4od2Uj6k9kx1WT0KKtUvD5c0lI8SELSt8z6A+/OBXcw9D+kZpbEuuXbomm989GObJMYAR1ChN05+meFDZsZmoW3KnfGKNn/omM2//5eSYrgn1mRlSAuQc/HaKKEfD1OHGZfNyB9pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1770.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(36756003)(2906002)(6506007)(83380400001)(66476007)(1076003)(66556008)(86362001)(186003)(66946007)(508600001)(7416002)(6512007)(52116002)(9686003)(8936002)(26005)(8676002)(4326008)(107886003)(2616005)(110136005)(956004)(6666004)(38350700002)(38100700002)(6486002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FFg8dpz2icfr5gV999ITWmHb1dL6JI0qG3wblHF1c4QqnWn/WHOuYWQRkoRn?=
 =?us-ascii?Q?vHf262KrU8814Ql8pmhNaqv2yLQmVKQt8ed/TjutNa/eOJYvYH5L5ZWqt02g?=
 =?us-ascii?Q?lH450sZBP+SqwPjiiFaFB0YHgs/grqSEZ21UCzc/4MywAZbPEuokUaE9X7YT?=
 =?us-ascii?Q?OGNa0WhoRQN0rs73JvXUB84mfcBgLJX9LbjkDbEhVjZZm/mXh4MJ9RVPgmAk?=
 =?us-ascii?Q?D0vMkKdEF78CmLwU+oXMoY6KQpI5ynRH20VjvmxxYcjaEu6aMswARdzCweh4?=
 =?us-ascii?Q?Ey2D7zqc2zn4RtzbEb7L+XN5e3hBRfnsCBuijWflNyzPQk5OTLlu5Wws/ih7?=
 =?us-ascii?Q?c53vI8s9sn9LdCmcOpZQ8VkkZ/NTmPaRaW2FWTpg8QP0r8hlIxZviiAcZB4i?=
 =?us-ascii?Q?hANy/TznEM289WklXeM8CpHcNSRU/YMnCYHV4naIliiC1mAxmG5fHjXNTwcO?=
 =?us-ascii?Q?4/H0w/yF0SCt/72wxLLR2zNEVqBIiF4BdGmRYTFfhrnfpEHAJ1WdV1HOqC8A?=
 =?us-ascii?Q?UtrksW9QHT7oAXo8RliG8JvEY4idzyITV2lh6069WlMiU2iUbeXBTNZRRYoP?=
 =?us-ascii?Q?Gz9LNOBXJhFgpPZ44I33aHZ3KXnQUY+roBq0hrTQkCJICuwyzAr75aNSP9Vi?=
 =?us-ascii?Q?jkPyAWZ/TkBDK/h6V2fZif5r3m842HQGr5P/muznvtojR9wzdW9MZKnXiCnm?=
 =?us-ascii?Q?ft5KZQtgBNJcaYWVetWKuu5HieG1esnSWM4L557CUDrX/e7kuNw7X90Vsvvt?=
 =?us-ascii?Q?TURn0YHJadJZ9c4Sqzf39KoviO7PZij+4U/jRei4Qy5vVvOnoQ8cyRGjFofC?=
 =?us-ascii?Q?6ngVe9QEBg0hYKeoJBtRjKXOJWuWMbVQuWmg7qxyClSCs076aCM429AGaqQI?=
 =?us-ascii?Q?kPVE6vpZyEbM1PKwO/M53GwzafE1e7DXsrO0QXhH8LDESdD4B5pTOd/5K89c?=
 =?us-ascii?Q?42NUMmjueSsVOSNsJEZ+8Qjupo1KrKBdmOC70tiuuCv6k1qQyqZSjAwpV2ZA?=
 =?us-ascii?Q?cQZb+s3kcAMxvDrVl4VDNKHDhE1I5rPTaQPLUz8P3MvSqHZ+1TGGagTNRyYD?=
 =?us-ascii?Q?D3lWhFgxkbDo4FmFukXFt7wx63MSx3Rlu5VAI12/8pSUqhptHGBqOGxR+1dV?=
 =?us-ascii?Q?lNp5hvi3qNOzZM028X0u2JqyRlMB2Sf0L3LyKl41h1mxtNcD0X9Ck3cSCYdU?=
 =?us-ascii?Q?ReiEiHMw6GFsdDnzMRFCuaNpWBoF1hrU9CdlpYxM8XFlbHtRCOpU7hzoF9Hi?=
 =?us-ascii?Q?2Qm5V8SwnFfZIDEWo8dUTR1ZFaFhUcDpJd59FE1PumUwE+cidKHZIbbFVWtw?=
 =?us-ascii?Q?37Dtb09hy3DFDlJ24718kySe?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065ef29f-6937-4579-70a3-08d9898c47b8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1770.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 12:16:24.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2MAb0A4+84vZCtOnsN4i2Mpy3V+IvSdhoZnSstgn7zwOGgk8+gGvmht8ObJkGyq9b/3kRGd5BU7D+KW74sFA3ed2aChFiJSU2sN573OmTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4705
X-Proofpoint-GUID: gHMB_KhivIQSUGUoU6cQT0I6rIuEZCey
X-Proofpoint-ORIG-GUID: gHMB_KhivIQSUGUoU6cQT0I6rIuEZCey
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_01,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 suspectscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070084
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
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c8b811e039cc2..ce636deec5e41 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2147,8 +2147,10 @@ static void cgroup_kill_sb(struct super_block *sb)
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

