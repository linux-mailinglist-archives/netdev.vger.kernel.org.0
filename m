Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480BCEAC4C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJaJHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfJaJHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 05:07:12 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9BA59C04B940
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:07:11 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id y14so304384wmi.4
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 02:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uv8J8WDWlm5KkI7ZZB1632xd20pA70gOpFtg9sDlJvM=;
        b=scblHHAT0XR+REt7B5QCuvtRjTERaWgyTo+uEUDgcJQzF9F1QWHOEM80X0E5DWD4ho
         4hKIPkgJiClJp1Dll+G70dfX0e1+VCdGneZlgPdBISmH6dovn28pQcWmeE0bWWeD61HF
         GtHWNV7eOL1LvGYbHx/tP0seXlaEQr//KP3fAhG69bxgT4+x1Wxosmld4VWM69cYB56V
         jLzykeNJ/d+wNh2hlVut2zwslKgQqMa5taSJRStB6JB/jFIlRB5cz2HqShAay5w5nFe5
         E7bioDsVAvVbgqd+vYB9WAc/FbREMAL+IZnOJkLdqOX3nNnO+6oG/bAuUsN/pWNJ3l8j
         BeRw==
X-Gm-Message-State: APjAAAUkRlb59e++VEa22HnCTRvR0KCC3RBxS5BidMRG2G6+QeGRm8fL
        SLqd4uWtzHFcXQ87yQ+F0LhDqPdJ4QNfz12SbdQOdBE8g391K/8nQhr30wbycFH64+mznFYxrtp
        5ftPR4gbzgvRvk7DA
X-Received: by 2002:a1c:6308:: with SMTP id x8mr4076650wmb.140.1572512830194;
        Thu, 31 Oct 2019 02:07:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwfjaVx5Id/rjqKFiRz8/nIcvC1Gfp7404XpLuXKxzmGRZ2YVyve+OhEy7UlUWjEBX07Dmh7Q==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr4076626wmb.140.1572512829951;
        Thu, 31 Oct 2019 02:07:09 -0700 (PDT)
Received: from steredhat ([91.217.168.176])
        by smtp.gmail.com with ESMTPSA id x205sm3535236wmb.5.2019.10.31.02.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 02:07:09 -0700 (PDT)
Date:   Thu, 31 Oct 2019 10:07:07 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, sunilmut@microsoft.com, willemb@google.com,
        stefanha@redhat.com, ytht.net@gmail.com, arnd@arndb.de,
        tglx@linutronix.de, decui@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vsock: Simplify '__vsock_release()'
Message-ID: <20191031090707.ec33h3z6zhux3hbq@steredhat>
References: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 07:47:41AM +0100, Christophe JAILLET wrote:
> Use '__skb_queue_purge()' instead of re-implementing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/vmw_vsock/af_vsock.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 2ab43b2bba31..2983dc92ca63 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -641,7 +641,6 @@ EXPORT_SYMBOL_GPL(__vsock_create);
>  static void __vsock_release(struct sock *sk, int level)
>  {
>  	if (sk) {
> -		struct sk_buff *skb;
>  		struct sock *pending;
>  		struct vsock_sock *vsk;
>  
> @@ -662,8 +661,7 @@ static void __vsock_release(struct sock *sk, int level)
>  		sock_orphan(sk);
>  		sk->sk_shutdown = SHUTDOWN_MASK;
>  
> -		while ((skb = skb_dequeue(&sk->sk_receive_queue)))
> -			kfree_skb(skb);
> +		skb_queue_purge(&sk->sk_receive_queue);
>  
>  		/* Clean up any sockets that never were accepted. */
>  		while ((pending = vsock_dequeue_accept(sk)) != NULL) {

Good clean-up!

This patch LGTM:
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano
