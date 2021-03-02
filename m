Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFB032A2C9
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443766AbhCBIcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:32:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239157AbhCBBSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:18:05 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1221EKAW008294;
        Mon, 1 Mar 2021 17:15:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uqY8g06FFAV5xQpyAbRl+VapuMxesj+spaTV2MTwDE4=;
 b=TeY/yy0h8jTRLO0uvJd5T4lwDzZm9tJv9vbsBjSX5NaQ0RkXSaC8CtlVTsu3gbCNR6r6
 8EYa/ajJz1eWyP2Lplm/HZvmQxMBeYTv6uXkYY/uHcIxWEp65li2oh4HzKJHGBQsOhH8
 ItfKouwGmYs3h16wI79f+plghi8jdp4fJ8g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3707450mwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Mar 2021 17:15:46 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 1 Mar 2021 17:15:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m72TdMtRjH2RsfYuY6xg5ssnwbLSpqtsS5kFkt8yYpDmgN7/DdHafKxTlberNw+YsygrmBxPJ2WGzQF5vSeH2l4sqWXKNMio+hA85CjRX9LHkjxL68RuwMzsm5KSIVp1pdZbUVhoqiUQIHkD102oQqzxClggMJk6EQITgARC6YIGG5thx5AHrlfvZ8zAPV0wGgAkzENrYhK+WEbT/1iDk3YPQoEDH32y8GoLMJZA5Wis2xIuyKoidO8prBDSdCz/0zNz7mJem+iYdY0wRkVVXzAQOs12Ac3wPkYTFuj1GRjD0IJyn/W7Fjoiaayb9CMulon67nlyomxP5gkgfUa1eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqY8g06FFAV5xQpyAbRl+VapuMxesj+spaTV2MTwDE4=;
 b=FVJwE+H96aIq1EFJ5M0x6AbK6LT9nM4gMvFvlnXiH9p6Vh4MLiQW1DVTDaagr/jkrZxy6pEHRHSvgjaYs4femtMJHJd6I/LphFphHpheBBMN7wlLSx3cJLd4L138lMMBIl+f+l7TL26huzWgqBoqhjaHRi2IurWwUiW/p1Wh/+8o005scT6ffciLrIFKW/5aGnnT3U1p4rCJ4w+uBKNPUCSCePgXHdgsoPVkCFjMCfI8IjeDOYBzCyly0/dnrJ+nk8xVEiomw6u3HwdXfc6GqnKLPnbN7z1ZVFLfdZQKxtVQl4/7dViE3+oyBck/qXqBWIdHROA1gONoC64RfNYXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB4308.namprd15.prod.outlook.com (2603:10b6:a03:1b4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Tue, 2 Mar
 2021 01:15:43 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::53a:b2c3:8b03:12d1%7]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 01:15:43 +0000
Date:   Mon, 1 Mar 2021 17:15:36 -0800
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
Subject: Re: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to
 CONFIG_MEMCG_KMEM
Message-ID: <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210301062227.59292-5-songmuchun@bytedance.com>
X-Originating-IP: [2620:10d:c090:400::5:642c]
X-ClientProxiedBy: MWHPR1201CA0008.namprd12.prod.outlook.com
 (2603:10b6:301:4a::18) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:642c) by MWHPR1201CA0008.namprd12.prod.outlook.com (2603:10b6:301:4a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Tue, 2 Mar 2021 01:15:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 133d07ec-bb70-49bc-0520-08d8dd18b336
X-MS-TrafficTypeDiagnostic: BY5PR15MB4308:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB4308BCAA5EEF7BA1628128F2BE999@BY5PR15MB4308.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXWMC3JyZ6IhBHtX70Z70md20oxI885nSEzsVU9YqliS8uT9y4CcRKJbEcGTKXBBmXlWx0Wn2WzQexbSuHGW4Xq+a/6kS0WDVqmnydPYDJXAwSvW/1k5xfDqL/oSmofpnrJdA65GpE5HdoWJRbHtbA90BkMsQLJqHu4Z9Ip1NAip7anTi8+jfgWmsx1FHTwhxEUDHY2RCn9xJJqTO3xS0u1ECTX0Fn4h57j1n2IjfxLoM4Fs2smbZxC/wNKjhJwtg9+FprqmlY0QTCuejxspnyMXndVTPs/MjR4u/POJEdQsVs3XitMpKzt4aBF8YKaiKFoW57a+ZojRRLKGhSMQjREbUktVyzi5yMcE+Opj+NBHw9eMXaavnyqNEYNTD6+zECKEaXSHBM87/PNwA2E4kIvMpGs7tp5aFYZlduoxZD2W3g81KG1CqIQgfgHOH2G77vCdh/FIS7Vza+AaOtuF2Y30Hax0PkjJouNZcy9Cy6L8YHHB0bcla20bc/qknqHcDmdlUMDFXq40+6o1GWg0Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(396003)(39860400002)(83380400001)(4326008)(186003)(16526019)(7696005)(86362001)(6666004)(8936002)(52116002)(66476007)(5660300002)(6506007)(66946007)(66556008)(478600001)(8676002)(7406005)(2906002)(316002)(7416002)(6916009)(9686003)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Lvh2V7tKrophZYKbN44GNw+O1pCt3gXqWb8QsqNoO2g4JxiTLvf2et1vGfUN?=
 =?us-ascii?Q?wU67YaqFY01yJdDqz0Nv12DaDg4G+miEzl+9xNJmvQ/D/kOtP8eaxbDi6uKv?=
 =?us-ascii?Q?IgzDmM2o7HUE9ayarOpJWLP7RgbM0pz5Htl15j3NIMeJwrolPjcYYbjc+4n5?=
 =?us-ascii?Q?IejVP4YWVEVcEFA6s+ue6+tgpW0UgXRIMaTlVcSRnb4lE7om85pWBNykMELH?=
 =?us-ascii?Q?/syaLCwkfRnyphhfMdKSiyHvXvjNTV5EvhydaVMB3pTDp22NLKIlbzYA+ymm?=
 =?us-ascii?Q?eSoTPMUJlgZM01hRUW1Q+3rGrCQ703e52YhIoZtQuaGFN9aMw3Xunxo2u9my?=
 =?us-ascii?Q?ARjBY5REdMaij8whQz5lwmQQP50cLhTxxNJsYXNn+0zl0J0JefFgf4/5IkoU?=
 =?us-ascii?Q?BjY2NgSISxIcj853dWkucNsxYvJOU1W3N8XzhaNPVEanzxWHLX4MRNAEaJC5?=
 =?us-ascii?Q?R6z9yf8fu+CFB46n7COvb04AdzitG9oHnweUkEMsnjJR6d95276y5mjvwn1Y?=
 =?us-ascii?Q?xLR6DivDE/Qnf/rR/ViqYJ67v0jTkJOgMUBJS3WbqmhjJ/uH7lFZcV9H5I18?=
 =?us-ascii?Q?FmXTxWf4ZJrRP06y9XlInkylqcYNtgigMLgkkkKdEWnM2vP/ipPXMQeUu4UQ?=
 =?us-ascii?Q?QPRA8LAdewaICNZU3Yn2BUREgDBhs+rNlwMg4nXZKcykEks+4JZbgD/VhSxb?=
 =?us-ascii?Q?/WiEAVoeuZ/1V4Mt94RtDx/Vlu3hP3rSGnhVixi+u6rJ7ZpUaW7FqV/vP29j?=
 =?us-ascii?Q?ng/wu7foZoiSxDAqcdE+O8rtbzygww/EV32ts1csvCYJBOLN+7WVSUnUDHee?=
 =?us-ascii?Q?lR7DTlAKiUhBZyIZ6Q6D0qJ1/Hpj94zD1vt85zQSnPynL9z8Fyx6QJ1QgzUg?=
 =?us-ascii?Q?D85QQX2fT9bt9AzcYG/UJKN+3FeFWvDujuWDs1uzYFaBtgUwcXMvbscuiAG8?=
 =?us-ascii?Q?Vdrqlxpkx/IpUOo+MWc4BTu2h+gRxoXRMKZPm2dZRad8LD31IzSDm401Qh+3?=
 =?us-ascii?Q?pKf4bztbdjY+R9Kjc8zLDsyaqqRtasi0o71N7tsmWNz06/t4hiXAeCRlrOrb?=
 =?us-ascii?Q?UZKy+4qmFE4EX6FvQ3MdmuYwAyqlL4ivpfd9d4Qn19MgP8Lvkz7Iv/GU/Lu6?=
 =?us-ascii?Q?Cqzn1n77kXKVNJnmNbKtvw7ZDwykfIvfucqbR5jVaUY/yMh9F5dJvAojTKsG?=
 =?us-ascii?Q?6mluXX2rlKCvLMJ6O/Lt94UgDrg6K8ILvObCgRLO5EwrePrE408GwL7f1cGq?=
 =?us-ascii?Q?txbxAjAIapm2hAI1CTDk2h/zDu7uyDBnNv6DK+PW5Y0KnWXc/JZ6pQF59tP0?=
 =?us-ascii?Q?H1N52vPsSLkznnj4Yd2xsZsjVDFCLyLtDjLVIqPW4YuiYA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 133d07ec-bb70-49bc-0520-08d8dd18b336
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 01:15:43.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GT/lZuhAoxyLgYgPmN19w+aTPYPumOnkRz7fzpF128GEATvbJbUMkFjy8ZdCoPsc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB4308
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_15:2021-03-01,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> The remote memcg charing APIs is a mechanism to charge kernel memory
> to a given memcg. So we can move the infrastructure to the scope of
> the CONFIG_MEMCG_KMEM.

This is not a good idea, because there is nothing kmem-specific
in the idea of remote charging, and we definitely will see cases
when user memory is charged to the process different from the current.

> 
> As a bonus, on !CONFIG_MEMCG_KMEM build some functions and variables
> can be compiled out.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/sched.h    | 2 ++
>  include/linux/sched/mm.h | 2 +-
>  kernel/fork.c            | 2 +-
>  mm/memcontrol.c          | 4 ++++
>  4 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ee46f5cab95b..c2d488eddf85 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1314,7 +1314,9 @@ struct task_struct {
>  
>  	/* Number of pages to reclaim on returning to userland: */
>  	unsigned int			memcg_nr_pages_over_high;
> +#endif
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  	/* Used by memcontrol for targeted memcg charge: */
>  	struct mem_cgroup		*active_memcg;
>  #endif
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 1ae08b8462a4..64a72975270e 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -294,7 +294,7 @@ static inline void memalloc_nocma_restore(unsigned int flags)
>  }
>  #endif
>  
> -#ifdef CONFIG_MEMCG
> +#ifdef CONFIG_MEMCG_KMEM
>  DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
>  /**
>   * set_active_memcg - Starts the remote memcg charging scope.
> diff --git a/kernel/fork.c b/kernel/fork.c
> index d66cd1014211..d66718bc82d5 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -942,7 +942,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  	tsk->use_memdelay = 0;
>  #endif
>  
> -#ifdef CONFIG_MEMCG
> +#ifdef CONFIG_MEMCG_KMEM
>  	tsk->active_memcg = NULL;
>  #endif
>  	return tsk;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 39cb8c5bf8b2..092dc4588b43 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -76,8 +76,10 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
>  
>  struct mem_cgroup *root_mem_cgroup __read_mostly;
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  /* Active memory cgroup to use from an interrupt context */
>  DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
> +#endif
>  
>  /* Socket memory accounting disabled? */
>  static bool cgroup_memory_nosocket;
> @@ -1054,6 +1056,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
>  }
>  EXPORT_SYMBOL(get_mem_cgroup_from_mm);
>  
> +#ifdef CONFIG_MEMCG_KMEM
>  static __always_inline struct mem_cgroup *active_memcg(void)
>  {
>  	if (in_interrupt())
> @@ -1074,6 +1077,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>  
>  	return false;
>  }
> +#endif
>  
>  /**
>   * mem_cgroup_iter - iterate over memory cgroup hierarchy
> -- 
> 2.11.0
> 
