Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C0E596101
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiHPRXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiHPRXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:23:03 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B87C31B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:23:01 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id h22so8641838qtu.2
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=qWctionUyzj6xt4kfUA/bvTWqv+YiujOGN62geulnhs=;
        b=YUhA6JXtkn3+DwU5xmYJx3BO8tKPAoTXpIwkg1omyOeL/bGxPoDHCFCfocYRoFoZ+1
         JCXlzfthm3v/PjWUMXXmRSK6+a9eliRK6QIjY+tBqcsoW+PapT1LJIqYzkQH3NtfVe9/
         rfGvb8iZX290CydyrI4NtmpSBB0DIrn+xPDCWmat949IF0m0K52349jKOy/lM/aLuH8f
         Pirzs7ALSAc6TqWbGjyFNN7pvzxYsGsgpcYtAcetZDUIrCZlK+5Fu7a/w4L444Qkb4Ri
         sOz0OtOVwVKQ08Rk338pJIKS3BWhX3qUElYidKhQarvjVh/KKkARZ8PXTTMWKuc/iXmr
         1W3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=qWctionUyzj6xt4kfUA/bvTWqv+YiujOGN62geulnhs=;
        b=FxH3nlw9FRISpXgx+gDHGh4teuErULUDSumd1WkkJprRLg+e7MT7+gMPRcotWXp4H8
         TyOSKAyzyhLp9MAsUHJNRlShRAi9gNTIzkEauyb+PJ6q+BOYBKycKi3+1wxGw273uILl
         nUHgynr9uzBySLsUyvn0Faek159UZQR933ZaR16dXQNHzyrPkH8M8OpBfbC1f12JqWgb
         3FMm8hwmQObh0nvpBihLboq7i2yGZrcwJIreH9qabp0jk1AhGql9V3KyutYttY5O9Lfc
         dp6cWyhFyQ+3oKn5fpfFj9CvP6tW4yzbmkfzR5RBGFsctdhbz5AmpU/HGS+OJmUFhvK8
         bUhQ==
X-Gm-Message-State: ACgBeo14NtDjnZo1tr8Kq+OltHrDeBXjCx7JAkDOBCrOKOK0LqteAwYy
        rQh/hA0w+gLNQHh62g9gjZ1G3SM6q8H8u7CVu4/Kzw==
X-Google-Smtp-Source: AA6agR7OmWKRdE3aTmdUdA0zq7H4+MMtDS4CHSEVg0PVzhYPnHCFcYGDZoAaAY1UETa5rM5VnB8v1w+94lye6xRuXws=
X-Received: by 2002:a05:622a:1906:b0:343:55d3:54ec with SMTP id
 w6-20020a05622a190600b0034355d354ecmr19161898qtc.168.1660670580355; Tue, 16
 Aug 2022 10:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-5-haoluo@google.com>
 <CAEf4BzZHf89Ds8nQWFCH00fKs9-9GkJ0d+Hrp-LkMCDUP_td0A@mail.gmail.com>
 <CA+khW7hUVOkHBO3dhRze2_VKZuxD-LuNQdO3nHUkLCYmuuR6eg@mail.gmail.com>
 <20220809162325.hwgvys5n3rivuz7a@MacBook-Pro-3.local.dhcp.thefacebook.com>
 <CA+khW7j0kzP+W_Qgsim52J+HeR27XJcyMk73Hq93tsmNzT7q6w@mail.gmail.com>
 <CA+khW7j1Ni_PfvsGisUpUgFtgg=f_qEUVd1VUmocn6L3=kndhw@mail.gmail.com>
 <CAJD7tkY6ihK9PkaAwrdRr-3QyiVFf8h4WkLXx73zYwNUjS_7pw@mail.gmail.com>
 <CAEf4BzZTrsBOPpCTFouoWZJG9yXkz8LZgLQrqDREAY-XdGb7ew@mail.gmail.com>
 <CA+khW7gR7XWaXLHtVYE3c3HTYTNmo5gp7mETAxTg=O9-URwu0w@mail.gmail.com> <CAEf4BzZ+a2uDo_t6kGBziqdz--m2gh2_EUwkGLDtMd65uwxUjA@mail.gmail.com>
In-Reply-To: <CAEf4BzZ+a2uDo_t6kGBziqdz--m2gh2_EUwkGLDtMd65uwxUjA@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 16 Aug 2022 10:22:49 -0700
Message-ID: <CA+khW7jeEg9S1hRFdYAEEdU45my6N32YbksoTHTjhsEWNkWYZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 4/8] bpf: Introduce cgroup iter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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
        Shakeel Butt <shakeelb@google.com>
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

On Tue, Aug 16, 2022 at 10:17 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Aug 15, 2022 at 11:52 PM Hao Luo <haoluo@google.com> wrote:
> >
> > On Mon, Aug 15, 2022 at 9:13 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Thu, Aug 11, 2022 at 7:10 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> > > >
> > > > On Wed, Aug 10, 2022 at 8:10 PM Hao Luo <haoluo@google.com> wrote:
> > > > >
> > > > > On Tue, Aug 9, 2022 at 11:38 AM Hao Luo <haoluo@google.com> wrote:
> > > > > >
> > > > > > On Tue, Aug 9, 2022 at 9:23 AM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Aug 08, 2022 at 05:56:57PM -0700, Hao Luo wrote:
> > > > > > > > On Mon, Aug 8, 2022 at 5:19 PM Andrii Nakryiko
> > > > > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > > > > > > > > >
> > > > > > > > > >  - walking a cgroup's descendants in pre-order.
> > > > > > > > > >  - walking a cgroup's descendants in post-order.
> > > > > > > > > >  - walking a cgroup's ancestors.
> > > > > > > > > >  - process only the given cgroup.
> > > > > > > > > >
> > > > > > [...]
> > > > > > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > > > > > index 59a217ca2dfd..4d758b2e70d6 100644
> > > > > > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > > > > > @@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
> > > > > > > > > >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> > > > > > > > > >  };
> > > > > > > > > >
> > > > > > > > > > +enum bpf_iter_order {
> > > > > > > > > > +       BPF_ITER_ORDER_DEFAULT = 0,     /* default order. */
> > > > > > > > >
> > > > > > > > > why is this default order necessary? It just adds confusion (I had to
> > > > > > > > > look up source code to know what is default order). I might have
> > > > > > > > > missed some discussion, so if there is some very good reason, then
> > > > > > > > > please document this in commit message. But I'd rather not do some
> > > > > > > > > magical default order instead. We can set 0 to mean invalid and error
> > > > > > > > > out, or just do SELF as the very first value (and if user forgot to
> > > > > > > > > specify more fancy mode, they hopefully will quickly discover this in
> > > > > > > > > their testing).
> > > > > > > > >
> > > > > > > >
> > > > > > > > PRE/POST/UP are tree-specific orders. SELF applies on all iters and
> > > > > > > > yields only a single object. How does task_iter express a non-self
> > > > > > > > order? By non-self, I mean something like "I don't care about the
> > > > > > > > order, just scan _all_ the objects". And this "don't care" order, IMO,
> > > > > > > > may be the common case. I don't think everyone cares about walking
> > > > > > > > order for tasks. The DEFAULT is intentionally put at the first value,
> > > > > > > > so that if users don't care about order, they don't have to specify
> > > > > > > > this field.
> > > > > > > >
> > > > > > > > If that sounds valid, maybe using "UNSPEC" instead of "DEFAULT" is better?
> > > > > > >
> > > > > > > I agree with Andrii.
> > > > > > > This:
> > > > > > > +       if (order == BPF_ITER_ORDER_DEFAULT)
> > > > > > > +               order = BPF_ITER_DESCENDANTS_PRE;
> > > > > > >
> > > > > > > looks like an arbitrary choice.
> > > > > > > imo
> > > > > > > BPF_ITER_DESCENDANTS_PRE = 0,
> > > > > > > would have been more obvious. No need to dig into definition of "default".
> > > > > > >
> > > > > > > UNSPEC = 0
> > > > > > > is fine too if we want user to always be conscious about the order
> > > > > > > and the kernel will error if that field is not initialized.
> > > > > > > That would be my preference, since it will match the rest of uapi/bpf.h
> > > > > > >
> > > > > >
> > > > > > Sounds good. In the next version, will use
> > > > > >
> > > > > > enum bpf_iter_order {
> > > > > >         BPF_ITER_ORDER_UNSPEC = 0,
> > > > > >         BPF_ITER_SELF_ONLY,             /* process only a single object. */
> > > > > >         BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
> > > > > >         BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
> > > > > >         BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> > > > > > };
> > > > > >
> > > > >
> > > > > Sigh, I find that having UNSPEC=0 and erroring out when seeing UNSPEC
> > > > > doesn't work. Basically, if we have a non-iter prog and a cgroup_iter
> > > > > prog written in the same source file, I can't use
> > > > > bpf_object__attach_skeleton to attach them. Because the default
> > > > > prog_attach_fn for iter initializes `order` to 0 (that is, UNSPEC),
> > > > > which is going to be rejected by the kernel. In order to make
> > > > > bpf_object__attach_skeleton work on cgroup_iter, I think I need to use
> > > > > the following
> > > > >
> > > > > enum bpf_iter_order {
> > >
> > > so first of all, this can't be called "bpf_iter_order" as it doesn't
> > > apply to BPF iterators in general. I think this should be called
> > > bpf_iter_cgroup_order (or maybe bpf_cgroup_iter_order) and if/when we
> > > add ability to iterate tasks within cgroups then we'll just reuse enum
> > > bpf_iter_cgroup_order as an extra parameter for task iterator.
> > >
> > > And with that future case in mind I do think that we should have 0
> > > being "UNSPEC" case.
> > >
> >
> > Ok.
> >
> > > > >         BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
> > > > >         BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
> > > > >         BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> > > > >         BPF_ITER_SELF_ONLY,             /* process only a single object. */
> > > > > };
> > > > >
> > > > > So that when calling bpf_object__attach_skeleton() on cgroup_iter, a
> > > > > link can be generated and the generated link defaults to pre-order
> > > > > walk on the whole hierarchy. Is there a better solution?
> > > > >
> > >
> > > I was actually surprised that we specify these additional parameters
> > > at attach (LINK_CREATE) time, and not at bpf_iter_create() call time.
> > > It seems more appropriate to allow to specify such runtime parameters
> > > very late, when we create a specific instance of seq_file. But I guess
> > > this was done because one of the initial motivations for iterators was
> > > to be pinned in BPFFS and read as a file, so it was more convenient to
> > > store such parameters upfront at link creation time to keep
> > > BPF_OBJ_PIN simpler. I guess it makes sense, worst case you'll need to
> > > create multiple bpf_link files, one for each cgroup hierarchy you'd
> > > like to query with the same single BPF program.
> > >
> >
> > Right. That was the design from the beginning.
> >
> > > But I digress.
> > >
> > > As for not being able to auto-attach cgroup iterator. I think that's
> > > sort of expected and is in line with not being able to auto-attach
> > > cgroup programs, as you need cgroup FD at runtime. So even if you had
> > > some reasonable default order, you still would need to specify target
> > > cgroup (either through FD or ID).
> > >
> > > So... either don't do skeleton auto-attach,
> >
> > This is not okay IMHO. It would be very inconvenient to use.
> >
> > > or let's teach libbpf code
> > > to not auto-attach some iter types?
> > >
> >
> > I'm thinking of two options:
> >
> > 1. Maybe we could add libbpf APIs for disabling auto-attach just like
> > prog autoload. Like:
> >
> > bpf_program__set_auto_attach()
> > bpf_program__get_auto_attach(...)
>
> Indeed, to give more flexibility we can also add
> bpf_program__set_autoattach() and bpf_program__autoattach() (note no
> underscore and no get prefix, to be consistent with autocreate and
> autoload getters and setters). It's a pretty simple change, please
> send a separate patch for this (soon-ish would be great to make it
> into final 1.0).

Acknowledged.

> >
> > 2. In auto-attach, if the program's link is already set, attach will
> > be skipped. So, we could just manually attach, which specifies the
> > order, and set the link in skeleton. This way, no change in libbpf is
> > needed. Does this sound good to you?
> >
>
> Yes, this is one other way and is fully supported. Might be a bit less
> convenient than set_autoattach in some cases, so set_autoattach still
> makes sense, IMO.
>

Acknowledged.

> > > Alternatively, we could teach libbpf to parse some sort of cgroup
> > > iterator spec, like:
> > >
> > > SEC("iter/cgroup:/path/to/cgroup:descendants_pre")
> > >
> > > But this approach won't work for a bunch of other parameterized
> > > iterators (e.g., task iter, or map elem iter), so I'm hesitant about
> > > adding this to libbpf as a generic functionality.
> > >
> >
> > Agree. Let's explore other options first.
> >
> > > >
> > > > I think this can be handled by userspace? We can attach the
> > > > cgroup_iter separately first (and maybe we will need to set prog->link
> > > > as well) so that bpf_object__attach_skeleton() doesn't try to attach
> > > > it? I am following this pattern in the selftest in the final patch,
> > > > although I think I might be missing setting prog->link, so I am
> > > > wondering why there are no issues in that selftest which has the same
> > > > scenario that you are talking about.
> > > >
> > > > I think such a pattern will need to be used anyway if the users need
> > > > to set any non-default arguments for the cgroup_iter prog (like the
> > > > selftest), right? The only case we are discussing here is the case
> > > > where the user wants to attach the cgroup_iter with all default
> > > > options (in which case the default order will fail).
> > > > I agree that it might be inconvenient if the default/uninitialized
> > > > options don't work for cgroup_iter, but Alexei pointed out that this
> > > > matches other bpf uapis.
> > > >
> > > > My concern is that in the future we try to reuse enum bpf_iter_order
> > > > to set ordering for other iterators, and then the
> > > > default/uninitialized value (BPF_ITER_DESCENDANTS_PRE) doesn't make
> > > > sense for that iterator (e.g. not a tree). In this case, the same
> > > > problem that we are avoiding for cgroup_iter here will show up for
> > > > that iterator, and we can't easily change it at this point because
> > > > it's uapi.
> > >
> > > Yep, valid concern, I agree.
> > >
> >
> > Andrii, other than auto-attach, do you have any concern for the rest
> > of this patchset?
>
> Well, I mostly was looking at UAPIs, didn't check iteration logic
> itself. But plenty of others did and I trust they did a good job at
> that. So no, no other concerns.
>

Thanks Andrii, I will try to send set_autoattach and autoattach patch asap.

> >
> > > >
> > > >
> > > > > > and explicitly list the values acceptable by cgroup_iter, error out if
> > > > > > UNSPEC is detected.
> > > > > >
> > > > > > Also, following Andrii's comments, will change BPF_ITER_SELF to
> > > > > > BPF_ITER_SELF_ONLY, which does seem a little bit explicit in
> > > > > > comparison.
> > > > > >
> > > > > > > I applied the first 3 patches to ease respin.
> > > > > >
> > > > > > Thanks! This helps!
> > > > > >
> > > > > > > Thanks!
