Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B31D20C4
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 08:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732902AbfJJG2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 02:28:01 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45389 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfJJG2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 02:28:01 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so4917035ljb.12
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 23:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrounds-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FiE63Jf0+YKrajX+a/6ereKGsQ9R9ph2lTRjBJOT88A=;
        b=CgY1dBiEMb98NQ/At9u26khShIHa54HFYd24qpfRhl58R7WD6fhM90irNgl/CX5d4d
         HP2cnwy5/XeyG/qAANZXTH0NDr4UO08Jm2FWN1Kn6aQYsp0qVzQAwM/I7J0a6LNwMHdo
         NmZdWlv4ymo8P7jElxCNRnKkDcyYtDHSf75MeYqHamlsEf1P83lTOhgnWIbBb9sczx5B
         iiKVlYHogkMOlNbl6PnmQvW90SsUlLFsqRd2Zd1PBxXbwBSZqP6Dg3+7q3LFTAl6Cgvj
         WdoA1i8sTSHe+0D+INEx6wnJCxVMkL0HUBl3JW0pgn+Optq8dYqM6pQmjApVthj8sJLz
         mArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FiE63Jf0+YKrajX+a/6ereKGsQ9R9ph2lTRjBJOT88A=;
        b=h13KpuDdkDpbI3Ty0BnBOpxH43Wkt2nzuE1ZqHNyeqHI+GaXuvXrx1dExWQdQxR5yM
         VBsRFTD/JaphwYQNiPAZFkeahHM0SauLd4Mk9rx81ml1B+2vgxIzVYyIVCu3l7EJqro5
         bPxnNEJI+Q8wLz4L+KXBsg7mUuJQWmA+DZNRgsMVFUMGNdS/s7IOEVwrd6c66N6+wnlI
         5QmV6dLfbkTa2V0mdKsYAcWsBnZVe3NcjhpaDnvAq1FS3FCS7vIZQaqj0Z2q2582gc7T
         ZTujXci3L32lGx1m+dAawTDznpmDiKbGf2TaMKgCvetEesI18vWpw3uI1tVMvYij/kAN
         yeFA==
X-Gm-Message-State: APjAAAU16K/Rj9rouMed3qjFnFshiA1Fz8VRQqgPHMFnn+pk/XfqfBHU
        5rQNu+U53UOSSv9Z7uvkxFEaPA==
X-Google-Smtp-Source: APXvYqxotN273Jma0cjDfGOmGpDy+7PPz1s8PTIBAU1+t1GdknJwYANdAEzTA16fCFrmVjrN4k/xmA==
X-Received: by 2002:a2e:a415:: with SMTP id p21mr5009509ljn.59.1570688877789;
        Wed, 09 Oct 2019 23:27:57 -0700 (PDT)
Received: from [10.0.156.104] ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id v1sm988319lfe.34.2019.10.09.23.27.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 23:27:56 -0700 (PDT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>
References: <d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com>
 <95c5a697932e19ebd6577b5dac4d7052fe8c4255.camel@redhat.com>
From:   Jonas Bonn <jonas.bonn@netrounds.com>
Message-ID: <18f58ddc-f16e-600f-02de-29c79332d945@netrounds.com>
Date:   Thu, 10 Oct 2019 08:27:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <95c5a697932e19ebd6577b5dac4d7052fe8c4255.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 09/10/2019 21:14, Paolo Abeni wrote:
> On Wed, 2019-10-09 at 08:46 +0200, Jonas Bonn wrote:
>> Hi,
>>
>> The lockless pfifo_fast qdisc has an issue with packets getting stuck in
>> the queue.  What appears to happen is:
>>
>> i)  Thread 1 holds the 'seqlock' on the qdisc and dequeues packets.
>> ii)  Thread 1 dequeues the last packet in the queue.
>> iii)  Thread 1 iterates through the qdisc->dequeue function again and
>> determines that the queue is empty.
>>
>> iv)  Thread 2 queues up a packet.  Since 'seqlock' is busy, it just
>> assumes the packet will be dequeued by whoever is holding the lock.
>>
>> v)  Thread 1 releases 'seqlock'.
>>
>> After v), nobody will check if there are packets in the queue until a
>> new packet is enqueued.  Thereby, the packet enqueued by Thread 2 may be
>> delayed indefinitely.
> 
> I think you are right.
> 
> It looks like this possible race is present since the initial lockless
> implementation - commit 6b3ba9146fe6 ("net: sched: allow qdiscs to
> handle locking")
> 
> Anyhow the racing windows looks quite tiny - I never observed that
> issue in my tests. Do you have a working reproducer?

Yes, it's reliably reproducible.  We do network latency measurements and 
latency spikes for these packets that get stuck in the queue.

> 
> Something alike the following code - completely untested - can possibly
> address the issue, but it's a bit rough and I would prefer not adding
> additonal complexity to the lockless qdiscs, can you please have a spin
> a it?

Your change looks reasonable.  I'll give it a try.


> 
> Thanks,
> 
> Paolo
> ---
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 6a70845bd9ab..65a1c03330d6 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -113,18 +113,23 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
>   		     struct net_device *dev, struct netdev_queue *txq,
>   		     spinlock_t *root_lock, bool validate);
>   
> -void __qdisc_run(struct Qdisc *q);
> +int __qdisc_run(struct Qdisc *q);
>   
>   static inline void qdisc_run(struct Qdisc *q)
>   {
> +	int quota = 0;
> +
>   	if (qdisc_run_begin(q)) {
>   		/* NOLOCK qdisc must check 'state' under the qdisc seqlock
>   		 * to avoid racing with dev_qdisc_reset()
>   		 */
>   		if (!(q->flags & TCQ_F_NOLOCK) ||
>   		    likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
> -			__qdisc_run(q);
> +			quota = __qdisc_run(q);
>   		qdisc_run_end(q);
> +
> +		if (quota > 0 && q->flags & TCQ_F_NOLOCK && q->ops->peek(q))
> +			__netif_schedule(q);

Not sure this is relevant, but there's a subtle difference in the way 
that the underlying ptr_ring peeks at the queue head and checks whether 
the queue is empty.

For peek it's:

READ_ONCE(r->queue[r->consumer_head]);

For is_empty it's:

!r->queue[READ_ONCE(r->consumer_head)];

The placement of the READ_ONCE changes here.  I can't get my head around 
whether this difference is significant or not.  If it is, then perhaps 
an is_empty() method is needed on the qdisc_ops...???

/Jonas
