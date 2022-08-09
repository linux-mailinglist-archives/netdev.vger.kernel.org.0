Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0458DBD6
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244995AbiHIQXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244993AbiHIQXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:23:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205EE6251;
        Tue,  9 Aug 2022 09:23:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 17so2442874pli.0;
        Tue, 09 Aug 2022 09:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KPF9jJthpkSS8i+2ec4VCDR6ruiQYT7BB/BfF0hTGCI=;
        b=MazbakfgpnQfwNY5eQB/huB8HLV7jzX0r75+SG64MdNIbpBmsHKTBW0rjBuVWOA/rK
         KHhHi4zbURw57Ai+qxPlQHwPA7e62bR1MsMeUIFFHzLjFbeJT9KHS/9SvgiL4y4T5IPY
         q88iQVrU97Zb4/aeByFYKDU796Qm2OCAtzTAt78ce0DJttBXx2avWvCyaKcesnHLZfAP
         rK27o/dcJK7ZREF+N6m6B6W38Pbu6LlzFayb/FxmUCLvFFpKdRGD/XwGHCwInSAqpBrF
         DTtmPeeLQwiYRGuGoHsSpJBMDBEl1omGw2eNikwBI/g13BTDFjL/D0R2qE4oki0xXAa8
         Qi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KPF9jJthpkSS8i+2ec4VCDR6ruiQYT7BB/BfF0hTGCI=;
        b=PGhkWYkaN3QzuEzuxnfAYU0JsW3T87YvZ4ge0o6h+v8ScnNuqWA+s9SxjeHJBriQcB
         p8vDckZNqe3x1DJtNNEynASVc6IqBPJ8guAlhpzPqlpykh9H4nb9XfBULJu8CO9ehPVg
         cFq25COTVIWVV6ARHX1cwpUstz0m81SBwHkYx8qQ9kvoegIYIA6DfpxCGe7s0ydtQKj1
         f8oSHVoTZBzNBpZwT+92o4AGMNLygR7gh/ksfMwZCpZefoYYXH6NFJYgAz4h74QWGxek
         Pt1IiYeDHOpSsw11n3oSFJLVV2MhdiB1QtxssSVvR5lyjp8af2WuXZZaCV9bNaC7mauP
         DUDg==
X-Gm-Message-State: ACgBeo0eltfOfiMJkX6/s4G9p+ThBtL/ZV31fahcYh0NqG+opQ/hTJJT
        HMg1kZy/t84UA77kFuk8gTQ=
X-Google-Smtp-Source: AA6agR7ktdxwJIVS/F/yiwj3MSGrqNq/ifDSCYBzdEg5uGp7t6TItuDRsqr3l/5v5ao8CW8p9ZlmBw==
X-Received: by 2002:a17:902:8683:b0:171:3114:7678 with SMTP id g3-20020a170902868300b0017131147678mr624478plo.172.1660062209335;
        Tue, 09 Aug 2022 09:23:29 -0700 (PDT)
Received: from MacBook-Pro-3.local.dhcp.thefacebook.com ([2620:10d:c090:500::2:2e69])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902d50700b0016c78f9f024sm11342520plg.104.2022.08.09.09.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 09:23:28 -0700 (PDT)
Date:   Tue, 9 Aug 2022 09:23:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hao Luo <haoluo@google.com>
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
Subject: Re: [PATCH bpf-next v7 4/8] bpf: Introduce cgroup iter
Message-ID: <20220809162325.hwgvys5n3rivuz7a@MacBook-Pro-3.local.dhcp.thefacebook.com>
References: <20220805214821.1058337-1-haoluo@google.com>
 <20220805214821.1058337-5-haoluo@google.com>
 <CAEf4BzZHf89Ds8nQWFCH00fKs9-9GkJ0d+Hrp-LkMCDUP_td0A@mail.gmail.com>
 <CA+khW7hUVOkHBO3dhRze2_VKZuxD-LuNQdO3nHUkLCYmuuR6eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+khW7hUVOkHBO3dhRze2_VKZuxD-LuNQdO3nHUkLCYmuuR6eg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 05:56:57PM -0700, Hao Luo wrote:
> On Mon, Aug 8, 2022 at 5:19 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > >
> > >  - walking a cgroup's descendants in pre-order.
> > >  - walking a cgroup's descendants in post-order.
> > >  - walking a cgroup's ancestors.
> > >  - process only the given cgroup.
> > >
> > > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > > created from attaching. This cgroup is passed as a file descriptor
> > > or cgroup id and serves as the starting point of the walk. If no
> > > cgroup is specified, the starting point will be the root cgroup v2.
> > >
> > > For walking descendants, one can specify the order: either pre-order or
> > > post-order. For walking ancestors, the walk starts at the specified
> > > cgroup and ends at the root.
> > >
> > > One can also terminate the walk early by returning 1 from the iter
> > > program.
> > >
> > > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > > program is called with cgroup_mutex held.
> > >
> > > Currently only one session is supported, which means, depending on the
> > > volume of data bpf program intends to send to user space, the number
> > > of cgroups that can be walked is limited. For example, given the current
> > > buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > > cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> > > be walked is 512. This is a limitation of cgroup_iter. If the output
> > > data is larger than the kernel buffer size, after all data in the
> > > kernel buffer is consumed by user space, the subsequent read() syscall
> > > will signal EOPNOTSUPP. In order to work around, the user may have to
> > > update their program to reduce the volume of data sent to output. For
> > > example, skip some uninteresting cgroups. In future, we may extend
> > > bpf_iter flags to allow customizing buffer size.
> > >
> > > Acked-by: Yonghong Song <yhs@fb.com>
> > > Acked-by: Tejun Heo <tj@kernel.org>
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  include/linux/bpf.h                           |   8 +
> > >  include/uapi/linux/bpf.h                      |  38 +++
> > >  kernel/bpf/Makefile                           |   3 +
> > >  kernel/bpf/cgroup_iter.c                      | 286 ++++++++++++++++++
> > >  tools/include/uapi/linux/bpf.h                |  38 +++
> > >  .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
> > >  6 files changed, 375 insertions(+), 2 deletions(-)
> > >  create mode 100644 kernel/bpf/cgroup_iter.c
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 20c26aed7896..09b5c2167424 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -48,6 +48,7 @@ struct mem_cgroup;
> > >  struct module;
> > >  struct bpf_func_state;
> > >  struct ftrace_ops;
> > > +struct cgroup;
> > >
> > >  extern struct idr btf_idr;
> > >  extern spinlock_t btf_idr_lock;
> > > @@ -1730,7 +1731,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
> > >         int __init bpf_iter_ ## target(args) { return 0; }
> > >
> > >  struct bpf_iter_aux_info {
> > > +       /* for map_elem iter */
> > >         struct bpf_map *map;
> > > +
> > > +       /* for cgroup iter */
> > > +       struct {
> > > +               struct cgroup *start; /* starting cgroup */
> > > +               int order;
> > > +       } cgroup;
> > >  };
> > >
> > >  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 59a217ca2dfd..4d758b2e70d6 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
> > >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> > >  };
> > >
> > > +enum bpf_iter_order {
> > > +       BPF_ITER_ORDER_DEFAULT = 0,     /* default order. */
> >
> > why is this default order necessary? It just adds confusion (I had to
> > look up source code to know what is default order). I might have
> > missed some discussion, so if there is some very good reason, then
> > please document this in commit message. But I'd rather not do some
> > magical default order instead. We can set 0 to mean invalid and error
> > out, or just do SELF as the very first value (and if user forgot to
> > specify more fancy mode, they hopefully will quickly discover this in
> > their testing).
> >
> 
> PRE/POST/UP are tree-specific orders. SELF applies on all iters and
> yields only a single object. How does task_iter express a non-self
> order? By non-self, I mean something like "I don't care about the
> order, just scan _all_ the objects". And this "don't care" order, IMO,
> may be the common case. I don't think everyone cares about walking
> order for tasks. The DEFAULT is intentionally put at the first value,
> so that if users don't care about order, they don't have to specify
> this field.
> 
> If that sounds valid, maybe using "UNSPEC" instead of "DEFAULT" is better?

I agree with Andrii.
This:
+       if (order == BPF_ITER_ORDER_DEFAULT)
+               order = BPF_ITER_DESCENDANTS_PRE;

looks like an arbitrary choice.
imo
BPF_ITER_DESCENDANTS_PRE = 0,
would have been more obvious. No need to dig into definition of "default".

UNSPEC = 0
is fine too if we want user to always be conscious about the order
and the kernel will error if that field is not initialized.
That would be my preference, since it will match the rest of uapi/bpf.h

I applied the first 3 patches to ease respin.
Thanks!
