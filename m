Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6DB4705D1
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhLJQjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:39:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243609AbhLJQjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:39:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639154126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r4QRN0UBrAGr9qhm2nQu9HuovT4+hT3nnPAZtJhnXc4=;
        b=PyLM9nYeTTlnspoIwzvL/S5nvyB30pmLZKFu2dPuc8FOgoD6AH14qcV0u3VcnbAyzz1E7u
        PNvserh5XbPoBReeM249mVXIn85wWyOkHnV0ixdxROU6lWhYiS6YUBcg/4vaK7VE84IITv
        BcpXsTBfnp5zAlxCAwpK2zgNppWTvu0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-dg9WqZrzMni5uKylMfbVZQ-1; Fri, 10 Dec 2021 11:35:25 -0500
X-MC-Unique: dg9WqZrzMni5uKylMfbVZQ-1
Received: by mail-qt1-f198.google.com with SMTP id d18-20020a05622a15d200b002acc9aa3e0cso14546412qty.17
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=r4QRN0UBrAGr9qhm2nQu9HuovT4+hT3nnPAZtJhnXc4=;
        b=i0PD1SUQVzFkeCQiBkZVvTwnX0AQ7cSjZ7H2XtnDnz8ryZumZYxQ+sXpZfZD9gNN2T
         gWdJFMck+siPwZJFEyqL8N9QlhCvsmrpmWwOQnJBh0Qu4LoWjALhluyHU/oZFez6NCMH
         O/T5mmmBPdK9fSQUQ0bsYdN3xJw9rp6hz50KnzDE3VjlZHYbwe/g+lUh5MWjvz2F/wSs
         PNldJw3J6HQrwNMHyRWLDmaTysINUPR47AT0eT7inAwNLYOajVclWDU8UQjPSMmUYwmN
         tip9XatJIC4FI55niGqwX66ATQ8dY15be4PTGV3ASLZyo6qDbh9XauZXNYEca7hxQgdN
         OoIw==
X-Gm-Message-State: AOAM533619LJ6OobkgHS0b9+xw5XOC8/dx98bGTBAdkOgHNPczVSoioU
        Beg1r1/JB+uc03pfQ2G3p/PJIIIqCHN8z6cX63gPCmb/gQeQCStZFgiLu6VMmpMLI3ahZeNXiRA
        qZ+QBlchh5o+LoIid
X-Received: by 2002:a05:622a:346:: with SMTP id r6mr27783930qtw.78.1639154125154;
        Fri, 10 Dec 2021 08:35:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB1DPknB3xGfiCNSNNr5OF7wwdMEz2YmEgxTOiMouAkgk4EI+Cb0io8ADKMSUwG+ip9S+nIw==
X-Received: by 2002:a05:622a:346:: with SMTP id r6mr27783900qtw.78.1639154124910;
        Fri, 10 Dec 2021 08:35:24 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-237-50.dyn.eolo.it. [146.241.237.50])
        by smtp.gmail.com with ESMTPSA id z10sm2281884qtw.71.2021.12.10.08.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:35:24 -0800 (PST)
Message-ID: <99af5c3079470432b97a74ab6aa3a43a1f7b178d.camel@redhat.com>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Fri, 10 Dec 2021 17:35:21 +0100
In-Reply-To: <YbN1OL0I1ja4Fwkb@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-10 at 16:41 +0100, Sebastian Andrzej Siewior wrote:
> The root-lock is dropped before dev_hard_start_xmit() is invoked and after
> setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
> by another sender/task with a higher priority then this new sender won't
> be able to submit packets to the NIC directly instead they will be
> enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
> is scheduled again and finishes the job.
> 
> By serializing every task on the ->busylock then the task will be
> preempted by a sender only after the Qdisc has no owner.
> 
> Always serialize on the busylock on PREEMPT_RT.

Not sure how much is relevant in the RT context, but this should impact
the xmit tput in a relevant, negative way.

If I read correctly, you use the busylock to trigger priority ceiling
on each sender. I'm wondering if there are other alternative ways (no
contended lock, just some RT specific annotation) to mark a whole
section of code for priority ceiling ?!?

Thanks!

Paolo
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/core/dev.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 2a352e668d103..4a701cf2e2c10 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3836,8 +3836,16 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
>  	 * separate lock before trying to get qdisc main lock.
>  	 * This permits qdisc->running owner to get the lock more
>  	 * often and dequeue packets faster.
> +	 * On PREEMPT_RT it is possible to preempt the qdisc owner during xmit
> +	 * and then other tasks will only enqueue packets. The packets will be
> +	 * sent after the qdisc owner is scheduled again. To prevent this
> +	 * scenario the task always serialize on the lock.
>  	 */
> -	contended = qdisc_is_running(q);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		contended = qdisc_is_running(q);
> +	else
> +		contended = true;
> +
>  	if (unlikely(contended))
>  		spin_lock(&q->busylock);
>  

