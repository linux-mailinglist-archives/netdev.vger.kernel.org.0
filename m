Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE27932A2C7
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381775AbhCBIcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:32:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43012 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233166AbhCBBOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:14:18 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122147Jw028017;
        Mon, 1 Mar 2021 17:12:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ThN+ehv/zMIPsztTY0/Oc35AMeSc5RecSzsa87omAco=;
 b=M9alM8+oJnTILnBZEDHmMVLdcDVxYxKxIsH66hkzDvuGNWqJdDq/d3iV02dIOO+jzMDg
 1qO40mIyK7ExrEtjNrFinafblX9J8NCiBeR3dwHsqMOZdXGSod/LFJQi0mdU4S2vfgrU
 jGw62O8DOJL68s3WumjI2qLRW1wh6VA9sAc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36ymsrkb4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Mar 2021 17:12:17 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Mar 2021 17:12:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFgkXgtBltvjKoxSRwzLkeIcUdQvSdguGWmmgHVsNGSXal34YV54UZFiFu3uhjCenmw0rvqPIIJxeNzNvI7F5ogK2fv5s5c1D1I+g5bhkMgJ/JvxxfivQwHOx5wTOo30RZ/STo+pCtw8vZITZz3KOrCXj/DhmLDkphoOVdvnFflcTxMGf5S2viYYOcHzyJzM1hZCyBijySrX37TpVhaMm4MleMCatuY1B8HQlESG3HnpHY5lQdqFQz1UTm+akxQ90KR9kstg18C/WfEOeN37D2aWPec2CljypvSOL5TTjzYAt1GwW53AyQX+6tl8lO020ZqtAQP/LxR/Q9B2SFJR5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ThN+ehv/zMIPsztTY0/Oc35AMeSc5RecSzsa87omAco=;
 b=JelpgbSUx8hdt9hJQy+QLwo6yIRyRQlSdidB/QCaOIASn/H+EXpl3mUpjegCbA3Qa1cal/4xGnKvlZutQJhunHETrORhFmss040eMZGy5XK76f0+0sZ7E5n0TwJ61QDUyzp/zOAnlpxjikstx4uhPT1XUVkq94b74mJ48+S7pyRUGaidNzDkv83DUInDAgHagorJF9nRnwYvIa/Lva+PbdK2x8mdRQrP9vf9E0vlCM0eSA+G0rYNj2vEQF/fFRRoc+Y5bJKdmKWFtdbfG/VfLqjiTCCMl/5fNT1RMq0rtaSxMfIsafx3PquPHbbVGQTn2XTyZzcHD7hfM4gN1vP4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3604.namprd15.prod.outlook.com (2603:10b6:a03:1b1::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 2 Mar
 2021 01:12:14 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 01:12:14 +0000
Date:   Mon, 1 Mar 2021 17:12:06 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Muchun Song <songmuchun@bytedance.com>
CC:     <viro@zeniv.linux.org.uk>, <jack@suse.cz>, <amir73il@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
        <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>,
        <bsegall@google.com>, <mgorman@suse.de>, <bristot@redhat.com>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>,
        <vdavydov.dev@gmail.com>, <akpm@linux-foundation.org>,
        <shakeelb@google.com>, <alex.shi@linux.alibaba.com>,
        <alexander.h.duyck@linux.intel.com>, <chris@chrisdown.name>,
        <richard.weiyang@gmail.com>, <vbabka@suse.cz>,
        <mathieu.desnoyers@efficios.com>, <posk@google.com>,
        <jannh@google.com>, <iamjoonsoo.kim@lge.com>,
        <daniel.vetter@ffwll.ch>, <longman@redhat.com>,
        <walken@google.com>, <christian.brauner@ubuntu.com>,
        <ebiederm@xmission.com>, <keescook@chromium.org>,
        <krisman@collabora.com>, <esyr@redhat.com>, <surenb@google.com>,
        <elver@google.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <duanxiongchun@bytedance.com>
Subject: Re: [PATCH 0/5] Use obj_cgroup APIs to change kmem pages
Message-ID: <YD2Q5q2HfKXPnDte@carbon.dhcp.thefacebook.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
X-Originating-IP: [2620:10d:c090:400::5:642c]
X-ClientProxiedBy: MWHPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:300:117::29) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:642c) by MWHPR03CA0019.namprd03.prod.outlook.com (2603:10b6:300:117::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 01:12:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 853f6be1-e95b-4870-028a-08d8dd183671
X-MS-TrafficTypeDiagnostic: BY5PR15MB3604:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36041AF69DBCB2399C92A3EFBE999@BY5PR15MB3604.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGa9ezh9b9HTJ+8mJG/YXutljqETSReBFQQDyvsL/74Sp6KXOYVMMhI1wT9hk1Dpwwwe04kLirrsV0M8AmDcOeETjQI1QcvyTvqFFjgkdnjrVkcqIGgHy18Lb31cVCcbO7xOFKrrXkqjeV76u6LW3jU3WY43icyfUCG8V/Q7di4FnvXKNZfa8DKmvMnswNZ6HZ/YBajzDyNlORoLOJ9NBkLEd38FZsz26clknqhetIZRIp3wGeNkivPfxazE6cf7FUj1SYKM+Av9nZ2cUvBFeISq57U4tlvxANjrxWoH7WSPPy0wrWbc9u/4wLKeCNOa3VK9Oqe84UUhSQSvFSbD3zbuzebXXPdzxb4U8YpEpH3n7gxw6UFIbp+yABoK/YFMiOrY+62tZ3lozvlSRpHeB4ek0s05gxqC1fce/jRlLGUrQGkYUXGZiu1OTSvxU3JzAfB6V6990bO8n3Cjyh1PxlEd9r6x3QubDxrKtfs+B6MbUjedmazabC30t0nx5eL+clrNZJK7hjKK5cGow9f9+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(366004)(376002)(346002)(396003)(66556008)(66946007)(66476007)(83380400001)(7416002)(6506007)(186003)(6666004)(16526019)(7406005)(52116002)(7696005)(6916009)(9686003)(8936002)(2906002)(55016002)(86362001)(316002)(5660300002)(4326008)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sPxJZpCkDMm8Th2YcoHrjIscrOnug66+AElC7ZJKwWukPJw3CnuCA9vORfLt?=
 =?us-ascii?Q?V+cG+CahxAiSS1B66tgSmpcfSSKiJyVmnO4YaqVYOrU96P3PPzn9T3H43Ni6?=
 =?us-ascii?Q?/Okmu2UGRwnXVUM+ZdbzadMXfI06Iyq/jxuofdCCGqwjkPwnxLUp3nh5CLOK?=
 =?us-ascii?Q?udf3JP6m3QcIHigQAqMjSHoV++LS++iddSU1nGSsWEaBSNgsZOqm+SFyx0il?=
 =?us-ascii?Q?n4sLWa8AIxyopi9W9o78nRoKBYQxWWG6TUcsYYN+Kd+OEcVtmGI8IPn4/zzf?=
 =?us-ascii?Q?iuwYZWoV1ImNiiC2zGyZ6roYD3NT3XwPZStUIU7rDSS3eDzWLC7UN+16sc7C?=
 =?us-ascii?Q?vQaoybBpGUpak0UMfsyigZ8zS53DD3sCSnmClLCBg/DrGvpHI9wADKyfoJRk?=
 =?us-ascii?Q?p+gsTVLrwf5lwEypYJIhaFcqWe9wxtmqmLrDC+1TL+J4ddHA7YnIrqJ9i3Rl?=
 =?us-ascii?Q?kp63CVKfkukUWrbBmK/+nVDcKzYE9wlJr0RGwBnxpYmZt6vfk1UM9dkohHOe?=
 =?us-ascii?Q?ycItNZQIScqhnUcuGyqc2b3t7L3LYiNxW697kK4QfHgddGeNrOlMTnsQSwuN?=
 =?us-ascii?Q?ROx4eWyJp/zPRBgxLbdTvXgba/w6z4M7GX45Q12k0TRbnT0qsm3OUc6NpUqN?=
 =?us-ascii?Q?Z4DOwL1UWAn5b7xU1odSffkKXob/iVsxN6hwDVR3DIZZ7F0bh9T1BHVlVZrk?=
 =?us-ascii?Q?jWx4HAnu1jsIiU3y42Fmp4JDSaPCJV0l7SpNSjWbp4TTVZJA3Un6GqsgSvcs?=
 =?us-ascii?Q?bRvFM2XwrgV6LrqlhUo7I9DIiSh73Oo+ma/BEpB9I3Ag1B21qDoY9BJB+7hh?=
 =?us-ascii?Q?Ku30jNTyLmUIDwmQy4yOg2Ei+76EodZtDIxfwB91qiTC1+WwXm5/m5MOhudQ?=
 =?us-ascii?Q?nWP4mkFjIpfNTioI9nIFzH7pe7HSymBcklgQvYHrvL+i0xEBhMXrnk7L9ASj?=
 =?us-ascii?Q?Ltitoq7yZVfuUWwYBLQI+c7K2O59tbWj+Xt/rJB2MHFnxlpj55JNkHo3X/7Y?=
 =?us-ascii?Q?3v98dOCV3IG5DONP8w6Od75SRETbWX81nqcTF+plAQMjdpQc2DQxUoZep4Vt?=
 =?us-ascii?Q?jOQKlCx6gqhRa7mXKf2FQ1alL9mBtksqxkZlkpVkb9uhIpegMi9EbciiA+b+?=
 =?us-ascii?Q?vwkTqHKtdeZcm9qsJVjGLgHgocPMUllOd0GCE3I5lclKBwv0vo/kA46I+lvs?=
 =?us-ascii?Q?U6PKEOsCZ0Zm/mkMEEOZwNEqpkznHE2yqn5MEAvMC+v6XYW7Hib9eCpCYtpH?=
 =?us-ascii?Q?Jgjtdt1t5KkDrBafmAXGxUDzJIjP1EcL1QAyZgC3FU2hzsBdowoTHvfu3HLX?=
 =?us-ascii?Q?AHs3FXnxRxKpTqFeGDISjJWYRJg8isRUvn9S27MVnc/wog=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 853f6be1-e95b-4870-028a-08d8dd183671
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 01:12:14.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gu6Y3UUUxJ4m3kVw7hKqfTqSLmQA7hnuAMJXLFsy5G1i9566LxF1y/zKxu+jiOB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3604
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_15:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1011
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Muchun!

On Mon, Mar 01, 2021 at 02:22:22PM +0800, Muchun Song wrote:
> Since Roman series "The new cgroup slab memory controller" applied. All
> slab objects are changed via the new APIs of obj_cgroup. This new APIs
> introduce a struct obj_cgroup instead of using struct mem_cgroup directly
> to charge slab objects. It prevents long-living objects from pinning the
> original memory cgroup in the memory. But there are still some corner
> objects (e.g. allocations larger than order-1 page on SLUB) which are
> not charged via the API of obj_cgroup. Those objects (include the pages
> which are allocated from buddy allocator directly) are charged as kmem
> pages which still hold a reference to the memory cgroup.

Yes, this is a good idea, large kmallocs should be treated the same
way as small ones.

> 
> E.g. We know that the kernel stack is charged as kmem pages because the
> size of the kernel stack can be greater than 2 pages (e.g. 16KB on x86_64
> or arm64). If we create a thread (suppose the thread stack is charged to
> memory cgroup A) and then move it from memory cgroup A to memory cgroup
> B. Because the kernel stack of the thread hold a reference to the memory
> cgroup A. The thread can pin the memory cgroup A in the memory even if
> we remove the cgroup A. If we want to see this scenario by using the
> following script. We can see that the system has added 500 dying cgroups.
> 
> 	#!/bin/bash
> 
> 	cat /proc/cgroups | grep memory
> 
> 	cd /sys/fs/cgroup/memory
> 	echo 1 > memory.move_charge_at_immigrate
> 
> 	for i in range{1..500}
> 	do
> 		mkdir kmem_test
> 		echo $$ > kmem_test/cgroup.procs
> 		sleep 3600 &
> 		echo $$ > cgroup.procs
> 		echo `cat kmem_test/cgroup.procs` > cgroup.procs
> 		rmdir kmem_test
> 	done
> 
> 	cat /proc/cgroups | grep memory

Well, moving processes between cgroups always created a lot of issues
and corner cases and this one is definitely not the worst. So this problem
looks a bit artificial, unless I'm missing something. But if it doesn't
introduce any new performance costs and doesn't make the code more complex,
I have nothing against.

Btw, can you, please, run the spell-checker on commit logs? There are many
typos (starting from the title of the series, I guess), which make the patchset
look less appealing.

Thank you!

> 
> This patchset aims to make those kmem pages drop the reference to memory
> cgroup by using the APIs of obj_cgroup. Finally, we can see that the number
> of the dying cgroups will not increase if we run the above test script.
> 
> Patch 1-3 are using obj_cgroup APIs to charge kmem pages. The remote
> memory cgroup charing APIs is a mechanism to charge kernel memory to a
> given memory cgroup. So I also make it use the APIs of obj_cgroup.
> Patch 4-5 are doing this.
> 
> Muchun Song (5):
>   mm: memcontrol: introduce obj_cgroup_{un}charge_page
>   mm: memcontrol: make page_memcg{_rcu} only applicable for non-kmem
>     page
>   mm: memcontrol: reparent the kmem pages on cgroup removal
>   mm: memcontrol: move remote memcg charging APIs to CONFIG_MEMCG_KMEM
>   mm: memcontrol: use object cgroup for remote memory cgroup charging
> 
>  fs/buffer.c                          |  10 +-
>  fs/notify/fanotify/fanotify.c        |   6 +-
>  fs/notify/fanotify/fanotify_user.c   |   2 +-
>  fs/notify/group.c                    |   3 +-
>  fs/notify/inotify/inotify_fsnotify.c |   8 +-
>  fs/notify/inotify/inotify_user.c     |   2 +-
>  include/linux/bpf.h                  |   2 +-
>  include/linux/fsnotify_backend.h     |   2 +-
>  include/linux/memcontrol.h           | 109 +++++++++++---
>  include/linux/sched.h                |   6 +-
>  include/linux/sched/mm.h             |  30 ++--
>  kernel/bpf/syscall.c                 |  35 ++---
>  kernel/fork.c                        |   4 +-
>  mm/memcontrol.c                      | 276 ++++++++++++++++++++++-------------
>  mm/page_alloc.c                      |   4 +-
>  15 files changed, 324 insertions(+), 175 deletions(-)
> 
> -- 
> 2.11.0
> 
