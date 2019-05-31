Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCACF313AA
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfEaRS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:18:58 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43711 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfEaRS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:18:57 -0400
Received: by mail-yb1-f195.google.com with SMTP id n145so3811771ybg.10
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnmvIpCDD1mIa9gm9HUiphTkGAm91+zvds9x4Vo74PU=;
        b=TKbOB7lTU9U3vVGKczPuouUfER+hEYS+HOg1NSkUtNt4t83o0ISnGjL+DRamy6kv5R
         cbT0aVyeS/7v7/Ygcr2LEbzD5946ss7nyPxOX1UYyEGAXMdKLI3jw9swrwmgPDldzSBm
         HKtSKTWkCoJ2xSenFRMU8nW3nVD/CbB1FBE9ZJYu/ZlMEbpCiiTZgT/33W82SDSZDRK3
         se1fzY7s48ukQCBJZ4fqw24evcSjruKzAjC3fI3j1+nOq97x1JHa96XwpeXJPzFzzoRq
         h/+D3Y36luJSYjLDAVUiWleDfJ4E60KUYqLxyVM/5rSknXqsmE7bCEj3R2ZGMvKcVr1A
         IU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnmvIpCDD1mIa9gm9HUiphTkGAm91+zvds9x4Vo74PU=;
        b=X+X0outL/bVAoz1dJkRVRkceOeZW0la/r1U6CaIy+jn+8490SuAvMQHkHIEJiqW4Ws
         FzlJMJPaNHFRlwOj0RObNLmOQUuPYFXxogCA4WVuOui4HDx/p/1pzepYT3+32eRE8156
         QiKPAQfNmwfKMkFlowjijkoHwbtawxNqdXeVhC9lVl39pCa8SnN9UP4EqxH+jI6nqKqb
         cuiCrmJP2yMW6r0KY4mbbdpxR/5awbOMgFIeNVbJe6pZzLxsZOYTlSwTNRxDjAX3FgQ7
         DsWpNF3tcxaXYwWsgvovuuxW647/FIlm9q94XGMfkcr7VltwmCJiUHc5IxWq3CJS7Ki3
         8WzA==
X-Gm-Message-State: APjAAAU+yr6bnkdcly8LPKYYiYGqZaDvGH56NkYfW2TsP1ruQypqDs23
        XDKStRBi25jhO/PHumT2n0uyGJwBcUCDk/ewvIgpMw==
X-Google-Smtp-Source: APXvYqxQ2awPrITvLSHAzEEYX0Dk+pxaQc+UkvqR0X8wJRFEblOG4TDeVO0zphOuECFZ20SO/odLCVoZIH+YlNXRMJw=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr5394980ybq.518.1559323136587;
 Fri, 31 May 2019 10:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190524160340.169521-12-edumazet@google.com> <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au> <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au> <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
 <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au> <4e2f7f20-5b7f-131f-4d8b-09cfc6e087d4@gmail.com>
 <20190531171135.GM28207@linux.ibm.com>
In-Reply-To: <20190531171135.GM28207@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 May 2019 10:18:45 -0700
Message-ID: <CANn89iL4xYj5mg3Ydh3c1XwWdrnGQ=uiVvx-xS75oPMaEMJ0Yg@mail.gmail.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary smp_store_release/READ_ONCE
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:11 AM Paul E. McKenney <paulmck@linux.ibm.com> wrote:
>
> On Fri, May 31, 2019 at 08:45:47AM -0700, Eric Dumazet wrote:
> >
> >
> > On 5/31/19 7:45 AM, Herbert Xu wrote:
> > > On Fri, May 31, 2019 at 10:24:08AM +0200, Dmitry Vyukov wrote:
> > >>
> > >> OK, let's call it barrier. But we need more than a barrier here then.
> > >
> > > READ_ONCE/WRITE_ONCE is not some magical dust that you sprinkle
> > > around in your code to make it work without locks.  You need to
> > > understand exactly why you need them and why the code would be
> > > buggy if you don't use them.
> > >
> > > In this case the code doesn't need them because an implicit
> > > barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
> > > exists in both places.
> > >
> >
> > More over, adding READ_ONCE() while not really needed prevents some compiler
> > optimizations.
> >
> > ( Not in this particular case, since fqdir->dead is read exactly once, but we could
> > have had a loop )
> >
> > I have already explained that the READ_ONCE() was a leftover of the first version
> > of the patch, that I refined later, adding correct (and slightly more complex) RCU
> > barriers and rules.
> >
> > Dmitry, the self-documentation argument is perfectly good, but Herbert
> > put much nicer ad hoc comments.
>
> I don't see all the code, but let me see if I understand based on the
> pieces that I do see...
>
> o       fqdir_exit() does a store-release to ->dead, then arranges
>         for fqdir_rwork_fn() to be called from workqueue context
>         after a grace period has elapsed.
>
> o       If inet_frag_kill() is invoked only from fqdir_rwork_fn(),
>         and if they are using the same fqdir, then inet_frag_kill()
>         would always see fqdir->dead==true.
>
>         But then it would not be necessary to check it, so this seems
>         unlikely
>

Nope, inet_frag_kill() can be called from timer handler, and there is
already an existing barrier (spinlock) before we call it (also under
rcu_read_lock())

ip_expire(struct timer_list *t)

rcu_read_lock();
spin_lock(&qp->q.lock);
 ... ipq_kill(qp);   -> inet_frag_kill()





> o       If fqdir_exit() does store-releases to a number of ->dead
>         fields under rcu_read_lock(), and if the next fqdir_exit()
>         won't happen until after all the callbacks complete
>         (combination of flushing workqueues and rcu_barrier(), for
>         example), then ->dead would be stable when inet_frag_kill()
>         is invoked, and might be true or not.  (This again requires
>         inet_frag_kill() be only invoked from fqdir_rwork_fn().)
>
> So I can imagine cases where this would in fact work.  But did I get
> it right or is something else happening?
>
>                                                         Thanx, Paul
>
