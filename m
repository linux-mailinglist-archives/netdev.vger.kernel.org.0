Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682CBEAC9D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJaJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:36:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33617 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbfJaJgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:36:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id y127so4070123lfc.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 02:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wgyP5K8XSgBVkPXgCWfubE2yzRzdB25VvAHZgFQv1M4=;
        b=vK/5pEsUfR4cEvCUmJggtsiAq2V4ibpuiYmmHPnDBXW2aM0dBLV8lL0AH1WuPcFVs6
         EZ8NSJ6adonRQCHZHtK5+MKs2uqP2JOysiiTsQBhjii98UDGZXwHmfFYSIn1ZUSOmyq0
         wYDL9yBUzAC4+bKha+F7+268MKD6Iq5FzRQt/kKeHiv1H/ecbjH/1+NcuIv5qResqFzv
         G4MywuzRi4k3HZuaa8c9pIay5kYng89o1hiOLtfNMDQPBZTXNpaOmgEGrcm0mjG7BleK
         oKlycpkggpcr7mwLFfpbYrr9/nzMlSboLvz2H+MT4HxSOJJRv7IWZb/FXtWd3680qC8n
         LsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wgyP5K8XSgBVkPXgCWfubE2yzRzdB25VvAHZgFQv1M4=;
        b=UaJWrZin0w1t/GmGNerJ7yMFE3l0G9Hax4Jg+uAMCSEDITS8YsKG7Ln7WkkmxmnP18
         Acp5SHQTGr5+0LTmdyQW95BwUxOqZehQK6P2yJZ/mZZs5aedr+5oSGmHvNr4I5/+u8nB
         oLmBB2+n++Trq3lBJiN2/iiSrAfqetiTJRcZ32znHfYB3qygLu5jz9jo+Lx3K9Ezw+Ec
         JOeR0L/jZCcfOCBQRsoFFx994BFPryRAsm6RcOXVF5p6hUBtQHuwrRMOnl6ExrajZG4g
         fWywYyE6FHaG6/xcr+JO9SVJn+yqO34lki6I5MK1j7AyEXo/Ue91t3Hwgn+1BOdkP1gp
         1S4Q==
X-Gm-Message-State: APjAAAX9J5u9DsGdmaWMPsvDIMYYdKuJv2H0yFP0pGg25fXN52ZkQ8ZR
        7/eFKf9iUTV3dC/punu6RXiA5g==
X-Google-Smtp-Source: APXvYqzlcES4u3+SBBCAztG7H3ClzN9Y1hcKkIaigP31xwNCtRHDIOJsYLSn85zRdFxtKrjYBKwVRA==
X-Received: by 2002:ac2:5f0a:: with SMTP id 10mr2699731lfq.57.1572514602594;
        Thu, 31 Oct 2019 02:36:42 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4225:b18c:bdc4:9185:f589:ee11? ([2a00:1fa0:4225:b18c:bdc4:9185:f589:ee11])
        by smtp.gmail.com with ESMTPSA id p193sm2680682lfa.18.2019.10.31.02.36.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 02:36:41 -0700 (PDT)
Subject: Re: [PATCH] vsock: Simplify '__vsock_release()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        davem@davemloft.net, sunilmut@microsoft.com, willemb@google.com,
        sgarzare@redhat.com, stefanha@redhat.com, ytht.net@gmail.com,
        arnd@arndb.de, tglx@linutronix.de, decui@microsoft.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c7a0b6b0-96cd-1fd3-3d98-94a3692bda38@cogentembedded.com>
Date:   Thu, 31 Oct 2019 12:36:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 31.10.2019 9:47, Christophe JAILLET wrote:

> Use '__skb_queue_purge()' instead of re-implementing it.

    In don't see that double underscore below...

> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   net/vmw_vsock/af_vsock.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 2ab43b2bba31..2983dc92ca63 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
[...]
> @@ -662,8 +661,7 @@ static void __vsock_release(struct sock *sk, int level)
>   		sock_orphan(sk);
>   		sk->sk_shutdown = SHUTDOWN_MASK;
>   
> -		while ((skb = skb_dequeue(&sk->sk_receive_queue)))
> -			kfree_skb(skb);
> +		skb_queue_purge(&sk->sk_receive_queue);
>   
>   		/* Clean up any sockets that never were accepted. */
>   		while ((pending = vsock_dequeue_accept(sk)) != NULL) {

MBR, Sergei
