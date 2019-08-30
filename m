Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82130A3385
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfH3JQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:16:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38058 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfH3JQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 05:16:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so6665918wme.3
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 02:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OmOxyirVK5rhjoOTnMBnhiR2RwlcT8CA1ShL6vnmzuc=;
        b=OUFIxNBTzTtYNJLL+LVtYBSOykMMh9gf8rh7nyWvJxhIQGcT3iVTmtYhMYo6jN5/x8
         K2JLWywcx980clBZK8tEbv8wHiiTPObQeSrJyZ7K7wF2nKCsl4FG+Z4GHfnPO40Sebmr
         SvfSNjUeVVn2CvgZ/JmUDGNFs/Tmb8Gxra6J8Iy7KTSmFZFXLrGblmL42jnYgpUcaCh5
         sVbLKEs6bfq9Wqj3CW66fkf878qvN6Ef8h9Nb+xCaX+9OanaZkJcod//iJ1QvGG/HJBO
         PCxhp5Wa7WR3mmT44eem8Aw97qN8zkq8oNIA1BGZ0/vaWeAGKo6U1SrBhdCzUtNonuOD
         eBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OmOxyirVK5rhjoOTnMBnhiR2RwlcT8CA1ShL6vnmzuc=;
        b=qigAJeMDv2SuC4DXbPM65qosICOBULR/wH5DeKznXb5+pfgnTiyGiJAO1x6HkXIQPF
         AnQOp64sCcmNu4lq4HT0JOaZVJmCZPuJDApohZxOv3hPfwJUZEGhdstvXXFtzciWQfWu
         xUrVCvt6gPO8rM8UOe2qdAd9vnqFkrEhETmsv/S3eZ76ptaXxIrHiy0v23HfTo2zX1h7
         Bwt7Vw6WVqSsJh/2JBO0ZqBNa+ZE+DvVbiimNnkGfdp4FWSse9sVaXA7ryZI9UHx+Fu2
         7FNux+1Xbl8Gu2lEoxI9ruZnRnE6MqnFB3Cph0Zho8ZQm3KL5YW13Ljgd7KXY8+x6Fxa
         j0RQ==
X-Gm-Message-State: APjAAAXPkts2e4kMBhERY5JgEcFvJMbOsQfi9mcb3sIapH1st6wXKnKr
        vXPYMJeMAe9IvXQZDFBImqbeCHAP
X-Google-Smtp-Source: APXvYqwKXIbmTUSXfrXOoKwAKq/2GvESFuX0FS8GL7g5laulx7DP2kIvDw3oaqUVsp4MX1/iyJFlhQ==
X-Received: by 2002:a7b:cb03:: with SMTP id u3mr17399401wmj.58.1567156579939;
        Fri, 30 Aug 2019 02:16:19 -0700 (PDT)
Received: from [192.168.8.147] (31.169.185.81.rev.sfr.net. [81.185.169.31])
        by smtp.gmail.com with ESMTPSA id b136sm9840226wme.18.2019.08.30.02.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 02:16:19 -0700 (PDT)
Subject: Re: [PATCH net] dev: Delay the free of the percpu refcount
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        eric.dumazet@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>
References: <1567142596-25923-1-git-send-email-subashab@codeaurora.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <959f4b3e-387d-a148-3281-aed26a6a7aa5@gmail.com>
Date:   Fri, 30 Aug 2019 11:16:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567142596-25923-1-git-send-email-subashab@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/19 7:23 AM, Subash Abhinov Kasiviswanathan wrote:
> While running stress-ng on an ARM64 kernel, the following oops
> was observedi -
> 
> 44837.761523:   <6> Unable to handle kernel paging request at
>                      virtual address 0000004a88287000
> 44837.761651:   <2> pc : in_dev_finish_destroy+0x4c/0xc8
> 44837.761654:   <2> lr : in_dev_finish_destroy+0x2c/0xc8
> 44837.762393:   <2> Call trace:
> 44837.762398:   <2>  in_dev_finish_destroy+0x4c/0xc8
> 44837.762404:   <2>  in_dev_rcu_put+0x24/0x30
> 44837.762412:   <2>  rcu_nocb_kthread+0x43c/0x468
> 44837.762418:   <2>  kthread+0x118/0x128
> 44837.762424:   <2>  ret_from_fork+0x10/0x1c
> 
> Prior to this, it appeared as if some of the inet6_dev allocations
> were failing. From the memory dump, the last operation performed
> was dev_put(), however the pcpu_refcnt was NULL while the
> reg_state = NETREG_RELEASED. Effectively, the refcount memory was
> freed in free_netdev() before the last reference was dropped.
> 
> Fix this by freeing the memory after all references are dropped and
> before the dev memory itself is freed.
> 
> Fixes: 29b4433d991c ("net: percpu net_device refcount")
> Cc: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  net/core/dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 49589ed..bce40d8 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9128,6 +9128,9 @@ void netdev_freemem(struct net_device *dev)
>  {
>  	char *addr = (char *)dev - dev->padded;
>  
> +	free_percpu(dev->pcpu_refcnt);
> +	dev->pcpu_refcnt = NULL;
> +
>  	kvfree(addr);
>  }
>  
> @@ -9272,9 +9275,6 @@ void free_netdev(struct net_device *dev)
>  	list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
>  		netif_napi_del(p);
>  
> -	free_percpu(dev->pcpu_refcnt);
> -	dev->pcpu_refcnt = NULL;
> -
>  	/*  Compatibility with error handling in drivers */
>  	if (dev->reg_state == NETREG_UNINITIALIZED) {
>  		netdev_freemem(dev);
> 

This looks bogus.

Whatever layer tries to access dev refcnt after free_netdev() has been called is buggy.

I would rather trap early and fix the root cause.

Untested patch :

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b5d28dadf964..8080f1305417 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3723,6 +3723,7 @@ void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
+       BUG_ON(!dev->pcpu_refcnt);
        this_cpu_dec(*dev->pcpu_refcnt);
 }
 
@@ -3734,6 +3735,7 @@ static inline void dev_put(struct net_device *dev)
  */
 static inline void dev_hold(struct net_device *dev)
 {
+       BUG_ON(!dev->pcpu_refcnt);
        this_cpu_inc(*dev->pcpu_refcnt);
 }
 

