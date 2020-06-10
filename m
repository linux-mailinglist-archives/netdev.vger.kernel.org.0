Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E345E1F4CDF
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 07:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgFJF0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 01:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgFJF0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 01:26:44 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05B5C05BD1E;
        Tue,  9 Jun 2020 22:26:43 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id k22so839186qtm.6;
        Tue, 09 Jun 2020 22:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LVHd9w66jWmrnJqXfNVLpDFscMb5hc4Ib+H9kk2r9UM=;
        b=UjqS8x6cb6jh5AR4v1mcKqyQuFqtt1ir9leW14shUwEsckZehe+Zgoo17YxgZRv+u6
         SV2TJP7UhKpAdvP3JKHSXf1b/pWa3/O6vgJfe1vnsulhemTZYYaaoZKmCNWDFeBz/OIw
         INLvP72F67hCJbK+bft8+dvIg5V0WRA0whUQDE02Y40mfoIApIjSdytDFcG0bZ1lo/5O
         Lu+PTiGcvxh5mmTzREDzWruyzTF9LSxg5SiIEnvpR7tgaMcsL0rnu9S1kJKV6SP9/g6e
         /I4ZRsnPLLkF1A5PGkwhUkNaj5E665S6+5+J6e/FtspYX1GmwTX9iBfQIHU+PNzc2unF
         YdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LVHd9w66jWmrnJqXfNVLpDFscMb5hc4Ib+H9kk2r9UM=;
        b=NNaPBmfNLVcEj2l3caK1mO9V82WTwbUxwrkfGksZR1o7ijDHq/C7bw5eaKnD0hE7bB
         L87g6zkHfq6x7wCorXhDPFP4LeXRxwGefoZELfo4PyjEXpqvh+HULKQccpEruRp1JSGH
         OaCO60EcW0QgefFXjnQCy0ZKyV24A7VmtYD7uBVUU5A7+5C7IcPrFOfeozg9LHgvOyQL
         o8Sx29wVZxaf2KK55+TOEduMuisntj+UuXopJxLHXa8EUxn9Nc3aTm354vH/8akhOz4z
         nqMyajAVBsbiC5SDnQIzgEEAPQoBNCLDhNfNhuN28qjOmo3EpgxaPTTw46OZQ2QYJDzj
         3yog==
X-Gm-Message-State: AOAM530rBCzRLs32Y4qko2KUNDurKSxth7mlTXxAWeguoAO2UNQ+loNd
        rz9ucatbsP/ZjfeL9CfL7bpyvX2M0I6C2Z1n+xA=
X-Google-Smtp-Source: ABdhPJxk3NJJIbfbESXTsgwWAHXwuBrcKvVWoX1v0AyORaqqC7xH3x5+eCC3KY5WEY/iPhtm1plPedPuM5NITG4s4EA=
X-Received: by 2002:aed:3f3b:: with SMTP id p56mr1394222qtf.93.1591766802782;
 Tue, 09 Jun 2020 22:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200608152052.898491-1-jean-philippe@linaro.org>
 <CAEf4BzaNaHGBxNLdA1RA7VPou7ypO3Z5XBRG5gpkePx4g27yWA@mail.gmail.com> <20200609140504.GA915559@myrica>
In-Reply-To: <20200609140504.GA915559@myrica>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Jun 2020 22:26:31 -0700
Message-ID: <CAEf4BzYhu_L3SwGuybaoz_S1MSXHLNRv=k4+K47xPG2DHqopOQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Fix BTF-to-C conversion of noreturn function pointers
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 9, 2020 at 7:05 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Mon, Jun 08, 2020 at 04:50:37PM -0700, Andrii Nakryiko wrote:
> > On Mon, Jun 8, 2020 at 8:23 AM Jean-Philippe Brucker
> > <jean-philippe@linaro.org> wrote:
> > >
> > > When trying to convert the BTF for a function pointer marked "noreturn"
> > > to C code, bpftool currently generates a syntax error. This happens with
> > > the exit() pointer in drivers/firmware/efi/libstub/efistub.h, in an
> > > arm64 vmlinux. When dealing with this declaration:
> > >
> > >         efi_status_t __noreturn (__efiapi *exit)(...);
> > >
> > > bpftool produces the following output:
> > >
> > >         efi_status_tvolatile  (*exit)(...);
> >
> >
> > I'm curious where this volatile is coming from, I don't see it in
> > __efiapi. But even if it's there, shouldn't it be inside parens
> > instead:
> >
> > efi_status_t (volatile *exit)(...);
>
> It's the __noreturn attribute that becomes "volatile", not the __efiapi.
> My reproducer is:
>
>   struct my_struct {
>           void __attribute__((noreturn)) (*fn)(int);
>   };
>   struct my_struct a;
>
> When generating DWARF info for this, GCC inserts a DW_TAG_volatile_type.
> Clang doesn't add a volatile tag, it just omits the noreturn qualifier.
> From what I could find, it's due to legacy "noreturn" support in GCC [1]:
> before version 2.5 the only way to declare a noreturn function was to
> declare it volatile.

Ok, thanks a lot for extra context, it made it easier to understand
and reproduce. For some reason, I can't repro it even for allyesconfig
build, but your simple repro shows this pretty clearly.

>
> [1] https://gcc.gnu.org/onlinedocs/gcc-4.7.2/gcc/Function-Attributes.html
>
> Given that not all compilers turn "noreturn" into "volatile", and that I
> haven't managed to insert any other modifier (volatile/const/restrict) in
> this location (the efistub example above is the only issue on an
> allyesconfig kernel), I was considering simply removing this call to
> btf_dump_emit_mods(). But I'm not confident enough that it won't ever be
> necessary.

Just removing btf_dump_emit_mods() won't be correct. But there is a
similar GCC-specific work-around for array modifiers. I've implemented
the same for func_proto ([0]), tested with my local allyesconfig.
There are no differences in generated vmlinux.h, so no regressions on
my side. Your repro also is fixed, though. I just sent a patch with
the alternative fix. Could you please test it with your setup and send
your Tested-by: to confirm it fixes your issue?

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200610052335.2862559-1-andriin@fb.com/

>
> > > Fix the error by inserting the space before the function modifier.
> > >
> > > Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
> > > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > ---
> >
> > Can you please add tests for this case into selftests (probably
> > progs/btf_dump_test_case_syntax.c?) So it's clear what's the input and
> > what's the expected output.
>
> Those tests are built with clang, which doesn't emit the "volatile"
> modifier. Should I add a separate test for GCC?

Nah, I don't think it's worth it to try to introduce GCC-compiled
tests just for this.


>
> Thanks,
> Jean
