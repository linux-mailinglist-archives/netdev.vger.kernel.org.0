Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868F158F64A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 05:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiHKDLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 23:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiHKDLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 23:11:00 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7CDE74
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 20:10:58 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id s11so5701241qtx.6
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 20:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=rmxwVf7t1PNS4e5hrhApn9dN42pWVfDKUXBNKpe7GPE=;
        b=OGIBZRTW1fN4NXGw414nvGJRbKag3aHq5Ziu4qj/DGZNt+s5Td7HX3QR6lPSb6HADc
         Datb70J9zakU4jgz+wRg4rl/IL4md+mq9H5HvaQpBOs3NQRm8bGlH75ErXDOvcIO6khE
         i/82PC2UyjnyduP6ecqJZpxSlRs2h+HRWC3QWdUSm3H0q5TRmo6jonEialdxv7o+UsJB
         k0Gpp6P5KZ2AjuOSl20G3N3QYh7HHV2UI8Xr7wAFsIWsHT4qicKzKPqa/cgWbNygpWoW
         5Newq4k5GZxGmuf8H0VKL3dOlxtYdNQANQ3AdU5I/0oigyJ5bIPJclNfjuRFFPM9aTQS
         mafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=rmxwVf7t1PNS4e5hrhApn9dN42pWVfDKUXBNKpe7GPE=;
        b=Grqph6SmPfzsHvbdy/niqo6TeswiHVWmQj8DcXExOSubdqUYSu5J+oJRCW61wJT4PT
         JQHuCG4yVymt+YT/eEtON0de9VbqnKXyP5d94syRkDAqYADsXz6mqdktvlMYtpy2FZJH
         cw0kKqtzSxTNxYRrIFJ8HFVEWbpWkDNBOI+np+5OPVhAZ1wTH8tv8GlcjeHe1WKCfj//
         jr1JexF0EYcixsKoVP9IsDC7Y+mht9GjH7mNIBHhXBuxnR4A5l8pltvE3yTGnHJVkx7f
         TrBu4iiSEa3ysvM0O8rEZyk8jdXeFXBZufcexyfvtNXh/1GGATXqLnXMA7YJS4eqPAa9
         P6ww==
X-Gm-Message-State: ACgBeo0L33IRJBLwwi8y/r2p6Av4hplOqPlGoDAZZB/BoKsCGNyenJGK
        uOEj/NoqWIoHKz58ZfNS0OlBSZ3RYO3jYxSpBGuMq5n21Cluh6BV
X-Google-Smtp-Source: AA6agR5uQwVDamlVJyjCUGZqvGIkRQ8eaoHoIvbB4CcDt9dlXFjB2eiGntIxzgE+9KZja1ke5pi07dzP5x3i+WE2irI=
X-Received: by 2002:ac8:57d2:0:b0:343:6785:a2e5 with SMTP id
 w18-20020ac857d2000000b003436785a2e5mr314856qta.299.1660187457913; Wed, 10
 Aug 2022 20:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-5-haoluo@google.com>
 <CAEf4BzZHf89Ds8nQWFCH00fKs9-9GkJ0d+Hrp-LkMCDUP_td0A@mail.gmail.com>
 <CA+khW7hUVOkHBO3dhRze2_VKZuxD-LuNQdO3nHUkLCYmuuR6eg@mail.gmail.com>
 <20220809162325.hwgvys5n3rivuz7a@MacBook-Pro-3.local.dhcp.thefacebook.com> <CA+khW7j0kzP+W_Qgsim52J+HeR27XJcyMk73Hq93tsmNzT7q6w@mail.gmail.com>
In-Reply-To: <CA+khW7j0kzP+W_Qgsim52J+HeR27XJcyMk73Hq93tsmNzT7q6w@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 10 Aug 2022 20:10:47 -0700
Message-ID: <CA+khW7j1Ni_PfvsGisUpUgFtgg=f_qEUVd1VUmocn6L3=kndhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 4/8] bpf: Introduce cgroup iter
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 9, 2022 at 11:38 AM Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Aug 9, 2022 at 9:23 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Aug 08, 2022 at 05:56:57PM -0700, Hao Luo wrote:
> > > On Mon, Aug 8, 2022 at 5:19 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
> > > > >
> > > > > Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > > > >
> > > > >  - walking a cgroup's descendants in pre-order.
> > > > >  - walking a cgroup's descendants in post-order.
> > > > >  - walking a cgroup's ancestors.
> > > > >  - process only the given cgroup.
> > > > >
> [...]
> > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > index 59a217ca2dfd..4d758b2e70d6 100644
> > > > > --- a/include/uapi/linux/bpf.h
> > > > > +++ b/include/uapi/linux/bpf.h
> > > > > @@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
> > > > >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> > > > >  };
> > > > >
> > > > > +enum bpf_iter_order {
> > > > > +       BPF_ITER_ORDER_DEFAULT = 0,     /* default order. */
> > > >
> > > > why is this default order necessary? It just adds confusion (I had to
> > > > look up source code to know what is default order). I might have
> > > > missed some discussion, so if there is some very good reason, then
> > > > please document this in commit message. But I'd rather not do some
> > > > magical default order instead. We can set 0 to mean invalid and error
> > > > out, or just do SELF as the very first value (and if user forgot to
> > > > specify more fancy mode, they hopefully will quickly discover this in
> > > > their testing).
> > > >
> > >
> > > PRE/POST/UP are tree-specific orders. SELF applies on all iters and
> > > yields only a single object. How does task_iter express a non-self
> > > order? By non-self, I mean something like "I don't care about the
> > > order, just scan _all_ the objects". And this "don't care" order, IMO,
> > > may be the common case. I don't think everyone cares about walking
> > > order for tasks. The DEFAULT is intentionally put at the first value,
> > > so that if users don't care about order, they don't have to specify
> > > this field.
> > >
> > > If that sounds valid, maybe using "UNSPEC" instead of "DEFAULT" is better?
> >
> > I agree with Andrii.
> > This:
> > +       if (order == BPF_ITER_ORDER_DEFAULT)
> > +               order = BPF_ITER_DESCENDANTS_PRE;
> >
> > looks like an arbitrary choice.
> > imo
> > BPF_ITER_DESCENDANTS_PRE = 0,
> > would have been more obvious. No need to dig into definition of "default".
> >
> > UNSPEC = 0
> > is fine too if we want user to always be conscious about the order
> > and the kernel will error if that field is not initialized.
> > That would be my preference, since it will match the rest of uapi/bpf.h
> >
>
> Sounds good. In the next version, will use
>
> enum bpf_iter_order {
>         BPF_ITER_ORDER_UNSPEC = 0,
>         BPF_ITER_SELF_ONLY,             /* process only a single object. */
>         BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
>         BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
>         BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> };
>

Sigh, I find that having UNSPEC=0 and erroring out when seeing UNSPEC
doesn't work. Basically, if we have a non-iter prog and a cgroup_iter
prog written in the same source file, I can't use
bpf_object__attach_skeleton to attach them. Because the default
prog_attach_fn for iter initializes `order` to 0 (that is, UNSPEC),
which is going to be rejected by the kernel. In order to make
bpf_object__attach_skeleton work on cgroup_iter, I think I need to use
the following

enum bpf_iter_order {
        BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
        BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
        BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
        BPF_ITER_SELF_ONLY,             /* process only a single object. */
};

So that when calling bpf_object__attach_skeleton() on cgroup_iter, a
link can be generated and the generated link defaults to pre-order
walk on the whole hierarchy. Is there a better solution?

> and explicitly list the values acceptable by cgroup_iter, error out if
> UNSPEC is detected.
>
> Also, following Andrii's comments, will change BPF_ITER_SELF to
> BPF_ITER_SELF_ONLY, which does seem a little bit explicit in
> comparison.
>
> > I applied the first 3 patches to ease respin.
>
> Thanks! This helps!
>
> > Thanks!
