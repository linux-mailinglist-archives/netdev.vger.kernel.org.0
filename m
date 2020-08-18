Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564BD247B88
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRAd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 20:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgHRAdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 20:33:55 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29165C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 17:33:55 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so8383839plr.7
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 17:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aFd0BLJFJjJJbxWdUwVWnP6GU2t34utjw2EDMc4/Xss=;
        b=Oise4o31OuwmwXhk9H72aMSYzEe/gwUl96xTEDbQ9JEebHfRhzgrgenRMR65VkgvtR
         yCi6EJD9CX4tyBWkFrSix+pr2BsqEaNFor3Oh9MhNdk5y1dguxFFmCEM53noWgM3qQMN
         bv+7LjPpvcXC0mp9hqyubMnYzD90d1M/+r6mkw8VLWPzT8GxtEXvxjOnmZIkZF8s8zk+
         m3pp7xEIkoNs3+vbxlFh111ma4QYLgusjQaYKHi24/OUsk6CYmtvOQDNZ9Jh5KwSYHVI
         GMUGJdOp5fGWH4WHyjVu4OYGIAhu1yH7IOgljeKXKCV5EnEZGNNSOuuGxTXOMZ1GK8Hb
         Ayqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aFd0BLJFJjJJbxWdUwVWnP6GU2t34utjw2EDMc4/Xss=;
        b=XiSY3a9jji/31YKNh920BRhiGC2agjMLmie4yrcP9e10wPHQ4Zvd4SCMUW2UFMsOYA
         QKuOIw8Q6pYHX7IGvUDK6xLZNVE3GHRT2MDVZtCWWjt+3aXP69JgYS+PrNAQXImDXEMw
         2S63kQQgZ7vkvc+EOvEKUt7HJ8XEy3GZurX4MQ5tZ8Ue077yods8g2N0KS2ZfnGS7IPA
         rULt+oWs6NI7sOBVADis/21ZzrScrluVFz5VhIyffNawJ895dhcDbsxdhS5l5eLPlepA
         sDeoQvzYtgh03WN6eXj3prV8FXtqp3Jm/xOHD+LGY/53L5JMX9zpbPjCFjYOO1BSw3R0
         /Qaw==
X-Gm-Message-State: AOAM533SOC0fHxbeIx+iUasiCXFUqF16w/jZyQ29h2LBUBxsU/LaiNx/
        bzealOav1dt8GQ2qd4FuS0o=
X-Google-Smtp-Source: ABdhPJwf7BK+PIRuh00n7/qzWoA/H4xR3TeMIONZ7bJ1Zl2DOS0MIX5b8vAk5m6u+CcRGNPoqSbJBA==
X-Received: by 2002:a17:90b:3197:: with SMTP id hc23mr14341559pjb.60.1597710834712;
        Mon, 17 Aug 2020 17:33:54 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x127sm21687362pfd.86.2020.08.17.17.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 17:33:53 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: lantiq: Use napi_complete_done()
To:     Hauke Mehrtens <hauke@hauke-m.de>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com
References: <20200815183314.404-1-hauke@hauke-m.de>
 <20200815183314.404-3-hauke@hauke-m.de>
 <17761534-65b1-e575-5e00-55e6f7e3f7b7@gmail.com>
 <718dce81-ace3-aaad-0f81-e75e227cd722@hauke-m.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <28b6bd3f-761c-9143-e90d-30af5d76e3ed@gmail.com>
Date:   Mon, 17 Aug 2020 17:33:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <718dce81-ace3-aaad-0f81-e75e227cd722@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/20 2:17 PM, Hauke Mehrtens wrote:
> On 8/16/20 8:07 PM, Eric Dumazet wrote:
>>
>>
>> On 8/15/20 11:33 AM, Hauke Mehrtens wrote:
>>> Use napi_complete_done() and activate the interrupts when this function
>>> returns true. This way the generic NAPI code can take care of activating
>>> the interrupts.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> ---
>>>  drivers/net/ethernet/lantiq_xrx200.c | 8 ++------
>>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
>>> index f34e4dc8c661..674ffb2ecd9a 100644
>>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>>> @@ -229,10 +229,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>>>  		}
>>>  	}
>>>  
>>> -	if (rx < budget) {
>>> -		napi_complete(&ch->napi);
>>> +	if (napi_complete_done(&ch->napi, rx))
>>>  		ltq_dma_enable_irq(&ch->dma);
>>> -	}
>>>  
>>>  	return rx;
>>>  }
>>> @@ -271,10 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
>>>  	if (netif_queue_stopped(net_dev))
>>>  		netif_wake_queue(net_dev);
>>>  
>>> -	if (pkts < budget) {
>>> -		napi_complete(&ch->napi);
>>> +	if (napi_complete_done(&ch->napi, pkts))
>>>  		ltq_dma_enable_irq(&ch->dma);
>>> -	}
>>>  
>>>  	return pkts;
>>>  }
>>>
>>
>>
>> This looks buggy to me.
> 
> Hi Eric,
> 
> Thanks for looking at the patch.
> 
> What exactly looks buggy to you?

You removed the " if (rx < budget) "

But you must not.

Drivers have to keep the test.

Something like that seems more correct :

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 1645e4e7ebdbb3c7abff8fe4207273df20f123d4..e3d617d387ed0f5593c3ba81d1d531d463bb5a6e 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -230,8 +230,8 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
        }
 
        if (rx < budget) {
-               napi_complete(&ch->napi);
-               ltq_dma_enable_irq(&ch->dma);
+               if (napi_complete(&ch->napi, rx))
+                       ltq_dma_enable_irq(&ch->dma);
        }
 
        return rx;
@@ -269,8 +269,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
        netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
 
        if (pkts < budget) {
-               napi_complete(&ch->napi);
-               ltq_dma_enable_irq(&ch->dma);
+               if (napi_complete(&ch->napi, pkts))
+                       ltq_dma_enable_irq(&ch->dma);
        }
 
        return pkts;

