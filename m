Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E722AE25F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732252AbgKJWAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732232AbgKJWAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:00:17 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABD3C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:00:17 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id h6so11457387pgk.4
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nU4xdx0PhV/+PUHMgjylz0is+Ov2vSZjSeguacOwknk=;
        b=oeJ7kH7OF0jjmTVKpjRBEAH5AVOrmtiz2xZOLgUwCYhw5j7Ba6O1L9IItIZa6fRHG6
         JonKpQOL7Ctn5Iggjtqg3LuQwPPi2wXNEa6zeJRtQCiKnmdoPtMu+PZ5YytitkwWoT+n
         Dew1CA4VFyk7xRiibxh3K4fYs/1C5JwqmJomaXnJFN9FJcz8LpVlNeRM+X1lkuZsBSUx
         V3U4Irj5I2vEfkAzMC5ibCf5+8QHF8A6GGBagdadgIEF1jQSP65jUirThJ9OhQ8G/uvo
         xuhknOh/qSku7JDp8/8AipVHV5wWuiceOvcQrYEZRDv7mGYTlkFExucbcwFFOXdTRG7v
         AKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nU4xdx0PhV/+PUHMgjylz0is+Ov2vSZjSeguacOwknk=;
        b=d1yyMiF9c1A/DWZmUrKxDh7mTee2rsIARh4staOABu3Wp/PrCuIF2eiupsfWq3SV4K
         HyxOZjCcqPX+A/AftnPqVXWjlDSVG4dpICJUixYE9zWqKd92NbT8j92vPG1lz7YHjyXS
         MOBkfjkuNFW7LhMN5U1HIHQJCF7ct7b3KYWhKTrC304l33vgud1giWmVYkrliGXNDpCb
         aPIr0HK/BYJARMZiyO6dU9yHtJXMwpn6RrVSjVuJRDA7WahB7ZJIQv+0wldyI1bHzW/x
         CQkldE42gs1BdgJW8AoadT0GjLQ8Hi1cRl81Qwvg+rEl0ULXxrGxetNLvzZXRmqgzvUE
         gdww==
X-Gm-Message-State: AOAM533MF/84w2m4HjnTGdD2Hd2viP+WTwlUBFZoWnllEhXO3XW0uyDa
        xF2aQFpWDIy+HYkLi2Gg9MXESs5u5uTu4IC16E3wgQ==
X-Google-Smtp-Source: ABdhPJxRbIXmjboGU6ktCqQNzoBKt+np2VFvQVLTANiLZV5o9uu7KBTidzS01s26V4sTl8fbu4m3S4mzAFhLxakwk48=
X-Received: by 2002:a62:5e06:0:b029:164:a9ca:b07e with SMTP id
 s6-20020a625e060000b0290164a9cab07emr14857161pfb.36.1605045616991; Tue, 10
 Nov 2020 14:00:16 -0800 (PST)
MIME-Version: 1.0
References: <20201107075550.2244055-1-ndesaulniers@google.com> <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
In-Reply-To: <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 10 Nov 2020 14:00:05 -0800
Message-ID: <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Joe Perches <joe@perches.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 7, 2020 at 2:33 AM Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2020-11-06 at 23:55 -0800, Nick Desaulniers wrote:
> > Clang is more aggressive about -Wformat warnings when the format flag
> > specifies a type smaller than the parameter. Fixes 8 instances of:
> >
> > warning: format specifies type 'unsigned short' but the argument has
> > type 'int' [-Wformat]
>
> Likely clang's -Wformat message is still bogus.
> Wasn't that going to be fixed?
>
> Integer promotions are already done on these types to int anyway.
> Didn't we have this discussion last year?
>
> https://lore.kernel.org/lkml/CAKwvOd=mqzj2pAZEUsW-M_62xn4pijpCJmP=B1h_-wEb0NeZsA@mail.gmail.com/
> https://lore.kernel.org/lkml/CAHk-=wgoxnmsj8GEVFJSvTwdnWm8wVJthefNk2n6+4TC=20e0Q@mail.gmail.com/
> https://lore.kernel.org/lkml/a68114afb134b8633905f5a25ae7c4e6799ce8f1.camel@perches.com/

Now I'll have to page in some old context...

The case we addressed last year was printing char with a wider format
string like %hd: https://reviews.llvm.org/rL369791,
https://bugs.llvm.org/show_bug.cgi?id=41467 and
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=95588 have a little more
info but not much.  Which is the case that Linus commented on.  Let's
say we're printing a "wider format than intended." Those have been
fixed in Clang.  These cases are printing a "narrower format than
intended."  Two distinct cases.

>
> Look at commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
> of unnecessary %h[xudi] and %hh[xudi]")
>
> The "h" and "hh" things should never be used. The only reason for them
> being used if if you have an "int", but you want to print it out as a
> "char" (and honestly, that is a really bad reason, you'd be better off
> just using a proper cast to make the code more obvious).
>
> So if what you have a "char" (or unsigned char) you should always just
> print it out as an "int", knowing that the compiler already did the
> proper type conversion.

Yeah, we could go through and remove %h and %hh to solve this, too, right?
-- 
Thanks,
~Nick Desaulniers
