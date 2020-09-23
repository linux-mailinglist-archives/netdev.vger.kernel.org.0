Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA62276024
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIWSlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgIWSlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:41:53 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9E3C0613CE;
        Wed, 23 Sep 2020 11:41:52 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a22so466675ljp.13;
        Wed, 23 Sep 2020 11:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2k9CV25RrDU0wvIk6G57sGfuXbwloarmNuW7bg4GqKQ=;
        b=AEj3XFTGvz6XnHZKhyYx0BadXLJ4vh0EvmJJE06/Ecd66MYkHugjIcFdgG1LBy/bDV
         Q7eMYtmXq6Ile48fVyvoFwitMiOTT0W2tZU0Wxnq+IrSP/LZjUjDClLafXDRJZ1jNaQ+
         01RnPUUUBw0ravqb19jjk9cbFDWvoQ3BdYRswL4sRnRe1HBgKVqFFx3COIKJTcmnJga8
         TiukHJPgjEmQXzueDiLmRmCyxkiPou5YyFhYuwZ1PJ6x+nHxjCQ38WKMzXv+BwO1H6P2
         S0Tm/4R4oRP4HM/GpAvqU5P5WcZmBgKEaeSGjwpX/yX9f0AUL7W8lZ7YEeGMPvJGueEl
         0zqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2k9CV25RrDU0wvIk6G57sGfuXbwloarmNuW7bg4GqKQ=;
        b=CrHNco7guSTgEXcRKWA1mSePgQeVmdHSp5iifheZ7o6tft2pnXYyZbiWU60HpohdIa
         qh7Ojyx4e8rncAqtammXBCdOnfV9dQiqlgElyWI0yfQiL1ze4WS96tRfUFigZFS04Gf0
         ssFy9aol0TK6PrV/hegnOBwJ2pzWwoUo6F0mf5V09ebChpkxhrGi/SDUAjQhEda7iHjY
         DNk4b0Oo9MMhqbmllStqCBEMnZGREDoqxm+FVQ3IpvREqtI/OJH5Sv/mKzW/WRdxz4Xs
         +MGwLf88G/3LXVDgWFOsyAyNqArjpKfLjnh7btxc0sfmxcr0Xa8NEozXL7khZ+UKKFPT
         ADJg==
X-Gm-Message-State: AOAM532Pnrj2CgNt1TvXdwLGwlgai3SBGaTzyhrAcy3Khdiceop2oSD+
        5T+j2K7FRKxMleudBNPsUkLAfVzFPUdUQZD9v9g=
X-Google-Smtp-Source: ABdhPJwDjxajelXuIroV0hGU/94fezNzAj9XrOoWiRhdrGKWN0zrJrx9q9zd8qWFtuAZCK3hduW7WLe4xOTHNDUZLxE=
X-Received: by 2002:a2e:9dcb:: with SMTP id x11mr401460ljj.450.1600886511328;
 Wed, 23 Sep 2020 11:41:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com> <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com>
In-Reply-To: <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 23 Sep 2020 11:41:40 -0700
Message-ID: <CAADnVQKXvx7QQXdGHVHtB8HgjR1GLwS0q_5_F7fe+y8brtPVZQ@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 18 Sep 2020 at 04:26, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> [...]
> >
> > Lorenz,
> > if you can test it on cloudflare progs would be awesome.
>
> Our programs all bpf_tail_call from the topmost function, so no calls
> from subprogs. I stripped out our FORCE_INLINE flag, recompiled and
> ran our testsuite. cls_redirect.c (also in the kernel selftests) has a
> test failure that I currently can't explain, but I don't have the time
> to look at it in detail right now.

selftests's test_cls_redirect.c does not have any tail calls,
so it's not an interesting target.
But your internal code relying on tail_call and until today
you could not use subprograms at all.
It doesn't matter that you do tail_call out of topmost function.
The verifier would disallow subprogs, so you were missing
on lots of new functionality.
What I'm suggesting to try is to keep your code as-is
(with tail_call in topmost) and simply remove always_inline.
Let the compiler decide on better code layout.
That will improve performance and most likely improve verification time too.
If you convert some of the subprograms into global functions then
you will be able to use function-by-function verification which will
drastically improve verification time.

Same thing for cilium. Their progs use tail_calls and because of that
couldn't use subprogs at all.
I think John was saying that prog load time is important for cilium.
The answer is to use global functions.
Now with tail_calls being compatible with subprogs all that is available.
