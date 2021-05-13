Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D775E37F281
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 07:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhEMFNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 01:13:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhEMFNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 01:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620882748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TcOAwivDbtlARJpFLH0Y1M7raCC9tMpEn3jc2In1UFc=;
        b=gB8ejoN8ecaM+vy8Grx3q/6GV0EjY0/WUl0BmuXOqyLjB/Nqx0/lVq03dAV+l/UBIJeTSA
        3xV6aIpSBSBZn0sa8y1llUNMcdK0czvFUlXpzXNAoVvSvvpaqJkG5cKXX0Q1QW4h5k+Uyu
        1QgNV1Bd6OqVtg9VOxa92c5+Q/n1UNA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-KUrAg_R3OMKYuFJSwP7bYw-1; Thu, 13 May 2021 01:12:20 -0400
X-MC-Unique: KUrAg_R3OMKYuFJSwP7bYw-1
Received: by mail-wr1-f72.google.com with SMTP id v5-20020adf9e450000b029010e708f05b3so6778501wre.6
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 22:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TcOAwivDbtlARJpFLH0Y1M7raCC9tMpEn3jc2In1UFc=;
        b=qobE/QW57W8hdUz5YwysMVYwwSvkjow3kJgf8h9ueH0fjc/MvbhV0TVS4YC7XqJOPN
         m44mSITLId9G+kqRkM+x18x4YXIRJyHcjG9udnSadXQ0PFtQP4vvhCoQvePSf37RCS8o
         lffWQzZvKJvCGL3eB5fmKcUKKMMEsbSC8Mr8EmHqRseJFDQZxIjrTRZWC12GoDMcb67R
         AzutEJiWP5Ght6+Y+97Z99Q8z1fNLfau1OPH/trnYyaLtbaHRTZVT/f20MGSv250Dnfd
         BWfVy+FH4epz49znEh8X3QYbLysl6LfkcDXtPL2NJySf9umfrtpnxZIMvcgkMMkUt16m
         6Cww==
X-Gm-Message-State: AOAM531fGjsOy3mkjJMuPHHlxE+pL0uHdcW9eMGPx5p1ZANeUhgLPArh
        KV2qZt2MQr9uOycJRsgdIlNzrWFo1DA9jc6OPDgfs4LModxz4VS7ZXiwFVMhe2iV6vBx6G9g7Fy
        3f0HegxLFUESwlbqi
X-Received: by 2002:a05:600c:19cd:: with SMTP id u13mr301609wmq.171.1620882738820;
        Wed, 12 May 2021 22:12:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz65HKJoTtlBrckxiBt2p5AvxqrwBotMCpCfUgNmO1jclonTBYcuH40MjWiQGDIMS8yJH2Sgw==
X-Received: by 2002:a05:600c:19cd:: with SMTP id u13mr301592wmq.171.1620882738557;
        Wed, 12 May 2021 22:12:18 -0700 (PDT)
Received: from localhost.localdomain ([151.29.91.215])
        by smtp.gmail.com with ESMTPSA id c15sm1734122wro.21.2021.05.12.22.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 22:12:18 -0700 (PDT)
Date:   Thu, 13 May 2021 07:12:16 +0200
From:   Juri Lelli <juri.lelli@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
Message-ID: <YJy1MI6Z4JHDExWL@localhost.localdomain>
References: <YJofplWBz8dT7xiw@localhost.localdomain>
 <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/05/21 23:43, Sebastian Andrzej Siewior wrote:
> __napi_schedule_irqoff() is an optimized version of __napi_schedule()
> which can be used where it is known that interrupts are disabled,
> e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
> callbacks.
> 
> On PREEMPT_RT enabled kernels this assumptions is not true. Force-
> threaded interrupt handlers and spinlocks are not disabling interrupts
> and the NAPI hrtimer callback is forced into softirq context which runs
> with interrupts enabled as well.
> 
> Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
> game so make __napi_schedule_irqoff() invoke __napi_schedule() for
> PREEMPT_RT kernels.
> 
> The callers of ____napi_schedule() in the networking core have been
> audited and are correct on PREEMPT_RT kernels as well.
> 
> Reported-by: Juri Lelli <juri.lelli@redhat.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Alternatively __napi_schedule_irqoff() could be #ifdef'ed out on RT and
> an inline provided which invokes __napi_schedule().
> 
> This was not chosen as it creates #ifdeffery all over the place and with
> the proposed solution the code reflects the documentation consistently
> and in one obvious place.
> 
>  net/core/dev.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 222b1d322c969..febb23708184e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6501,11 +6501,18 @@ EXPORT_SYMBOL(napi_schedule_prep);
>   * __napi_schedule_irqoff - schedule for receive
>   * @n: entry to schedule
>   *
> - * Variant of __napi_schedule() assuming hard irqs are masked
> + * Variant of __napi_schedule() assuming hard irqs are masked.
> + *
> + * On PREEMPT_RT enabled kernels this maps to __napi_schedule()
> + * because the interrupt disabled assumption might not be true
> + * due to force-threaded interrupts and spinlock substitution.
>   */
>  void __napi_schedule_irqoff(struct napi_struct *n)
>  {
> -	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	else
> +		__napi_schedule(n);
>  }
>  EXPORT_SYMBOL(__napi_schedule_irqoff);

Thanks for the patch!

Reviewed-by: Juri Lelli <juri.lelli@redhat.com>

Best,
Juri

