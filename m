Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C8546C3C
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349436AbiFJSVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiFJSVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:21:18 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045E9A5AB1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:21:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id c30so13867892ljr.9
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X9snqEMH/Ix6Dli1RP50OG94L6ccIMvYVQKbL6sOtAw=;
        b=f+jgp7E7S9ANufp44+Ow9tf3HKLh0tJjTrsCy4BlATa9Gu4Penj5a4XnbZOwzNDsL2
         wyvFice2qNSvnZo/xVkC7t3TMsJuHJIAl8oJVohlWCb7xu9yW74m8cYlivD5BQURRyLf
         AuR81xBsCeI7/k/YQd8GY/YmL7G3lHc8/GB+xb50b7B3AczPnTBqZcxelduvNRW4jEdC
         L5i4BMXrYNqNFp6hIjQ1ilfnyDQe24a1cohEAyrmlZOqI+9PYm9UVc1nkE8DX0LaJ9Sa
         NPAl5YnTs02o5CYtjmvoV1Bis+a0C5xIGZALbxrFDCZhZfF6POph3NXfK+WtqrAhkuAa
         7gAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X9snqEMH/Ix6Dli1RP50OG94L6ccIMvYVQKbL6sOtAw=;
        b=I/vO9fbZxLRsZ6sf6OJGBVsYYTNZsc84XeEf1dv3LNsZXZ3Dn1CiRkyayY757Yomo7
         0q2tJHPE311bPmILDD4Go1BdHga/VoDbd9tBThKP0L0IRkR0v1KZx9/FcP3B08ZyzO0p
         NmFMyA8oSFGP34n3IQ3DMx8RqWfcQ5vefXQIaMXpTrMWHyEBvgbr8fw2/sWPi4L+FNhD
         fv9vCyO24jmivPTSEO8sFSxFYOcNO3NzO3skUJoEWRnnk1plvXrx+DWSl9YEbHZRjnOk
         W4u72rFOwRgs/X+/TzEyXHrOJGP3jS5CWrNgbHCq4J1LKdJ3XEOqSaLgKTo4YOj8jp+8
         F2Pg==
X-Gm-Message-State: AOAM53198XZpO2Mga9tfd5uKhJkY5JObWyG9zyzgqn6dEgeU45r+L0p5
        yevaC9IYcv0s5CzgfrZSckeeaQwHu6DSW4lOzD4TyO19MdVjyA==
X-Google-Smtp-Source: ABdhPJy5jObSqH1LJzpnVjYFBkgQIsUppxjo00fJh8uVp75EpEt+fksSO1g5RkteBZM5zlnGh57hOSFU09sd/g7QCt8=
X-Received: by 2002:a2e:83c9:0:b0:24d:a95d:7b7a with SMTP id
 s9-20020a2e83c9000000b0024da95d7b7amr63485268ljh.254.1654885275121; Fri, 10
 Jun 2022 11:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAMJ=MEcPzkBLynL7tpjdv0TCRA=Cmy13e7wmFXrr-+dOVcshKA@mail.gmail.com>
 <f0f30591-f503-ae7c-9293-35cca4ceec84@gmail.com> <CAMJ=MEdctBNSihixym1ZO9RVaCa_FpTQ8e4xFukz3eN8F1P8bQ@mail.gmail.com>
 <13735ebc-fc54-22ff-21a1-da1895a74446@gmail.com>
In-Reply-To: <13735ebc-fc54-22ff-21a1-da1895a74446@gmail.com>
From:   Ronny Meeus <ronny.meeus@gmail.com>
Date:   Fri, 10 Jun 2022 20:21:03 +0200
Message-ID: <CAMJ=MEdP0eYVEUT+6LS7O8Mj5NMXzdOP_gfRtsc8_JubV+7oOA@mail.gmail.com>
Subject: Re: TCP socket send return EAGAIN unexpectedly when sending small fragments
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Op vr 10 jun. 2022 om 19:47 schreef Eric Dumazet <eric.dumazet@gmail.com>:
>
>
> On 6/10/22 08:16, Ronny Meeus wrote:
> > Op vr 10 jun. 2022 om 16:21 schreef Eric Dumazet <erdnetdev@gmail.com>:
> >>
> >> On 6/10/22 05:48, Ronny Meeus wrote:
> >>> Hello
> >>>
> >>> I have a small test application written in C that creates a local (in
> >>> process) TCP channel via loopback.
> >>> (kernel version is 3.10.0 but the same issue is also seen for example
> >>> on a 4.9 kernel).
> >>>
> >>> On the client side, an SO_SNDBUF of 5Kb is configured (which is
> >>> doubled by the kernel) while on the server side the default size is
> >>> used.
> >>> Both client and server side are running in non-blocking mode.
> >>>
> >>> The server side is not reading its socket so all data is simply queued
> >>> in the socket's receive buffer.
> >>> On the client side, the client is writing data into the socket in a
> >>> loop until the write returns an error (EAGAIN in this case).
> >>>
> >>> Depending on the size of data I send on this socket, I get the EAGAIN
> >>> on the client side already after a small number of messages.
> >>> For example when sending 106 byte messages, I see the first EAGAIN
> >>> after 21 write calls:
> >>> # ./tcp_client_server 106
> >>> using data size 106
> >>> client send buffer size 5000
> >>> client socket snd_buf: 10000
> >>> ERRNO = 11 count=21
> >>>
> >>> The same is observed for all sizes smaller than or equal to 107 bytes.
> >>>
> >>> When getting the socket stats using ss I see all data (2226b) pending
> >>> in the socket on the server side:
> >>> # ss -tmi  | grep -i X11 -A 1
> >>> ESTAB      0      0      127.0.0.1:59792                127.0.0.1:x11
> >>> skmem:(r0,rb1061296,t0,tb10000,f0,w0,o0,bl0,d0) cubic wscale:7,7
> >>> rto:202 rtt:1.276/2.504 mss:21888 rcvmss:536 advmss:65483 cwnd:10
> >>> bytes_acked:2227 segs_out:24 segs_in:18 send 1372.3Mbps lastsnd:3883
> >>> lastrcv:771546999 lastack:3883 pacing_rate 2744.3Mbps retrans:0/1
> >>> rcv_space:43690
> >>> --
> >>> ESTAB      2226   0      127.0.0.1:x11
> >>> 127.0.0.1:59792
> >>> skmem:(r4608,rb1061488,t0,tb2626560,f3584,w0,o0,bl0,d1) cubic
> >>> wscale:7,7 rto:200 ato:40 mss:21888 rcvmss:536 advmss:65483 cwnd:10
> >>> bytes_received:2226 segs_out:17 segs_in:24 lastsnd:3893 lastrcv:3893
> >>> lastack:3883 rcv_space:43690
> >>>
> >>>
> >>> When sending larger messages, the EAGAIN only is seen after 2116 writes.
> >>> # ./tcp_client_server 108
> >>> using data size 108
> >>> client send buffer size 5000
> >>> client socket snd_buf: 10000
> >>> ERRNO = 11 count=2116
> >>>
> >>> Again, the ss shows all data being present on the server side (108 *
> >>> 2116 = 228528)
> >>> ESTAB      228528 0      127.0.0.1:x11
> >>> 127.0.0.1:59830
> >>> skmem:(r976896,rb1061488,t0,tb2626560,f2048,w0,o0,bl0,d1) cubic
> >>> wscale:7,7 rto:200 ato:80 mss:21888 rcvmss:536 advmss:65483 cwnd:10
> >>> bytes_received:228528 segs_out:436 segs_in:2119 lastsnd:3615
> >>> lastrcv:3606 lastack:3596 rcv_rtt:1 rcv_space:43690
> >>> --
> >>> ESTAB      0      0      127.0.0.1:59830                127.0.0.1:x11
> >>> skmem:(r0,rb1061296,t0,tb10000,f0,w0,o0,bl0,d0) cubic wscale:7,7
> >>> rto:206 rtt:5.016/9.996 mss:21888 rcvmss:536 advmss:65483 cwnd:10
> >>> bytes_acked:228529 segs_out:2119 segs_in:437 send 349.1Mbps
> >>> lastsnd:3596 lastrcv:771704718 lastack:3566 pacing_rate 698.1Mbps
> >>> retrans:0/1 rcv_space:43690
> >>>
> >>>
> >>>
> >>> When I enlarge the SNDBUF on the client side to for example 10K, I see
> >>> that more messages can be sent:
> >>> # ./tcp_client_server 106 10000
> >>> using data size 106
> >>> client send buffer size 10000
> >>> client socket snd_buf: 20000
> >>> ERRNO = 11 count=1291
> >>>
> >>> I also captured the packets on the interface using wireshark and it
> >>> looks like the error is returned after the TCP layer has done a
> >>> retransmit (after 10ms) of the last packet sent on the connection.
> >>>
> >>> 10:12:38.186451 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1165:1265, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186461 IP localhost.etlservicemgr > localhost.48470: Flags
> >>> [.], ack 1265, win 342, options [nop,nop,TS val 593860562 ecr
> >>> 593860562], length 0
> >>> 10:12:38.186478 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1265:1365, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186488 IP localhost.etlservicemgr > localhost.48470: Flags
> >>> [.], ack 1365, win 342, options [nop,nop,TS val 593860562 ecr
> >>> 593860562], length 0
> >>> 10:12:38.186505 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1365:1465, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186516 IP localhost.etlservicemgr > localhost.48470: Flags
> >>> [.], ack 1465, win 342, options [nop,nop,TS val 593860562 ecr
> >>> 593860562], length 0
> >>> 10:12:38.186533 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1465:1565, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186543 IP localhost.etlservicemgr > localhost.48470: Flags
> >>> [.], ack 1565, win 342, options [nop,nop,TS val 593860562 ecr
> >>> 593860562], length 0
> >>> 10:12:38.186560 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1565:1665, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186578 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1665:1765, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186595 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1765:1865, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186615 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1865:1965, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.186632 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1965:2065, ack 165, win 342, options [nop,nop,TS val
> >>> 593860562 ecr 593860562], length 100
> >>> 10:12:38.196064 IP localhost.48470 > localhost.etlservicemgr: Flags
> >>> [P.], seq 1965:2065, ack 165, win 342, options [nop,nop,TS val
> >>> 593860572 ecr 593860562], length 100
> >>> 10:12:38.196128 IP localhost.etlservicemgr > localhost.48470: Flags
> >>> [.], ack 2065, win 342, options [nop,nop,TS val 593860572 ecr
> >>> 593860562,nop,nop,sack 1 {1965:2065}], length 0
> >>>
> >>> Now my question is: how is it possible that I can only send 21
> >>> messages of 106 bytes before I see the EAGAIN while when sending
> >>> larger messages I can send 2K+ messages.
> >>
> >> This is because kernel tracks kernel memory usage.
> >>
> >> Small packets incur more overhead.
> >>
> >> The doubling of SO_SNDBUF user value, is an heuristic based on the fact
> >> the kernel
> >>
> >> uses a 2x overhead estimation,
> >>
> >> while effective overhead can vary from ~1.001x to ~768x depending on
> >> number of bytes per skb.
> >>
> > Hi Eric,
> >
> > thanks for the feedback but it is not completely clear to me.
> >
> > The small SNDBUF is on the client side and a large part of the data
> > has already ACKed by the receiving side.
> > Only the last 5 or 6 messages are waiting to be ACKed.
> > So I would expect that the biggest part of the overhead is located on
> > the receiving side where there is sufficient memory space (default
> > RCVBUF size is used).
> >
> > If the 5 queued packets on the sending side would cause the EAGAIN
> > issue, the real question maybe is why the receiving side is not
> > sending the ACK within the 10ms while for earlier messages the ACK is
> > sent much sooner.
>
>
> delayed acks on receiver, when receiving small packet(s)
>

Great feedback.

>
> >
> > Do you have any clue which kernel function does generate this EAGAIN?
> > And what would be the correct solution to this problem?
>
>
> I do not really see what is the problem you have.

The actual problem I have is that the application behavior is
completely different depending on the message size.
I created the test application to be able to investigate something we
see in the real-application and that is that libevent either queues a
lot or does not queue anything.
Libevent starts to queue data as soon as it sees the EAGAIN error.

>
> Perhaps you should not set SO_SNDBUF, and let the kernel decide (auto
> tune, and auto cork)
>

I think this might indeed be a solution. Just remove the SO_SNDBUF, or
at least use a much larger value.

> >
> > Best regards,
> > Ronny
> >
