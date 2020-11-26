Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D352C4D7A
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 03:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732885AbgKZCa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 21:30:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730809AbgKZCa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 21:30:28 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQ2ThbD005350;
        Wed, 25 Nov 2020 18:30:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1Tvt934Y8NKZb3371lejoeEp+YlGWUyvQuobprGX6wE=;
 b=bK7mNgCa8snfckWHZBYgYGYDO9ppdlendXY5hEQW4GRA+9oP8IqEB4wPmvMk/VWzu5sG
 CGJUrIk7KSTkJ3z7KI+uIRh5tuLABTWPOoFNgkGADYszwWgf6qyPvfrfyWTf23CnoLYl
 wHJWMCgzs6z/hITlW7TdZgiPcJBuMAKMzZc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 351dspng9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Nov 2020 18:30:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 25 Nov 2020 18:30:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEZxP+xjP266MIyYZoNlEXT/MNcR2gfJHw3TucgVKh9+ziPrVQvU4i7XbnnzMuNmZ/c5KPflrfFJSFjnQ0QZd/Uy+gNQUJNGQCMKODnk5UIdXSucV50oyFf0f1Zx2PMZgYf0AITUL5ow8aZ/ZMXDfedabcLUlHqW4XKX6RU8xPy6VmTAlzcaSCpq9+wA/r7So9vAz0iT+0XVJ5KoHo2/hLMPcwny7Cbyx2n1xLfgfHVcsEb95SqxS4elOv6RsfXDNujjdOfF3zRssi1K+SbZ79MCkzzoCFE5FYUgxAA/2fnzBWyjWddwGkzpT2EObBEzlb8VRMTaHj92aOHj+5yL3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Tvt934Y8NKZb3371lejoeEp+YlGWUyvQuobprGX6wE=;
 b=XtzM6ES1RXP15R6nBpzUEGfQfRZA0vslo5hCg5nhZWjIJxw8dICD7BDcsIeqc/iZaR3W61Ab5yxo3WCKMPtLIaJxbBw0ETCEzj8w88XVfkZJmQ8pq1JxuhiymI8nKNA56U/6EzmiZ4olA/JgRN8NVUwr0IFnPTM32Xz9ilTGVfOjAms6eu76mcSMwRrF81PQ2Yj02+0bvAc8ReshnO7mMsqqPuw+xQ5DvkN6i4TZ9r8o7slqktQargSnd8Ne/uk0LuIlsWS11/Vm8yNJYkqkpZWf1gEabUK4jduw8cRncrFiCgOcKwuYCNpj5eWxOVpbvBHuAq1rwg+cZVwaqcrV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Tvt934Y8NKZb3371lejoeEp+YlGWUyvQuobprGX6wE=;
 b=AWOIOOuwTq4ZZ6gGiSaHJYU3UZ544r/eBOd2PAlJgtYfFB/onFfofneX2yM7jEEjPmHMei2hh4tU9s1kW70gFLTAs3dgnt9DgpxIIeb13Xw2YUcBlmjQX+Qz4TCFNXq2WujBCCkPlnKkzT3VYa7LIG5A8yxabwxQBCD3lS5txMo=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3524.namprd15.prod.outlook.com (2603:10b6:a03:1f5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.29; Thu, 26 Nov
 2020 02:30:06 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%7]) with mapi id 15.20.3589.031; Thu, 26 Nov 2020
 02:30:06 +0000
Date:   Wed, 25 Nov 2020 18:30:00 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, <hannes@cmpxchg.org>, <tj@kernel.org>
Subject: Re: [PATCH bpf-next v8 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201126023000.GB840171@carbon.dhcp.thefacebook.com>
References: <20201125030119.2864302-1-guro@fb.com>
 <20201125030119.2864302-7-guro@fb.com>
 <ef140167-8d80-c581-318c-36c0430e4cfa@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef140167-8d80-c581-318c-36c0430e4cfa@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:781]
X-ClientProxiedBy: MWHPR19CA0068.namprd19.prod.outlook.com
 (2603:10b6:300:94::30) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:781) by MWHPR19CA0068.namprd19.prod.outlook.com (2603:10b6:300:94::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Thu, 26 Nov 2020 02:30:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7b424f6-8b1b-48b4-a56b-08d891b32f9e
X-MS-TrafficTypeDiagnostic: BY5PR15MB3524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3524B87357188C5A0B021EBBBEF90@BY5PR15MB3524.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8DkNXH3BbbWEo2AOlAAK1FZbDsattcc2fX+WPAFn1l82VaZfyhy6R1w+6HZxeaH2A1uV3Up5sE7NZWA6T4El1I/30uAXnZqFQuGFYdVmwM0klSREBsI+HCSfmhtrOpDMdvMsll2DfRAp+4nyoLqAzy2mO7IfN1FzVN8mQ08+1qfI61iauynuVyi+ATprHcNwsKrMPuD6OOpzFq/xkDx7jA4RZ8lWdBx9aNSQZF895LWSmRfSS3NeSweUn6sNXcsAyD//Tzj+Q0gPTRap4sQmuoP9qqrlQJ1z+SLRKqP+H2Y/twf5lAfqNe3Po49aiLMznW5ht+41G/AFcTbhUKQAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39860400002)(346002)(53546011)(9686003)(6506007)(7416002)(316002)(55016002)(2906002)(16526019)(1076003)(8936002)(186003)(8676002)(6916009)(478600001)(66556008)(83380400001)(33656002)(86362001)(66476007)(6666004)(52116002)(15650500001)(5660300002)(7696005)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: CFL6Kreatb17RVvmwUeRVyOPCcGIsh4mAFZU6tl7dzZD9plGce58h5AAkIXUdjICyt4FNUz+Gxl06ySG3xOWb7A5R2r2LGuoFOMCxfYLEqqpfD7Zje3cpbO9Dz3Fka+26z+6dI1LhaK02mTfsoJnUn0+serp9bnn1UrRB5PBedw1rsC9MFHIWExkUsmQg3zKIwVHT74Ao+Jqwfp7R198WvlXT89tHW0Eq2bVby7raiSmeE+fjvidV79QEJnUbfMlFlF7fLA1gZWFXcuGtlw0RphgxmlgoVO6gwPzPeicfZfv5e5ZWZxvUx07mDp2B8/OcqCRROPcxKgxw9O0WZLeaJ6i8iERIZBYitaS8726p0AU2QdGX9ueP99h9v10tdTS+u6/zC/0aPUNbGZ1JD8Ybe7NYlmJq/Fw1gO1PksNGqquyuhZeYJ0mAFn92WdrBoLB2XsaC/hlpGrMbszBOJ4AcKuZhUV9JYoy6p19SoTOBSKC8YP2Csbz5mc0KEDrKvaKEm1dug32gLssH4NZkryFES8Miju7MjDpE/DsrBv/s02DaZpQZSR6sfHg5af7VjGRQ/eUGyrDEywD+jw9lWRTe5/eOBw2yoBR6SVUvfOg02f6/56mlic62KXhyBe6fMqHnh7XUbhqm4zykc52pGCbj6HV5x4i6bM54INx6wj/++/NogB37a2Z0MyUc2kr3OSYELe6Gbd30Rk775mDqMguyQWGlLo8bdg3ccC38tTGt38zMppW00uOB2q+vJJDGQH9M9BnhbyWCU5+TH68uAckSgPTsT3XOZApu+8cvCjdNLrA5lwWU40c599rzz1I29Vwf4DOu/wuURPDbJHGlv/9X/0bsAJlmFUzO0oZ1rn6wQ1KU4r3zGhJTpCN5+BXkeGNTufNq70i8+LQDQAx6+BsyCL8B0rzpMj04o9Sg/lVNc=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b424f6-8b1b-48b4-a56b-08d891b32f9e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 02:30:05.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYDXIRv/SqvWc2MM2O3JgP8//y7Bx7PbiPgmgDoQKWBee5COkaFTrS/cai+TO/UO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3524
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-25_14:2020-11-25,2020-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=5 spamscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 01:21:41AM +0100, Daniel Borkmann wrote:
> On 11/25/20 4:00 AM, Roman Gushchin wrote:
> > In the absolute majority of cases if a process is making a kernel
> > allocation, it's memory cgroup is getting charged.
> > 
> > Bpf maps can be updated from an interrupt context and in such
> > case there is no process which can be charged. It makes the memory
> > accounting of bpf maps non-trivial.
> > 
> > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> > memcg accounting from interrupt contexts") and b87d8cefe43c
> > ("mm, memcg: rework remote charging API to support nesting")
> > it's finally possible.
> > 
> > To do it, a pointer to the memory cgroup of the process, which created
> > the map, is saved, and this cgroup can be charged for all allocations
> > made from an interrupt context. This commit introduces 2 helpers:
> > bpf_map_kmalloc_node() and bpf_map_alloc_percpu(). They can be used in
> > the bpf code for accounted memory allocations, both in the process and
> > interrupt contexts. In the interrupt context they're using the saved
> > memory cgroup, otherwise the current cgroup is getting charged.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> 
> Thanks for updating the cover letter; replying in this series instead
> on one more item that came to mind:
> 
> [...]
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index f3fe9f53f93c..4154c616788c 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -31,6 +31,8 @@
> >   #include <linux/poll.h>
> >   #include <linux/bpf-netns.h>
> >   #include <linux/rcupdate_trace.h>
> > +#include <linux/memcontrol.h>
> > +#include <linux/sched/mm.h>
> >   #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> >   			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> > @@ -456,6 +458,77 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
> >   		__release(&map_idr_lock);
> >   }
> > +#ifdef CONFIG_MEMCG_KMEM
> > +static void bpf_map_save_memcg(struct bpf_map *map)
> > +{
> > +	map->memcg = get_mem_cgroup_from_mm(current->mm);
> > +}
> > +
> > +static void bpf_map_release_memcg(struct bpf_map *map)
> > +{
> > +	mem_cgroup_put(map->memcg);
> > +}
> > +
> > +void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
> > +			   int node)
> > +{
> > +	struct mem_cgroup *old_memcg;
> > +	bool in_interrupt;
> > +	void *ptr;
> > +
> > +	/*
> > +	 * If the memory allocation is performed from an interrupt context,
> > +	 * the memory cgroup to charge can't be determined from the context
> > +	 * of the current task. Instead, we charge the memory cgroup, which
> > +	 * contained the process created the map.
> > +	 */
> > +	in_interrupt = in_interrupt();
> > +	if (in_interrupt)
> > +		old_memcg = set_active_memcg(map->memcg);
> > +
> > +	ptr = kmalloc_node(size, flags, node);
> > +
> > +	if (in_interrupt)
> > +		set_active_memcg(old_memcg);
> > +
> > +	return ptr;
> > +}
> > +
> > +void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
> > +				    size_t align, gfp_t gfp)
> > +{
> > +	struct mem_cgroup *old_memcg;
> > +	bool in_interrupt;
> > +	void *ptr;
> > +
> > +	/*
> > +	 * If the memory allocation is performed from an interrupt context,
> > +	 * the memory cgroup to charge can't be determined from the context
> > +	 * of the current task. Instead, we charge the memory cgroup, which
> > +	 * contained the process created the map.
> > +	 */
> > +	in_interrupt = in_interrupt();
> > +	if (in_interrupt)
> > +		old_memcg = set_active_memcg(map->memcg);
> > +
> > +	ptr = __alloc_percpu_gfp(size, align, gfp);
> > +
> > +	if (in_interrupt)
> > +		set_active_memcg(old_memcg);
> 
> For this and above bpf_map_kmalloc_node() one, wouldn't it make more sense to
> perform the temporary memcg unconditionally?
> 
> 	old_memcg = set_active_memcg(map->memcg);
> 	ptr = kmalloc_node(size, flags, node);
> 	set_active_memcg(old_memcg);
> 
> I think the semantics are otherwise a bit weird and the charging unpredictable;
> this way it would /always/ be accounted against the prog in the memcg that
> originally created the map.
> 
> E.g. maps could be shared between progs attached to, say, XDP/tc where in_interrupt()
> holds true with progs attached to skb-cgroup/egress where we're still in process
> context. So some part of the memory is charged against the original map's memcg and
> some other part against the current process' memcg which seems odd, no? Or, for example,
> if we start to run a tracing BPF prog which updates state in a BPF map ... that tracing
> prog now interferes with processes in other memcgs which may not be intentional & could
> lead to potential failures there as opposed when the tracing prog is not run. My concern
> is that the semantics are not quite clear and behavior unpredictable compared to always
> charging against map->memcg.
> 
> Similarly, what if an orchestration prog creates dedicated memcg(s) for maps with
> individual limits ... the assumed behavior (imho) would be that whatever memory is
> accounted on the map it can be accurately retrieved from there & similarly limits
> enforced, no? It seems that would not be the case currently.
> 
> Thoughts?

I did consider this option. There are pros and cons. In general we tend to charge the cgroup
which actually allocates the memory, and I decided to stick with this rule. I agree, it's fairly
easy to come with arguments why always charging the map creator is better. The opposite is
also true: it's not clear why bpf is different here. So I'm fine with both options, if there
is a wide consensus, I'm happy to switch to the other option. In general, I believe that
the current scheme is more flexible: if someone want to pay in advance, they are free to preallocate
the map. Otherwise it's up to whoever wants to populate it.

Thanks!
