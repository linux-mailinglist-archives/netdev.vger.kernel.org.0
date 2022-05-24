Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBFB53228E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 07:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiEXFkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 01:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbiEXFka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 01:40:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC3690CC9;
        Mon, 23 May 2022 22:40:27 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24NKGrEF015570;
        Mon, 23 May 2022 22:40:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ttcvTwQzCgu33LSgm0nsN+Y91oGeQ0LyRqMPA+hvmnc=;
 b=q9qiXBcVJeh9tMgajmxQxjkOpmSzJ8xJQ26gFP2G+sNeZwos0/4gAqMj688afEiIeTli
 wxfKOs0DBiC5AqAtr/HtauN9DpT4b7ceIFxjvL+IrUw4637JBeIQSYVU0AybpQojF8eL
 jxT8+BclluME9axBRhi/+pBQACWL7GNpO0A= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g6urvxd6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 22:40:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3+pi/tjIitIpAYV+T5cSmJTDTzfcj2z2VD/pbu25uQP9o2jec54Il5g57R3SitMyDhf6KM7WyzgbBPjqBIeHBIkR1oGff4NZbLec4/88HdVJgBX/XRC+Js0v8AakHTDfs31MBMvHYnkx3zgThGph67AupTAVWic2cEJ5tbQVAOFeH5bsK+kbsoFYHTeUio+sYZTwJ3yZUVkfdwL2D7roaWpYPvrO1t+n1jcsC6zaJCcaOytFpzTmhHJxYGZLGIZ3JaktGngbLPlepmLk7kz2Fy79BFRAxvu8+jw6oI/uD+yMbn8JRaI3Qg0iCz1X3Vk2SDoGT7/h9Ga45w/WmLBTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttcvTwQzCgu33LSgm0nsN+Y91oGeQ0LyRqMPA+hvmnc=;
 b=Q59cmqG3ll3FRiuZZqJpf7q5cEBUrZM2LHxU4zKtA16/5Fhg3/9zaqtBgP8MAxxUh0AchFWw38QZNxkXiVRmAtrS1l+vdM5XbjGrqQ2/rwSn7EC9w7hyYss1Z0sY9bBHMDcKI+AE1DdBZXGauDwU18tppgQD0TqZUhD5ywmAEH60UkOJ65w++yH7EKSUlQOKjlGsrAQ5R7hBpLJzcAuNmXE2EeECl5Ui88CY4MGTdf1i7kIbfNsG3zKlTh0HprW3pBgQnclGsLLrqCEJJCtNWWoUxYoffSEuzzciROjWGm8Sn6hcVKRR44LR05YcK4VeD5Idneuw3kd7bLz2sQmXxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by BN8PR15MB2881.namprd15.prod.outlook.com (2603:10b6:408:87::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 05:40:09 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::31b7:473f:3995:c117]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::31b7:473f:3995:c117%6]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 05:40:09 +0000
Date:   Mon, 23 May 2022 22:40:07 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v7 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220524054007.nskzzkghazi73xr4@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-4-sdf@google.com>
 <20220521005313.3q3w2ventgwrccrd@kafai-mbp>
 <CAKH8qBuUW8vSgTaF-K_kOPoX3kXBy5Z=ufcMx8mwTwkxs2wQ6g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuUW8vSgTaF-K_kOPoX3kXBy5Z=ufcMx8mwTwkxs2wQ6g@mail.gmail.com>
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ae1c95b-7199-496b-d9a6-08da3d47dd1c
X-MS-TrafficTypeDiagnostic: BN8PR15MB2881:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2881BEB35188EAF39825A1D9D5D79@BN8PR15MB2881.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SGpN/il2yP8UieSaf70ed73ylgttKbnAny0G786WLajNcpMxxQuYUKkiOmSWzg8Aj1Hqo/Ri+VCtzcTZKMj+gqaWjRT1hPREZzTkQ7rZIBw3kcRdpwttjsNR3x+V5Gzl0qi9h0kRIiMj2a4HxnLnuY+5ZnecuNZZ6q0+Oyjf51cI4JeuthcGjDEnNbHmGHMjDqkkynChQ6VS/A8PiZeH+DiJC+f2Uz6gBC4wQO+VX0MaSc0xzIO5nIx1w7wo/xF/XoSFs3FTs1UswcXIBYafwoC8Gkrjd41HKHjBXoVmV4r6DsaZ70d7kjrs75TMveT8cfAi+0s5zfxQyPQI7dv4A41xZtJ1jWME8nZpqJT4lejEh5PBXVs7Wk1jf1Kk6+RwS2QCJVPqUlxJMPJwyd5Rfgo+Da85CtSYei0SWfztlnQDSZpSl0e9ko9f7jUmkml9j9yqWovKB3DUHi6Us89h6xnplCoIaOZctX1ZSidqpcpq6GPKB48Jj3+MpHpORlA9xT4Tt6qRCncIpwittSRS4Ez8Zle8AgnyApD39WI3emhnBtqAMjc+pmFC94EsffZKUpNCrfCZJ+bIS8MYMAkGAV+XoFx5r0I6cFY5008yFb8Ee/EerUV9OfWYP7LeqSBwXD7elUGjrM4oTPd2Sk5qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6512007)(9686003)(52116002)(6486002)(508600001)(5660300002)(2906002)(33716001)(6506007)(53546011)(8936002)(4326008)(38100700002)(8676002)(316002)(6916009)(83380400001)(66476007)(66946007)(66556008)(186003)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?thHsHz6UVR/BLoWmxp9dtsuMsk2RWaoITRftm4Xk7WUmnzdad94G7pO9K1Gg?=
 =?us-ascii?Q?GUlqm0Q2h4EXSgi2TIBTNl8zpEvh3vt5RuhiuE9yeJKs6Ay3AjRsTL4fB1EI?=
 =?us-ascii?Q?Y63tz78+PDE0VfdsDPjlz0jd5XVWgKNmhlBPrME4i+CVDfyuxhb3bvSLF5KT?=
 =?us-ascii?Q?zyjHBCLHPEiMjAA8PZHP9rXKAJC3xkBf8KiF4VwPCBzmH9k4QN/ihkg3r8+4?=
 =?us-ascii?Q?ZpFLpJLFKdx3/SusCNeO00sK0/o206412AtCUZ6aw/5k0sp6DLpl/PdVMsIy?=
 =?us-ascii?Q?BXAWUzBwS5l/5BwJhiJoD3jDA9YXLnPrmVmz0O2yVhlE8CrsuYAYy2auLOyS?=
 =?us-ascii?Q?+FILuD6A7N7hxXvf5QuK9tU/FrLlaIH1rCMIWzLvb1lqN7naJNTOo5d2F4vy?=
 =?us-ascii?Q?CTQQUtujUDlZiSMEbQWbP7LvmVU2ep88/wlGmIeEO1/fdZ+FN2gyTwnzdZ+g?=
 =?us-ascii?Q?QrXRmQUYdUysxApzN8tOSapfw7QupfwKe3VRzTbH31nWPks5B6gwUYPtmBMK?=
 =?us-ascii?Q?ywrItPcyrdwAxVPvBFINBRCM59U9BKS3ufw6nbFrYlVmbY6OOPokahuZM7zi?=
 =?us-ascii?Q?5zA6So3IpmnVh0HmCRSBeHtnPQ87Lore6IEkczLExPkPwygatq+CAvjfstOR?=
 =?us-ascii?Q?mCNbOOmCXhkVUtThN6tLeJ0vXt5sP7384Rm4uxzytW0gnGx10pirXt0ZIfEq?=
 =?us-ascii?Q?xRFXEbavXBv938qBfg0+oOisVz+kKIRfnPMs8rR7dIzWZlk+JxbNywVq5cFO?=
 =?us-ascii?Q?t3JkHtsFEhM/HTg6JujFTVqcDqxms1wDzRfE2ai2q0+8rW8GHtUBIii9gNyJ?=
 =?us-ascii?Q?uTjt/wqE87xsBj0uRMtZJVzy0eSvprtS8En0sy8qUQgP8lICPPgHIImFYM/q?=
 =?us-ascii?Q?bhXQz9+PK/9qXv3lyqlzOXhqG9mblN5mUqnJc0Bw6D16KyUbOlmrIKk/LF6o?=
 =?us-ascii?Q?mrK7OdhZCeFPkEb3fjMR08z268smI2VodTZ4eCX41OFSYWBp0v+SVzp7Rs/a?=
 =?us-ascii?Q?aso7XZ7+VWCAbC0xHofE7B5iJ34am+fInM5pg2RED0BnWiHUojClItyYouBi?=
 =?us-ascii?Q?Vgm26Qv5X0ZZjPRTY8oTKnQFAAiOcqDsLrQBsn+ZHPPGPnvK4oceylwW+g2Z?=
 =?us-ascii?Q?KXUvTRyQrSxJLKozth0jmAhWpUYf7gl2HPsCM/d6+lb3aeNwIAa1n1hW50wI?=
 =?us-ascii?Q?TTa66ilagepyqQXdHlloj8OhPMhjYxubJ8xcNj2hPH4AbDrsAVxBzOOjBzBF?=
 =?us-ascii?Q?E95wVxI2m0zfpswiU2UNVwy9cCZUc5NP5/R6wX+AkYVVApXnM74x4s8bTIpZ?=
 =?us-ascii?Q?o3AjgkRQ+jl7uC8JaiEjOnc+sSBvbAgatQsG7/WJRJotack7wVo2w97idt0U?=
 =?us-ascii?Q?cW8bTwLiKo5UFFMlfvA5JPvn2Yr8OSLK0mCTVMs2BqQZHJNe7R3xtQghoOz9?=
 =?us-ascii?Q?foTKAxIB2h1RApV4nZs2lp9JhOOmYYo5e7qA1gQzZlDy17JD0sNo6vQ+iDSD?=
 =?us-ascii?Q?Fulok/I16zZquPzk5J1P8sy3v/A+yUDEVMQJN4zXxKEbqAopHem43RXHU+T0?=
 =?us-ascii?Q?3qdeS3oqIyqXo/ZSilE6KtuRzsJFGsWwTtQcQ8sd0HEe4TigR9/Tayd5Dv32?=
 =?us-ascii?Q?6D8qWqNy0bo5NNQdi/q+xeHv6739xHmaGN1okM4u6mA79wqfIgwAfkHUNOTI?=
 =?us-ascii?Q?FIfqEp9Z1DfV748NAuBcpZX3AVV+Ehr6dIgKXenBOeUbUmLLOkA4S+/m2WPy?=
 =?us-ascii?Q?FvlIur63NLYtzroM0QLBjmn3D6hA2JY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae1c95b-7199-496b-d9a6-08da3d47dd1c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 05:40:09.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXUghE+usLPEs7pDf22zIJz34Xcm4qwVYk7KEHglmZGvWkVfSfcxcwodpn2k6Uyx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2881
X-Proofpoint-GUID: iusm6VrnqmQUzobnrVywKVR86_657C-S
X-Proofpoint-ORIG-GUID: iusm6VrnqmQUzobnrVywKVR86_657C-S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_01,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 07:15:03PM -0700, Stanislav Fomichev wrote:
> ,
> 
> On Fri, May 20, 2022 at 5:53 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, May 18, 2022 at 03:55:23PM -0700, Stanislav Fomichev wrote:
> >
> > [ ... ]
> >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index ea3674a415f9..70cf1dad91df 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -768,6 +768,10 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_
> > >  u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
> > >  void notrace __bpf_prog_exit_sleepable(struct bpf_prog *prog, u64 start,
> > >                                      struct bpf_tramp_run_ctx *run_ctx);
> > > +u64 notrace __bpf_prog_enter_lsm_cgroup(struct bpf_prog *prog,
> > > +                                     struct bpf_tramp_run_ctx *run_ctx);
> > > +void notrace __bpf_prog_exit_lsm_cgroup(struct bpf_prog *prog, u64 start,
> > > +                                     struct bpf_tramp_run_ctx *run_ctx);
> > >  void notrace __bpf_tramp_enter(struct bpf_tramp_image *tr);
> > >  void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);
> > >
> > > @@ -1035,6 +1039,7 @@ struct bpf_prog_aux {
> > >       u64 load_time; /* ns since boottime */
> > >       u32 verified_insns;
> > >       struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
> > > +     int cgroup_atype; /* enum cgroup_bpf_attach_type */
> > >       char name[BPF_OBJ_NAME_LEN];
> > >  #ifdef CONFIG_SECURITY
> > >       void *security;
> > > @@ -1107,6 +1112,12 @@ struct bpf_tramp_link {
> > >       u64 cookie;
> > >  };
> > >
> > > +struct bpf_shim_tramp_link {
> > > +     struct bpf_tramp_link tramp_link;
> > > +     struct bpf_trampoline *tr;
> > > +     atomic64_t refcnt;
> > There is already a refcnt in 'struct bpf_link'.
> > Reuse that one if possible.
> 
> I was assuming that having a per-bpf_shim_tramp_link recfnt might be
> more readable. I'll switch to the one from bpf_link per comments
> below.
> 
> > [ ... ]
> >
> > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > index 01ce78c1df80..c424056f0b35 100644
> > > --- a/kernel/bpf/trampoline.c
> > > +++ b/kernel/bpf/trampoline.c
> > > @@ -11,6 +11,8 @@
> > >  #include <linux/rcupdate_wait.h>
> > >  #include <linux/module.h>
> > >  #include <linux/static_call.h>
> > > +#include <linux/bpf_verifier.h>
> > > +#include <linux/bpf_lsm.h>
> > >
> > >  /* dummy _ops. The verifier will operate on target program's ops. */
> > >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > > @@ -497,6 +499,163 @@ int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampolin
> > >       return err;
> > >  }
> > >
> > > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
> > > +static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
> > > +                                                  bpf_func_t bpf_func)
> > > +{
> > > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > > +     struct bpf_prog *p;
> > > +
> > > +     shim_link = kzalloc(sizeof(*shim_link), GFP_USER);
> > > +     if (!shim_link)
> > > +             return NULL;
> > > +
> > > +     p = bpf_prog_alloc(1, 0);
> > > +     if (!p) {
> > > +             kfree(shim_link);
> > > +             return NULL;
> > > +     }
> > > +
> > > +     p->jited = false;
> > > +     p->bpf_func = bpf_func;
> > > +
> > > +     p->aux->cgroup_atype = prog->aux->cgroup_atype;
> > > +     p->aux->attach_func_proto = prog->aux->attach_func_proto;
> > > +     p->aux->attach_btf_id = prog->aux->attach_btf_id;
> > > +     p->aux->attach_btf = prog->aux->attach_btf;
> > > +     btf_get(p->aux->attach_btf);
> > > +     p->type = BPF_PROG_TYPE_LSM;
> > > +     p->expected_attach_type = BPF_LSM_MAC;
> > > +     bpf_prog_inc(p);
> > > +     bpf_link_init(&shim_link->tramp_link.link, BPF_LINK_TYPE_TRACING, NULL, p);
> > > +     atomic64_set(&shim_link->refcnt, 1);
> > > +
> > > +     return shim_link;
> > > +}
> > > +
> > > +static struct bpf_shim_tramp_link *cgroup_shim_find(struct bpf_trampoline *tr,
> > > +                                                 bpf_func_t bpf_func)
> > > +{
> > > +     struct bpf_tramp_link *link;
> > > +     int kind;
> > > +
> > > +     for (kind = 0; kind < BPF_TRAMP_MAX; kind++) {
> > > +             hlist_for_each_entry(link, &tr->progs_hlist[kind], tramp_hlist) {
> > > +                     struct bpf_prog *p = link->link.prog;
> > > +
> > > +                     if (p->bpf_func == bpf_func)
> > > +                             return container_of(link, struct bpf_shim_tramp_link, tramp_link);
> > > +             }
> > > +     }
> > > +
> > > +     return NULL;
> > > +}
> > > +
> > > +static void cgroup_shim_put(struct bpf_shim_tramp_link *shim_link)
> > > +{
> > > +     if (shim_link->tr)
> > I have been spinning back and forth with this "shim_link->tr" test and
> > the "!shim_link->tr" test below with an atomic64_dec_and_test() test
> > in between  :)
> 
> I did this dance so I can call cgroup_shim_put from
> bpf_trampoline_link_cgroup_shim, I guess that's confusing.
> bpf_trampoline_link_cgroup_shim can call cgroup_shim_put when
> __bpf_trampoline_link_prog fails (shim_prog->tr==NULL);
> cgroup_shim_put can be also called to unlink the prog from the
> trampoline (shim_prog->tr!=NULL).
> 
> > > +             bpf_trampoline_put(shim_link->tr);
> > Why put(tr) here?
> >
> > Intuitive thinking is that should be done after __bpf_trampoline_unlink_prog(.., tr)
> > which is still using the tr.
> > or I missed something inside __bpf_trampoline_unlink_prog(..., tr) ?
> >
> > > +
> > > +     if (!atomic64_dec_and_test(&shim_link->refcnt))
> > > +             return;
> > > +
> > > +     if (!shim_link->tr)
> > And this is only for the error case in bpf_trampoline_link_cgroup_shim()?
> > Can it be handled locally in bpf_trampoline_link_cgroup_shim()
> > where it could actually happen ?
> 
> Yeah, agreed, I'll move the cleanup path to
> bpf_trampoline_link_cgroup_shim to make it less confusing here.
> 
> > > +             return;
> > > +
> > > +     WARN_ON_ONCE(__bpf_trampoline_unlink_prog(&shim_link->tramp_link, shim_link->tr));
> > > +     kfree(shim_link);
> > How about shim_link->tramp_link.link.prog, is the prog freed ?
> >
> > Considering the bpf_link_put() does bpf_prog_put(link->prog).
> > Is there a reason the bpf_link_put() not used and needs to
> > manage its own shim_link->refcnt here ?
> 
> Good catch, I've missed the bpf_prog_put(link->prog) part. Let me see
> if I can use the link's refcnt, it seems like I can define my own
> link->ops->dealloc to call __bpf_trampoline_unlink_prog and the rest
> will be taken care of.
> 
> > > +}
> > > +
> > > +int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
> > > +                                 struct bpf_attach_target_info *tgt_info)
> > > +{
> > > +     struct bpf_shim_tramp_link *shim_link = NULL;
> > > +     struct bpf_trampoline *tr;
> > > +     bpf_func_t bpf_func;
> > > +     u64 key;
> > > +     int err;
> > > +
> > > +     key = bpf_trampoline_compute_key(NULL, prog->aux->attach_btf,
> > > +                                      prog->aux->attach_btf_id);
> > > +
> > > +     err = bpf_lsm_find_cgroup_shim(prog, &bpf_func);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     tr = bpf_trampoline_get(key, tgt_info);
> > > +     if (!tr)
> > > +             return  -ENOMEM;
> > > +
> > > +     mutex_lock(&tr->mutex);
> > > +
> > > +     shim_link = cgroup_shim_find(tr, bpf_func);
> > > +     if (shim_link) {
> > > +             /* Reusing existing shim attached by the other program. */
> > > +             atomic64_inc(&shim_link->refcnt);
> > > +             /* note, we're still holding tr refcnt from above */
> > hmm... why it still needs to hold the tr refcnt ?
> 
> I'm assuming we need to hold the trampoline for as long as shim_prog
> is attached to it, right? Otherwise it gets kfreed.
Each 'attached' cgroup-lsm prog holds the shim_link's refcnt.
shim_link holds both the trampoline's and the shim_prog's refcnt.

As long as there is attached cgroup-lsm prog(s).  shim_link's refcnt
should not be zero.  The shim_link will stay and so does the
shim_link's trampoline and shim_prog.

When the last cgroup-lsm prog is detached, bpf_link_put() should
unlink itself (and its shim_prog) from the trampoline first and
then do a bpf_trampoline_put(tr) and bpf_prog_put(shim_prog).
I think bpf_tracing_link_release() is doing something similar also.
