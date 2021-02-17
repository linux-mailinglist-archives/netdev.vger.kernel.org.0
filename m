Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F35731DEC2
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhBQSDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhBQSDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:03:19 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836AAC061574;
        Wed, 17 Feb 2021 10:02:38 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id q5so12072540ilc.10;
        Wed, 17 Feb 2021 10:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=9phedVN9F6tsus8Z4OUiJzjoyd9QAwQ4EHDKpiG4l0s=;
        b=fnCxuZNZZIc6MC70hCzch7AYMD5h3GIFy0f1Gs9xp8P06zb3/8axvzz97Ws7pDrH32
         N71jDEdH0lz8uqNIWEQ9NnOoaCNeC4vcPop2FJwSSkAtYD/fwMJRdkhNVBuv6Hb9n5MI
         DVzUoS7yDybYsKCPEzBjQtEDqzxT+CjaNFXpWKWMABN4AerE05dTWspLJLW2+rkEoh8V
         /3n9uByJo5YZAKcEw9AAP9Zm7CD8o2zCez18CLNKyU3eaefi/DsxTBmUTo3m8mSu+iTI
         /afWQTHKzohD54Ev53cZgU04qB2pLPCoUrUPQltwTBT5EkmgOciGAraq51s7M5qufBi0
         vovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=9phedVN9F6tsus8Z4OUiJzjoyd9QAwQ4EHDKpiG4l0s=;
        b=UwcDK9vqOI9Vjz4Ny2NHeMc1qLwETvELA6fIcbyV3lwSG6tlSN6VA1el3GFVyIuBg2
         NMRPot2MLNgkuOGBb7HydIJMTDDsO59NigNc+mTWBO7nRkejSaTftZeEyqsFDHBtoBQh
         gzyxkoZZWHyLNN9cLO7wUaBRa2jj9GjSwxKVW9y+fDQT1mwYF1pGUC6y9MgPGM4k64G0
         uwQKHssHXFwMhCsfFpQT1tu7RKjKgon1e/GmX6hTPBQ9buScH1sSIZ70QaXNohMS2b5L
         FJZsQlDr+RbHAbjbDFC/36vFMSaxef6kaKH/aR13eVUerPjYSuSkp/WXLpc4a+QBPgnf
         NE2g==
X-Gm-Message-State: AOAM533eccWz63Suy7rSJLEry/b/7V85FrDcu+Mq5rTGmI2h1lIwMNy7
        cnl75wWU7y+8t7gJ64lcTDCxcyanOQB9x0r/W20=
X-Google-Smtp-Source: ABdhPJwQKEnLco30SxSgg73i0bPN5PocjhgmOHX6ErxX1rDT9y7StNtXtxFR7NIi4J4VsFr0wO7fq+ekk9ttWnlMwkw=
X-Received: by 2002:a92:d8c5:: with SMTP id l5mr210279ilo.209.1613584957842;
 Wed, 17 Feb 2021 10:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20210213164648.1322182-1-jolsa@kernel.org> <YC0Pmn0uwhHROsQd@kernel.org>
 <CA+icZUWBfwJ0WKQi7AO_dhcMpFWmo6riwszpmsZLfn1BwH_kyw@mail.gmail.com> <AA8690FE-7C57-4791-881A-DE06B337DF45@gmail.com>
In-Reply-To: <AA8690FE-7C57-4791-881A-DE06B337DF45@gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 17 Feb 2021 19:02:26 +0100
Message-ID: <CA+icZUWC-OuV1dJv6PsmbjU7fMSY02RFa8X1LLmJB3xh=W0O_A@mail.gmail.com>
Subject: Re: [PATCHv2] btf_encoder: Match ftrace addresses within elf functions
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 2:56 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
>
>
> On February 17, 2021 10:40:43 AM GMT-03:00, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >On Wed, Feb 17, 2021 at 1:44 PM Arnaldo Carvalho de Melo
> ><arnaldo.melo@gmail.com> wrote:
> >>
> >> Em Sat, Feb 13, 2021 at 05:46:48PM +0100, Jiri Olsa escreveu:
> >> > Currently when processing DWARF function, we check its entrypoint
> >> > against ftrace addresses, assuming that the ftrace address matches
> >> > with function's entrypoint.
> >> >
> >> > This is not the case on some architectures as reported by Nathan
> >> > when building kernel on arm [1].
> >> >
> >> > Fixing the check to take into account the whole function not
> >> > just the entrypoint.
> >> >
> >> > Most of the is_ftrace_func code was contributed by Andrii.
> >>
> >> Applied locally, will go out after tests,
> >>
> >
> >Hi Arnaldo,
> >
> >Is it possible to have a pahole version 1.21 with this patch and the
> >one from Yonghong Son?
> >
> >From my local pahole Git:
> >
> >$ git log --oneline --no-merges v1.20..
> >2f83aefdbddf (for-1.20/btf_encoder-ftrace_elf-clang-jolsa-v2)
> >btf_encoder: Match ftrace addresses within elf functions
> >f21eafdfc877 (for-1.20/btf_encoder-sanitized_int-clang-yhs-v2)
> >btf_encoder: sanitize non-regular int base type
> >
> >Both patches fixes all issues seen so far with LLVM/Clang >=
> >12.0.0-rc1 and DWARF-v5 and BTF (debug-info) and pahole on
> >Linux/x86_64 and according to Nathan on Linux/arm64.
> >Yesterday, I tried with LLVM/Clang 13-git from <apt.llvm.org>.
> >
> >BTW, Nick's DWARF-v5 patches are pending in <kbuild.git#kbuild> (see
> >[1]).
> >
> >Personally, I can wait until [1] is in Linus Git.
> >
> >Please, let me/us know what you are planning.
> >( I know it is Linux v5.12 merge-window. )
>
> Sure, next week.
>

That's OK with me.

- Sedat -

> - Arnaldo
>
> >
> >Regards,
> >- Sedat -
> >
> >[1]
> >https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git/log/?h=kbuild
>
> --
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
