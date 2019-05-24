Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA0829F1B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfEXTaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 15:30:09 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46671 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfEXTaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 15:30:09 -0400
Received: by mail-ed1-f67.google.com with SMTP id f37so15715042edb.13;
        Fri, 24 May 2019 12:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bevgnpwWp43eLyKYVX1neQ0UpZhiFx6WSxipgBSsKRk=;
        b=Omm51I/HC8uqeMOORrTprPgd8EI0GEG2/vdjRflGw6kD4ao+xJC++uyCNJChLeTp7/
         diqPKe29SGQhAYwnjtB5W1SVme/jv2KbE4Kx5hqEYDQRWo1gG6Eyzguv4X+8vshr/OiK
         CSFPo+j5TsK9FGba/4m6xMj76y3/NRFNYq+FsOza6sL2gfD2r+6DM9fkkMV/KzFw8tpb
         80aQGS2QAltLMofWker9rQY+PLNZh1mGtqm4hpuVJsVZdAOpH37I5sxrXkhYDaUUyoEy
         NsXJbyV0TE4q8dIpWOgnePyDfOAOAeLbYZm/ceLzOekPUO1cRVhKsm5000Egk1nd9V9v
         rpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bevgnpwWp43eLyKYVX1neQ0UpZhiFx6WSxipgBSsKRk=;
        b=DEHslOi5EmzB0S3/wq4Dn0D3zVPahxUllkbNTA1pyQY5fFDt4qOFoVidLX8lejHeqr
         jXsz3CCyYsbpWdDRwoINZ6k9OISzi+/yNPiCR2HLanE/V9SLBmPzGWnmporQqAYCFiTT
         71PITVOARfqlUWbuS9HBZVLMUYuHk06sNU0AQF7xAUhS97G0Yj5y4LPgGoOiPCfNTpBp
         j0LcakPC+neM2NJW6djs3y2Uyx4WbVmYqIX5w/0SnqLzMUa7mlKb3Vd1ALmHCCJJwidq
         aG0Ck1XOqQw4ZfvKUw6vU+nHumDUuFo8E7m6XaeitLhJsGjWCcR31oUax0yF1x9AaE9U
         S+WA==
X-Gm-Message-State: APjAAAXOK0jKUCfmQPPm5YyiveG31+OlW8/N59racpQqzEzDkefBu486
        kvFy4tIAxFcKp4L1uNIy7LlOinn1+uoIGMsmPjI=
X-Google-Smtp-Source: APXvYqyS2Gr9Ox8h2x39qvakn/evhg5BERIyfc6ZfJWEkcvPeJmxxQycHb293J3FqUvkicWp3WNJTIyNkiHpZ5tELEo=
X-Received: by 2002:aa7:ca54:: with SMTP id j20mr105844637edt.23.1558726206280;
 Fri, 24 May 2019 12:30:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
 <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com> <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
 <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com>
In-Reply-To: <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 May 2019 15:29:29 -0400
Message-ID: <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 12:34 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> > Interesting. TCP timestamping takes the opposite choice and does
> > timestamp the last byte in the sendmsg request.
> >
>
> I have a difficult time with the philosophy of TX timestamping the last
> segment. The actual timestamp occurs just before the last segment
> is sent. This is neither the start  nor the end of a GSO packet, which
> to me seems somewhat arbitrary. It is even more arbitrary when using
> software TX tiimestamping. These are timestamps represent the
> time that the packet is queued onto the NIC=E2=80=99s buffer, not actual
> time leaving the wire.

It is the last moment that a timestamp can be generated for the last
byte, I don't see how that is "neither the start nor the end of a GSO
packet".

> Queuing to a ring buffer is usually much faster
> than wire rates. Therefore, say the timestamp of the last 1500 byte
> segment of a 64K GSO packet may in reality be representing a time
> about half way through the burst.
>
> Since the timestamp of a TX packet occurs just before any data is sent,
> I have found it most valuable to timestamp just before the first byte of
> the packet or burst. Conversely, I find it most valuable to get an RX
> timestamp  after the last byte arrives.
>
> > It sounds like it depends on the workload. Perhaps this then needs to
> > be configurable with an SOF_.. flag.
> >
>
> It would be interesting if a practical case can be made for timestamping
> the last segment. In my mind, I don=E2=80=99t see how that would be valua=
ble.

It depends whether you are interested in measuring network latency or
host transmit path latency.

For the latter, knowing the time from the start of the sendmsg call to
the moment the last byte hits the wire is most relevant. Or in absence
of (well defined) hardware support, the last byte being queued to the
device is the next best thing.

It would make sense for this software implementation to follow
established hardware behavior. But as far as I know, the exact time a
hardware timestamp is taken is not consistent across devices, either.

For fine grained timestamped data, perhaps GSO is simply not a good
mechanism. That said, it still has to queue a timestamp if requested.

> > Another option would be to return a timestamp for every segment. But
> > they would all return the same tskey. And it causes different behavior
> > with and without hardware offload.
>
> When it comes to RX packets, getting per-packet (or per segment)
> timestamps is invaluable. They represent actual wire times. However
> my previous research into TX timestamping has led me to conclude
> that there is no practical value when timestamping every packet of
> a back-to-back burst.
>
> When using software TX timestamping, The inter-packet timestamps
> are typically much faster than line rate. Whereas you may be sending
> on a GigE link, you may measure 20Gbps. At higher rates, I have found
> that the overhead of per-packet software timestamping can produce
> gaps in packets.
>
> When using hardware timestamping, I think you will find that nearly all
> adapters only allow one timestamp at a time. Therefore only one
> packet in a burst would get timestamped.

Can you elaborate? When the host queues N packets all with hardware
timestamps requested, all N completions will have a timestamp? Or is
that not guaranteed?

> There are exceptions, for
> example I am playing with a 100G Mellanox adapter that has
> per-packet TX timestamping. However, I suspect that when I am
> done testing, all I will see is timestamps that are representing wire
> rate (e.g. 123nsec per 1500 byte packet).
>
> Beyond testing the accuracy of a NIC=E2=80=99s timestamping capabilities,=
 I
> see very little value in doing per-segment timestamping.

Ack. Great detailed argument, thanks.
