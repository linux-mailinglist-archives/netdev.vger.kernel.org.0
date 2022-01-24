Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9AA497F36
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbiAXMVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:21:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23532 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239285AbiAXMVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643026894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kTQ7PaifhtIuOUaGkRwV0rZi7ijH/GseKpb0aQu503M=;
        b=fqodM0oAkov2yURvwLTqkZ9aB3fhAZDKxKYqjCiHOJRkrhK6rPIzC3aViW/ENDkzT1lknI
        XRoQ4GvBPhp4wzcBdGTWiaXpuubV7pRXwbmuS2sPxzTypf1h3qLa8nI8yW0VrQZKFk+MD+
        qoXaUzIhTED2tIbMfPSDaeUhKIOzhWM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-391ogVjqOlSrP1w4rQfs7Q-1; Mon, 24 Jan 2022 07:21:33 -0500
X-MC-Unique: 391ogVjqOlSrP1w4rQfs7Q-1
Received: by mail-ed1-f72.google.com with SMTP id f21-20020a50d555000000b00407a8d03b5fso3032177edj.9
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 04:21:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kTQ7PaifhtIuOUaGkRwV0rZi7ijH/GseKpb0aQu503M=;
        b=hOvIXxcnaZmOWbFh6q/D3TBb2HDgYMYessQZzuzBk99/H1pcZ4q/3JU9fuwQ1PL9Km
         OpfeifnxXB4bi7z8brVb3ljfrGaT/mSGWE7NlDebiT9uYP5EaOhl9trN4mvMa2klAHam
         JfSs3i1aTuQ4cz+Ut01wmeBu+Lsg6/Y4bIshLMu8eIDEcL9ndeIiS1hRx6K4rfzIJTB5
         lh0hruy8+16Vkk7DYy340A+3qnmHZDRhGgqR6p/q7vXJUentHpi2Twq/HEVxxPSJTe+r
         vGc3Nif02DlbMqYTQM9GKZKqS4ouVu39kbZERe8InAk+f+Xi0zT4eRe17dwEIgeANnIf
         YGbg==
X-Gm-Message-State: AOAM530lDIwb1L2kLXdWrzV/J99gN+Np7CCHe9eznGiM03vfXJcPU4K/
        FXxVK6eGCRUonMRfA81+w06LXwC/2FCyHwYDaTyG22SvUB1Mz88DfMLbvq9ATgOs7seut9o7isp
        OUZku72PUM8Kym9vH
X-Received: by 2002:a17:907:7215:: with SMTP id dr21mr12510964ejc.75.1643026892288;
        Mon, 24 Jan 2022 04:21:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzS7uK/kism/BhI8pUrfROMKoK9OgoCpLIy8AaFqvZDEgRt4IY3hBtM8Sx8szftVyw6NcmdTA==
X-Received: by 2002:a17:907:7215:: with SMTP id dr21mr12510940ejc.75.1643026892036;
        Mon, 24 Jan 2022 04:21:32 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id l3sm6455280edr.61.2022.01.24.04.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:21:31 -0800 (PST)
Date:   Mon, 24 Jan 2022 13:21:29 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Subject: Re: [RFC PATCH v3 0/9] fprobe: Introduce fprobe function entry/exit
 probe
Message-ID: <Ye6ZyeHQtPfUoSvX@krava>
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
 <CAEf4Bzbbimea3ydwafXSHFiEffYx5zAcwGNKk8Zi6QZ==Vn0Ug@mail.gmail.com>
 <20220121135510.7cfa6540e31824aa39b1c1b8@kernel.org>
 <CAEf4Bza0eTft2kjcm9HhKpAm=AuXnGwZfZ+sYpVVBvj93PBreQ@mail.gmail.com>
 <Ye3ptcW0eAFRYm58@krava>
 <20220124092405.665e9e0fc3ce14b16a1a9fcf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124092405.665e9e0fc3ce14b16a1a9fcf@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 09:24:05AM +0900, Masami Hiramatsu wrote:
> On Mon, 24 Jan 2022 00:50:13 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Fri, Jan 21, 2022 at 09:29:00AM -0800, Andrii Nakryiko wrote:
> > > On Thu, Jan 20, 2022 at 8:55 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > >
> > > > On Thu, 20 Jan 2022 14:24:15 -0800
> > > > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > > On Wed, Jan 19, 2022 at 6:56 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > > >
> > > > > > Hello Jiri,
> > > > > >
> > > > > > Here is the 3rd version of fprobe. I added some comments and
> > > > > > fixed some issues. But I still saw some problems when I add
> > > > > > your selftest patches.
> > > > > >
> > > > > > This series introduces the fprobe, the function entry/exit probe
> > > > > > with multiple probe point support. This also introduces the rethook
> > > > > > for hooking function return as same as kretprobe does. This
> > > > > > abstraction will help us to generalize the fgraph tracer,
> > > > > > because we can just switch it from rethook in fprobe, depending
> > > > > > on the kernel configuration.
> > > > > >
> > > > > > The patch [1/9] and [7/9] are from Jiri's series[1]. Other libbpf
> > > > > > patches will not be affected by this change.
> > > > > >
> > > > > > [1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
> > > > > >
> > > > > > However, when I applied all other patches on top of this series,
> > > > > > I saw the "#8 bpf_cookie" test case has been stacked (maybe related
> > > > > > to the bpf_cookie issue which Andrii and Jiri talked?) And when I
> > > > > > remove the last selftest patch[2], the selftest stopped at "#112
> > > > > > raw_tp_test_run".
> > > > > >
> > > > > > [2] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#m242d2b3a3775eeb5baba322424b15901e5e78483
> > > > > >
> > > > > > Note that I used tools/testing/selftests/bpf/vmtest.sh to check it.
> > > > > >
> > > > > > This added 2 more out-of-tree patches. [8/9] is for adding wildcard
> > > > > > support to the sample program, [9/9] is a testing patch for replacing
> > > > > > kretprobe trampoline with rethook.
> > > > > > According to this work, I noticed that using rethook in kretprobe
> > > > > > needs 2 steps.
> > > > > >  1. port the rethook on all architectures which supports kretprobes.
> > > > > >     (some arch requires CONFIG_KPROBES for rethook)
> > > > > >  2. replace kretprobe trampoline with rethook for all archs, at once.
> > > > > >     This must be done by one treewide patch.
> > > > > >
> > > > > > Anyway, I'll do the kretprobe update in the next step as another series.
> > > > > > (This testing patch is just for confirming the rethook is correctly
> > > > > >  implemented.)
> > > > > >
> > > > > > BTW, on the x86, ftrace (with fentry) location address is same as
> > > > > > symbol address. But on other archs, it will be different (e.g. arm64
> > > > > > will need 2 instructions to save link-register and call ftrace, the
> > > > > > 2nd instruction will be the ftrace location.)
> > > > > > Does libbpf correctly handle it?
> > 
> > hm, I'm probably missing something, but should this be handled by arm
> > specific kernel code? user passes whatever is found in kallsyms, right?
> 
> In x86, fentry nop is always placed at the first instruction of the function,
> but the other arches couldn't do that if they use LR (link register) for
> storing return address instead of stack. E.g. arm64 saves lr and call the
> ftrace. Then ftrace location address of a function is not the symbol address.
> 
> Anyway, I updated fprobe to handle those cases. I also found some issues
> on rethook, so let me update the series again.

great, I reworked the bpf fprobe link change and need to add the
symbols attachment support, so you don't need to include it in
new version.. I'll rebase it and send on top of your patchset

thanks,
jirka

> 
> > > > >
> > > > > libbpf doesn't do anything there. The interface for kprobe is based on
> > > > > function name and kernel performs name lookups internally to resolve
> > > > > IP. For fentry it's similar (kernel handles IP resolution), but
> > > > > instead of function name we specify BTF ID of a function type.
> > > >
> > > > Hmm, according to Jiri's original patch, it seems to pass an array of
> > > > addresses. So I thought that has been resolved by libbpf.
> > > >
> > > > +                       struct {
> > > > +                               __aligned_u64   addrs;
> > > 
> > > I think this is a pointer to an array of pointers to zero-terminated C strings
> > 
> > I used direct addresses, because bpftrace already has them, so there was
> > no point passing strings, I cann add support for that
> 
> So now both direct address array or symbol array are OK.
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
> 

