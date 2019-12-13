Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34A11E04F
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLMJKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:10:16 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:37662 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfLMJKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:10:15 -0500
Received: by mail-yb1-f179.google.com with SMTP id x139so562524ybe.4;
        Fri, 13 Dec 2019 01:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TbC55wrZwYGHq1ldqQ5o7D8fMLmXBwSKiD5tYxW82D0=;
        b=e/hJYjQLOmUykX6b4f24wrqdn59OxzXhYg0aZvBhzvO/c070bTEDuXBwb/rgm+dfji
         RPPCTCKICtAsR2LMRV61S3nRmS5a2qxwffkOH84zSop4OsMYh85zBU6DyGphmbPl7Ng/
         58hAIOnxX0r/7fuNpSCilWYsfYWkzu/5cZC0NHZiqGG5YrmXmzn60aXWZQe7x5fI33sZ
         Ct174LGx47MPfjCJeyzKtKw7wj8czic6L+BCu1mOD7E1OBX/5M1KMLQUp0CvF98kb6Ej
         NapnRSRmu3uGeY1WFw4kWVRzIYTQanrkN/mNi4ckD4BLUEWStD17KV3DtjxR0to0A1Ps
         bDZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TbC55wrZwYGHq1ldqQ5o7D8fMLmXBwSKiD5tYxW82D0=;
        b=SvIbx9J2WoSdtjrFXokWfZczcn5DvscNtsTigkhM/JgPNUnNODH0BpflF9Ld+uDoCG
         /tQ4zre4Koy4Qao0yTNP6R3PFd6BY2dA8eRzQSMFprFNUC8O1mUs1qxwknQUtSl+GmdW
         IkoqGbgiW+6F45VST4uvRlkql3dGf3OFXLD5rqTRDuk8wJ5XOObuhjDtXIzB6PYwXtnP
         3i6N2r1sl0zVqJcd2ptpfu+fzB+Jh71HTstAoEN6R57TXZf1QdyCAOUlhPyATvG7vrDe
         GiCW7iLzn+iCp7HZsZ+Ij6N0fuj9zmZohaVpzgickv9dVYTUr9VejxLIFrln+eWBur9p
         zKCg==
X-Gm-Message-State: APjAAAWPTNcT+QONO5hYY5JSUsmFN5czL8HVQ/isFValv7gJkw6dfj6k
        bYGiOOK+aLO+Rl+EsPGvIzxevPsfqJEp4fzQMzE=
X-Google-Smtp-Source: APXvYqzFbr3SC3sncwKiCdGbsh+8/3JFW0SgmwklLbh2Ts9ttESOPSBncmHt8DDXJraw6NJ/tQ+o78Y4wb9fCU/Arhk=
X-Received: by 2002:a25:c4c6:: with SMTP id u189mr7083978ybf.145.1576228214013;
 Fri, 13 Dec 2019 01:10:14 -0800 (PST)
MIME-Version: 1.0
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com> <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
In-Reply-To: <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Fri, 13 Dec 2019 14:40:00 +0530
Message-ID: <CABPxzYJZLHBvtjN7=-hPiUK1XU_b60m8Wpw4tHsT7zOQwZWRVw@mail.gmail.com>
Subject: Re: debugging TCP stalls on high-speed wifi
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 2:43 AM Johannes Berg <johannes@sipsolutions.net> wrote:
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
>
> But unless somehow you think processing the (many) ACKs on the sender
> will cause it to stop transmitting, or something like that, I don't
> think I should be seeing what I described earlier: we sometimes (have
> to?) reclaim the entire transmit queue before TCP starts pushing data
> again. That's less than 2MB split across at least two TCP streams, I
> don't see why we should have to get to 0 (which takes about 7ms) until
> more packets come in from TCP?
>
> Or put another way - if I free say 400kB worth of SKBs, what could be
> the reason we don't see more packets be sent out of the TCP stack within
> the few ms or so? I guess I have to correlate this somehow with the ACKs
> so I know how much data is outstanding for ACKs. (*)
Maybe try 'reno' instead of 'cubic' to see if congestion control is
being too careful?I
n my experiments a while ago reno was a bit more aggressive esp. in less
lossy environments.
>
>
> The sk_pacing_shift is set to 7, btw, which should give us 8ms of
> outstanding data. For now in this setup that's enough(**), and indeed
> bumping the limit up (setting sk_pacing_shift to say 5) doesn't change
> anything. So I think this part we actually solved - I get basically the
> same performance and behaviour with two streams (needed due to GBit LAN
> on the other side) as with 20 streams.
As you have said CPU util is low, maybe try disabling RSS (as we are
using 2 streams)
and see if that is causing any concurrency issues?
>
>
> > I had a plan about enabling compressing ACK as I did for SACK
> > in commit
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d9f4262b7ea41ca9981cc790e37cca6e37c789e
> >
> > But I have not done it yet.
> > It is a pity because this would tremendously help wifi I am sure.
>
> Nice :-)
>
> But that is something the *receiver* would have to do.
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
>
>
> (**) As another aside to this, the next generation HW after this will
> have 256 frames in a block-ack, so that means instead of up to 64 (we
> only use 63 for internal reasons) frames aggregated together we'll be
> able to aggregate 256 (or maybe we again only 255?). Each one of those
> frames may be an A-MSDU with ~11k content though (only 8k in the setup I
> have here right now), which means we can get a LOT of data into a single
> PPDU ... we'll probably have to bump the sk_pacing_shift to be able to
> fill that with a single TCP stream, though since we run all our
> performance numbers with many streams, maybe we should just leave it :)
>
>


-- 
Thanks,
Regards,
Chaitanya T K.
