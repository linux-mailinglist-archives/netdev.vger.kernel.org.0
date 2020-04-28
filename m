Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02DA1BC4C0
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgD1QO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728037AbgD1QO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:14:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF7AC03C1AB;
        Tue, 28 Apr 2020 09:14:28 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so22091514lja.13;
        Tue, 28 Apr 2020 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnXnmnUGnJoiqmak1qzJ2uo0ETz1Y/4EWDM5M5+McW4=;
        b=fGS2oo0V4315baKko4RVx1wvx1RkPf6mVsOhdOrIDDYWBQzPnkKlTSp8QHvAj1CDy9
         nzIxC+HzhXpaIa7msXlP2DMi5d8gpXeO92dOxA7FQ2waSsG3js+AV+/HHAjo/ZlDoJQw
         hcb9MPNRB8gjqdA06X2g4kJnT47UJptPJsJzQRnzBRzkOgQ4K9xgW14vozetfeDfkS4z
         PiYhDAK0FEGJjn0A7uVFpN+BKbglLueXcL1gS5csd30zCtQk4+zZhwNbBojouyxNvpah
         MVMeHsvKv2teVMfuSxNxQDDi643nUKW1KifpFcZbs5cRdQpyLgvy55+a1NCbpap4kJ/N
         NLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnXnmnUGnJoiqmak1qzJ2uo0ETz1Y/4EWDM5M5+McW4=;
        b=n2BdI3BSFrziwKdD/OFP31BCCzFVnVnt/apNQ3xI3YaOKEOc9qkLIY56in2ZyzKLJc
         38Vf0zPjX9IB3FGGyYPhw7e57gts+xUrrZ5r6lDSxsxWZtVIe/DvgxlKPh+T1R6FPTet
         JMLKpskX1maO4Na7COB2hFPe5FEXONtNpTS4fsHRNW2bwjKNndIkIDZL02uMtJ1pirMN
         DYHz2GNby5gJ0QQJOuAPWWEmwVluS+U7qt6kkLnV1m5qIbf19/sOJgKhH3k6TZjDdl+n
         sgLAFRYGHs5qt02y4hZ2yRjmJrf7KxLZKaHxr/TvZf3RzPFu+QQ+eTTxjfSSzwVmYwWc
         ruoA==
X-Gm-Message-State: AGi0PuYoJdIFxq7m85dX9dhLuWiPZayaWLZ1ZL5wsSq4q/XeQsunQDVa
        t+gSatM/JFGTmyi5uh6TBX2vkAoKPFriWS9Jsj0=
X-Google-Smtp-Source: APiQypIXDLASfkazcJ+MQrYti2Ag3mLrjAObISlzH9I+j+TwEOwLu6ohEsL7aLot1tJOG7n4pooQE3SwWHE1K4b6jjM=
X-Received: by 2002:a2e:9011:: with SMTP id h17mr18597862ljg.138.1588090466535;
 Tue, 28 Apr 2020 09:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAK7LNARHd0DXRLONf6vH_ghsYZjzoduzkixqNDpVqqPx0yHbHg@mail.gmail.com>
In-Reply-To: <CAK7LNARHd0DXRLONf6vH_ghsYZjzoduzkixqNDpVqqPx0yHbHg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Apr 2020 09:14:15 -0700
Message-ID: <CAADnVQ+RvDq9qvNgSkwaMO8QcDG1gCm-SkGgNHyy1gVC3_0w=A@mail.gmail.com>
Subject: Re: BPFilter: bit size mismatch between bpfiter_umh and vmliux
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 3:54 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Hi.
>
> I have a question about potential bit size
> mismatch between vmlinux and bpfilter_umh.
>
>
> net/bpfilter/bpfilter_umh is compiled for the
> default machine bit of the compiler.
> This may not match to the kernel bit size.
>
>
> This happens in the following scenario.
>
> GCC can be compiled as bi-arch.
> If you use GCC that defaults to 64-bit,
> you can give -m32 flag to produce the 32 bit code.
>
> When you build the kernel for 32-bit, -m32 is
> properly passed for building the kernel space objects.
> However, it is missing while building the userspace
> objects for bpfilter_umh.
>
>
> For example, my build host is x86_64 Ubuntu.
>
> If I build the kernel for i386
> with CONFIG_BPFILTER_UMH=y,
> the embedded bpfilter_umh is 64bit ELF.
>
> You can reproduce it by the following command on the
> mainline kernel.
>
> masahiro@oscar:~/ref/linux$ make ARCH=i386 defconfig
> masahiro@oscar:~/ref/linux$ scripts/config -e BPFILTER
> masahiro@oscar:~/ref/linux$ scripts/config -e BPFILTER_UMH
> masahiro@oscar:~/ref/linux$ make $(nproc) ARCH=i386
>    ...
> masahiro@oscar:~/ref/linux$ file vmlinux
> vmlinux: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV),
> statically linked,
> BuildID[sha1]=7ac691c67b4fe9b0cd46b45a2dc2d728d7d87686, not stripped
> masahiro@oscar:~/ref/linux$ file net/bpfilter/bpfilter_umh
> net/bpfilter/bpfilter_umh: ELF 64-bit LSB executable, x86-64, version
> 1 (GNU/Linux), statically linked,
> BuildID[sha1]=baf1ffe26f4c030a99a945fc22924c8c559e60ac, for GNU/Linux
> 3.2.0, not stripped
>
>
>
>
> At least, the build was successful,
> but does this work at runtime?
>
> If this is a bug, I can fix it cleanly.
>
> I think the bit size of the user mode helper
> should match to the kernel bit size. Is this correct?

yes. they should match.
In theory we can have -m32 umh running on 64-bit kernel,
but I wouldn't bother adding support for such thing
until there is a use case.
Running 64-bit umh on 32-bit kernel is no go.
