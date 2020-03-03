Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B029177CD9
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgCCRJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:09:53 -0500
Received: from mail-qv1-f48.google.com ([209.85.219.48]:46275 "EHLO
        mail-qv1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCCRJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:09:52 -0500
Received: by mail-qv1-f48.google.com with SMTP id m2so1984032qvu.13;
        Tue, 03 Mar 2020 09:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLjcjiO4Yvr0GGf3W+CwTmDAVxWUFSRxq+aiq86/wA4=;
        b=ByR3cWMpBWm6gLGyBsOOD7qzoN3x08lt2dmw3xF9oo2xdUZ0NFXCJE90ibqUYZpAPP
         jpUFnrtJqY8HBEd9JhGXczG6gAUorDEK/Af5VP9HdFBMQ/8rjxxnFeOtMQqTVvA3GcLB
         1/7x5t9sG4tPsh8ERnu8Ya1psREA5jtspGLrpbp0WtmcacNCUWT3BTruS0yVW2+uK/lS
         J0hpzNP0OrdrrESiwLk9p6MC8n9/3bjRHsmQ8WWataLhASz0uWR8/QeIBOYjxTFd/3n3
         JxqlfztCdEe4wW8txBy2v90Szyw4glDtZQa1SnqQ2/YFDW7nDyPWcqzg6AYcVZfUGw66
         E1WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLjcjiO4Yvr0GGf3W+CwTmDAVxWUFSRxq+aiq86/wA4=;
        b=kWmzZqC0q3ly+KBkOd6Z5EMl51/BpHu+AoMxhLzjranWHVT4Kw6PivWsjSANsr2BAP
         TBHe6XDeizEiL3DnABqDLl25yCqY8v2AbX1N2oDx9gs8J+E/MpEVsMmDpOw46yKOeUcz
         YjpBKqmAipMeuDQWDqZ42HRxA59IV5HUtwy/Kwjjhh6PNiXkgPS/x6d07pMN+aEZ1qGM
         sEEkDhRxoQl9feTMLyu5S9DIGr6lw4d8qxQT9rdrU5vh+0zkyNGg2/VsMatYc//vMaaV
         fJxdMI6epsgHnKQZJIoZuEcJPADZdMuIZHd47r2SMfgCnjoQQyWGwKh9r6CagBjyoyjk
         DTXA==
X-Gm-Message-State: ANhLgQ0NRHg3jCWM+Bmw5uCqq+zffRgLxrTnNO1OH5GxJPm1Tb+i/NR0
        Bmx+mLIVv9l9vmOO0N2w7xE+tsOyAWcDY3mZ+ZzdNV2biv8=
X-Google-Smtp-Source: ADFU+vsgHaGZa9bWuPzMFSOlBQ+ujHAAJ+EzkTPIXygSXSXNa9rNTYqS25OTf066tJkrrA4bRRFyZrAZrLXr6KQs880=
X-Received: by 2002:a0c:f381:: with SMTP id i1mr1056592qvk.163.1583255390017;
 Tue, 03 Mar 2020 09:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20200303140837.90056-1-jolsa@kernel.org>
In-Reply-To: <20200303140837.90056-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Mar 2020 09:09:38 -0800
Message-ID: <CAEf4BzY8_=wcL3N96eS-jcSPBL=ueMgQg+m=Fxiw+o0Tc7F23Q@mail.gmail.com>
Subject: Re: [RFC] libbpf,selftests: Question on btf_dump__emit_type_decl for BTF_KIND_FUNC
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 6:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> for bpftrace I'd like to print BTF functions (BTF_KIND_FUNC)
> declarations together with their names.
>
> I saw we have btf_dump__emit_type_decl and added BTF_KIND_FUNC,
> where it seemed to be missing, so it prints out something now
> (not sure it's the right fix though).
>
> Anyway, would you be ok with adding some flag/bool to struct
> btf_dump_emit_type_decl_opts, so I could get output like:
>
>   kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
>   kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
>
> ... to be able to the arguments and return type separated,
> so I could easily get to something like above?
>
> Current interface is just vfprintf callback and I'm not sure
> I can rely that it will allywas be called with same arguments,
> like having separated calls for parsed atoms like 'return type',
> '(', ')', '(', 'arg type', 'arg name', ...
>
> I'm open to any suggestion ;-)

Hey Jiri!

Can you please elaborate on the use case and problem you are trying to solve?

I think we can (and probably even should) add such option and support
to dump functions, but whatever we do it should be a valid C syntax
and should be compilable.
Example above:

kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t

Is this really the syntax you need to get? I think btf_dump, when
(optionally) emitting function declaration, will have to emit that
particular one as:

size_t ksys_read(unsigned int fd, char buf, long unsigned int count);

But I'd like to hear the use case before we add this. Thanks!

>
> thanks,
> jirka
>
>
> ---
>  tools/lib/bpf/btf_dump.c                      |  4 ++++
>  .../selftests/bpf/prog_tests/btf_dump.c       | 21 +++++++++++++++++++
>  .../bpf/progs/btf_dump_test_case_bitfields.c  | 10 +++++++++
>  .../bpf/progs/btf_dump_test_case_multidim.c   |  3 +++
>  .../progs/btf_dump_test_case_namespacing.c    | 19 +++++++++++++++++
>  .../bpf/progs/btf_dump_test_case_ordering.c   |  3 +++
>  .../bpf/progs/btf_dump_test_case_packing.c    | 16 ++++++++++++++
>  .../bpf/progs/btf_dump_test_case_padding.c    | 15 +++++++++++++
>  .../bpf/progs/btf_dump_test_case_syntax.c     |  3 +++
>  9 files changed, 94 insertions(+)
>

[...]

>
> +/*
> + *int ()(struct {
> + *     struct packed_trailing_space _1;
> + *     short: 16;
> + *     struct non_packed_trailing_space _2;
> + *     struct packed_fields _3;
> + *     short: 16;
> + *     struct non_packed_fields _4;
> + *     struct nested_packed _5;
> + *     short: 16;
> + *     union union_is_never_packed _6;
> + *     union union_does_not_need_packing _7;
> + *     union jump_code_union _8;
> + *     int: 24;
> + *} __attribute__((packed)) *_)
> + */

This clearly isn't compilable, right?

>  /*------ END-EXPECTED-OUTPUT ------ */
>
>  int f(struct {
> diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
> index 35c512818a56..581349bb0c2f 100644
> --- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
> +++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
> @@ -102,6 +102,21 @@ struct zone {
>         struct zone_padding __pad__;
>  };
>

[...]
