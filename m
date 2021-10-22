Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1278D436F67
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 03:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbhJVBdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 21:33:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48506 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230288AbhJVBdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 21:33:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19LJb1r1028264;
        Thu, 21 Oct 2021 18:30:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZAI4ALD3IOPkn/ZDv37bBcofWD94RVNJhCNAaLserkY=;
 b=BrffFq0QvdYXJy+HxkHv0ZIPDi9j6kg74RNMLpiG70tGCk/HmQCUQwYzwOjKeFrDgl3V
 ZIVpOyZ7BmjjGar/4aVr73medsuvqwoqBxQLIQyrKwbt3NqPEv57uKLzyKtSqzDRlHS0
 Rv+VCrOq/rYYjXU6G83miRIITzyhX8p8FXY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3btxd3sk4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Oct 2021 18:30:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 21 Oct 2021 18:30:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWBI7ZdfPX/1eKBljyFXdVFtTSF+oCMAMgnnf2XMo0ocxrXlPGa8sd+zRECOCpeI3MLOjH9MSLQnqpVjenr+vEQ6RBeu7WyXPuY2Jto/w+CLSjLm6fxV0kYvNVxloVefDIA1WkMoLGH0eWKUo3BbNTqsqKxqzurHavz9XNHiuq9ig7HgoMhJMFCQjQRMuAV8juTPf6lw3XuRLjT2iXV4CedkagaQdYQuY7OOA2Maiski8HE0Ck255PIl8IyhQBjn0nM2D8X45p1dyWFasilLzV2QKfDur1lC18bKfAyJQK2SYaQshm4bZakrc6KVUG6ea1E8TMSO9gnJ/l0ncu/opQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAI4ALD3IOPkn/ZDv37bBcofWD94RVNJhCNAaLserkY=;
 b=Pyu1UXvdPZO2HxZJZlu5rMUTKL8GVwtmXUCyChCELIU2y8y/johS7Eq4wektBzQf47VhM3H5omTseDNmpA7SdT9vV01lOhLefS1vB9uFnmJ/6XVXpQUfB3vEku/o94WwJyQrOhNqAVZ7eo55628xRyu4gy7NeOOQHN2nDxlAOBNxrWMg3Yx4LVincTqmfvo5YDUPzT+x6CssOe144DhBcbYWcnXU/XuowxG845OG0AKR/0d9UrPAfdxPWdZEJEgM48BwxnKbxzHMyjSP+PDM5gonc64vtODoaX8forhSTRVtkwwHTnK5UdF4TuvLXtRuo8d6Muh1FoxdFF/Fuh9tMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2343.namprd15.prod.outlook.com (2603:10b6:a02:8b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Fri, 22 Oct
 2021 01:30:29 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::1052:c025:1e48:7f94]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::1052:c025:1e48:7f94%5]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 01:30:28 +0000
Date:   Thu, 21 Oct 2021 18:30:24 -0700
From:   Roman Gushchin <guro@fb.com>
To:     <quanyang.wang@windriver.com>
CC:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        <mkoutny@suse.com>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Message-ID: <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211018075623.26884-1-quanyang.wang@windriver.com>
X-ClientProxiedBy: MW2PR2101CA0008.namprd21.prod.outlook.com
 (2603:10b6:302:1::21) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:9a55) by MW2PR2101CA0008.namprd21.prod.outlook.com (2603:10b6:302:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1 via Frontend Transport; Fri, 22 Oct 2021 01:30:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78992110-7157-4156-29fc-08d994fb87d7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2343:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2343B8A9BF9CC05C24FEE14BBE809@BYAPR15MB2343.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dr5YdvoZ37kGfZISM8Bk7Fjm7wYxFS+tDgcdeUdRaBLcp+8OxQzgnnbElmPXbg7KWc6j4penZhSUFjw4LRndATJCOVuhE5nA5sbK5XgRnfb9Nr0m8eFRJE25ArYqIxBvI2QFLvmw8LsyBTKyFKJornd3P5mOCv53LfqkifT+5thtfJTelFJ1IphOpq/sWPwOab93pdMxlHLynIkerw1/jjTAy71537T8GjQvXSnVrPgyppTK4VIV/6oN/qhGD6Bri0gzYbEudBXafPsg+k36F38ECFhzPSoO6CdbReE6uRRP0ZH7Cm7ggHLOFffnfDNagy3AC0+uAAAStpVKhL5Crv9C6PWMFLnkKzMz08ahVM0hnBFDyd2oSCfuRoeLtm3JIxIL10QxPZurYxkb2V7lp9cIlewGMEQpd62vHBuSDCYBKOutdONZLwZQD8eim6heRsDAonBe5bIXyiR0wyhj29bZXCAMgNJl6bm7yksZJHDmDdqQHdVT0ak7Nw13Eb1KASnuq0W+obXCZBUD6ird+rR/K49DZhZaR0UZzCf9fqDCzMP0U21ccYa/fGOe6o6K8siUz3MurSSBhQe8+oAc/Qct9hPLD2fCu5gj5SSp9M2LFDDGagUe/WB+QIWXDK7jg6sbVvcAta/AIWRuWk8KYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(4326008)(55016002)(5660300002)(6666004)(86362001)(66946007)(54906003)(186003)(6916009)(316002)(66556008)(7696005)(2906002)(7416002)(8936002)(52116002)(508600001)(8676002)(6506007)(38100700002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?msSRbHbenpTw3geXZA7bctjBX3fg+5RKAgLlZ7wYE1SB+HfojjU4MZ2B7a/e?=
 =?us-ascii?Q?GagZbIrez60Tv5HtcS6PM1K+jNVvD6HDeJbdn+WU4XT/JMDvWUaa+fHNojI8?=
 =?us-ascii?Q?zQd6nHKi6u512LwsAg7DjRmYnzIZxX8/AejnWSrE7Eg/YQWKmDfbTc1GJu/d?=
 =?us-ascii?Q?9IslU9efjr0/Byy2CJqwYcYI8nuGNUcBkzX/LosRBoR1Z57G3xo2KJdQDkgi?=
 =?us-ascii?Q?NbArAYON8/CUhqcVrvPpvSKJTylZGgm5/Ta0XFw2RNGjQjkMZUKYR+sfa2f2?=
 =?us-ascii?Q?0aFUvWD2IdFQ9MtzB9+W5SQp9g3ZOC0Lr6f3dpsmmDtTCeGU3icwmgHhLTp4?=
 =?us-ascii?Q?KkHt0ll4r0C2ZypAeTVIp2gSrclZAYX1Z0JVeVfhXVGOOXusKjKMAw1lgs3F?=
 =?us-ascii?Q?91S+aIo3uSNVi4Q3WmyBcnoIu5mO9phFqQTiKligR6rxO+u8QQ+dye6FdCq0?=
 =?us-ascii?Q?n9wLe6cjisQpooHCWit5IAG7xkLiSK5Xh6RayTO4OJfqfnyvMcIZrZ7DL/OH?=
 =?us-ascii?Q?MhGZ/OuS23Khh6i7ZtvbO6ylQSqOnF/H6pXxC8jM7PCcgPlwZopiS1fRxMXu?=
 =?us-ascii?Q?/yS8/m45RWNlS2lsTJRlkOvZv1/1uyB5EMQXCjxRfuWpHM86ffQgLiQp/ZUX?=
 =?us-ascii?Q?QEGy/rhsMvCa8Qp/G6S1FPrUhlaBnHn2DD55W7A3Tc/lhPb2GGy46Mt2w/NF?=
 =?us-ascii?Q?N26sIE3WYCbRfk7vt6l3cpVqaFfj+j98w7hv+1ivI5cSBWoLmacvvOn/TpyH?=
 =?us-ascii?Q?q4DagCglTRjmG6bIciUhaPqaDJ9ypYck2UvytXpQ9BZvTUaRUm5DjiQvXdb8?=
 =?us-ascii?Q?HNTB0I4RmOZ9loDdwOlGGOAr6SkqLqXn0XKoGLLtzVEPFIA9OLZiMMXyhpAw?=
 =?us-ascii?Q?oI265mzSS5vZTTjGEDAcYtNk6psM7spf1LR3JoG9sPanKA2/5UrgzwyarQWd?=
 =?us-ascii?Q?S/kWZ8Nas+XcsIxYdPDJY7UsC+067PlmObpGK0CaS/GizAe4ifXKD7GIuXE0?=
 =?us-ascii?Q?Y+lj8IGTEPOcZqgmunu8FTajGKb323o0olJ30y4DyPjwOm+Gjn02BxEbb9Wf?=
 =?us-ascii?Q?/7aCwTHMwJ780OtDR3EK/oIZbiNxvPQZo1FCRKXln6kpJ3dVvwvM5Qqcvumn?=
 =?us-ascii?Q?ycIhsWsbqoDDGME/Xjsw088fEFkj2zFvfs+HxRPpwgMoKgpzrvBmOmodtkzl?=
 =?us-ascii?Q?9DuTLchbyhP4sy42YqvDXSZXnLvYbSE9t9nWheYMtV82K0Mp/a28X/zzPcwM?=
 =?us-ascii?Q?xocHJKmB+yFubiDDwJjnPJWHJQUpn2gEtYhRhuPTaWLYlocpRWH64abTjXa3?=
 =?us-ascii?Q?ijLOCKgZUI+dyQ6jZ1c1Z6sWuhM5N/0cJruxXYhTxytUgKVp04392xteUf3M?=
 =?us-ascii?Q?WVkDXItqd0uIBRUbcgwBlq2u85IqbF5EjdJc96jqqFIKElrVvNbzP1k/LFPq?=
 =?us-ascii?Q?ngjkd/ZYskjtNhzuiyke1+nYXeSE/0A+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78992110-7157-4156-29fc-08d994fb87d7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 01:30:28.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2343
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 3yJ8CL-sXNzCGi8IuvyRfeP4QBAneYwo
X-Proofpoint-GUID: 3yJ8CL-sXNzCGi8IuvyRfeP4QBAneYwo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_07,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110220006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang@windriver.com wrote:
> From: Quanyang Wang <quanyang.wang@windriver.com>
> 
> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
> the command as below:
> 
>     $mount -t cgroup -o none,name=foo cgroup cgroup/
>     $umount cgroup/
> 
> unreferenced object 0xc3585c40 (size 64):
>   comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>   hex dump (first 32 bytes):
>     01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>     00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>   backtrace:
>     [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>     [<1f03679c>] cgroup_setup_root+0x174/0x37c
>     [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>     [<f85b12fd>] vfs_get_tree+0x24/0x108
>     [<f55aec5c>] path_mount+0x384/0x988
>     [<e2d5e9cd>] do_mount+0x64/0x9c
>     [<208c9cfe>] sys_mount+0xfc/0x1f4
>     [<06dd06e0>] ret_fast_syscall+0x0/0x48
>     [<a8308cb3>] 0xbeb4daa8
> 
> This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
> memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
> is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
> is called by cgroup_setup_root when mounting, but not freed along with
> root_cgrp when umounting. Adding cgroup_bpf_offline which calls
> percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
> umount path.
> 
> This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
> of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
> cleanup that frees the resources which are allocated by cgroup_bpf_inherit
> in cgroup_setup_root. 
> 
> And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
> cgroup_put is at the end of cgroup_bpf_release which is called by
> cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
> cgroup's refcount.
> 
> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
> Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
> ---
> V1 ---> V2:
> 1. As per Daniel's suggestion, add description to commit msg about the
> balance of cgroup's refcount in cgroup_bpf_offline.
> 2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
> description about it.
> 3. Fix indentation on the percpu_ref_is_dying line.

Acked-by: Roman Gushchin <guro@fb.com>

The fix looks correct, two fixes tag are fine too, if only it won't
confuse scripts picking up patches for stable backports.

In fact, it's a very cold path, which is arguably never hit in the real
life. On cgroup v2 it's not an issue. I'm not sure we need a stable
backport at all, only if it creates a noise for some automation tests.

Quanyang, out of curiosity, how did you find it?

Anyway, thanks for catching and fixing it!

Roman
