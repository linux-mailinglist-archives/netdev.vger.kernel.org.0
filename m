Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E6414CF8B
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgA2RVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:21:44 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42050 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgA2RVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 12:21:43 -0500
Received: by mail-yw1-f68.google.com with SMTP id b81so175511ywe.9
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 09:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/IQnUlZhIXQ6cA8rde71im7xnRTEjmtD1qfBjFVp0mI=;
        b=JeAb5jSqnOoHjuxJgtl+vO32xP7qlblMF3btXErZ9BXFn3YPZ4svLRyEIUFvRDQ6cv
         Iu0sK9ZqdQctbvmt+ywuQWzKUlpKnyHk/oJrmPJtkGhsCrp7C1ddMakzvfZiQyOacg8H
         5Am/l/Qm5ad4cWtYIdoYFl7LgrPH/kq3WRJnun1tjlQ8zNCKc1tidUP2NS9zR8jriFgK
         KBCR5rU0WEsvjHJWtDZtnb0yu8M4VAYtz69xzHd6v9dGDnwcjoxDoISLT3ZA56oEdTww
         BdGN0aHjukN/R7Lr0AQDUacJRz9K4VC7BE2K3ZOPpT1eE4MDiHb6JWHheolnsxNFdCry
         lWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/IQnUlZhIXQ6cA8rde71im7xnRTEjmtD1qfBjFVp0mI=;
        b=hgKqstTmlVnIbSP0Himpsk7VBz7YTkrEoqoATEiGM2f1L8y67gu6bZXACfrKoL0rqJ
         +9U35cddi0YOOUb4OUy718ngD/UdwEmmztAuqCnZAGIsF2lQKEB7gIFV00V3+J/qeSZv
         vAg7+/f+sHfyjbk524hpH809M3u7x7RbQq0ISj/xxjuh3ib8PvsGxCAKKXTsUq/e/GUQ
         pJ60FSbvkEFGSUyTyQxS083aPMsSWaFZVeBRjM188DRXyfN6fVh7TdtI/ouH4tgY1Niw
         jn2K5i+jYH0vUzMZmgG7SXj9Q6bcl9Kq3qMRsbw4/L04Tkbws8Z0ie8mDoG/L671fxvV
         wawg==
X-Gm-Message-State: APjAAAWPgTyYmR0kJCbU8SGSwgWxbbuYqOqz6WQT8fjoyycQkrGwaUiB
        tUb7fMZjnxzegdzBFFD4LiALNfTW
X-Google-Smtp-Source: APXvYqx7bwuXydEaATXDErwB+/n15McOkgdK2qDWg3uM/kn9fMjuNlQToJlrYdcx/BlRqC+HRKK4vQ==
X-Received: by 2002:a81:9146:: with SMTP id i67mr20935790ywg.120.1580318501598;
        Wed, 29 Jan 2020 09:21:41 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id p1sm1327067ywh.74.2020.01.29.09.21.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 09:21:40 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id z125so198496ybf.9
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 09:21:40 -0800 (PST)
X-Received: by 2002:a25:bf91:: with SMTP id l17mr474135ybk.178.1580318499826;
 Wed, 29 Jan 2020 09:21:39 -0800 (PST)
MIME-Version: 1.0
References: <20200127204031.244254-1-willemdebruijn.kernel@gmail.com> <20200128.105909.2133255162840958859.davem@davemloft.net>
In-Reply-To: <20200128.105909.2133255162840958859.davem@davemloft.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 29 Jan 2020 12:21:03 -0500
X-Gmail-Original-Message-ID: <CA+FuTSem3r-7F_=b5eiT1J5QbP9_pHhFNDSkDkz0v19uSVq=Ow@mail.gmail.com>
Message-ID: <CA+FuTSem3r-7F_=b5eiT1J5QbP9_pHhFNDSkDkz0v19uSVq=Ow@mail.gmail.com>
Subject: Re: [PATCH net] udp: segment looped gso packets correctly
To:     David Miller <davem@davemloft.net>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 11:58 AM David Miller <davem@davemloft.net> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Mon, 27 Jan 2020 15:40:31 -0500
>
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Multicast and broadcast packets can be looped from egress to ingress
> > pre segmentation with dev_loopback_xmit. That function unconditionally
> > sets ip_summed to CHECKSUM_UNNECESSARY.
> >
> > udp_rcv_segment segments gso packets in the udp rx path. Segmentation
> > usually executes on egress, and does not expect packets of this type.
> > __udp_gso_segment interprets !CHECKSUM_PARTIAL as CHECKSUM_NONE. But
> > the offsets are not correct for gso_make_checksum.
> >
> > UDP GSO packets are of type CHECKSUM_PARTIAL, with their uh->check set
> > to the correct pseudo header checksum. Reset ip_summed to this type.
> > (CHECKSUM_PARTIAL is allowed on ingress, see comments in skbuff.h)
> >
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
>
> Applied and queued up for -stable, but I have to say:
>
> > +     if (skb->pkt_type == PACKET_LOOPBACK)
> > +             skb->ip_summed = CHECKSUM_PARTIAL;
> > +
>
> There are a lot of implementation detail assumptions encoded into that
> conditional statement :-)
>
> Feel free to follow-up with a patch adding a comment containing a
> condensed version of your commit log here.

Will do. Yeah, that does look pretty obscure. I may have gotten a bit
too used to relying solely on git blame ;-)

Thanks!
