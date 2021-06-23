Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F63B1E37
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 18:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhFWQC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 12:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhFWQC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 12:02:26 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5DBC061574;
        Wed, 23 Jun 2021 09:00:07 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d11so3290245wrm.0;
        Wed, 23 Jun 2021 09:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ky7p5E5Glt+ARNR1+ACXJj8PM4qwkhYTCUGGXf86byc=;
        b=DtSYSSCpqDpWYYp42JMupVgA2pr0xCAFayG8VfR5umevghy+4vA+cIZ2sc+NuyR6So
         pLldtPAnqWAqQM9fm9B0BvozoCncNQMqH8dhAMZXgklgZJVrKU+QUMax9plLr/Na6lDm
         TeWOEQEb9Qs3x5GNda1OeRrCBTDtaFT66fp3M/KYhgVfn//hAbuoTF8zva+K0tFTLuE6
         qh5qiSxWrXyOjEcnRr//ifDmTwVUVocoMW9QH5PXwfprtCAU4yPVaoUj1KL4fF9ZVYbA
         sDeHw3a56oTf7CgzpDoTMN4yFkkg8tRD7g07mh9TKsYmoGE3twte/MpZ06eZhWrUuFbI
         ai0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ky7p5E5Glt+ARNR1+ACXJj8PM4qwkhYTCUGGXf86byc=;
        b=aUH2+GfwHe079xYLF5Zupoc4neNLwkd0hKOPj8Ew4+Ot5cHVrmLA1yUk9w40qgqZBX
         6yrgk1qK5GWbZdT4Un4eEM+ZGxjsZ0QdvWnlQEfouuSbfTizHRp6qA88KBbGLFc48R/P
         EwZ+U2wJd1biI9Ngz8P7TIUyjuqqwjAPKT1YTWs9gLmDfwlloN6WsDAl4eelrHah6Xs8
         z0uF4GE1bhcEJIG+6LzGxmv1SOGygbk/BhMbtoDtEycvH8RMeElkasaqtmRfg+CQjQAn
         GpgPoZSbKTWHy84IkLpFhlNrv6xMOEeNG0eTvY/e5GwxFsJTc/gR19E47cMIkj2X2NwP
         +/jA==
X-Gm-Message-State: AOAM532/5/Xy87JIEcbx5dJ+2iNF3BtFLNGb0WUgzLCQGdzyae5gE7PC
        Ys9RU5NGueeXeNhCkIFY7fH7ztAJCWV81rrKyp0=
X-Google-Smtp-Source: ABdhPJzR41oO6i92ixrN6II8RUAha93sdxoqIJeaXsbn2hRw3Hr1vwvqL7ZcPm5wlX3oOft+r2+PD3kWL/Kr207fdSo=
X-Received: by 2002:a5d:5187:: with SMTP id k7mr819538wrv.395.1624464006015;
 Wed, 23 Jun 2021 09:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1624384990.git.lucien.xin@gmail.com> <cfaa01992d064520b3a9138983e8ec41@AcuMS.aculab.com>
 <CADvbK_e7D4s81vS0rq=P4mQe47dshJgQzaWnrUyCi-Cis4xyhQ@mail.gmail.com>
 <CADvbK_eeJVoWps8UrygEfNdXL76Q2XMoNOoELWHFqOTq2634cA@mail.gmail.com> <8328f935ec4f488e8d95486a7564aec0@AcuMS.aculab.com>
In-Reply-To: <8328f935ec4f488e8d95486a7564aec0@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 23 Jun 2021 11:59:54 -0400
Message-ID: <CADvbK_d0E01o1rZYpX-dbmz57ZZmdRbYiEzYj0XQdOYJpaZ8mA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
To:     David Laight <David.Laight@aculab.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 5:50 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 23 June 2021 04:49
> ...
> > [103] pl_send: PLPMTUD: state: 1, size: 1200, high: 0 <--[a]
> > [103] pl_recv: PLPMTUD: state: 1, size: 1200, high: 0
> ...
> > [103] pl_send: PLPMTUD: state: 2, size: 1456, high: 0
> > [103] pl_recv: PLPMTUD: state: 2, size: 1456, high: 0  <--[b]
> > [103] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
> > [108] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
> > [113] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
> > [118] pl_send: PLPMTUD: state: 2, size: 1488, high: 0
> > [118] pl_recv: PLPMTUD: state: 2, size: 1456, high: 1488 <---[c]
> > [118] pl_send: PLPMTUD: state: 2, size: 1460, high: 1488
> > [118] pl_recv: PLPMTUD: state: 2, size: 1460, high: 1488 <--- [d]
> > [118] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
> > [124] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
> > [129] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
> > [134] pl_send: PLPMTUD: state: 2, size: 1464, high: 1488
> > [134] pl_recv: PLPMTUD: state: 2, size: 1460, high: 1464 <-- around
> > 30s "search complete from 1200 bytes"
> > [287] pl_send: PLPMTUD: state: 3, size: 1460, high: 0
> > [287] pl_recv: PLPMTUD: state: 3, size: 1460, high: 0
> > [287] pl_send: PLPMTUD: state: 2, size: 1464, high: 0 <-- [aa]
> > [292] pl_send: PLPMTUD: state: 2, size: 1464, high: 0
> > [298] pl_send: PLPMTUD: state: 2, size: 1464, high: 0
> > [303] pl_send: PLPMTUD: state: 2, size: 1464, high: 0
> > [303] pl_recv: PLPMTUD: state: 2, size: 1460, high: 1464  <--[bb]  <--
> > around 15s "re-search complete from current pmtu"
> >
> > So since no interval to send the next probe when the ACK is received
> > for the last one,
> > it won't take much time from [a] to [b], and [c] to [d],
> > and there are at most 2 failures to find the right pmtu, each failure
> > takes 5s * 3 = 15s.
> >
> > when it goes back to search from search complete after a long timeout,
> > it will take only 1 failure to get the right pmtu from [aa] to [bb].
>
> What mtu is being used during the 'failures' ?
> I hope it is the last working one.
Yes, it's always the working one, which was set in search complete state.
More specifically, it changes in 3 cases:
a) at the beginning, it's using the dst->mtu;
b) set to the optimal one in search complete state after searching is done.
c) 'black hole' found, it sets to 1200, and starts to probe from 1200.
d) if still fails with 1200, the mtu is set to MIN_PLPMTU, but still
probes with 1200 until it succeeds.

>
> Also, what actually happen if the network route changes from
> one that supports 1460 bytes to one that only supports 1200
> and where ICMP errors are not generated?
then it's the case c) and d) above.

For the "black hole" detection, I'd like to probe it with the current
mtu and 3 times (15s in total)

>
> The first protocol retry is (probably) after 2 seconds.
> But it will use the 1460 byte mtu and fail again.
yeah, but 15s is the time we have to wait for confirming this is
caused by really the mtu change.

>
> Notwithstanding the standards, what pmtu actually exist
> 'in the wild' for normal networks?
PLPMTUD is trying to probe the max payload of SCTP, not
the real pmtu.

> Are there actually any others apart from 'full sized ethernet'
> and 'PPPoE'?
sctp over UDP if that's what you mean.
With the probe, we don't really care about the outer header, because
what we get with the probe is the real available size for sctp payload.

Like we probe with 1400, if it gets ACKed from the peer, the payload 1400
will be able to go though the path.

> So would it actually better to send two probes one for
> each of those two sizes and see which ones respond?

we could only if regardless of the RFC8899:

   "To avoid excessive load, the interval between individual probe
   packets MUST be at least one RTT..."

>
> (I'm not sure we ever manage to send full length packets.
> Our data is M3UA (mostly SMS) and sent with Nagle disabled.
> So even the customers sending 1000s of SMS/sec are unlikely
> to fill packets.)
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
