Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB1FD00C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNVE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:04:29 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34603 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfKNVE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:04:29 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so5140121pff.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 13:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=BcZFevtMU9F31cQ9RsTXs8jYlkIG9rxj6OfuUbC3ax8=;
        b=IX3U7cp/ZQ8rNnnfOWfj+LZYPuC+MlkiJ992hk3p8SoZJIbb6MHCanmnldMNDeYD47
         OPaEW0XMKG5jK1p1RRKN8ZID6JQcMCIVfZztOphVJICZnSWb1xf7aZ0EFnrM/arkeQDM
         cq1UCM2w4XzRsX6wwPRqdihtTvGwFWOZlPXWF6WzHtgVFA+BOn5JGdFrE2+9OIQPnmJD
         I+lc67zx/BLgKuMMBKpeRN4LWeQZkZy1IOonGg0pO2HNIzcwEnmVJTxwHmhm6I/ddCey
         6OYlP2bjzkCvRIX4dsjeWdkWWLVshG01RzaPAieleeLiratIrniTKNDDrpkp9QBYQCDo
         e1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=BcZFevtMU9F31cQ9RsTXs8jYlkIG9rxj6OfuUbC3ax8=;
        b=Zpt1PX16SL+mB93sFsCO8Q7gzN5XLsYyc8hLMnLO81cFTxM0lMLY10MZgb+Cr58Dq/
         rthBqOKBSdisY3jjf9+pzFUQxryeNby0H7FSWOameNkD9nwP++Y8CO7WLDdPg+06nDMN
         /LlSYDkHezXl8pmmKm0ORJYxed9u6NqSSFuqgz2bxeBoZ4vlba6pTeX3tjgCD/V3lE8m
         9p8VMXfSHCmqjXynd2J8QuESz2ulMvWAFDu1VdwbLaxEnfJPAR5zV4W6E66zj6VuQCkA
         aZMggSiwXMEvSGMmh39ALkriYgAbfaFWJ5UlSod1g3+tRl5zPrT1A//AARGogHtB2fz1
         extw==
X-Gm-Message-State: APjAAAWUSGLRDt/i/ZssvdeAgAbLMpHIW1gvUJIncy9KtP1EcNYgk4um
        SVhWrb7KrAgpfm4RCtwSMZg=
X-Google-Smtp-Source: APXvYqyoXrL9k0m/i+6IrUYzdce6VIcUZ7EIyKivRbGvbFiVhSIDlKCZQk7O5979Ltw53THSn7stKg==
X-Received: by 2002:a17:90a:fa84:: with SMTP id cu4mr14932203pjb.65.1573765468373;
        Thu, 14 Nov 2019 13:04:28 -0800 (PST)
Received: from [172.20.189.1] ([2620:10d:c090:180::dd67])
        by smtp.gmail.com with ESMTPSA id a19sm4830153pfn.144.2019.11.14.13.04.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 13:04:27 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Date:   Thu, 14 Nov 2019 13:04:26 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
In-Reply-To: <20191114204227.GA43707@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 2019, at 12:42, Ilias Apalodimas wrote:

> Hi Jonathan,
>
> On Thu, Nov 14, 2019 at 12:27:40PM -0800, Jonathan Lemon wrote:
>>
>>
>> On 14 Nov 2019, at 10:53, Ilias Apalodimas wrote:
>>
>>> [...]
>>>>> index 2cbcdbdec254..defbfd90ab46 100644
>>>>> --- a/include/net/page_pool.h
>>>>> +++ b/include/net/page_pool.h
>>>>> @@ -65,6 +65,9 @@ struct page_pool_params {
>>>>>  	int		nid;  /* Numa node id to allocate from pages from */
>>>>>  	struct device	*dev; /* device, for DMA pre-mapping purposes */
>>>>>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>>>>> +	unsigned int	max_len; /* max DMA sync memory size */
>>>>> +	unsigned int	offset;  /* DMA addr offset */
>>>>> +	u8 sync;
>>>>>  };
>>>>
>>>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
>>>> (then it can also be gated on having DMA_MAP enabled)
>>>
>>> You mean instead of the u8?
>>> As you pointed out on your V2 comment of the mail, some cards don't 
>>> sync
>>> back to
>>> device.
>>> As the API tries to be generic a u8 was choosen instead of a flag to
>>> cover these
>>> use cases. So in time we'll change the semantics of this to 'always
>>> sync', 'dont
>>> sync if it's an skb-only queue' etc.
>>> The first case Lorenzo covered is sync the required len only instead 
>>> of
>>> the full
>>> buffer
>>
>> Yes, I meant instead of:
>> +		.sync = 1,
>>
>> Something like:
>>         .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
>>
>> Since .sync alone doesn't make sense if the page pool isn't 
>> performing any
>> DMA mapping, right?
>
> Correct. If the sync happens regardless of the page pool mapping 
> capabilities,
> this will affect performance negatively as well (on non-coherent 
> architectures)
>
>> Then existing drivers, if they're converted, can just
>> add the SYNC flag.
>>
>> I did see the initial case where only the RX_BUF_SIZE (1536) is 
>> sync'd
>> instead of the full page.
>>
>> Could you expand on your 'skb-only queue' comment?  I'm currently 
>> running
>> a variant of your patch where iommu mapped pages are attached to 
>> skb's and
>> sent up the stack, then reclaimed on release.  I imagine that with 
>> this
>> change, they would have the full RX_BUF_SIZE sync'd before returning 
>> to the
>> driver, since the upper layers could basically do anything with the 
>> buffer
>> area.
>
> The idea was that page_pool lives per device queue. Usually some 
> queues are
> reserved for XDP only. Since eBPF progs can change the packet we have 
> to sync
> for the device, before we fill in the device descriptors.

And some devices (mlx4) run xdp on the normal RX queue, and if the 
verdict is
PASS, a skb is constructed and sent up the stack.


> For the skb reserved queues, this depends on the 'anything'. If the 
> rest of the
> layers touch (or rather write) into that area, then we'll again gave 
> to sync.
> If we know that the data has not been altered though, we can hand them 
> back to
> the device skipping that sync right?

Sure, but this is also true for eBPF programs.  How would the driver 
know that
the data has not been altered / compacted by the upper layers?
-- 
Jonathan
