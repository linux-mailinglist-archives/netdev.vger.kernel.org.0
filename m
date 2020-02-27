Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76437171530
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 11:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgB0Klg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 05:41:36 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41071 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbgB0Klg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 05:41:36 -0500
Received: by mail-oi1-f195.google.com with SMTP id i1so2790039oie.8
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 02:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jpiav8fKOwVu0TUVR7UwwTMPFM0cFCBF2DyYYg5YgDY=;
        b=ngaSYzm6MKTTw3cw8N+eC3tcGz8rF+p+q8HQUProMdhEUg7hBYAKChodn050qgjpvR
         yq9RRV0phhGe/dYv5IqrtRFMWsbZWu1uKYtC0Y5D/itc7LLNnIc+TK7FI13bxc+PC/wn
         uoFhtGitcYtuHKF2LUluXqr50xXvCTtPZa9NKpvcKyMCqHz+yk2zGaXvsfSvywA5HOIx
         qWcopZxV7ApTXiN0+33eCoGpwLTBaBNq4vzOK8XD+OgCbng1g/thw6dBayW0szfmAF1k
         20Yb5aFkzcobRCgK+gTLjQtOxexvIZYfWy5GYILbX84dzDgBdtKD+foL4MIDGeOvquot
         X0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jpiav8fKOwVu0TUVR7UwwTMPFM0cFCBF2DyYYg5YgDY=;
        b=KIVbks68/IlapAF8gCq3KSK/NKk0EF6jm0G3QOWfZcE7MezEDGD/JCfJpXgyTVjv54
         VcOOm+HlH+Xm3jNnJ6ExQy+4BUwrI3Kv0jaOaLGbrjJVjAbr0Xk4tbA0SYHDlRxHn27h
         Eh8BUOWeuT2BoNrALugbkG7nli7rhp/zZMz/Z4IpgnyA+b7EsriQzAupPhvFSFwuPyiO
         KqA+gNup1ax3ei1dW8kePb13sBTs0n/tvm5aY1OVmQ5UV558v5pdcI2Tx5MmXbv9HyqX
         eTV5lKqI4m4dPPWzv6AcoOvXpc2rfAFWm1rPI77jf2+iX5p8oJQTDIAgBEGvzOLwl9v9
         k1mw==
X-Gm-Message-State: APjAAAW1WGYgJU4DadJ4ytwgFqz7STw2f5KrzLnl4TMJ8nCpzVmlcHPy
        ZGEWLrgHzTSWfjGJdq7WPFMCUMUYa8wwn1DBkI4=
X-Google-Smtp-Source: APXvYqxxajQvPar1mr+dY//Rjw7pAD98j9iRgtYWdM5c03ICRv0uM0yGhuonCGpeiAgWxAwbWjDo2BLsV2N3JEvp/+k=
X-Received: by 2002:aca:dc45:: with SMTP id t66mr2825383oig.39.1582800095098;
 Thu, 27 Feb 2020 02:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk>
 <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com> <87wo88wcwi.fsf@toke.dk>
In-Reply-To: <87wo88wcwi.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 27 Feb 2020 11:41:23 +0100
Message-ID: <CAJ8uoz2++_D_XFwUjFri0HmNaNWKtiPNrJr=Fvc8grj-8hRzfg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 11:22 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> David Ahern <dahern@digitalocean.com> writes:
>
> > On 2/26/20 1:34 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>> OK so basically there would be commands to configure which TX queue i=
s
> >>> used by XDP. With enough resources default is to use dedicated queues=
.
> >>> With not enough resources default is to fail binding xdp program
> >>> unless queues are specified. Does this sound reasonable?
> >> Yeah, that was the idea. See this talk from LPC last year for more
> >> details: https://linuxplumbersconf.org/event/4/contributions/462/
> >>
> >
> > Can we use one of the breakout timeslots at netdevconf and discuss this
> > proposal and status?
>
> Adding in Magnus and Jesper; I won't be at netdevconf, sadly, but you
> guys go ahead :)
>
> Magnus indicated he may have some preliminary code to share soonish.
> Maybe that means before netdevconf? ;)

I will unfortunately be after Netdevconf due to other commitments. The
plan is to send out the RFC to the co-authors of the Plumbers
presentation first, just to check the sanity of it. And after that
send it to the mailing list. Note that I have taken two shortcuts in
the RFC to be able to make quicker progress. The first on is the
driver implementation of the dynamic queue allocation and
de-allocation. It just does this within a statically pre-allocated set
of queues. The second is that the user space interface is just a
setsockopt instead of a rtnetlink interface. Again, just to save some
time in this initial phase. The information communicated in the
interface is the same though. In the current code, the queue manager
can handle the queues of the networking stack, the XDP_TX queues and
queues allocated by user space and used for AF_XDP. Other uses from
user space is not covered due to my setsockopt shortcut. Hopefully
though, this should be enough for an initial assessment.

/Magnus

> -Toke
>r
