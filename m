Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575C0267F42
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 12:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgIMKpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 06:45:35 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:30159 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgIMKp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 06:45:29 -0400
Received: from [10.0.2.15] ([93.23.14.57])
        by mwinf5d57 with ME
        id TNlM2300B1Drbmd03NlNQC; Sun, 13 Sep 2020 12:45:26 +0200
X-ME-Helo: [10.0.2.15]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Sep 2020 12:45:26 +0200
X-ME-IP: 93.23.14.57
Subject: Re: [PATCH] net: dl2k: switch from 'pci_' to 'dma_' API
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, snelson@pensando.io,
        jeffrey.t.kirsher@intel.com, mhabets@solarflare.com,
        yuehaibing@huawei.com, mchehab+huawei@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200913061417.347682-1-christophe.jaillet@wanadoo.fr>
 <20200913065559.GB35718@unreal>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <8c2b1241-6b70-0837-3f03-f72e4bbdd165@wanadoo.fr>
Date:   Sun, 13 Sep 2020 12:45:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200913065559.GB35718@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/09/2020 à 08:55, Leon Romanovsky a écrit :
> On Sun, Sep 13, 2020 at 08:14:17AM +0200, Christophe JAILLET wrote:
 > [...]
>> @@ -504,9 +510,8 @@ static int alloc_list(struct net_device *dev)
>>   						sizeof(struct netdev_desc));
>>   		/* Rubicon now supports 40 bits of addressing space. */
>>   		np->rx_ring[i].fraginfo =
>> -		    cpu_to_le64(pci_map_single(
>> -				  np->pdev, skb->data, np->rx_buf_sz,
>> -				  PCI_DMA_FROMDEVICE));
>> +		    cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
>> +					       np->rx_buf_sz, DMA_FROM_DEVICE));
> 
> I'm aware that this was before, but both pci_map_single and
> dma_map_single return an ERROR and it is wrong to set .fraginfo without
> checking result.
> 
> Thanks
> 
Hi,

Nice catch.

I'll try to send patches for such patterns as some follow-ups.
It can be found in several drivers.

But anyone who want to fix it faster than me is welcome ;-)

CJ
