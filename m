Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB935345FF
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbiEYVsY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 May 2022 17:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343710AbiEYVsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 17:48:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49B91B82EC
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 14:48:19 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-274-hR3S7X-LPgW-O2LdYns0Jw-1; Wed, 25 May 2022 22:48:16 +0100
X-MC-Unique: hR3S7X-LPgW-O2LdYns0Jw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 25 May 2022 22:48:15 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 25 May 2022 22:48:15 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>
CC:     'Pavan Chebbi' <pavan.chebbi@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: RE: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKwAC24IAAAoYsMAABXOQgAASBiKAAAHW4wAABHST0AACH9sAAAKZZrD///3FgP//7fNg//44TdD/98XoIAIPG/gA//+b67D//PxWwP/5eKuA//KIPLA=
Date:   Wed, 25 May 2022 21:48:15 +0000
Message-ID: <4ff290b53a3945669f2057eddd8441b2@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
        <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
        <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
        <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
        <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
        <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
        <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
        <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
        <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
        <CALs4sv2M+9N1joECMQrOGKHQ_YjMqzeF1gPD_OBQ2_r+SJwOwQ@mail.gmail.com>
        <1bc5053ef6f349989b42117eda7d2515@AcuMS.aculab.com>
        <ae631eefb45947ac84cfe0468d0b7508@AcuMS.aculab.com>
        <9119f62fadaa4342a34882cac835c8b0@AcuMS.aculab.com>
        <CALs4sv13Y7CoMvrYm2c58vP6FKyK+_qrSp2UBCv0MURTAkv8hg@mail.gmail.com>
        <71de7bfbb0854449bce509d67e9cf58c@AcuMS.aculab.com>
        <3bbe3c3762c44ffa932101092117853c@AcuMS.aculab.com>
 <20220525085647.6dfb7ed0@kernel.org>
In-Reply-To: <20220525085647.6dfb7ed0@kernel.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski
> Sent: 25 May 2022 16:57
> 
> On Wed, 25 May 2022 07:28:42 +0000 David Laight wrote:
> > > As the trace below shows I think the underlying problem
> > > is that the napi callbacks aren't being made in a timely manner.
> >
> > Further investigations have shown that this is actually
> > a generic problem with the way napi callbacks are called
> > from the softint handler.
> >
> > The underlying problem is the effect of this code
> > in __do_softirq().
> >
> >         pending = local_softirq_pending();
> >         if (pending) {
> >                 if (time_before(jiffies, end) && !need_resched() &&
> >                     --max_restart)
> >                         goto restart;
> >
> >                 wakeup_softirqd();
> >         }
> >
> > The napi processing can loop through here and needs to do
> > the 'goto restart' - not doing so will drop packets.
> > The need_resched() test is particularly troublesome.
> > I've also had to increase the limit for 'max_restart' from
> > its (hard coded) 10 to 1000 (100 isn't enough).
> > I'm not sure whether I'm hitting the jiffies limit,
> > but that is hard coded at 2.
> >
> > I'm going to start another thread.
> 
> If you share the core between the application and NAPI try using prefer
> busy polling (SO_PREFER_BUSY_POLL), and manage polling from user space.
> If you have separate cores use threaded NAPI and isolate the core
> running NAPI or give it high prio.

The application is looking at 10000 UDP sockets each of which
typically has 1 packet every 20ms (but there might be an extra
one).
About the only way to handle this is with an array of 100 epoll
fd each of which has 100 UDP sockets.
Every 10ms (we do our RTP in 10ms epochs) each application thread
picks the next epoll fd (using atomic_in_ov()) and then reads all
the 'ready' sockets.
The application can't afford so take a mutex in any hot path
because mutex contention can happen while the process is 'stolen'
by a hardware interrupt and/or softint.
That then stalls all the waiting application threads.

Even then I've got 35 application threads that call epoll_wait()
and recvfrom() and run at about 50% cpu.

The ethernet napi code is using about 50% of two cpu.
I'm using RPS to move the IP/UDP processing to other cpu.
(Manually avoiding the ones taking the hardware interrupts.)

> YMMV but I've spent more time than I'd like to admit looking at the
> softirq yielding conditions, they are hard to beat :(

I've spent a long time discovering it is one reason I'm losing
a lot of packets on a system with a reasonable amount of idle time.

> If you control
> the app much better use of your time to arrange busy poll or pin things.

Pinning things gets annoying.
I've been running the 'important' application threads under the
RT scheduler. This makes their cpu assignment very sticky.
So nearly as good a pinning but the scheduler decides where they go.

This afternoon I tried using threaded napi for the ethernet interface.
(Suggested by Eric.)
This can only really work if the threads run under the RT scheduler.
I can't see an easy way to do this, apart from:
  (cd /proc; for pid in [1-9]*; do
	comm=$(cat $pid/comm);
	[ "${comm#napi/}" != "$comm" ] && chrt --pid 50 $pid;
  done;)
Since I was only running 35 RT application threads the extra 5
napi ones is exactly one for each cpu and AFAICT they all run
on separate cpu.

With threaded napi (and RPS) I'm only seeing 250 (or so)
busy ethernet ring entries in the napi code - not the 1000+
I was getting with the default __do_softirq() code.
Similar to stopping the softint code falling back to its thread.
I'm still losing packets though (sometimes over 100/sec)
not sure if the hardware has no free ring buffers or
whether the switch is dropping some of them.

Apart from python (which needs pinning to a single cpu) I'm not
sure how much effect pinning a normal priority process to a
cpu has - unless you also pin more general processes away from
that cpu.
Running under the RT scheduler (provided you don't create too
many RT processes) sort of gives each one its own cpu while
allowing other processes to use the cpu when it is idle.
Straight forward pinning of processes doesn't do that.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

