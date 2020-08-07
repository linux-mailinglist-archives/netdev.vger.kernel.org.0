Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABB123E4F7
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgHGAKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgHGAKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 20:10:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B2BC061574;
        Thu,  6 Aug 2020 17:10:13 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x6so12646850pgx.12;
        Thu, 06 Aug 2020 17:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2AQPshyFo1NNl//hfrXQDRsmwEkSWkp/H66N0+lGonQ=;
        b=TV/1fPt4pzmkbk8n6fVQISlErv4oddDc0gmhpmsSkSTVyWPk3z8wfScyToixIc1pbW
         QEuVaVrNlGwgmo2qJL8X5Im/rd4PaR4hWfVc/2MrdymFF/0TZ9pHpcIAi2jYoq4vQfRR
         cm0I5TqMEVyRDYsrp6SwdD+Oi2FoFbsm+UVX7n7fJ5dnQnC973EeBFpllmmcw9vlACjn
         T8MeKfOea+O9EbrIGc2Kq5ZwnCp1kAJ9jCXuwaVaoBkVkHSebfUh26pqm8Ppy/B0HVRr
         Dw0wuh9IfQJBfPydqu+t647WvTZqSnb0ZWavMn/0t8+2iBVb0aKYX0yCHfjP81Tdgqf/
         y2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2AQPshyFo1NNl//hfrXQDRsmwEkSWkp/H66N0+lGonQ=;
        b=FK+Gghh6HTs6gHVtJeIQU9CbFKz/WdjIihEYC0XFK1RbYtno81h+zWsKJlLfhckskJ
         ee6ls7xjO8kMgVzrCFJZSwqgy5kYK8pmoNdJgEadiZG19BbQz0fsgOFyZV255grtO3nD
         GP8MmkXN1KFnkQeM7Y2qCD2DlgB+22V0ppvknS1LJmGpPHnrBaLeUpl37lAhtq5KoMED
         fg3GdvatJv36UQitLfXHXjq7tGaxScht4shmWBQNapBFFOYIYKD/DuklXHgMjwlGXMXb
         MePaJNC4+m4/tAmV8DEpzV3R95U0SulxXXfR9Qh9OXLL8C1yKhJ944pURtrOkGDvQdjs
         X0FQ==
X-Gm-Message-State: AOAM530ajFejRJ8xQnB3v1++e0yyp3TTpf8NdBX7IIS3LwtTFGs7kzDD
        X1DtqJdmqoSst4f065GCGdI=
X-Google-Smtp-Source: ABdhPJzSxgukFbbaN5Y7NEuDVddRID8es05BWhuiCvVGy0cgoRCtnOmA2KleqeN5vIYKdxHWsknAxA==
X-Received: by 2002:a62:2c0e:: with SMTP id s14mr10913759pfs.289.1596759006935;
        Thu, 06 Aug 2020 17:10:06 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2a06])
        by smtp.gmail.com with ESMTPSA id f17sm9853729pfq.67.2020.08.06.17.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 17:10:06 -0700 (PDT)
Date:   Thu, 6 Aug 2020 17:10:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 7/9] selftests/bpf: add CO-RE relo test for
 TYPE_ID_LOCAL/TYPE_ID_TARGET
Message-ID: <20200807001003.tf4hv7jw7aiwi3yf@ast-mbp.dhcp.thefacebook.com>
References: <20200804182409.1512434-1-andriin@fb.com>
 <20200804182409.1512434-8-andriin@fb.com>
 <20200806223033.m5fe4cppxz5t3n54@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaSc=Q9mNhV_UpCKAk5RPQ-AssB4VrmvVy=2a83a5bL9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaSc=Q9mNhV_UpCKAk5RPQ-AssB4VrmvVy=2a83a5bL9Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 04:48:27PM -0700, Andrii Nakryiko wrote:
> On Thu, Aug 6, 2020 at 3:30 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 04, 2020 at 11:24:07AM -0700, Andrii Nakryiko wrote:
> > > +
> > > +SEC("raw_tracepoint/sys_enter")
> > > +int test_core_type_id(void *ctx)
> > > +{
> > > +     struct core_reloc_type_id_output *out = (void *)&data.out;
> > > +
> > > +     out->local_anon_struct = bpf_core_type_id_local(struct { int marker_field; });
> > > +     out->local_anon_union = bpf_core_type_id_local(union { int marker_field; });
> > > +     out->local_anon_enum = bpf_core_type_id_local(enum { MARKER_ENUM_VAL = 123 });
> > > +     out->local_anon_func_proto_ptr = bpf_core_type_id_local(_Bool(*)(int));
> > > +     out->local_anon_void_ptr = bpf_core_type_id_local(void *);
> > > +     out->local_anon_arr = bpf_core_type_id_local(_Bool[47]);
> > > +
> > > +     out->local_struct = bpf_core_type_id_local(struct a_struct);
> > > +     out->local_union = bpf_core_type_id_local(union a_union);
> > > +     out->local_enum = bpf_core_type_id_local(enum an_enum);
> > > +     out->local_int = bpf_core_type_id_local(int);
> > > +     out->local_struct_typedef = bpf_core_type_id_local(named_struct_typedef);
> > > +     out->local_func_proto_typedef = bpf_core_type_id_local(func_proto_typedef);
> > > +     out->local_arr_typedef = bpf_core_type_id_local(arr_typedef);
> > > +
> > > +     out->targ_struct = bpf_core_type_id_kernel(struct a_struct);
> > > +     out->targ_union = bpf_core_type_id_kernel(union a_union);
> > > +     out->targ_enum = bpf_core_type_id_kernel(enum an_enum);
> > > +     out->targ_int = bpf_core_type_id_kernel(int);
> > > +     out->targ_struct_typedef = bpf_core_type_id_kernel(named_struct_typedef);
> > > +     out->targ_func_proto_typedef = bpf_core_type_id_kernel(func_proto_typedef);
> > > +     out->targ_arr_typedef = bpf_core_type_id_kernel(arr_typedef);
> >
> > bpf_core_type_id_kernel() returns btf_id of the type in vmlinux BTF or zero,
> > so what is the point of above tests? All targ_* will be zero.
> > Should the test find a type that actually exists in the kernel?
> > What am I missing?
> 
> Probably, that for almost all core_reloc tests, "kernel BTF" comes
> from specially-crafted BTFs, like btf__core_reloc_type_id*.c for this
> set of tests. Only one core_reloc sub-test actually loads real kernel
> BTF, for all others we have a "controlled environment" set up.

ahh. right.

> But on another note. I opted to make all type-based relocations to
> return 0 if target type is not found, but now I'm thinking that maybe
> for TYPE_SIZE and TYPE_ID_KERNEL we should fail them, just like
> field-based ones, if type is not found. Makes it harder to miss that
> something changed in the new kernel version. WDYT?

makes sense to me. If we ever need non-failing type_id_kernel() we can
add it later, right?
