Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F8B3BA35E
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 18:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhGBQwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 12:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhGBQwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 12:52:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E08C061762;
        Fri,  2 Jul 2021 09:49:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u19so5889703plc.3;
        Fri, 02 Jul 2021 09:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r04r30t3Y200Y/AHEPmOStIgaJywRT9acaLbe+VfwK8=;
        b=dtGeJ3WWpWO88kcTgsir8hQKzfQwR3Ll1ScRHvMVGiGI42x/Z6Jd9rSmDRUdG57cD4
         vF+XQRa8yv55Bo1GcQPjLia7xLRxD7PfaNq+EPSOELpmYbWrcn9UONCDvIef+witr9PQ
         XF4PTKXo4WQwXhdkXAPA6za+5bXFTuc2Elt4HJ7Yqg2n0/oUZj3ERH33yO/J5Ez7SutX
         xTsyFFHZxilkWO6QzGvlZjyE5DviIujdYZk9pMuhPo0942/opmdUX7p2u2qbTxI7tVcd
         iGvKbDSP6L6InC+kqlJAIKLsgE1i8Q7ftLRWjaMOqqQq9EB71d6RlGzD8baKyku8nGOQ
         AC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r04r30t3Y200Y/AHEPmOStIgaJywRT9acaLbe+VfwK8=;
        b=Q7aiKIyYH+NIJzUx7Vfc/pE94ZF5tbbeGfidFlIGiI4aG4nhK4xJTBbhEyV1raXjiI
         y5G8X2RJqQqrqg38krqKHNYY50L0R2zd1QU14gPxOXDV5yMIqS5L2aGTxnEDJ6iGnDlO
         jQYtcFycO3kdAEDbXDh3/4Ga7LtqPJ+izH1TbEuQYy8My+uZUs50X/c2fXd7QbGR/4Pg
         y137N74a+/Jfz24A0YpLT5T8ovGSb89g/UmYx5vCJ6ycC0EAJW7ZqG8G+yjS5+3rP6yX
         ogRlXgLB8+yQgwoZheCQpzI6kUQggnGjrM/KHN8kCWMRVFhzF1gX+waKMZ5u/6eWc3eQ
         vg2w==
X-Gm-Message-State: AOAM532Cgj/Yi8K/DGeG8BW+W1Esol2KALr4qCTX7CaQGBDWks7o+u9Y
        hiSQGxrbBJdvJ5UQo2rDRTtRXr3ddE4=
X-Google-Smtp-Source: ABdhPJxNOVRmY8/NMCgjvT/qoaShHj2buicPIN1qWUu+JrXHv9fDFnxwawcujNp5HVw4eSUCYN2uPg==
X-Received: by 2002:a17:90a:8d17:: with SMTP id c23mr652765pjo.96.1625244574115;
        Fri, 02 Jul 2021 09:49:34 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id s22sm3948458pfe.208.2021.07.02.09.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 09:49:33 -0700 (PDT)
Subject: Re: Kernel Panic in skb_release_data using genet
To:     Maxime Ripard <maxime@cerno.tech>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas saenz julienne <nsaenz@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
 <20210524151329.5ummh4dfui6syme3@gilmour>
 <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
 <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
 <20210625125906.gj45zykbemh5zzhw@gilmour>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0f0f41de-76ca-a9a2-c362-9b15dd47f144@gmail.com>
Date:   Fri, 2 Jul 2021 09:49:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625125906.gj45zykbemh5zzhw@gilmour>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Maxime,

On 6/25/2021 5:59 AM, Maxime Ripard wrote:
> Hi Florian,
> 
> Sorry for the late reply
> 
> On Thu, Jun 10, 2021 at 02:33:17PM -0700, Florian Fainelli wrote:
>> On 6/2/2021 6:28 AM, Maxime Ripard wrote:
>>> On Tue, Jun 01, 2021 at 11:33:18AM +0200, nicolas saenz julienne wrote:
>>>> On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
>>>>>> That is also how I boot my Pi4 at home, and I suspect you are right, if
>>>>>> the VPU does not shut down GENET's DMA, and leaves buffer addresses in
>>>>>> the on-chip descriptors that point to an address space that is managed
>>>>>> totally differently by Linux, then we can have a serious problem and
>>>>>> create some memory corruption when the ring is being reclaimed. I will
>>>>>> run a few experiments to test that theory and there may be a solution
>>>>>> using the SW_INIT reset controller to have a big reset of the controller
>>>>>> before handing it over to the Linux driver.
>>>>>
>>>>> Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
>>>>> that the TX or RX DMA have been left running during the hand over from
>>>>> the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to reduce
>>>>> as much as possible the differences between your set-up and my set-up
>>>>> but so far have not been able to reproduce the crash in booting from NFS
>>>>> repeatedly, I will try again.
>>>>
>>>> FWIW I can reproduce the error too. That said it's rather hard to reproduce,
>>>> something in the order of 1 failure every 20 tries.
>>>
>>> Yeah, it looks like it's only from a cold boot and comes in "bursts",
>>> where you would get like 5 in a row and be done with it for a while.
>>
>> Here are two patches that you could try exclusive from one another
>>
>> 1) Limit GENET to a single queue
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index fcca023f22e5..e400c12e6868 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -3652,6 +3652,12 @@ static int bcmgenet_change_carrier(struct
>> net_device *dev, bool new_carrier)
>>          return 0;
>>   }
>>
>> +static u16 bcmgenet_select_queue(struct net_device *dev, struct sk_buff
>> *skb,
>> +                                struct net_device *sb_dev)
>> +{
>> +       return 0;
>> +}
>> +
>>   static const struct net_device_ops bcmgenet_netdev_ops = {
>>          .ndo_open               = bcmgenet_open,
>>          .ndo_stop               = bcmgenet_close,
>> @@ -3666,6 +3672,7 @@ static const struct net_device_ops
>> bcmgenet_netdev_ops = {
>>   #endif
>>          .ndo_get_stats          = bcmgenet_get_stats,
>>          .ndo_change_carrier     = bcmgenet_change_carrier,
>> +       .ndo_select_queue       = bcmgenet_select_queue,
>>   };
>>
>>   /* Array of GENET hardware parameters/characteristics */
>>
>> 2) Ensure that all TX/RX queues are disabled upon DMA initialization
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> index fcca023f22e5..7f8a5996fbbb 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>> @@ -3237,15 +3237,21 @@ static void bcmgenet_get_hw_addr(struct
>> bcmgenet_priv *priv,
>>   /* Returns a reusable dma control register value */
>>   static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
>>   {
>> +       unsigned int i;
>>          u32 reg;
>>          u32 dma_ctrl;
>>
>>          /* disable DMA */
>>          dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
>> +       for (i = 0; i < priv->hw_params->tx_queues; i++)
>> +               dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
>>          reg = bcmgenet_tdma_readl(priv, DMA_CTRL);
>>          reg &= ~dma_ctrl;
>>          bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
>>
>> +       dma_ctrl = 1 << (DESC_INDEX + DMA_RING_BUF_EN_SHIFT) | DMA_EN;
>> +       for (i = 0; i < priv->hw_params->rx_queues; i++)
>> +               dma_ctrl |= (1 << (i + DMA_RING_BUF_EN_SHIFT));
>>          reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
>>          reg &= ~dma_ctrl;
>>          bcmgenet_rdma_writel(priv, reg, DMA_CTRL);
> 
> I had a bunch of issues popping up today so I took the occasion to test
> those patches. The first one doesn't change anything, I still had the
> crash occurring with it. With the second applied (in addition), it seems
> like it's fixed. I'll keep testing and will let you know.

Did this patch survive more days of testing? I am tempted to send it 
regardless of your testing because it is a correctness issue that is 
being fixed. There is a global DMA enable bit which should "cut" any 
TX/RX queues, but still, for symmetry with other code paths all queues 
should be disabled.

Thanks!
-- 
Florian
