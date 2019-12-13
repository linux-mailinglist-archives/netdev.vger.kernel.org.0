Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3D11DB63
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 01:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbfLMA7e convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Dec 2019 19:59:34 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:40765 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731326AbfLMA7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 19:59:34 -0500
Received: by mail-pl1-f181.google.com with SMTP id g6so473959plp.7;
        Thu, 12 Dec 2019 16:59:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=WuwF0hiqxZ6JMd/RlSlfL/wmLshzp5F40AkEMlUmWNc=;
        b=SPvTyxt2D3NeGq0bL1Xhl9zHLAw0o/geDMeV1lakG4KqsIhMkJn9+si9xYy23axDqp
         jWx9rXqFqsdI+3CH4T0fn2wKpOGLjCFkHxg/RY3Er1bt56gQQ3J4ejhETY9TlXnQbmam
         HOaAntVdjsLdlJnxLZUJyRKIM9N8plevCIT1yD1lKeVkSECdK4hXUvlA7gSXIp/aH2Gi
         /X8qGyL5xTJEjPGalQJf6HWwXvlAR6Gfo/uwPOCiR9++W7gyNW4ETyHFSAhA+LiZ0Sdd
         piqVOSxIbUf+Sre8YvR683ou5PfxUkb0gUF0BaFbkUMsSmNTRtDQn/CxVz0tewulg+b+
         dbNw==
X-Gm-Message-State: APjAAAUJPYHZwu9bRVUteRZzJTgVw9P0tpOonwQtrqR3bpIYdXAARvzN
        wU0ZvGMiHxtGtNxFI8LR3qI=
X-Google-Smtp-Source: APXvYqxXyNyItcfYohs4GSTLqwL9op5FlQ4cyMEbgWOOcLbnLAOKyp4FNBqo5QP3kZQEAZu661acgQ==
X-Received: by 2002:a17:902:ba97:: with SMTP id k23mr4977171pls.343.1576198773415;
        Thu, 12 Dec 2019 16:59:33 -0800 (PST)
Received: from cweber-x250.corp.meraki.com (192-195-83-200.static.monkeybrains.net. [192.195.83.200])
        by smtp.gmail.com with ESMTPSA id h16sm8840432pfn.85.2019.12.12.16.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 16:59:32 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: [Make-wifi-fast] debugging TCP stalls on high-speed wifi
From:   Simon Barber <simon@superduper.net>
In-Reply-To: <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
Date:   Thu, 12 Dec 2019 16:59:30 -0800
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <22B5F072-630A-44BE-A0E5-BF814A6CB9B0@superduper.net>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
 <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
 <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
To:     Dave Taht <dave.taht@gmail.com>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I’m currently adding ACK thinning to Linux’s GRO code. Quite a simple addition given the way that code works.

Simon


> On Dec 12, 2019, at 3:42 PM, Dave Taht <dave.taht@gmail.com> wrote:
> 
> On Thu, Dec 12, 2019 at 1:12 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>> 
>> Hi Eric,
>> 
>> Thanks for looking :)
>> 
>>>> I'm not sure how to do headers-only, but I guess -s100 will work.
>>>> 
>>>> https://johannes.sipsolutions.net/files/he-tcp.pcap.xz
>>>> 
>>> 
>>> Lack of GRO on receiver is probably what is killing performance,
>>> both for receiver (generating gazillions of acks) and sender
>>> (to process all these acks)
>> Yes, I'm aware of this, to some extent. And I'm not saying we should see
>> even close to 1800 Mbps like we have with UDP...
>> 
>> Mind you, the biggest thing that kills performance with many ACKs isn't
>> the load on the system - the sender system is only moderately loaded at
>> ~20-25% of a single core with TSO, and around double that without TSO.
>> The thing that kills performance is eating up all the medium time with
>> small non-aggregated packets, due to the the half-duplex nature of WiFi.
>> I know you know, but in case somebody else is reading along :-)
> 
> I'm paying attention but pay attention faster if you cc make-wifi-fast.
> 
> If you captured the air you'd probably see the sender winning the
> election for airtime 2 or more times in a row,
> it's random and oft dependent on on a variety of factors.
> 
> Most Wifi is *not* "half" duplex, which implies it ping pongs between
> send and receive.
> 
>> 
>> But unless somehow you think processing the (many) ACKs on the sender
>> will cause it to stop transmitting, or something like that, I don't
>> think I should be seeing what I described earlier: we sometimes (have
>> to?) reclaim the entire transmit queue before TCP starts pushing data
>> again. That's less than 2MB split across at least two TCP streams, I
>> don't see why we should have to get to 0 (which takes about 7ms) until
>> more packets come in from TCP?
> 
> Perhaps having a budget for ack processing within a 1ms window?
> 
>> Or put another way - if I free say 400kB worth of SKBs, what could be
>> the reason we don't see more packets be sent out of the TCP stack within
>> the few ms or so? I guess I have to correlate this somehow with the ACKs
>> so I know how much data is outstanding for ACKs. (*)
> 
> yes.
> 
> It would be interesting to repeat this test in ht20 mode, and/or using
> 
> flent --socket-stats --step-size=.04 --te=upload_streams=2 -t
> whatever_variant_of_test tcp_nup
> 
> That will capture some of the tcp stats for you.
> 
>> 
>> The sk_pacing_shift is set to 7, btw, which should give us 8ms of
>> outstanding data. For now in this setup that's enough(**), and indeed
>> bumping the limit up (setting sk_pacing_shift to say 5) doesn't change
>> anything. So I think this part we actually solved - I get basically the
>> same performance and behaviour with two streams (needed due to GBit LAN
>> on the other side) as with 20 streams.
>> 
>> 
>>> I had a plan about enabling compressing ACK as I did for SACK
>>> in commit
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d9f4262b7ea41ca9981cc790e37cca6e37c789e
>>> 
>>> But I have not done it yet.
>>> It is a pity because this would tremendously help wifi I am sure.
>> 
>> Nice :-)
>> 
>> But that is something the *receiver* would have to do.
> 
> Well it is certainly feasible to thin acks on the driver as we did in
> cake. More general. More cpu intensive. I'm happily just awaiting
> eric's work instead.
> 
> One thing comcast inadvertently does to most flows is remark them cs1,
> which tosses big data into the bk queue and acks into the be queue. It
> actually helps sometimes.
> 
>> 
>> The dirty secret here is that we're getting close to 1700 Mbps TCP with
>> Windows in place of Linux in the setup, with the same receiver on the
>> other end (which is actually a single Linux machine with two GBit
>> network connections to the AP). So if we had this I'm sure it'd increase
>> performance, but it still wouldn't explain why we're so much slower than
>> Windows :-)
>> 
>> Now, I'm certainly not saying that TCP behaviour is the only reason for
>> the difference, we already found an issue for example where due to a
>> small Windows driver bug some packet extension was always used, and the
>> AP is also buggy in that it needs the extension but didn't request it
>> ... so the two bugs cancelled each other out and things worked well, but
>> our Linux driver believed the AP ... :) Certainly there can be more
>> things like that still, I just started on the TCP side and ran into the
>> queueing behaviour that I cannot explain.
>> 
>> 
>> In any case, I'll try to dig deeper into the TCP stack to understand the
>> reason for this transmit behaviour.
>> 
>> Thanks,
>> johannes
>> 
>> 
>> (*) Hmm. Now I have another idea. Maybe we have some kind of problem
>> with the medium access configuration, and we transmit all this data
>> without the AP having a chance to send back all the ACKs? Too bad I
>> can't put an air sniffer into the setup - it's a conductive setup.
> 
> see above
>> 
>> 
>> (**) As another aside to this, the next generation HW after this will
>> have 256 frames in a block-ack, so that means instead of up to 64 (we
>> only use 63 for internal reasons) frames aggregated together we'll be
>> able to aggregate 256 (or maybe we again only 255?).
> 
> My fervent wish is to somehow be able to mark every frame we can as not
> needing a retransmit in future standards. I've lost track of what ax
> can do. ? And for block ack retries
> to give up far sooner.
> 
> you can safely drop all but the last three acks in a flow, and the
> txop itself provides
> a suitable clock.
> 
> And, ya know, releasing packets ooo doesn't hurt as much as it used
> to, with rack.
>> Each one of those
>> frames may be an A-MSDU with ~11k content though (only 8k in the setup I
>> have here right now), which means we can get a LOT of data into a single
>> PPDU ...
> 
> Just wearing my usual hat, I would prefer to optimize for service
> time, not bandwidth, in the future,
> using smaller txops with this more data in them, than the biggest
> txops possible.
> 
> If you constrain your max txop to 2ms in this test, you will see tcp
> in slow start ramp up faster,
> and the ap scale to way more devices, with way less jitter and
> retries. Most flows never get out of slowstart.
> 
>> . we'll probably have to bump the sk_pacing_shift to be able to
>> fill that with a single TCP stream, though since we run all our
>> performance numbers with many streams, maybe we should just leave it :)
> 
> Please. Optimizing for single flow performance is an academic's game.
> 
>> 
>> 
> 
> 
> -- 
> Make Music, Not War
> 
> Dave Täht
> CTO, TekLibre, LLC
> http://www.teklibre.com
> Tel: 1-831-435-0729
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast

