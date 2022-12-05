Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBCD642CD1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiLEQaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLEQaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:30:23 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42F6D13C
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:30:22 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3c21d6e2f3aso123322767b3.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 08:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/1zxzft3XQrLGJBHO2P4bZMMXf1MxBr6IUIeTJ5M8UY=;
        b=cU2xFMa74iU7af0EOrwp5tt+e6R56Vndwh0dnsSRmhqjiTgQeuWaVtVDQ9mR5jkZ1o
         20BCxpKLqlon9vANt/5C9mHp1fd+KhHMLrSIz9hXUkSDPdc1yC2fUQKimVomx8oIWZlj
         6UzKVupDjFxoFhj6eGaYEk+Um7i82h5rCvz36TwdCK5y4XNL9qWhB9AbI0jzJqMTSbuA
         1brt5cKAa4bC/sWGTDLipI0l2ZHB81tMmLHCHqfs+/cVKuu6ScACI3AYuDEeKcv2Tf1+
         MdFrqK4AlObBuyky1vBexouLgFE3qEXYmtoFbfvEY1jaxSqJphVgX5GiwESlOgu3gE5N
         O4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1zxzft3XQrLGJBHO2P4bZMMXf1MxBr6IUIeTJ5M8UY=;
        b=Hg4YmuJGugGgFoYPkhB38TnHtSFITY/fLpH0d36SvcDDsmRSCbIDCe9PiRR6x48ccu
         qVfjR6FpH61+P3vr9yPwQHqxBQZ5SFSA37IFDTdtGAa27WqV7k2Xby6uTnzJiF2Lf1oM
         GLwg901ZbrHJEzJ7ClgtEcJxMwo/FYU0QtKrythVpK2kRqII9qBSTU81sLA3AcYZFjn2
         tOyUeIiHmdpI6QQq1OFneeROpGlES5dBU19SDlzhl/6sfKBjf5DsEFFrJiKc20c4p1Kd
         +8Km+hRBB/eCtQBFoSyJFEsGPEPnpoBN5u9qDM5O1yfeWSc8JyRl+6BBkeZ9my5XEyDM
         YVGw==
X-Gm-Message-State: ANoB5pl3TpjLu23uofkHu4OErUSVuqZfqO4c6hnOjQfTtpaesmZZvI3M
        QRenpvlikltEY1HuWLSAINmmwwnFvrmxjIH2tCDJfA==
X-Google-Smtp-Source: AA0mqf72/qz5y6QJlOCO00pR3OxEpQTwykBu1SWbrD5hO4HP+w5QmA/1E1DIEL5CUHoe5BlyEm1b93RQSYZrrd4MZvc=
X-Received: by 2002:a81:6ec6:0:b0:3c7:38d8:798f with SMTP id
 j189-20020a816ec6000000b003c738d8798fmr35149570ywc.489.1670257821450; Mon, 05
 Dec 2022 08:30:21 -0800 (PST)
MIME-Version: 1.0
References: <20221205153557.28549-1-justin.iurman@uliege.be>
In-Reply-To: <20221205153557.28549-1-justin.iurman@uliege.be>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 17:30:10 +0100
Message-ID: <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
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

Patch title seems

On Mon, Dec 5, 2022 at 4:36 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> This patch fixes a NULL qdisc pointer when retrieving the TX queue depth
> for IOAM.
>
> IMPORTANT: I suspect this fix is local only and the bug goes deeper (see
> reasoning below).
>
> Kernel panic:
> [...]
> RIP: 0010:ioam6_fill_trace_data+0x54f/0x5b0
> [...]
>
> ...which basically points to the call to qdisc_qstats_qlen_backlog
> inside net/ipv6/ioam6.c.
>
> From there, I directly thought of a NULL pointer (queue->qdisc). To make
> sure, I added some printk's to know exactly *why* and *when* it happens.
> Here is the (summarized by queue) output:
>
> skb for TX queue 1, qdisc is ffff8b375eee9800, qdisc_sleeping is ffff8b375eee9800
> skb for TX queue 2, qdisc is ffff8b375eeefc00, qdisc_sleeping is ffff8b375eeefc00
> skb for TX queue 3, qdisc is ffff8b375eeef800, qdisc_sleeping is ffff8b375eeef800
> skb for TX queue 4, qdisc is ffff8b375eeec800, qdisc_sleeping is ffff8b375eeec800
> skb for TX queue 5, qdisc is ffff8b375eeea400, qdisc_sleeping is ffff8b375eeea400
> skb for TX queue 6, qdisc is ffff8b375eeee000, qdisc_sleeping is ffff8b375eeee000
> skb for TX queue 7, qdisc is ffff8b375eee8800, qdisc_sleeping is ffff8b375eee8800
> skb for TX queue 8, qdisc is ffff8b375eeedc00, qdisc_sleeping is ffff8b375eeedc00
> skb for TX queue 9, qdisc is ffff8b375eee9400, qdisc_sleeping is ffff8b375eee9400
> skb for TX queue 10, qdisc is ffff8b375eee8000, qdisc_sleeping is ffff8b375eee8000
> skb for TX queue 11, qdisc is ffff8b375eeed400, qdisc_sleeping is ffff8b375eeed400
> skb for TX queue 12, qdisc is ffff8b375eeea800, qdisc_sleeping is ffff8b375eeea800
> skb for TX queue 13, qdisc is ffff8b375eee8c00, qdisc_sleeping is ffff8b375eee8c00
> skb for TX queue 14, qdisc is ffff8b375eeea000, qdisc_sleeping is ffff8b375eeea000
> skb for TX queue 15, qdisc is ffff8b375eeeb800, qdisc_sleeping is ffff8b375eeeb800
> skb for TX queue 16, qdisc is NULL, qdisc_sleeping is NULL
>
> What the hell? So, not sure why queue #16 would *never* have a qdisc
> attached. Is it something expected I'm not aware of? As an FYI, here is
> the output of "tc qdisc list dev xxx":
>
> qdisc mq 0: root
> qdisc fq_codel 0: parent :10 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :f limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :e limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :d limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :c limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :b limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :a limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :9 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
>
> By the way, the NIC is an Intel XL710 40GbE QSFP+ (i40e driver, firmware
> version 8.50 0x8000b6c7 1.3082.0) and it was tested on latest "net"
> version (6.1.0-rc7+). Is this a bug in the i40e driver?
>

> Cc: stable@vger.kernel.org

Patch title is mangled. The Fixes: tag should appear here, not in the title.


Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")

> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  net/ipv6/ioam6.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
> index 571f0e4d9cf3..2472a8a043c4 100644
> --- a/net/ipv6/ioam6.c
> +++ b/net/ipv6/ioam6.c
> @@ -727,10 +727,13 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
>                         *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
>                 } else {
>                         queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);

Are you sure skb_dst(skb)->dev is correct at this stage, what about
stacked devices ?

> -                       qdisc = rcu_dereference(queue->qdisc);
> -                       qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> -
> -                       *(__be32 *)data = cpu_to_be32(backlog);
> +                       if (!queue->qdisc) {

This is racy.

> +                               *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> +                       } else {
> +                               qdisc = rcu_dereference(queue->qdisc);
> +                               qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> +                               *(__be32 *)data = cpu_to_be32(backlog);
> +                       }
>                 }
>                 data += sizeof(__be32);
>         }
> --
> 2.25.1
>

Quite frankly I suggest to revert b63c5478e9cb completely.

The notion of Queue depth can not be properly gathered in Linux with a
multi queue model,
so why trying to get a wrong value ?
