Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1AD2C8C94
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgK3SUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:20:55 -0500
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:51127 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728629AbgK3SUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:20:55 -0500
Received: from [192.168.42.210] ([81.185.173.102])
        by mwinf5d73 with ME
        id yiK82300D2CvH0103iK8vB; Mon, 30 Nov 2020 19:19:10 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 30 Nov 2020 19:19:10 +0100
X-ME-IP: 81.185.173.102
Subject: Re: [PATCH] mlxsw: switch from 'pci_' to 'dma_' API
To:     Heiner Kallweit <hkallweit1@gmail.com>, jiri@nvidia.com,
        idosch@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Newsgroups: gmane.linux.kernel.janitors,gmane.linux.kernel.wireless.general,gmane.linux.network,gmane.linux.kernel
References: <20201129211733.2913-1-christophe.jaillet@wanadoo.fr>
 <a4fde87f-ea73-8ba4-e6cd-689f0f649eb4@gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <35052891-4d32-19f0-e991-2aad009917e9@wanadoo.fr>
Date:   Mon, 30 Nov 2020 19:19:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <a4fde87f-ea73-8ba4-e6cd-689f0f649eb4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 29/11/2020 à 22:46, Heiner Kallweit a écrit :
> Am 29.11.2020 um 22:17 schrieb Christophe JAILLET:
>> @@ -1817,17 +1817,17 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   		goto err_pci_request_regions;
>>   	}
>>   
>> -	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>> +	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
> 
> Using dma_set_mask_and_coherent() would be better here.
> 
>>   	if (!err) {
>> -		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
>> +		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
>>   		if (err) {
> 
> This check isn't needed, see comment at definition of
> dma_set_mask_and_coherent().
> 

Hi,

Correct, but I didn't want to mix several things in the same commit.
This one is dedicated to automatically generated changes done with 
coccinelle.

I plan to have another set of such clean-ups once "wrappers in 
include/linux/pci-dma-compat.h are gone"

However, if it is prefered to have only one patch, I can resubmit.

CJ

