Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB86774F6
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 01:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGZX3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 19:29:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36014 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfGZX3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 19:29:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so54321896qtc.3;
        Fri, 26 Jul 2019 16:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iP+4tXpLLeYulkhr0ZU6hQTrNg2JblROEAiYyRg4WR0=;
        b=tYVEYEgZYyhQJFBs8/vhITB4QTXcU+Ii5yBrep0rH0JawtIPtvAqHbsfjwoqc1FKWZ
         Gqh5zpyOCjO99KzLjY8Sgwa5p3yDktPb17gOWNky7v9UzlaEE4nJ3yWPjBHQI7ATKsDf
         RroR13NVs72Awy5hpSqMF1EAEkJyG6xcKsAKg0GRHW3FTHYq67NeqYu5pBqRO5a9kiDy
         4sTH855lj/4nlRRq3YitQV986y+K+Fu4lZhG/64I1+7awhkwZ/nAJGscmBe4awl+naN7
         cRmO/UXB/y0oDfGjc2GcBA4O5lMTv2/3nQaLo53u0IHFjeCXg/IkDb82hH+CQJ8T3DdD
         Gk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iP+4tXpLLeYulkhr0ZU6hQTrNg2JblROEAiYyRg4WR0=;
        b=o0Rx7WC96bi6Gl3FIRh9UosPMFimJoHT8LG/nSuzY+pI8sa+7Xl6Siza3yzKT3q8gL
         yvVQ4QrBtFVW9VqodCipBcPEeL6wd4aNUN4utbsInPr9Q56lpf1ERczntD8RhyZgmzxC
         4IBkbHz3MjDp2BGx8vvhqXDMB1hgygvUhnwRaujmwotZf4AYrm/mQtJOxJRDFQeI2RUZ
         KJHR3pGgvslfC8mIbb/j0UZ1Fzg1VXu4eGju9irJd27fcEUdpQMPRo0FiQigOYU+0AIk
         eybKO1xwiLVXdJlT6CmZlrq1JIR5gSgalAQmiEeVa0ACifneud2EMRD34DmQ+D+VZF9i
         6rjA==
X-Gm-Message-State: APjAAAWeoLQ9vycbVo9s8EzLNs8IrYc+TouNb+RCZNgh7qosVrgolRS5
        q0P7o0U6FwjTTzHrfJixmRXNEtuSBO8Mi4cxSQA=
X-Google-Smtp-Source: APXvYqxjTpZCnXWPYVPXCFLjhJEDGo6+SOZ7ZKkwTfEcfUTdPhr5mOG8NIob9UXiDZTDtVzOfwDIRl0l8pTL02MRlTo=
X-Received: by 2002:ac8:6601:: with SMTP id c1mr63893457qtp.93.1564183752890;
 Fri, 26 Jul 2019 16:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-7-andriin@fb.com>
 <20190725232633.zt6fxixq72xqwwmz@ast-mbp>
In-Reply-To: <20190725232633.zt6fxixq72xqwwmz@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 16:29:02 -0700
Message-ID: <CAEf4Bzbhk1-L4iktq-0=hTQdTrzzoWRhjt93wVWb+EQBQK8Pqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/10] selftests/bpf: add CO-RE relocs array tests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 4:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 12:27:38PM -0700, Andrii Nakryiko wrote:
> > Add tests for various array handling/relocation scenarios.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ...
> > +
> > +#define CORE_READ(dst, src) \
> > +     bpf_probe_read(dst, sizeof(*src), __builtin_preserve_access_index(src))
>
> This is the key accessor that all progs will use.
> Please split just this single macro into individual commit and add
> detailed comment about its purpose and
> what __builtin_preserve_access_index() does underneath.

I'm planning to add more powerful and flexible set of macros to
support BCC style a->b->c->d accesses using single macro. Something
like BPF_CORE_READ(&dst, sizeof(dst), a, b, c, d). I want to move
bpf_helpers.h into libbpf itself first, after some clean up. How about
I write all that at that time and for now just add this simpler
CORE_READ into bpf_helpers.h?

Relocations recorded by __builtin_preserve_access_index() are
described pretty well in patch #1, which adds bpf_offset_reloc. I'll
double check if I mention this built-in there, and if not - will add
that.

>
> > +SEC("raw_tracepoint/sys_enter")
> > +int test_core_nesting(void *ctx)
> > +{
> > +     struct core_reloc_arrays *in = (void *)&data.in;
> > +     struct core_reloc_arrays_output *out = (void *)&data.out;
> > +
> > +     /* in->a[2] */
> > +     if (CORE_READ(&out->a2, &in->a[2]))
> > +             return 1;
> > +     /* in->b[1][2][3] */
> > +     if (CORE_READ(&out->b123, &in->b[1][2][3]))
> > +             return 1;
