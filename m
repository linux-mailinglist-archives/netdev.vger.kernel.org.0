Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24172B73C3
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgKRB3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:29:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgKRB3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:29:10 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI1P6NK008791;
        Tue, 17 Nov 2020 17:28:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8XsK0gn9bmUAeuuyz1sSJ/wNfbJleVLFHaarPnFCIcY=;
 b=YDKPD0ZaK0bBpXO1zoQCeQY2rW0GiEFkqfAbeeLbRZ3DW9H1S7M9votQiUgunFUwkwfl
 vUTz8os9GuvJFmNc7MWbV7BIfNNsZAhFpfBHHTFZWQURyBDkG6kUgYWgwSwhm1gMotvP
 k8unwxw8o+d5VXwRO8XYhxbVGW6LsnIN68Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34vhqjb3v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 17:28:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 17:28:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKGJIrzl8FnQ9h9imS23RgUrCcwsOpniyfx4N95icgETyXfYoWHjIGegWMTeMSJFnBIRHWHkcWHI2CPxdvDJliUOCOm1HonXtRw6PFg7Tbx2UiSGZg2C3lSQdr//9DwkAJXhsD2OsARyLo4Hhkh3pyUmjzSdaOps0Wk9kNG37EnekVG44ruBDqOkkWcyf8Q6MtmEZYgLFxbwmuk2e9/Tm+xFtNcpvFAHmEZlx46MeASh8nfMXP65cw2l2YTZ6/wytIL8WYYvCng+x+kuKgdA6oCS6Bu7ktSkaEbbiInYSP120Lp8pJbr5KkpBfxYQyOMpk25sw0m5AB/cUgbAuDjig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XsK0gn9bmUAeuuyz1sSJ/wNfbJleVLFHaarPnFCIcY=;
 b=DAhm0MXW8mIIpb6YxCyVKrZPp/1x68HTVXPZR5EwjYZ9LawaR3h9wC8Bpkd9TTdV1nAYbOdIgvKJ2D6XGME92v+ZTLm1SfXpnhsEtvLDucRiOvejLtkSQuIUHdbNmXJciAZcWft4RCAa/3tKPPe8wfv8HBCtDXrdOcmCV55w6vGG3qlOVdbk+1P1g8SlUZIF0+BITrZNCtGiBWOnLmQULp+Oih3mQRmmvMCINlXyI4TGAwWSI7fmr/yVhZsdL8lUy1QbowcvA4hzrSk2TNrnSCBXduj6ymu/XQ0vGihhFNg181EBfKSyA1T2zSJM004cq3L+x18claEOPOyv9++GrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XsK0gn9bmUAeuuyz1sSJ/wNfbJleVLFHaarPnFCIcY=;
 b=dWv3ohuZphj/0vsOxO8BWLU5DYK6aJ1SApJ5xbMIvEvQclt+fRL2ZigELgwCrAO+543f4gspMzseUTZIMc/1rXPDPLxKk7zFZh8A884MQYEZGm8ARzZswO8k2gqKYj4Bz+MiDAYsP1iDvQLb4MqrEJV8WnV/gfV5D3RZQn/xV28=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3603.namprd15.prod.outlook.com (2603:10b6:a03:1f7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Wed, 18 Nov
 2020 01:28:47 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3564.031; Wed, 18 Nov 2020
 01:28:47 +0000
Date:   Tue, 17 Nov 2020 17:28:41 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201118012841.GA186396@carbon.dhcp.thefacebook.com>
References: <20201117034108.1186569-1-guro@fb.com>
 <20201117034108.1186569-7-guro@fb.com>
 <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
 <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
 <20201118010703.GC156448@carbon.DHCP.thefacebook.com>
 <CAADnVQ+vSLfgVCXB7KnXMBzVe3rL20qLwrKf=xrJXpZTmUEnYA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+vSLfgVCXB7KnXMBzVe3rL20qLwrKf=xrJXpZTmUEnYA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:57cc]
X-ClientProxiedBy: CO2PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:104:6::31) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:57cc) by CO2PR04CA0105.namprd04.prod.outlook.com (2603:10b6:104:6::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 01:28:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51afb830-d163-49ef-9be4-08d88b614ba2
X-MS-TrafficTypeDiagnostic: BY5PR15MB3603:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3603DC405344D398FD701C92BEE10@BY5PR15MB3603.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YyOxayvzol/7YLramS1LxK/VEUhRIY2OKHJpQayJL6PDuJJdHmPZ3GQ/G5PTlF6D9AgZ2252F0piZTrij1V+GF400xnosSKKOM0LciB644qnuv/SOsxuEGxI9oNGYmgSZp5he/kAagmOviyxnTTKb453zhivVTZVN6YHvWr+j9vVfVTc5p3GJJnIGThyDESWE9RWWC/lNc92yETqRqINwkwQGEGM9xSCWaFTBI/7MOqK2ZDth3zvlwO0FLKOwlQg0GCB9IoNEkDxMxdpP3uKVqsvD4pdOVeYgUsJPB6cfJt/+hcMbEJrsBrMmYRz3Ly/OX1a8piMO79260NrUpOifg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(366004)(396003)(52116002)(33656002)(66946007)(4326008)(8676002)(83380400001)(7696005)(2906002)(5660300002)(15650500001)(8936002)(1076003)(186003)(16526019)(6916009)(53546011)(66476007)(66556008)(6506007)(9686003)(6666004)(86362001)(54906003)(478600001)(316002)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6EiUJG/lZBOTfBoWDjh346eCpJKbZkSfxUvahGOmhEnDTLtPwNxv7xRcqEs055xM+xGFnUhRN95rKhk0qAKb4++fuH+Zy94EWz5fB27kH9lXV/yr5Gq7/jexzMi2RpexnI6NU4dA9WJo7FyicEp/Uektimjn4BSIO8QWYqcZaVEi2BXazK/o7O6/neK9/pAr0BdAkn8rjJvbNnqktVjgEQer7NVEpMAXr5OqPoDs2blkz70yPMpHqb4hX4q855+rm8nhQNwB+/TmppB7oK/c3/Oaw8SLonC2ToYViGVc++LmskGk73HTC33zMMer4uUGFsxNF/PEeH9m6JL7I9hjkffwTz+8x3UqYvFOY9u7Ot8dd6CyMUoA5Fh9O63SFA3QaNwQ0cV8huEvvqEBxrXuMV2cgBOLka3oHpHXO6Uadb/BYVyhKGmCLns2UfqCK9dpWCeHAqoHWGzrIRsgrfEM/67EGrGSsRVrE1sVZxogwxZlnVqcd+rw/pKeuXDMI9SFhPF2Wdu90AoCmihC8nRbInPRFhTMLdITIGSqSUD3Q2cp/ltD9Oqwa5hrUpDRr1ffr4Ix00PUK5wp41gO8u5Ix9nG34EAW6e7VJrceSRIffYg//yKrBZEyXhALiIo/eyZs87i4vZGRQxt7BNX5b+YUrTfYf++5r7lfT65irJluyM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51afb830-d163-49ef-9be4-08d88b614ba2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 01:28:47.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLhfRPv+aJmRyPEYk4lgylhY8LGecA4Gv55OZvUma6NgUq3o9QZAXVHPkY5ChmFy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3603
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 05:11:00PM -0800, Alexei Starovoitov wrote:
> On Tue, Nov 17, 2020 at 5:07 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Tue, Nov 17, 2020 at 04:46:34PM -0800, Roman Gushchin wrote:
> > > On Wed, Nov 18, 2020 at 01:06:17AM +0100, Daniel Borkmann wrote:
> > > > On 11/17/20 4:40 AM, Roman Gushchin wrote:
> > > > > In the absolute majority of cases if a process is making a kernel
> > > > > allocation, it's memory cgroup is getting charged.
> > > > >
> > > > > Bpf maps can be updated from an interrupt context and in such
> > > > > case there is no process which can be charged. It makes the memory
> > > > > accounting of bpf maps non-trivial.
> > > > >
> > > > > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> > > > > memcg accounting from interrupt contexts") and b87d8cefe43c
> > > > > ("mm, memcg: rework remote charging API to support nesting")
> > > > > it's finally possible.
> > > > >
> > > > > To do it, a pointer to the memory cgroup of the process which created
> > > > > the map is saved, and this cgroup is getting charged for all
> > > > > allocations made from an interrupt context.
> > > > >
> > > > > Allocations made from a process context will be accounted in a usual way.
> > > > >
> > > > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > > > Acked-by: Song Liu <songliubraving@fb.com>
> > > > [...]
> > > > > +#ifdef CONFIG_MEMCG_KMEM
> > > > > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > > > > +                                          void *value, u64 flags)
> > > > > +{
> > > > > + struct mem_cgroup *old_memcg;
> > > > > + bool in_interrupt;
> > > > > + int ret;
> > > > > +
> > > > > + /*
> > > > > +  * If update from an interrupt context results in a memory allocation,
> > > > > +  * the memory cgroup to charge can't be determined from the context
> > > > > +  * of the current task. Instead, we charge the memory cgroup, which
> > > > > +  * contained a process created the map.
> > > > > +  */
> > > > > + in_interrupt = in_interrupt();
> > > > > + if (in_interrupt)
> > > > > +         old_memcg = set_active_memcg(map->memcg);
> > > > > +
> > > > > + ret = map->ops->map_update_elem(map, key, value, flags);
> > > > > +
> > > > > + if (in_interrupt)
> > > > > +         set_active_memcg(old_memcg);
> > > > > +
> > > > > + return ret;
> > > >
> > > > Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
> > > > retpoline for lookup/update/delete calls on maps") which removes the indirect
> > > > call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
> > > > not invoked for the vast majority of cases.
> > >
> > > I see. Well, the first option is to move these calls into map-specific update
> > > functions, but the list is relatively long:
> > >   nsim_map_update_elem()
> > >   cgroup_storage_update_elem()
> > >   htab_map_update_elem()
> > >   htab_percpu_map_update_elem()
> > >   dev_map_update_elem()
> > >   dev_map_hash_update_elem()
> > >   trie_update_elem()
> > >   cpu_map_update_elem()
> > >   bpf_pid_task_storage_update_elem()
> > >   bpf_fd_inode_storage_update_elem()
> > >   bpf_fd_sk_storage_update_elem()
> > >   sock_map_update_elem()
> > >   xsk_map_update_elem()
> > >
> > > Alternatively, we can set the active memcg for the whole duration of bpf
> > > execution. It's simpler, but will add some overhead. Maybe we can somehow
> > > mark programs calling into update helpers and skip all others?
> >
> > Actually, this is problematic if a program updates several maps, because
> > in theory they can belong to different cgroups.
> > So it seems that the first option is the way to go. Do you agree?
> 
> May be instead of kmalloc_node() that is used by most of the map updates
> introduce bpf_map_kmalloc_node() that takes a map pointer as an argument?
> And do set_memcg inside?

I suspect it's not only kmalloc_node(), but if there will be 2-3 allocation
helpers, it sounds like a good idea to me! I'll try and get back with v7 soon.

Thanks!
