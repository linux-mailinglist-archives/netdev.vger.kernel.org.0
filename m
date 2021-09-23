Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0704163E4
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbhIWRLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242343AbhIWRK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 13:10:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16563C061574;
        Thu, 23 Sep 2021 10:09:28 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 17so6996409pgp.4;
        Thu, 23 Sep 2021 10:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQOyTrPWpuoR0qjRwY2/Pk+PGAik9H+Dp0um2iO+NWk=;
        b=AzeTNk4Xsxez7OMYnIujebqjThOfoyvbw7+K81cNzXRuS8/WSQHX5R3sHFuIGSsBPa
         7Aa+ihvXF9NVEsmKlnxSzOn/aJhIiMuudgdRNKojjhRjBqE9mOmatyvqRu7sGyAiFYai
         tXMyaRFr/GuqlOIE1QMSXk3QMWik9J9cFU9UjjGNA552qXjo/dQWMQcoXjvrjfH7qXXT
         KRO/YuWReJPj29hE4LaAlE1Y9HM12YkgGR+ZiqfAzXy2RBzduY0q/3+oBawhqKeioDbd
         kofU3RuH6BrDlFBZMbPTqx+OHoKcWBbhxnCo1wcN86tybrA7BtswJsu8z+GiQ03JAPb1
         eC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQOyTrPWpuoR0qjRwY2/Pk+PGAik9H+Dp0um2iO+NWk=;
        b=gN/rgYFxf24jsSntLDR7lZn31iyC1Pmcu9AFYKoIqqtS2lbRGQClzNQ9iBfsQNCBOV
         0h9Q6Kj8dptTHz707I6KlPGhlB7go7vI/j12gKQjsxZwNCl00P9+9xdRrQ4f8hNp5TgB
         AhMcgNYIcKl0nTS14BFJARfn15bgh8JfA/rhpD/7/r4OIm8OnmFtojGpBpTj4y4/G5JI
         v6UnB2zVy2+i6+Rc2XSrrFMlCJs/NKs8wuBeptICs/vAenJX1T5+n0BOfX8LXsqm0ohr
         vCBI6RNlVGNIpXsVtmjoQQvGTif9W+M04PLmzEvcYqDOp4rdvDlKtBqy+h6q7zvWrpUn
         pWEw==
X-Gm-Message-State: AOAM532enQcqKaSnXAdRFiVsYfcfsBgFOy1uPKiCh7pUhHTH43T1YZ1T
        k/T4UuCMvRQBSCF3MY9QkG4NN2GLM4o=
X-Google-Smtp-Source: ABdhPJzE1lualTU79piPX8UlNwZ68F8W1spoATcV9dMUVHXMzw2XVSk6BelCnHdh/PSKffkJ8eN/lA==
X-Received: by 2002:a05:6a00:14c5:b0:447:aa13:b71f with SMTP id w5-20020a056a0014c500b00447aa13b71fmr5700154pfu.40.1632416967117;
        Thu, 23 Sep 2021 10:09:27 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z25sm6230526pfj.199.2021.09.23.10.09.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 10:09:26 -0700 (PDT)
Subject: Re: [PATCH net-next] net: rtnetlink: convert rcu_assign_pointer to
 RCU_INIT_POINTER
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210918063607.23681-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <94c26a4b-4a39-fcc8-60e4-880fe80c4443@gmail.com>
Date:   Thu, 23 Sep 2021 10:09:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210918063607.23681-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/21 11:36 PM, Yajun Deng wrote:
> It no need barrier when assigning a NULL value to an RCU protected
> pointer. So use RCU_INIT_POINTER() instead for more fast.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/rtnetlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 972c8cb303a5..327ca6bc6e6d 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -301,7 +301,7 @@ int rtnl_unregister(int protocol, int msgtype)
>  	}
>  
>  	link = rtnl_dereference(tab[msgindex]);
> -	rcu_assign_pointer(tab[msgindex], NULL);
> +	RCU_INIT_POINTER(tab[msgindex], NULL);
>  	rtnl_unlock();
>  
>  	kfree_rcu(link, rcu);
> @@ -337,7 +337,7 @@ void rtnl_unregister_all(int protocol)
>  		if (!link)
>  			continue;
>  
> -		rcu_assign_pointer(tab[msgindex], NULL);
> +		RCU_INIT_POINTER(tab[msgindex], NULL);
>  		kfree_rcu(link, rcu);
>  	}
>  	rtnl_unlock();
> 

FYI, there is no memory barrier involved in 

rcu_assign_pointer(tab[msgindex], NULL);

This has been the case for the last 5 years.

Your patch was not needed really.
