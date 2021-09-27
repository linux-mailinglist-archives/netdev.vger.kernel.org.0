Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0AE419E0A
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhI0SWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236012AbhI0SWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:22:05 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B85DC061575;
        Mon, 27 Sep 2021 11:20:27 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i13so20302677ilm.4;
        Mon, 27 Sep 2021 11:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=rzX5wn63csK5u2gLG46ZNldaW0rbl/tJITLCPxp+274=;
        b=A4sPcSiR/ZxxjVkAgWnm21qIBthsojmf07g4mBlInjQ7t3eDZ6Xes1KjtcAuJKiRpt
         939hid92bEYXL4PXczzo2DDaA4VT7yxqPjs7/xHRfCBb+big3hJDh1Pxu01HPGe3qG2I
         5WhBOKTVUBS5QdVgeq4Geha8xlRdvBuE73cpc2x30ME5UeG5MjfOA1hokai4Gazf+nbM
         h8pU/E+QHv7UY7Z1dFutSC2lZ6KsRs8LAMVBt0h7ILDHMJr8z80Kb6yTzEql7ARYd7qp
         e36ez7uC8t49ifv5Mm2GkMOWyYHpHPxSnC25fcTnWn2r1lgmKo8MacKiIehfOBC5JPmt
         VFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=rzX5wn63csK5u2gLG46ZNldaW0rbl/tJITLCPxp+274=;
        b=1orNyGtiAMCZabsRbbEwu52pGcZtzYyqdvjAn3OI7yt0GX9K/kgM0BIu+P1yd1bfXC
         vFsdXwfDChv249GOoiV9Dz+lFaRAJv04Z7N4f6n6OPPJd0u5SBYMu5aVeqqzmzEQR3ko
         QBw+isM3Yn5U6H4weviSSQR8PkRTaXRWVStec2A2fU0yEseU4qYWZu/boBm51Qu81xOH
         DNduMJd09nUi812kClEnxrUSRRJ6gG4+dGSTlsTfGU2R1niNFLKu0Jyg+fRwUQRT4niw
         LNJB0PlXFxmZNL/KxjarrbQrZub5zy+aflXbAaztY0V5OHUN/TyXk20VzywPh/RVN8SY
         q7SQ==
X-Gm-Message-State: AOAM532UWZojMxTW3C2dFj+6RNTUVZeYlO7cCJ/I24nI7grsUOgDFSSk
        EDOILRNCtF07lhwRDkpIfAU=
X-Google-Smtp-Source: ABdhPJyMlBHphqPh55+uxLSWfLzuNOpRyBMvQek1N6NId3XJlrZf4JVQoSwem2aXsFR77aChU10Axg==
X-Received: by 2002:a92:d382:: with SMTP id o2mr1071760ilo.67.1632766826911;
        Mon, 27 Sep 2021 11:20:26 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id f7sm9496428ilc.82.2021.09.27.11.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:20:26 -0700 (PDT)
Date:   Mon, 27 Sep 2021 11:20:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Message-ID: <61520b6224619_397f208d7@john-XPS-13-9370.notmuch>
In-Reply-To: <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp>
 <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
 <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
 <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification
 stats
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave Marchevsky wrote:
> On 9/23/21 10:02 PM, Andrii Nakryiko wrote:   
> > On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> >>
> >> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
> >>> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
> >>>> The verifier currently logs some useful statistics in
> >>>> print_verification_stats. Although the text log is an effective feedback
> >>>> tool for an engineer iterating on a single application, it would also be
> >>>> useful to enable tracking these stats in a more structured form for
> >>>> fleetwide or historical analysis, which this patchset attempts to do.
> >>>>
> >>>> A concrete motivating usecase which came up in recent weeks:
> >>>>
> >>>> A team owns a complex BPF program, with various folks extending its
> >>>> functionality over the years. An engineer tries to make a relatively
> >>>> simple addition but encounters "BPF program is too large. Processed
> >>>> 1000001 insn".
> >>>>
> >>>> Their changes bumped the processed insns from 700k to over the limit and
> >>>> there's no obvious way to simplify. They must now consider a large
> >>>> refactor in order to incorporate the new feature. What if there was some
> >>>> previous change which bumped processed insns from 200k->700k which
> >>>> _could_ be modified to stress verifier less? Tracking historical
> >>>> verifier stats for each version of the program over the years would
> >>>> reduce manual work necessary to find such a change.
> >>>>
> >>>>
> >>>> Although parsing the text log could work for this scenario, a solution
> >>>> that's resilient to log format and other verifier changes would be
> >>>> preferable.
> >>>>
> >>>> This patchset adds a bpf_prog_verif_stats struct - containing the same
> >>>> data logged by print_verification_stats - which can be retrieved as part
> >>>> of bpf_prog_info. Looking for general feedback on approach and a few
> >>>> specific areas before fleshing it out further:
> >>>>
> >>>> * None of my usecases require storing verif_stats for the lifetime of a
> >>>>   loaded prog, but adding to bpf_prog_aux felt more correct than trying
> >>>>   to pass verif_stats back as part of BPF_PROG_LOAD
> >>>> * The verif_stats are probably not generally useful enough to warrant
> >>>>   inclusion in fdinfo, but hoping to get confirmation before removing
> >>>>   that change in patch 1
> >>>> * processed_insn, verification_time, and total_states are immediately
> >>>>   useful for me, rest were added for parity with
> >>>>      print_verification_stats. Can remove.
> >>>> * Perhaps a version field would be useful in verif_stats in case future
> >>>>   verifier changes make some current stats meaningless
> >>>> * Note: stack_depth stat was intentionally skipped to keep patch 1
> >>>>   simple. Will add if approach looks good.
> >>>
> >>> Sorry for the delay. LPC consumes a lot of mental energy :)
> >>>
> >>> I see the value of exposing some of the verification stats as prog_info.
> >>> Let's look at the list:
> >>> struct bpf_prog_verif_stats {
> >>>        __u64 verification_time;
> >>>        __u32 insn_processed;
> >>>        __u32 max_states_per_insn;
> >>>        __u32 total_states;
> >>>        __u32 peak_states;
> >>>        __u32 longest_mark_read_walk;
> >>> };
> >>> verification_time is non deterministic. It varies with frequency
> >>> and run-to-run. I don't see how alerting tools can use it.
> >>
> >> Makes sense to me, will get rid of it.
> >>
> >>> insn_processed is indeed the main verification metric.
> >>> By now it's well known and understood.
> >>>
> >>> max_states_per_insn, total_states, etc were the metrics I've studied
> >>> carefully with pruning, back tracking and pretty much every significant
> >>> change I did or reiviewed in the verifier. They're useful to humans
> >>> and developers, but I don't see how alerting tools will use them.
> >>>
> >>> So it feels to me that insn_processed alone will be enough to address the
> >>> monitoring goal.
> >>
> >> For the concrete usecase in my original message insn_processed would be
> >> enough. For the others - I thought there might be value in gathering
> >> those "fleetwide" to inform verifier development, e.g.:
> >>
> >> "Hmm, this team's libbpf program has been regressing total_states over
> >> past few {kernel, llvm} rollouts, but they haven't been modifying it.
> >> Let's try to get a minimal repro, send to bpf@vger, and contribute to
> >> selftests if it is indeed hitting a weird verifier edge case"
> >>
> >> So for those I'm not expecting them to be useful to alert on or be a
> >> number that the average BPF program writer needs to care about.
> >>
> >> Of course this is hypothetical as I haven't tried to gather such data
> >> and look for interesting patterns. But these metrics being useful to
> >> you when looking at significant verifier changes is a good sign.
> > 
> > One reason to not add all those fields is to not end up with
> > meaningless stats (in the future) in UAPI. One way to work around that
> > is to make it "unstable" by providing it through raw_tracepoint as
> > internal kernel struct.
> > 
> > Basically, the proposal would be: add new tracepoint for when BPF
> > program is verified, either successfully or not. As one of the
> > parameters provide stats struct which is internal to BPF verifier and
> > is not exposed through UAPI.
> > 
> > Such tracepoint actually would be useful more generally as well, e.g.,
> > to monitor which programs are verified in the fleet, what's the rate
> > of success/failure (to detect verifier regression), what are the stats
> > (verification time actually would be good to have there, again for
> > stats and detecting regression), etc, etc.
> > 
> > WDYT?
> > 
> 
> Seems reasonable to me - and attaching a BPF program to the tracepoint to
> grab data is delightfully meta :)
> 
> I'll do a pass on alternate implementation with _just_ tracepoint, no 
> prog_info or fdinfo, can add minimal or full stats to those later if
> necessary.

We can also use a hook point here to enforce policy on allowing the
BPF program to load or not using the stats here. For now basic
insn is a good start to allow larger/smaller programs to be loaded,
but we might add other info like call bitmask, features, types, etc.
If one of the arguments is the bpf_attr struct we can just read
lots of useful program info out directly.

We would need something different from a tracepoint though to let
it return a reject|accept code. How about a new hook type that
has something similar to sockops that lets us just return an
accept or reject code?

By doing this we can check loader signatures here to be sure the
loader is signed or otherwise has correct permissions to be loading
whatever type of bpf program is here.

Thanks,
John
