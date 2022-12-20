Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB7652408
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiLTP7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLTP7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:59:45 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17676322;
        Tue, 20 Dec 2022 07:59:43 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id u19so30238840ejm.8;
        Tue, 20 Dec 2022 07:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fI/lW0aHJk0OikOsN818tfzOC/kgJ2mQGiUnD3zYHII=;
        b=YR2SCFq3h9BHWI6yB6I4PUGSDBmzh1cL0SUVeRYD3gUirF0o9S09A/QJ+X2JjEn9lF
         n7Xd7FrC2REIh/dxgneouYwbEZR0QcfvG8BgeuAJfS95PyjJfgNuLUMq7PwU7IkzjlRX
         p0h9rt0jrL3JySszv3kXipiLQh24D40jXUH00zpu+dQrMrESeIuJXTEb5PH5qD751AYu
         vbdpI7BDeMq2FZm/X20il4wgRlNJwEfoZOj9sZhALo/4Q31qLWPR3nPlKd60JDzP7vRe
         1wIBxGYXwNq1swGayeUbygESrf/nel20cubInkYKx8OlKO8PvAA/zngjBR9zlEohe09L
         tBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fI/lW0aHJk0OikOsN818tfzOC/kgJ2mQGiUnD3zYHII=;
        b=4cGCJlq+E428zmRHwm0FAU53Gy4PRT7Zt4ryON8GV4i+kKk08H0VfC0XiRQ53w7FwZ
         HPqGGDP2L9kvb2ZGD8YsgzSMAjz0oXyjExu6UtBPEzo7JewEXwneIRmegI07Ptvu5WT0
         70nrKdpdkJ66TwQZhwCcDONY90NXkmcXF+P2IVlRAPr2PLGNNiWAVnAinaLsbKHfjyaG
         +Kg/a0j2dKzX/RXjbaMShNbmcBoEOVtr16TyFjLrxfNXBdX594BdcRpl+VaHDeXpS92Y
         IStn3/IK/PXXoax3Zd8g4yhwXnMoMR8DGVgF0ZaJuWldo7SyEyjVoyoEEm4zzO4hDGHo
         TmtQ==
X-Gm-Message-State: AFqh2koRi2IbT0MQ5ISJkkwL/eyfdRU/i8R/OkqvoSgVMi0UTmXG1mNE
        jhsRiFjMAmQ6z0dqKMiqr9+dF9kBviuUWXSzzCcJnLmkpjM=
X-Google-Smtp-Source: AMrXdXuBTNIr7KCiWnbLWVn/ccVIAj6zT7EGt+uoCYcBs5ToXU+5dlCHbWR3/aCFP0bz7ZkqWw+lBAil4VxlkybelHs=
X-Received: by 2002:a17:906:b189:b0:828:7572:a6d5 with SMTP id
 w9-20020a170906b18900b008287572a6d5mr462390ejy.137.1671551982367; Tue, 20 Dec
 2022 07:59:42 -0800 (PST)
MIME-Version: 1.0
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell> <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
 <Y5u4dA01y9RjjdAW@sbohrer-cf-dell> <CAJ8uoz1GKvoaM0DCo1Ki8q=LHR1cjrNC=1BK7chTKKW9Po5F5A@mail.gmail.com>
 <Y6EQjd5w9Dfmy8ko@sbohrer-cf-dell> <CAJ8uoz1D3WY=joXqMo80a5Vqx+3N=5YX6Lh=KC1=coM5zDb-dA@mail.gmail.com>
 <Y6HUBWCytyebNnOx@sbohrer-cf-dell>
In-Reply-To: <Y6HUBWCytyebNnOx@sbohrer-cf-dell>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 20 Dec 2022 16:59:30 +0100
Message-ID: <CAJ8uoz3r=2jo0EwMz1iAsatR59qFKoLw4mcK7w+TpE387s_Y-g@mail.gmail.com>
Subject: Re: Possible race with xsk_flush
To:     Shawn Bohrer <sbohrer@cloudflare.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 4:26 PM Shawn Bohrer <sbohrer@cloudflare.com> wrote:
>
> On Tue, Dec 20, 2022 at 10:06:48AM +0100, Magnus Karlsson wrote:
> > On Tue, Dec 20, 2022 at 2:32 AM Shawn Bohrer <sbohrer@cloudflare.com> wrote:
> > >
> > > On Fri, Dec 16, 2022 at 11:05:19AM +0100, Magnus Karlsson wrote:
> > > > To summarize, we are expecting this ordering:
> > > >
> > > > CPU 0 __xsk_rcv_zc()
> > > > CPU 0 __xsk_map_flush()
> > > > CPU 2 __xsk_rcv_zc()
> > > > CPU 2 __xsk_map_flush()
> > > >
> > > > But we are seeing this order:
> > > >
> > > > CPU 0 __xsk_rcv_zc()
> > > > CPU 2 __xsk_rcv_zc()
> > > > CPU 0 __xsk_map_flush()
> > > > CPU 2 __xsk_map_flush()
> > > >
> > > > Here is the veth NAPI poll loop:
> > > >
> > > > static int veth_poll(struct napi_struct *napi, int budget)
> > > > {
> > > >     struct veth_rq *rq =
> > > >     container_of(napi, struct veth_rq, xdp_napi);
> > > >     struct veth_stats stats = {};
> > > >     struct veth_xdp_tx_bq bq;
> > > >     int done;
> > > >
> > > >     bq.count = 0;
> > > >
> > > >     xdp_set_return_frame_no_direct();
> > > >     done = veth_xdp_rcv(rq, budget, &bq, &stats);
> > > >
> > > >     if (done < budget && napi_complete_done(napi, done)) {
> > > >         /* Write rx_notify_masked before reading ptr_ring */
> > > >        smp_store_mb(rq->rx_notify_masked, false);
> > > >        if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
> > > >            if (napi_schedule_prep(&rq->xdp_napi)) {
> > > >                WRITE_ONCE(rq->rx_notify_masked, true);
> > > >                __napi_schedule(&rq->xdp_napi);
> > > >             }
> > > >         }
> > > >     }
> > > >
> > > >     if (stats.xdp_tx > 0)
> > > >         veth_xdp_flush(rq, &bq);
> > > >     if (stats.xdp_redirect > 0)
> > > >         xdp_do_flush();
> > > >     xdp_clear_return_frame_no_direct();
> > > >
> > > >     return done;
> > > > }
> > > >
> > > > Something I have never seen before is that there is
> > > > napi_complete_done() and a __napi_schedule() before xdp_do_flush().
> > > > Let us check if this has something to do with it. So two suggestions
> > > > to be executed separately:
> > > >
> > > > * Put a probe at the __napi_schedule() above and check if it gets
> > > > triggered before this problem
> > > > * Move the "if (stats.xdp_redirect > 0) xdp_do_flush();" to just
> > > > before "if (done < budget && napi_complete_done(napi, done)) {"
> > > >
> > > > This might provide us some hints on what is going on.
> > >
> > > After staring at this code for way too long I finally made a
> > > breakthrough!  I could not understand how this race could occur when
> > > napi_poll() calls netpoll_poll_lock().  Here is netpoll_poll_lock():
> > >
> > > ```
> > >   static inline void *netpoll_poll_lock(struct napi_struct *napi)
> > >   {
> > >     struct net_device *dev = napi->dev;
> > >
> > >     if (dev && dev->npinfo) {
> > >       int owner = smp_processor_id();
> > >
> > >       while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
> > >         cpu_relax();
> > >
> > >       return napi;
> > >     }
> > >     return NULL;
> > >   }
> > > ```
> > > If dev or dev->npinfo are NULL then it doesn't acquire a lock at all!
> > > Adding some more trace points I see:
> > >
> > > ```
> > >   iperf2-1325    [002] ..s1. 264246.626880: __napi_poll: (__napi_poll+0x0/0x150) n=0xffff91c885bff000 poll_owner=-1 dev=0xffff91c881d4e000 npinfo=0x0
> > >   iperf2-1325    [002] d.Z1. 264246.626882: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x3b/0xc0) addr=0x1503100 len=0x42 xs=0xffff91c8bfe77000 fq=0xffff91c8c1a43f80 dev=0xffff91c881d4e000
> > >   iperf2-1325    [002] d.Z1. 264246.626883: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x42/0xc0) addr=0x1503100 len=0x42 xs=0xffff91c8bfe77000 fq=0xffff91c8c1a43f80 dev=0xffff91c881d4e000
> > >   iperf2-1325    [002] d.Z1. 264246.626884: xsk_flush: (__xsk_map_flush+0x32/0xb0) xs=0xffff91c8bfe77000
> > > ```
> > >
> > > Here you can see that poll_owner=-1 meaning the lock was never
> > > acquired because npinfo is NULL.  This means that the same veth rx
> > > queue can be napi_polled from multiple CPU and nothing stops it from
> > > running concurrently.  They all look like this, just most of the time
> > > there aren't concurrent napi_polls running for the same queue.  They
> > > do however move around CPUs as I explained earlier.
> > >
> > > I'll note that I've ran with your suggested change of moving
> > > xdp_do_flush() before napi_complete_done() all weekend and I have not
> > > reproduced the issue.  I don't know if that truly means the issue is
> > > fixed by that change or not.  I suspect it does fix the issue because
> > > it prevents the napi_struct from being scheduled again before the
> > > first poll has completed, and nap_schedule_prep() ensures that only
> > > one instance is ever running.
> >
> > Thanks Shawn! Good news that the patch seems to fix the problem. To
> > me, napi_schedule_prep() makes sure that only one NAPI instance is
> > running. Netpoll is an optional feature and I do not even have it
> > compiled into my kernel. At least I do not have it defined in my
> > .config and I cannot find any netpoll symbols with a readelf command.
> > If netpoll is not used, I would suspect that npinfo == NULL. So to me,
> > it is still a mystery why this is happening.
>
> Oh I don't think it is a mystery anymore.  The napi_complete_done()
> signals that this instance of of the napi_poll is complete.  As you
> said nap_schedule_prep() checks to ensure that only one instance of
> napi_poll is running at a time, but we just indicated it was done with
> napi_complete_done().  This allows this CPU or more importantly any
> other CPU to reschedule napi polling for this receive queue, but we
> haven't called xdp_do_flush() yet so the flush can race.  I'll note
> that the napi_schedule_prep()/__napi_schedule() in veth_poll really
> isn't the problem since it will schedule itself back on the same CPU.
> The problem is simply that another CPU is free to call
> napi_scheulde_prep()/__napi_schedule() in that window after
> napi_complete_done() and before xdp_do_flush().  The veth driver can
> schedule a napi_poll from the transmit path which is what starts the
> poll on a second CPU.

Bingo! Would you like to prepare a patch or would you like me to do
it? This has been broken since the support was put in veth in 4.19.

> I was simply blinded by that stupid netpoll_poll_lock() but it is
> completely unnecessary.
>
> > To validate or disprove that there are two instances of the same napi
> > running, could you please put a probe in veth_poll() right after
> > veth_xdp_rcv() and one at xdp_do_flush() and dump the napi id in both
> > cases? And run the original code with the bug :-). It would be good to
> > know what exactly happens in the code between these points when this
> > bug occurs. Maybe we could do this by enabling the trace buffer and
> > dumping it when the bug occurs.
>
> The two instances that race are definitely different napi_polls, the
> second one is scheduled from the veth transmit path.
>
> > > If we think this is the correct fix I'll let it run for another day or
> > > two and prepare a patch.
> >
> > There is one more advantage to this bug fix and that is performance.
> > By calling __xdp_map_flush() immediately after the receive function,
> > user space can start to work on the packets quicker so performance
> > will improve.
>
> Yes definitely.
>
> Thanks,
> Shawn Bohrer
