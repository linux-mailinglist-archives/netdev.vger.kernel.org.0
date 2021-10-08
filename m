Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7DC426E1A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243181AbhJHPwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243225AbhJHPwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 11:52:38 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4564FC061764;
        Fri,  8 Oct 2021 08:50:42 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i11so9423517ila.12;
        Fri, 08 Oct 2021 08:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wOmTV3UlOvmZmVtYO7vIZQjLO4KRW2yG1tmxqQB4RRI=;
        b=DpJe9HsN79B3gsdtD7Aiojr3PrYJNVMaCXdcgeuK5WxIkckFPRjVyuYwRIwRKqgYnp
         p9Z42KU0u/1vAJTqJugS6N/8vT6iiNepeFCdqvjV5CtoX5s4ok6Ivhi/n0C2bDBKwKL8
         lzug8dLoqis7JjMXVx+l3ttaj+u/Ja1y3NHJ9xGevMXuoznt5L4bXQnY9yX699j+TOBr
         tZbEr28HYiIjOfOMymrJU2qN4S6jfoSU4W1y4XcnM+O5woAyGM8A3WRiahPJ9lWngt2X
         a3l2pZQYQHWyrgZpbZTeQYpAnosqfDhRt6HSvgKHE2Q5LTT34xgDytFVbVS0VWIQ6QsE
         wbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wOmTV3UlOvmZmVtYO7vIZQjLO4KRW2yG1tmxqQB4RRI=;
        b=kFzOg7jw5ZU6AG74alZP5eW/oGR6lKpruHT+yrkamRG+6qgeEdf/FFOa4IvfwgKBRy
         Q9S2swoXkz6v/Cjn4Tjj8wf7t4dkIP64eHAK15xpFKfGall1rnVM1Gg3XuDwPvJ5cfdX
         BZtRdXqsZ7AM+wP6JyU/wk4p+JVtvMX+S1JMAe71fRsErqYPVeAXLywMhpJOECCbggT6
         shhB7V8e2F74hzqmDSkSjcFM/LzZlDoHxd0dUzWIkb/tW620MueXx6gOdpaF3inS5THi
         SZETO6c3AZGmFjhKb1Hpj7oP8pqzpQlN8s0Q3zB40SXzhTC/eJYYc0++XbSxvGAAD+xx
         ApCg==
X-Gm-Message-State: AOAM533biDVmKnDg8jRt5wy9BffzfSxb1ykQ4rbuakznzCai+i+o3wHX
        Le10h1z95zoJF4TKaIInmmQ=
X-Google-Smtp-Source: ABdhPJxZtsmAP/l197BYpF8xRrLrsrPzdPZhsDbRyBUpQdxbzzdMpDMMLudDRyHfN38TjwG0kpyXtg==
X-Received: by 2002:a05:6e02:1c47:: with SMTP id d7mr8255536ilg.49.1633708241649;
        Fri, 08 Oct 2021 08:50:41 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l3sm1195715ilg.54.2021.10.08.08.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:50:40 -0700 (PDT)
Date:   Fri, 08 Oct 2021 08:50:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Message-ID: <616068c823efd_1bf120816@john-XPS-13-9370.notmuch>
In-Reply-To: <2c483e31-27e9-6b9b-15ec-1a3917ecefb3@fb.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp>
 <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
 <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
 <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com>
 <61520b6224619_397f208d7@john-XPS-13-9370.notmuch>
 <CAEf4BzbxYxnQND9JJ4SfQb4kxxkRtk4S4rR2iqkcz6bJ2jdFqw@mail.gmail.com>
 <615270f889bf9_e24c2083@john-XPS-13-9370.notmuch>
 <2c483e31-27e9-6b9b-15ec-1a3917ecefb3@fb.com>
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
> On 9/27/21 9:33 PM, John Fastabend wrote:   
> > Andrii Nakryiko wrote:
> >> On Mon, Sep 27, 2021 at 11:20 AM John Fastabend
> >> <john.fastabend@gmail.com> wrote:
> >>>
> >>> Dave Marchevsky wrote:
> >>>> On 9/23/21 10:02 PM, Andrii Nakryiko wrote:
> >>>>> On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> >>>>>>
> >>>>>> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
> >>>>>>> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
> >>>>>>>> The verifier currently logs some useful statistics in
> >>>>>>>> print_verification_stats. Although the text log is an effective feedback
> >>>>>>>> tool for an engineer iterating on a single application, it would also be
> >>>>>>>> useful to enable tracking these stats in a more structured form for
> >>>>>>>> fleetwide or historical analysis, which this patchset attempts to do.
> >>>>>>>>
> > 
> > [...] 
> > 
> >>>>
> >>>> Seems reasonable to me - and attaching a BPF program to the tracepoint to
> >>>> grab data is delightfully meta :)
> >>>>
> >>>> I'll do a pass on alternate implementation with _just_ tracepoint, no
> >>>> prog_info or fdinfo, can add minimal or full stats to those later if
> >>>> necessary.
> 
> Actually I ended up pushing a simple add of insn_processed to prog_info, 
> fdinfo instead of bare tracepoint. The more general discussion here is
> interesting - if we can inject some custom logic into various points in
> verification process, can gather arbitrary stats or make policy decisions
> from the same attach points.
> 
> >>>
> >>> We can also use a hook point here to enforce policy on allowing the
> >>> BPF program to load or not using the stats here. For now basic
> >>> insn is a good start to allow larger/smaller programs to be loaded,
> >>> but we might add other info like call bitmask, features, types, etc.
> >>> If one of the arguments is the bpf_attr struct we can just read
> >>> lots of useful program info out directly.
> >>>
> >>> We would need something different from a tracepoint though to let
> >>> it return a reject|accept code. How about a new hook type that
> >>> has something similar to sockops that lets us just return an
> >>> accept or reject code?
> >>>
> >>> By doing this we can check loader signatures here to be sure the
> >>> loader is signed or otherwise has correct permissions to be loading
> >>> whatever type of bpf program is here.
> >>
> >> For signing and generally preventing some BPF programs from loading
> >> (e.g., if there is some malicious BPF program that takes tons of
> >> memory to be validated), wouldn't you want to check that before BPF
> >> verifier spent all those resources on verification? So maybe there
> >> will be another hook before BPF prog is validated for that? Basically,
> >> if you don't trust any BPF program unless it is signed, I'd expect you
> >> check signature before BPF verifier does its heavy job.
> > 
> > Agree, for basic sig check or anything that just wants to look at
> > the task_struct storage for some attributes before we verify is
> > more efficient. The only reason I suggested after is if we wanted
> > to start auditing/enforcing on calls or map read/writes, etc. these
> > we would need the verifier to help tabulate.
> 
> This is the "Bob isn't signed, so ensure that Bob can only read from 
> Alice's maps" case from your recent talk, right? 

Correct.

> 
> I'd like to add another illustrative usecase: "progs of type X can 
> use 4k of stack, while type Y can only use 128 bytes of stack". For
> the 4k case, a single attach point after verification is complete 
> wouldn't work as the prog would've been eagerly rejected.

Makes sense. Another use case would be to allow more tailcalls. 32 has
become limiting for some of our use cases where we have relatively small
insn counts, but tail calls >32 may happen. If we bumped this to
128 for example we might want to only allow specific prog types to
allow it.

> 
> Alexei suggested adding some empty noinline functions with 
> ALLOW_ERROR_INJECTION at potential attach points, then attaching 
> BPF_MODIFY_RETURN progs to inject custom logic. This would allow 
> arbitrarily digging around while optionally affecting return result.
> 
> WDYT?

That is exactly what I had in mind as well. And what I did to get
the example to work in the talk.

Also we would want a few other of these non-inline verdict locations
as well mostly to avoid having to setup a full LSM environment when we
just want some simple BPF verdict actions at key hooks and/or to
trigger our CI on some edge cases that are tricky to hit by luck.

> 
> > When I hacked it in for experimenting I put the hook in the sys
> > bpf load path before the verifier runs. That seemed to work for
> > the simpler sig check cases I was running.
> > 
> > OTOH though if we have a system with lots of BPF failed loads this
> > would indicate a more serious problem that an admin should fix
> > so might be nicer code-wise to just have a single hook after verifier
> > vs optimizing to two one in front and one after. 
> > 
> >>
> >>>
> >>> Thanks,
> >>> John
> > 
> > 
