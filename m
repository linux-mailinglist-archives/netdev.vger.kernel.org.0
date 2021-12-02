Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C7466610
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357701AbhLBPEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351374AbhLBPEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:04:48 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE02C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 07:01:25 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id y68so423482ybe.1
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 07:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VTobswxlLE4YejykxhV8zQJTLNxk0g77t+kXOsxPmSs=;
        b=dhagCgKIjVqCtJ/HmkKDllriSJHfF9F/NZDjIOCTilwFjJ1zD8mgWDnyjoVYTCzxRh
         Fp/Wng8+N8qqaoR7W/YCoWmf3kmcv4ds76TGrz9Zd8xzJRo2vBQroztKCz1pWjdNOqcg
         n/Vc+aiT1CTO/ZXZM6cA65h+OEB061lekMyX177rM+BJ92aGFjJWivUvwuDne8PNeNaT
         OZ6m1oxNJ3KlBSrB7tCHBMCQmCGZEE5GKf0g/+F4tyN9wAnfjoabKVoD0v8JcPyJT1dS
         sCfYfAV8iEuxR1Dx6ynPLPqaFgDnKU1l77hhOVXs3Qr8BDXayT56k6bdTY11estUNQuk
         XB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VTobswxlLE4YejykxhV8zQJTLNxk0g77t+kXOsxPmSs=;
        b=PQ8R635WtDYF6jHj9AGIN2JX8+gKwk1t3Zd4yDY9kGr/aB679LxbTqzzSmB80dmiHj
         3vEZLHloACM4jlP9mtT3I0IAbVUcwKSSLe5BGjCGGE3SJKqvjKlnarOxrh3CLRsaBL4C
         dgvnhgC61QI/ubcPabmXkuwTd2aNt5xk2Y0EpFzWkSS3rU6WXyEXorXqGnDW3mr7yNcv
         PtQ2cnTMepMzH9ZXMgzX3dhn8TbSVYkWJZE+iT8vJpP0JtYqoWHDt+Jv/fVdCFIZRKgD
         UZc5HehBY8gcHhm3lfHvPH2VWMtJt5NUmiacjLzGjLaKc12YyRpgWacllxCJCP33N2NB
         1M4g==
X-Gm-Message-State: AOAM533WqGm2Twj7/fvWtziwqPlEi7/JaJ1PArT50iGiZA5LYxaqvfHM
        mXp3l7jlDpMFHIgfgwGXpvUWjz/VlHf/KfoA4esNbA==
X-Google-Smtp-Source: ABdhPJy0EPYw/QrnIPBWnWcPSjiwL6Gw0AaYK3evS7TveIVfxAUCNgXk+f7PZhTcCBqiCnn2wSKsd4F90v3JD7HYKCU=
X-Received: by 2002:a25:760d:: with SMTP id r13mr17012907ybc.296.1638457284795;
 Thu, 02 Dec 2021 07:01:24 -0800 (PST)
MIME-Version: 1.0
References: <20211125193852.3617-1-goldstein.w.n@gmail.com>
 <CANn89iLnH5B11CtzZ14nMFP7b--7aOfnQqgmsER+NYNzvnVurQ@mail.gmail.com>
 <CAFUsyfK-znRWJN7FTMdJaDTd45DgtBQ9ckKGyh8qYqn0eFMMFA@mail.gmail.com>
 <CAFUsyfLKqonuKAh4k2qdBa24H1wQtR5FkAmmtXQGBpyizi6xvQ@mail.gmail.com>
 <CAFUsyfJ619Jx_BS515Se0V_zRdypOg3_2YzbKUk5zDBNaixhaQ@mail.gmail.com>
 <8e4961ae0cf04a5ca4dffdec7da2e57b@AcuMS.aculab.com> <CAFUsyfLoEckBrnYKUgqWC7AJPTBDfarjBOgBvtK7eGVZj9muYQ@mail.gmail.com>
 <29cf408370b749069f3b395781fe434c@AcuMS.aculab.com>
In-Reply-To: <29cf408370b749069f3b395781fe434c@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 07:01:13 -0800
Message-ID: <CANn89iJgNie40sGqAyJ8CM3yKNqRXGGPkMtTPwXQ4S_9jVspgw@mail.gmail.com>
Subject: Re: [PATCH v1] x86/lib: Optimize 8x loop and memory clobbers in csum_partial.c
To:     David Laight <David.Laight@aculab.com>
Cc:     Noah Goldstein <goldstein.w.n@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 6:24 AM David Laight <David.Laight@aculab.com> wrote:
>
> I've dug out my test program and measured the performance of
> various copied of the inner loop - usually 64 bytes/iteration.
> Code is below.
>
> It uses the hardware performance counter to get the number of
> clocks the inner loop takes.
> This is reasonable stable once the branch predictor has settled down.
> So the different in clocks between a 64 byte buffer and a 128 byte
> buffer is the number of clocks for 64 bytes.
> (Unlike the TSC the pmc count doesn't depend on the cpu frequency.)
>
> What is interesting is that even some of the trivial loops appear
> to be doing 16 bytes per clock for short buffers - which is impossible.
> Checksum 1k bytes and you get an entirely different answer.
> The only loop that really exceeds 8 bytes/clock for long buffers
> is the adxc/adoc one.
>
> What is almost certainly happening is that all the memory reads and
> the dependant add/adc instructions are all queued up in the 'out of
> order' execution unit.
> Since 'rdpmc' isn't a serialising instruction they can still be
> outstanding when the function returns.
> Uncomment the 'rdtsc' and you get much slower values for short buffers.
>
> When testing the full checksum function the queued up memory
> reads and adc are probably running in parallel with the logic
> that is handling lengths that aren't multiples of 64.
>
> I also found nothing consistently different for misaligned reads.
>
> These were all tested on my i7-7700 cpu.
>

I usually do not bother timing each call.
I instead time a loop of 1,000,000,000 calls.
Yes, this includes loop cost, but this is the same cost for all variants.
   for (i = 0; i < 100*1000*1000; i++) {
        res += csum_partial((void *)frame + 14 + 64*0, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*1, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*2, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*3, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*4, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*5, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*6, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*7, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*8, 40, 0);
        res += csum_partial((void *)frame + 14 + 64*9, 40, 0);
    }

Then use " perf stat ./bench"   or similar.
