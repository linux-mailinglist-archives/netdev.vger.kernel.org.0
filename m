Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEAD64E91F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 11:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiLPKFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 05:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiLPKFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 05:05:34 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F8E49B79;
        Fri, 16 Dec 2022 02:05:33 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ud5so4991631ejc.4;
        Fri, 16 Dec 2022 02:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IXhzGmnlQELt4azv8KqPYzbySAS1vW2YM0qHKEAcOLo=;
        b=XyzAnJPTZPHLYP3qkvhOoud5DEsfYZ6Ph7qAugG2yt8iMyet9agy4Yk5kc4oTK7Xlr
         meNMPa2cI2a+yAa6Nok0FCj/cc12LstlZweHKjkUs+/jbhTkOvR55DNdulYp4/D7JBTj
         6r9KjsiHNJRWjA6QRyz9dC+65ogXgCi/Fv4i31RI6MRwa24X5DZDYDyCFSQ2s0IiOUyI
         i2OuC50Wr+jEYYsyYywrSj8bme+hnfL4zy7dKjw7am8L+HWNkKji96gLItDR+UPcL252
         Y2Bz6FDRW7Keb0y1ZWFymJEPPfyjJI5ln3kCQVr8WzCGh3XrvqLTjJe7dN1/p0x2Mf5w
         vs0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXhzGmnlQELt4azv8KqPYzbySAS1vW2YM0qHKEAcOLo=;
        b=66gAADE2Ba9AVi15brRJYOCmlrqgqbzaUZiqa4QcWwgECFVn7i6N4cHvezXBqWkznQ
         l2InhoM098n78QXdmEPTNo33/cYgOSGU7N/0h93k74zGWjT3kTEfUrJPWy/p+/Ib0M4I
         Lt871+KyAaV/dKUj2y3H/J+WHQg5BOIC+1C7bkyDtalSWdzWPpAUXVSxjNH/hCm2RkEr
         rLbVcFQAl9r9xFRpumrJsO/afqSgm388+uDEVZ5feYCY27kyo3Wy7H2WCwQZnqM8jKWh
         iQjRpASONJbGdDvWDECtT0LspJYyDCHvOtf0HWRJa5NTzNFd+wbPQtOHgCiuZ323K936
         qhaQ==
X-Gm-Message-State: ANoB5pl+XEXutUefC0GBSXuQ4JGGmTxG1nyPGTHFREBy7J7w4p8Fq1L1
        YoRdgvSrFuRDZAz3vUYs6guESEsAowbV+zuiBWB3Kl/3cfZqERc1
X-Google-Smtp-Source: AA0mqf6q/pClbSK8lHlHtqucyXa4LcD5yAVTp+1KvpkYow5d30J20yYBwz8/b/pBjDikNvFG7uvGxdHyMhcmoGdWgmw=
X-Received: by 2002:a17:906:6b97:b0:7c0:fe68:35e9 with SMTP id
 l23-20020a1709066b9700b007c0fe6835e9mr14029559ejr.49.1671185131649; Fri, 16
 Dec 2022 02:05:31 -0800 (PST)
MIME-Version: 1.0
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell> <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
 <Y5u4dA01y9RjjdAW@sbohrer-cf-dell>
In-Reply-To: <Y5u4dA01y9RjjdAW@sbohrer-cf-dell>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 16 Dec 2022 11:05:19 +0100
Message-ID: <CAJ8uoz1GKvoaM0DCo1Ki8q=LHR1cjrNC=1BK7chTKKW9Po5F5A@mail.gmail.com>
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

On Fri, Dec 16, 2022 at 1:15 AM Shawn Bohrer <sbohrer@cloudflare.com> wrote:
>
> On Thu, Dec 15, 2022 at 11:22:05AM +0100, Magnus Karlsson wrote:
> > Thanks Shawn for your detailed bug report. The rings between user
> > space and kernel space are single-producer/single-consumer, so in your
> > case when both CPU0 and CPU2 are working on the fill ring and the Rx
> > ring at the same time, this will indeed produce races. The intended
> > design principle to protect against this is that only one NAPI context
> > can access any given ring at any point in time and that the NAPI logic
> > should prevent two instances of the same NAPI instance from running at
> > the same time. So if that is not true for some reason, we would get a
> > race like this. Another option is that one of the CPUs should really
> > process another fill ring instead of the same.
> >
> > Do you see the second socket being worked on when this happens?
> >
> > Could you please share how you set up the two AF_XDP sockets?
>
> Alex Forster sent more details on the configuration but just to
> reiterate there are actually 8 AF_XDP sockets in this test setup.
> There are two veth interfaces and each interface has four receive
> queues.  We create one socket per interface/queue pair.  Our XDP
> program redirects each packet to the correct AF_XDP socket based on
> the queue number.
>
> Yes there is often activity on other sockets near the time when the
> bug occurs.  This is why I'm printing xs/fq, the socket address and
> fill queue address, and printing the ingress/egress device name and
> queue number in my prints.  This allows to match up the user space and
> kernel space prints.  Additionally we are using a shared UMEM so
> descriptors could move around between sockets though I've tried to
> minimize this and in every case I've seen so far the mystery
> descriptor was last used on the same socket and has also been in the
> fill queue just not next in line.
>
> > Are you using XDP_DRV mode in your tests?
> >
> > > A couple more notes:
> > > * The ftrace print order and timestamps seem to indicate that the CPU
> > >   2 napi_poll is running before the CPU 0 xsk_flush().  I don't know
> > >   if these timestamps can be trusted but it does imply that maybe this
> > >   can race as I described.  I've triggered this twice with xsk_flush
> > >   probes and both show the order above.
> > > * In the 3 times I've triggered this it has occurred right when the
> > >   softirq processing switches CPUs
> >
> > This is interesting. Could you check, in some way, if you only have
> > one core working on the fill ring before the softirq switching and
> > then after that you have two? And if you have two, is that period
> > transient?
>
> I think what you are asking is why does the softirq processing switch
> CPUs?  There is still a lot I don't fully understand here but I've
> tried to understand this, if only to try to make it happen more
> frequently and make this easier to reproduce.
>
> In this test setup there is no hardware IRQ.  iperf2 sends the packet
> and the CPU where iperf is running runs the veth softirq.  I'm not
> sure how it picks which veth receive queue receives the packets, but
> they end up distributed across the veth qeueus.  Additionally
> __veth_xdp_flush() calls __napi_schedule().  This is called from
> veth_xdp_xmit() which I think means that transmitting packets from
> AF_XDP also schedules the softirq on the current CPU for that veth
> queue.  What I definitely see is that if I pin both iperf and my
> application to a single CPU all softirqs of all queues run on that
> single CPU.  If I pin iperf2 to one core and my application to another
> core I get softirqs for all veth queues on both cores.

To summarize, we are expecting this ordering:

CPU 0 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_rcv_zc()
CPU 2 __xsk_map_flush()

But we are seeing this order:

CPU 0 __xsk_rcv_zc()
CPU 2 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_map_flush()

Here is the veth NAPI poll loop:

static int veth_poll(struct napi_struct *napi, int budget)
{
    struct veth_rq *rq =
    container_of(napi, struct veth_rq, xdp_napi);
    struct veth_stats stats = {};
    struct veth_xdp_tx_bq bq;
    int done;

    bq.count = 0;

    xdp_set_return_frame_no_direct();
    done = veth_xdp_rcv(rq, budget, &bq, &stats);

    if (done < budget && napi_complete_done(napi, done)) {
        /* Write rx_notify_masked before reading ptr_ring */
       smp_store_mb(rq->rx_notify_masked, false);
       if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
           if (napi_schedule_prep(&rq->xdp_napi)) {
               WRITE_ONCE(rq->rx_notify_masked, true);
               __napi_schedule(&rq->xdp_napi);
            }
        }
    }

    if (stats.xdp_tx > 0)
        veth_xdp_flush(rq, &bq);
    if (stats.xdp_redirect > 0)
        xdp_do_flush();
    xdp_clear_return_frame_no_direct();

    return done;
}

Something I have never seen before is that there is
napi_complete_done() and a __napi_schedule() before xdp_do_flush().
Let us check if this has something to do with it. So two suggestions
to be executed separately:

* Put a probe at the __napi_schedule() above and check if it gets
triggered before this problem
* Move the "if (stats.xdp_redirect > 0) xdp_do_flush();" to just
before "if (done < budget && napi_complete_done(napi, done)) {"

This might provide us some hints on what is going on.

Thanks: Magnus

> In our test setup we aren't applying any cpu affinity.  iperf2 is
> multi-threaded and can run on all 4 cores, and our application is
> multithreaded and can run on all 4 cores.  The napi scheduling seems
> to be per veth queue and yes I see those softirqs move and switch
> between CPUs.  I don't however have anything that clearly shows it
> running concurrently on two CPUs (The stretches of __xsk_rcv_zc are
> all on one core before it switches).  The closest I have is the
> several microseconds where it appears xsk_flush() overlaps at the end
> of my traces.  I would think that if the napi locking didn't work at
> all you'd see clear overlap.
>
> From my experiments with CPU affinity I've updated my test setup to
> frequently change the CPU affinity of iperf and our application on one
> of my test boxes with hopes that it helps to reproduce but I have no
> results so far.
>
> > > * I've also triggered this before I added the xsk_flush() probe and
> > >   in that case saw the kernel side additionally fill in the next
> > >   expected descriptor, which in the example above would be 0xfe4100.
> > >   This seems to indicate that my tracking is all still sane.
> > > * This is fairly reproducible, but I've got 10 test boxes running and
> > >   I only get maybe bug a day.
> > >
> > > Any thoughts on if the bug I described is actually possible,
> > > alternative theories, or other things to test/try would be welcome.
> >
> > I thought this would be impossible, but apparently not :-). We are
> > apparently doing something wrong in the AF_XDP code or have the wrong
> > assumptions in some situation, but I just do not know what at this
> > point in time. Maybe it is veth that breaks some of our assumptions,
> > who knows. But let us dig into it. I need your help here, because I
> > think it will be hard for me to reproduce the issue.
>
> Yeah if you have ideas on what to test I'll do my best to try them.
>
> I've additionally updated my application to put a bad "cookie"
> descriptor address back in the RX ring before updating the consumer
> pointer.  My hope is that if we then ever receive that cookie it
> proves the kernel raced and failed to update the correct address.
>
> Thanks,
> Shawn Bohrer
