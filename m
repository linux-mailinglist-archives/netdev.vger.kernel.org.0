Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB8149A48F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375143AbiAYAT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455412AbiAXVfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:35:23 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A4CC0BD104;
        Mon, 24 Jan 2022 12:22:22 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d188so6704968iof.7;
        Mon, 24 Jan 2022 12:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4mZfIWY8oZHBJvbezAfQki3gasCfLQjRP0A4uvZXh/s=;
        b=f3bagKMjQoICG1f7F8PAR6AfPBuB2sPAAYOn+F/1y8nGDFV+mhKSTRK66UYPdoZhF4
         b4b8kuWi/F9c1+OUlM1lZpaBQxYZkAuRWxGBMH3okjSHBe85wr6Gc7cq5e4G51dDD5Lh
         h8DJEhC8EMutrkRSGEpGU4pcwPfuh0/Lhhpo5UIGY/V17w7IG0oP1XFnZ2qL5zWTzksR
         2QTJvsBxtEyrRbbDOCQZc3wHVpW9PGcdr7sEOpiLbYkUs3Ehilz53s5vBSOQjgVPK8ZK
         o02VCW6NDe6DRGsuwdKArQVJv/RniD3vc5uaJoiKnxYkFIjuysXH/xJdVmimnPSHFJMA
         PwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4mZfIWY8oZHBJvbezAfQki3gasCfLQjRP0A4uvZXh/s=;
        b=ZLzaRBkVvBO/fYZpkdBYJptGmA86GdcU8yBuICu3VwoO5MvmXIUXeghgsgeL/L+ZTZ
         AUZTL9yeB+BX6wgeTPaUNhRKYicvbNf3NZuT+J8lwxWHnnBhBGDmMun6QCdz7loKZVnY
         AMEtxRq+WQJPauPpflC2+2+1cZgXZ4E2h7mISJcZ26MdYrbMZLe/eXB2RD+vUGSXEy/4
         AF69qAeNqfGDJc6VvsrDanyBgrBkYVjQARUE4KqvNaGO/7/mTS7B2Lnb1yXk3OuiyJBS
         NjOxAt0AWmInNf9S6HUEMXqftH3eV+ycZzDYsNYnyQpZMa4JJnS2bkJDdcb+Id0DoqE/
         gxBQ==
X-Gm-Message-State: AOAM531vUL1/g526sW1gjRiEmlHWJJBQuB3iCoN1EScVLPb8BBNBtY1/
        vBwyxRuD/nBLG2CQqiR/yP3UL01xU52vjV73xIE=
X-Google-Smtp-Source: ABdhPJwwtlX+lokeNR+f3H0pCCz3YM3DTq4o8pav9NyzwHzMKwIBjf3M3TKTL9htJz0svoFvh2ziB1+HWC6Cc14m5/8=
X-Received: by 2002:a05:6638:1212:: with SMTP id n18mr4604420jas.93.1643055741615;
 Mon, 24 Jan 2022 12:22:21 -0800 (PST)
MIME-Version: 1.0
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
 <CAEf4Bzbbimea3ydwafXSHFiEffYx5zAcwGNKk8Zi6QZ==Vn0Ug@mail.gmail.com>
 <20220121135510.7cfa6540e31824aa39b1c1b8@kernel.org> <CAEf4Bza0eTft2kjcm9HhKpAm=AuXnGwZfZ+sYpVVBvj93PBreQ@mail.gmail.com>
 <Ye3ptcW0eAFRYm58@krava> <20220124092405.665e9e0fc3ce14b16a1a9fcf@kernel.org> <Ye6ZyeHQtPfUoSvX@krava>
In-Reply-To: <Ye6ZyeHQtPfUoSvX@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jan 2022 12:22:10 -0800
Message-ID: <CAEf4BzbrVBXDJA4qbCgudiiLGtHNyUQAOuE=AUwfxzMrF=Wr=w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/9] fprobe: Introduce fprobe function entry/exit probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 4:21 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jan 24, 2022 at 09:24:05AM +0900, Masami Hiramatsu wrote:
> > On Mon, 24 Jan 2022 00:50:13 +0100
> > Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > > On Fri, Jan 21, 2022 at 09:29:00AM -0800, Andrii Nakryiko wrote:
> > > > On Thu, Jan 20, 2022 at 8:55 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > >
> > > > > On Thu, 20 Jan 2022 14:24:15 -0800
> > > > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > > On Wed, Jan 19, 2022 at 6:56 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > > > >
> > > > > > > Hello Jiri,
> > > > > > >
> > > > > > > Here is the 3rd version of fprobe. I added some comments and
> > > > > > > fixed some issues. But I still saw some problems when I add
> > > > > > > your selftest patches.
> > > > > > >
> > > > > > > This series introduces the fprobe, the function entry/exit probe
> > > > > > > with multiple probe point support. This also introduces the rethook
> > > > > > > for hooking function return as same as kretprobe does. This
> > > > > > > abstraction will help us to generalize the fgraph tracer,
> > > > > > > because we can just switch it from rethook in fprobe, depending
> > > > > > > on the kernel configuration.
> > > > > > >
> > > > > > > The patch [1/9] and [7/9] are from Jiri's series[1]. Other libbpf
> > > > > > > patches will not be affected by this change.
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> > > > > > >
> > > > > > > However, when I applied all other patches on top of this series,
> > > > > > > I saw the "#8 bpf_cookie" test case has been stacked (maybe related
> > > > > > > to the bpf_cookie issue which Andrii and Jiri talked?) And when I
> > > > > > > remove the last selftest patch[2], the selftest stopped at "#112
> > > > > > > raw_tp_test_run".
> > > > > > >
> > > > > > > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#m242d2b3a3775eeb5baba322424b15901e5e78483
> > > > > > >
> > > > > > > Note that I used tools/testing/selftests/bpf/vmtest.sh to check it.
> > > > > > >
> > > > > > > This added 2 more out-of-tree patches. [8/9] is for adding wildcard
> > > > > > > support to the sample program, [9/9] is a testing patch for replacing
> > > > > > > kretprobe trampoline with rethook.
> > > > > > > According to this work, I noticed that using rethook in kretprobe
> > > > > > > needs 2 steps.
> > > > > > >  1. port the rethook on all architectures which supports kretprobes.
> > > > > > >     (some arch requires CONFIG_KPROBES for rethook)
> > > > > > >  2. replace kretprobe trampoline with rethook for all archs, at once.
> > > > > > >     This must be done by one treewide patch.
> > > > > > >
> > > > > > > Anyway, I'll do the kretprobe update in the next step as another series.
> > > > > > > (This testing patch is just for confirming the rethook is correctly
> > > > > > >  implemented.)
> > > > > > >
> > > > > > > BTW, on the x86, ftrace (with fentry) location address is same as
> > > > > > > symbol address. But on other archs, it will be different (e.g. arm64
> > > > > > > will need 2 instructions to save link-register and call ftrace, the
> > > > > > > 2nd instruction will be the ftrace location.)
> > > > > > > Does libbpf correctly handle it?
> > >
> > > hm, I'm probably missing something, but should this be handled by arm
> > > specific kernel code? user passes whatever is found in kallsyms, right?
> >
> > In x86, fentry nop is always placed at the first instruction of the function,
> > but the other arches couldn't do that if they use LR (link register) for
> > storing return address instead of stack. E.g. arm64 saves lr and call the
> > ftrace. Then ftrace location address of a function is not the symbol address.
> >
> > Anyway, I updated fprobe to handle those cases. I also found some issues
> > on rethook, so let me update the series again.
>
> great, I reworked the bpf fprobe link change and need to add the
> symbols attachment support, so you don't need to include it in
> new version.. I'll rebase it and send on top of your patchset

Using just addresses (IPs) for retsnoop and bpftrace is fine because
such generic tools are already parsing kallsyms and probably building
some lookup table. But in general, having IP-based attachment is a
regression from current perf_event_open-based kprobe, where user is
expected to pass symbolic function name. Using IPs has an advantage of
being unambiguous (e.g., when same static function name in kernel
belongs to multiple actual functions), so there is that. But I was
also wondering wouldn't kernel need to do symbol to IP resolution
anyways just to check that we are attaching to function entry?

I'll wait for your patch set to see how did you go about it in a new revision.


>
> thanks,
> jirka
>
> >
> > > > > >
> > > > > > libbpf doesn't do anything there. The interface for kprobe is based on
> > > > > > function name and kernel performs name lookups internally to resolve
> > > > > > IP. For fentry it's similar (kernel handles IP resolution), but
> > > > > > instead of function name we specify BTF ID of a function type.
> > > > >
> > > > > Hmm, according to Jiri's original patch, it seems to pass an array of
> > > > > addresses. So I thought that has been resolved by libbpf.
> > > > >
> > > > > +                       struct {
> > > > > +                               __aligned_u64   addrs;
> > > >
> > > > I think this is a pointer to an array of pointers to zero-terminated C strings
> > >
> > > I used direct addresses, because bpftrace already has them, so there was
> > > no point passing strings, I cann add support for that
> >
> > So now both direct address array or symbol array are OK.
> >
> > Thank you,
> >
> > --
> > Masami Hiramatsu <mhiramat@kernel.org>
> >
>
