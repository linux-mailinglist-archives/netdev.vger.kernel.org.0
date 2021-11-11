Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E4144DBEA
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 20:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhKKTFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 14:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhKKTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 14:05:52 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812FFC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 11:03:02 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id s13so11474622wrb.3
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 11:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/A1ttcle2orZSkbe2/qDQphOhnF3u+g6v2xRcshKQUM=;
        b=OsuRwQ3XDCH0jVIcVGLbJ40UVtYUehcfr76e0ikkYHls3g2WpVaMrspL/wa9XfeMUj
         yAqJLK6qs46PbHqMRriI45F55Bc7MpXFO/dJQ5Lcq6AzgPBMF8PK3pZlk2SyIZpxzAYT
         rNdZlXKulE0/XQfZbV8lsHae24SPJO08xGpNffdp5NzXzDdoBIGSYatXR5L8a8r0Hl5w
         S1syxPP1zsYaPggnhelc0MnVE5XUTkgthC0WBUhxnHz29ROEIvFXWYfbT4i99l0Nt3LM
         3gOKZmRoPHDZcTo6//bNvUxkZhC1cGB0YOirR2d2gAFx3sdRysRODYbi/bNqLBVS+bx2
         TJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/A1ttcle2orZSkbe2/qDQphOhnF3u+g6v2xRcshKQUM=;
        b=Hom2dap16X3EmyqGaiUvvIcwrOl4s6yUKHkwYLpP8/vW85IQah9lOI6neJ60FPpKo6
         xPpgjp1gsISAL2EmZHtwpkyKXOO9z459rQbWryRKHnuUWAs45+g4VmF7L2yy6DrkG4yp
         CFJDm0Ngu3z9nrp0NMuKNq/r2UNzYyg1wHEaHEjaSEurGavEw4ZbYyiCERZBAiLdjeO1
         FckvAytHVMWMHukXI27B++528A6pgVJ0FXayLJMM4ipYdDLkbvg5cuRp/YOHF12R3cMM
         GYIOuY2JcOVDgqb5kDP0rbSTYQEQbL5Rq+E32h36fvV/PDOGUXSHTngsv0FcU2W7hqxN
         Mu5Q==
X-Gm-Message-State: AOAM532ZZELAoa0pnRMoUIXTNb8p29FEK14rHP9JB7+xx/YnlqL3kXhl
        wyltUVQtCl7vDcSUBubaXrYsMy80+GzccXNxbxUufA==
X-Google-Smtp-Source: ABdhPJwVyRT2A+cvE5/PQ6nPbH0rVqqZAM4jrIPQBOBMF8gbOALCJcUZ6j9/03nkaGFED8F1RVRwg9ZUDJhvXIl+A6c=
X-Received: by 2002:adf:e387:: with SMTP id e7mr11505573wrm.412.1636657380507;
 Thu, 11 Nov 2021 11:03:00 -0800 (PST)
MIME-Version: 1.0
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net> <YYzl8/7N+Tv/j0RV@hirez.programming.kicks-ass.net>
 <CANn89i+qjOpL9eYj=F2Mg-rLduQob4tOZcEUZeB5v0Zz3p6Qqw@mail.gmail.com>
 <CANn89i+Y6OXdKccgM6+gC-2giJFcOrMfraG7ofCfKXmjsfMPJQ@mail.gmail.com> <2b36e547-f080-a1ee-f0f0-a9e5fe1e4693@citrix.com>
In-Reply-To: <2b36e547-f080-a1ee-f0f0-a9e5fe1e4693@citrix.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 11 Nov 2021 11:02:48 -0800
Message-ID: <CANn89iL9k8spkSGzty0g7C4FA1=pgtd-4zYranqvFywBFG6cZw@mail.gmail.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>, amc96@srcf.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 10:18 AM Andrew Cooper
<andrew.cooper3@citrix.com> wrote:
>
> On 11/11/2021 16:52, Eric Dumazet wrote:
> > On Thu, Nov 11, 2021 at 8:02 AM Eric Dumazet <edumazet@google.com> wrote:
> >> Thanks Peter !
> >>
> >> This is more or less the first version I wrote. (I was doing tests for
> >> (len & 32), (len & 16) .. to not have to update len in these blocks.
> >>
> >> Then, I tried to add an inline version, a la ip_fast_csum() but for IPv6.
> >>
> >> Then I came up with the version I sent, for some reason my .config had
> >> temporarily disabled CONFIG_RETPOLINE,
> >> thanks for reminding me this !
> >>
> >> I also missed this warning anyway :
> >> arch/x86/lib/csum-partial_64.o: warning: objtool: csum_partial()+0x2f:
> >> unannotated intra-function call
> >>
> >> I will spend a bit more time on this before sending a V2, thanks again !
> > BTW, I could not understand why :
> >
> >                result = add32_with_carry(result, *(u32 *)buff);
> >
> > generates this code :
> >
> >  123: 41 8b 09              mov    (%r9),%ecx
> >  126: 89 4d f8              mov    %ecx,-0x8(%rbp)
> >  129: 03 45 f8              add    -0x8(%rbp),%eax
> >  12c: 83 d0 00              adc    $0x0,%eax
>
> Are you using Clang?  There is a long outstanding code generation bug
> where an "rm" constraint is converted to "m" internally.
>

Yes, this is what I realized later. This is a clang bug.

> https://bugs.llvm.org/show_bug.cgi?id=47530
>
> Even a stopgap of pretending "rm" means "r" would result in far better
> code, 99% of the time.

Agreed

>
> > Apparently add32_with_carry() forces the use of use of a temporary in memory
> >
> > While
> >                asm("   addl 0*4(%[src]),%[res]\n"
> >                    "   adcl $0,%[res]\n"
> >                        : [res] "=r" (result)
> >                        : [src] "r" (buff), "[res]" (result)
> >                         : "memory");
>
> Just as a minor note about the asm constraints here and elsewhere
>
>     : [res] "=r" (result)
>     : "res" (result)
>
> ought to be just [res] "+r" (result).  The result variable really is
> read and written by the asm fragments.

Thanks for the tip !
