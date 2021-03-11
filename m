Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7590337CDA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCKSqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCKSpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:45:53 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF743C061574;
        Thu, 11 Mar 2021 10:45:52 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id u75so22712991ybi.10;
        Thu, 11 Mar 2021 10:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ogcTCYzPB9i0rOzycmKs7pdncHCMoqNAs75CsbaToP0=;
        b=uwg/8WGJpy4NfYDrDXtkT+6u5ZEc9JmMQw6E5kdVihc3j6C/k2X3TPtj9TI+0+M+1/
         FN5t8qOx2UOXY5X3i4SXYEcU8Va6rpTVYMiLxBQ16qo/Vks5v64c0ABp3lZd6N/QBbjF
         +zP16kI9QbZ2Wfcn9rsgS9ULK7C34EEitnJsWEDOIHqdB8qaZ2a4tLsnPMAUEsunNbTW
         +bJPJEgZWrcx5s0DhAK3Oy3nqooUj09VdpEr6tLzJycKOkM5VgAPG0Ue6gbHp8h5ZI61
         qxKqrZKeLJB/Dq/Y5lMwEUJcPrashPhvKHHBz8qn5wWRES9FgwhwqBdEEjr2L9Q7v2zJ
         mv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ogcTCYzPB9i0rOzycmKs7pdncHCMoqNAs75CsbaToP0=;
        b=lQU0ihVPCi3mujnMy9pH+q6XweDkJKiLbgNKlf2cseDsD54c/A3q4U/Dv30uDDhXGg
         mDUjHmSK66TVcDWzLuSp+OknQ0SMwKAEDuq3gCPnBpz1NMb2X6xmGTibLdG2w4Guf5tr
         gMkbyLXvet+Tlz/OG8DFmOEJO3YOqF2NLKEv25neqheSAMomoI9g1RbuyoS8+2uEguDV
         9luoXB7DK6KpMmVIQM6umVGWQiB5EtnEdeNoWRzD/MvrWAzeGkegO9965pmD8LPVy10G
         XqEjKycZrasb4oi5VLLhLsde+/D+5JQkWdD2VTQCOSXbL2g+tKAz+uFn2zL2cG389o4F
         UPJA==
X-Gm-Message-State: AOAM533kyHcjts2THRuTfW69mCA+PaWtxY0K1LAAX+Mu6VMpXLElSTi1
        PoKlCry6aO+KQmD3DEgibU8C9+IBmSsKAtU4n0E=
X-Google-Smtp-Source: ABdhPJwv4xEYQWTX+ZdaejejPHRZjF5qbSmro0JQ+rx8vgH6EzJjP/wmUvF/qCoEj5LVBl17OD1+HUFYjUCOvFtkINc=
X-Received: by 2002:a25:cc13:: with SMTP id l19mr13391310ybf.260.1615488351781;
 Thu, 11 Mar 2021 10:45:51 -0800 (PST)
MIME-Version: 1.0
References: <20210310040431.916483-1-andrii@kernel.org> <20210310040431.916483-8-andrii@kernel.org>
 <9f44eedf-79a3-0025-0f31-ee70f2f7d98b@isovalent.com>
In-Reply-To: <9f44eedf-79a3-0025-0f31-ee70f2f7d98b@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Mar 2021 10:45:40 -0800
Message-ID: <CAEf4BzZKFKQQSQmNPkoSW8b3NEvRXirkqx-Hewt1cmRE9tPmHw@mail.gmail.com>
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

On Thu, Mar 11, 2021 at 3:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-03-09 20:04 UTC-0800 ~ Andrii Nakryiko <andrii@kernel.org>
> > Add `bpftool gen bpfo <output-file> <input_file>...` command to statically
> > link multiple BPF object files into a single output BPF object file.
> >
> > Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
> > convention for statically-linked BPF object files. Both .o and .bpfo suffixes
> > will be stripped out during BPF skeleton generation to infer BPF object name.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > ---
> >  tools/bpf/bpftool/gen.c | 46 ++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 45 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 4033c46d83e7..8b1ed6c0a62f 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > +static int do_bpfo(int argc, char **argv)
>
> > +{
> > +     struct bpf_linker *linker;
> > +     const char *output_file, *file;
> > +     int err;
> > +
> > +     if (!REQ_ARGS(2)) {
> > +             usage();
> > +             return -1;
> > +     }
> > +
> > +     output_file = GET_ARG();
> > +
> > +     linker = bpf_linker__new(output_file, NULL);
> > +     if (!linker) {
> > +             p_err("failed to create BPF linker instance");
> > +             return -1;
> > +     }
> > +
> > +     while (argc) {
> > +             file = GET_ARG();
> > +
> > +             err = bpf_linker__add_file(linker, file);
> > +             if (err) {
> > +                     p_err("failed to link '%s': %d", file, err);
>
> I think you mentioned before that your preference was for having just
> the error code instead of using strerror(), but I think it would be more
> user-friendly for the majority of users who don't know the error codes
> if we had something more verbose? How about having both strerror()
> output and the error code?

Sure, I'll add strerror(). My earlier point was that those messages
are more often misleading (e.g., "file not found" for ENOENT or
something similar) than helpful. I should check if bpftool is passing
through warn-level messages from libbpf. Those are going to be very
helpful, if anything goes wrong. --verbose should pass through all of
libbpf messages, if it's not already the case.

>
> > +                     goto err_out;
> > +             }
> > +     }
> > +
> > +     err = bpf_linker__finalize(linker);
> > +     if (err) {
> > +             p_err("failed to finalize ELF file: %d", err);
> > +             goto err_out;
> > +     }
> > +
> > +     return 0;
> > +err_out:
> > +     bpf_linker__free(linker);
> > +     return -1;
>
> Should you call bpf_linker__free() even on success? I see that
> bpf_linker__finalize() frees some of the resources, but it seems that
> bpf_linker__free() does a more thorough job?

yep, it should really be just

err_out:
    bpf_linker__free(linker);
    return err;


>
> > +}
> > +
> >  static int do_help(int argc, char **argv)
> >  {
> >       if (json_output) {
> > @@ -611,6 +654,7 @@ static int do_help(int argc, char **argv)
> >
> >  static const struct cmd cmds[] = {
> >       { "skeleton",   do_skeleton },
> > +     { "bpfo",       do_bpfo },
> >       { "help",       do_help },
> >       { 0 }
> >  };
> >
>
> Please update the usage help message, man page, and bash completion,
> thanks. Especially because what "bpftool gen bpfo" does is not intuitive
> (but I don't have a better name suggestion at the moment).

Yeah, forgot about manpage and bash completions, as usual.

re: "gen bpfo". I don't have much better naming as well. `bpftool
link` is already taken for bpf_link-related commands. It felt like
keeping this under "gen" command makes sense. But maybe `bpftool
linker link <out> <in1> <in2> ...` would be a bit less confusing
convention?

>
> Great work!
>
> Quentin
