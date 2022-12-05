Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CEA642DF4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiLEQwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiLEQwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:52:07 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7067C750
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:50:41 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id n184so14997050yba.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 08:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=omxPhxygGi15DInRWNsEIsnqTdfZ/lF3i1adfZBYqUs=;
        b=scqda3yNywWG6P6eVxTAMfyltHtKiS1vZtEYCCcWsy5ylNETkg4WCJXkQTeVWI6Gqg
         mtl3j/cidoQ7g3YDQS04ZpJJ8z5kGVUK5Mn+uG5J6hY4tbUrPSuXNE2ra7EQM1lUWejQ
         Tg4Tgbw2PsAooGbaL3Zi9hiJV+KiT5U9GMSA1Y0OxFENvRBFqrtu3IZ9TvT6OZzcxF9B
         IXldqDJdkpaVuErS4pm9ZDd9xoJcZmCH7ggm84sJ21XYckL5+SeECspb0vdurPorkGb5
         L39PxZEk4ww76D4LsVz13qiPNDqp7/RoR/cOBZNMpPHTtZIuR5vIYAGl7ci6LEe6ITaD
         88sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=omxPhxygGi15DInRWNsEIsnqTdfZ/lF3i1adfZBYqUs=;
        b=EgAaNzEi20iFHSFys0ePx2sQ5Yblc+hKniw1mb+hXSjQm0GjD0sY1cAfebq5C8ETam
         aLJ0zXNHqlRGM2PLUbb25Z1JKjRV73lxY+L5AqXClCGerJakrV9Q4JjZhpxOlUk9btaf
         rVZD9b+P1jAjQEDcrvL79pnyd/UZzvP6gxhvKvq4keXkYDUmh2w1bLHiqDbzfgqAuyt5
         FgO5q1Qy13HImnnSalC12qWcLnK4tHEmi0r+R931fAgMe+95MBQCtAfriDARueuwA3YO
         lpMe5Ni0Vw7pEjTB0kbyac9zIvcfaZTzuaem+j0SIjb/2THHeYr3nu2aMtxtAfAQnBY3
         9qJQ==
X-Gm-Message-State: ANoB5pmdi3R+ls17UiqSff1l+Z4w0okyhSciHoJfMp+xw11uedEeIlo3
        6jOb5K65XStPQBykg0npg9p6RnxsISeUpJye52TpFw==
X-Google-Smtp-Source: AA0mqf44nhhZrtHWPcx3MqYDBxCJTtCrWPDxuLtpIYyntxCI8F/ZvXwwdp5paXz5Xkx/21IBz+pcYa3nhxk3c9LNaok=
X-Received: by 2002:a05:6902:1004:b0:6fe:d784:282a with SMTP id
 w4-20020a056902100400b006fed784282amr9840834ybt.598.1670259040447; Mon, 05
 Dec 2022 08:50:40 -0800 (PST)
MIME-Version: 1.0
References: <20221205153557.28549-1-justin.iurman@uliege.be> <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
In-Reply-To: <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 17:50:28 +0100
Message-ID: <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 5, 2022 at 5:30 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Patch title seems
>
> On Mon, Dec 5, 2022 at 4:36 PM Justin Iurman <justin.iurman@uliege.be> wrote:
> >
> > This patch fixes a NULL qdisc pointer when retrieving the TX queue depth
> > for IOAM.
> >
> > IMPORTANT: I suspect this fix is local only and the bug goes deeper (see
> > reasoning below).
> >
> > Kernel panic:
> > [...]
> > RIP: 0010:ioam6_fill_trace_data+0x54f/0x5b0
> > [...]
> >
> > ...which basically points to the call to qdisc_qstats_qlen_backlog
> > inside net/ipv6/ioam6.c.
> >
> > From there, I directly thought of a NULL pointer (queue->qdisc). To make
> > sure, I added some printk's to know exactly *why* and *when* it happens.
> > Here is the (summarized by queue) output:
> >
> > skb for TX queue 1, qdisc is ffff8b375eee9800, qdisc_sleeping is ffff8b375eee9800
> > skb for TX queue 2, qdisc is ffff8b375eeefc00, qdisc_sleeping is ffff8b375eeefc00
> > skb for TX queue 3, qdisc is ffff8b375eeef800, qdisc_sleeping is ffff8b375eeef800
> > skb for TX queue 4, qdisc is ffff8b375eeec800, qdisc_sleeping is ffff8b375eeec800
> > skb for TX queue 5, qdisc is ffff8b375eeea400, qdisc_sleeping is ffff8b375eeea400
> > skb for TX queue 6, qdisc is ffff8b375eeee000, qdisc_sleeping is ffff8b375eeee000
> > skb for TX queue 7, qdisc is ffff8b375eee8800, qdisc_sleeping is ffff8b375eee8800
> > skb for TX queue 8, qdisc is ffff8b375eeedc00, qdisc_sleeping is ffff8b375eeedc00
> > skb for TX queue 9, qdisc is ffff8b375eee9400, qdisc_sleeping is ffff8b375eee9400
> > skb for TX queue 10, qdisc is ffff8b375eee8000, qdisc_sleeping is ffff8b375eee8000
> > skb for TX queue 11, qdisc is ffff8b375eeed400, qdisc_sleeping is ffff8b375eeed400
> > skb for TX queue 12, qdisc is ffff8b375eeea800, qdisc_sleeping is ffff8b375eeea800
> > skb for TX queue 13, qdisc is ffff8b375eee8c00, qdisc_sleeping is ffff8b375eee8c00
> > skb for TX queue 14, qdisc is ffff8b375eeea000, qdisc_sleeping is ffff8b375eeea000
> > skb for TX queue 15, qdisc is ffff8b375eeeb800, qdisc_sleeping is ffff8b375eeeb800
> > skb for TX queue 16, qdisc is NULL, qdisc_sleeping is NULL
> >
> > What the hell? So, not sure why queue #16 would *never* have a qdisc
> > attached. Is it something expected I'm not aware of? As an FYI, here is
> > the output of "tc qdisc list dev xxx":
> >
> > qdisc mq 0: root
> > qdisc fq_codel 0: parent :10 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :f limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :e limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :d limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :c limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :b limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :a limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :9 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> > qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >
> > By the way, the NIC is an Intel XL710 40GbE QSFP+ (i40e driver, firmware
> > version 8.50 0x8000b6c7 1.3082.0) and it was tested on latest "net"
> > version (6.1.0-rc7+). Is this a bug in the i40e driver?
> >
>
> > Cc: stable@vger.kernel.org
>
> Patch title is mangled. The Fixes: tag should appear here, not in the title.
>
>
> Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")
>
> > Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> > ---
> >  net/ipv6/ioam6.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
> > index 571f0e4d9cf3..2472a8a043c4 100644
> > --- a/net/ipv6/ioam6.c
> > +++ b/net/ipv6/ioam6.c
> > @@ -727,10 +727,13 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
> >                         *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> >                 } else {
> >                         queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
>
> Are you sure skb_dst(skb)->dev is correct at this stage, what about
> stacked devices ?
>
> > -                       qdisc = rcu_dereference(queue->qdisc);
> > -                       qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> > -
> > -                       *(__be32 *)data = cpu_to_be32(backlog);
> > +                       if (!queue->qdisc) {
>
> This is racy.
>
> > +                               *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> > +                       } else {
> > +                               qdisc = rcu_dereference(queue->qdisc);
> > +                               qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> > +                               *(__be32 *)data = cpu_to_be32(backlog);
> > +                       }
> >                 }
> >                 data += sizeof(__be32);
> >         }
> > --
> > 2.25.1
> >
>
> Quite frankly I suggest to revert b63c5478e9cb completely.
>
> The notion of Queue depth can not be properly gathered in Linux with a
> multi queue model,
> so why trying to get a wrong value ?

Additional reason for a revert is that qdisc_qstats_qlen_backlog() is
reserved for net/sched
code, I think it needs the qdisc lock to be held.
