Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2C157C1B3
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiGUAlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiGUAlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:41:06 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86086753B2
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 17:41:05 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id m16so240690qka.12
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 17:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NLPMp1+Mt0L/+E6R8JU+BLoZczUGaly/ZIP7N/DIUjk=;
        b=c/VUBK2QvK2vfwdHRofaHZt9HYM7EXslS5s2wi+6Jwim5NYju5JdGCOAHrTetv5xzX
         P6KxFVcy1D5RFcg/Lvl97dO+5pxv0GXUlzN44Cy5TuZ/gA81BWqp9haTPUM6xx64N0bs
         SHW6Vm0sBminmKxtKqvJupkRFTQNNDwJV4AcYgtn0fbG/utFhqyLDZJA1eq3+H7nQ+j7
         BJsTZb0EboDNRuH2YyK6pgTy5VpPPpWotY6gCwtNSxHpU8gv/rBsdETPlA3GXuCsgPb9
         76rbDja4enOdfJIlMTAQPtwAl4IndOKluUlnQfdcLMztE4Dp/VpnhnLxp0iOhX56xuDc
         ggBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NLPMp1+Mt0L/+E6R8JU+BLoZczUGaly/ZIP7N/DIUjk=;
        b=nU9fE82IBZUVLNP2ju7n7xZrFcldEKkFxWy3hkEJJ/TxXfS4Khn+oMdGufVPSlXmHE
         0FCu/C05klfvehBdk0Kt+yOk+bvJ06Mt0B8QAOzH9lv/egfYC8L4pGbHYpMtotsi4p71
         TxtejhLkAsy+QThSyw8Mv+yNrBKCOuSSIfrGLwxaO4ORiVNgxdYKMRxr1NrBfLzdtTIi
         8XZ+VIDYhsfHI3WI9IlNnAJ9CFCiQoIUtVlgCOqbzbtxu3uVkser1f5H9P6U4A2h3UPa
         Y07UblsTJmqowvaGb6/qo2IReHUlPdLFuMxZByy7a8fcybmkLMI6ijcRoTfhTPVwOIN7
         AYiQ==
X-Gm-Message-State: AJIora+5fx2WUgRwuuTwryDD9wRkDfFreSqMAWDpIovq2eZL4xUAzfnX
        y6MytroCqfeLRoS2AzEJ9MFjHnyzCCx/wRFCqKI0Uw==
X-Google-Smtp-Source: AGRyM1t7L3IvjLTHGAVSqlP7orZ4xN16eJegyERHUQa/h5YTRHg7oWqGSwg34qaRWfWGU6zWV64OePdr5YgV/f6wBcM=
X-Received: by 2002:a05:620a:4590:b0:6b5:e884:2d2c with SMTP id
 bp16-20020a05620a459000b006b5e8842d2cmr12236347qkb.267.1658364064440; Wed, 20
 Jul 2022 17:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com> <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com> <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
 <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com>
In-Reply-To: <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 20 Jul 2022 17:40:53 -0700
Message-ID: <CA+khW7jp+0AadVagqCcV8ELNRphP47vJ6=jGyuMJGnTtYynF+Q@mail.gmail.com>
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

On Mon, Jul 11, 2022 at 8:45 PM Yonghong Song <yhs@fb.com> wrote:
>
> On 7/11/22 5:42 PM, Hao Luo wrote:
[...]
> >>>> +
> >>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> >>>> +{
> >>>> +    struct cgroup_iter_priv *p = seq->private;
> >>>> +
> >>>> +    mutex_lock(&cgroup_mutex);
> >>>> +
> >>>> +    /* support only one session */
> >>>> +    if (*pos > 0)
> >>>> +        return NULL;
> >>>
> >>> This might be okay. But want to check what is
> >>> the practical upper limit for cgroups in a system
> >>> and whether we may miss some cgroups. If this
> >>> happens, it will be a surprise to the user.
> >>>
> >
> > Ok. What's the max number of items supported in a single session?
>
> The max number of items (cgroups) in a single session is determined
> by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
> depends on how much data bpf program intends to send to user space.
> If each bpf program run intends to send 64B to user space, e.g., for
> cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write
> rate, read/write rate. Then each session can support 512 cgroups.
>

Hi Yonghong,

Sorry about the late reply. It's possible that the number of cgroup
can be large, 1000+, in our production environment. But that may not
be common. Would it be good to leave handling large number of cgroups
as follow up for this patch? If it turns out to be a problem, to
alleviate it, we could:

1. tell users to write program to skip a certain uninteresting cgroups.
2. support requesting large kernel_buffer_size for bpf_iter, maybe as
a new bpf_iter flag.

Hao

> >
[...]
> >>> [...]
