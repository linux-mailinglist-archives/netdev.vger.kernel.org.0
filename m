Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B2F1A7F1E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbgDNOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388896AbgDNOEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:04:12 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141DCC061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 07:04:12 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m12so17256845edl.12
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/c50VyeHNbLWgRIbX3KJd3kvNvma9nMCuDi9ah7MIKI=;
        b=a4pwAa6smvKSxI9VsyuJxtQCMa49h32B3pSqRkBw1ZY8mSUY98IQEqaSdk4kMkGEzJ
         iZfHZEyFtGSIzE8ZmqwXtP5m9QNPe6T6Ewrtashle/fm6xVve9oL8CsR25tXGlHc/LuQ
         u8TQLkjtIyAFvrgk84S8amcE+WTVGVIDoazt9zIslJjtsMisHvGAaCiDQMZsOByDZqkP
         7dIwWQ/nvEh6wdP4WnYOEPGs9CVg+7CyYPai1QMenefGs0BnAotZp1NQV2eGoe2XG9Sc
         SkKpfZ83gjMcQ5RIkCUzwUtNE0rINh2Fr+QfdxXC3/caQpeGingRmwnIbuVbbYSygJKD
         /Zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/c50VyeHNbLWgRIbX3KJd3kvNvma9nMCuDi9ah7MIKI=;
        b=OEbBglb50poPiGGi2mXo8I9LG6OzG9ddknFa6QZUfNEsvjTnYyg70U7AeOqLV7QSCL
         EDlkTKyxfYHui5DpWaQ6RgMGDxfa0rbifNL5b6RJG0mZZcVyXnq15/P1HouUFIJ7b8GY
         EDEqH+OcMr58n8lP3+xjTCJcNp9NI01gWJfFwtYc48T7OVKTTjHaki5G6Jlv95HLIA7G
         gfBLAts0dgZt/2fxQuZ9xtYXbDb5EzaBq0W+W0nd5SMwmeqOOOUjR81XogD8t2t20zB2
         iODYBIRe+mEueRVm9IndS6RIbv/VHJeMMx5Zjdua21dvfyjIrl3XJQ0MwVOUG45gJ8dK
         zZIQ==
X-Gm-Message-State: AGi0PubEmQ+TsOYE+dLaKA4f08eYHW18EbnshWO26zcb2z5N0ML7QKd4
        9m9nNmVkK5IDFTIQZ/x81eDcwFVtbemNgaJL20I=
X-Google-Smtp-Source: APiQypIz8qwAgymwCk3n4j297oVIEEOi9vhAeVaBqMECjKK+hYBlvUznLJGvpWfhV/MNIBBuxOgb/UzEoBAcJOqgONE=
X-Received: by 2002:a05:6402:553:: with SMTP id i19mr8755481edx.42.1586873050553;
 Tue, 14 Apr 2020 07:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <2786b9598d534abf1f3d11357fa9b5f5@sslemail.net>
 <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <25b83b5245104a30977b042a886aa674@inspur.com> <CAF=yD-LAWc0POejfaB_xRW97BoVdLd6s6kjATyjDFBoK1aP-9Q@mail.gmail.com>
 <31e6d4edec0146e08cb3603ad6c2be4c@inspur.com> <CA+FuTSfG2J-5pu4kieXHm7d4giv4qXmwXBBHtJf0EcB1=83UOw@mail.gmail.com>
 <de32975979434430b914de00916bee95@inspur.com> <CA+FuTSe6vkWNq03zxP9Cbx4oj38sf1omeajh5fZRywouyADO6g@mail.gmail.com>
 <d81dbd7adfbe4bf3ba23649c5d3af59f@inspur.com> <CA+FuTScQfrHFdYYuwB6kWezPLCxs5dQH-hk7Vt9D4SQLzcbLXg@mail.gmail.com>
 <934640b05d7f46848ba2636fcc0b1e34@inspur.com> <CA+FuTSf5sUxoNTSurptYAq9UGVoDAxPRLHrKHmT0r-QBm=wRmw@mail.gmail.com>
 <9380edd337474a96ad427cc2a2256e5f@inspur.com>
In-Reply-To: <9380edd337474a96ad427cc2a2256e5f@inspur.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 14 Apr 2020 10:03:34 -0400
Message-ID: <CAF=yD-JiwR1e-QhWPQ8BmmYYEWs+N94O3fpqE4V-DPKC8iEFrg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFt2Z2VyLmtlcm5lbC5vcmfku6Plj5FdUmU6IFt2Z2VyLmtlcm5lbC5vcmfku6M=?=
        =?UTF-8?B?5Y+RXVJlOiBbdmdlci5rZXJuZWwub3Jn5LujIOWPkV1SZTogW1BBVENIIG5ldC1uZXh0XSBuZXQvIHBh?=
        =?UTF-8?B?Y2tldDogZml4IFRQQUNLRVRfVjMgcGVyZm9ybSBhbmNlIGlzc3VlIGluIGNhc2Ugb2YgVFNP?=
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>
Cc:     "yang_y_yi@163.com" <yang_y_yi@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "u9012063@gmail.com" <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > iperf3 test result
> > > -----------------------
> > > [yangyi@localhost ovs-master]$ sudo ../run-iperf3.sh
> > > iperf3: no process found
> > > Connecting to host 10.15.1.3, port 5201 [  4] local 10.15.1.2 port
> > > 44976 connected to 10.15.1.3 port 5201
> > > [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
> > > [  4]   0.00-10.00  sec  19.6 GBytes  16.8 Gbits/sec  106586    307 K=
Bytes
> > > [  4]  10.00-20.00  sec  19.5 GBytes  16.7 Gbits/sec  104625    215 K=
Bytes
> > > [  4]  20.00-30.00  sec  20.0 GBytes  17.2 Gbits/sec  106962    301 K=
Bytes
> >
> > Thanks for the detailed info.
> >
> > So there is more going on there than a simple network tap. veth, which =
calls netif_rx and thus schedules delivery with a napi after a softirq (twi=
ce), tpacket for recv + send + ovs processing. And this is a single flow, s=
o more sensitive to batching, drops and interrupt moderation than a workloa=
d of many flows.
> >
> > If anything, I would expect the ACKs on the return path to be the more =
likely cause for concern, as they are even less likely to fill a block befo=
re the timer. The return path is a separate packet socket?
> >
> > With initial small window size, I guess it might be possible for the en=
tire window to be in transit. And as no follow-up data will arrive, this wa=
its for the timeout. But at 3Gbps that is no longer the case.
> > Again, the timeout is intrinsic to TPACKET_V3. If that is unacceptable,=
 then TPACKET_V2 is a more logical choice. Here also in relation to timely =
ACK responses.
> >
> > Other users of TPACKET_V3 may be using fewer blocks of larger size. A c=
hange to retire blocks after 1 gso packet will negatively affect their work=
loads. At the very least this should be an optional feature, similar to how=
 I suggested converting to micro seconds.
> >
> > [Yi Yang] My iperf3 test is TCP socket, return path is same socket as f=
orward path. BTW this patch will retire current block only if vnet header i=
s in packets, I don't know what else use cases will use vnet header except =
our user scenario. In addition, I also have more conditions to limit this, =
but it impacts on performance. I'll try if V2 can fix our issue, this will =
be only one way to fix our issue if not.
> >
>
> Thanks. Also interesting might be a short packet trace of packet arrival =
on the bond device ports, taken at the steady state of 3 Gbps.
> To observe when inter-arrival time exceeds the 167 usec mean. Also inform=
ative would be to learn whether when retiring a block using your patch, tha=
t block also holds one or more ACK packets along with the GSO packet. As th=
eir delay might be the true source of throttling the sender.
>
> I think we need to understand the underlying problem better to implement =
a robust fix that works for a variety of configurations, and does not causi=
ng accidental regressions. The current patch works for your setup, but I'm =
afraid that it might paper over the real issue.
>
> It is a peculiar aspect of TPACKET_V3 that blocks are retired not when a =
packet is written that fills them, but when the next packet arrives and can=
not find room. Again, at sustained rate that delay should be immaterial. Bu=
t it might be okay to measure remaining space after write and decide to ret=
ire if below some watermark. I would prefer that watermark to be a ratio of=
 block size rather than whether the packet is gso or not.
>
> [Yi Yang] Sorry for late reply, I missed this email. I did do timing for =
every received frames, time interval is highly dynamic, I can't find any va=
luable clues, but I did find TCP ACK frames have big impact on performance,=
 which are some small frames (size is not more than 100), in TPACKET_V3 cas=
e, a block will have a bunch of such TCP ACK frames, so these ACK frames ar=
en't received and sent back to the receiver in time. I tried TPACKET_V2, it=
s performance is beyond I expect, I tried it in kernel 5.5.9, its performan=
ce is better than this patch, about 11Gbps, I also tried kernel 4.15.0 (fro=
m Ubuntu, it actually cherry picked many fixed patches from upstream, so is=
n't official 4.15.0), its performance is about 14Gbps, worse than this patc=
h (it is 17Gbps), so obviously the performance is kernel-related, platform =
related. In non-pmd case (i.e. sender and receiver are one thread and use t=
he same CPU), TPACKET_V2 is much better then recvmmsg&sendmmsg. We decide t=
o use TPACKET_V2 for TSO. But we don't know how we can reach higher perform=
ance than 14Gbps, it looks like tpacket_v2/v3's cache flush operation has s=
ide effect on performance (especially once flush per frame for TPACKET_V2)

Kernel 5.5.9 with TPACKET_V2 is better than this patch at 11 Gbps, but
Ubuntu 4.15.0 is worse that this patch at 14 Gbps (this patch is 17)?

How did you arrive at the conclusion that the cache flush operation is
the main bottleneck?

Good to hear that you verified that a main issue is the ACK delay.

Instead of packet sockets, you could also take a look at AF_XDP. There
seems to be documentation on how to deploy it with OVS.
