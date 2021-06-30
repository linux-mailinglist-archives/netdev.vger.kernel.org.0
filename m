Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D806D3B89CA
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 22:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhF3UjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 16:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhF3UjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 16:39:23 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842ECC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 13:36:54 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g7so5204846wri.7
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 13:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bSbzwZx8e+nfocMIZerQ9GaOcy8l+TaARcL2+vs0EiU=;
        b=frRrUt3+xkGDAPJCQ5AMdEdhw8NTJfEVPqnv4t5Fx8piTyHH8S9Yp8tEfEHQi4CuI+
         AXdJUqGj1pdKRfv7tePHhp/nMqhig/1pXbqC6jZRS7/oKLBOm3Q3w5JEvtWNYKEpqAqL
         A2Tc3ZAD+3gLt2RLMBtAhZpEynxFv7xDedwWsEBDiEfGIaqVSlY2chCR6sRPck3qrr9G
         myBYa486w1SWLRtqmo9kKpW37SEbuAVG2uxZ7105vPW1w4ZV2N7xtSpsn6NytUYNyd/x
         katXuzSBTdy6yjxDJtyD6U5xW9BpxQvbQ/lUTEpgH89NMR3YXjPRI5+jvvGKhj1XiaRu
         WKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bSbzwZx8e+nfocMIZerQ9GaOcy8l+TaARcL2+vs0EiU=;
        b=WZy98EZ5Lkc/reDTyJQN3GUzj0pa9+LVYCr2TFMi88O0XySKSi9nilpmjbYV0QSxcG
         0nw25WjNQKl+2oRl5/EeRS4+qfQgDS1syrIISkFXzSxMYu9WopoAHSfqpmPiaLA4uO1k
         clQS0YKw0seIQWZBjC8MjgNx0fVnU6YK8apWcRiergCKHDQMt5HP2YGEONP+fW6ZiCMd
         l+sCF6i0KpZdtBxiYjVX9qWwiwVmpB7dLHC2236vHXzyLW4ZXn2em0oZkdstdXX1sXRG
         IpIcSDSg8M1twNo5ISDYhNcyZPUgRjcU9Jfrzg7B9JV3EgVjaQgrbd7TGQSeu7j+bx4A
         j2Fg==
X-Gm-Message-State: AOAM53340x0JoWIjp3kSOlCoW8gSXrT1k1rBQ3eYDdxtQVIIRiv+OGaF
        Nc31eLahIe9XMnqJpP9kqNg=
X-Google-Smtp-Source: ABdhPJx/kjpHjzp+3GjE1hsRq40CLzpgrA3wndnolh3azSYgNL2iG9SwvDP/nxUF3ryhbfiXmvmw5A==
X-Received: by 2002:a05:6000:1b0e:: with SMTP id f14mr20268610wrz.335.1625085413216;
        Wed, 30 Jun 2021 13:36:53 -0700 (PDT)
Received: from [192.168.98.98] (209.104.23.93.rev.sfr.net. [93.23.104.209])
        by smtp.gmail.com with ESMTPSA id k5sm22855535wmk.11.2021.06.30.13.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:36:52 -0700 (PDT)
Subject: Re: [PATCH 4/5] net: wwan: iosm: fix netdev tx stats
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
References: <20210630182748.3481-1-m.chetan.kumar@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dbef867f-6333-d1f7-0f33-98582af7bdf8@gmail.com>
Date:   Wed, 30 Jun 2021 22:36:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630182748.3481-1-m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/21 8:27 PM, M Chetan Kumar wrote:
> Update tx stats on successful packet consume, drop.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> index 84e37c4b0f74..561944a33725 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -123,6 +123,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
>  
>  	/* Return code of zero is success */
>  	if (ret == 0) {
> +		netdev->stats.tx_packets++;
> +		netdev->stats.tx_bytes += skb->len;

What makes you think skb has not been consumed already ?
It seems clear it has been given, this thread can not expect skb has not been mangled/freed.
skb->len might now contain garbage, or even crash the kernel under appropriate debug features.

>  		ret = NETDEV_TX_OK;
>  	} else if (ret == -EBUSY) {
>  		ret = NETDEV_TX_BUSY;
> @@ -140,7 +142,8 @@ static int ipc_wwan_link_transmit(struct sk_buff *skb,
>  			ret);
>  
>  	dev_kfree_skb_any(skb);
> -	return ret;
> +	netdev->stats.tx_dropped++;
> +	return NETDEV_TX_OK;
>  }
>  
>  /* Ops structure for wwan net link */
> 
