Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5E34850E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238939AbhCXXIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238945AbhCXXHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 19:07:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C2EC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 16:07:53 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id w3so35614439ejc.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 16:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qsd1JhWJpf1ciVxoWsFClx+NuXVu7rG/32rKvOz9phI=;
        b=aL7wSNdXde3VZhmK7DowPJskT+hBYh7uCr3EA6njTzh5lxFu9m1Ef5xt+4Q5FhGRcO
         mkaLL7c9g6JkXCBb5qobvCDIVFigm92A5nKVuHh+PzhETNA3YkLKieVmX1ujwscbcrR6
         GsSYpCR8ldUK6owZqKPmsRTT92KtnYJALXs88yIZtiI2aAJqJpvpYrhwEUhKI7SdCYMP
         8xx8m9REwEGvq5k1LbkXNYdTvWmZaF/DwhtUXW05CFdTrLmYYjxdqYo4VE89L6I9UOVh
         k/wxmGQ89znt0Gm+VyH9cAEUy8UtwZELQgbAdqrVDuRQGt+/5BdJygb3BfnmLcw9dFT6
         aMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qsd1JhWJpf1ciVxoWsFClx+NuXVu7rG/32rKvOz9phI=;
        b=Qhefp7GYxHkGSmMUPkPkDbQpew3qQ/rvIkKmT/6m/vN2NI46Nt8nBgZXmmMcg4MOHQ
         6nBCzoV1QcsYmbzXvo4bXKUMWgmXRV1hYIgOpMPxoj+DdqDsdw4luot7hGQS4ByfBLPy
         iLCkxZHuiXzsQ1eLOMm4bCgBUA+NbBgTXDvr6nP9yvyScha8Z29QDMrrt9pkL54eGvYC
         iJsig5FXQBqAG1fu2YLI697Kg0HI9tSQnWGdqz0uDHI4MwHkb7CRDLv4EALMaAUm0F99
         PigNdafvooVhiRkOHwrzVjum3ywgQO+xNIEv5EggyCjvfus9U7aa0zttyD+GbMCTS2+D
         3tYw==
X-Gm-Message-State: AOAM530NJuFhfhhenP+j3c+c0woIOTdThjMIDVDgKTK+iau9Q6qVvqjo
        LbyhB4ZGCZpv7NheI92EC5A=
X-Google-Smtp-Source: ABdhPJxm1BdZQW9wu7P/EGr33FiJBdyRYeoh7tflPHJUudBNRQySSW5i0P3TgzD0WC0Om6Sq0C40fg==
X-Received: by 2002:a17:906:5597:: with SMTP id y23mr6280894ejp.165.1616627271958;
        Wed, 24 Mar 2021 16:07:51 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g22sm1581650ejm.69.2021.03.24.16.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 16:07:51 -0700 (PDT)
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
 <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
 <20210324222114.4uh5modod373njuh@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7510c29a-b60f-e0d7-4129-cb90fe376c74@gmail.com>
Date:   Wed, 24 Mar 2021 16:07:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324222114.4uh5modod373njuh@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 3:21 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Wed, Mar 24, 2021 at 02:09:02PM -0700, Florian Fainelli wrote:
>>
>>
>> On 3/24/2021 1:13 PM, Vladimir Oltean wrote:
>>> Hi Martin,
>>>
>>> On Wed, Mar 24, 2021 at 09:04:16PM +0100, Martin Blumenstingl wrote:
>>>> Hello,
>>>>
>>>> the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
>>>> support for multiple (TX) queues.
>>>> This MAC is connected to the SoC's built-in switch IP (called GSWIP).
>>>>
>>>> Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
>>>> The vendor driver (which mixes DSA/switch and MAC functionality in one
>>>> driver) uses the following approach:
>>>> - eth0 ("lan") uses the first TX queue
>>>> - eth1 ("wan") uses the second TX queue
>>>>
>>>> With the current (mainline) lantiq_xrx200 driver some users are able
>>>> to fill up the first (and only) queue.
>>>> This is why I am thinking about adding support for the second queue to
>>>> the lantiq_xrx200 driver.
>>>>
>>>> My main question is: how do I do it properly?
>>>> Initializing the second TX queue seems simple (calling
>>>> netif_tx_napi_add for a second time).
>>>> But how do I choose the "right" TX queue in xrx200_start_xmit then?
>>
>> If you use DSA you will have a DSA slave network device which will be
>> calling into dev_queue_xmit() into the DSA master which will be the
>> xrx200 driver, so it's fairly simple for you to implement a queue
>> selection within the xrx200 tagger for instance.
>>
>> You can take a look at how net/dsa/tag_brcm.c and
>> drivers/net/ethernet/broadcom/bcmsysport.c work as far as mapping queues
>> from the DSA slave network device queue/port number into a queue number
>> for the DSA master.
> 
> What are the benefits of mapping packets to TX queues of the DSA master
> from the DSA layer?

For systemport and bcm_sf2 this was explained in this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d156576362c07e954dc36e07b0d7b0733a010f7d

in a nutshell, the switch hardware can return the queue status back to
the systemport's transmit DMA such that it can automatically pace the TX
completion interrupts. To do that we need to establish a mapping between
the DSA slave and master that is comprised of the switch port number and
TX queue number, and tell the HW to inspect the congestion status of
that particular port and queue.

What this is meant to address is a "lossless" (within the SoC at least)
behavior when you have user ports that are connected at a speed lower
than that of your internal connection to the switch typically Gigabit or
more. If you send 1Gbits/sec worth of traffic down to a port that is
connected at 100Mbits/sec there will be roughly 90% packet loss unless
you have a way to pace the Ethernet controller's transmit DMA, which
then ultimately limits the TX completion of the socket buffers so things
work nicely. I believe that per queue flow control was evaluated before
and an out of band mechanism was preferred but I do not remember the
details of that decision to use ACB.
-- 
Florian
