Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE32B737B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgKRBHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:07:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15400 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727155AbgKRBHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:07:33 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI13dU7002813;
        Tue, 17 Nov 2020 17:07:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4kjXE1B/oSFrRG7nl8p2xVS8pgn5M/0Lx8YAuFU9jJg=;
 b=bH+pUfcSBXJduwtrNgha4uhwfC04S/KMyDGAQkCKZFPR1O6mJpUFplrmTDpwNZfnw8Hk
 XUU9Wt0kwLoM434o61VovsHf2inTMs3xzSjsovWzfWh/XJqFYvGflz887+d46jtZRJ//
 gvKrgKCQEohn4cdmFibuoOfFusWGPpbeOQ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34tyxqxv31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 17:07:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 17:07:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUlplhdcBfKEWbVaJUqSmfqJYlIESeusaQSDlsjzasu67c+D8hVuOza432fcR91s9gPuibH2k9qySwQ9ztig4rQoxo9H8oO96lOVY8Kvc6noml3t3RHC9vVMLKwouNoLeGc3G8AV8Avnz1EjGFfHdYjFuXgFrhnG7EA8npCaRc2LspjpWpIEsS+Yk6dwRpNRnjl2D6Amwf9snBKrzCSQ0hY0FFBJXlsovNNa8b/lKF3OOY2WvWGf3MVof9uCF4UbUH07fnUNoaVBgAJ9a0QB3PC+Dummo+CVrpq8YzqpuEYVcqLT6ysgw4DwyyuLTmwMcHBkvzLe1iRphIH3MM6eDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kjXE1B/oSFrRG7nl8p2xVS8pgn5M/0Lx8YAuFU9jJg=;
 b=bnMwC8Kmk5TgyTQmhLwJYEBlWNk6vGoV4F8JTRfxwIeXCJZB5EUAgSaRPS0+stJSF0PlaWcZeDttRc71W10lLF7SrAMONAdNSB6adSZ3/5ce2njYe669RM2VguJi3LvMXWZnKLDzGTBSte9DAgpC4GEkZjXmS6qAfsErVSa7SpLYoei7obww3/B88UumMHQshe3WRoIcVUG3JXPNicjJUmgXPfoV2pG0PJhV1sdq+7NfbuU+CbPhH2Up/c0m1epbvS3FzDdM7WVOQchO8tP2dLJZsS/XcEsd3C6Bx9egD1LtJJrfa+t3xICas4akIyx/8ljWHPca5Wwra1a/cSaqAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kjXE1B/oSFrRG7nl8p2xVS8pgn5M/0Lx8YAuFU9jJg=;
 b=EuvdgOM7eqvke38lL9U32BaYWWVc+TO32YIcD77XLD2XicwNwiHeZ5oEBSLIldR4fEmGKai92owLhFUdvAculcjvfWAUSX+UoXfWGTEGSx71VShfRoy90FLCa0RqGBgThLPEQ8JvL9GTe3rjnxxcY9PvQ8fUhIyADyDv8WTNHaQ=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2598.namprd15.prod.outlook.com (2603:10b6:a03:14d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 01:07:13 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3564.031; Wed, 18 Nov 2020
 01:07:13 +0000
Date:   Tue, 17 Nov 2020 17:07:03 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v6 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
Message-ID: <20201118010703.GC156448@carbon.DHCP.thefacebook.com>
References: <20201117034108.1186569-1-guro@fb.com>
 <20201117034108.1186569-7-guro@fb.com>
 <41eb5e5b-e651-4cb3-a6ea-9ff6b8aa41fb@iogearbox.net>
 <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118004634.GA179309@carbon.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:d0f1]
X-ClientProxiedBy: MW4PR03CA0387.namprd03.prod.outlook.com
 (2603:10b6:303:114::32) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:d0f1) by MW4PR03CA0387.namprd03.prod.outlook.com (2603:10b6:303:114::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Wed, 18 Nov 2020 01:07:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06d4d3c8-087c-490a-c34c-08d88b5e4875
X-MS-TrafficTypeDiagnostic: BYAPR15MB2598:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB259887E39377625C896D459CBEE10@BYAPR15MB2598.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6BTzbODR6eEGV5uke5zgw/IaLmqoJsWmr3cH/cQkwcv5VJlb69n+9l2QBHOxZOmxPwB2H/PP4cZLwr165Jrfx/4cI8VRGMYnTHOTDirP43mpmQC0W55APMLNEKK87kmdcOcOtuqYfX99vsNGfinxkAlBgclgZMEuTFWRt2Zb8dxR1kRgAtfMcE8eSiZKFdPaGLdMzsnHACJbEps/zzqjPjOVdGQkKdPuVZZ6slLVn0GkH2aXdR+G0WdoMczky3msP30Vw7RQKl/Q2but9gmIWeG0QT9U2PJmWfc9t1OGaC5YFFFV4zrhtl/XCorO7bqBX4TKb7U/uQRngSXpNkftA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(396003)(366004)(346002)(86362001)(5660300002)(478600001)(8676002)(186003)(52116002)(316002)(16526019)(33656002)(8936002)(83380400001)(66476007)(66556008)(6666004)(7696005)(4326008)(53546011)(6916009)(6506007)(1076003)(15650500001)(2906002)(55016002)(66946007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4o2XxKvDe8nM/csrXiMrYhClo3HtEu7bXNfJYHY3zlwVJZrCgW4fbkcHA70V/3vsCIdC0NfaYTi806foNbSaSRl2PSzzH7q5wbUzwv+BJ+SlIWpAPlhiRqYfokuvvmVvXq6Iy5WzFa3zpQ2ep1f1f6Q43wc5z7I/kBBGXP/yUa3yTUZiawgOuf64nVLPocxDd/vq3csxktx40tPDSw6R3uKsKIvE9rEQeTCkt4nDP8ojWrRGcFoINyYMomQDsAEty9AkV3MW+fCR8IZlNdryGgvgzi4LHRxSyMFFYvLEmG2YhWEkXo8g1Hgmm2Jr0EN54fE6gToPOeW9kfEgmEXO7v0YAa4ZrxJ/3H3IE+tEVnacU8WRsG0t9dIeO8iWfqGKca0bWziIxPHWkGZq6VNIrsrjWU4NHnEMKkMZpltksN5rZXsDS3PnIZ6i8n1Rjmx+6k7e8GDJ/YMJ94gOd7Oraie3oy17/4WRpNdO0CNkWe9m7Tg/Mm/PcXrgJdTZt1jqwpsABaCdD8vwgopWefLXmhX3ksssvWJk3vfui89RhYFEFsIOkR9CCsa0kf46Vvom9Fhbl+gyyjYMzm3/CBCsGtZpwd4G8dV+Db3kc//KIBocoYowIJqcdo3yUG2V8rCH+Or2SqCzLezuiOWM9bxEfBgV+Cvi3E0SbAmHKZV294w=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d4d3c8-087c-490a-c34c-08d88b5e4875
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 01:07:13.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVK0Ed0o10XAImqrRQTreV0SPQmm3HQL9ToDjMnbsmvVaJ5OF3Q/5FcQ6KaibC/I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2598
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0 suspectscore=1
 malwarescore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 04:46:34PM -0800, Roman Gushchin wrote:
> On Wed, Nov 18, 2020 at 01:06:17AM +0100, Daniel Borkmann wrote:
> > On 11/17/20 4:40 AM, Roman Gushchin wrote:
> > > In the absolute majority of cases if a process is making a kernel
> > > allocation, it's memory cgroup is getting charged.
> > > 
> > > Bpf maps can be updated from an interrupt context and in such
> > > case there is no process which can be charged. It makes the memory
> > > accounting of bpf maps non-trivial.
> > > 
> > > Fortunately, after commit 4127c6504f25 ("mm: kmem: enable kernel
> > > memcg accounting from interrupt contexts") and b87d8cefe43c
> > > ("mm, memcg: rework remote charging API to support nesting")
> > > it's finally possible.
> > > 
> > > To do it, a pointer to the memory cgroup of the process which created
> > > the map is saved, and this cgroup is getting charged for all
> > > allocations made from an interrupt context.
> > > 
> > > Allocations made from a process context will be accounted in a usual way.
> > > 
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > [...]
> > > +#ifdef CONFIG_MEMCG_KMEM
> > > +static __always_inline int __bpf_map_update_elem(struct bpf_map *map, void *key,
> > > +						 void *value, u64 flags)
> > > +{
> > > +	struct mem_cgroup *old_memcg;
> > > +	bool in_interrupt;
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * If update from an interrupt context results in a memory allocation,
> > > +	 * the memory cgroup to charge can't be determined from the context
> > > +	 * of the current task. Instead, we charge the memory cgroup, which
> > > +	 * contained a process created the map.
> > > +	 */
> > > +	in_interrupt = in_interrupt();
> > > +	if (in_interrupt)
> > > +		old_memcg = set_active_memcg(map->memcg);
> > > +
> > > +	ret = map->ops->map_update_elem(map, key, value, flags);
> > > +
> > > +	if (in_interrupt)
> > > +		set_active_memcg(old_memcg);
> > > +
> > > +	return ret;
> > 
> > Hmm, this approach here won't work, see also commit 09772d92cd5a ("bpf: avoid
> > retpoline for lookup/update/delete calls on maps") which removes the indirect
> > call, so the __bpf_map_update_elem() and therefore the set_active_memcg() is
> > not invoked for the vast majority of cases.
> 
> I see. Well, the first option is to move these calls into map-specific update
> functions, but the list is relatively long:
>   nsim_map_update_elem()
>   cgroup_storage_update_elem()
>   htab_map_update_elem()
>   htab_percpu_map_update_elem()
>   dev_map_update_elem()
>   dev_map_hash_update_elem()
>   trie_update_elem()
>   cpu_map_update_elem()
>   bpf_pid_task_storage_update_elem()
>   bpf_fd_inode_storage_update_elem()
>   bpf_fd_sk_storage_update_elem()
>   sock_map_update_elem()
>   xsk_map_update_elem()
> 
> Alternatively, we can set the active memcg for the whole duration of bpf
> execution. It's simpler, but will add some overhead. Maybe we can somehow
> mark programs calling into update helpers and skip all others?

Actually, this is problematic if a program updates several maps, because
in theory they can belong to different cgroups.
So it seems that the first option is the way to go. Do you agree?
