Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135252C5900
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391469AbgKZQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:06:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55942 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730181AbgKZQGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 11:06:34 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQG4vdX022985;
        Thu, 26 Nov 2020 08:06:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=oyfSKBtaxUJCMyWi6VEkQjB8CrGUNIEFtUHzS1TxS4o=;
 b=fy/PnPhAeWSkQUosLCozIoQDA3u7VS0AtspY8zVnWsRvnXdGgl5K5wBapfTwvW+We2wF
 Tdt7BmwLvN3VTmEU55daBDRHFtnpLmtk4p6yPlIXxVa4E9igDWl1pduxLVR9HC8nbvmS
 UKpSCmNM4zCDcdlICMKIxTVxmylFPKwwj9U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 351qwdedvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Nov 2020 08:06:14 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 26 Nov 2020 08:06:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PswujZYaKt6S9gp27I6npgeG8rFkJWKnRfz0z8I1czcwG6y2Pjh7MHoXX2enJrZvER+h3GuQcacPlB+S1qXuF/YpbfAlPLk16AydKu8o+dfotOHZtZs7f1RU/+ZN7JOJUAolvE0kF5RX6Y7fOKp0lr/7C6Do0AoVA/4iEbD/fFmuiWcPGSs7Jw9ID+kvBOsyY1EVd2iAvwDjfopO+ht9Ir8U5hJU1lmYk1lPMmUzLqXUZFkpd34JY2guLdFAMtMKSMfhNM5RdmYL1MReqhcPzXnPDWuDROFhG/pbxsLCV1v3R2U7f2+5BdM42tRpx7qt3zRdS9GgQsV9QsBOOB4trA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1WNIdtvvcPAnXV1JhEvJg5BwlyUkFkUH2BfHaXrzjo=;
 b=YOe3GSgb/SFd7r6DNim1k/Xbng92piL/5m1wbS8HvUP74KkD32vZ7Hv5KoSDW4S10oY/AhbwLZTAbw55Na/HFu+kz5Fh/FCVsuG0GHW+LkebIpn5+j9xE4XaySDXsGuHE/40HdnRNzrBdwy2tcWudPPUKPvsXNgwZHePHjVz8A0fa1ZG5AzE7+zfXqaa8KYclDhv+JOKUv/JOXFQ+XMhwooFRCEC0rnyeP22SJbvcIOkcTTBcsnwbsyFX7K3PWunE1B9UVoOUIJyBhYrtSiQKsOoH/Gg7/rXgikGXnpwlm6xi8vzDqYpzgr9OLXGP9bQQ/B54lI55FihYZ3GHQP+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1WNIdtvvcPAnXV1JhEvJg5BwlyUkFkUH2BfHaXrzjo=;
 b=DC1OfcacHZdRY1vFrQFNikbhOy8yXkPjERwkdBzlI+W5somneWqtOymlUoJiZeRW1Uvlkr5MNnhPejXJWGIJD9eDkLYvcrKT1NRGRiaO3+fCGPBj1v7V5O+dHrNYYSS9HboLijxe7LktRgwNU/YxBGZEQzgUmI9g/cwC42U+gb0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SA0PR15MB3901.namprd15.prod.outlook.com
 (2603:10b6:806:8f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Thu, 26 Nov
 2020 16:06:11 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::f966:8c42:dcc0:7d96%5]) with mapi id 15.20.3589.025; Thu, 26 Nov 2020
 16:06:11 +0000
Date:   Thu, 26 Nov 2020 08:06:05 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <netdev@vger.kernel.org>, <andrii@kernel.org>,
        <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <hannes@cmpxchg.org>, <tj@kernel.org>
Subject: Re: [PATCH bpf-next v8 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201126160605.GC840171@carbon.dhcp.thefacebook.com>
References: <20201125030119.2864302-1-guro@fb.com>
 <20201125030119.2864302-7-guro@fb.com>
 <ef140167-8d80-c581-318c-36c0430e4cfa@iogearbox.net>
 <20201126023000.GB840171@carbon.dhcp.thefacebook.com>
 <87lfeol9vn.fsf@toke.dk>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfeol9vn.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:88d6]
X-ClientProxiedBy: MW2PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:907:1::17) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:88d6) by MW2PR16CA0040.namprd16.prod.outlook.com (2603:10b6:907:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Thu, 26 Nov 2020 16:06:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28f124c0-2360-4924-9b69-08d89225311f
X-MS-TrafficTypeDiagnostic: SA0PR15MB3901:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3901CAE41C2258279FA7A2A9BEF90@SA0PR15MB3901.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8KZft5iwCnan7RTPH0hsFtAasKgcOlMs3UKAN/gc6yAZH6O5TTxdU4zPghhT7iv2AGYBFuEHJycvC9lyHUoGZtO9g71Hc5wyWRhzE4Ca6TvTsA6DRrPYqu4M6zcOZspCwqwYWdz2RdD2tWphdv9n1+zAVu1cS10mG0hUDT1XprIUXyKaQ2aUBmasVdphKvmDe/1tSTbiC5tdoMCTmMMps6M/kpgel1Gf1kU8176jfJ33HSO4t/kOHTBYV/eVqko5mMvmvN1oCuMLmtSQDvZnZmPu9+mV+PQae2XeyWV4YUz4On+lS9VK8GyNeK3RhQNtq2MHOz3zMmIPKgFX/Yk+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(2906002)(9686003)(55016002)(316002)(1076003)(66574015)(86362001)(83380400001)(66476007)(66556008)(33656002)(66946007)(478600001)(6666004)(5660300002)(186003)(6916009)(7696005)(16526019)(52116002)(4326008)(7416002)(15650500001)(8936002)(8676002)(53546011)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?BPs4PUsy6AEyiL8hTwuFgt82fEqqW4S83LE/wsUlYXgqMG2yoaxA4TIBzx?=
 =?iso-8859-1?Q?GxOyd1XaCtKxWKCD7SgetkMqy4RBawDlnXBt0Ca9ORZhX3RNMUvJhgLvc1?=
 =?iso-8859-1?Q?SJmoEilY7VNgroOGDbsQ8ObKZN2sUibDgkYqZlokvs3tSAE3IDwJ3u4qxg?=
 =?iso-8859-1?Q?bX0ZUd1zCaAxf3JR+EC9UiXC1CEd3oghRP3sGSh6YstW7z72Cag0FXFxOL?=
 =?iso-8859-1?Q?y+1tKADHKkk42k5LP+w7kq4aSEkkKYqsbuhVB7W3S+4DkveGaqnRF9fur1?=
 =?iso-8859-1?Q?UU/7Tg4D4mR8CcB1LWegboLympHfjzh/CuTX7Q95BYyYPsLf+iQuk4eUU2?=
 =?iso-8859-1?Q?IZmcq7+M4c27fLmYaINNSmMNp/H47hkM914tUr4PSTcfdFEe9Sa+iCZlmz?=
 =?iso-8859-1?Q?8BtyhklH2Ym+wD5uJir08ULF8fe2EYShk28mvGsXRYjuEt+LRUAtRFFsie?=
 =?iso-8859-1?Q?w5oBJFqmicuL/2H6ee1UgcdwsaOsG2P5JwZaF0S3FKDp0cMaj4tIBkPYy4?=
 =?iso-8859-1?Q?CaCcG03YhNf1jvReEey7AtxDvn7cFqgv7gY5eI3JLvGMjklXhOgPEulE6B?=
 =?iso-8859-1?Q?uv4nePoBnRB/PMyB/miUgVDDoTlEZ7++IZ+O2dbz4PQBLupmTUmQ577CKx?=
 =?iso-8859-1?Q?+qQ5SVq6bC4GYcGHqMJPFeuQ95NFfkUHNZktoH3636jGP5iShqBd2pUX+0?=
 =?iso-8859-1?Q?+Gyjt2FWfgKpDDc1iL07WQSAILwZaQoiqnlzMgpIC2QJ2wSAJaFqNWQo4y?=
 =?iso-8859-1?Q?/UGOKi3/4ckKjgbpUZT3Mzw5X8VysLDUiKsqv6HRi7Otl6PPzZprZ5T1HK?=
 =?iso-8859-1?Q?dwbjVSfj0drQHcrNq2sc9BQmdEmeaBt4jiuB/ZhhYe5NWZDFGXgvAiPeTK?=
 =?iso-8859-1?Q?BbkZOYqswnlvr+gS+m/w1xS0KNOM1JC/0SfFuo5yVwIeQSw+Lb3PxGvLce?=
 =?iso-8859-1?Q?72udukEbhvWGQjcZ5FU7bsYnlA3Py/wjnx+rrcU/k7wqEu1YvRbEYr6GvB?=
 =?iso-8859-1?Q?faKz6AHeo08pwp4C7gcmgUGsXEIRqN+JwjOLZvoNwHQfh2jNZJO7tebAjB?=
 =?iso-8859-1?Q?sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f124c0-2360-4924-9b69-08d89225311f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB4141.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2020 16:06:11.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1kgz/QRCHEYBvs8RquEAjrC/4DfB4n07pnDoCUJfYjaAUgJQB38Vy4Y639jznHnH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3901
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_06:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0 suspectscore=5
 malwarescore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 10:56:12AM +0100, Toke Høiland-Jørgensen wrote:
> Roman Gushchin <guro@fb.com> writes:
> 
> > On Thu, Nov 26, 2020 at 01:21:41AM +0100, Daniel Borkmann wrote:
> >> On 11/25/20 4:00 AM, Roman Gushchin wrote:
> >> > In the absolute majority of cases if a process is making a kernel
> >> > allocation, it's memory cgroup is getting charged.
> >> > 
> >> > Bpf maps can be updated from an interrupt context and in such
> >> > case there is no process which can be charged. It makes the memory
> >> > accounting of bpf maps non-trivial.
> >> > 
> >> > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> >> > memcg accounting from interrupt contexts") and b87d8cefe43c
> >> > ("mm, memcg: rework remote charging API to support nesting")
> >> > it's finally possible.
> >> > 
> >> > To do it, a pointer to the memory cgroup of the process, which created
> >> > the map, is saved, and this cgroup can be charged for all allocations
> >> > made from an interrupt context. This commit introduces 2 helpers:
> >> > bpf_map_kmalloc_node() and bpf_map_alloc_percpu(). They can be used in
> >> > the bpf code for accounted memory allocations, both in the process and
> >> > interrupt contexts. In the interrupt context they're using the saved
> >> > memory cgroup, otherwise the current cgroup is getting charged.
> >> > 
> >> > Signed-off-by: Roman Gushchin <guro@fb.com>
> >> 
> >> Thanks for updating the cover letter; replying in this series instead
> >> on one more item that came to mind:
> >> 
> >> [...]
> >> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> > index f3fe9f53f93c..4154c616788c 100644
> >> > --- a/kernel/bpf/syscall.c
> >> > +++ b/kernel/bpf/syscall.c
> >> > @@ -31,6 +31,8 @@
> >> >   #include <linux/poll.h>
> >> >   #include <linux/bpf-netns.h>
> >> >   #include <linux/rcupdate_trace.h>
> >> > +#include <linux/memcontrol.h>
> >> > +#include <linux/sched/mm.h>
> >> >   #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> >> >   			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
> >> > @@ -456,6 +458,77 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
> >> >   		__release(&map_idr_lock);
> >> >   }
> >> > +#ifdef CONFIG_MEMCG_KMEM
> >> > +static void bpf_map_save_memcg(struct bpf_map *map)
> >> > +{
> >> > +	map->memcg = get_mem_cgroup_from_mm(current->mm);
> >> > +}
> >> > +
> >> > +static void bpf_map_release_memcg(struct bpf_map *map)
> >> > +{
> >> > +	mem_cgroup_put(map->memcg);
> >> > +}
> >> > +
> >> > +void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
> >> > +			   int node)
> >> > +{
> >> > +	struct mem_cgroup *old_memcg;
> >> > +	bool in_interrupt;
> >> > +	void *ptr;
> >> > +
> >> > +	/*
> >> > +	 * If the memory allocation is performed from an interrupt context,
> >> > +	 * the memory cgroup to charge can't be determined from the context
> >> > +	 * of the current task. Instead, we charge the memory cgroup, which
> >> > +	 * contained the process created the map.
> >> > +	 */
> >> > +	in_interrupt = in_interrupt();
> >> > +	if (in_interrupt)
> >> > +		old_memcg = set_active_memcg(map->memcg);
> >> > +
> >> > +	ptr = kmalloc_node(size, flags, node);
> >> > +
> >> > +	if (in_interrupt)
> >> > +		set_active_memcg(old_memcg);
> >> > +
> >> > +	return ptr;
> >> > +}
> >> > +
> >> > +void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
> >> > +				    size_t align, gfp_t gfp)
> >> > +{
> >> > +	struct mem_cgroup *old_memcg;
> >> > +	bool in_interrupt;
> >> > +	void *ptr;
> >> > +
> >> > +	/*
> >> > +	 * If the memory allocation is performed from an interrupt context,
> >> > +	 * the memory cgroup to charge can't be determined from the context
> >> > +	 * of the current task. Instead, we charge the memory cgroup, which
> >> > +	 * contained the process created the map.
> >> > +	 */
> >> > +	in_interrupt = in_interrupt();
> >> > +	if (in_interrupt)
> >> > +		old_memcg = set_active_memcg(map->memcg);
> >> > +
> >> > +	ptr = __alloc_percpu_gfp(size, align, gfp);
> >> > +
> >> > +	if (in_interrupt)
> >> > +		set_active_memcg(old_memcg);
> >> 
> >> For this and above bpf_map_kmalloc_node() one, wouldn't it make more sense to
> >> perform the temporary memcg unconditionally?
> >> 
> >> 	old_memcg = set_active_memcg(map->memcg);
> >> 	ptr = kmalloc_node(size, flags, node);
> >> 	set_active_memcg(old_memcg);
> >> 
> >> I think the semantics are otherwise a bit weird and the charging unpredictable;
> >> this way it would /always/ be accounted against the prog in the memcg that
> >> originally created the map.
> >> 
> >> E.g. maps could be shared between progs attached to, say, XDP/tc where in_interrupt()
> >> holds true with progs attached to skb-cgroup/egress where we're still in process
> >> context. So some part of the memory is charged against the original map's memcg and
> >> some other part against the current process' memcg which seems odd, no? Or, for example,
> >> if we start to run a tracing BPF prog which updates state in a BPF map ... that tracing
> >> prog now interferes with processes in other memcgs which may not be intentional & could
> >> lead to potential failures there as opposed when the tracing prog is not run. My concern
> >> is that the semantics are not quite clear and behavior unpredictable compared to always
> >> charging against map->memcg.
> >> 
> >> Similarly, what if an orchestration prog creates dedicated memcg(s) for maps with
> >> individual limits ... the assumed behavior (imho) would be that whatever memory is
> >> accounted on the map it can be accurately retrieved from there & similarly limits
> >> enforced, no? It seems that would not be the case currently.
> >> 
> >> Thoughts?
> >
> > I did consider this option. There are pros and cons. In general we
> > tend to charge the cgroup which actually allocates the memory, and I
> > decided to stick with this rule. I agree, it's fairly easy to come
> > with arguments why always charging the map creator is better. The
> > opposite is also true: it's not clear why bpf is different here. So
> > I'm fine with both options, if there is a wide consensus, I'm happy to
> > switch to the other option. In general, I believe that the current
> > scheme is more flexible: if someone want to pay in advance, they are
> > free to preallocate the map. Otherwise it's up to whoever wants to
> > populate it.
> 
> I think I agree with Daniel here: conceptually the memory used by a map
> ought to belong to that map's memcg. I can see how the other scheme can
> be more flexible, but as Daniel points out it seems like it can lead to
> hard-to-debug errors...

Ok, I'll switch to always charging the map's memcg in the next version.

> 
> (Side note: I'm really excited about this work in general! The ulimit
> thing has been a major pain...)

Great! Thanks!
