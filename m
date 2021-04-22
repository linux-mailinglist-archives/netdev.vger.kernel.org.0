Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1D1367812
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 05:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhDVDoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 23:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhDVDoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 23:44:17 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACDCC06174A;
        Wed, 21 Apr 2021 20:43:43 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 82so49770577yby.7;
        Wed, 21 Apr 2021 20:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K1J7Jfo/p7F7g43mZ89qDgWCtyHJyA7natQZcpgvdy4=;
        b=TYG7C+bApbwT5r7qKjeMiPU0Pxt5pVeu/KJFDvacPBDtp7IO7AvijfOH3V5IXB0BGd
         8KGPzxL2d64OxXeFnU9XC5hk2aLs3vm2jbM4J3eUtBLApvWbN5IYRuy4ul4X2FDhNrqH
         cO980r2eSFKjK9ELEP8XMUGTJs1+rNHnGQ/UlbcpTUwuBtukUbiSmNINhtZlLziY8tN+
         gnRf/qDZbOfYwsSrmdsPi69E5MWFksAxVCQHywzwJp19iqjq8fInCzIgFYphktJCK6LX
         /6xoJZjAcqceGxtQpCJNsmp96hSt6/BQYIUwVwOkwCMz4znok7U9szlWCfbskqc9tyqU
         tryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1J7Jfo/p7F7g43mZ89qDgWCtyHJyA7natQZcpgvdy4=;
        b=EvdpIBQI87k52VdU+cxzXgRQmPR1sLTI7RcliGA1csCGUci3OSmpnhwv0HgSaDqn1x
         25EGeusa6iSzAFvvqYyVq9c9ocB2SSTzkMrIQYYG/D9+5q4qeCALwY7ZUEWE+IQwWumN
         9wKEPXCNdEXcD2RBi48IRTSeWuhl5uW8YHvn3wHMbk9tuggWNmZUqRyTCmV1Y6OWzbhJ
         AkfJfG04uhmTaMWniupjGOdw2WkOkLnEuGL184Z0NHHkPc8COXHmLJpnNOWvMru2w+Jd
         K27uVBoe6uKbZ5rGNg7+WuUm9ade5CzK3TQi6XqxGO3frCnotqWkUN0oCl5/7z6djfG3
         /K3Q==
X-Gm-Message-State: AOAM533mO4mM1HhQxRTBMnPRxhe2yYaM/plAUzHUwbAmqWNdjM2UHy48
        AoEI1MA1Dvx5BxixGP4wA07FOrqiDKXVmqFoWy0=
X-Google-Smtp-Source: ABdhPJzsxNYFYSQQAlB7Zs6mLQ+lf4j8tnAMg4u9VTJHGTtCI0d4b/GKHuNIaBAIq/ksQTYPXkbSi0KQegVSLWZeiSQ=
X-Received: by 2002:a25:dc46:: with SMTP id y67mr1841106ybe.27.1619063022509;
 Wed, 21 Apr 2021 20:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210420193740.124285-1-memxor@gmail.com> <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
In-Reply-To: <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Apr 2021 20:43:31 -0700
Message-ID: <CAEf4Bzai3maV8E9eWi1fc8fgaeC7qFg7_-N_WdLH4ukv302bhg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 3:59 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/20/21 9:37 PM, Kumar Kartikeya Dwivedi wrote:
> [...]
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index bec4e6a6e31d..b4ed6a41ea70 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -16,6 +16,8 @@
> >   #include <stdbool.h>
> >   #include <sys/types.h>  // for size_t
> >   #include <linux/bpf.h>
> > +#include <linux/pkt_sched.h>
> > +#include <linux/tc_act/tc_bpf.h>
> >
> >   #include "libbpf_common.h"
> >
> > @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
> >   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> >   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> >
> > +/* Convenience macros for the clsact attach hooks */
> > +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
> > +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>
> I would abstract those away into an enum, plus avoid having to pull in
> linux/pkt_sched.h and linux/tc_act/tc_bpf.h from main libbpf.h header.
>
> Just add a enum { BPF_TC_DIR_INGRESS, BPF_TC_DIR_EGRESS, } and then the
> concrete tc bits (TC_H_MAKE()) can be translated internally.
>
> > +struct bpf_tc_opts {
> > +     size_t sz;
>
> Is this set anywhere?
>
> > +     __u32 handle;
> > +     __u32 class_id;
>
> I'd remove class_id from here as well given in direct-action a BPF prog can
> set it if needed.
>
> > +     __u16 priority;
> > +     bool replace;
> > +     size_t :0;
>
> What's the rationale for this padding?
>
> > +};
> > +
> > +#define bpf_tc_opts__last_field replace
> > +
> > +/* Acts as a handle for an attached filter */
> > +struct bpf_tc_attach_id {
>
> nit: maybe bpf_tc_ctx

ok, so wait. It seems like apart from INGRESS|EGRESS enum and ifindex,
everything else is optional and/or has some sane defaults, right? So
this bpf_tc_attach_id or bpf_tc_ctx seems a bit artificial construct
and it will cause problems for extending this.

So if my understanding is correct, I'd get rid of it completely. As I
said previously, opts allow returning parameters back, so if user
didn't specify handle and priority and kernel picks values on user's
behalf, we can return them in the same opts fields.

For detach, again, ifindex and INGRESS|EGRESS is sufficient, but if
user want to provide more detailed parameters, we should do that
through extensible opts. That way we can keep growing this easily,
plus simple cases will remain simple.

Similarly bpf_tc_info below, there is no need to have struct
bpf_tc_attach_id id; field, just have handle and priority right there.
And bpf_tc_info should use OPTS framework for extensibility (though
opts name doesn't fit it very well, but it is still nice for
extensibility and for doing optional input/output params).

Does this make sense? Am I missing something crucial here?

The general rule with any new structs added to libbpf APIs is to
either be 100% (ok, 99.99%) sure that they will never be changed, or
do forward/backward compatible OPTS. Any other thing is pain and calls
for symbol versioning, which we are trying really hard to avoid.

>
> > +     __u32 handle;
> > +     __u16 priority;
> > +};
> > +
> > +struct bpf_tc_info {
> > +     struct bpf_tc_attach_id id;
> > +     __u16 protocol;
> > +     __u32 chain_index;
> > +     __u32 prog_id;
> > +     __u8 tag[BPF_TAG_SIZE];
> > +     __u32 class_id;
> > +     __u32 bpf_flags;
> > +     __u32 bpf_flags_gen;
>
> Given we do not yet have any setters e.g. for offload, etc, the one thing
> I'd see useful and crucial initially is prog_id.
>
> The protocol, chain_index, and I would also include tag should be dropped.
> Similarly class_id given my earlier statement, and flags I would extend once
> this lib API would support offloading progs.
>
> > +};
> > +
> > +/* id is out parameter that will be written to, it must not be NULL */
> > +LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
> > +                          const struct bpf_tc_opts *opts,
> > +                          struct bpf_tc_attach_id *id);
> > +LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
> > +                          const struct bpf_tc_attach_id *id);
> > +LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
> > +                            const struct bpf_tc_attach_id *id,
> > +                            struct bpf_tc_info *info);
>
> As per above, for parent_id I'd replace with dir enum.
>
> > +
> >   #ifdef __cplusplus
> >   } /* extern "C" */
> >   #endif
