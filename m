Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D58821909
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 15:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfEQNVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 09:21:02 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:33582 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfEQNVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 09:21:01 -0400
Received: by mail-ed1-f42.google.com with SMTP id n17so10634971edb.0
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 06:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdx9+wppO6hHFlfPXjMUio+1YA5xWnVHzoFl1SLDq7s=;
        b=XW8Gp2PhyPckYRr1k7/rj3FhEHOnOXCmRgY0/ZSKqnAnus1er34PC06jga+68aaT4y
         ODFhZEgXOehuQuq/kgf9kDmZWBKmHrjt+E1Lm/EvkiJfz67oaVwcD8c3arRxpk2Hp3Uv
         as/B/EiAFN9E1akkd0fD0LjExjz8WPJX9/Bh3SnZc/s1jmqk6v9SYatiqVm7YKtj5VmT
         hwijvNCaMyPdS3/25RKY+35zM0IU+q/DTGghzEH5Yp7ZB5gF9qTF6DyLIymzNvhqH35n
         nWsgy58T61XXmQSUywzeSk0O/lvpNQt7umj5XTHRhuIfHmtfEKis2CDdDrcjwtAptmLC
         DT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdx9+wppO6hHFlfPXjMUio+1YA5xWnVHzoFl1SLDq7s=;
        b=PT25q5cEP3CQ0yOPJqH6wNz5NgS3KApMI6LZGZHe9hH42BpK/3Zc3AqJG3wI8Hu6oA
         cJW/P9m7xIaa+b9hsxQlVodN5F/BN3Rn5yiw87qRmLtHrkbCd05+ted07BzKwI83g7aU
         dkw63j11/MAhhx9j5jcAW0aqJ5AzrQ2SAYJ3IdB7pMKGH976myvLQqZxSS7gtaxGwsgE
         xah7t7bryj0MDdVbDoFLOWgJ0c85e+Mhxb//bmdDuHEf+Ge3vEf5gdNBgAPtuK0D8blY
         Nj+JuxGfpSyiWGmZakPS5odsylO1ewN6UFFl01o648tsvaOo11c9KiqgPYfPZOUQUqhr
         Y5Ow==
X-Gm-Message-State: APjAAAV5tnr2MA2vnsMK0rRUfMHy8efDd9RECCHlkMM5f60gfg8d8TBq
        wTm8BjDOsrXtSqMfO9LBVb4Ml0+LCzEuF81xdVI=
X-Google-Smtp-Source: APXvYqykSfG7C2c7Ngl+RPdfKIt9/Z0t9gNhlH7NSZNAtrLARTRBrwwIDxHMuvfBxOh55vwp1uvnONGs3+I/lmUOLs8=
X-Received: by 2002:a17:906:65d4:: with SMTP id z20mr44359895ejn.38.1558099260152;
 Fri, 17 May 2019 06:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com> <CABUuw67P+oZ+P4Ed4si5QB52aamhCKx80o47oU0jNjWzB6C3iw@mail.gmail.com>
 <CA+FuTSdcik=QLc=XMjWSFWty=zEm6_0Q3xKMo=1zi2_zNjwjpw@mail.gmail.com> <655000834f584886ae87f5d8836837ba@AcuMS.aculab.com>
In-Reply-To: <655000834f584886ae87f5d8836837ba@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 17 May 2019 09:20:23 -0400
Message-ID: <CAF=yD-+3dtoWsHSJ713Cv=uq8TidBFpT2CqNN0KXbyDTt5Y_QQ@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     David Laight <David.Laight@aculab.com>
Cc:     Adam Urban <adam.urban@appleguru.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 8:57 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Willem de Bruijn
> > Sent: 17 May 2019 04:23
> > On Thu, May 16, 2019 at 8:27 PM Adam Urban <adam.urban@appleguru.org> wrote:
> > >
> > > And replying to your earlier comment about TTL, yes I think a TTL on
> > > arp_queues would be hugely helpful.
> > >
> > > In any environment where you are streaming time-sensitive UDP traffic,
> > > you really want the kernel to be tuned to immediately drop the
> > > outgoing packet if the destination isn't yet known/in the arp table
> > > already...
>
> I suspect we may suffer from the same problems when sending out a lot
> of RTP (think of sending 1000s of UDP messages to different addresses
> every 20ms).
> For various reasons the sends are done from a single raw socket (rather
> than 'connected' UDP sockets).
>
> > For packets that need to be sent immediately or not at all, you
> > probably do not want a TTL, but simply for the send call to fail
> > immediately with EAGAIN instead of queuing the packet for ARP
> > resolution at all. Which is approximated with unres_qlen 0.
> >
> > The relation between unres_qlen_bytes, arp_queue and SO_SNDBUF is
> > pretty straightforward in principal. Packets can be queued on the arp
> > queue until the byte limit is reached. Any packets on this queue still
> > have their memory counted towards their socket send budget. If a
> > packet is queued that causes to exceed the threshold, older packets
> > are freed and dropped as needed. Calculating the exact numbers is not
> > as straightforward, as, for instance, skb->truesize is a kernel
> > implementation detail.
>
> But 'fiddling' with the arp queue will affect all traffic.
> So you'd need it to be per socket option so that it is a property
> of the message by the time it reaches the arp code.

A per socket or even datagram do-not-queue signal would be
interesting. Where any queuing would instead result in send failure
(though this feedback signal does not work for secondary qdiscs).

The recent SCM_TXTIME cmsg has a deadline mode that might implement
this. In which case we would only have to check for it in the neighbor
layer.

>
> > The simple solution is just to overprovision the socket SO_SNDBUF. If
> > there are few sockets in the system that perform this role, that seems
> > perfectly fine.
>
> That depends on how often you are sending messages compared to the
> arp timeout. If you are sending 50 messages a second to each of 1000
> destinations the over provisioning of SO_SNDBUF would have to be extreme.
>
> FWIW we do sometimes see sendmsg() taking much longer than expected,
> but haven't get tracked down why.

I've observed this problem with health checks under particular ARP
settings as well.
