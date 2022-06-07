Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5562E542024
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383604AbiFHARv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835343AbiFGX4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:56:16 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA42FAA74;
        Tue,  7 Jun 2022 16:16:58 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257GgADD022771;
        Tue, 7 Jun 2022 15:18:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ge55lUHQV/b/1Bgenf8r2E1VX3CPYsBNyp3KvC+L64w=;
 b=HW94/Baim+eMI/ICj8iHhIQpqZH9Xx8aVTfl2Ka94ANw0z/eUQMxMoBcxOKJ1Ywaacow
 rT3tGkTvKf0OHxcgzOAwce+MupHxrKRvsqLDMnhSOorvUuwsOR7YO5tic9Xv3cxGrG40
 lxmiSQAjN3wmeN6w2CeWfGh7riVGPa0E8bI= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gjaduj899-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 15:18:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSnlW8L/RBokyxmXaPKuXmCLAUb8SWez+kWn1Tp7mnEGALy34cksppu3DcRpJKbN2M/j4bSUZ45imPgT/FBLCDESsIq7NDbzCoEiKVOjE28ENtIeiO/fB+uRVENB0zeXNZfxNFBYnNUgoHcJDiBqnZWSgf7AZQdoyeayMu3ni/Hgagp2ID6UOtFqW5K/vskR/6fAe71Douc5HjXdDRdMZMPCua059im7JA/JhzRNEhuTCNci7ZlDfRfJJPxMA3kLMmjTHBy3ob/xuVmreJXcn6xTnvET8GRqQHjstY420Rx2q1hLepus7pXslqDcsYW8WR2jN2E11fJlx0lA/7KoNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ge55lUHQV/b/1Bgenf8r2E1VX3CPYsBNyp3KvC+L64w=;
 b=J6EQkvplpNqE9vZc1FVNCKA4OI/sumAe4uH92wOz8muzK4PpRwYmvtMcmhEZmZHgf7aNR8rNVQqvQh5tqHOry9MmLMtawoxVNBO6QCcqIwj79lZ0EMYawCKo0xhTu347sjNEYNoGqO7SNsQ7QpZ8YTSB7bQd0UIf0PWH6pDQSPqv0MzGT/82xUDB8VQ4GPYLKiszf+zjVLDUS0yehcK9lNeAiHGLro7lpBofhjsJsa2L6sv52ZX9Ept7qk1w3LJODjUqKE1lmcwxdGwBwyd6kSgSM8EgTPWuyf+vuA+SYbxpcnPHWfleSEljIFxumfk8lUJdGcakqvKR8kccrS3W+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MN2PR15MB3550.namprd15.prod.outlook.com (2603:10b6:208:1b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 22:17:58 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 22:17:58 +0000
Date:   Tue, 7 Jun 2022 15:17:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 06/11] bpf: allow writing to a subset of sock
 fields from lsm progtype
Message-ID: <20220607221756.ez4ntth5qnuev3ap@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-7-sdf@google.com>
 <20220604071808.rwzoktja73ijr3i7@kafai-mbp>
 <CAKH8qBv-cKrqvYjPh3P1JaWGLCTpBq3JtOEg+Py=a7BN_dVrPw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBv-cKrqvYjPh3P1JaWGLCTpBq3JtOEg+Py=a7BN_dVrPw@mail.gmail.com>
X-ClientProxiedBy: BY5PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::34) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d30a153-cf73-49fa-0c9f-08da48d393d4
X-MS-TrafficTypeDiagnostic: MN2PR15MB3550:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB355096E31624566D6031EFCED5A59@MN2PR15MB3550.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9iVmhrJKCA+lFfjbMnwRIas+RVGM8rWllyrr2QyS1g/Y7gJzdBasxhWDCk8q9oyN94wYR4R+rFYBBQtZbdHMgiBOV2AkquOIAb6163IvSvMJqvzHRrNUJrUarwVCf8kItqulVoPxdyjajY/jxUhY6ehCRGUEk4DOFpI8/mcXO0jgAVoKjARw67vPC7DtehhaPBbbakmAoEayN5DoTT/pi551g1mZMD199kwv5OzXJr7deuEmQmgjXloSzbm/5vn2K0AgVXCg10OKO8akB49C0aX5AZvjwX4FRV5SJKWwxkwhwU+1vIw+Vld/pB3sIRcs19PqUKrVqTity6ByZ2xUULGAHcOA+6j/eHS1xy76OeQQ62oURnbBZqm5FM0WH403c6NpdGM+pxONzB7hrDGYfXyRY1irvHzEQeIV43ftXLtpVdnac4k6iisIxmRs8VlYnaSEwsZU9GqgmBfeXfmaASQQ6yAay7Sup50eRDG8kay58Uyjd3NC+HJyuJHSYdMpQR/MB7MhQrW9DslP8E5f+col71DnyFND1q2mhnKwkDdwYIPsoVDvkO5d6w6g553eMMSF37FORbPd5je9TnL+qslI/rOnMoz/4Sl6EC02/fPMkPCW6ncydgc/98tnbVNuu0LfvPcOi5g78y00unQ3Cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(4326008)(1076003)(186003)(9686003)(6512007)(6486002)(8676002)(86362001)(316002)(38100700002)(6916009)(66946007)(66556008)(33716001)(66476007)(2906002)(5660300002)(53546011)(52116002)(6506007)(83380400001)(508600001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gMmcoAjvC0gwqjsJDfCA0yc+YeqWQWlJLkc7lL6mCivri0KzgE9dY2Uru27K?=
 =?us-ascii?Q?jQO52tdsbpoyPPGo0tgos9xFedhRZkv6jwXJE/cUpi5SeAr5O5oiuVVe+IGi?=
 =?us-ascii?Q?9gtjnJy3jYQ9BnSrBy9na6m3waZtSpDDMX+PyACNtt3zT5dRZVvYkgueHxGy?=
 =?us-ascii?Q?1iIUsf9Bo/hVcETVMnMQ4o5Rh5fepvWGusTeO8IWCXxSVG1+m1mM+F6xM/Om?=
 =?us-ascii?Q?VgF7+k+CV05fu5kM6RaUWYIwRz5z9pFmpsxF2NjMWhsOyrxPl+bSC/Rvvpns?=
 =?us-ascii?Q?yhcIHunFhZ5ooIqMk8FMXT0Qs2oUlQlBObnYH1uo8aNvUwond71nfYlEjiDB?=
 =?us-ascii?Q?pfI9/L3vDhh+7lD0rkguw+SCTxAiCGu5kbySA0JpOwq/I71tVYs2g+uxAcu5?=
 =?us-ascii?Q?lQwdiVBubV2Y3vS7kwlxbM/tr2R6uW9HTY/fWCOgV4BsXLlUS+UfUS1nyryM?=
 =?us-ascii?Q?+maCImjNcp4n3eXx69nZEzpU6BzJ/rsUUR4Gz/oUiYztaJx20vO2dxHwEQRC?=
 =?us-ascii?Q?j8SZxO6YeSzgoq3cs3PS8D1H4MaF6GGJX+g9NnZnVHT3dGVnWgM+K78Hw0qT?=
 =?us-ascii?Q?NpLc3KjREtAjh0Uai1AleZyX9LIv4oo2mBrN2QX0Zp5luzjg+Ju6nUjxSCPT?=
 =?us-ascii?Q?zFs0dFm+ZwauuRfMztd0dry2lVEWEQJHdjVRZSj4Ka2iNwRr3xDPMRoZxcyn?=
 =?us-ascii?Q?g6iK4RvJX4t4nHSH5bqQJFXh6/ACXEAAqYrERuCssNpfk035R9SsHJi0wS0H?=
 =?us-ascii?Q?9IpvPh6w9jMSeE2Lfe73dBEwhEu018mwns/FPdcOkvqG4bEwZH+keAwpSRkG?=
 =?us-ascii?Q?b0E9W1mmEbkBFwVzh77xCoTvi/TVgBxFNKstiShfxRx9J+t5HTQCNSX2rcPf?=
 =?us-ascii?Q?uzhYMC7KVFEZnm5lMtjaAmQHqImaDb2LpWtT/hyE67b3YilHcF1UPwvD/nHU?=
 =?us-ascii?Q?Cr2L+DPuJBLaceqjI+W7XD7nLPRGJa/FhR0LMG8PeLc0n+BlPEgffbU1co/C?=
 =?us-ascii?Q?+E6f7OuiuuAlNbAEEVMGORvlHpsPZWFxd6f0FFsGRRXo0vXM2VsuSQlyyEuI?=
 =?us-ascii?Q?ro4mVGWh9zreorZ0shH5t5uFxKrOq2mfIgRx8SWO8C8mXiESD2jpawhiJ833?=
 =?us-ascii?Q?56u8NcrnOTeYJcmxAYRXnHIU97TWhsMSJKo4wnuPMTklKseTBUeeYA2mPdqo?=
 =?us-ascii?Q?9qQkCUEfIQnM5IOUNg3hhly4cEP4RgOJkNFXLY8tcPFa+UeUXdUJeiDPb8Yz?=
 =?us-ascii?Q?1j8yRT3xIvyEf8G0KCgzbMrc9brSEP7g+ZNAmveBOIlr8/Et00TldLNjTpnP?=
 =?us-ascii?Q?wq0Naj3P8vHAO4lMTSdevzgNyCParibRspVqOzB52twLWwE7I36W9a8eTV8A?=
 =?us-ascii?Q?bi7CWFJQwdW4FkfdKz892hnLs7GcIU+WhCmLR6ejCXbgQSK4O4KrdEPOVmEO?=
 =?us-ascii?Q?npvaGiClq5mqDXuFb3iTmoONo+kGy8Q7gf0X6FS0Lzb+D1JEG+LHgTPDIfco?=
 =?us-ascii?Q?vbARbSh/chGyLTG5UKJJs1ZDNlPMsef1mB+adsWZJBpozf1tPraMMeddda1L?=
 =?us-ascii?Q?YmX3sm9FQmDW3MnirY3pUFJe9d5GrlnTqlCZaXcCx7KctoBBqOI/LfQ4XWAE?=
 =?us-ascii?Q?6eCuWqIEEAt7vFxqo8pJ95LtDI2TK8/sXAbNnQUk/KcWpHIQmuJzkMJ+fkaU?=
 =?us-ascii?Q?MpFnVUFe4dX0UswrFepBO7sB4pTWfyGeLgsy4j9Qe4LwUZbRrw1hSE2P8VHt?=
 =?us-ascii?Q?n4vmLC4EE+D+43XpK7l5bZnjGr6bgYk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d30a153-cf73-49fa-0c9f-08da48d393d4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 22:17:58.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQXGXeYw7ofazTh/COO+kthMkV5yLJJSD4yy1FPBX1xpxCfTgN+03vn7BmBY1Fa5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3550
X-Proofpoint-GUID: 8g-NKrVuG5qKR0Ma9jN3jS-81AQxuvt1
X-Proofpoint-ORIG-GUID: 8g-NKrVuG5qKR0Ma9jN3jS-81AQxuvt1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_10,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 03:46:29PM -0700, Stanislav Fomichev wrote:
> On Sat, Jun 4, 2022 at 12:18 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Jun 01, 2022 at 12:02:13PM -0700, Stanislav Fomichev wrote:
> > > For now, allow only the obvious ones, like sk_priority and sk_mark.
> > >
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  kernel/bpf/bpf_lsm.c  | 58 +++++++++++++++++++++++++++++++++++++++++++
> > >  kernel/bpf/verifier.c |  3 ++-
> > >  2 files changed, 60 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> > > index 83aa431dd52e..feba8e96f58d 100644
> > > --- a/kernel/bpf/bpf_lsm.c
> > > +++ b/kernel/bpf/bpf_lsm.c
> > > @@ -303,7 +303,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
> > >  const struct bpf_prog_ops lsm_prog_ops = {
> > >  };
> > >
> > > +static int lsm_btf_struct_access(struct bpf_verifier_log *log,
> > > +                                     const struct btf *btf,
> > > +                                     const struct btf_type *t, int off,
> > > +                                     int size, enum bpf_access_type atype,
> > > +                                     u32 *next_btf_id,
> > > +                                     enum bpf_type_flag *flag)
> > > +{
> > > +     const struct btf_type *sock_type;
> > > +     struct btf *btf_vmlinux;
> > > +     s32 type_id;
> > > +     size_t end;
> > > +
> > > +     if (atype == BPF_READ)
> > > +             return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
> > > +                                      flag);
> > > +
> > > +     btf_vmlinux = bpf_get_btf_vmlinux();
> > > +     if (!btf_vmlinux) {
> > > +             bpf_log(log, "no vmlinux btf\n");
> > > +             return -EOPNOTSUPP;
> > > +     }
> > > +
> > > +     type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
> > > +     if (type_id < 0) {
> > > +             bpf_log(log, "'struct sock' not found in vmlinux btf\n");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     sock_type = btf_type_by_id(btf_vmlinux, type_id);
> > > +
> > > +     if (t != sock_type) {
> > > +             bpf_log(log, "only 'struct sock' writes are supported\n");
> > > +             return -EACCES;
> > > +     }
> > > +
> > > +     switch (off) {
> > > +     case bpf_ctx_range(struct sock, sk_priority):
> > This looks wrong.  It should not allow to write at
> > any bytes of the '__u32 sk_priority'.
> 
> SG, I'll change to offsetof() and will enfoce u32 size.
> 
> > > +             end = offsetofend(struct sock, sk_priority);
> > > +             break;
> > > +     case bpf_ctx_range(struct sock, sk_mark):
> > Same here.
> >
> > Just came to my mind,
> > if the current need is only sk_priority and sk_mark,
> > do you think allowing bpf_setsockopt will be more useful instead ?
> 
> For my use-case I only need sk_priority, but I was thinking that we
> can later extend that list as needed. But you suggestion to use
> bpf_setsockopt sounds good, let me try to use that. That might be
> better than poking directly into the fields.
semi-related.
bpf_setsockopt will have more options (and more useful) in the future.
I am thinking to refactor the bpf_setsockopt() to avoid duplicate
codes between the syscall setsockopt().  With sockptr_t, that may be
easier to do now.  It will then be easier to allow most of the options
in bpf_setsockopt().

> 
> > It currently has SO_MARK, SO_PRIORITY, and other options.
> > Also, changing SO_MARK requires to clear the sk->sk_dst_cache.
> > In general, is it safe to do bpf_setsockopt in all bpf_lsm hooks ?
> 
> It seems that we might need to more strictly control it (regardless of
> helper or direct field access). Not all lsm hooks lock sk argument, so
> we so maybe start with some allowlist of attach_btf_ids that can do
> bpf_setsockopt? (I'll add existing hooks that work on new/unreferenced
> or locked sockets to the list)
Yeah, it seems a btf id list is needed.  Regardless of bpf_setsockopt()
or not, locking the sk is needed to make changes.
