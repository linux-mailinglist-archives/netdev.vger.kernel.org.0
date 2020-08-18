Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEDD247B9F
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 02:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHRAs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 20:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgHRAsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 20:48:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950E3C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 17:48:54 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r11so9081181pfl.11
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 17:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v+74K1oF+fDCWBcsW/Lw2tL+AlptR8x+ZdGL7IJOR98=;
        b=ou3LCu30hpLq2QKBdzULZWhqt5A6ujAUWW/wDeph970BwYJtnRjXzqCgjfMfjBpPNF
         WtlCsxTJ8ZVO4nhJuWn1mDozGTjSUhfVdrjUsHLxGEElhYRU8tOfItFoY+dYBCX5kxw3
         8WeM86Tnzp1EyvOpgd6USEsgpc7iZvDPgraCe8HDoHGhUBW2Bx52R411trd6psFljfb/
         /Mh19lKuC+H8eqa3eh0zs9jD4LcteHTmYPRXgV5d4y1erBsHutN7vhV2RPQTf/LXZEE+
         QyQPtZtvKViCaRCtgL42C2OqdZfLlKb6MtoCiZcagoM7eheVPLOtlYqtIA3DEreQJZdz
         58vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v+74K1oF+fDCWBcsW/Lw2tL+AlptR8x+ZdGL7IJOR98=;
        b=VVZDaKIhL3fHelYgIm36TmpEeT0et6IrpGlmWTp22yxEske7rAPtlUTs3+hS3UJyzI
         CSbP6XdlyuY939L+fSTJApHSRRCSVKYYQvF2O32As4IhyZ6MpylWXF3ilV0IRXgEV/7J
         hncbmFIF24llLxnoCJEakJdfcpb1wf2wdLrjiQHYuNnfpOyh2uqm0fCKe0dEomackoET
         bvl+86l4snwRAmlsBjmbHmBxbnHrtSdhVHRSnR8W9avEYDGWSxkolENESP8mW348+Xio
         xJ87l55Vh7Cm9fv36WVz2ztRV5dwXQSD1T7aXzJS4neElKRJcP1vxFtneLMrowlv2a7y
         EyRQ==
X-Gm-Message-State: AOAM531RKceMPM0Kt+xGLZDGwJ04pSjA8UyC7C0zu/O8rZ0xuHVaOox5
        rmLabwpXE2ORrSQ4zYg6q90=
X-Google-Smtp-Source: ABdhPJxOndjlyEOgkjLHXu3fBmR6YnQzbvgW0eObSbgXnmsYyleFTf2EgqCaASE1gH2XtkYtqxb/AQ==
X-Received: by 2002:aa7:96db:: with SMTP id h27mr13217849pfq.26.1597711734032;
        Mon, 17 Aug 2020 17:48:54 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g17sm18947183pjl.37.2020.08.17.17.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 17:48:53 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: lantiq: Use napi_complete_done()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
References: <20200815183314.404-1-hauke@hauke-m.de>
 <20200815183314.404-3-hauke@hauke-m.de>
 <17761534-65b1-e575-5e00-55e6f7e3f7b7@gmail.com>
 <718dce81-ace3-aaad-0f81-e75e227cd722@hauke-m.de>
 <28b6bd3f-761c-9143-e90d-30af5d76e3ed@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4d9fb110-f5b9-c279-6bac-d7663c8111b8@gmail.com>
Date:   Mon, 17 Aug 2020 17:48:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <28b6bd3f-761c-9143-e90d-30af5d76e3ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/20 5:33 PM, Eric Dumazet wrote:
> 
> 
> On 8/17/20 2:17 PM, Hauke Mehrtens wrote:
>> On 8/16/20 8:07 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 8/15/20 11:33 AM, Hauke Mehrtens wrote:
>>>> Use napi_complete_done() and activate the interrupts when this function
>>>> returns true. This way the generic NAPI code can take care of activating
>>>> the interrupts.
>>>>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> ---
>>>>  drivers/net/ethernet/lantiq_xrx200.c | 8 ++------
>>>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
>>>> index f34e4dc8c661..674ffb2ecd9a 100644
>>>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>>>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>>>> @@ -229,10 +229,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>>>>  		}
>>>>  	}
>>>>  
>>>> -	if (rx < budget) {
>>>> -		napi_complete(&ch->napi);
>>>> +	if (napi_complete_done(&ch->napi, rx))
>>>>  		ltq_dma_enable_irq(&ch->dma);
>>>> -	}
>>>>  
>>>>  	return rx;
>>>>  }
>>>> @@ -271,10 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
>>>>  	if (netif_queue_stopped(net_dev))
>>>>  		netif_wake_queue(net_dev);
>>>>  
>>>> -	if (pkts < budget) {
>>>> -		napi_complete(&ch->napi);
>>>> +	if (napi_complete_done(&ch->napi, pkts))
>>>>  		ltq_dma_enable_irq(&ch->dma);
>>>> -	}
>>>>  
>>>>  	return pkts;
>>>>  }
>>>>
>>>
>>>
>>> This looks buggy to me.
>>
>> Hi Eric,
>>
>> Thanks for looking at the patch.
>>
>> What exactly looks buggy to you?
> 
> You removed the " if (rx < budget) "
> 
> But you must not.
> 
> Drivers have to keep the test.
> 
> Something like that seems more correct :
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index 1645e4e7ebdbb3c7abff8fe4207273df20f123d4..e3d617d387ed0f5593c3ba81d1d531d463bb5a6e 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -230,8 +230,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>         }
>  
>         if (rx < budget) {
> -               napi_complete(&ch->napi);
> -               ltq_dma_enable_irq(&ch->dma);
> +               if (napi_complete(&ch->napi, rx))

Obviously : s/napi_complete/napi_complete_done/

> +                       ltq_dma_enable_irq(&ch->dma);
>         }
>  
>         return rx;
> @@ -269,8 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
>         netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
>  
>         if (pkts < budget) {
> -               napi_complete(&ch->napi);
> -               ltq_dma_enable_irq(&ch->dma);
> +               if (napi_complete(&ch->napi, pkts))

Same : s/napi_complete/napi_complete_done/


> +                       ltq_dma_enable_irq(&ch->dma);
>         }
>  
>         return pkts;
> 
