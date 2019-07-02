Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F45D1E3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGBOjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:39:16 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41655 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBOjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:39:16 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so481972eds.8
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ghkBJfH3riiMZVHdgg42gixzfK201WjnkqS3R0mSiJg=;
        b=K8SadsSZIJLlPW/JiwfaFh13OiURHUYzLJXXyjdMJTc5djsIoftwMhbumclHLXK4Pc
         eXEgD8erfoSznT0/M7sg1/fy8KHCwM4L4+NcjZexg5Hlb8IPvJ+9gbgguTwic4n0EPKY
         VgUQVVtaISwRgKX+XCvXmR5Pc7XsMDaBNGegUFCSP7WZpBiGHVEmUIvK2roBrdmCNVRD
         fBlF3FVlaVtY8juG+/kKxdqZcR9i1U49g2pUylQa1YLNXzWY/zAsnexSC/SNNx/K/YZQ
         q7RMy59sFDAL5notYaJKG7YN9n8eQWUhoTH+B9g4yhpxIyuHCBaGiBp8AU7GSVVplBli
         ozOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ghkBJfH3riiMZVHdgg42gixzfK201WjnkqS3R0mSiJg=;
        b=JQ6gOdq8xSZeE/UUAvwPLtzm0nhvbUYNZJI9XnZ7h5H/AptuJtlDXXk8GZ4fhqkMSG
         BWbApiqQZxNU41gV6zyXlWvvhh2ov0tdB+Br2wJ30BrUmcXcWGD22xmrhAioxf/SrzCP
         2dL97FWAl1YS01memgfep4wCVruyfVhIp/4sHGS2eC1KIoXBeZduyD/jIDMtAdkvuDmH
         /q98+VA4AaH1eFJ4wa02wQurbyueBcq0n1egdy81ULWMoJkbwxbmW2vcV0zEooX6FUNC
         aMfJ3oBtFxOJeXc8x1IsWcn+mHf/3MlJdeDNVSXVrEenY1PsIY35SEo3xRnmxbsGTqHs
         LoAw==
X-Gm-Message-State: APjAAAXdY6U2lyMQUBnfnQ4ZuKrEIRU6LKSMLU5Z8QI7QCMg3flSEdGz
        CqI+y3O9H5/aAvAzhf8J7ZPdSB0611Y0ZVc/piMKuQ==
X-Google-Smtp-Source: APXvYqxvzHK+6hYIXpfgwe4H2fpCMiUm6Ve30ERBnrljY3n4wOg8y3nt4dkeJVrm4vv/AHHvj/n3FgOwCWOl50wo4Dw=
X-Received: by 2002:aa7:d30b:: with SMTP id p11mr37026010edq.23.1562078354897;
 Tue, 02 Jul 2019 07:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561999976.git.pabeni@redhat.com> <8c32b92eee12bf0725ead331e7607d8c4012d51f.1561999976.git.pabeni@redhat.com>
 <CA+FuTSfHF_LRuZeW3ZiX5a662=fdAu9zmmpa67WpOkZqkt8Srw@mail.gmail.com> <a2806dab7e472b5316da87318f1b8e48ff68cd4b.camel@redhat.com>
In-Reply-To: <a2806dab7e472b5316da87318f1b8e48ff68cd4b.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jul 2019 10:38:38 -0400
Message-ID: <CAF=yD-+3t9HBP0Q29WW9TMLw14fVqJamBb600R8r1R00NB2Y8Q@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 9:03 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2019-07-01 at 15:07 -0400, Willem de Bruijn wrote:
> > On Mon, Jul 1, 2019 at 1:10 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > This avoids an indirect call per syscall for common ipv4 transports
> > >
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > >  net/ipv4/af_inet.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > > index 8421e2f5bbb3..9a2f17d0c5f5 100644
> > > --- a/net/ipv4/af_inet.c
> > > +++ b/net/ipv4/af_inet.c
> > > @@ -797,6 +797,8 @@ int inet_send_prepare(struct sock *sk)
> > >  }
> > >  EXPORT_SYMBOL_GPL(inet_send_prepare);
> > >
> > > +INDIRECT_CALLABLE_DECLARE(int udp_sendmsg(struct sock *, struct msghdr *,
> > > +                                         size_t));
> >
> > Small nit: this is already defined in include/net/udp.h, which is
> > included. So like tcp_sendmsg, probably no need to declare.
>
> Thank you for the review!
>
> You are right, that declaration can be dropped.
> >
> > If defining inet6_sendmsg and inet6_recvmsg in include/net/ipv6.h,
> > perhaps do the same for the other missing functions, instead of these
> > indirect declarations at the callsite?
>
> Uhm... since inet6_{send,recv}msg exists only for retpoline sake and
> are not exported, I think is probably better move their declaration to
> socket.c via INDIRECT_CALLABLE_DECLARE(), to that ICWs are all self-
> contained.
>
> Unless there are objections about spamming, I can repost the series
> with the above changes.

If just for the spurious declaration, can be merged as is, too.
Either way. Not spammy at all to resend after a day.
