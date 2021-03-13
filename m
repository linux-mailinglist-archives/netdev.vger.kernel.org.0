Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8704C33A002
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 19:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhCMShz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 13:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbhCMShc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 13:37:32 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D11C061574;
        Sat, 13 Mar 2021 10:37:32 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id u75so28907100ybi.10;
        Sat, 13 Mar 2021 10:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7PJ+NfAxn5vKEjd6pLLLtie7Fgp2PvH0Kp7IgMqUmV0=;
        b=sxHwG+9Lz2cEGhbpIVv+GZA+RNrPlk2Cy2US2djtqtNKEm8gXf0KxPxkyHZp0c6nLa
         4a4kVrMQd1kXJn87yu91G/Zi9LLaSqgXjGWnTqcIUDLFrqQphWVJuiK05ktwFIfW6JS5
         kUWAHi49smYgoprOeYCqhUnN09TWV+G1JBOo/CO4Wncm9kY5/dNkEmOgZcaUdAtRDtXB
         gEkcpJ4dmNPpzUk8KiQaEkmZCqpRKcPpY5as4VNMMj3NV/DLNkpdSrCmrsWDmMIlu8Pn
         Im0BCurvs1aM3OgKQAh+m867eqkasJBoOtmI/7rGZc/QdeXh7YyDdNYJYVyylkPhW3rE
         pTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7PJ+NfAxn5vKEjd6pLLLtie7Fgp2PvH0Kp7IgMqUmV0=;
        b=D+rxikgmnsG1ilNvojknjTAdAM/ufwTgn8pLxX2qpxdgwTkN6eIFKyeepWwLG/guEr
         20Mhsavtv3sqbMZVUhAykockLHdLtWPBU7SJQ4OsQf8yxIn2xB8ybFbBmkCSCd+BHKzq
         Y9tbL1GyTvASZU46gjfoOnjKGy5V08LTVY3vf/l73Tb9U1FqcxDwSqsOYNxiYBx0yLdw
         RPsnJJXekm9x4YvWLaV1lvKpi/7qhFa/Frqfr/CrPbRq8n42o0qyCnLuXRwM3gNPr+E0
         NG/0aY/M4qa6cLXkIHB1clBhWhh5wXYHLBHCuFxa4ax61/d3HAMN1sGu4k+fs0tihElv
         +r9Q==
X-Gm-Message-State: AOAM531mHR/6wCHcXKTjbjIXoiH/2DxjleJ0YbJstruzP3C/bPY7Kckx
        JMnlf1sM+HU9CinqnFoSBnGJ79uV7+xkQB3h8rw=
X-Google-Smtp-Source: ABdhPJz6DzS0xf7B/MdVtMWT3Y4IiEMXjGF3utbQirtwRiJ5n8cAWELOxK5mEVb5SdBGKC66cxiPLTh7GyU4f4waPEk=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr26525278yba.459.1615660651854;
 Sat, 13 Mar 2021 10:37:31 -0800 (PST)
MIME-Version: 1.0
References: <20210310040431.916483-1-andrii@kernel.org> <20210310040431.916483-8-andrii@kernel.org>
 <9f44eedf-79a3-0025-0f31-ee70f2f7d98b@isovalent.com> <CAEf4BzZKFKQQSQmNPkoSW8b3NEvRXirkqx-Hewt1cmRE9tPmHw@mail.gmail.com>
 <7c78ba67-03ff-fd84-339e-08628716abdf@isovalent.com>
In-Reply-To: <7c78ba67-03ff-fd84-339e-08628716abdf@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 13 Mar 2021 10:37:21 -0800
Message-ID: <CAEf4BzZGYdTVWf3dp6FvBu+ogd491CXky5v708OzQG8oyYoCOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpftool: add `gen bpfo` command to perform
 BPF static linking
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 10:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-03-11 10:45 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Thu, Mar 11, 2021 at 3:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> 2021-03-09 20:04 UTC-0800 ~ Andrii Nakryiko <andrii@kernel.org>
> >>> Add `bpftool gen bpfo <output-file> <input_file>...` command to statically
> >>> link multiple BPF object files into a single output BPF object file.
> >>>
> >>> Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
> >>> convention for statically-linked BPF object files. Both .o and .bpfo suffixes
> >>> will be stripped out during BPF skeleton generation to infer BPF object name.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>> ---
> >>>  tools/bpf/bpftool/gen.c | 46 ++++++++++++++++++++++++++++++++++++++++-
> >>>  1 file changed, 45 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> >>> index 4033c46d83e7..8b1ed6c0a62f 100644
> >>> --- a/tools/bpf/bpftool/gen.c
> >>> +++ b/tools/bpf/bpftool/gen.c
> >>> +static int do_bpfo(int argc, char **argv)
> >>
> >>> +{
> >>> +     struct bpf_linker *linker;
> >>> +     const char *output_file, *file;
> >>> +     int err;
> >>> +
> >>> +     if (!REQ_ARGS(2)) {
> >>> +             usage();
> >>> +             return -1;
> >>> +     }
> >>> +
> >>> +     output_file = GET_ARG();
> >>> +
> >>> +     linker = bpf_linker__new(output_file, NULL);
> >>> +     if (!linker) {
> >>> +             p_err("failed to create BPF linker instance");
> >>> +             return -1;
> >>> +     }
> >>> +
> >>> +     while (argc) {
> >>> +             file = GET_ARG();
> >>> +
> >>> +             err = bpf_linker__add_file(linker, file);
> >>> +             if (err) {
> >>> +                     p_err("failed to link '%s': %d", file, err);
> >>
> >> I think you mentioned before that your preference was for having just
> >> the error code instead of using strerror(), but I think it would be more
> >> user-friendly for the majority of users who don't know the error codes
> >> if we had something more verbose? How about having both strerror()
> >> output and the error code?
> >
> > Sure, I'll add strerror(). My earlier point was that those messages
> > are more often misleading (e.g., "file not found" for ENOENT or
> > something similar) than helpful. I should check if bpftool is passing
> > through warn-level messages from libbpf. Those are going to be very
> > helpful, if anything goes wrong. --verbose should pass through all of
> > libbpf messages, if it's not already the case.
>
> Thanks. Yes, --verbose should do it, but it's worth a double-check.
>
> >>> +                     goto err_out;
> >>> +             }
> >>> +     }
> >>> +
> >>> +     err = bpf_linker__finalize(linker);
> >>> +     if (err) {
> >>> +             p_err("failed to finalize ELF file: %d", err);
> >>> +             goto err_out;
> >>> +     }
> >>> +
> >>> +     return 0;
> >>> +err_out:
> >>> +     bpf_linker__free(linker);
> >>> +     return -1;
> >>
> >> Should you call bpf_linker__free() even on success? I see that
> >> bpf_linker__finalize() frees some of the resources, but it seems that
> >> bpf_linker__free() does a more thorough job?
> >
> > yep, it should really be just
> >
> > err_out:
> >     bpf_linker__free(linker);
> >     return err;
> >
> >
> >>
> >>> +}
> >>> +
> >>>  static int do_help(int argc, char **argv)
> >>>  {
> >>>       if (json_output) {
> >>> @@ -611,6 +654,7 @@ static int do_help(int argc, char **argv)
> >>>
> >>>  static const struct cmd cmds[] = {
> >>>       { "skeleton",   do_skeleton },
> >>> +     { "bpfo",       do_bpfo },
> >>>       { "help",       do_help },
> >>>       { 0 }
> >>>  };
> >>>
> >>
> >> Please update the usage help message, man page, and bash completion,
> >> thanks. Especially because what "bpftool gen bpfo" does is not intuitive
> >> (but I don't have a better name suggestion at the moment).
> >
> > Yeah, forgot about manpage and bash completions, as usual.
> >
> > re: "gen bpfo". I don't have much better naming as well. `bpftool
> > link` is already taken for bpf_link-related commands. It felt like
> > keeping this under "gen" command makes sense. But maybe `bpftool
> > linker link <out> <in1> <in2> ...` would be a bit less confusing
> > convention?
>
> "bpftool linker" would have been nice, but having "bpftool link", I
> think it would be even more confusing. We can pass commands by their
> prefixes, so is "bpftool link" the command "link" or a prefix for
> "linker"? (I know it would be easy to sort out from our point of view,
> but for regular users I'm sure that would be confusing).

right

>
> I don't mind leaving it under "bpftool gen", it's probably the most
> relevant command we have. As for replacing the "bpfo" keyword, I've
> thought of "combined", "static_linked", "archive", "concat". I write
> them in case it's any inspiration, but I find none of them ideal :/.

How about "bpftool gen object", which can be shortened in typing to
just `bpftool gen obj`. It seems complementary to `gen skeleton`. You
first generate object (from other objects generated by compiler, which
might be a bit confusing at first), then you generate skeleton from
the object. WDYT?

>
> Quentin
