Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A11589558
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbiHDAaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiHDAaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:30:07 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F10259277
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 17:30:05 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id l18so10726590qvt.13
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 17:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m6XkC9SsYbws11fU/lKUsxSKL8HIjijhC5ukFJOVAg0=;
        b=lxEIIB2x2iibG4PBjXLIXWtMcmcGyMl4ihpwyUY7PqULj9eFbsANj8sp9BO+MIUc8m
         zgNMHvRyeehg1eLXEKH5zHrm09x2KfCSBSu6bQ61eEnE7/U8ZFIDtE1DBHsg89oyx8Xi
         TzUM3+OD77maP7r32Y/hBG7zSRhgSIYYBeLg9HrW+kyLW+hNXP7nZNBWp/2n1zhfso8F
         1xMgQDUNo4e32+zlSmzj1CyN7BCj/a/ucsdHY4YiGVIc5X0eHj8/l1dm4sVUjbwNn/g1
         bdg8VkTe1CITpGeKNCaNEXdPGxxj/gQnFejEErFBpDXIlSYDeEqCFDviYLvbd692DIio
         Hz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m6XkC9SsYbws11fU/lKUsxSKL8HIjijhC5ukFJOVAg0=;
        b=ZesVcYfuqnIWpi788ceABKmBOkgB8vzOQbuwc3PXezloWC8vrOXq9ADk08gl5ObaPI
         Iip3Ik5+aKhT+L75vObPVzPEhfujZWdSbtkSnspKMQd2oVnKNz5yIcuzNYnDTPvC9mOk
         viTVeRP2VPZN/whl97Ktn80fK7hTKlarShSiwi+JBDPPNtOrX/W0oW+lSYQAd+dKwOn3
         Fxlc0vkZT609VVRNBaiYBIGIzO5DIj6khvbe+JzbtZlDklavzDoocS0PiMgNrVlqLWl7
         Q1oz0/Bh6NilroAgpUBIA6Q7h/eqvI7cuiDrrgwaV2BO2fSWOepaB+zfyfpdrVcSpAb2
         JyDA==
X-Gm-Message-State: ACgBeo3y83FGDxelrDz+tMrGwU3CFrlwdNdjOMbqBUqgeB8pIQLKx36c
        BvY4wO4Nx7PHAxgfqCB4Zrb0J1mehg1UI+J4jaVVcw==
X-Google-Smtp-Source: AA6agR6lahu4GM/VNiA4RD1/ceM/yj+jVGPjA2YZnH7aavqPzYhk9txYF8tPePFZuNAGK+/RFKNZQettinIlm70U8Dw=
X-Received: by 2002:a0c:b31a:0:b0:473:8062:b1b4 with SMTP id
 s26-20020a0cb31a000000b004738062b1b4mr24728083qve.85.1659573004159; Wed, 03
 Aug 2022 17:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAEf4BzbD38XFVxMy5crO-=+Xg7U3Vc_fB4Ntug4BEbmdLpvuDQ@mail.gmail.com>
 <CA+khW7jftQikVsc8moM6rNRqBerUHDM6WRDjb33exdbogDc7aQ@mail.gmail.com>
 <CAEf4BzYDqaTQr-S8TuLkysQ+FhT+6qMS0z=Sp_7+-wk84_4h6Q@mail.gmail.com>
 <CA+khW7jDD9p80xnZj0Z3m5oFHjb2u___NAiJkbyRgD5FKopGhg@mail.gmail.com> <CAEf4BzZhy49KLe5VG4aXZtWBExADskgA__MzhC+6k3DVgU5o5w@mail.gmail.com>
In-Reply-To: <CAEf4BzZhy49KLe5VG4aXZtWBExADskgA__MzhC+6k3DVgU5o5w@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 3 Aug 2022 17:29:53 -0700
Message-ID: <CA+khW7ggTFp8je0zwo83uGN8pKZXy+D07y+tPRRAXmY+e3pm-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
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
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Kui-Feng Lee <kuifeng@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 1:40 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Aug 3, 2022 at 1:30 PM Hao Luo <haoluo@google.com> wrote:
> >
> > On Tue, Aug 2, 2022 at 3:50 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Aug 2, 2022 at 3:27 PM Hao Luo <haoluo@google.com> wrote:
> > > >
> > > > On Mon, Aug 1, 2022 at 8:43 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Fri, Jul 22, 2022 at 10:48 AM Yosry Ahmed <yosryahmed@google.com> wrote:
[...]
> > > > > > +};
> > > > > > +
> > > > > >  union bpf_iter_link_info {
> > > > > >         struct {
> > > > > >                 __u32   map_fd;
> > > > > >         } map;
> > > > > > +
> > > > > > +       /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > > > > > +        * ancestors of a given cgroup.
> > > > > > +        */
> > > > > > +       struct {
> > > > > > +               /* Cgroup file descriptor. This is root of the subtree if walking
> > > > > > +                * descendants; it's the starting cgroup if walking the ancestors.
> > > > > > +                * If it is left 0, the traversal starts from the default cgroup v2
> > > > > > +                * root. For walking v1 hierarchy, one should always explicitly
> > > > > > +                * specify the cgroup_fd.
> > > > > > +                */
> > > > > > +               __u32   cgroup_fd;
> > > > >
> > > > > Now, similar to what I argued in regard of pidfd vs pid, I think the
> > > > > same applied to cgroup_fd vs cgroup_id. Why can't we support both?
> > > > > cgroup_fd has some benefits, but cgroup_id is nice due to simplicity
> > > > > and not having to open/close/keep extra FDs (which can add up if we
> > > > > want to periodically query something about a large set of cgroups).
> > > > > Please see my arguments from [0] above.
> > > > >
> > > > > Thoughts?
> > > > >
> > > >
> > > > We can support both, it's a good idea IMO. But what exactly is the
> > > > interface going to look like? Can you be more specific about that?
> > > > Below is something I tried based on your description.
> > > >
> > > > @@ -91,6 +91,18 @@ union bpf_iter_link_info {
> > > >         struct {
> > > >                 __u32   map_fd;
> > > >         } map;
> > > > +       struct {
> > > > +               /* PRE/POST/UP/SELF */
> > > > +               __u32 order;
> > > > +               struct {
> > > > +                       __u32 cgroup_fd;
> > > > +                       __u64 cgroup_id;
> > > > +               } cgroup;
> > > > +               struct {
> > > > +                       __u32 pid_fd;
> > > > +                       __u64 pid;
> > > > +               } task;
> > > > +       };
> > > >  };
> > > >
> > >
> > > So I wouldn't combine task and cgroup definition together, let's keep
> > > them independent.
> > >
> > > then for cgroup we can do something like:
> > >
> > > struct {
> > >     __u32 order;
> > >     __u32 cgroup_fd; /* cgroup_fd ^ cgroup_id, exactly one can be non-zero */
> > >     __u32 cgroup_id;
> > > } cgroup
> > >
> > > Similar idea with task, but it's a bit more complicated because there
> > > we have target that can be pid, pidfd, or cgroup (cgroup_fd and
> > > cgroup_id). I haven't put much thought into the best representation,
> > > though.
> > >
> >
> > The cgroup part sounds good to me. For the full picture, how about
> > this? I'm just trying  a prototype, hoping that it can help people to
> > get a clear picture.
> >
> > union bpf_iter_link_info {
> >           struct {
> >                   __u32   map_fd;
> >           } map;
> >           struct {
> >                   __u32   order; /* PRE/POST/UP/SELF */
> >                   __u32   cgroup_fd;
> >                   __u64   cgroup_id;
> >           } cgroup;
>
> lgtm
>
> >           struct {
> >                   __u32   pid;
> >                   __u32   pid_fd;
> >                   __u64   cgroup_id;
> >                   __u32   cgroup_fd;
> >                   __u32   mode; /* SELF or others */
>
> I'd move mode to be first. I'm undecided on using 4 separate fields
> for pid/pid_fd/cgroup_{id,fd} vs a single union (or just generic "u64
> target"  and then mode can define how we should treat target --
> whether it's pid, pid_fd, cgroup ID or FD. I'm fine either way, I
> think. But for cgroup case not having to duplicate PRE/POST/UP/SELF
> for cgroup id and then for cgroup fd seems like a win. So separate
> fields might be better. It's also pretty extendable. And I'm
> personally not worried about using few more bytes in bpf_attr for
> disjoin fields like this.
>

Sounds good. Thanks for clarification. Using separate fields looks
good to me. Since we settled on the cgroup part, I will apply update
in cgroup_iter v7.


> >           } task;
> > };
> >
> > > > > > +               __u32   traversal_order;
> > > > > > +       } cgroup;
> > > > > >  };
> > > > > >
> > > > > >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> > > > >
> > > > > [...]
