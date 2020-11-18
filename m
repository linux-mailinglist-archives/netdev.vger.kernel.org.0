Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB922B82C8
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgKRRP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:15:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53830 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726444AbgKRRP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:15:57 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AIHASTr024091;
        Wed, 18 Nov 2020 09:15:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AAKgzx+Om70wgYr2W43I9hm6kQvoIWfTMhopqdNS0p8=;
 b=YmTKyPDAYCYWwWAzMKuvlyv2z3nuEJ1Ar4EOSRWslD2wNkJ6VuhjZxSq5TUj2zEWa+3y
 sjnI49JceHnpd0Tf4+g2PIYQ1NtzXlCOtSZegg9/SW1hXoCLtAf2d5DEFhjRKHWNeXVc
 FFNbm2VO1PYLJcksO8sKbVzfwFSms/QDMSU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhky001b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 09:15:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 18 Nov 2020 09:15:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTQaHrdvd4/AJlRzbfwgYkoGKkCwlpw/BmbzJgHu3HMHgV8mXW9tsuOLeN48CMEaYyWA7rriNGtX/gguTZo2Q81BBSh9sIVJd4RR4DToQgHCrn/23mui84iHAjO9QzSxWXtThVPH/38pdjMfU/81+owfAsXcu0CSK2sLXpCYH7coooAefp4U/XfJTT8mDAVQ5Hu9qkQ8GRK/LxIk6NHc1EUAEM6NpxmSb+3pj3PUp5OjE5O4pYoQQu+Z0TNuI/geUsP0/A4DcgbvNR9sFuh9eTPojpS0h10jOK6fhzl2Phn6+GOkSu1yXlWEs5fwCBfDuMPy2efT0Op9/LcnAtWdzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAKgzx+Om70wgYr2W43I9hm6kQvoIWfTMhopqdNS0p8=;
 b=VQhWt8PRHHCtgobKcoRIoCTZyVJzsnVmCRZt67w1/xAzYjJMC/zH6xvbUHsIVZKusjfCq5sOw7tLjllFBemCMqGKmguZEC3Hc4LhPgTge7Y9jkmddP6NjM3PlvcnxHtJ/bvDpyUHOVbGCv5ovEMuAIavMzg8/5mfbkXrx8EM+mi88eFEIJOzdG9S0y/umlWmTikZZvBWx7ZmYT99v5jWi98pJgbvd3K6rn7HsiyphPm+O6YZNphDSR7b/I0n7OcF0ONgxciN587AuvhlA0UbFE4hTcLyzTbzRw+5fB7Mlm/fKMp4p5vJXcSMyKxQtCV2rFlNOLW0Po789MpNuhfaog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAKgzx+Om70wgYr2W43I9hm6kQvoIWfTMhopqdNS0p8=;
 b=FT5spwzR9Muw6MgXK3RRWUairkusWAOW0dW4/Npsb0j/jVe1mxtaYewZ+Sqg5h0mMvk4qGvDAXff7//zBMf31v6R6pABuQCi/Ijkb0iJdjTasfQ0YeDpzRcIoz99bTNiS/wOyGqZd3wQmpaLD0dGpW2KnWZ3N9CkMCvde0mjaO8=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2279.namprd15.prod.outlook.com (2603:10b6:a02:85::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 17:15:18 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%7]) with mapi id 15.20.3589.021; Wed, 18 Nov 2020
 17:15:18 +0000
Date:   Wed, 18 Nov 2020 09:15:13 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201118171513.GB186396@carbon.dhcp.thefacebook.com>
References: <20201117034108.1186569-1-guro@fb.com>
 <20201117034108.1186569-7-guro@fb.com>
 <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
 <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
 <20201118010703.GC156448@carbon.DHCP.thefacebook.com>
 <CAADnVQ+vSLfgVCXB7KnXMBzVe3rL20qLwrKf=xrJXpZTmUEnYA@mail.gmail.com>
 <20201118012841.GA186396@carbon.dhcp.thefacebook.com>
 <43c845d6-ea33-0d9d-98bb-e743af4940a3@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43c845d6-ea33-0d9d-98bb-e743af4940a3@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:4d1a]
X-ClientProxiedBy: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:4d1a) by MWHPR12CA0059.namprd12.prod.outlook.com (2603:10b6:300:103::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 17:15:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 700abe82-c946-4f02-3a3f-08d88be585c9
X-MS-TrafficTypeDiagnostic: BYAPR15MB2279:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB227950AA41868C50DF741E22BEE10@BYAPR15MB2279.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezw2CjYKGQGhTdiWtZArp96sfoU0COkjXUGdbZ5BZwOw2O/gPw9WG5c7TfL6NMnktUnZUmIxzoJBgNiDH/clumZDs6f5vPejPBUxxW+lcekTjpsBi0cTIfC1C/hYITheZrHxwDPe5SofvdXM+I1YCJ1D8W0tDuQg4CWd0pDqm3gUsnJykcJagnjDFmiw0Nh4ElwLabGERzy/7mweM7KK1ZUyEBixh98cMruhBpZQA9R5lw96k5v1NYOopGCP04sX9/CaEsVqld0+SqCW43hUb/DpaiS4cqMqRnIwmEvUUWHT4MRrJ8PBLV/CqZbG7tONnkbnPSqn78WNgfA+g7dVEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39860400002)(396003)(7416002)(316002)(1076003)(9686003)(53546011)(8676002)(6916009)(186003)(478600001)(8936002)(55016002)(52116002)(16526019)(7696005)(4326008)(83380400001)(86362001)(2906002)(54906003)(6666004)(5660300002)(66556008)(66946007)(6506007)(15650500001)(66476007)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 38CLe1m4+Rq4VYzc2hF328/w/rzcEA+psBWzw17PmD+2eCBy3XgJqZtLwITmC9oCW4G9D+WN53BTiX0WTulHNtkxUJvL3K4HldQmc0Eo+4gTcuMCJorJpjZUwVzOt+8TK9EeYD7pLvO0mBV3vj5R+ZN5zrP1DVy/k0EHrK4GNR0RWx4VkNGfDBXBt/5KYJygaNYEzmUuCevAjovQ7z4s81MdwHjvO8cYPRp9JnXgZGJ9QTeMRt+6S1OugyWGs++k+ZJqukI40egpIbOppL9//2NIy7aKWjvp03sxwP0fK/HT/+4II9lg33BU708v4Y0Hr3wXV2LL6Nltln9nfMd4eTCUJODtGY3Y7FNRvqEbQ5udyONIC8VPeImGotOkIVP1Q+Nryl5vPZHa76EeNP410UohNmQgWVrUZbpAT8DLUPz/wf6QFL1zSDPwELxDKfCq+LA+wB5SLtTzxnRiKX0+ezqKekTpmQ6c+FYEito5aGp91Hs/16KlGQSTB5TQwh1/U0exyVYO/av0kZhEB0hjY2MGxvc1oqjBLYyokx+TlBzNhqOnBSvCoZoYBu3ZAVYG8udY24H5/EW42y/UMbSDbVFmULQD7VTJK0uyr8bYCueEqeZ5dbswr4435rw8EMoDFennetbeIRNQ5yl7/6BSip1XKskB71vZ5GuuZzavKn0=
X-MS-Exchange-CrossTenant-Network-Message-Id: 700abe82-c946-4f02-3a3f-08d88be585c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 17:15:18.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CziFVqpMkbs6TTNa8mM3wzWVmjJMvIbZC03FyercskepY3JlgtrqD9B2NDLUX2s+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2279
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_06:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:22:55AM +0100, Daniel Borkmann wrote:
> On 11/18/20 2:28 AM, Roman Gushchin wrote:
> > On Tue, Nov 17, 2020 at 05:11:00PM -0800, Alexei Starovoitov wrote:
> > > On Tue, Nov 17, 2020 at 5:07 PM Roman Gushchin <guro@fb.com> wrote:
> > > > On Tue, Nov 17, 2020 at 04:46:34PM -0800, Roman Gushchin wrote:
> > > > > On Wed, Nov 18, 2020 at 01:06:17AM +0100, Daniel Borkmann wrote:
> > > > > > On 11/17/20 4:40 AM, Roman Gushchin wrote:
> > > > > > > In the absolute majority of cases if a process is making a kernel
> > > > > > > allocation, it's memory cgroup is getting charged.
> > > > > > > 
> > > > > > > Bpf maps can be updated from an interrupt context and in such
> > > > > > > case there is no process which can be charged. It makes the memory
> > > > > > > accounting of bpf maps non-trivial.
> > > > > > > 
> > > > > > > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> > > > > > > memcg accounting from interrupt contexts") and b87d8cefe43c
> > > > > > > ("mm, memcg: rework remote charging API to support nesting")
> > > > > > > it's finally possible.
> > > > > > > 
> > > > > > > To do it, a pointer to the memory cgroup of the process which created
> > > > > > > the map is saved, and this cgroup is getting charged for all
> > > > > > > allocations made from an interrupt context.
> > > > > > > 
> > > > > > > Allocations made from a process context will be accounted in a usual way.
> > > > > > > 
> > > > > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > > > [...]
> > > > > > > +#ifdef CONFIG_MEMCG_KMEM
> > > > > > > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > > > > > > +                                          void *value, u64 flags)
> > > > > > > +{
> > > > > > > + struct mem_cgroup *old_memcg;
> > > > > > > + bool in_interrupt;
> > > > > > > + int ret;
> > > > > > > +
> > > > > > > + /*
> > > > > > > +  * If update from an interrupt context results in a memory allocation,
> > > > > > > +  * the memory cgroup to charge can't be determined from the context
> > > > > > > +  * of the current task. Instead, we charge the memory cgroup, which
> > > > > > > +  * contained a process created the map.
> > > > > > > +  */
> > > > > > > + in_interrupt = in_interrupt();
> > > > > > > + if (in_interrupt)
> > > > > > > +         old_memcg = set_active_memcg(map->memcg);
> > > > > > > +
> > > > > > > + ret = map->ops->map_update_elem(map, key, value, flags);
> > > > > > > +
> > > > > > > + if (in_interrupt)
> > > > > > > +         set_active_memcg(old_memcg);
> > > > > > > +
> > > > > > > + return ret;
> > > > > > 
> > > > > > Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
> > > > > > retpoline for lookup/update/delete calls on maps") which removes the indirect
> > > > > > call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
> > > > > > not invoked for the vast majority of cases.
> > > > > 
> > > > > I see. Well, the first option is to move these calls into map-specific update
> > > > > functions, but the list is relatively long:
> > > > >    nsim_map_update_elem()
> > > > >    cgroup_storage_update_elem()
> > > > >    htab_map_update_elem()
> > > > >    htab_percpu_map_update_elem()
> > > > >    dev_map_update_elem()
> > > > >    dev_map_hash_update_elem()
> > > > >    trie_update_elem()
> > > > >    cpu_map_update_elem()
> > > > >    bpf_pid_task_storage_update_elem()
> > > > >    bpf_fd_inode_storage_update_elem()
> > > > >    bpf_fd_sk_storage_update_elem()
> > > > >    sock_map_update_elem()
> > > > >    xsk_map_update_elem()
> > > > > 
> > > > > Alternatively, we can set the active memcg for the whole duration of bpf
> > > > > execution. It's simpler, but will add some overhead. Maybe we can somehow
> > > > > mark programs calling into update helpers and skip all others?
> > > > 
> > > > Actually, this is problematic if a program updates several maps, because
> > > > in theory they can belong to different cgroups.
> > > > So it seems that the first option is the way to go. Do you agree?
> > > 
> > > May be instead of kmalloc_node() that is used by most of the map updates
> > > introduce bpf_map_kmalloc_node() that takes a map pointer as an argument?
> > > And do set_memcg inside?
> > 
> > I suspect it's not only kmalloc_node(), but if there will be 2-3 allocation
> > helpers, it sounds like a good idea to me! I'll try and get back with v7 soon.
> 
> Could this be baked into kmalloc*() API itself given we also need to pass in
> __GFP_ACCOUNT everywhere, so we'd have a new API with additional argument where
> we pass the memcg pointer to tell it directly where to account it for instead of
> having to have the extra set_active_memcg() set/restore dance via BPF wrapper?
> It seems there would be not much specifics on BPF itself and if it's more generic
> it could also be used by other subsystems.

Actually BPF is the first example of the kernel memory accounting from an interrupt
context. There are few examples where we do an indirect charging (charging an arbitrary
memory cgroup, not the current one), but not so many. And usually it's easier to
wrap everything into set_active_memcg(), rather than pass a memcg argument into every
function which can do a memory allocation. Also, in !CONFIG_MEMCG or !CONFIG_MEMCG_KMEM
it's easy to compile out set_active_memcg() and everything memcg-related, but not
easy to remove a memcg argument from many functions all over the code.

In this particular case the only reason why it's not easy to wrap everything into
set_active_memcg() pair is the function call "inlining", which is very bpf-specific.

So as now I'd go with what Alexei suggested.

Thanks!
