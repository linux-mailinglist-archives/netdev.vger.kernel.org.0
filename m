Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2821248844E
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 16:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiAHPsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 10:48:03 -0500
Received: from mx4.wp.pl ([212.77.101.11]:17330 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbiAHPsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 10:48:03 -0500
Received: (wp-smtpd smtp.wp.pl 21247 invoked from network); 8 Jan 2022 16:48:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641656881; bh=tY7VsZM77BHCfiyt/bYVat3VJ4fcshqWFfJ4NvTa2V0=;
          h=Subject:To:From;
          b=o3XZ3On0cq1+7RrMo3ilSHnZRS23ReOqNBuRvPi6LXlPTA3Q+fK3SOJzB03jrKWkM
           MkVQsgz7TQE+4uHO+PBQzZQpUylXC2o4krw8d11V+dhsVZWx9H5h59rwEO5ZfedobJ
           e29AABBKntJy+nWpOQLGnhDj7D+3+zJTglw5yOPs=
Received: from riviera.nat.ds.pw.edu.pl (HELO [192.168.3.133]) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <joe@perches.com>; 8 Jan 2022 16:48:01 +0100
Message-ID: <76e32faf-3e50-c71f-afd9-3a2a1da86bd1@wp.pl>
Date:   Sat, 8 Jan 2022 16:48:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net: lantiq_etop: make alignment match open
 parenthesis
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, davem@davemloft.net,
        kuba@kernel.org, jgg@ziepe.ca, rdunlap@infradead.org,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211229233952.5306-1-olek2@wp.pl>
 <7d75e12a4eb373a5a7e90161049a0eccb6b8c63c.camel@perches.com>
From:   Aleksander Bajkowski <olek2@wp.pl>
In-Reply-To: <7d75e12a4eb373a5a7e90161049a0eccb6b8c63c.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-WP-MailID: 027ffb4d66c228aab29b644f6fd9f9e4
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [QXNU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

On 12/30/21 02:32, Joe Perches wrote:
> On Thu, 2021-12-30 at 00:39 +0100, Aleksander Jan Bajkowski wrote:
>> checkpatch.pl complains as the following:
>>
>> Alignment should match open parenthesis
> []
>> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> []
>> @@ -111,9 +111,9 @@ ltq_etop_alloc_skb(struct ltq_etop_chan *ch)
>>  	ch->skb[ch->dma.desc] = netdev_alloc_skb(ch->netdev, MAX_DMA_DATA_LEN);
>>  	if (!ch->skb[ch->dma.desc])
>>  		return -ENOMEM;
>> -	ch->dma.desc_base[ch->dma.desc].addr = dma_map_single(&priv->pdev->dev,
>> -		ch->skb[ch->dma.desc]->data, MAX_DMA_DATA_LEN,
>> -		DMA_FROM_DEVICE);
>> +	ch->dma.desc_base[ch->dma.desc].addr =
>> +		dma_map_single(&priv->pdev->dev, ch->skb[ch->dma.desc]->data,
>> +			       MAX_DMA_DATA_LEN, DMA_FROM_DEVICE);
>>  	ch->dma.desc_base[ch->dma.desc].addr =
>>  		CPHYSADDR(ch->skb[ch->dma.desc]->data);
> 
> Unassociated trivia:
> 
> ch->dma.desc_base[ch->dma.desc].addr is the target of consecutive assignments.
> 
> That looks very odd.
> 
> Isn't the compiler allowed to toss/throw away the first assignment?
> 
> 


I think you are right. This function should look similar to xrx200_alloc_skb().
Both drivers have the same DMA IP core and packet receiving mechanism.
