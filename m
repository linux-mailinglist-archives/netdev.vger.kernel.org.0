Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD95253F10
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgH0HZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgH0HZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 03:25:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91463C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:25:36 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t14so4173097wmi.3
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 00:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BY7cUVXro+sL6QOojQsrNJIxdX/3hgp6XJ4jDEJJNMk=;
        b=fqhZui15OTrYRJADBtVe9GjCipRqTQVii/i0SH0dP+PaG4tOSwpauuf1FwURH2WG0k
         nRtNLBU8HXlAsSX1Zccj33BSpwsDNnpBnioQwkwVD6eBsWFoBDGq5+9SDi7QM9w8YMio
         unAVT/UchlF3S4HbaYBpZ3tEAVaR/mQbfhBrPWg0570iylpqvYhwzoAUNwKzXqxtoF82
         ivCyXFgY+lOSmtXPMh9IKl9mq4ruXtGRtWAVI+2+o23RAJRn+vQHnqK3y4Xy8IxLBCtF
         kzuKFsuf5YM9eJpY5rvitwQ1Q9B37AF1yy7w1deSGWewjnqVbH6Nd2eLCyFaodVrjdLx
         JzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BY7cUVXro+sL6QOojQsrNJIxdX/3hgp6XJ4jDEJJNMk=;
        b=D0ICGh5ysNJfKZgfFKX8xHHf1x9uTJIK1rPWVgmeDpMIdWv2KfG++L6o/DNsJApPyY
         IDsy+yQlBnRDkkV3V5SZ8OzCBAbjaQEZvovmJ27OZWGv5GurtiK9nwZVn8dDwdWQfYIi
         bR+N4JqtjMwp+O71ZX5OdlpY0muKlD7rhypC1INwNT7YtNqTH3usd0YgkYGetcB+jp0n
         zo5yFs4YStvqs6hDvtfTA/bNBT+XsNHUzc8ABU9OomjQnzthaaugOiwmslfJClNJpz6F
         IzvbCVp5rn3km0LDsDS5ef/S+Ept6AWi1H3U99obaUu0/BcWikrLAW8bZt2Nq8I6tenc
         fRgA==
X-Gm-Message-State: AOAM531caBdk1lwPckrxIxiYFb9tf7T+Gm4x8fm7Lb+g5JWwk64Uny4x
        1IvZc2iNA6dZP6LUV/tYDes=
X-Google-Smtp-Source: ABdhPJz1DZ/ww9aYJadMry0qGnnVy77FWdorChkaAKWXAsLialgmmzd/00ExJZNAiOdFjO85dI5VTw==
X-Received: by 2002:a7b:c8cc:: with SMTP id f12mr4263967wml.169.1598513133620;
        Thu, 27 Aug 2020 00:25:33 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.26.29])
        by smtp.gmail.com with ESMTPSA id t14sm4519726wrg.38.2020.08.27.00.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 00:25:32 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: disable netpoll on fresh napis
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     eric.dumazet@gmail.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Rob Sherwood <rsher@fb.com>
References: <20200826194007.1962762-1-kuba@kernel.org>
 <20200826194007.1962762-2-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <25872247-9776-2638-cf83-a51861ce5cd4@gmail.com>
Date:   Thu, 27 Aug 2020 00:25:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200826194007.1962762-2-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/20 12:40 PM, Jakub Kicinski wrote:
> napi_disable() makes sure to set the NAPI_STATE_NPSVC bit to prevent
> netpoll from accessing rings before init is complete. However, the
> same is not done for fresh napi instances in netif_napi_add(),
> even though we expect NAPI instances to be added as disabled.
> 
> This causes crashes during driver reconfiguration (enabling XDP,
> changing the channel count) - if there is any printk() after
> netif_napi_add() but before napi_enable().
> 
> To ensure memory ordering is correct we need to use RCU accessors.
> 
> Reported-by: Rob Sherwood <rsher@fb.com>
> Fixes: 2d8bff12699a ("netpoll: Close race condition between poll_one_napi and napi_disable")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev.c     | 3 ++-
>  net/core/netpoll.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d42c9ea0c3c0..95ac7568f693 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6612,12 +6612,13 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  		netdev_err_once(dev, "%s() called with weight %d\n", __func__,
>  				weight);
>  	napi->weight = weight;
> -	list_add(&napi->dev_list, &dev->napi_list);
>  	napi->dev = dev;
>  #ifdef CONFIG_NETPOLL
>  	napi->poll_owner = -1;
>  #endif
>  	set_bit(NAPI_STATE_SCHED, &napi->state);
> +	set_bit(NAPI_STATE_NPSVC, &napi->state);
> +	list_add_rcu(&napi->dev_list, &dev->napi_list);
>  	napi_hash_add(napi);
>  }
>  EXPORT_SYMBOL(netif_napi_add);
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index 093e90e52bc2..2338753e936b 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -162,7 +162,7 @@ static void poll_napi(struct net_device *dev)
>  	struct napi_struct *napi;
>  	int cpu = smp_processor_id();
>  
> -	list_for_each_entry(napi, &dev->napi_list, dev_list) {
> +	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
>  		if (cmpxchg(&napi->poll_owner, -1, cpu) == -1) {
>  			poll_one_napi(napi);
>  			smp_store_release(&napi->poll_owner, -1);
> 

You added rcu in this patch (without anything in the changelog).

netpoll_poll_dev() uses rcu_dereference_bh(), suggesting you might need list_for_each_entry_rcu_bh()



