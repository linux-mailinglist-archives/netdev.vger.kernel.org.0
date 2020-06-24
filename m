Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B284207945
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405011AbgFXQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404952AbgFXQfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:35:07 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E450C0613ED;
        Wed, 24 Jun 2020 09:35:07 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cv17so1308601qvb.13;
        Wed, 24 Jun 2020 09:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lDn4TidR4qxH9VOW6mcMSR+f5fQgbVg5so95pf6069k=;
        b=ROLM4SJ34XlWaQFKwc2CQNOVLZ9kDhK4rDyw0xNWABvN1TnHekqFvl3v5ir+gkn9wR
         6cLJFhXOHa99yGaU4sgHyita3rksUWY2I191ABsjox/JYBED886lsdJioA64S9UJ7Dzr
         PJArX6io3EcKf1ZWVlZXa+N+1BOivU4opRo91pPJA6hmrDqT7Ng6mfFXOAcyaWRkjECD
         M3PUo8+WRo0h77UeyV3fFwXoCE03OslOqmnvM+6IIheNBaJCdVsHKJfp2AaD1EmaSLAQ
         YMV1B41BpZIq8Ts2VXOicqoVN0eRwa04GNG7QCfekZXZCpiM3nm+mzJ2DTdzqupvbrfI
         spxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lDn4TidR4qxH9VOW6mcMSR+f5fQgbVg5so95pf6069k=;
        b=jwfqVQLxSs/h8A+opaxsolkQ4uVtMj55d5IKidcMosAx2jA3M1cqVlPdC+OfKACkXv
         8Scg+t5II8Sy91uZCFVekWpvAf1n47pA2NYKdmwR0cSnGWYE1H6FGIYKYQfYoRKdctLs
         T32c41mNBn+o0drBJuDhjygosOQzg0bqjB3ij9uuGnwqP/oOJ3Q7I4gCDmCPKie1oPqv
         1i0oIR/FnQi5koNDy2YjpBuyvWIBYiXAmLBmFxB7NzxaWn5GgS6X1oRbVRn7rVjXWct4
         RIr2vHkyjOxONYJ1N7yYArnyiHGKZx6hRmEl2mk4za5PZWnf7WaxFMIKnJ71XJMc13hR
         SVNQ==
X-Gm-Message-State: AOAM530Hslkb/mv0qqxaAiXQ76YMejel9YsmCsL3CAua7mY5DPUwS0pY
        paM90Fn3KJgiFdi2qXFsWTT6rBDbwTiR9qQtVyU=
X-Google-Smtp-Source: ABdhPJxv2vbKd0+529OflCA51otsX32YPHc+nJbcHmJ11PjU1wnIU1L1Qn0WKAvZp3PJ6QGyRoKMrGJGBJHyspgIA4E=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr19252356qvb.228.1593016506056;
 Wed, 24 Jun 2020 09:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200624003340.802375-1-andriin@fb.com> <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com>
 <CAEf4BzYKV=A+Sd1ByA2=7CG7WJedB0CRAU7RGN6jO8B9ykpHiA@mail.gmail.com> <20200624145235.73mysssbdew7eody@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200624145235.73mysssbdew7eody@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jun 2020 09:34:52 -0700
Message-ID: <CAEf4Bzay9fErW5wooMBkmrHPK9T=e8O82cJc5NNq+wmugTznjQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add debug message for each created program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 7:52 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 23, 2020 at 11:59:40PM -0700, Andrii Nakryiko wrote:
> > On Tue, Jun 23, 2020 at 11:47 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Jun 23, 2020 at 5:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > Similar message for map creation is extremely useful, so add similar for BPF
> > > > programs.
> > >
> > > 'extremely useful' is quite subjective.
> > > If we land this patch then everyone will be allowed to add pr_debug()
> > > everywhere in libbpf with the same reasoning: "it's extremely useful pr_debug".
> >
> > We print this for maps, making it clear which maps and with which FD
> > were created. Having this for programs is just as useful. It doesn't
> > overwhelm output (and it's debug one either way). "everyone will be
> > allowed to add pr_debug()" is a big stretch, you can't just sneak in
> > or force random pr_debug, we do review patches and if something
> > doesn't make sense we can and we do reject it, regardless of claimed
> > usefulness by the patch author.
> >
> > So far, libbpf debug logs were extremely helpful (subjective, of
> > course, but what isn't?) to debug "remotely" various issues that BPF
> > users had. They don't feel overwhelmingly verbose and don't have a lot
> > of unnecessary info. Adding a few lines (how many BPF programs are
> > there per each BPF object?) for listing BPF programs is totally ok.
>
> None of the above were mentioned in the commit log.
> And no examples were given where this extra line would actually help.

I used it just 2 days ago trying to understand why bpftool doesn't
show its own bpf_iter program, but shows maps. I discovered with
surprise that we actually don't log FDs of loaded programs.

>
> I think libbpf pr_debug is extremely verbose instead of extremely useful.
> Just typical output:
> ./test_progs -vv -t lsm
> libbpf: loading object 'lsm' from buffer
> libbpf: section(1) .strtab, size 306, link 0, flags 0, type=3
> libbpf: skip section(1) .strtab
> libbpf: section(2) .text, size 0, link 0, flags 6, type=1
> libbpf: skip section(2) .text
> libbpf: section(3) lsm/file_mprotect, size 192, link 0, flags 6, type=1
> libbpf: found program lsm/file_mprotect
> libbpf: section(4) .rellsm/file_mprotect, size 32, link 25, flags 0, type=9
> libbpf: section(5) lsm/bprm_committed_creds, size 104, link 0, flags 6, type=1
> libbpf: found program lsm/bprm_committed_creds
> libbpf: section(6) .rellsm/bprm_committed_creds, size 32, link 25, flags 0, type=9
>
> How's above useful for anyone?
> libbpf says that there are '.strtab' and '.text' sections in the elf file.
> That's wet water. Any elf file has that.
> Then it says it's skipping '.text' ?
> That reads surprising. Why library would skip the code?
> And so on and so forth.

I can pick a few more not-so-useful (usually) pr_debug-level log lines
as well, I don't think it disproves that debug logs are useful.

> That output is useful to only few core libbpf developers.

Yes, and I don't expect typical BPF developers to have them turned on
by default. They are *DEBUG*-level output, after all, users shouldn't
care about them, only INFO and WARN/ERR ones, I'd hope. But it's #1
thing that I ask users to provide when they come with any questions
about BPF or libbpf.

So yeah, as a core libbpf developer and a person helping people with
various (often non-libbpf-specific) BPF problems both online and
within my company, I stand by my claim that libbpf debug logs are
extremely useful and helped debug and understand numerous issues.

Just yesterday (or two days ago, maybe), having those CO-RE relocation
logs, which I fought to keep when I added CO-RE relocs initially,
immediately shown that a person doesn't have bpf_iter compiled in its
running kernel, despite the claims otherwise.

>
> I don't mind more thought through debug prints, but
> saying that existing pr_debugs are 'extremely useful' is a stretch.

Some lines are extremely useful, yes, some less so. But then again,
depending on the situation. Not all parts of the log are relevant 100%
of the time, but sometimes even these ELF parsing logs are important.
How many people add and debug libbpf functionality that deals with
interpreting ELF sections/relocations/etc to be able to claim about
their usefulness anyway?

Regardless, we've spent way too much time on this, I don't care about
this particular pr_debug() enough to argue further.
