Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC7344C6F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhCVQ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhCVQ4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:56:31 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2459C061574;
        Mon, 22 Mar 2021 09:56:30 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m3so7314484ybt.0;
        Mon, 22 Mar 2021 09:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O8a1/KMRD2gZlRZYI2i+SlO+VhWKrwDB0WvdEpBaVbE=;
        b=t5Um+QAdxVORPIeyt/dcD/BvreZIWg82Edi10Gou+E/9cYzuB2K3D0xF18Usg+EHV5
         kM/a4eZZvcx14jvUGVB65NzTPTmz7uaP6N6hR41MqPuccZ4xcoQJC+qOGup4wz0+yFuD
         M5T/hkei/wR/0bedell5Nk8URyUabim6SQDR00j2NMSARTorCG/RUV2dHfl40rmdKTsF
         lLk3qq7Q1a6splKo6HMcePRpJznaHgwE+5EaFmpz8gaWPH8yO2ZswTSk5WdACg/gpS/E
         fFzglId0NSSNJ6r9mkDymQcUv2GaoVFmBsfUtcLAWTXBuda0pr+quUCy5jip6/qWHpLO
         ncng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O8a1/KMRD2gZlRZYI2i+SlO+VhWKrwDB0WvdEpBaVbE=;
        b=TYwx8K/yPecNjvAP6DTWH6IZk/S6FtgpG1aZzA+drsId8QolJQyM7NKRTJffoCynIY
         MbRKjqgVJS4clAbAHnixmGXMLoZYhmMGuJKVtpt9czUK7YZuWHhKWNQUn1jr+eduuc2Y
         VZXH1lE+pFQY5L2xQVLOBN2WBD1VmeyZKlUsSPmsTfXjGDe/b4fZloyHBDn+c2a5Jqb0
         3mx1UD0TvDgpIrVUtGZSqC3C0mK2PPB389ODI8TL1zBUOgm5vWBUXiLPEDZ0iPUIQ5Gn
         AWmUr3pkC9Dtv3f1d7t52SnZ9lj3dnOE27KxmD6JDoQ0Hh4dVNp9Owx9jOnyO7KPPVJm
         lCjQ==
X-Gm-Message-State: AOAM532bDjekV5RCwwuZaAeIztmR8fWJDCiOAPInJ4lfJuw0+cqiREmR
        NLcUOKZXEggV9oYDd10z2iUe4qM8oWl5d6N1QcE=
X-Google-Smtp-Source: ABdhPJynFSu7SS+LXJeOFDSKUSk2+lgJrWGC2LWRfVF9fLj80uzqBt9QyF6f3qHQZafgqUqlX7kLBjGtGuSgbgkM0l8=
X-Received: by 2002:a25:874c:: with SMTP id e12mr517350ybn.403.1616432190180;
 Mon, 22 Mar 2021 09:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210319205909.1748642-1-andrii@kernel.org> <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp> <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp>
In-Reply-To: <20210322010734.tw2rigbr3dyk3iot@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Mar 2021 09:56:19 -0700
Message-ID: <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 6:07 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Mar 20, 2021 at 10:00:57AM -0700, Andrii Nakryiko wrote:
> > On Fri, Mar 19, 2021 at 7:22 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Mar 19, 2021 at 01:59:09PM -0700, Andrii Nakryiko wrote:
> > > > Add ability to skip BTF generation for some BPF object files. This is done
> > > > through using a convention of .nobtf.c file name suffix.
> > > >
> > > > Also add third statically linked file to static_linked selftest. This file has
> > > > no BTF, causing resulting object file to have only some of DATASEC BTF types.
> > > > It also is using (from BPF code) global variables. This tests both libbpf's
> > > > static linking logic and bpftool's skeleton generation logic.
> > >
> > > I don't like the long term direction of patch 1 and 3.
> > > BTF is mandatory for the most bpf kernel features added in the last couple years.
> > > Making user space do quirks for object files without BTF is not something
> > > we should support or maintain. If there is no BTF the linker and skeleton
> > > generation shouldn't crash, of course, but they should reject such object.
> >
> > I don't think tools need to enforce any policies like that. They are
> > tools and should be unassuming about the way they are going to be used
> > to the extent possible.
>
> Right and bpftool/skeleton was used with BTF since day one.
> Without BTF the skeleton core ideas are lost. The skeleton api
> gives no benefit. So what's the point of adding support for skeleton without BTF?
> Is there a user that would benefit? If so, what will they gain from
> such BTF-less skeleton?

The only part of skeleton API that's not available is convenient
user-space access to global variables. If you don't use global
variables you don't use BTF at all with skeleton. So all features but
one work without BTF just fine: compile-time maps and progs (and
links) references, embedding object file in .skel.h, and even
automatic memory-mapping of .data/.rodata/.bss (just unknown struct
layout).

Compile-time maps and progs and separately object file embedding in C
header are useful in their own rights, even individually. There is no
single "core idea" of the BPF skeleton in my mind. What is it for you?

So given none of the fixes are horrible hacks and won't incur
additional maintenance costs, what's the problem with accepting them?
