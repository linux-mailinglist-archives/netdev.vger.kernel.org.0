Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F5AD364E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfJKAjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:39:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34009 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfJKAjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:39:54 -0400
Received: by mail-lj1-f196.google.com with SMTP id j19so8087499lja.1
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrounds-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MDZWWB/Ud+l+MVtuAcfOL6WEx1UA5LiZUDvJuyzpvkg=;
        b=hc3nIVQED6Uz8RMHE512mAme6wFesU8CViEQvM4PrDjUqlfQ6K2P2by391xa0v+8BD
         b+i8xdFvIO11WDdZsnkvmC1Tv0EaTCs7bpJiwWW0yhUI6JQDT0mIwKmOhXAV3oZFvi7l
         BM4l8uliYM+EBQl0GsE4CQr31jvf7BEdw+J4+N0TfyXGoffJ8osMuzmhtBwvVSxhD2h+
         lP/sPZvblagaDj082R5f1ae61/HJLa0k3W7zwVR2qGNY+eIDsV4SvMyGBrd6Sv1hWh6M
         Z8JDx+DD9EkVCV4Hg2UtGJnHBmcgrR4sel9eNncDjiCExkdH9wFUdG3yD4M0HhFONhXW
         I8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MDZWWB/Ud+l+MVtuAcfOL6WEx1UA5LiZUDvJuyzpvkg=;
        b=XRMafdfnWM/SzFgftlUCuig/WKzumQB4XcB89WhQEeQtTZAF11qAoNTOaK7tOZG7W+
         Y9HEcPHVyrOf0G7soNbYBthulKiIAHPzzu8kz9FRdlYr7+ssNxekFtU5IybLzwalolJT
         YtsgiHOTQ1ZAl/BopLXKFVeYjDBd5vHL9gHduaH7iay3sPXHYaJ2Wk5BnA3s0+AlvFRH
         18N714Xmrcsnep3LWJM/GrVXXUgBDuGN/VXzDOxnQ5f7qdboslJJNghzR0dExL4ET1xn
         kdO0PjMj1nUafDf1wt6fA53vOJnm/wPDGFAcBRNkFKJB5tluF53RIBAa6eOjD9NB73uo
         qzew==
X-Gm-Message-State: APjAAAWhaIMU4zJO7IhJ6Bd6/Kxkrhf0JWai7z2Ki+8IoYcxqpbPgJ9z
        5FyHsgieRsg/06oPAF2KdXhnVG7auKM=
X-Google-Smtp-Source: APXvYqwLtDb+QvkzAQUPXoIIcToYZ5I2J6+xh8y/t0HHV0IYXkrCo1M9n2dTnICXxEpHQ6XXx/vfkA==
X-Received: by 2002:a2e:9890:: with SMTP id b16mr7091204ljj.153.1570754392048;
        Thu, 10 Oct 2019 17:39:52 -0700 (PDT)
Received: from [192.168.1.169] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c26sm1789740ljj.45.2019.10.10.17.39.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 17:39:51 -0700 (PDT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>
References: <d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com>
 <95c5a697932e19ebd6577b5dac4d7052fe8c4255.camel@redhat.com>
From:   Jonas Bonn <jonas.bonn@netrounds.com>
Message-ID: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
Date:   Fri, 11 Oct 2019 02:39:48 +0200
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
> Something alike the following code - completely untested - can possibly
> address the issue, but it's a bit rough and I would prefer not adding
> additonal complexity to the lockless qdiscs, can you please have a spin
> a it?

We've tested a couple of variants of this patch today, but unfortunately 
it doesn't fix the problem of packets getting stuck in the queue.

A couple of comments:

i) On 5.4, there is the BYPASS path that also needs the same treatment 
as it's essentially replicating the behavour of qdisc_run, just without 
the queue/dequeue steps

ii)  We are working a lot with the 4.19 kernel so I backported to the 
patch to this version and tested there.  Here the solution would seem to 
be more robust as the BYPASS path does not exist.

Unfortunately, in both cases we continue to see the issue of the "last 
packet" getting stuck in the queue.

/Jonas


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
>   	}
>   }
>   
> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> index 17bd8f539bc7..013480f6a794 100644
> --- a/net/sched/sch_generic.c
> +++ b/net/sched/sch_generic.c
> @@ -376,7 +376,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
>   	return sch_direct_xmit(skb, q, dev, txq, root_lock, validate);
>   }
>   
> -void __qdisc_run(struct Qdisc *q)
> +int __qdisc_run(struct Qdisc *q)
>   {
>   	int quota = dev_tx_weight;
>   	int packets;
> @@ -390,9 +390,10 @@ void __qdisc_run(struct Qdisc *q)
>   		quota -= packets;
>   		if (quota <= 0 || need_resched()) {
>   			__netif_schedule(q);
> -			break;
> +			return 0;
>   		}
>   	}
> +	return quota;
>   }
>   
>   unsigned long dev_trans_start(struct net_device *dev)
> 
