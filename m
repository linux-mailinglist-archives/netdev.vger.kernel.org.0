Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644FB1DF3AF
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 03:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgEWBAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 21:00:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8064 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731169AbgEWBAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 21:00:43 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04N0wC9j031015;
        Fri, 22 May 2020 18:00:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FfgzNYdrwIkKb7ByAN2fidKIYj/yra9iNrAv3jSqmJg=;
 b=iKpo3WpZT7RpvRdZBjJUUqRFgKmhYxrl9jIshOFfCjDu9MYg6qndXUago7Rx/hzdB2l1
 M2HX4PT/KMpbrXNu0dDyFEoBh0Kn6OwY+Gq85chDS1SJGP2LE2xGv4hGcVOpWYU3zZSg
 F7rBx2Gcm82ubcX5J9mqwhL4kg5v+0ehr9A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 315bt2xvwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 May 2020 18:00:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 May 2020 18:00:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCBM3xjSqK+8hg2+hznATPLu8m7lopJoiu+DOWPXxlmfh38xDbTnJC4+95mLtnYrOgH0wqvbT1Z8pnoM0fljQUuLmcK7CKNXSytvfptNMazsvUw+InEharS1ZKuqzmDzXYsWnhr88hMNHczs5LiRNL2YmKuGY3wtAQzOWQ7dLeieW9d3ux1ckhsLDLuVJAT9eFUaTlGaX9UVy1BovwUP9qXGMqryaV1h0FELoq4/93KmVOOiDTjJCPe7acm7Z80WX9tO2AT19KS9q6Dhm6gVpYjldq8JZ2sCNEmma19Pp6wpF87X+m5q1lzib0HLOXGYYrJyIgHG1DB4F1vBrroQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfgzNYdrwIkKb7ByAN2fidKIYj/yra9iNrAv3jSqmJg=;
 b=KBK1/qwIA3FTb7fPaXs8GPt6kW9mLuaPUVVcq521lTw/xeYzl9uX0geZv3TAPFC9UWhGaAM8EnQfvsq7ZbJlajYWHjilPz5pQ7y8KnPQ3w2vgvt7/J9rVjJuIOdoRFpQMNEk0TGlPZM1+D8qEM6NWoR45cXOgzQ3ldiOkdaYKN+gJKQZsE385/qqZncZC6Pitf+yyxsOg3Y+XF95SNHrYcbaAELYcR9LHfDKN0fWpC1W6gpEeLxSWJhodj4v8/MzOLO8Kbz+e+tsfdeCU5bxlOTTZQMgs7bk7EFjFt427KvHr0THF60Yo9WB3RJ+xjCeAVENGD2fyAxO+/fPWmQcMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfgzNYdrwIkKb7ByAN2fidKIYj/yra9iNrAv3jSqmJg=;
 b=lf5hQ4UnKUCxojnBgDfV9rdJO/AbC9ytQQ4CzKNnuRJilHIG0IXf32/19km5fXkUPouKx9ZBLzKECuSbzk9kTCU1sKssukG/QOasJHvjXS/0Km/EwIjvuBsQps/TKblWRV4rtF5gIwXLMAuQO/DdRvei74mdvXZm8iiTZzKb/Vg=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3554.namprd15.prod.outlook.com (2603:10b6:a03:1b5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Sat, 23 May
 2020 01:00:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.3000.034; Sat, 23 May 2020
 01:00:09 +0000
Date:   Fri, 22 May 2020 18:00:03 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        <kernel-team@fb.com>, <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Consolidate inner-map-compatible
 properties into bpf_types.h
Message-ID: <20200523010003.6iyavqny3aruv6u2@kafai-mbp.dhcp.thefacebook.com>
References: <20200522022336.899416-1-kafai@fb.com>
 <20200522022342.899756-1-kafai@fb.com>
 <9c00ced2-983f-ad59-d805-777ebd1f1cab@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c00ced2-983f-ad59-d805-777ebd1f1cab@iogearbox.net>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2022) by BYAPR06CA0056.namprd06.prod.outlook.com (2603:10b6:a03:14b::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 01:00:09 +0000
X-Originating-IP: [2620:10d:c090:400::5:2022]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cabd2e70-6b91-4358-bb19-08d7feb4a3f0
X-MS-TrafficTypeDiagnostic: BY5PR15MB3554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3554D9F9A546CF8F9017457BD5B50@BY5PR15MB3554.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSg3JtzW/uIJ6pABZpC/M1Q2Xp35r8tQqMO3wb22JY0WMNnTmuXQkbr9DmvGxJWsgJD6c35OtR7XeDnEE2A6BhyYAnjQEFUbJjjYyVroL2gNx12PyyfGRwwCbKA9iQwFjIwp/BTFzPdLrCJpTZzg3TD+qoPimCMtvkpA+MgRmgTHmXUFLW75k4NE0y1Ik6tswGGvgcT0UDrikD+yLXqgEAQdinL1PE9FiPhs9K7Ci+gWimN9yh1N/emSjhxUSWvxQblk/Vt3CyRrKdOYmHp15Wcm6WN0lt4mJo9VDIbAQgugXZ7WFyekFU9AdESbQZr0K9jwx4FzmxBoXb+iaUXGdpYmAyU5Du6qmpJGb4WB16MfJWUGvRPwDq0eNEJT6oKg4EhxIP+CuViuQsbovhShx1w6JF35kJll0xN82i1N+i37UOhBRMss6GPPXGncyrOP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(136003)(396003)(6666004)(6506007)(2906002)(55016002)(7696005)(52116002)(9686003)(5660300002)(66556008)(8936002)(53546011)(8676002)(6916009)(66476007)(16526019)(186003)(54906003)(4326008)(478600001)(66946007)(1076003)(86362001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: b59xu+JFCFmQTof3Nn1SEE3jB9fFiqqryn/BSUySDx3Tz86/BL1OFUZIBlJw5Itp7AGCDaN4HwaDtqK7u/HYYB1Fy/N8CV5e0XKbRPrBAENNj/Vxq9JZgLpwjCeBDgALFbsBx0OQ2wm+K1XOBhPIQfpAs52RT7IrDFXoWjpPSYBMtHOQW14ZfJyj7+karxvENM1f+DeAztkdJqIwIcT4gUN9u+ly4ErS5VqUnR4Nwh+MdRw2zhH2YX5f6w3P/RSHXHmWwfPKZUohREYsOqjgweHD5jwDcybe6n6KRudVvIhjgtVrDyL1DlHAlTimMmBksfc/H1nNK4J2n8SjqW5JX7uBZzzqMvbIFDlRJZqCmFd3WMA6zvpuRoTnxycssPUWO85ysc4GgNRxwZTd9LoqxET11n0IomsNd+CucEEEdDeEF4GIxUCyUdZTbZJoLO9jIKQG+L7cbWFIathNt5DuaGHyQxDI6k3izVE9rTITn4krEUHCNw+CeaFlB4MppyTl3XVy8CwoXCdF2WX3WG80ww==
X-MS-Exchange-CrossTenant-Network-Message-Id: cabd2e70-6b91-4358-bb19-08d7feb4a3f0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 01:00:09.6844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vqMfg+Mdydr67F4McJ68YjeClcyH9jm5NrqAej95rbdU+P4cViBf7OnIHsE9QrFD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3554
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-22_12:2020-05-22,2020-05-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 12:22:48AM +0200, Daniel Borkmann wrote:
> On 5/22/20 4:23 AM, Martin KaFai Lau wrote:
> [...]
> >   };
> > +/* Cannot be used as an inner map */
> > +#define BPF_MAP_NO_INNER_MAP (1 << 0)
> > +
> >   struct bpf_map {
> >   	/* The first two cachelines with read-mostly members of which some
> >   	 * are also accessed in fast-path (e.g. ops, max_entries).
> > @@ -120,6 +123,7 @@ struct bpf_map {
> >   	struct bpf_map_memory memory;
> >   	char name[BPF_OBJ_NAME_LEN];
> >   	u32 btf_vmlinux_value_type_id;
> > +	u32 properties;
> >   	bool bypass_spec_v1;
> >   	bool frozen; /* write-once; write-protected by freeze_mutex */
> >   	/* 22 bytes hole */
> > @@ -1037,12 +1041,12 @@ extern const struct file_operations bpf_iter_fops;
> >   #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
> >   	extern const struct bpf_prog_ops _name ## _prog_ops; \
> >   	extern const struct bpf_verifier_ops _name ## _verifier_ops;
> > -#define BPF_MAP_TYPE(_id, _ops) \
> > +#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
> >   	extern const struct bpf_map_ops _ops;
> >   #define BPF_LINK_TYPE(_id, _name)
> >   #include <linux/bpf_types.h>
> >   #undef BPF_PROG_TYPE
> > -#undef BPF_MAP_TYPE
> > +#undef BPF_MAP_TYPE_FL
> >   #undef BPF_LINK_TYPE
> >   extern const struct bpf_prog_ops bpf_offload_prog_ops;
> > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > index 29d22752fc87..3f32702c9bf4 100644
> > --- a/include/linux/bpf_types.h
> > +++ b/include/linux/bpf_types.h
> > @@ -76,16 +76,25 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
> >   #endif /* CONFIG_BPF_LSM */
> >   #endif
> > +#define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
> > +
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> > -BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops)
> > +/* prog_array->aux->{type,jited} is a runtime binding.
> > + * Doing static check alone in the verifier is not enough,
> > + * so BPF_MAP_NO_INNTER_MAP is needed.
> 
> typo: INNTER
Good catch.

> 
> > + */
> > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops,
> > +		BPF_MAP_NO_INNER_MAP)
> 
> Probably nit, but what is "FL"? flags? We do have map_flags already, but here the
> BPF_MAP_NO_INNER_MAP ends up in 'properties' instead. To avoid confusion, it would
> probably be better to name it 'map_flags_fixed' since this is what it really means;
> fixed flags that cannot be changed/controlled when creating a map.
ok. may be BPF_MAP_TYPE_FIXED_FL?

> 
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops)
> >   #ifdef CONFIG_CGROUPS
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
> >   #endif
> >   #ifdef CONFIG_CGROUP_BPF
> > -BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
> > -BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
> > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops,
> > +		BPF_MAP_NO_INNER_MAP)
> > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops,
> > +		BPF_MAP_NO_INNER_MAP)
> >   #endif
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
> > @@ -116,8 +125,10 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
> >   BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> >   #if defined(CONFIG_BPF_JIT)
> > -BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops,
> > +		BPF_MAP_NO_INNER_MAP)
> >   #endif
> > +#undef BPF_MAP_TYPE
> >   BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> >   BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> [...]
> > diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
> > index 17738c93bec8..d965a1d328a9 100644
> > --- a/kernel/bpf/map_in_map.c
> > +++ b/kernel/bpf/map_in_map.c
> > @@ -17,13 +17,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
> >   	if (IS_ERR(inner_map))
> >   		return inner_map;
> > -	/* prog_array->aux->{type,jited} is a runtime binding.
> > -	 * Doing static check alone in the verifier is not enough.
> > -	 */
> > -	if (inner_map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
> > -	    inner_map->map_type == BPF_MAP_TYPE_CGROUP_STORAGE ||
> > -	    inner_map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
> > -	    inner_map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
> > +	if (inner_map->properties & BPF_MAP_NO_INNER_MAP) {
> >   		fdput(f);
> >   		return ERR_PTR(-ENOTSUPP);
> >   	}
> 
> This whole check here is currently very fragile. For example, given we forbid cgroup
> local storage here, why do we not forbid socket local storage? What about other maps
> like stackmap? It's quite unclear if it even works as expected and if there's also a
> use-case we are aware of. Why not making this an explicit opt-in?
Re: "cgroup-local-storage", my understanding is,
cgroup-local-storage is local to the bpf's cgroup that it is running under,
so it is not ok for a cgroup's bpf to be able to access other cgroup's local
storage through map-in-map, so they are excluded here.

sk-local-storage does not have this restriction.  For other maps, if there is
no known safety issue, why restricting it and create unnecessary API
discrepancy?

I think we cannot restrict the existing map either unless there is a
known safety issue.

> 
> Like explicit annotating via struct bpf_map_ops where everything is visible in one
> single place where the map is defined:
> 
> const struct bpf_map_ops array_map_ops = {
>         .map_alloc_check = array_map_alloc_check,
>         [...]
>         .map_flags_fixed = BPF_MAP_IN_MAP_OK,
> };
I am not sure about adding it to bpf_map_ops instead of bpf_types.h.
It will be easier to figure out what map types do not support MAP_IN_MAP (and
other future map's fixed properties) in one place "bpf_types.h" instead of
having to dig into each map src file.

If the objective is to have the future map "consciously" opt-in, how about
keeping the "BPF_MAP_TYPE" name as is but add a fixed_flags param as the
earlier v1 and flip it from NO to OK flag.  It will be clear that,
it is a decision that the new map needs to make instead of a quiet 0
in "struct bpf_map_ops".

For example,
BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops, BPF_MAP_IN_MAP_OK)
BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops, 0)
BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops, BPF_MAP_IN_MAP_OK | BPF_MAP_IN_MAP_DYNAMIC_SIZE_OK)

> 
> That way, if someone forgets to add .map_flags_fixed to a new map type, it's okay since
> it's _safe_ to forget to add these flags (and okay to add in future uapi-wise) as opposed
> to the other way round where one can easily miss the opt-out case and potentially crash
> the machine worst case.
