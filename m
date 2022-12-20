Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD4651CD2
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 10:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiLTJHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 04:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLTJHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 04:07:15 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9B318367;
        Tue, 20 Dec 2022 01:07:13 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gh17so27663801ejb.6;
        Tue, 20 Dec 2022 01:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hizhlraO4kHOCEYm3J7nRb+ljc4URdDU1ZVYjL6Mn1k=;
        b=o3p4LW4Vvk6cU6zlvociiz9UFJt/5GHIZIGXCnP2XlSctycCyhWxDRbQyuogLpCnS4
         QX5kmLgtNbsDgOME6/5Y+Tik7pyudq7pLoMlw8R+BfQjpfLenuwn+rFRXqaZpaM4EA+T
         3laBcoQFcif80u7LkuvDkqJxgYXFzXOIoGJMnKzZr+klZ4nviFcle4suq8aBM2eyqEne
         ad3s28uzIJqnf6Vj/P2DkSKJji8Mgp39T9W0+dkwCAWhlv9/UtM1AsUoWb/TCZQL0WJx
         n5JduR8DJGIlqCypuM0gw2I7zs7Ynu7LsPrMVjrENv5pVKa+63UEJCmfwETazwYn1irC
         gVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hizhlraO4kHOCEYm3J7nRb+ljc4URdDU1ZVYjL6Mn1k=;
        b=RHFm79umGqmMcOliSvd5uLUlUNnfWqRntqjIbp17HghzSaFQnJhXyhBe0Lw1TASKJs
         xaoYTl8BmtMEokjJeGBR+9vrtxfmS2wdQhAq4D5pNWmNuyVPlvUuEmQCxbCraLCO0LKk
         XJxfN9jFlmP1yguL6cMeJhkHFo9RpG+e2J4rjX9+3gqbZEhR2Yi1Ebq6JiZ501b1v/Mj
         088PvPS25vxoIhcu8bMZtsFyuqqrrE4AzJsidQBQxWr8vyt1nDb1PasfLBaqGd2eAQw4
         zseKvqe3sK94uNNntzg5jQf8LG3qkg4mZ4go1GvChycajVZupKi9aHY3/yCzlIaWLAoy
         JsHA==
X-Gm-Message-State: ANoB5pm7KRp7TPFjtpo75ss6qo/M95VD3I488ZTikPxPJ1o/YKmGF+B+
        S65ZmYqkPS3Ns3sQMR1EDmJLcS4i24xEqzqZznQ=
X-Google-Smtp-Source: AA0mqf7tZggX8A3D9/epYuhbbq/7JCSYNIH1tVlMxMD9jL68M7wDUd57r1VVvSy9Ncsfob0PycwFvhLtkD5BMyoXpbs=
X-Received: by 2002:a17:906:6c91:b0:7c1:4c57:4726 with SMTP id
 s17-20020a1709066c9100b007c14c574726mr2961595ejr.488.1671527220968; Tue, 20
 Dec 2022 01:07:00 -0800 (PST)
MIME-Version: 1.0
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell> <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
 <Y5u4dA01y9RjjdAW@sbohrer-cf-dell> <CAJ8uoz1GKvoaM0DCo1Ki8q=LHR1cjrNC=1BK7chTKKW9Po5F5A@mail.gmail.com>
 <Y6EQjd5w9Dfmy8ko@sbohrer-cf-dell>
In-Reply-To: <Y6EQjd5w9Dfmy8ko@sbohrer-cf-dell>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 20 Dec 2022 10:06:48 +0100
Message-ID: <CAJ8uoz1D3WY=joXqMo80a5Vqx+3N=5YX6Lh=KC1=coM5zDb-dA@mail.gmail.com>
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

On Tue, Dec 20, 2022 at 2:32 AM Shawn Bohrer <sbohrer@cloudflare.com> wrote:
>
> On Fri, Dec 16, 2022 at 11:05:19AM +0100, Magnus Karlsson wrote:
> > To summarize, we are expecting this ordering:
> >
> > CPU 0 __xsk_rcv_zc()
> > CPU 0 __xsk_map_flush()
> > CPU 2 __xsk_rcv_zc()
> > CPU 2 __xsk_map_flush()
> >
> > But we are seeing this order:
> >
> > CPU 0 __xsk_rcv_zc()
> > CPU 2 __xsk_rcv_zc()
> > CPU 0 __xsk_map_flush()
> > CPU 2 __xsk_map_flush()
> >
> > Here is the veth NAPI poll loop:
> >
> > static int veth_poll(struct napi_struct *napi, int budget)
> > {
> >     struct veth_rq *rq =
> >     container_of(napi, struct veth_rq, xdp_napi);
> >     struct veth_stats stats = {};
> >     struct veth_xdp_tx_bq bq;
> >     int done;
> >
> >     bq.count = 0;
> >
> >     xdp_set_return_frame_no_direct();
> >     done = veth_xdp_rcv(rq, budget, &bq, &stats);
> >
> >     if (done < budget && napi_complete_done(napi, done)) {
> >         /* Write rx_notify_masked before reading ptr_ring */
> >        smp_store_mb(rq->rx_notify_masked, false);
> >        if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
> >            if (napi_schedule_prep(&rq->xdp_napi)) {
> >                WRITE_ONCE(rq->rx_notify_masked, true);
> >                __napi_schedule(&rq->xdp_napi);
> >             }
> >         }
> >     }
> >
> >     if (stats.xdp_tx > 0)
> >         veth_xdp_flush(rq, &bq);
> >     if (stats.xdp_redirect > 0)
> >         xdp_do_flush();
> >     xdp_clear_return_frame_no_direct();
> >
> >     return done;
> > }
> >
> > Something I have never seen before is that there is
> > napi_complete_done() and a __napi_schedule() before xdp_do_flush().
> > Let us check if this has something to do with it. So two suggestions
> > to be executed separately:
> >
> > * Put a probe at the __napi_schedule() above and check if it gets
> > triggered before this problem
> > * Move the "if (stats.xdp_redirect > 0) xdp_do_flush();" to just
> > before "if (done < budget && napi_complete_done(napi, done)) {"
> >
> > This might provide us some hints on what is going on.
>
> After staring at this code for way too long I finally made a
> breakthrough!  I could not understand how this race could occur when
> napi_poll() calls netpoll_poll_lock().  Here is netpoll_poll_lock():
>
> ```
>   static inline void *netpoll_poll_lock(struct napi_struct *napi)
>   {
>     struct net_device *dev = napi->dev;
>
>     if (dev && dev->npinfo) {
>       int owner = smp_processor_id();
>
>       while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
>         cpu_relax();
>
>       return napi;
>     }
>     return NULL;
>   }
> ```
> If dev or dev->npinfo are NULL then it doesn't acquire a lock at all!
> Adding some more trace points I see:
>
> ```
>   iperf2-1325    [002] ..s1. 264246.626880: __napi_poll: (__napi_poll+0x0/0x150) n=0xffff91c885bff000 poll_owner=-1 dev=0xffff91c881d4e000 npinfo=0x0
>   iperf2-1325    [002] d.Z1. 264246.626882: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x3b/0xc0) addr=0x1503100 len=0x42 xs=0xffff91c8bfe77000 fq=0xffff91c8c1a43f80 dev=0xffff91c881d4e000
>   iperf2-1325    [002] d.Z1. 264246.626883: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x42/0xc0) addr=0x1503100 len=0x42 xs=0xffff91c8bfe77000 fq=0xffff91c8c1a43f80 dev=0xffff91c881d4e000
>   iperf2-1325    [002] d.Z1. 264246.626884: xsk_flush: (__xsk_map_flush+0x32/0xb0) xs=0xffff91c8bfe77000
> ```
>
> Here you can see that poll_owner=-1 meaning the lock was never
> acquired because npinfo is NULL.  This means that the same veth rx
> queue can be napi_polled from multiple CPU and nothing stops it from
> running concurrently.  They all look like this, just most of the time
> there aren't concurrent napi_polls running for the same queue.  They
> do however move around CPUs as I explained earlier.
>
> I'll note that I've ran with your suggested change of moving
> xdp_do_flush() before napi_complete_done() all weekend and I have not
> reproduced the issue.  I don't know if that truly means the issue is
> fixed by that change or not.  I suspect it does fix the issue because
> it prevents the napi_struct from being scheduled again before the
> first poll has completed, and nap_schedule_prep() ensures that only
> one instance is ever running.

Thanks Shawn! Good news that the patch seems to fix the problem. To
me, napi_schedule_prep() makes sure that only one NAPI instance is
running. Netpoll is an optional feature and I do not even have it
compiled into my kernel. At least I do not have it defined in my
.config and I cannot find any netpoll symbols with a readelf command.
If netpoll is not used, I would suspect that npinfo == NULL. So to me,
it is still a mystery why this is happening.

To validate or disprove that there are two instances of the same napi
running, could you please put a probe in veth_poll() right after
veth_xdp_rcv() and one at xdp_do_flush() and dump the napi id in both
cases? And run the original code with the bug :-). It would be good to
know what exactly happens in the code between these points when this
bug occurs. Maybe we could do this by enabling the trace buffer and
dumping it when the bug occurs.

> If we think this is the correct fix I'll let it run for another day or
> two and prepare a patch.

There is one more advantage to this bug fix and that is performance.
By calling __xdp_map_flush() immediately after the receive function,
user space can start to work on the packets quicker so performance
will improve.

> Thanks,
> Shawn Bohrer
