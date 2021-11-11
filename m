Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86DF44DACD
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhKKQzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKKQzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:55:54 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4BDC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:53:04 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 133so5655622wme.0
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GF+I7k9REg4J5pp7bpz4i4qyzuEm21Cj7urzwGnbJEg=;
        b=OShEFn6GEVMIrsEcvpqtNv6qzAUXcQtG7jnm3B4hMA44oQwKiu1+9Oug+A/TZbjWYn
         dSpAwm47rbHKsgieq/aUKpZUsnwXvcKW/TEHSEpGTDf9SkYFtsY7WP56f+NvEUKiTa3m
         D3lbrJfAq0cUMgt8mrcL2a7d3/MRvSS4DK/PCWZulUvrdKm6ui+yaAKjcvsxWrgbTyfQ
         eQUxZJDWXQ7jl7949eBmW4YciGFgW79C7j6O1QmQpxKVtM1KjVVVs+Qp3qizFMsdnPdF
         H8gIfRVD1N93YW0nXRM41d51VQg3ErdG76uVQJVascmio7Tj1SHMG96Jh1hVxQCBLm1g
         MEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GF+I7k9REg4J5pp7bpz4i4qyzuEm21Cj7urzwGnbJEg=;
        b=PXVG9JsPa5Q+//xTaYG7oy0JAbpBD7NN3tau6FMRngkFwWhJylNHUUjcCW7HLBA3oz
         gEyl8VoxkIQyhzXhxjZY4ULK7GwryJgpZjy4dvwkX394aOU+xJbcQ17MWDJfr+6WAihu
         /c/DWdTHvY8ZImTDfxBt2y50ZeoOdem+mRBgpbakGnyxi5dIKiRBxqjKp9SZZIyA2AKZ
         c99r/i3p1642PPmupo6dq13zOz8fGmGD8yecUXD1I3ojxvSitmYqoOewhgW+njsUM0IU
         xxArC+oq3AhJznQ0s5WZqxRxFyig3FKoIdbAf28MAVxI0E1Euyt6BkyLBA0hLm9kgxEk
         nIlQ==
X-Gm-Message-State: AOAM533bnHXIY0xXbOx6SfVzk+lICxRwsReLlqzSUSe+EEPG+0LeSNjG
        dYiS0mXv5QexwhU/+LWQfdSvJS0ZrOBJHgI3jTB2Yw==
X-Google-Smtp-Source: ABdhPJz/oogn1hAsMLtKpi1RptvsFD1ssLVa7+Zew5YEdjSG4/1US9Z3N20259F4w1VsmKvt3X+4Ql/Om12wmO694vc=
X-Received: by 2002:a05:600c:2297:: with SMTP id 23mr26264276wmf.73.1636649582756;
 Thu, 11 Nov 2021 08:53:02 -0800 (PST)
MIME-Version: 1.0
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net> <YYzl8/7N+Tv/j0RV@hirez.programming.kicks-ass.net>
 <CANn89i+qjOpL9eYj=F2Mg-rLduQob4tOZcEUZeB5v0Zz3p6Qqw@mail.gmail.com>
In-Reply-To: <CANn89i+qjOpL9eYj=F2Mg-rLduQob4tOZcEUZeB5v0Zz3p6Qqw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 11 Nov 2021 08:52:51 -0800
Message-ID: <CANn89i+Y6OXdKccgM6+gC-2giJFcOrMfraG7ofCfKXmjsfMPJQ@mail.gmail.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 8:02 AM Eric Dumazet <edumazet@google.com> wrote:
>

> Thanks Peter !
>
> This is more or less the first version I wrote. (I was doing tests for
> (len & 32), (len & 16) .. to not have to update len in these blocks.
>
> Then, I tried to add an inline version, a la ip_fast_csum() but for IPv6.
>
> Then I came up with the version I sent, for some reason my .config had
> temporarily disabled CONFIG_RETPOLINE,
> thanks for reminding me this !
>
> I also missed this warning anyway :
> arch/x86/lib/csum-partial_64.o: warning: objtool: csum_partial()+0x2f:
> unannotated intra-function call
>
> I will spend a bit more time on this before sending a V2, thanks again !

BTW, I could not understand why :

               result = add32_with_carry(result, *(u32 *)buff);

generates this code :

 123: 41 8b 09              mov    (%r9),%ecx
 126: 89 4d f8              mov    %ecx,-0x8(%rbp)
 129: 03 45 f8              add    -0x8(%rbp),%eax
 12c: 83 d0 00              adc    $0x0,%eax

Apparently add32_with_carry() forces the use of use of a temporary in memory

While
               asm("   addl 0*4(%[src]),%[res]\n"
                   "   adcl $0,%[res]\n"
                       : [res] "=r" (result)
                       : [src] "r" (buff), "[res]" (result)
                        : "memory");

gives

 120: 41 03 01              add    (%r9),%eax
 123: 83 d0 00              adc    $0x0,%eax
