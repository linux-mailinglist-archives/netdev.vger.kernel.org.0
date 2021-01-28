Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27717306A59
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhA1B2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhA1B2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:28:01 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8112C061573;
        Wed, 27 Jan 2021 17:27:21 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id k4so3920900ybp.6;
        Wed, 27 Jan 2021 17:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5oabX9d0jpF1qIOlWbNO/kMyuSTCKbx/P4GY6FSPWA4=;
        b=PkD0nc+wc41Kw8XtSBDTOstEjO9r6RU/RYCrxnnRLovFmU3E8qLWsFJyS3qBVQkHf5
         W0ZGWcTpfq9wWTBGA1HRxgSLvITs8LwhrP6PE7GY1dHl4R7xf/2KE/4ViEHKb5rCxcjv
         ocJVsrlUhPri/1Hgs4+7z1aswAR91Pc4WTXBmJpIFyczbtjbcmF2XXCjz0eYcCDZiEyI
         ve8e//LujQT8m0dBmD2K4HljjNpvgVKCnTiBuHCxgmC1KhRlLkw2ZFNP3mW9IX/WWdmD
         V+jDJl8jtrS2/hWo/Y5Ub5YxPUtJlPyffeWJaM03ZhYyW4xptYGwRZ/6YPftym+Zw+PG
         X0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5oabX9d0jpF1qIOlWbNO/kMyuSTCKbx/P4GY6FSPWA4=;
        b=DMKMalo36Gf8G66wf748IqlL7PCRF65B84OPtavhFwoWJCepkufQ1NA+1xAApwRgM4
         KNyTbcUFcLRlvJPsOCXQZJok+ZfF8ArznL0zhHFxNRm/27rfBWmcftbSTFXnjWIfr4zy
         wJOaB7CRisZoQ7xBqk1zY6IT+VlMcAqKci7jjpkBu++EXH5us1Jw2u5RKj4yxlH+5fF6
         LzrIk5EYZTduYRbBy2Q7BLRSGfFIZLRoqaHIu7bbGqJfbDCn97eq/hj8rSpSwowvlixq
         pY83nR/DL2GEUfa3pHs8G355XtawY2Xxc8YbJ1MCUNFzdkSSMnTTApxk6JlQv5yLDSUv
         wjUA==
X-Gm-Message-State: AOAM531s+O/4UGXjFClJmdAOBop9t5Qcq8dr0V43QMfUcxuTB0BxJNXG
        kPICrWC1GfV+JsJmLlEEBfG/NFz5zj5l+GDxY5U=
X-Google-Smtp-Source: ABdhPJz/Pq0amRGqUDQRuhNxiCQCjwzWoZgcYlPUq0/YBZ+bEEGKRzM38LK0BaZxqh8lik7Nc1Kc70ge9Yy6l6KSiaM=
X-Received: by 2002:a25:1287:: with SMTP id 129mr19516582ybs.27.1611797240604;
 Wed, 27 Jan 2021 17:27:20 -0800 (PST)
MIME-Version: 1.0
References: <20210122003235.77246-1-sedat.dilek@gmail.com>
In-Reply-To: <20210122003235.77246-1-sedat.dilek@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Jan 2021 17:27:09 -0800
Message-ID: <CAEf4Bzb+fXZy1+337zRFA9v8x+Mt7E3YOZRhG8xnXeRN4_oCRA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] tools: Factor Clang, LLC and LLVM utils definitions
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Andrey Ignatov <rdna@fb.com>,
        Stephane Eranian <eranian@google.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Briana Oursler <briana.oursler@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 4:32 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> When dealing with BPF/BTF/pahole and DWARF v5 I wanted to build bpftool.
>
> While looking into the source code I found duplicate assignments
> in misc tools for the LLVM eco system, e.g. clang and llvm-objcopy.
>
> Move the Clang, LLC and/or LLVM utils definitions to
> tools/scripts/Makefile.include file and add missing
> includes where needed.
> Honestly, I was inspired by commit c8a950d0d3b9
> ("tools: Factor HOSTCC, HOSTLD, HOSTAR definitions").
>
> I tested with bpftool and perf on Debian/testing AMD64 and
> LLVM/Clang v11.1.0-rc1.
>
> Build instructions:
>
> [ make and make-options ]
> MAKE="make V=1"
> MAKE_OPTS="HOSTCC=clang HOSTCXX=clang++ HOSTLD=ld.lld CC=clang LD=ld.lld LLVM=1 LLVM_IAS=1"
> MAKE_OPTS="$MAKE_OPTS PAHOLE=/opt/pahole/bin/pahole"
>
> [ clean-up ]
> $MAKE $MAKE_OPTS -C tools/ clean
>
> [ bpftool ]
> $MAKE $MAKE_OPTS -C tools/bpf/bpftool/
>
> [ perf ]
> PYTHON=python3 $MAKE $MAKE_OPTS -C tools/perf/
>
> I was careful with respecting the user's wish to override custom compiler,
> linker, GNU/binutils and/or LLVM utils settings.
>
> Some personal notes:
> 1. I have NOT tested with cross-toolchain for other archs (cross compiler/linker etc.).
> 2. This patch is on top of Linux v5.11-rc4.
>
> I hope to get some feedback from especially Linux-bpf folks.
>
> Acked-by: Jiri Olsa <jolsa@redhat.com> # tools/build and tools/perf
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---

Hi Sedat,

If no one objects, we'll take this through bpf-next tree. Can you
please re-send this as a non-RFC patch against the bpf-next tree? Feel
free to add my ack. Thanks.

> Changelog RFC v1->v2:
> - Add Jiri's ACK
> - Adapt to fit Linux v5.11-rc4
>

[...]
