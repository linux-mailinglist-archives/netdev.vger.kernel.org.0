Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A96485984
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbiAETvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:51:51 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:56874 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbiAETvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:51:46 -0500
Received: from [192.168.1.18] ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 5CJynyfKuBazo5CJyn0El3; Wed, 05 Jan 2022 20:51:45 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 05 Jan 2022 20:51:45 +0100
X-ME-IP: 90.11.185.88
Message-ID: <86bf852e-4220-52d4-259d-3455bc24def1@wanadoo.fr>
Date:   Wed, 5 Jan 2022 20:51:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] enic: Use dma_set_mask_and_coherent()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     benve@cisco.com, govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <f926eab883a3e5c4dbfd3eb5108b3e1828e6513b.1641045708.git.christophe.jaillet@wanadoo.fr>
 <YdK4IIFvi5O5eXHC@infradead.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <YdK4IIFvi5O5eXHC@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/01/2022 à 09:47, Christoph Hellwig a écrit :
> On Sat, Jan 01, 2022 at 03:02:45PM +0100, Christophe JAILLET wrote:
>> -	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(47));
>> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(47));
>>   	if (err) {
>> +		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>>   		if (err) {
>>   			dev_err(dev, "No usable DMA configuration, aborting\n");
>>   			goto err_out_release_regions;
>>   		}
>>   	} else {
>>   		using_dac = 1;
> 
> There is no need for the callback.  All the routines to set a DMA mask
> will only fail if the passed in mask is too small, but never if it is
> larger than what is supported.  Also the using_dac variable is not
> needed, NETIF_F_HIGHDMA can and should be set unconditionally.
> 

Ok, thanks.
I was only aware of the 64 bits case.
The patch has already reached -next.

I'll send another patch on to of it to go one step further.

CJ
