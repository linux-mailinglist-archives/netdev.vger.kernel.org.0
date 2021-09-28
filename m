Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FE541A442
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhI1An3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbhI1An2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:43:28 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD6DC061575;
        Mon, 27 Sep 2021 17:41:49 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id m70so28058388ybm.5;
        Mon, 27 Sep 2021 17:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEUbUu/OyN7X0Fpm+BVMV//96K67b3V4xTMb6EH1M1g=;
        b=hRNukkSHUdnt9Nu98I4S+Jm7/ProyAFkFSCL4/GIPJH6NjSxFgx2nqtedFPIEf4lqB
         QvYMRvGTGr9nSHTLIaRhhSA1W3ZMXrMZ0awB0Pd0yF7ccg0ImoZNHHZS1arRi31ePCnA
         DqGyaYjqfUPABY8chUzIJPZ4L4gj2fqdY7qjXl2+oBfDEVAozti+HY9EX5/clwP+WTpR
         q3aTeHppejOuU8lh7xwG9207rg5Zfd3zqQLLc9Ue+apMRMT5+z4nsQR7br63UwUTley5
         GanAr0PfB7Kjg92qpQSjkzkhL7JT1Xq4cP53ovI1eTAyLm6YQn78XNj1YHQtuKn4n3VZ
         WGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEUbUu/OyN7X0Fpm+BVMV//96K67b3V4xTMb6EH1M1g=;
        b=eYAboo74BvtuujGNY+tdN1fJS/80b7YmCztYlCIBW/1YWkjGFrT+efwQZtKyGP6C18
         J8ZDYLNoYAZosS9GGSpdiR5UDmlcodh+6j9IBpnmG38pb187LBNV9EoaWNgsFl/KExfz
         V0ZZW9lgXInFc2HK5+3/xfx+pZXICAavhIduiHZyRyiyPAnYMCZs/cc9+s3q6ARFTB/u
         MZomi7SWOsX9sZintclHqYs69RrgMnJcF6oAuCh0h33W72vSXGk4GaFILIKBzaHTRJrn
         4/6Agf9Suh/82UQhpcJN60wzAoQiHu2G9n6xbGPY4fWEwffC3iQ7RrVzxXP4AW5+3D7/
         YTZA==
X-Gm-Message-State: AOAM532DSHvfqJ6QGXA3bafmdWUDZKuL8W/xeC6O/gVekgS367yYDf32
        HnK5Dq5PG93mPMHEN43Bi9frHtVUL8gZrz2pjQ4=
X-Google-Smtp-Source: ABdhPJyd2EApfAg6UHQPV5u+2UStN3+9mbcoUYVA9p00ksStZpwHwIwMpfUyF5bcjmWBqtxri31Kk+JznhSFAsCMmsI=
X-Received: by 2002:a25:2d4e:: with SMTP id s14mr3192993ybe.2.1632789709098;
 Mon, 27 Sep 2021 17:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp> <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
 <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
 <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com> <61520b6224619_397f208d7@john-XPS-13-9370.notmuch>
In-Reply-To: <61520b6224619_397f208d7@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Sep 2021 17:41:38 -0700
Message-ID: <CAEf4BzbxYxnQND9JJ4SfQb4kxxkRtk4S4rR2iqkcz6bJ2jdFqw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification stats
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 11:20 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Dave Marchevsky wrote:
> > On 9/23/21 10:02 PM, Andrii Nakryiko wrote:
> > > On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > >>
> > >> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
> > >>> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
> > >>>> The verifier currently logs some useful statistics in
> > >>>> print_verification_stats. Although the text log is an effective feedback
> > >>>> tool for an engineer iterating on a single application, it would also be
> > >>>> useful to enable tracking these stats in a more structured form for
> > >>>> fleetwide or historical analysis, which this patchset attempts to do.
> > >>>>
> > >>>> A concrete motivating usecase which came up in recent weeks:
> > >>>>
> > >>>> A team owns a complex BPF program, with various folks extending its
> > >>>> functionality over the years. An engineer tries to make a relatively
> > >>>> simple addition but encounters "BPF program is too large. Processed
> > >>>> 1000001 insn".
> > >>>>
> > >>>> Their changes bumped the processed insns from 700k to over the limit and
> > >>>> there's no obvious way to simplify. They must now consider a large
> > >>>> refactor in order to incorporate the new feature. What if there was some
> > >>>> previous change which bumped processed insns from 200k->700k which
> > >>>> _could_ be modified to stress verifier less? Tracking historical
> > >>>> verifier stats for each version of the program over the years would
> > >>>> reduce manual work necessary to find such a change.
> > >>>>
> > >>>>
> > >>>> Although parsing the text log could work for this scenario, a solution
> > >>>> that's resilient to log format and other verifier changes would be
> > >>>> preferable.
> > >>>>
> > >>>> This patchset adds a bpf_prog_verif_stats struct - containing the same
> > >>>> data logged by print_verification_stats - which can be retrieved as part
> > >>>> of bpf_prog_info. Looking for general feedback on approach and a few
> > >>>> specific areas before fleshing it out further:
> > >>>>
> > >>>> * None of my usecases require storing verif_stats for the lifetime of a
> > >>>>   loaded prog, but adding to bpf_prog_aux felt more correct than trying
> > >>>>   to pass verif_stats back as part of BPF_PROG_LOAD
> > >>>> * The verif_stats are probably not generally useful enough to warrant
> > >>>>   inclusion in fdinfo, but hoping to get confirmation before removing
> > >>>>   that change in patch 1
> > >>>> * processed_insn, verification_time, and total_states are immediately
> > >>>>   useful for me, rest were added for parity with
> > >>>>      print_verification_stats. Can remove.
> > >>>> * Perhaps a version field would be useful in verif_stats in case future
> > >>>>   verifier changes make some current stats meaningless
> > >>>> * Note: stack_depth stat was intentionally skipped to keep patch 1
> > >>>>   simple. Will add if approach looks good.
> > >>>
> > >>> Sorry for the delay. LPC consumes a lot of mental energy :)
> > >>>
> > >>> I see the value of exposing some of the verification stats as prog_info.
> > >>> Let's look at the list:
> > >>> struct bpf_prog_verif_stats {
> > >>>        __u64 verification_time;
> > >>>        __u32 insn_processed;
> > >>>        __u32 max_states_per_insn;
> > >>>        __u32 total_states;
> > >>>        __u32 peak_states;
> > >>>        __u32 longest_mark_read_walk;
> > >>> };
> > >>> verification_time is non deterministic. It varies with frequency
> > >>> and run-to-run. I don't see how alerting tools can use it.
> > >>
> > >> Makes sense to me, will get rid of it.
> > >>
> > >>> insn_processed is indeed the main verification metric.
> > >>> By now it's well known and understood.
> > >>>
> > >>> max_states_per_insn, total_states, etc were the metrics I've studied
> > >>> carefully with pruning, back tracking and pretty much every significant
> > >>> change I did or reiviewed in the verifier. They're useful to humans
> > >>> and developers, but I don't see how alerting tools will use them.
> > >>>
> > >>> So it feels to me that insn_processed alone will be enough to address the
> > >>> monitoring goal.
> > >>
> > >> For the concrete usecase in my original message insn_processed would be
> > >> enough. For the others - I thought there might be value in gathering
> > >> those "fleetwide" to inform verifier development, e.g.:
> > >>
> > >> "Hmm, this team's libbpf program has been regressing total_states over
> > >> past few {kernel, llvm} rollouts, but they haven't been modifying it.
> > >> Let's try to get a minimal repro, send to bpf@vger, and contribute to
> > >> selftests if it is indeed hitting a weird verifier edge case"
> > >>
> > >> So for those I'm not expecting them to be useful to alert on or be a
> > >> number that the average BPF program writer needs to care about.
> > >>
> > >> Of course this is hypothetical as I haven't tried to gather such data
> > >> and look for interesting patterns. But these metrics being useful to
> > >> you when looking at significant verifier changes is a good sign.
> > >
> > > One reason to not add all those fields is to not end up with
> > > meaningless stats (in the future) in UAPI. One way to work around that
> > > is to make it "unstable" by providing it through raw_tracepoint as
> > > internal kernel struct.
> > >
> > > Basically, the proposal would be: add new tracepoint for when BPF
> > > program is verified, either successfully or not. As one of the
> > > parameters provide stats struct which is internal to BPF verifier and
> > > is not exposed through UAPI.
> > >
> > > Such tracepoint actually would be useful more generally as well, e.g.,
> > > to monitor which programs are verified in the fleet, what's the rate
> > > of success/failure (to detect verifier regression), what are the stats
> > > (verification time actually would be good to have there, again for
> > > stats and detecting regression), etc, etc.
> > >
> > > WDYT?
> > >
> >
> > Seems reasonable to me - and attaching a BPF program to the tracepoint to
> > grab data is delightfully meta :)
> >
> > I'll do a pass on alternate implementation with _just_ tracepoint, no
> > prog_info or fdinfo, can add minimal or full stats to those later if
> > necessary.
>
> We can also use a hook point here to enforce policy on allowing the
> BPF program to load or not using the stats here. For now basic
> insn is a good start to allow larger/smaller programs to be loaded,
> but we might add other info like call bitmask, features, types, etc.
> If one of the arguments is the bpf_attr struct we can just read
> lots of useful program info out directly.
>
> We would need something different from a tracepoint though to let
> it return a reject|accept code. How about a new hook type that
> has something similar to sockops that lets us just return an
> accept or reject code?
>
> By doing this we can check loader signatures here to be sure the
> loader is signed or otherwise has correct permissions to be loading
> whatever type of bpf program is here.

For signing and generally preventing some BPF programs from loading
(e.g., if there is some malicious BPF program that takes tons of
memory to be validated), wouldn't you want to check that before BPF
verifier spent all those resources on verification? So maybe there
will be another hook before BPF prog is validated for that? Basically,
if you don't trust any BPF program unless it is signed, I'd expect you
check signature before BPF verifier does its heavy job.

>
> Thanks,
> John
