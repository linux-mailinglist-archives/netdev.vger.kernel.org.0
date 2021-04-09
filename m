Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD00435A72A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhDITdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbhDITdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:33:07 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1879DC061762
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 12:32:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e7so7806839edu.10
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 12:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Krm9TysnA9QTUw0WAMt/iHDLSmVCZjo5giWY5TPQLsc=;
        b=GdXl1NHdyGZ2/gae4X2zmagDwC0Lc0Hay/sPIVLQUm/U6nDYX96RppYpTlRb951VO9
         prqFKp2u5V3POCOObfPTUPrdnHvE3kAV3vR0QpoI+ljS5fVGhDeRWCGjjkXGOpNWcgdB
         ffKLUIlzCYnm80Zznc7Y5iFI5TK9DsreW/kWob5Oq+3fZKy0bzXvOYqee7TsrHmJ5yas
         lNrW48tWVcPXeDkGOjefXxnKJwKavysy8j08prg02IMJ5malvnw9hdH9wA0t/RnlBipq
         8Dm7xiv8V4BYmgIJsHIuve6q9ELhqCMyuADR7QdVpRRA9io1BKI6RDQcV0IVSCMe51zv
         WAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Krm9TysnA9QTUw0WAMt/iHDLSmVCZjo5giWY5TPQLsc=;
        b=Uzi2Gqbjb+DY1WVOaT2iH/weNQtwzs7/WlYs/lEVaEBb3gbLekNlCxHsNFBmwTbCsu
         0meADDqxdXBOVUbg7bjpmez0V424tqbOS6I5k4T23Pe7NEBsW053ddyTZIxT6eJrFDpS
         h1mkqec5aayKhToDEVaedhEH5Nr7YtiCcJaBPSPpjyCdOq2JZlmTII5wOLLL8c0qe7x5
         /fHr0AnqWhJaSB0i9nCB9VpitEmcDJ2NZLFJStTFXvBNVZIKULoMCozI0ktEbGOWSLyG
         vSfQ13j90vw7b3etI8H+EJcILIRXXAj/kmv5Jef91cF+KJIBruTQSz6arp7mtyrtxa+8
         44JQ==
X-Gm-Message-State: AOAM533ckB32uiq+/q3Y+gw01+dK2l7V38bq1+riaIVVPbT5gLkuuSZS
        jwBixCqGXOFT3Xd1+Wa2ef0=
X-Google-Smtp-Source: ABdhPJw+UM0qD9WaFLsy56gvEuxkMw8fBwlC+UGLwV7ACnSr/R/stis1nWA2tfVcSFV402HwRGNCAA==
X-Received: by 2002:a05:6402:3506:: with SMTP id b6mr19442392edd.175.1617996771148;
        Fri, 09 Apr 2021 12:32:51 -0700 (PDT)
Received: from [192.168.0.108] ([82.137.32.50])
        by smtp.gmail.com with ESMTPSA id y21sm1931353edv.31.2021.04.09.12.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 12:32:50 -0700 (PDT)
Subject: Re: [net-next, v2, 2/2] enetc: support PTP Sync packet one-step
 timestamping
To:     Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
References: <20210408111350.3817-1-yangbo.lu@nxp.com>
 <20210408111350.3817-3-yangbo.lu@nxp.com>
 <20210408090250.21dee5c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210408090708.7dc9960f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <AM0PR04MB6754A7B847379CC8DC3D855196739@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20210409090939.0a2c0325@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <a9a755f3-9a44-83d5-4426-1238c96c8e15@gmail.com>
Date:   Fri, 9 Apr 2021 22:32:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210409090939.0a2c0325@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.04.2021 19:09, Jakub Kicinski wrote:
> On Fri, 9 Apr 2021 06:37:53 +0000 Claudiu Manoil wrote:
>>> On Thu, 8 Apr 2021 09:02:50 -0700 Jakub Kicinski wrote:
>>>> 		if (priv->flags & ONESTEP_BUSY) {
>>>> 			skb_queue_tail(&priv->tx_skbs, skb);
>>>> 			return ...;
>>>> 		}
>>>> 		priv->flags |= ONESTEP_BUSY;
>>>
>>> Ah, if you have multiple queues this needs to be under a separate
>>> spinlock, 'cause netif_tx_lock() won't be enough.
>>
>> Please try test_and_set_bit_lock()/ clear_bit_unlock() based on Jakub's
>> suggestion, and see if it works for you / whether it can replace the mutex.
> 
> I was thinking that with multiple queues just a bit won't be sufficient
> because:
> 
> xmit:				work:
> test_bit... // already set
> 				dequeue // empty
> enqueue
> 				clear_bit()
> 
> That frame will never get sent, no?

I don't see any issue with Yangbo's initial design actually, I was just
suggesting him to replace the mutex with a bit lock, based on your comments.
That means:
xmit:		work:				clean_tx_ring: //Tx conf
skb_queue_tail()		
		skb_dequeue()
		test_and_set_bit_lock()
						clear_bit_unlock()

The skb queue is one per device, as it needs to serialize ptp skbs
for that device (due to the restriction that a ptp packet cannot be 
enqueued for transmission if there's another ptp packet waiting
for transmission in a h/w descriptor ring).

If multiple ptp skbs are coming in from different xmit queues at the 
same time (same device), they are enqueued in the common priv->tx_skbs 
queue (skb_queue_tail() is protected by locks), and the worker thread is 
started.
The worker dequeues the first ptp skb, and places the packet in the h/w 
descriptor ring for transmission. Then dequeues the second skb and waits 
at the lock (or mutex or whatever lock is preferred).
Upon transmission of the ptp packet the lock is released by the Tx 
confirmation napi thread (clean_tx_ring()) and the next PTP skb can be 
placed in the corresponding descriptor ring for transmission by the 
worker thread.

So the way I understood your comments is that you'd rather use a spin 
lock in the worker thread instead of a mutex.

> 
> Note that skb_queue already has a lock so you'd just need to make that
> lock protect the flag/bit as well, overall the number of locks remains
> the same. Take the queue's lock, check the flag, use
> __skb_queue_tail(), release etc.
> 

This is a good optimization idea indeed, to use the priv->tx_skb skb 
list's spin lock, instead of adding another lock.
