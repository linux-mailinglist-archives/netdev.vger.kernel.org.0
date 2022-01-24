Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F1249AB76
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 06:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343660AbiAYE4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 23:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S246821AbiAYDsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 22:48:51 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E005C055AB9;
        Mon, 24 Jan 2022 14:58:55 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id y17so3737389ilm.1;
        Mon, 24 Jan 2022 14:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDNdwkpKNppfQdAX/RdKIIe2QTeFkfz/ktdn7giHmGI=;
        b=MBEEVN7qDgCDFdhhT/HSwodOkA2yjB0B9zxtw7ijLPl52m/FAjbCwaWH8yWFYUtARU
         4ZJH46ALo8osGkf0MEwlDgjllQpwLMIcbsuNWbuxW2N0EM8xWtzfxwDl88IU8aUbkork
         HyRmA6KX+zCPsaTu8DYH7MhRh1w5fVM4wF0kwNOsDLIZpeGhPKkGmnB4DzM0jiNfcwr6
         OxrxepvUEe0HCeIFtrK3rgloAORRIvUmwSM3DoYAi6F3xFmj8p9QB8HMIYn6wsQtK4lc
         ywDaz3wUhu2uh12LimtVHU2REFuwrij1vAxG65TQ9IMWvm/yVzNWMkpd9cYH/5wY+vIF
         zsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDNdwkpKNppfQdAX/RdKIIe2QTeFkfz/ktdn7giHmGI=;
        b=zlqyGXvXz6NqxC+AweejPTMhDadKqjzwwiZNfMDdGm3izGzw5HQuxn3VqD39vW4I+N
         v6kDs/R6IHqOHPhWnttACR5tjqDoDpcS4pFXxGUM1HMq47fOwK9+0dSr89d56xjBJmT8
         xJxJvlGL1iQH9BsQ/+APYnBDeZgGi1SPjF2072gIxzkxy5xYdUPM9Huu1Hnjjo1TfQjH
         RGOOCyq3h6Zxrh1oopWbPj3bECDjCmeY3V7jLI2WKg+sM+ujBjDEafGLeNcVioOQL2qP
         nXRknZwQnSq/Ru/2+VGb4FeorLrz8IecMLiifA8jcWSFcIof1DdAGilghou1VbTUB5U0
         DjtA==
X-Gm-Message-State: AOAM5328n2E4gM/Fi/3RbRm5mN+WlF9tlvXpUoR587rft+HGTk6H46hg
        faOA8SzvrW4SVTfL1IoIsOOn+26zBqrq2L6tWw4=
X-Google-Smtp-Source: ABdhPJzw6T+yZqQNek1Xa16SraihhQDl009D5c6isNAz+ULolEbkGeGQItFNTYFc/HRNedmb9oOGygvRXqA0YbOCVLI=
X-Received: by 2002:a05:6e02:190e:: with SMTP id w14mr9072640ilu.71.1643065134544;
 Mon, 24 Jan 2022 14:58:54 -0800 (PST)
MIME-Version: 1.0
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
 <CAEf4Bzbbimea3ydwafXSHFiEffYx5zAcwGNKk8Zi6QZ==Vn0Ug@mail.gmail.com>
 <20220121135510.7cfa6540e31824aa39b1c1b8@kernel.org> <CAEf4Bza0eTft2kjcm9HhKpAm=AuXnGwZfZ+sYpVVBvj93PBreQ@mail.gmail.com>
 <Ye3ptcW0eAFRYm58@krava> <20220124092405.665e9e0fc3ce14b16a1a9fcf@kernel.org>
 <Ye6ZyeHQtPfUoSvX@krava> <CAEf4BzbrVBXDJA4qbCgudiiLGtHNyUQAOuE=AUwfxzMrF=Wr=w@mail.gmail.com>
 <Ye8m2CpVI8VOiMTH@krava>
In-Reply-To: <Ye8m2CpVI8VOiMTH@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Jan 2022 14:58:43 -0800
Message-ID: <CAEf4Bzasj_3EFwW6RvMcV9Z95QUfevUX5eTA5_yWB4Q+KvXuXg@mail.gmail.com>
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

On Mon, Jan 24, 2022 at 2:23 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jan 24, 2022 at 12:22:10PM -0800, Andrii Nakryiko wrote:
>
> SNIP
>
> > > > > > > > > (This testing patch is just for confirming the rethook is correctly
> > > > > > > > >  implemented.)
> > > > > > > > >
> > > > > > > > > BTW, on the x86, ftrace (with fentry) location address is same as
> > > > > > > > > symbol address. But on other archs, it will be different (e.g. arm64
> > > > > > > > > will need 2 instructions to save link-register and call ftrace, the
> > > > > > > > > 2nd instruction will be the ftrace location.)
> > > > > > > > > Does libbpf correctly handle it?
> > > > >
> > > > > hm, I'm probably missing something, but should this be handled by arm
> > > > > specific kernel code? user passes whatever is found in kallsyms, right?
> > > >
> > > > In x86, fentry nop is always placed at the first instruction of the function,
> > > > but the other arches couldn't do that if they use LR (link register) for
> > > > storing return address instead of stack. E.g. arm64 saves lr and call the
> > > > ftrace. Then ftrace location address of a function is not the symbol address.
> > > >
> > > > Anyway, I updated fprobe to handle those cases. I also found some issues
> > > > on rethook, so let me update the series again.
> > >
> > > great, I reworked the bpf fprobe link change and need to add the
> > > symbols attachment support, so you don't need to include it in
> > > new version.. I'll rebase it and send on top of your patchset
> >
> > Using just addresses (IPs) for retsnoop and bpftrace is fine because
> > such generic tools are already parsing kallsyms and probably building
> > some lookup table. But in general, having IP-based attachment is a
> > regression from current perf_event_open-based kprobe, where user is
> > expected to pass symbolic function name. Using IPs has an advantage of
> > being unambiguous (e.g., when same static function name in kernel
> > belongs to multiple actual functions), so there is that. But I was
> > also wondering wouldn't kernel need to do symbol to IP resolution
> > anyways just to check that we are attaching to function entry?
>
> ftrace does its own check for address to attach, it keeps record
> for every attachable address.. so less work for us ;-)

Oh, makes sense, thanks!

>
> >
> > I'll wait for your patch set to see how did you go about it in a new revision.
>
> I agree we should have the support to use symbols as well, I'll add it

sounds good, thanks

>
> jirka
>
