Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A3F1FFBE9
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgFRTlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgFRTlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:41:11 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E779BC06174E;
        Thu, 18 Jun 2020 12:41:10 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id l6so7084065ilo.2;
        Thu, 18 Jun 2020 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wZg6yRbftXiW6TCni10DoNGM70aOuUyAxCGfvTDR9XU=;
        b=jjVpbJV1ixssIdVOYNxSsU8+EfmTLuFYsg3C1ud0mv2xDTmc9ddZCS0gJMFQYgE+5u
         Gv1oOxg3fM+2wUPW/j8PTyaEwY6DRtqXMN25FtLavH0DzButhP6O1K8rJ6XrqvHm6MGb
         w2xknfQGyBdA1Dt0SruZxJD+bMDkg6RP+DM+2qYKnUbcP51gyRyRtK14g5hg0xj5nmNV
         hMgicqY4Wn8Z81f8PGUsMqNgOFXPXAE1r5rh8S21EdY94jTHm70562zS/fhpb84I9gQn
         FxiI+kSx0Q9GUDzbqFFaFODcu3aBvPN/R+Wo++oDfJjLZ3Ue30bnDl93RSKpG0cZYsnK
         J/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wZg6yRbftXiW6TCni10DoNGM70aOuUyAxCGfvTDR9XU=;
        b=h7CqWjHG3k4JOGFXx/CKbco3oL6ldBV4QZJevKcrRBsX1+c/JZRkkppRQNJ4gse9NM
         z1m+4BgH9aNI2hg7G96kcDEf3goBwCq6DH587zwCu3sSD8RgwCwtjDF80yChvI4QNj5J
         DovDfbqwsm/QhGBfMCNrin93nD2E6tpHNx2Ygqup2KIPEHuuHxes3vRLAKyP0UoneCfI
         hW6rWCJPRfB6UbYIl2Y506uEWVYKYSXEdaagamQwSb953YVaHoF8EfrIbnoLupQXQDfe
         bYMyNcglwia0KA+vg1993rb0uzb0Kj5jSKFiC9RNBg9AkM9BaOjg4WQdDthZ4Khslyt9
         /ehQ==
X-Gm-Message-State: AOAM531s1EPWrEZFPKtSeBGsiUcvJkCgU7IQNiWE8p/PY5p5M6RNsFFY
        jPJhDVJC6brJ2Czhm6E9Jrair5lo1OiL9US1Tw8yJBNmgrhYzQ==
X-Google-Smtp-Source: ABdhPJycBUSitplzrcQ5ab7GadNEq5wup1y9ndBKlbjuu5aP4JH5PshANb+lUZSaK4NWS1wdi+Xvozb0jGgJEcC28gE=
X-Received: by 2002:a05:6e02:13c7:: with SMTP id v7mr99568ilj.230.1592509270309;
 Thu, 18 Jun 2020 12:41:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200618183310.5352-1-alexander.kapshuk@gmail.com> <20200618190807.GA20699@nautica>
In-Reply-To: <20200618190807.GA20699@nautica>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Thu, 18 Jun 2020 22:40:34 +0300
Message-ID: <CAJ1xhMX97LwVbTyGcV=bT2mYTPAZy=cU5SKtzYYqH4jbT_qPGw@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Fix sparse rcu warnings in client.c
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 10:08 PM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Alexander Kapshuk wrote on Thu, Jun 18, 2020:
> > Address sparse nonderef rcu warnings:
> > net/9p/client.c:790:17: warning: incorrect type in argument 1 (different address spaces)
> > net/9p/client.c:790:17:    expected struct spinlock [usertype] *lock
> > net/9p/client.c:790:17:    got struct spinlock [noderef] <asn:4> *
> > net/9p/client.c:792:48: warning: incorrect type in argument 1 (different address spaces)
> > net/9p/client.c:792:48:    expected struct spinlock [usertype] *lock
> > net/9p/client.c:792:48:    got struct spinlock [noderef] <asn:4> *
> > net/9p/client.c:872:17: warning: incorrect type in argument 1 (different address spaces)
> > net/9p/client.c:872:17:    expected struct spinlock [usertype] *lock
> > net/9p/client.c:872:17:    got struct spinlock [noderef] <asn:4> *
> > net/9p/client.c:874:48: warning: incorrect type in argument 1 (different address spaces)
> > net/9p/client.c:874:48:    expected struct spinlock [usertype] *lock
> > net/9p/client.c:874:48:    got struct spinlock [noderef] <asn:4> *
> >
> > Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
>
> Thanks for this patch.
> From what I can see, there are tons of other parts of the code doing the
> same noderef access pattern to access current->sighand->siglock and I
> don't see much doing that.
> A couple of users justify this by saying SLAB_TYPESAFE_BY_RCU ensures
> we'll always get a usable lock which won't be reinitialized however we
> access it... It's a bit dubious we'll get the same lock than unlock to
> me, so I agree to some change though.
>
> After a second look I think we should use something like the following:
>
> if (!lock_task_sighand(current, &flags))
>         warn & skip (or some error, we'd null deref if this happened currently);
> recalc_sigpending();
> unlock_task_sighand(current, &flags);
>
> As you can see, the rcu_read_lock() isn't kept until the unlock so I'm
> not sure it will be enough to please sparse, but I've convinced myself
> current->sighand cannot change while we hold the lock and there just are
> too many such patterns in the kernel.
>
> Please let me know if I missed something or if there is an ongoing
> effort to change how this works; I'll wait for a v2.
>
> --
> Dominique

Thanks for your prompt response.
I too made the same observation of the numerous patterns in the kernel
where current->sighand is accessed without being rcu_dereference()'d.
For this patch I used kernel/signal.c:1368,1398: __lock_task_sighand()
as an example.

I will give your suggestion a careful consideration and will get back
to you soon.
Thanks.
