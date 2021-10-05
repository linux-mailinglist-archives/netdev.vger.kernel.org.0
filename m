Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888C642324B
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhJEUsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhJEUsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 16:48:04 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2802AC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 13:46:13 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id m3so1264577lfu.2
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 13:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WSPoOTkRr5tV7uZ2oQ4/a2w9VK4Qjz1YAPZdC+7bcrw=;
        b=atKPmliQ9LuYJrilGpsViHfk6LQV6BmknanYEfaKC5+DRlC/Sf/bbZjgm5eOG2gsrs
         fmv7trPUK3bUcYnjK+F3dvGkJznH7EtdSCCwNZlfE6Q1ZLEG8bowAjHuLUwTsaJgDL3U
         E3zlV7ocEBIN+OWdpawxUEevr7fS0Jaaj9cW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WSPoOTkRr5tV7uZ2oQ4/a2w9VK4Qjz1YAPZdC+7bcrw=;
        b=gjFqVh6Z5Zmm3lWYwuuE6GRavu9KrPxA7YiGQw28+Om9fwe++Z5zPzCa7oGxiLXk9j
         Dfn5LjTdCRgNCsY2TerDHHbkrLnvahI4ubabK/5H2+uLyaS2TMcIdt52Y21RzavAkp9k
         yZjW0AKSrG7rF2Yy3mRLKazvGQ2bJrixYjEEk+WELMUlT75qk6+X0wnPEauaV3nY8XEJ
         kIZCJP4r3Vd8qw7WsGbePCTE1y21xaAwADwAFqX3b51y1uc/cqLPsj7kLlgSkk8ZKre7
         79Tt8zxrr0PNw5knoE6Iy0I9s8tDVvr2K40q6lagx+hyZafaN05u6maU8J+vpLTw9Itv
         xARA==
X-Gm-Message-State: AOAM531Q5plkWz79biaHZlkr6QkG6Ad+JnT0DSJ4mYViHP8i+BeFueoU
        vtmR09A9mZE+nJxG75cowOCWcQtcdvnzZxwe9Ik=
X-Google-Smtp-Source: ABdhPJz7Wb1g0X4FLdYah8jQ7O6TGu4oOOlR9tNl1p5COhM81Ylply31UDXmcY3ej/byWKz9jmdzcg==
X-Received: by 2002:a2e:9a09:: with SMTP id o9mr25104602lji.218.1633466770582;
        Tue, 05 Oct 2021 13:46:10 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id i10sm2068228ljn.36.2021.10.05.13.46.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 13:46:09 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id x27so1123485lfa.9
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 13:46:09 -0700 (PDT)
X-Received: by 2002:a05:651c:a09:: with SMTP id k9mr25182695ljq.191.1633466769318;
 Tue, 05 Oct 2021 13:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211005094728.203ecef2@gandalf.local.home> <ef5b1654-1f75-da82-cab8-248319efbe3f@rasmusvillemoes.dk>
 <639278914.2878.1633457192964.JavaMail.zimbra@efficios.com>
 <826o327o-3r46-3oop-r430-8qr0ssp537o3@vanv.qr> <20211005144002.34008ea0@gandalf.local.home>
 <srqsppq-p657-43qq-np31-pq5pp03271r6@vanv.qr> <20211005154029.46f9c596@gandalf.local.home>
 <20211005163754.66552fb3@gandalf.local.home>
In-Reply-To: <20211005163754.66552fb3@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 5 Oct 2021 13:45:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj+P=YeuY=tpY72nDMQgxGTzEMqjfq5P536G=qYEkQr1w@mail.gmail.com>
Message-ID: <CAHk-=wj+P=YeuY=tpY72nDMQgxGTzEMqjfq5P536G=qYEkQr1w@mail.gmail.com>
Subject: Re: [RFC][PATCH] rcu: Use typeof(p) instead of typeof(*p) *
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, rcu <rcu@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam <coreteam@netfilter.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 5, 2021 at 1:38 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Really, thinking about abstraction, I don't believe there's anything wrong
> with returning a pointer of one type, and then typecasting it to a pointer
> of another type. Is there? As long as whoever uses the returned type does
> nothing with it.

Just stop doing this.,

Dammit, just include the header file that defines the type in the
places that you use the thing.

Because, yes, there is a LOT wrong with just randomly casting pointers
that you think have the "wrong type". You're basically taking it on
yourself to lie to the compiler, and intentionally breaking the type
system, because you have some completely bogus reason to hide a type.

We don't hide types in the kernel for no good reason.

You are literally talking about making things worse, for a reason that
hasn't even been explained, and isn't valid in the first place.
Nothing else in the kernel has had a problem just declaring the damn
type,.

If there was some clean and simple solution to the compiler warning
problem, that would be one thing. But when you think you need to
change core RCU macros, or lie to the compiler about the type system,
at that point it's not some clean and simple fix any more. At that
point you're literally making things worse than just exposing the
type.

           Linus
