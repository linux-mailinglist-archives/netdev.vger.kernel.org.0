Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE3A4169C7
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 04:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243851AbhIXCEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 22:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243853AbhIXCEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 22:04:33 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC9BC061574;
        Thu, 23 Sep 2021 19:03:01 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id f133so2457516yba.11;
        Thu, 23 Sep 2021 19:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wsZ86eDvq8rFmKfUftx4luAbwr+ZRtVm+Rx+YkpDik=;
        b=ILfxGwVSmwzvNn+m6MCcdOhWfndmx2yG/ncNzHivTj6FQnNOf2u82alVQScQarghfT
         ocpUpX4nkYkJUbTEYCoxE0hpXuC0d8nc1Kh+UvlONBIMdpwDt2NuPMXDy+Z7SfCxH1FI
         w38SgUdsDYGv0ga/TVl6JrW89uZyyl0oJ36HzdxVndJEEdD8ZsmdrXVZ0/3318JwcRQ6
         FrBOCsHIZHCzTZuDnjkoLpP6lPiimuUbNTX5OwbS7PgdTsVANkftp5m1/I6aP5/sbpXv
         liomsi2g0BMqFfl85278dY/AAu+S/3ucrPgMX9smzTuIEdojrXI4WT/n2rtWivRThw7e
         7Icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wsZ86eDvq8rFmKfUftx4luAbwr+ZRtVm+Rx+YkpDik=;
        b=mXMr5KXit5U777Wu+F9IDwlOrBvyP/0zGt4rgRUYBrRmwB2U3XgTKZ3KvfV+w7g5aT
         GFuSVZWni6k9YUUHPIKZIyZYLj1AqQ4RaS4300gfhYgIWTr0LVvt0lozbYl5oBg0m1Vv
         eYqvVsY1wFUBQ32dx0nL1nUDKJZwDo/YgHxDt1VtZcvQVwI8xFrvpz9/VgRAwf3q9FMz
         x/feHPbF5BuF8jD7mrIN6K46GZGY8++SKY0Y6KGEe6cGEfQhZUCwMjj5KPVViahnWB0N
         g08gE/Fvhfut4wOKBfO2h5LNYTQ+SwmpzuB9Du5abmNie9s65X+CGkz1tv4W4l/y4kFy
         3meQ==
X-Gm-Message-State: AOAM5317Xo+KmQCGcK8+VpkXgLihZ/P15/I4IzI9NmyOyFHQW4hhHdb4
        Mdm9UawqaVAqV+uy40ZkrqALEM5vOf1TPs5yBIo=
X-Google-Smtp-Source: ABdhPJwgf4bPVvwDo7YWfjkAmOWikv0CNiP00v/Ii6qpI2sJfFTUX7Gm7bQsINT2ksCcfQATPEY4ssUydQyzu/TkKpI=
X-Received: by 2002:a25:47c4:: with SMTP id u187mr10023389yba.225.1632448980821;
 Thu, 23 Sep 2021 19:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp> <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
In-Reply-To: <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 23 Sep 2021 19:02:49 -0700
Message-ID: <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification stats
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
> > On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
> >> The verifier currently logs some useful statistics in
> >> print_verification_stats. Although the text log is an effective feedback
> >> tool for an engineer iterating on a single application, it would also be
> >> useful to enable tracking these stats in a more structured form for
> >> fleetwide or historical analysis, which this patchset attempts to do.
> >>
> >> A concrete motivating usecase which came up in recent weeks:
> >>
> >> A team owns a complex BPF program, with various folks extending its
> >> functionality over the years. An engineer tries to make a relatively
> >> simple addition but encounters "BPF program is too large. Processed
> >> 1000001 insn".
> >>
> >> Their changes bumped the processed insns from 700k to over the limit and
> >> there's no obvious way to simplify. They must now consider a large
> >> refactor in order to incorporate the new feature. What if there was some
> >> previous change which bumped processed insns from 200k->700k which
> >> _could_ be modified to stress verifier less? Tracking historical
> >> verifier stats for each version of the program over the years would
> >> reduce manual work necessary to find such a change.
> >>
> >>
> >> Although parsing the text log could work for this scenario, a solution
> >> that's resilient to log format and other verifier changes would be
> >> preferable.
> >>
> >> This patchset adds a bpf_prog_verif_stats struct - containing the same
> >> data logged by print_verification_stats - which can be retrieved as part
> >> of bpf_prog_info. Looking for general feedback on approach and a few
> >> specific areas before fleshing it out further:
> >>
> >> * None of my usecases require storing verif_stats for the lifetime of a
> >>   loaded prog, but adding to bpf_prog_aux felt more correct than trying
> >>   to pass verif_stats back as part of BPF_PROG_LOAD
> >> * The verif_stats are probably not generally useful enough to warrant
> >>   inclusion in fdinfo, but hoping to get confirmation before removing
> >>   that change in patch 1
> >> * processed_insn, verification_time, and total_states are immediately
> >>   useful for me, rest were added for parity with
> >>      print_verification_stats. Can remove.
> >> * Perhaps a version field would be useful in verif_stats in case future
> >>   verifier changes make some current stats meaningless
> >> * Note: stack_depth stat was intentionally skipped to keep patch 1
> >>   simple. Will add if approach looks good.
> >
> > Sorry for the delay. LPC consumes a lot of mental energy :)
> >
> > I see the value of exposing some of the verification stats as prog_info.
> > Let's look at the list:
> > struct bpf_prog_verif_stats {
> >        __u64 verification_time;
> >        __u32 insn_processed;
> >        __u32 max_states_per_insn;
> >        __u32 total_states;
> >        __u32 peak_states;
> >        __u32 longest_mark_read_walk;
> > };
> > verification_time is non deterministic. It varies with frequency
> > and run-to-run. I don't see how alerting tools can use it.
>
> Makes sense to me, will get rid of it.
>
> > insn_processed is indeed the main verification metric.
> > By now it's well known and understood.
> >
> > max_states_per_insn, total_states, etc were the metrics I've studied
> > carefully with pruning, back tracking and pretty much every significant
> > change I did or reiviewed in the verifier. They're useful to humans
> > and developers, but I don't see how alerting tools will use them.
> >
> > So it feels to me that insn_processed alone will be enough to address the
> > monitoring goal.
>
> For the concrete usecase in my original message insn_processed would be
> enough. For the others - I thought there might be value in gathering
> those "fleetwide" to inform verifier development, e.g.:
>
> "Hmm, this team's libbpf program has been regressing total_states over
> past few {kernel, llvm} rollouts, but they haven't been modifying it.
> Let's try to get a minimal repro, send to bpf@vger, and contribute to
> selftests if it is indeed hitting a weird verifier edge case"
>
> So for those I'm not expecting them to be useful to alert on or be a
> number that the average BPF program writer needs to care about.
>
> Of course this is hypothetical as I haven't tried to gather such data
> and look for interesting patterns. But these metrics being useful to
> you when looking at significant verifier changes is a good sign.

One reason to not add all those fields is to not end up with
meaningless stats (in the future) in UAPI. One way to work around that
is to make it "unstable" by providing it through raw_tracepoint as
internal kernel struct.

Basically, the proposal would be: add new tracepoint for when BPF
program is verified, either successfully or not. As one of the
parameters provide stats struct which is internal to BPF verifier and
is not exposed through UAPI.

Such tracepoint actually would be useful more generally as well, e.g.,
to monitor which programs are verified in the fleet, what's the rate
of success/failure (to detect verifier regression), what are the stats
(verification time actually would be good to have there, again for
stats and detecting regression), etc, etc.

WDYT?

>
> > It can be exposed to fd_info and printed by bpftool.
> > If/when it changes with some future verifier algorithm we should be able
> > to approximate it.
> >
>
