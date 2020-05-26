Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FDD1E2976
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgEZRyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgEZRyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:54:39 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC17C03E96D;
        Tue, 26 May 2020 10:54:38 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c12so2635147qkk.13;
        Tue, 26 May 2020 10:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hCYc7KV7Skpz/YZk+K4sEp1qqQzUr+pq6RyD+6BMZ9c=;
        b=HQ994vIws5+/lquS0/4xe3lFDvwdNu/VbARMWOnw/enVUDTm0xwL6Jzb3DjKi1p6VB
         Efwqa0X/ge0w9IdT6lpPQYuc+CFYP2ft9VHYlgGsU6Ik+IZ8/05h5M8uALn3GNOR7e6E
         7pYOXJxkxRMl0bKfnjN6vjHvGIOS2zgs9s6yB4FN9QaQzSn+ShNXvKb3QnMow7Lrt2+P
         z50N3f52p8nkoivdnMNJvgyvPD48qSfvyF8KOfRYP0wkaG7AlMU+VYApG6GL+v2KqBec
         v60pV5CslI2xzZNCOJYpUByBq02BMgf/5wxL2WQouQMSFGcH+rfahUK+OUjSPg3V6vH+
         D7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hCYc7KV7Skpz/YZk+K4sEp1qqQzUr+pq6RyD+6BMZ9c=;
        b=YJCrpeZvWqud7GemCj1J9au9t5Z5vprcAuieGXYd57geDdC2tOaWsV2TLLcBhV7sy5
         +n9+X3IJa8Kd3Mu5KcRBbR0slVFFitxkZO0WZehFLZ++VMr60/VURl716oSB11A1yH3n
         gxBCU0Wsaf+VmpLXlJbG4+jw9zjSGZzG6KEpp1xSzFZuSq07p+d0CAxJ02Pjd8wB3qoF
         AvzTscytmoVVGPuvF6WveVSeGbtfrt+wsivQrGDzTStVLTcwLOMcXpGzEGvIyykKgNWa
         bXLgAvDgkv+TrF7VL/T8pGxN37T4BqoKn9hnxOamDch88pzr6adIii5GSTI6OT5qnTMG
         HnWw==
X-Gm-Message-State: AOAM533VpHAz//LfBvalWaT7CGuk9vKyY/UiF7iA0GkNuUAdustfxroe
        Fro+IAUqym+B4hFYL8bFicfGhqCg/h0UsIphz4o=
X-Google-Smtp-Source: ABdhPJw1g7T2jfIUKzW0KqBXVwDKbkNOv+aSLcxKbJbL6XZHWFMsoxPd+J7rQRoW+xWQ+JSC56X+m5LGlckavYohd2c=
X-Received: by 2002:a05:620a:12d2:: with SMTP id e18mr2772844qkl.437.1590515677414;
 Tue, 26 May 2020 10:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200522022336.899416-1-kafai@fb.com> <20200522022342.899756-1-kafai@fb.com>
 <9c00ced2-983f-ad59-d805-777ebd1f1cab@iogearbox.net> <20200523010003.6iyavqny3aruv6u2@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200523010003.6iyavqny3aruv6u2@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 10:54:26 -0700
Message-ID: <CAEf4Bza===GwERi_x0Evf_Wjm+8=wBHnG4VHPNtZ=GPPZ+twiQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Consolidate inner-map-compatible
 properties into bpf_types.h
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 6:01 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, May 23, 2020 at 12:22:48AM +0200, Daniel Borkmann wrote:
> > On 5/22/20 4:23 AM, Martin KaFai Lau wrote:
> > [...]
> > >   };
> > > +/* Cannot be used as an inner map */
> > > +#define BPF_MAP_NO_INNER_MAP (1 << 0)
> > > +
> > >   struct bpf_map {
> > >     /* The first two cachelines with read-mostly members of which some
> > >      * are also accessed in fast-path (e.g. ops, max_entries).
> > > @@ -120,6 +123,7 @@ struct bpf_map {
> > >     struct bpf_map_memory memory;
> > >     char name[BPF_OBJ_NAME_LEN];
> > >     u32 btf_vmlinux_value_type_id;
> > > +   u32 properties;
> > >     bool bypass_spec_v1;
> > >     bool frozen; /* write-once; write-protected by freeze_mutex */
> > >     /* 22 bytes hole */
> > > @@ -1037,12 +1041,12 @@ extern const struct file_operations bpf_iter_fops;
> > >   #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
> > >     extern const struct bpf_prog_ops _name ## _prog_ops; \
> > >     extern const struct bpf_verifier_ops _name ## _verifier_ops;
> > > -#define BPF_MAP_TYPE(_id, _ops) \
> > > +#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
> > >     extern const struct bpf_map_ops _ops;
> > >   #define BPF_LINK_TYPE(_id, _name)
> > >   #include <linux/bpf_types.h>
> > >   #undef BPF_PROG_TYPE
> > > -#undef BPF_MAP_TYPE
> > > +#undef BPF_MAP_TYPE_FL
> > >   #undef BPF_LINK_TYPE
> > >   extern const struct bpf_prog_ops bpf_offload_prog_ops;
> > > diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> > > index 29d22752fc87..3f32702c9bf4 100644
> > > --- a/include/linux/bpf_types.h
> > > +++ b/include/linux/bpf_types.h
> > > @@ -76,16 +76,25 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
> > >   #endif /* CONFIG_BPF_LSM */
> > >   #endif
> > > +#define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
> > > +
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> > > -BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops)
> > > +/* prog_array->aux->{type,jited} is a runtime binding.
> > > + * Doing static check alone in the verifier is not enough,
> > > + * so BPF_MAP_NO_INNTER_MAP is needed.
> >
> > typo: INNTER
> Good catch.
>
> >
> > > + */
> > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops,
> > > +           BPF_MAP_NO_INNER_MAP)
> >
> > Probably nit, but what is "FL"? flags? We do have map_flags already, but here the
> > BPF_MAP_NO_INNER_MAP ends up in 'properties' instead. To avoid confusion, it would
> > probably be better to name it 'map_flags_fixed' since this is what it really means;
> > fixed flags that cannot be changed/controlled when creating a map.
> ok. may be BPF_MAP_TYPE_FIXED_FL?
>
> >
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops)
> > >   #ifdef CONFIG_CGROUPS
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
> > >   #endif
> > >   #ifdef CONFIG_CGROUP_BPF
> > > -BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
> > > -BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
> > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops,
> > > +           BPF_MAP_NO_INNER_MAP)
> > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops,
> > > +           BPF_MAP_NO_INNER_MAP)
> > >   #endif
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
> > > @@ -116,8 +125,10 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
> > >   BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
> > >   #if defined(CONFIG_BPF_JIT)
> > > -BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> > > +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops,
> > > +           BPF_MAP_NO_INNER_MAP)
> > >   #endif
> > > +#undef BPF_MAP_TYPE
> > >   BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> > >   BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> > [...]
> > > diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
> > > index 17738c93bec8..d965a1d328a9 100644
> > > --- a/kernel/bpf/map_in_map.c
> > > +++ b/kernel/bpf/map_in_map.c
> > > @@ -17,13 +17,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
> > >     if (IS_ERR(inner_map))
> > >             return inner_map;
> > > -   /* prog_array->aux->{type,jited} is a runtime binding.
> > > -    * Doing static check alone in the verifier is not enough.
> > > -    */
> > > -   if (inner_map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
> > > -       inner_map->map_type == BPF_MAP_TYPE_CGROUP_STORAGE ||
> > > -       inner_map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
> > > -       inner_map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
> > > +   if (inner_map->properties & BPF_MAP_NO_INNER_MAP) {
> > >             fdput(f);
> > >             return ERR_PTR(-ENOTSUPP);
> > >     }
> >
> > This whole check here is currently very fragile. For example, given we forbid cgroup
> > local storage here, why do we not forbid socket local storage? What about other maps
> > like stackmap? It's quite unclear if it even works as expected and if there's also a
> > use-case we are aware of. Why not making this an explicit opt-in?
> Re: "cgroup-local-storage", my understanding is,
> cgroup-local-storage is local to the bpf's cgroup that it is running under,
> so it is not ok for a cgroup's bpf to be able to access other cgroup's local
> storage through map-in-map, so they are excluded here.
>
> sk-local-storage does not have this restriction.  For other maps, if there is
> no known safety issue, why restricting it and create unnecessary API
> discrepancy?
>
> I think we cannot restrict the existing map either unless there is a
> known safety issue.
>
> >
> > Like explicit annotating via struct bpf_map_ops where everything is visible in one
> > single place where the map is defined:
> >
> > const struct bpf_map_ops array_map_ops = {
> >         .map_alloc_check = array_map_alloc_check,
> >         [...]
> >         .map_flags_fixed = BPF_MAP_IN_MAP_OK,
> > };
> I am not sure about adding it to bpf_map_ops instead of bpf_types.h.
> It will be easier to figure out what map types do not support MAP_IN_MAP (and
> other future map's fixed properties) in one place "bpf_types.h" instead of
> having to dig into each map src file.

I'm 100% with Daniel here. If we are consolidating such things, I'd
rather have them in one place where differences between maps are
defined, which is ops. Despite an "ops" name, this seems like a
perfect place for specifying all those per-map-type properties and
behaviors. Adding flags into bpf_types.h just splits everything into
two places: bpf_types.h specifies some differences, while ops specify
all the other ones.

Figuring out map-in-map support is just one of many questions one
might ask about differences between map types, I don't think that
justifies adding them to bpf_types.h. Grepping for struct bpf_map_ops
with search context (i.e., -A15 or something like that) should be
enough to get a quick glance at all possible maps and what they
define/override.

It also feels like adding this as bool field for each aspect instead
of a collection of bits is cleaner and a bit more scalable. If we need
to add another property with some parameter/constant, or just enum,
defining one of few possible behaviors, it would be easier to just add
another field, instead of trying to cram that into u32. It also solves
your problem of "at the glance" view of map-in-map support features.
Just name that field unique enough to grep by it :)

>
> If the objective is to have the future map "consciously" opt-in, how about
> keeping the "BPF_MAP_TYPE" name as is but add a fixed_flags param as the
> earlier v1 and flip it from NO to OK flag.  It will be clear that,
> it is a decision that the new map needs to make instead of a quiet 0
> in "struct bpf_map_ops".
>
> For example,
> BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops, BPF_MAP_IN_MAP_OK)
> BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops, 0)
> BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops, BPF_MAP_IN_MAP_OK | BPF_MAP_IN_MAP_DYNAMIC_SIZE_OK)
>
> >
> > That way, if someone forgets to add .map_flags_fixed to a new map type, it's okay since
> > it's _safe_ to forget to add these flags (and okay to add in future uapi-wise) as opposed
> > to the other way round where one can easily miss the opt-out case and potentially crash
> > the machine worst case.
