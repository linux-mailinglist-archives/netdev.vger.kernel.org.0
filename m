Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 433DB64D979
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 11:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiLOKW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 05:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiLOKW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 05:22:29 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47972983F;
        Thu, 15 Dec 2022 02:22:18 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id gh17so51176916ejb.6;
        Thu, 15 Dec 2022 02:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w9BVbdALGkaQPw7JS7SOcY3nrDXVLw0SiJG7nqBW9rk=;
        b=OsPs86PWBkFHni5P1snQjQfVx3HzcylXp5vX10jNVgUX4NbuhdMY2rWnxqnGl+HBmr
         VZ1UfAdPeSVdoajo5y7CeBV4eobIX9UJmvd+29KjfhLM1aSiGKw4kDNDBEuw1DVTcu3M
         890Z2bljbr4aDfkSRC2PnCsYBO6fUvgbYGsLC5Y4ByZP8IOPinrZVR04DYc4incR+qsn
         5zir+ftNNQ/J9ZH4HR62tULCZBaa3FmwhN2wzvkjZTIiQDfgakzTpu1yL+RAnUdcJ9li
         7UJHcZy4aXmh6QbHsAwccio2TaNFP4haRpUglFEQb4aotDJlhzsW+oeTIPHZ36xQU9mP
         V5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w9BVbdALGkaQPw7JS7SOcY3nrDXVLw0SiJG7nqBW9rk=;
        b=d6SdLueYAahxP2K8RUY3Ukg2MFSFAC3xAGi/LNTYTBPtfp1soNIRB37BBUG4JmJIJP
         XhIX8msO+n7KTjsToI/E4AqxikoGAjyMptPdghzFf5MM4NPNHRRJdwdIjASM7qCDUCzb
         QmHN8B0svJkW/NxWb/tKRO1OP5lcUM7WxkUa9o1vdI5Ev57jXFbZo3tKZ3dDSaJNWpOd
         eZebYz7iqDpmZcXeqqzyv2+IRLzrXdNcgTzOFAmb0yYet5ibv6gLHsad9tTaoIalITkv
         1ya802NMTXdOCPM3PfKtmLVSbaWVNsf+E4AALsYebbj5NslSd5olIke6bHMJUdf46aPE
         8eNQ==
X-Gm-Message-State: ANoB5pnv7OI0lkixG9jOABBuNPjN6hitqHHZ4Gd1suN3pBbZ0Cwm98ZE
        bOG1gYYGD98Rv3uv1tVn2MFH/qKMOkHWxTgY4dg=
X-Google-Smtp-Source: AA0mqf7ODm7bGl+OqlKEejG6e3iD8MGH3Pvhm1taAS7yskQ11J7WGnkZ/JzZqJTVzkSAIDn2EAaSFrL6xyI3Rjjq/fQ=
X-Received: by 2002:a17:906:a58:b0:7ad:b45c:dbca with SMTP id
 x24-20020a1709060a5800b007adb45cdbcamr73135286ejf.388.1671099737195; Thu, 15
 Dec 2022 02:22:17 -0800 (PST)
MIME-Version: 1.0
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
In-Reply-To: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 15 Dec 2022 11:22:05 +0100
Message-ID: <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
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

On Wed, Dec 14, 2022 at 11:33 PM Shawn Bohrer <sbohrer@cloudflare.com> wrote:
>
> Hello,
>
> I've been trying to track down a problem we've been seeing with
> occasional corrupt packets using AF_XDP.  As you probably expect this
> occurs because we end up with the same descriptor in ring multiple
> times.  However, after lots of debugging and analyzing I think this is
> actually caused by a kernel bug, though I still don't fully understand
> what is happening.  This is currently being seen on kernel 5.15.77 and
> I haven't done any testing to see if we see the same issue on newer
> versions.
>
> Inside my application I've written code to track and log as
> descriptors are placed into the fill and tx queues, and when they are
> pulled out of the rx and completion queues.  The transitions are
> logged to /sys/kernel/debug/tracing/trace_marker.  Additionally I keep
> my own VecDeque which mirrors the order descriptors are placed in the
> fill queue and I verify that they come out of the rx queue in the same
> order.  I do realize there are some cases where they might not come
> out in the same order but I do not appear to be hitting that.
>
> I then add several kprobes to track the kernel side with ftrace. Most
> importantly are these probes:
>
> This adds a probe on the call to xskq_prod_reserve_desc() this
> actually creates two probes so you see two prints everytime it is hit:
> perf probe -a '__xsk_rcv_zc:7 addr len xs xs->pool->fq'
>
> This adds a probe on xsk_flush():
> perf probe -a 'xsk_flush:0 xs'
>
> My AF_XDP application is bound to two multi-queue veth interfaces
> (called 'ingress' and 'egress' in my prints) in a networking
> namespace.  I'm then generating traffic with iperf and hping3 through
> these interfaces.  When I see an out-of-order descriptor in my
> application I dump the state of my internal VecDeque to the
> trace_marker.  Here is an example of what I'm seeing which looks like
> a kernel bug:
>
>  // On CPU 0 we've removed descriptor 0xff0900 from the fill queue,
>  // copied a packet, but have not put it in the rx queue yet
>  flowtrackd-9chS-142014  [000] d.Z1. 609766.698512: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x9b/0x250) addr=0xff0900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
>  flowtrackd-9chS-142014  [000] d.Z1. 609766.698513: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0xff0900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
>  // On CPU 2 we've removed descriptor 0x1000900 from the fill queue,
>  // copied a packet, but have not put it in the rx queue yet
>           iperf2-1217    [002] d.Z1. 609766.698523: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x9b/0x250) addr=0x1000900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
>           iperf2-1217    [002] d.Z1. 609766.698524: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0x1000900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
>  // On CPU 0 xsk_flush is called on the socket
>  flowtrackd-9chS-142014  [000] d.Z1. 609766.698528: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff90fd32693c00
>  // My application receives 0xff0900 on the ingress interface queue 1
>  flowtrackd-9chS-142014  [000] ..... 609766.698540: tracing_mark_write: ingress q:1 0xff0900 FILL -> RX
>  // On CPU 2 xsk_flush is called on the socket
>           iperf2-1217    [002] d.Z1. 609766.698545: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff90fd32693c00
>  // My application receives 0xf61900 this is unexpected.  We expected
>  // to receive 0x1000900 which is what you saw in the previous
>  // __xsk_rcv_zc print.  0xf61900 is in the fill queue but it is far
>  // away from our current position in the ring and I've trimmed the
>  // print slightly to show that.
>  flowtrackd-9chS-142014  [000] ..... 609766.698617: tracing_mark_write: ingress q:1 0xf61900 FILL -> RX: expected 0x1000900 remaining: [fe4100, f9c100, f8a100, ..., f61900
>
> From reading the code I believe that the call to
> xskq_prod_reserve_desc() inside __xsk_rcv_zc is the only place
> descriptors are placed into the RX queue.  To me this means I should
> see a print from my probe for the mystery 0xf61900 but we do not see
> this print.  Instead we see the expected 0x1000900.  One theory I have
> is that there could be a race where CPU 2 increments the cached_prod
> pointer but has not yet updated the addr and len, CPU 0 calls
> xsk_flush(), and now my application reads the old descriptor entry
> from that location in the RX ring.  This would explain everything, but
> the problem with this theory is that __xsk_rcv_zc() and xsk_flush()
> are getting called from within napi_poll() and this appears to hold
> the netpoll_poll_lock() for the whole time which I think should
> prevent the race I just described.

Thanks Shawn for your detailed bug report. The rings between user
space and kernel space are single-producer/single-consumer, so in your
case when both CPU0 and CPU2 are working on the fill ring and the Rx
ring at the same time, this will indeed produce races. The intended
design principle to protect against this is that only one NAPI context
can access any given ring at any point in time and that the NAPI logic
should prevent two instances of the same NAPI instance from running at
the same time. So if that is not true for some reason, we would get a
race like this. Another option is that one of the CPUs should really
process another fill ring instead of the same.

Do you see the second socket being worked on when this happens?

Could you please share how you set up the two AF_XDP sockets?

Are you using XDP_DRV mode in your tests?

> A couple more notes:
> * The ftrace print order and timestamps seem to indicate that the CPU
>   2 napi_poll is running before the CPU 0 xsk_flush().  I don't know
>   if these timestamps can be trusted but it does imply that maybe this
>   can race as I described.  I've triggered this twice with xsk_flush
>   probes and both show the order above.
> * In the 3 times I've triggered this it has occurred right when the
>   softirq processing switches CPUs

This is interesting. Could you check, in some way, if you only have
one core working on the fill ring before the softirq switching and
then after that you have two? And if you have two, is that period
transient?

> * I've also triggered this before I added the xsk_flush() probe and
>   in that case saw the kernel side additionally fill in the next
>   expected descriptor, which in the example above would be 0xfe4100.
>   This seems to indicate that my tracking is all still sane.
> * This is fairly reproducible, but I've got 10 test boxes running and
>   I only get maybe bug a day.
>
> Any thoughts on if the bug I described is actually possible,
> alternative theories, or other things to test/try would be welcome.

I thought this would be impossible, but apparently not :-). We are
apparently doing something wrong in the AF_XDP code or have the wrong
assumptions in some situation, but I just do not know what at this
point in time. Maybe it is veth that breaks some of our assumptions,
who knows. But let us dig into it. I need your help here, because I
think it will be hard for me to reproduce the issue.

Thanks: Magnus

> Thanks,
> Shawn Bohrer
