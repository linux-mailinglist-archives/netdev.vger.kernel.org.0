Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882EE1E75ED
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgE2GbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:31:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725308AbgE2GbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 02:31:14 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T6PpGM013391;
        Thu, 28 May 2020 23:31:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8cv9qcVSR6C6dKbQd//C91aa408AVAiKNu98eUGt8Gc=;
 b=VX+pUpNmubnAE4+7ntXCv/t2MtR1fNLHufMOTRYb9ugxjOa9olSJ048RFRnhIk13r/e8
 WpIMzs6Z22DU4qfLFBSwmRVqRt571QSmIBSbUkHnA+PP+gOnA6+fEIqGPhfdoYALuJMP
 UI3OX0l43PvitOt6FHFk+hk0H2DMv3BW+dE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 319yh5ypdc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 28 May 2020 23:30:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 28 May 2020 23:30:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfLvCy/M+uJ1ZOf5h606C3qFqDh6DijzflyHpT8OhL0Ldp4Yp9Gg2oXWKDR9DUlR8YX9WeOj0qJMMEZWcRkbMUVbClXRJubbebYahoIWWHRQv1snESrKDr57cpRj2t9MZ7I51qauP1f5LpW8p4m4N47MgoDlChnfbpk1/TjLwdr6eQAmbamlGuGjTFi8CY0GkYX2IQ8U4Klh24ptMnG7F75rlzc+Yycvlt46qFKqC/alZbVi9gnke1Z1woW+GB3NQ/4EFKH8g5jKuMukBoGDVNvfgMbdA5h6zuVBzxzV4zDRbE0lgVMeHsfuYrGUhN3ADGmZgWIeohw/yMcgPLtwrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cv9qcVSR6C6dKbQd//C91aa408AVAiKNu98eUGt8Gc=;
 b=Mx35SkmkDbhgUxt2WqP7GPScB4aF8CsKvXvhwPyo4RZ9N3UHWxOOH1snOFrrHg48zR+nGhfJZAmTpE/Yfvi1eJ1C69mIY0Y6pk6lfhgJmQ5+gSb0rUoVeWG7I0XeDs2w1w+ksrakWu1MxTjRTiAofPXMRJ2ju9bH6+LX/x8uCwAkdt7UiRAo7ZJZKBsfGOaNZyEn93DMFIvgIa72DNeXEyoUhYGJ6BLhBgPmbSUmGNWLf3uEzM++bmB5wkO+m8KqwQFDqed0u7k+prraIuti/z9H8qLIo+Yd3OBwvIKZlF9tNHdQeNbVOvEUyUPP0+/6kbm8L3RDjw7zPRvod6yaLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cv9qcVSR6C6dKbQd//C91aa408AVAiKNu98eUGt8Gc=;
 b=D3cLqLQImaftWJh8tHzRYj7lfUlAdzZesQm2U+MRzmcDrNJUSD1Wb4gI/w4hA/OP4CLTJF48GkwEHNtpE/Lt++WG5dBsD/peVLteFRubrybV1YCT0yikpRI3eePmYasJPt38iUc9wXdut//GP32/8JhwPg9glH9/g81wiO4GRyY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3699.namprd15.prod.outlook.com (2603:10b6:a03:1b6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:30:56 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:30:56 +0000
Date:   Thu, 28 May 2020 23:30:54 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Consolidate inner-map-compatible
 properties into bpf_types.h
Message-ID: <20200529063054.edz7qfiqgfgjzj43@kafai-mbp>
References: <20200522022336.899416-1-kafai@fb.com>
 <20200522022342.899756-1-kafai@fb.com>
 <9c00ced2-983f-ad59-d805-777ebd1f1cab@iogearbox.net>
 <20200523010003.6iyavqny3aruv6u2@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza===GwERi_x0Evf_Wjm+8=wBHnG4VHPNtZ=GPPZ+twiQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza===GwERi_x0Evf_Wjm+8=wBHnG4VHPNtZ=GPPZ+twiQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:254::14) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:d1b5) by BY3PR05CA0009.namprd05.prod.outlook.com (2603:10b6:a03:254::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Fri, 29 May 2020 06:30:55 +0000
X-Originating-IP: [2620:10d:c090:400::5:d1b5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a964c186-287d-4aa5-f986-08d80399d7d8
X-MS-TrafficTypeDiagnostic: BY5PR15MB3699:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36990BE4040F6D28E4114719D58F0@BY5PR15MB3699.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQLzwhna6+xzzI6iTer3cmDp93h8ZlXv9fQ8rMhywjmBcMvku22S3Hi9fFm2Knj3o5IR10g/dCDUc7EJga2KtbqI62rwY2PFSPrX07ZHa390vDw6NLjTvoQZb2IkLo148kV5zxIvf6I5C++yM6juzGT3oFVTG37yRxPIiktP26+PDzefuqHk0r/NMOwddWjIO4KzmeF1IJITW2QHfwI1FfVwni19vzqxFHhik7/9NUNjB63M9Ht1gvyyLEFNLjuBB5UE/zK9UyDCPm71zYUUVeNCPWBBbTS14khLa7F4FBki5VLnHX1cfrb5QKFEfj5Z6PazDdmhzRCH/3y6ctYr3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(1076003)(66476007)(66556008)(33716001)(2906002)(86362001)(66946007)(83380400001)(110136005)(4326008)(55016002)(9686003)(498600001)(186003)(8936002)(16526019)(52116002)(8676002)(53546011)(6496006)(54906003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: M2YXi2AHX4Cm5mMmnbaeMP/KxzDcfIrN+4IXnyyigJ/+dEV2mG5BvNGqIuGKt9FxC5oPGFxkN/72AlQSFWaylgtU8IzzANLQKf1YWxJyUxhoQ3Nb6D7m2uaBU6wO7ZEbSWc2t4CrrOgFvnvEOEL+vp9W46x6M/vD1hhjW89PpNpHlC3BdjFHUv+09Fw+OA4rstEha3whU37lkCtoq7m9tqiLZas633+p4qflJ3Ytj0jC9MuEJ5XBdEIw0OcWBQ82NuJ0Y06g4N0GoBIht5xImrvXha8JpTJPpdy9+bHPiQQvCs3gonTd7Z+NITd8exDy8To0zKXrtjL2538LoImzH3Rs8IZQGL7Dzt8i0uvGpwy1qvJlvSg/GikTSOGntXgbuWNShOaO0cCtRbG4hJFOe3oH2HRMSdy6fb7RhcIz9eJ8RZXBfEt18q4njcryXfLZ5oOmlIQhXAwv32hx6Q/YC6EwXeHatUAaCzsqI2+1LhhJKMyOdHUsh3NfhNzEY7b3BeL4/Yd9QVUzjJFlPDPHag==
X-MS-Exchange-CrossTenant-Network-Message-Id: a964c186-287d-4aa5-f986-08d80399d7d8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:30:56.3743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AeOJ99e9/Y3X0dr3LBx1qQsiRwArp3SVtajY1bkipxsgi5NpWxR3/TqfUeL+xxe4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3699
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 phishscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:54:26AM -0700, Andrii Nakryiko wrote:
> On Fri, May 22, 2020 at 6:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Sat, May 23, 2020 at 12:22:48AM +0200, Daniel Borkmann wrote:
> > > On 5/22/20 4:23 AM, Martin KaFai Lau wrote:
> > > [...]
> > > >   };
> > > > +/* Cannot be used as an inner map */
> > > > +#define BPF_MAP_NO_INNER_MAP (1 << 0)
> > > > +
> > > >   struct bpf_map {
> > > >     /* The first two cachelines with read-mostly members of which some
> > > >      * are also accessed in fast-path (e.g. ops, max_entries).
> > > > @@ -120,6 +123,7 @@ struct bpf_map {
> > > >     struct bpf_map_memory memory;
> > > >     char name[BPF_OBJ_NAME_LEN];
> > > >     u32 btf_vmlinux_value_type_id;
> > > > +   u32 properties;
> > > >     bool bypass_spec_v1;
> > > >     bool frozen; /* write-once; write-protected by freeze_mutex */
> > > >     /* 22 bytes hole */
> > > > @@ -1037,12 +1041,12 @@ extern const struct file_operations bpf_iter_fops;
> > > >   #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
> > > >     extern const struct bpf_prog_ops _name ## _prog_ops; \
> > > >     extern const struct bpf_verifier_ops _name ## _verifier_ops;
> > > > -#define BPF_MAP_TYPE(_id, _ops) \
> > > > +#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
> > > >     extern const struct bpf_map_ops _ops;
> > > >   #define BPF_LINK_TYPE(_id, _name)
> > > >   #include <linux/bpf_types.h>
> > > >   #undef BPF_PROG_TYPE
> > > > -#undef BPF_MAP_TYPE
> > > > +#undef BPF_MAP_TYPE_FL
> > > >   #undef BPF_LINK_TYPE
> > > >   extern const struct bpf_prog_ops bpf_offload_prog_ops;
> > > > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > > > index 29d22752fc87..3f32702c9bf4 100644
> > > > --- a/include/linux/bpf_types.h
> > > > +++ b/include/linux/bpf_types.h
> > > > @@ -76,16 +76,25 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
> > > >   #endif /* CONFIG_BPF_LSM */
> > > >   #endif
> > > > +#define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
> > > > +
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> > > > -BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops)
> > > > +/* prog_array->aux->{type,jited} is a runtime binding.
> > > > + * Doing static check alone in the verifier is not enough,
> > > > + * so BPF_MAP_NO_INNTER_MAP is needed.
> > >
> > > typo: INNTER
> > Good catch.
> >
> > >
> > > > + */
> > > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops,
> > > > +           BPF_MAP_NO_INNER_MAP)
> > >
> > > Probably nit, but what is "FL"? flags? We do have map_flags already, but here the
> > > BPF_MAP_NO_INNER_MAP ends up in 'properties' instead. To avoid confusion, it would
> > > probably be better to name it 'map_flags_fixed' since this is what it really means;
> > > fixed flags that cannot be changed/controlled when creating a map.
> > ok. may be BPF_MAP_TYPE_FIXED_FL?
> >
> > >
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops)
> > > >   #ifdef CONFIG_CGROUPS
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
> > > >   #endif
> > > >   #ifdef CONFIG_CGROUP_BPF
> > > > -BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
> > > > -BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
> > > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops,
> > > > +           BPF_MAP_NO_INNER_MAP)
> > > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops,
> > > > +           BPF_MAP_NO_INNER_MAP)
> > > >   #endif
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
> > > > @@ -116,8 +125,10 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
> > > >   BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> > > >   #if defined(CONFIG_BPF_JIT)
> > > > -BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> > > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops,
> > > > +           BPF_MAP_NO_INNER_MAP)
> > > >   #endif
> > > > +#undef BPF_MAP_TYPE
> > > >   BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> > > >   BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> > > [...]
> > > > diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
> > > > index 17738c93bec8..d965a1d328a9 100644
> > > > --- a/kernel/bpf/map_in_map.c
> > > > +++ b/kernel/bpf/map_in_map.c
> > > > @@ -17,13 +17,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
> > > >     if (IS_ERR(inner_map))
> > > >             return inner_map;
> > > > -   /* prog_array->aux->{type,jited} is a runtime binding.
> > > > -    * Doing static check alone in the verifier is not enough.
> > > > -    */
> > > > -   if (inner_map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
> > > > -       inner_map->map_type == BPF_MAP_TYPE_CGROUP_STORAGE ||
> > > > -       inner_map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
> > > > -       inner_map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
> > > > +   if (inner_map->properties & BPF_MAP_NO_INNER_MAP) {
> > > >             fdput(f);
> > > >             return ERR_PTR(-ENOTSUPP);
> > > >     }
> > >
> > > This whole check here is currently very fragile. For example, given we forbid cgroup
> > > local storage here, why do we not forbid socket local storage? What about other maps
> > > like stackmap? It's quite unclear if it even works as expected and if there's also a
> > > use-case we are aware of. Why not making this an explicit opt-in?
> > Re: "cgroup-local-storage", my understanding is,
> > cgroup-local-storage is local to the bpf's cgroup that it is running under,
> > so it is not ok for a cgroup's bpf to be able to access other cgroup's local
> > storage through map-in-map, so they are excluded here.
> >
> > sk-local-storage does not have this restriction.  For other maps, if there is
> > no known safety issue, why restricting it and create unnecessary API
> > discrepancy?
> >
> > I think we cannot restrict the existing map either unless there is a
> > known safety issue.
> >
> > >
> > > Like explicit annotating via struct bpf_map_ops where everything is visible in one
> > > single place where the map is defined:
> > >
> > > const struct bpf_map_ops array_map_ops = {
> > >         .map_alloc_check = array_map_alloc_check,
> > >         [...]
> > >         .map_flags_fixed = BPF_MAP_IN_MAP_OK,
> > > };
> > I am not sure about adding it to bpf_map_ops instead of bpf_types.h.
> > It will be easier to figure out what map types do not support MAP_IN_MAP (and
> > other future map's fixed properties) in one place "bpf_types.h" instead of
> > having to dig into each map src file.
> 
> I'm 100% with Daniel here. If we are consolidating such things, I'd
> rather have them in one place where differences between maps are
> defined, which is ops. Despite an "ops" name, this seems like a
> perfect place for specifying all those per-map-type properties and
> behaviors. Adding flags into bpf_types.h just splits everything into
> two places: bpf_types.h specifies some differences, while ops specify
> all the other ones.
> 
> Figuring out map-in-map support is just one of many questions one
> might ask about differences between map types, I don't think that
> justifies adding them to bpf_types.h. Grepping for struct bpf_map_ops
> with search context (i.e., -A15 or something like that) should be
> enough to get a quick glance at all possible maps and what they
> define/override.
> 
> It also feels like adding this as bool field for each aspect instead
> of a collection of bits is cleaner and a bit more scalable. If we need
> to add another property with some parameter/constant, or just enum,
> defining one of few possible behaviors, it would be easier to just add
> another field, instead of trying to cram that into u32. It also solves
> your problem of "at the glance" view of map-in-map support features.
> Just name that field unique enough to grep by it :)
How about another way.  What patch 2 want is each map could have its own
bpf_map_meta_equal().  Instead of adding 2 flags, add the bpf_map_meta_equal()
as a ops to bpf_map_ops.  Each map supports to be used as an inner_map
needs to set this ops.  Then it will be an opt-in.
A default implementation can be provided for most maps' use.
The maps (e.g. arraymap and other future maps) that has different requirement
can implement its own.  For the existing maps, when we address those
limitations (e.g. arraymap's gen_lookup) later,  we can then change its
bpf_map_meta_equal.

Thoughts?

> 
> >
> > If the objective is to have the future map "consciously" opt-in, how about
> > keeping the "BPF_MAP_TYPE" name as is but add a fixed_flags param as the
> > earlier v1 and flip it from NO to OK flag.  It will be clear that,
> > it is a decision that the new map needs to make instead of a quiet 0
> > in "struct bpf_map_ops".
> >
> > For example,
> > BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops, BPF_MAP_IN_MAP_OK)
> > BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops, 0)
> > BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops, BPF_MAP_IN_MAP_OK | BPF_MAP_IN_MAP_DYNAMIC_SIZE_OK)
> >
> > >
> > > That way, if someone forgets to add .map_flags_fixed to a new map type, it's okay since
> > > it's _safe_ to forget to add these flags (and okay to add in future uapi-wise) as opposed
> > > to the other way round where one can easily miss the opt-out case and potentially crash
> > > the machine worst case.
