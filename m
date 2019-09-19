Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A07B8253
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 22:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392502AbfISUSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 16:18:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43328 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390609AbfISUSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 16:18:06 -0400
Received: by mail-pf1-f196.google.com with SMTP id a2so3005535pfo.10;
        Thu, 19 Sep 2019 13:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cAVjhmhu7pSgMbcHXRJCmEJ83viZzHQPrEDfxtrY4Mc=;
        b=P8JUOP4eCpFg/p5sEtBFNScWnlt0gjJGJzsuv5iFBoy83vohKUjU2AvWEtULdr3G1r
         42VYRzHz7aCzMQlcS3FTYezDDmD8t9A7A1XnSEjmUvvSuX+dGD70VtekbvZcT0fK/1pi
         7VkTmpFYdqsI5yVYpfKYb6E4a5phHC4nOu54IQe81uYEmmCOBvaDSK4q553+5YcyRU5g
         izvraefWolXIMfUMUDZ3zn/6A9CqisZTH453FpoQ7YqgGQFEVJBc9TAHSpSertIrdUYx
         799wr/920xxj3c6WranFPbj6zTh0sKpQ4aggxlPJ4i35lCSVeK0F8+63hWnK9LTMeopT
         XGiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cAVjhmhu7pSgMbcHXRJCmEJ83viZzHQPrEDfxtrY4Mc=;
        b=Kl7X07esKY9cRKc/qdFlHwfQrMT9CCbiMRS7Me8D7a7VBUTdEXSIlnUT7BYxFjzi8/
         shZPCjcRSNE++0KxjapuyEu7ZOL2yTyh5L6lFltJhUp0NqCy9T3+byBcIjLJbYyY309b
         gee01mrHsn0dloNM7AVXmMOmelitJNWX6jT0Y/ZXqISv9GqfSj+yvZXzm53M2P88tCui
         Td0sBNbJZ89XuuI3UkncNJFW5/20FR9DW+MNKjGRLRV/mdCSY9wfpGw+L8GzqgpmBjPu
         HA8FJXQXY5lo644OcDoUI6tyoz25l5gLFFzrtihMBZV/68RUsyhZbYT5ICmGRB7vW7Pr
         EUgg==
X-Gm-Message-State: APjAAAXmOXcd0O/osPPSEzMJZ64UHssZTz+zcJ7QvgQj/wxb8hWb9TcN
        1B+gWkNuk63F79x4LuKNcUDh2l/nb4BOIvM/xkU=
X-Google-Smtp-Source: APXvYqy7oIVtYNtx9EJmxLTe7zL4Vmlhgv2BhBQsQrwloJEK/bDaIs3hAKBYyA49LULxDhfCJhkgJqKpgErOHpDjbZo=
X-Received: by 2002:a17:90b:d91:: with SMTP id bg17mr5621130pjb.79.1568924286060;
 Thu, 19 Sep 2019 13:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190913200819.32686-1-cpaasch@apple.com> <CALMXkpbL+P8ZM+Z8NHg644X7++opx2He5256D7ZLncntQp+8vw@mail.gmail.com>
 <20190919200726.GA252076@kroah.com>
In-Reply-To: <20190919200726.GA252076@kroah.com>
From:   Christoph Paasch <christoph.paasch@gmail.com>
Date:   Thu, 19 Sep 2019 13:17:54 -0700
Message-ID: <CALMXkpaRjcFdm+O6Dr6yiJQH=eKso+g5ZSYE3SA6gGQLHD9RZA@mail.gmail.com>
Subject: Re: [PATCH v4.14-stable 0/2] Fixes to commit fdfc5c8594c2 (tcp:
 remove empty skb from write queue in error cases)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 1:07 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 19, 2019 at 08:21:43AM -0700, Christoph Paasch wrote:
> > Hello Greg & Sasha,
> >
> > On Sat, Sep 14, 2019 at 12:20 AM Christoph Paasch <cpaasch@apple.com> wrote:
> > >
> > >
> > > The above referenced commit has problems on older non-rbTree kernels.
> > >
> > > AFAICS, the commit has only been backported to 4.14 up to now, but the
> > > commit that fdfc5c8594c2 is fixing (namely ce5ec440994b ("tcp: ensure epoll
> > > edge trigger wakeup when write queue is empty"), is in v4.2.
> > >
> > > Christoph Paasch (2):
> > >   tcp: Reset send_head when removing skb from write-queue
> > >   tcp: Don't dequeue SYN/FIN-segments from write-queue
> >
> > I'm checking in on these two patches for the 4.14 stable-queue.
> > Especially the panic fixed by patch 2 is pretty easy to trigger :-/
>
> Dude, it's been less than a week.  And it's the middle of the merge
> window.  And it's the week after Plumbers and Maintainer's summit.
>
> Relax...

Sorry!

> I'll go queue these up now, but I am worried about them, given this
> total mess the backports seem to have caused.
>
> Why isn't this needed in 4.9.y and 4.4.y also?

From what I see, commit fdfc5c8594c2 has not been backported to 4.9
and older. But I can imagine that eventually it will have to be
backported (I guess Eric can confirm or deny).
If it gets backported to 4.9 and 4.4, my 2 patches will have to come with them.


Christoph
