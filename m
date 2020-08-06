Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F4423E4C0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgHFXsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFXsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:48:39 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E534FC061574;
        Thu,  6 Aug 2020 16:48:38 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q16so56222ybk.6;
        Thu, 06 Aug 2020 16:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tPB4LQVsdG8CBfEwgKpmNDeAiLlxqdByOFFXNmufjps=;
        b=NxHD3B9jiJs2Z27ohDZpMNEHOhMVQNFXiMnx7jQgtke0OdlDNSQA3hS9vR9vueL57W
         TQZ3C6WYbde6ZApQKfALNjX0T66G7nHof6OIh92VVMg8DEoeUjdeeJ23hRZQb91JQbgY
         WX595xeo3rNGQ4jO8FTWJ14rt7w5pzsT89bUCgziPLYsc7quxIksLuTAv1iSFJHJkrtl
         9bXrQgRrdnV4tzexrDTxO4CQ+f8aEcHv2QXi0LP7zmWiFRzmARYj7ZaQXm7Px40uNIsR
         i9sQEllP2WBk4gWfOmInwEmV5EIfhRu5PPsOcCidt1m2DER60ZidQn8qvLgRyqHQS02f
         KXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tPB4LQVsdG8CBfEwgKpmNDeAiLlxqdByOFFXNmufjps=;
        b=qVcKGUnsBL6os13YQWZaofdjnbQaF1g56BviUSxTzYbwEeS6Vk+Rm74xx1vhCTL5wM
         hj3oSfWwdVmXSSnN7eM4qqdB7cjqR01O/3s1aAhzwQJjQ6LmiRbXdB8LCToLFBumxQqN
         PttggmT7aGmVB138JOf7R6DMEED01OFwcviClRz783ZBZUgkUSygQynfYsaKwR1OCBBc
         vwLCXw6eBLPqsiRlK7DSZgKFXRnlXY7hoJgeYUtYh3yv9E3haNfQNPVJk/Gwx3PvbKGi
         HK7KjQ222e0mumcQ5CspD1ADcXiPu/bQnFtUqWMW4ZpTX5NUMGRal4MB5Sb+Q3uvv9vZ
         BIxA==
X-Gm-Message-State: AOAM532KPu2/Gr0uyUnwqM2E4eZYA7eJuL79T5bB/S0CH+iNRZnvv6ii
        QU499J2njUnMxLD9B+K1k/aXYg7RkjYrmpuDXFUmTlGC
X-Google-Smtp-Source: ABdhPJyu5JgD0xSWGP66tBmDNnQTzGPpDX1l5c8D54ucbHG57/RDMbl3uq2kkGyeA4vxdbLoZ+4Ygv1tVUr8eAeI7S0=
X-Received: by 2002:a25:37c8:: with SMTP id e191mr14942254yba.230.1596757718152;
 Thu, 06 Aug 2020 16:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200804182409.1512434-1-andriin@fb.com> <20200804182409.1512434-8-andriin@fb.com>
 <20200806223033.m5fe4cppxz5t3n54@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200806223033.m5fe4cppxz5t3n54@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 6 Aug 2020 16:48:27 -0700
Message-ID: <CAEf4BzaSc=Q9mNhV_UpCKAk5RPQ-AssB4VrmvVy=2a83a5bL9Q@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 7/9] selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 3:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 04, 2020 at 11:24:07AM -0700, Andrii Nakryiko wrote:
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int test_core_type_id(void *ctx)
> > +{
> > +     struct core_reloc_type_id_output *out = (void *)&data.out;
> > +
> > +     out->local_anon_struct = bpf_core_type_id_local(struct { int marker_field; });
> > +     out->local_anon_union = bpf_core_type_id_local(union { int marker_field; });
> > +     out->local_anon_enum = bpf_core_type_id_local(enum { MARKER_ENUM_VAL = 123 });
> > +     out->local_anon_func_proto_ptr = bpf_core_type_id_local(_Bool(*)(int));
> > +     out->local_anon_void_ptr = bpf_core_type_id_local(void *);
> > +     out->local_anon_arr = bpf_core_type_id_local(_Bool[47]);
> > +
> > +     out->local_struct = bpf_core_type_id_local(struct a_struct);
> > +     out->local_union = bpf_core_type_id_local(union a_union);
> > +     out->local_enum = bpf_core_type_id_local(enum an_enum);
> > +     out->local_int = bpf_core_type_id_local(int);
> > +     out->local_struct_typedef = bpf_core_type_id_local(named_struct_typedef);
> > +     out->local_func_proto_typedef = bpf_core_type_id_local(func_proto_typedef);
> > +     out->local_arr_typedef = bpf_core_type_id_local(arr_typedef);
> > +
> > +     out->targ_struct = bpf_core_type_id_kernel(struct a_struct);
> > +     out->targ_union = bpf_core_type_id_kernel(union a_union);
> > +     out->targ_enum = bpf_core_type_id_kernel(enum an_enum);
> > +     out->targ_int = bpf_core_type_id_kernel(int);
> > +     out->targ_struct_typedef = bpf_core_type_id_kernel(named_struct_typedef);
> > +     out->targ_func_proto_typedef = bpf_core_type_id_kernel(func_proto_typedef);
> > +     out->targ_arr_typedef = bpf_core_type_id_kernel(arr_typedef);
>
> bpf_core_type_id_kernel() returns btf_id of the type in vmlinux BTF or zero,
> so what is the point of above tests? All targ_* will be zero.
> Should the test find a type that actually exists in the kernel?
> What am I missing?

Probably, that for almost all core_reloc tests, "kernel BTF" comes
from specially-crafted BTFs, like btf__core_reloc_type_id*.c for this
set of tests. Only one core_reloc sub-test actually loads real kernel
BTF, for all others we have a "controlled environment" set up.

But on another note. I opted to make all type-based relocations to
return 0 if target type is not found, but now I'm thinking that maybe
for TYPE_SIZE and TYPE_ID_KERNEL we should fail them, just like
field-based ones, if type is not found. Makes it harder to miss that
something changed in the new kernel version. WDYT?
