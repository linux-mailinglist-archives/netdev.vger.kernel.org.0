Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F1A2EF7E9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbhAHTJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbhAHTJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 14:09:38 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBDBC061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 11:08:58 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id f26so9464543qka.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 11:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e1ptPpvUKZAEmkxoGSuS3Gaph4gB+fAlz3VQZrfvkt0=;
        b=On4jIaKZ77RgR+pNzZI7MB4oTZ35yWxCdD2kHdYbphylvihUKBsLzgjd2GLsP3i5au
         kD5xs1DRhevoert0cxwYHurG4W1QjR5HIVTdVME+/yWNM1MNfBup3lpUvYE6tsvJkbSc
         sNbNl5K3IyrTy4jsE61qkV/CzbxTvMUlb/Sziu/KKNeqiMsnrFIYsJVJ99C2PcsS+mhw
         uL4EgQV4/AxFfCfIxr1skv1N8mkkq/1Yu2JEe2iZLTjrCiwZQlKXIv1JEFSG2gzWIdJ9
         RtSStrTtRoOuQrux7DwTFoq4Fzs4LrK+GLZ2x2pjgXkxHaWQd3NqbjNvVdI/BL7KUjoK
         TU8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e1ptPpvUKZAEmkxoGSuS3Gaph4gB+fAlz3VQZrfvkt0=;
        b=V9vG7Vmg0fvotjp66DYmm2kCDaOjF4rViU5U/HBV6WYKeTvRwhqaDYNeve7w0le6Uf
         LiK7i7+W4VGh0bapGHeCTNsJV/6SfFcQxolIdiCTKFWcImCmlLcsWb+2phx7f+2fDzOE
         nkyaRPs901w04oVPHkwaUvyPRjOoJMSV5XjXG6/OaOZqhclmd1iRZlt9+DIVjjv0S86W
         l4v2DUmmJJCXkkYE7OIyp7ZPbjhcSbZiArdBzchetwXvvmMY/22izf2LR22mrO78NVJ0
         Rgcz52f7yVC3RJHOgzY0RDU8K3ksRBATb3JnAx2gSrljQLDU2znTPAVTpBj+mHQkUk5J
         eLYQ==
X-Gm-Message-State: AOAM533Nh5h0BiS3X3BVGEVu1/phii2p8A93jjWDsES7KEh1dhWKUsct
        AOvtixkVwMNhJQ87G9BlDxOxdOK3ES3tLovQFr5nkLCvUCipaw==
X-Google-Smtp-Source: ABdhPJyQe+wRvGDfQv4ypZPEoJEDfWtkm6YPrJ4OZn0z9kjZBgCO12W7hYcQuBMK+j2Xl2UjwkQ7XSgqRyM8NE0lzD0=
X-Received: by 2002:a05:620a:22ab:: with SMTP id p11mr5381316qkh.237.1610132937641;
 Fri, 08 Jan 2021 11:08:57 -0800 (PST)
MIME-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com> <20210108180333.180906-2-sdf@google.com>
 <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
 <CAKH8qBsWsKVxAyvhEYqXytTFMGEN=C3ZMKBPLs2RKcEpM4hXXQ@mail.gmail.com> <CANn89iKv1aKE3Tcyr-vqv2mHeDompWjUn6txeK-qEO6-G-pBBw@mail.gmail.com>
In-Reply-To: <CANn89iKv1aKE3Tcyr-vqv2mHeDompWjUn6txeK-qEO6-G-pBBw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 8 Jan 2021 11:08:46 -0800
Message-ID: <CAKH8qBuGi_7eFpX0y+HdJznMvUxZsrJtdz2O5P4WK-4H_8s8Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 10:41 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 7:26 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Fri, Jan 8, 2021 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Fri, Jan 8, 2021 at 7:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > > 3% overhead for locking/unlocking the socket.
> > > >
> > > > Without this patch:
> > > >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> > > >             |
> > > >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> > > >                        |
> > > >                         --0.81%--__kmalloc
> > > >
> > > > With the patch applied:
> > > >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> > > >
> > >
> > >
> > > OK but we are adding yet another indirect call.
> > >
> > > Can you add a patch on top of it adding INDIRECT_CALL_INET() avoidance ?
> > Sure, but do you think it will bring any benefit?
>
> Sure, avoiding an indirect call might be the same gain than the
> lock_sock() avoidance :)
>
> > We don't have any indirect avoidance in __sys_getsockopt for the
> > sock->ops->getsockopt() call.
> > If we add it for this new bpf_bypass_getsockopt, we might as well add
> > it for sock->ops->getsockopt?
>
> Well, that is orthogonal to this patch.
> As you may know, Google kernels do have a mitigation there already and
> Brian may upstream it.
I guess my point here was that if I send it out only for bpf_bypass_getsockopt
it might look a bit strange because the rest of the getsockopt still
suffers the indirect costs. If Brian has plans to upstream the rest, maybe
it's better to upstream everything together with some numbers?
CC'ing him for his opinion.

I'm happy to follow up in whatever form is best. I can also resend
with INDIRECT_CALL_INET2 if there are no objections in including
this version from the start.

> > And we need some new INDIRECT_CALL_INET2 such that f2 doesn't get
> > disabled when ipv6 is disabled :-/
>
> The same handler is called for IPv4 and IPv6, so you need the variant
> with only one known handler (tcp_bpf_bypass_getsockopt)
>
> Only it needs to make sure CONFIG_INET is enabled.
