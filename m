Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DF244EA8B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhKLPli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbhKLPlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:41:11 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD76DC06120E
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:38:02 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id n29so16171198wra.11
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 07:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=//YwoVAROfjntC6JS/S9hKFALgk6bmNJUeXxMi/dxhQ=;
        b=h54NMrKY1L38HO4f3jzmaHZp0QAgVS2zJTaY5okHafq3CCSQLcJoIONkaPTyzc+oAh
         e4pY9ZT0BRTzfN3NinUR2c9E5b9AbtDg9l9ZHCsAA6zzRc6jAF94MzKYx5bT2BFtnhr0
         QhiJO1bSbVc1pmEz1uAvUV5/SWj3xcF6TJe5oGjS+Y2FWjvk8ncYaxKwzlneGq9zt8RT
         tkgXlWPWV2zI3IAFKB/jDJQPoIJGNoh93dKqk8lp1ozB0WuPyiMz8voAB9kM8epPJCRD
         P0C6NM0j2k7mpiFUJ0y0FN+RdTNG/JW2lM5EcirULT2nDWOkCSIbrdi2TUjXLww1KB5I
         PCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=//YwoVAROfjntC6JS/S9hKFALgk6bmNJUeXxMi/dxhQ=;
        b=6rdAyvomPg4RfsUT/6/9Qu2VLFBSWT8UXjcpJlS3uHEm+rvhecc5zOtRWVEWnmkUUo
         KjuOKkGCRY08fT05lxOtzWlUQaO0YCEvqHBg1zr4q/GAp/ehdLZR1hwqvErYMpdq5gVg
         3R5UBVorGEjk0EvZq7Jl8BMkrrYHQzOb9XJFlNnrFBjlxYYgzpOyZsbKoYN/se+mfzsx
         6dudwaHs7qYJmhGwy0kkXYO8NJzlHDzpGbOzKuQ9gz19IcrlxcMuNqDMvGPEzFMPPoVc
         JM2++1ct0Nydy1Hf3gsFEElizAabnSE0so1WAlxipOrx+13ZDJa1S10G5OUqgtIOPv3r
         eG8w==
X-Gm-Message-State: AOAM531mLpcImiqbx0frCFU46N4NaPjXMxzwpCoP8x45BNEktqouQ7F3
        wPUxlVsw7PCO15/p1fkzXnloWUOIKXJo9iD0+IqB2A==
X-Google-Smtp-Source: ABdhPJzrW0f0xpOFTUq5QatLqh45ydCIRfC/LQRhVZfVHIZQSy/yzkVCur84KLPokqZKICh6sIKeNfmVuaB8CzDNFC8=
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr20770196wrq.221.1636731480922;
 Fri, 12 Nov 2021 07:38:00 -0800 (PST)
MIME-Version: 1.0
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com>
 <YY4wPgyt65Q6WOdK@hirez.programming.kicks-ass.net> <CANn89iJNvxatTTcHvzNKuUu2HyNfH=O7XesA3pHUwfn4Qy=pJQ@mail.gmail.com>
 <YY6HXBK7UN4YqBJm@hirez.programming.kicks-ass.net>
In-Reply-To: <YY6HXBK7UN4YqBJm@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Nov 2021 07:37:48 -0800
Message-ID: <CANn89iLpjDsSzLCMz6w8TO5zu1N6HoWM3sgzQevv=zpMYaOt8g@mail.gmail.com>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 7:25 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Nov 12, 2021 at 06:21:38AM -0800, Eric Dumazet wrote:
> > On Fri, Nov 12, 2021 at 1:13 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Thu, Nov 11, 2021 at 02:30:50PM -0800, Eric Dumazet wrote:
> > > > > For values 7 through 1 I wonder if you wouldn't be better served by
> > > > > just doing a single QWORD read and a pair of shifts. Something along
> > > > > the lines of:
> > > > >     if (len) {
> > > > >         shift = (8 - len) * 8;
> > > > >         temp64 = (*(unsigned long)buff << shift) >> shift;
> > > > >         result += temp64;
> > > > >         result += result < temp64;
> > > > >     }
> > > >
> > > > Again, KASAN will not be happy.
> > >
> > > If you do it in asm, kasan will not know, so who cares :-) as long as
> > > the load is aligned, loading beyond @len shouldn't be a problem,
> > > otherwise there's load_unaligned_zeropad().
> >
> > OK, but then in this case we have to align buff on qword boundary,
> > or risk crossing page boundary.
>
> Read the above, use load_unaligned_zeropad(), it's made for exactly that
> case.
>
> Slightly related, see:
>
>   https://lkml.kernel.org/r/20211110101326.141775772@infradead.org

Ah right you are, thanks a lot !
