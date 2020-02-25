Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D05716EFF2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 21:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731685AbgBYUUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 15:20:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52373 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbgBYUUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 15:20:37 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so577608wmc.2
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 12:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSUQgM+Gi05W9iBcKU4tKxIsn0Ezgn1f82aBeGbKCQc=;
        b=nqi/HRpB5I74D1XvhiysB93d83mLFP1U5h689x1aT/pY3ixf3cL4LGvZ6pDXLOXaGK
         ZLi6KQDlaw4jQxvmjFcwCaCy4pOLqKH4JaDyqRK/ht7o2KcQkXT36gZGqJKPTgDNoMrJ
         qRWSKvTiRcp33aoKEyGYIX5+8LeZh5xy5CDh0ctFOLsh/dsToRIUaog7iFziNpaAIvNA
         pPG3/gFd62P3k0y4ReaowYhupjBlVv7WuRMYfWoW58OuN0DUWdwYNQkMTedHFus7XTO4
         gWkRvnFMZDCrXYtNZUZTiSZOIbBB0AdkeXqdBW2dqG8EZj03fh690xo/9NBx3cV9L7oh
         549Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSUQgM+Gi05W9iBcKU4tKxIsn0Ezgn1f82aBeGbKCQc=;
        b=KEdUHKkPWmUfKV54G8soiKnfp+VpXrwVKvzIuYcAfCUhOq8EDLTwUjl3zWFMPbSYuW
         HMReGAh+kMT/Pg2zK4J5Zjtwiw2adSaMZTmEZ2TWbTfVqwyFnBLKvB3HZed2O0GAT70a
         mga/ThpHei7L46x/m0cKhk6MbTF5QDruOg2VzKfM7pWXxAijrk0TAHZwvHtUgyoLd6f2
         v56OjEDrx2mNu4PD8TT16AhBMmutH4kMZBCg6Lk0GkZcUFsDdhpV3x7VpfCizUqg8YwT
         DCR+6pJ4CgX64eqFxWyxvwAiEy5/Vx+dNLICkMQwC5rMr2WiqNuUabsljHd9f6mbCRvm
         nVUA==
X-Gm-Message-State: APjAAAV3w6uJzjCL0EBj8X6yOaY7Jvp+ENViUoK/6s+1sQW0yAyqs5RN
        5RoqMeHpctdGFNmWEpmx6f3tplzoru6WMmX6xKnbgA==
X-Google-Smtp-Source: APXvYqx+uY8MCJdK2SEFHpQuAu2dAUKFYLEZl12iM4hxN9CJm9MAJ+UVg0Dg5k1L+zOK8+gmjZFmKEhH9b8WsvYtwvM=
X-Received: by 2002:a1c:9c4c:: with SMTP id f73mr865526wme.125.1582662034197;
 Tue, 25 Feb 2020 12:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20200225060620.76486-1-arjunroy.kdev@gmail.com>
 <CANn89iLrOwvNSHOB2i_+gMmN29O6BpJrnd9RfNERDTayNf7qKA@mail.gmail.com>
 <CAOFY-A35RJOwg_4Vqc1SzeGb83OoWG-LE+dJb1maRPauaLLNwQ@mail.gmail.com>
 <CAOFY-A0DXFse8=Mm0fx6kxAvsFZ=AzT96_P+WT=ctSESBncNjA@mail.gmail.com> <CACSApvac8dxyec08Ac1dpD+TERWp6h94o+8Xg5mW6QLe3mUYNg@mail.gmail.com>
In-Reply-To: <CACSApvac8dxyec08Ac1dpD+TERWp6h94o+8Xg5mW6QLe3mUYNg@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 25 Feb 2020 12:20:22 -0800
Message-ID: <CAOFY-A1UEPx12274Mqw3xefNDAVg2FQGAvV4LHoWMLyihyaD6w@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 9:17 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Tue, Feb 25, 2020 at 12:04 PM Arjun Roy <arjunroy@google.com> wrote:
> >
> > On Tue, Feb 25, 2020 at 8:48 AM Arjun Roy <arjunroy@google.com> wrote:
> > >
> > > On Mon, Feb 24, 2020 at 10:28 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Mon, Feb 24, 2020 at 10:06 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> > > > >
> > > > > From: Arjun Roy <arjunroy@google.com>
> > > > >
> > > > > TCP receive zerocopy currently does not update the returned optlen for
> > > > > getsockopt(). Thus, userspace cannot properly determine if all the
> > > > > fields are set in the passed-in struct. This patch sets the optlen
> > > > > before return, in keeping with the expected operation of getsockopt().
> > > > >
> > > > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive
> > > > > zerocopy")
> > > >
> > > >
> > > > OK, please note for next time :
> > > >
> > > > Fixes: tag should not wrap : It should be a single line.
> > > > Preferably it should be the first tag (before your Sob)
> > > >
> > > > Add v2 as in [PATCH v2 net-next]  :  so that reviewers can easily see
> > > > which version is the more recent one.
> > > >
> > > >
> > > > >
> > > > > +               if (!err) {
> > > > > +                       if (put_user(len, optlen))
> > > > > +                               return -EFAULT;
> > > >
> > > > Sorry for not asking this before during our internal review :
> > > >
> > > > Is the cost of the extra STAC / CLAC (on x86) being high enough that it is worth
> > > > trying to call put_user() only if user provided a different length ?
> > >
> > > I'll have to defer to someone with more understanding of the overheads
> > > involved in this case.
> > >
> >
> > Actually, now that I think about it, the (hopefully) common case is
> > indeed that the kernel and userspace agree on the size of the struct,
> > so I think just having just that one extra branch to check before
> > issuing a put_user() would be well worth it compared to all the
> > instructions in put_user(). I'll send a v2 patch with the change.
>
> Thank you, Arjun.  Given that most TCP socket options overwrite the
> optlen even when returning error, I think we can avoid having the
> extra branch by simply moving put_user right after the check for "len
> == sizeof(zc)" and before "switch(len)".
>
> Thanks,
> Soheil
>
Unfortunately I don't that works in this case - there's a point before
then that could set len to sizeof(zc) (if len was > sizeof(zc) to
begin with) which would disrupt what we want.

Accounting for that would probably add more complication and still
require a branch, so I'm going with the simpler move in this case.
Will send a v2 patch out momentarily.

Thanks,
-Arjun


> > Thanks,
> > -Arjun
> >
> > > -Arjun
