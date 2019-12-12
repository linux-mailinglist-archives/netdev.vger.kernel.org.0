Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 542A311DA27
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfLLXmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 18:42:45 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:46805 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfLLXmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 18:42:44 -0500
Received: by mail-io1-f46.google.com with SMTP id t26so465011ioi.13;
        Thu, 12 Dec 2019 15:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZWyV4My1aJmk8+Rn/f00ZFYAsGIsd/LdnfKHd8JtAx4=;
        b=rG8m0szmlNxU/YNq58fVt+KT8c7Tinoo928+5EgQV1if/709iPxBInzTjd1/KMWktl
         fMKSv41ZaH8jQ46IYuIg5HyoYnGUFr9T2lbaYJIcKI96t9UK9kIeOz4esVYngG6g6Mg2
         cM5BAocezrMvC2w+rY2e2xTQksO7qkALeav6amyfltR/C6njCQONEaMkFRGJKuYghR2c
         5jyrrrr4qX7t5JmRMLqpYMoAYom1cy94GsZvw9tunPXxl7nRCkCANUt3wtenDuDQzrK/
         NO86vR0Iymrt6QqxteBE4wLt6u0wVcesjHjyQAmIOF2YtucsIyP1kRaD7GFxvdn8r1SG
         4rKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZWyV4My1aJmk8+Rn/f00ZFYAsGIsd/LdnfKHd8JtAx4=;
        b=k2O8IUgrxlLFxZB4Ro5UHmCNVzPxzq4SpGO04ClQXLTjaMkvtkMyGiJyo8ET+rh5xG
         kw8CcZyV5nue5262AEgu4NR3OZkqoLUIA0JfRTfLbN0XGvnkbRsmFq7J4S23Fv52m2WF
         9rztqX5NN9MmcJNvROzLC/K64EclftHQL9gNdmBUbQA9dQWY2yxDlqZPIsLYd2GccvR2
         aCbPxhn3oQHrFIzKrqXfv3j6LXSDqJrU3QGzbhiDmQTSizZrLtU9y5VGqsk5xSzXC9BV
         YGy1f3ucX3/34Zvtr6CMSjZmruRdf1vN1UbjamqCpEwWBYq94dw8kF5vDHd7fv1zDWJK
         AwqQ==
X-Gm-Message-State: APjAAAV69yjiILbthlFFO/sRzHFB6SAjLXt8Fh3Vwr7FT2nEVtB73qwH
        +cp+j3Bif4uqQBJVMa/UI7W5Xz0xLNMchUpk3vE=
X-Google-Smtp-Source: APXvYqyWxnV/UyLmRxXBbEVkuuawmaDfWBy51Fo/ZQ6opagGbN6ZIkkkpU4RXrxAf7avrNsBjuGv6Nzjh+ZYMTycltI=
X-Received: by 2002:a6b:3c0f:: with SMTP id k15mr3919601iob.246.1576194163357;
 Thu, 12 Dec 2019 15:42:43 -0800 (PST)
MIME-Version: 1.0
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com> <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
In-Reply-To: <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 12 Dec 2019 15:42:31 -0800
Message-ID: <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 1:12 PM Johannes Berg <johannes@sipsolutions.net> w=
rote:
>
> Hi Eric,
>
> Thanks for looking :)
>
> > > I'm not sure how to do headers-only, but I guess -s100 will work.
> > >
> > > https://johannes.sipsolutions.net/files/he-tcp.pcap.xz
> > >
> >
> > Lack of GRO on receiver is probably what is killing performance,
> > both for receiver (generating gazillions of acks) and sender
> > (to process all these acks)
> Yes, I'm aware of this, to some extent. And I'm not saying we should see
> even close to 1800 Mbps like we have with UDP...
>
> Mind you, the biggest thing that kills performance with many ACKs isn't
> the load on the system - the sender system is only moderately loaded at
> ~20-25% of a single core with TSO, and around double that without TSO.
> The thing that kills performance is eating up all the medium time with
> small non-aggregated packets, due to the the half-duplex nature of WiFi.
> I know you know, but in case somebody else is reading along :-)

I'm paying attention but pay attention faster if you cc make-wifi-fast.

If you captured the air you'd probably see the sender winning the
election for airtime 2 or more times in a row,
it's random and oft dependent on on a variety of factors.

Most Wifi is *not* "half" duplex, which implies it ping pongs between
send and receive.

>
> But unless somehow you think processing the (many) ACKs on the sender
> will cause it to stop transmitting, or something like that, I don't
> think I should be seeing what I described earlier: we sometimes (have
> to?) reclaim the entire transmit queue before TCP starts pushing data
> again. That's less than 2MB split across at least two TCP streams, I
> don't see why we should have to get to 0 (which takes about 7ms) until
> more packets come in from TCP?

Perhaps having a budget for ack processing within a 1ms window?

> Or put another way - if I free say 400kB worth of SKBs, what could be
> the reason we don't see more packets be sent out of the TCP stack within
> the few ms or so? I guess I have to correlate this somehow with the ACKs
> so I know how much data is outstanding for ACKs. (*)

yes.

It would be interesting to repeat this test in ht20 mode, and/or using

flent --socket-stats --step-size=3D.04 --te=3Dupload_streams=3D2 -t
whatever_variant_of_test tcp_nup

That will capture some of the tcp stats for you.

>
> The sk_pacing_shift is set to 7, btw, which should give us 8ms of
> outstanding data. For now in this setup that's enough(**), and indeed
> bumping the limit up (setting sk_pacing_shift to say 5) doesn't change
> anything. So I think this part we actually solved - I get basically the
> same performance and behaviour with two streams (needed due to GBit LAN
> on the other side) as with 20 streams.
>
>
> > I had a plan about enabling compressing ACK as I did for SACK
> > in commit
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5d9f4262b7ea41ca9981cc790e37cca6e37c789e
> >
> > But I have not done it yet.
> > It is a pity because this would tremendously help wifi I am sure.
>
> Nice :-)
>
> But that is something the *receiver* would have to do.

Well it is certainly feasible to thin acks on the driver as we did in
cake. More general. More cpu intensive. I'm happily just awaiting
eric's work instead.

One thing comcast inadvertently does to most flows is remark them cs1,
which tosses big data into the bk queue and acks into the be queue. It
actually helps sometimes.

>
> The dirty secret here is that we're getting close to 1700 Mbps TCP with
> Windows in place of Linux in the setup, with the same receiver on the
> other end (which is actually a single Linux machine with two GBit
> network connections to the AP). So if we had this I'm sure it'd increase
> performance, but it still wouldn't explain why we're so much slower than
> Windows :-)
>
> Now, I'm certainly not saying that TCP behaviour is the only reason for
> the difference, we already found an issue for example where due to a
> small Windows driver bug some packet extension was always used, and the
> AP is also buggy in that it needs the extension but didn't request it
> ... so the two bugs cancelled each other out and things worked well, but
> our Linux driver believed the AP ... :) Certainly there can be more
> things like that still, I just started on the TCP side and ran into the
> queueing behaviour that I cannot explain.
>
>
> In any case, I'll try to dig deeper into the TCP stack to understand the
> reason for this transmit behaviour.
>
> Thanks,
> johannes
>
>
> (*) Hmm. Now I have another idea. Maybe we have some kind of problem
> with the medium access configuration, and we transmit all this data
> without the AP having a chance to send back all the ACKs? Too bad I
> can't put an air sniffer into the setup - it's a conductive setup.

see above
>
>
> (**) As another aside to this, the next generation HW after this will
> have 256 frames in a block-ack, so that means instead of up to 64 (we
> only use 63 for internal reasons) frames aggregated together we'll be
> able to aggregate 256 (or maybe we again only 255?).

My fervent wish is to somehow be able to mark every frame we can as not
needing a retransmit in future standards. I've lost track of what ax
can do. ? And for block ack retries
to give up far sooner.

you can safely drop all but the last three acks in a flow, and the
txop itself provides
a suitable clock.

And, ya know, releasing packets ooo doesn't hurt as much as it used
to, with rack.
> Each one of those
> frames may be an A-MSDU with ~11k content though (only 8k in the setup I
> have here right now), which means we can get a LOT of data into a single
> PPDU ...

Just wearing my usual hat, I would prefer to optimize for service
time, not bandwidth, in the future,
using smaller txops with this more data in them, than the biggest
txops possible.

If you constrain your max txop to 2ms in this test, you will see tcp
in slow start ramp up faster,
and the ap scale to way more devices, with way less jitter and
retries. Most flows never get out of slowstart.

> . we'll probably have to bump the sk_pacing_shift to be able to
> fill that with a single TCP stream, though since we run all our
> performance numbers with many streams, maybe we should just leave it :)

Please. Optimizing for single flow performance is an academic's game.

>
>


--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
