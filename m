Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B44258CB4
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 12:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgIAKYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 06:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIAKYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 06:24:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F185CC061244;
        Tue,  1 Sep 2020 03:24:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so894148wrx.7;
        Tue, 01 Sep 2020 03:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BSt68/4cPL6B9cbf1fFvNtUnV0pY08yiPoiq1b4k1C0=;
        b=S7myy3wG2JuXN07jCRBXVQEkcUWLvqicrue256XR6ACpbJb2cgsL4VaYdajdUpMBJg
         5BEHLdorN6ZwlmNj8zlmGHGkyvmLfBXW17jx1/MRTk2rGs0WVBWRmD3gAPjQi5zmPzrD
         ELE6RdhzMCPmR6fGRMl7qBvhbonyvAY9M41R9bnzzNnb8lQkKFW3vZ4q9Tz/RN8NonHM
         wgCBCdHwUSuNi6UEmDzI+vR6skypaDwHML/xuEKwy/i45fNksaEnXLctqqlSeAvzyZI0
         3BkOhxYT9WhnGukYj5iIj1d0fpDUJR/yVd54p4037RIo0fMAvqynsvocQ+J5GArP64dy
         xbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BSt68/4cPL6B9cbf1fFvNtUnV0pY08yiPoiq1b4k1C0=;
        b=Q85lW70mO+oT/RAGhxrEFv4W9NVdPry0o26V6Cs3igC7lC36tFQcsFhI1YHzS00UHR
         AcuZX6C04G1HGnu3sz+eu5KnBb3HTyweK4uhK/xUuNLaTo/G1BUxY2qHo+nIb4qlebmU
         zzo1oZN2HnARKoQ2swP3s0Wbg41Dqe+QR2fdYsHg8KPuw2lQyVunQKcpNKZG/ULsZ27L
         oK82RZzqYvC4sf5IqKeeGW9ZIeOAytq1RGWn8rXqFv7DuoqaeV6zlnHTcE/JS3ralsF0
         KnYD5AW0dyu3CiJr1HtPdmErIldnup6c2ByNcVxReQwvooS0mHT9wHtU8nexoL2dQx3x
         TgZQ==
X-Gm-Message-State: AOAM532GdewuwecsIVWXp0gdHhRD3IUcly0nJT6bwG26XmptU8pHQspy
        Lwfl3/FjsbNA+XybMORwKkU=
X-Google-Smtp-Source: ABdhPJxn8Pb1jUHnsNUO9WCAd6GraSIjHy5Th5Wm/JL+aPo3SX1EFDLyAFgK6p5HIYEYcZhcz45qdw==
X-Received: by 2002:a5d:4e0b:: with SMTP id p11mr1113430wrt.32.1598955882575;
        Tue, 01 Sep 2020 03:24:42 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.241.11])
        by smtp.gmail.com with ESMTPSA id s5sm1515675wrm.33.2020.09.01.03.24.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 03:24:41 -0700 (PDT)
Subject: Re: [PATCH 2/2] random32: add noise from network and scheduling
 activity
To:     Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Sedat Dilek <sedat.dilek@gmail.com>, George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-3-w@1wt.eu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ed5d4d2a-0f8f-f202-8c4f-9fc3d4307e97@gmail.com>
Date:   Tue, 1 Sep 2020 12:24:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200901064302.849-3-w@1wt.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/20 11:43 PM, Willy Tarreau wrote:
> With the removal of the interrupt perturbations in previous random32
> change (random32: make prandom_u32() output unpredictable), the PRNG
> has become 100% deterministic again. While SipHash is expected to be
> way more robust against brute force than the previous Tausworthe LFSR,
> there's still the risk that whoever has even one temporary access to
> the PRNG's internal state is able to predict all subsequent draws till
> the next reseed (roughly every minute). This may happen through a side
> channel attack or any data leak.
> 
> This patch restores the spirit of commit f227e3ec3b5c ("random32: update
> the net random state on interrupt and activity") in that it will perturb
> the internal PRNG's statee using externally collected noise, except that
> it will not pick that noise from the random pool's bits nor upon
> interrupt, but will rather combine a few elements along the Tx path
> that are collectively hard to predict, such as dev, skb and txq
> pointers, packet length and jiffies values. These ones are combined
> using a single round of SipHash into a single long variable that is
> mixed with the net_rand_state upon each invocation.
> 
> The operation was inlined because it produces very small and efficient
> code, typically 3 xor, 2 add and 2 rol. The performance was measured
> to be the same (even very slightly better) than before the switch to
> SipHash; on a 6-core 12-thread Core i7-8700k equipped with a 40G NIC
> (i40e), the connection rate dropped from 556k/s to 555k/s while the
> SYN cookie rate grew from 5.38 Mpps to 5.45 Mpps.
> 

> diff --git a/net/core/dev.c b/net/core/dev.c
> index b9c6f31ae96e..e075f7e0785a 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -144,6 +144,7 @@
>  #include <linux/indirect_call_wrapper.h>
>  #include <net/devlink.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/prandom.h>
>  
>  #include "net-sysfs.h"
>  
> @@ -3557,6 +3558,7 @@ static int xmit_one(struct sk_buff *skb, struct net_device *dev,
>  		dev_queue_xmit_nit(skb, dev);
>  
>  	len = skb->len;
> +	PRANDOM_ADD_NOISE(skb, dev, txq, len + jiffies);
>  	trace_net_dev_start_xmit(skb, dev);
>  	rc = netdev_start_xmit(skb, dev, txq, more);
>  	trace_net_dev_xmit(skb, rc, dev, len);
> @@ -4129,6 +4131,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>  			if (!skb)
>  				goto out;
>  
> +			PRANDOM_ADD_NOISE(skb, dev, txq, jiffies);
>  			HARD_TX_LOCK(dev, txq, cpu);
>  
>  			if (!netif_xmit_stopped(txq)) {
> @@ -4194,6 +4197,7 @@ int dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
>  
>  	skb_set_queue_mapping(skb, queue_id);
>  	txq = skb_get_tx_queue(dev, skb);
> +	PRANDOM_ADD_NOISE(skb, dev, txq, jiffies);
>  
>  	local_bh_disable();
>  
> 

Hi Willy

There is not much entropy here really :

1) dev & txq are mostly constant on a typical host (at least the kind of hosts that is targeted by 
Amit Klein and others in their attacks.

2) len is also known by the attacker, attacking an idle host.

3) skb are also allocations from slab cache, which tend to recycle always the same pointers (on idle hosts)


4) jiffies might be incremented every 4 ms (if HZ=250)

Maybe we could feed percpu prandom noise with samples of ns resolution timestamps,
lazily cached from ktime_get() or similar functions.

This would use one instruction on x86 to update the cache, with maybe more generic noise.

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 4c47f388a83f17860fdafa3229bba0cc605ec25a..a3e026cbbb6e8c5499ed780e57de5fa09bc010b6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -751,7 +751,7 @@ ktime_t ktime_get(void)
 {
        struct timekeeper *tk = &tk_core.timekeeper;
        unsigned int seq;
-       ktime_t base;
+       ktime_t res, base;
        u64 nsecs;
 
        WARN_ON(timekeeping_suspended);
@@ -763,7 +763,9 @@ ktime_t ktime_get(void)
 
        } while (read_seqcount_retry(&tk_core.seq, seq));
 
-       return ktime_add_ns(base, nsecs);
+       res = ktime_add_ns(base, nsecs);
+       __this_cpu_add(prandom_noise, (unsigned long)ktime_to_ns(res));
+       return res;
 }
 EXPORT_SYMBOL_GPL(ktime_get);

