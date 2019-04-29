Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE4E3DC
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfD2NhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:37:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34294 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfD2NhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:37:10 -0400
Received: by mail-ed1-f68.google.com with SMTP id a6so9183210edv.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 06:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XRC72bwxoB8dmbaXPgvxgagGIY74mvZ2HSyRfhZoXOc=;
        b=r5s4SIsGNZxCQaizviMrkiqmt0wD47uS9Buy0oi878Z4URT+qOs3tvipUz8QEGoD/Z
         xmRMETnwemJvqe8Bs0+aP47WZUehJZ3zqYKYM2TygR/aBwDaSQa4NRBvfGmfNE9yMgHJ
         LDkjDqW+TB5j5grwboPG1o2j5oCucWFixbZSmfhH4DbyMqacOScsxN+UvR4BFamZpNyW
         X/DeKLkkq8RMyFCKAIXcDPT+QvgfQh0oMTs191tsYhuiVC3V9ka2zH5yP9NLtvjGwwH9
         XNiocUfziPZOM0rpxRS3XeTiow9rTik9Ucc4odJpA4ndB1C5wf5IKKLCPrgfjb9amzgU
         2dNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XRC72bwxoB8dmbaXPgvxgagGIY74mvZ2HSyRfhZoXOc=;
        b=iumdDZpU816FKgQC3HHP0wtlxWxLt+iH0FR2f5zPeKQ6BEqmSnPHwz6K9lv2IT6Wkd
         YTNeLGk+W343Cr+HqkOdfHtERZw4B8MejfXSBYK+7beYCmQ33xET2gAczd5GC7iSAyrE
         Ht370ahHXDGpljhIRh8bLnM4EIJaGaz5CfzaLpoHQNmcLCjU1VIAb0r9DZsRZoFDCmNh
         c90zu3A4/ONVWk/MQlbuyHxIIf6v8WYUFhkFpHnnwEf52KrtnA1h0NlRkBzt6/8QHjep
         suhoGaxiTJ6ZJaLOVS0r7L4pPMSWAH3UDhF0Qhnj2nW9w7hJAk0sUagztX3jIE9DB6jY
         kJJQ==
X-Gm-Message-State: APjAAAWwYv8WMDm/2+8QyCcCmeJl+kNype5HuXNRtmOVFdlTj+iDj8h9
        2/Cy/ioGB+ynxTZAg4aSxaTD2fzAtD4fASvjN98=
X-Google-Smtp-Source: APXvYqyPvVpX9na0YsMXxRu0ofL7y0v6lA5b3wVGhXuWDtuiPKCRrz2vJMEkazWKoR/ymMm9oY5Hz76Y0Wj2VceYT2w=
X-Received: by 2002:a17:906:7d08:: with SMTP id u8mr18849895ejo.1.1556545028482;
 Mon, 29 Apr 2019 06:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190426192735.145633-1-willemdebruijn.kernel@gmail.com>
 <92f9793efb2a4d9fb7973dcb47192c4b@AcuMS.aculab.com> <CAF=yD-KKSt+y5AcMrBDv6NUVeMoBVXy11dRJEZ1mDxf-Z5Rw6w@mail.gmail.com>
 <9e3e74586bdb4ea3bef2848d4ff60fcf@AcuMS.aculab.com>
In-Reply-To: <9e3e74586bdb4ea3bef2848d4ff60fcf@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Apr 2019 09:36:32 -0400
Message-ID: <CAF=yD-+z0wxMM-rGXUo3scLo5N6DnkJ73SVgKgGkK3Wav5seVQ@mail.gmail.com>
Subject: Re: [PATCH net] packet: validate msg_namelen in send directly
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@idosch.org" <idosch@idosch.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 9:25 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Willem de Bruijn
> > Sent: 29 April 2019 13:53
> > On Mon, Apr 29, 2019 at 5:00 AM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Willem de Bruijn
> > > > Sent: 26 April 2019 20:28
> > > > Packet sockets in datagram mode take a destination address. Verify its
> > > > length before passing to dev_hard_header.
> > > >
> > > > Prior to 2.6.14-rc3, the send code ignored sll_halen. This is
> > > > established behavior. Directly compare msg_namelen to dev->addr_len.
> > > >
> > > > Fixes: 6b8d95f1795c4 ("packet: validate address length if non-zero")
> > > > Suggested-by: David Laight <David.Laight@aculab.com>
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > ---
> > > >  net/packet/af_packet.c | 18 ++++++++++++------
> > > >  1 file changed, 12 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > > > index 9419c5cf4de5e..13301e36b4a28 100644
> > > > --- a/net/packet/af_packet.c
> > > > +++ b/net/packet/af_packet.c
> > > > @@ -2624,10 +2624,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > >                                               sll_addr)))
> > > >                       goto out;
> > > >               proto   = saddr->sll_protocol;
> > > > -             addr    = saddr->sll_halen ? saddr->sll_addr : NULL;
> > > >               dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
> > > > -             if (addr && dev && saddr->sll_halen < dev->addr_len)
> > > > -                     goto out_put;
> > > > +             if (po->sk.sk_socket->type == SOCK_DGRAM) {
> > > > +                     addr = saddr->sll_addr;
> > > > +                     if (dev && msg->msg_namelen < dev->addr_len +
> > > > +                                     offsetof(struct sockaddr_ll, sll_addr))
> > > > +                             goto out_put;
> > > > +             }
> > >
> > > IIRC you need to initialise 'addr - NULL' at the top of the functions.
> > > I'm surprised the compiler doesn't complain.
> >
> > It did complain when I moved it below the if (dev && ..) branch. But
> > inside a branch with exactly the same condition as the one where used,
> > the compiler did figure it out. Admittedly that is fragile.
>
> Even a function call should be enough since the called code is allowed
> to modify po->sk.sk_socket->type via a global pointer.
>
> > Then it might be simplest to restore the unconditional assignment
> >
> >                 proto   = saddr->sll_protocol;
> > +               addr    = saddr->sll_addr;
> >                 dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
>
> There is an 'addr = NULL' in the 'address absent' branch.
> Moving that higher up makes it even more clear that the address is
> only set in one place.

I can do that. Only, touching code in multiple locations can make
backporting to stable branches more difficult.
