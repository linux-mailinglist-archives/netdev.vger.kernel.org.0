Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CD634ACBC
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCZQol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhCZQoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 12:44:21 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D94C0613AA;
        Fri, 26 Mar 2021 09:44:20 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 8so6429308ybc.13;
        Fri, 26 Mar 2021 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tRN5VAE4WkJxfop58HKg1C3hfeOFy8L/8TWojLksxs0=;
        b=USQY59x0ozK+9Brn44qlEk3R43qi7cz3rNGE36Sx3h9YA6GNDcO3n6bTuIMRrs9Nym
         sqQ30a0IdjdMV9c/XDDh+58PkyyJWOhd6OY3FfgIwWqcrwdQyYoKrTZh0vV83Furrfzc
         pw02zcZynajq9szaTZF/Gz2LmauDn/Ro0idLJ6ktdPVP5U6+Q9CL08WPbSfdmu8O7ihd
         afOfjomCpUSYij2Zo0g7VJZYzMWt4DdAaT5f53kCyjLPZvzux9fAZCOCXUmjCv7AhMvZ
         tAg1wEUkYI/aOJNoV6+YLOqFomawgM75XmZjZGUVOJSh1DFaw0+p1sajM/TFlkluNsfH
         /+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tRN5VAE4WkJxfop58HKg1C3hfeOFy8L/8TWojLksxs0=;
        b=S3UG6l3+UeGYVZyq5r82zi3Ze7qkyIV6jr9AKUwgdvu8EemVxLgvNkYyAm7bWfqehP
         gmZ1NsCfQKCF4fbVztmIMl1qMhyIT+JsbCZyCOxBd0IiRtT0ow+PwWalyNAQzkMWQ3X4
         iuBQJnbsPsijifS3Mce4heaw2wr70xsay5W/rlafCzr/mxlko7cjsez7AL4feihupaQB
         HC1gIIt0qV54lShUOwajaA5384mkikI3IOMe2nOdy9RuHnrIz5vEAsD/q4s7TssamcIg
         dfnLjpKIXWruEwb63pzd7vU7KKEcySw0G3REZdkLVA/IgaOfDWYUBM75pc5Xts8x1JXo
         aIqg==
X-Gm-Message-State: AOAM531Z02jGhl6Eor2rhgREi0t9S6nvkpeNW9QJw/A7OH2rM2wIJreH
        LY8TCNjpTSAZQtgyw9R0IuS6L/RvDLSkXwPPhgs=
X-Google-Smtp-Source: ABdhPJzvbOPD6svduyaIvb4+fOrRDEKZUWRdFRMrnkmtvT8pfOmjV5LRQ3/eElAbRYeBiLx1oMtP8QT9L47cA5T+cRI=
X-Received: by 2002:a25:874c:: with SMTP id e12mr19726978ybn.403.1616777058610;
 Fri, 26 Mar 2021 09:44:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210319205909.1748642-1-andrii@kernel.org> <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp> <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp> <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
 <20210322175443.zflwaf7dstpg4y2b@ast-mbp>
In-Reply-To: <20210322175443.zflwaf7dstpg4y2b@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Mar 2021 09:44:07 -0700
Message-ID: <CAEf4BzYHP00_iav1Y_vhMXBmAO3AnqqBz+uK-Yu=NGYUMEUyxw@mail.gmail.com>
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

On Mon, Mar 22, 2021 at 10:54 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Mar 22, 2021 at 09:56:19AM -0700, Andrii Nakryiko wrote:
> > On Sun, Mar 21, 2021 at 6:07 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sat, Mar 20, 2021 at 10:00:57AM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Mar 19, 2021 at 7:22 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Mar 19, 2021 at 01:59:09PM -0700, Andrii Nakryiko wrote:
> > > > > > Add ability to skip BTF generation for some BPF object files. This is done
> > > > > > through using a convention of .nobtf.c file name suffix.
> > > > > >
> > > > > > Also add third statically linked file to static_linked selftest. This file has
> > > > > > no BTF, causing resulting object file to have only some of DATASEC BTF types.
> > > > > > It also is using (from BPF code) global variables. This tests both libbpf's
> > > > > > static linking logic and bpftool's skeleton generation logic.
> > > > >
> > > > > I don't like the long term direction of patch 1 and 3.
> > > > > BTF is mandatory for the most bpf kernel features added in the last couple years.
> > > > > Making user space do quirks for object files without BTF is not something
> > > > > we should support or maintain. If there is no BTF the linker and skeleton
> > > > > generation shouldn't crash, of course, but they should reject such object.
> > > >
> > > > I don't think tools need to enforce any policies like that. They are
> > > > tools and should be unassuming about the way they are going to be used
> > > > to the extent possible.
> > >
> > > Right and bpftool/skeleton was used with BTF since day one.
> > > Without BTF the skeleton core ideas are lost. The skeleton api
> > > gives no benefit. So what's the point of adding support for skeleton without BTF?
> > > Is there a user that would benefit? If so, what will they gain from
> > > such BTF-less skeleton?
> >
> > The only part of skeleton API that's not available is convenient
> > user-space access to global variables. If you don't use global
> > variables you don't use BTF at all with skeleton. So all features but
> > one work without BTF just fine: compile-time maps and progs (and
> > links) references, embedding object file in .skel.h, and even
> > automatic memory-mapping of .data/.rodata/.bss (just unknown struct
> > layout).
> >
> > Compile-time maps and progs and separately object file embedding in C
> > header are useful in their own rights, even individually. There is no
> > single "core idea" of the BPF skeleton in my mind. What is it for you?
> >
> > So given none of the fixes are horrible hacks and won't incur
> > additional maintenance costs, what's the problem with accepting them?
>
> Because they double the maintenance cost now and double the support forever.
> We never needed to worry about skeleton without BTF and now it would be
> a thing ? So all tests realistically need to be doubled: with and without BTF.

2x? Realistically?.. No, I wouldn't say so. :) Extra test or a few
might be warranted, but doubling the amount of testing is a huge
exaggeration.

> Even more so for static linking. If one .o has BTF and another doesn't
> what linker suppose to do? Keep it, but the linked BTF will sort of cover
> both .o-s, but line info in some funcs will be missing.
> All these weird combinations would need to be tested.

BPF static linker already supports that mode, btw. And yes, it
shouldn't crash the kernel. And you don't need a skeleton or static
linker to do that to the kernel, so I don't know how that is a new
mode of operation.

> The sensible thing to do would be to reject skel generation without BTF
> and reject linking without BTF. The user most likely forgot -g during
> compilation of bpf prog. The bpftool should give the helpful message
> in such case. Whether it's generating skel or linking. Silently proceeding
> and generating half-featured skeleton is not what user wanted.

Sure, a warning message makes sense. Outright disabling this - not so
much. I still can't get why I can't get BPF skeleton and static
linking without BTF, if I really want to. Both are useful without BTF.

So I don't know, it's the third different argument I'm addressing
without any conclusion on the previous two. It, sadly, feels rather
like fighting subjective personal preferences, rather than a
discussion.
