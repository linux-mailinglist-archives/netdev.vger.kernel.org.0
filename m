Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC50F57D262
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiGURWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGURWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:22:07 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3465B2DAAB
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:22:06 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id id17so1420378wmb.1
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S3C8q1laz4rBJ9aGVPrsPOjt/QLLVMunUdYBJjHo4DE=;
        b=FilIoPgSWSX+M9Q5xzcjR7Bm7oSCIxKHBRehRGwnQpyGPiolhL1PxrDc/gy3NEOgOA
         WtGktAZpu/0N7X96yPfmjrLk2bK/wsS8TEOdha+N5u6sMaZkwMhw8bnIsVuTtsAWfZ9o
         htlMSo/fKYogD8FOwfdEzo5i+r75wKKrQSZlleXpxHTTDFqyRHQyrtEU3d8Qj5hwOytl
         2Vl8qkFZwE4dMFP7JDWy90fDAGFnFDYaM5yEfdAeOrfMN5c4raOQQd17eiuYR0t0J5A5
         vpib/yCSI2QQxVVS5XwklwcxvCmxO2tOy1SVFzfY7kFlxniF2kdvaqzNIhWOLJ+DZBJ+
         dnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S3C8q1laz4rBJ9aGVPrsPOjt/QLLVMunUdYBJjHo4DE=;
        b=0RnrTN5la0ezQtAzZ0aMzCBfZV0VAltkJun1eDALAE6tgqykkMkpCdFRIiMG8GiP4j
         pkz9nsJlp40be+Ngr9Cj4441xGeLjJNB6QSrUYHEHGzrkmt4RZq7dcGeuy71mgeo1gME
         0wVTvdcCnoKNhTtWduIO1mUYWGBgmpEyGmEFDSZ/nrS7PiS3zoTcNPd+Irj0bSyhvY+S
         Gzxs0rMF4xSCSiGMhJk+PIgRQmDsbxxYBL2AuytU7zYOmNWOKCGK+5C1zuT8NIEYWDa+
         mHpvsfzkp5LAfnZnf8EPqN+oJfJjmiG1pwmmsEXya8/IAO99UUwJ776CteyNwYuox7pU
         AP2A==
X-Gm-Message-State: AJIora+50XxMn4DxeBvcBRMy4mLSlqyOUIGJ66lj31jMs0rlOCfBxR1x
        pDkhj/lelR6zkV1R4h+jyTXMqtnXMwU/i62ORfhFqg==
X-Google-Smtp-Source: AGRyM1t48kSCXbpdLtCbqUKCWIaKHfAn7MwO5VCXmGix7BhsPk0uKaPuE/mS8Vwzif/e/0r5f/Ku//506/LwFKbrjMM=
X-Received: by 2002:a05:600c:354e:b0:3a3:2ede:853d with SMTP id
 i14-20020a05600c354e00b003a32ede853dmr4107316wmq.61.1658424124442; Thu, 21
 Jul 2022 10:22:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com> <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com> <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
 <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com> <CA+khW7jp+0AadVagqCcV8ELNRphP47vJ6=jGyuMJGnTtYynF+Q@mail.gmail.com>
 <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666@fb.com>
In-Reply-To: <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 21 Jul 2022 10:21:53 -0700
Message-ID: <CA+khW7ihQmjwGuVPCEuZ5EXMiMWWaxiAatmjpo1xiaWokUNRGw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
To:     Yonghong Song <yhs@fb.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 9:15 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/20/22 5:40 PM, Hao Luo wrote:
> > On Mon, Jul 11, 2022 at 8:45 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> On 7/11/22 5:42 PM, Hao Luo wrote:
> > [...]
> >>>>>> +
> >>>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> >>>>>> +{
> >>>>>> +    struct cgroup_iter_priv *p = seq->private;
> >>>>>> +
> >>>>>> +    mutex_lock(&cgroup_mutex);
> >>>>>> +
> >>>>>> +    /* support only one session */
> >>>>>> +    if (*pos > 0)
> >>>>>> +        return NULL;
> >>>>>
> >>>>> This might be okay. But want to check what is
> >>>>> the practical upper limit for cgroups in a system
> >>>>> and whether we may miss some cgroups. If this
> >>>>> happens, it will be a surprise to the user.
> >>>>>
> >>>
> >>> Ok. What's the max number of items supported in a single session?
> >>
> >> The max number of items (cgroups) in a single session is determined
> >> by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
> >> depends on how much data bpf program intends to send to user space.
> >> If each bpf program run intends to send 64B to user space, e.g., for
> >> cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write
> >> rate, read/write rate. Then each session can support 512 cgroups.
> >>
> >
> > Hi Yonghong,
> >
> > Sorry about the late reply. It's possible that the number of cgroup
> > can be large, 1000+, in our production environment. But that may not
> > be common. Would it be good to leave handling large number of cgroups
> > as follow up for this patch? If it turns out to be a problem, to
> > alleviate it, we could:
> >
> > 1. tell users to write program to skip a certain uninteresting cgroups.
> > 2. support requesting large kernel_buffer_size for bpf_iter, maybe as
> > a new bpf_iter flag.
>
> Currently if we intend to support multiple read() for cgroup_iter,
> the following is a very inefficient approach:
>
> in seq_file private data structure, remember the last cgroup visited
> and for the second read() syscall, do the traversal again (but not
> calling bpf program) until the last cgroup and proceed from there.
> This is inefficient and probably works. But if the last cgroup is
> gone from the hierarchy, that the above approach won't work. One
> possibility is to remember the last two cgroups. If the last cgroup
> is gone, check the 'next' cgroup based on the one before the last
> cgroup. If both are gone, we return NULL.
>

I suspect in reality, just remembering the last cgroup (or two
cgroups) may not be sufficient. First, I don't want to hold
cgroup_mutex across multiple sessions. I assume it's also not safe to
release cgroup_mutex in the middle of walking cgroup hierarchy.
Supporting multiple read() can be nasty for cgroup_iter.

> But in any case, if there are additional cgroups not visited,
> in the second read(), we should not return NULL which indicates
> done with all cgroups. We may return EOPNOTSUPP to indicate there
> are missing cgroups due to not supported.
>
> Once users see EOPNOTSUPP which indicates there are missing
> cgroups, they can do more filtering in bpf program to avoid
> large data volume to user space.
>

Makes sense. Yonghong, one question to confirm, if the first read()
overflows, does the user still get partial data?

I'll change the return code to EOPNOTSUPP in v4 of this patchset.

> To provide a way to truely visit *all* cgroups,
> we can either use bpf_iter link_create->flags
> to increase the buffer size as your suggested in the above so
> user can try to allocate more kernel buffer size. Or implement
> proper second read() traversal which I don't have a good idea
> how to do it efficiently.

I will try the buffer size increase first. Looks more doable. Do you
mind putting this support as a follow-up?

> >
> > Hao
> >
> >>>
> > [...]
> >>>>> [...]
