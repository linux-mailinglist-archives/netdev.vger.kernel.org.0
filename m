Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2DA3F4461
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 06:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhHWEd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 00:33:56 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:24261 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhHWEdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 00:33:55 -0400
Received: from [192.168.1.18] ([90.126.253.178])
        by mwinf5d34 with ME
        id ksZA250083riaq203sZBsW; Mon, 23 Aug 2021 06:33:12 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 23 Aug 2021 06:33:12 +0200
X-ME-IP: 90.126.253.178
Subject: Re: [PATCH] forcedeth: switch from 'pci_' to 'dma_' API
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
Cc:     Rain River <rain.1986.08.12@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <099a3b5974f6b2be8770e180823e2883209a3691.1629615550.git.christophe.jaillet@wanadoo.fr>
 <CAD=hENe2OPUZCwL8fxBGGoLc6_1g0kqgo=GKebnot-5+W2n-LQ@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <6f0d95cc-3cb6-c166-7e82-b7914ad25f72@wanadoo.fr>
Date:   Mon, 23 Aug 2021 06:33:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAD=hENe2OPUZCwL8fxBGGoLc6_1g0kqgo=GKebnot-5+W2n-LQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 23/08/2021 à 04:39, Zhu Yanjun a écrit :
> On Sun, Aug 22, 2021 at 3:09 PM Christophe JAILLET
> <christophe.jaillet@wanadoo.fr> wrote:
>>
>> The wrappers in include/linux/pci-dma-compat.h should go away.
>>
>> The patch has been generated with the coccinelle script below.
>>
>> It has been hand modified to use 'dma_set_mask_and_coherent()' instead of
>> 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when applicable.
>> This is less verbose.
>>
>> It has been compile tested.
>>
>>
>> @@
>> @@
>> -    PCI_DMA_BIDIRECTIONAL
>> +    DMA_BIDIRECTIONAL
>>
>> @@
>> @@
>> -    PCI_DMA_TODEVICE
>> +    DMA_TO_DEVICE
>>
>> @@
>> @@
>> -    PCI_DMA_FROMDEVICE
>> +    DMA_FROM_DEVICE
>>
>> @@
>> @@
>> -    PCI_DMA_NONE
>> +    DMA_NONE
>>
>> @@
>> expression e1, e2, e3;
>> @@
>> -    pci_alloc_consistent(e1, e2, e3)
>> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
>>
>> @@
>> expression e1, e2, e3;
>> @@
>> -    pci_zalloc_consistent(e1, e2, e3)
>> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_free_consistent(e1, e2, e3, e4)
>> +    dma_free_coherent(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_map_single(e1, e2, e3, e4)
>> +    dma_map_single(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_unmap_single(e1, e2, e3, e4)
>> +    dma_unmap_single(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4, e5;
>> @@
>> -    pci_map_page(e1, e2, e3, e4, e5)
>> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_unmap_page(e1, e2, e3, e4)
>> +    dma_unmap_page(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_map_sg(e1, e2, e3, e4)
>> +    dma_map_sg(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_unmap_sg(e1, e2, e3, e4)
>> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
>> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
>> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
>> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2, e3, e4;
>> @@
>> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
>> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
>>
>> @@
>> expression e1, e2;
>> @@
>> -    pci_dma_mapping_error(e1, e2)
>> +    dma_mapping_error(&e1->dev, e2)
>>
>> @@
>> expression e1, e2;
>> @@
>> -    pci_set_dma_mask(e1, e2)
>> +    dma_set_mask(&e1->dev, e2)
>>
>> @@
>> expression e1, e2;
>> @@
>> -    pci_set_consistent_dma_mask(e1, e2)
>> +    dma_set_coherent_mask(&e1->dev, e2)
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>>     https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
>> ---
>>   drivers/net/ethernet/nvidia/forcedeth.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
>> index 8724d6a9ed02..ef3fb4cc90af 100644
>> --- a/drivers/net/ethernet/nvidia/forcedeth.c
>> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
>> @@ -5782,15 +5782,11 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>>                  np->desc_ver = DESC_VER_3;
>>                  np->txrxctl_bits = NVREG_TXRXCTL_DESC_3;
>>                  if (dma_64bit) {
>> -                       if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(39)))
>> +                       if (dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(39)))
>>                                  dev_info(&pci_dev->dev,
>>                                           "64-bit DMA failed, using 32-bit addressing\n");
>>                          else
>>                                  dev->features |= NETIF_F_HIGHDMA;
>> -                       if (pci_set_consistent_dma_mask(pci_dev, DMA_BIT_MASK(39))) {
>> -                               dev_info(&pci_dev->dev,
>> -                                        "64-bit DMA (consistent) failed, using 32-bit ring buffers\n");
>> -                       }
> 
>  From the commit log, "pci_set_consistent_dma_mask(e1, e2)" should be
> replaced by "dma_set_coherent_mask(&e1->dev, e2)".
> But in this snippet,  "pci_set_consistent_dma_mask(e1, e2)" is not
> replaced by "dma_set_coherent_mask(&e1->dev, e2)".
> 
> Why?

Hi,
in the commit log I said that:
     The patch has been generated with the coccinelle script below.

     It has been hand modified to use 'dma_set_mask_and_coherent()'
     instead of 'pci_set_dma_mask()/pci_set_consistent_dma_mask()' when
     applicable.
     This is less verbose.

When I started this task proposed by Christoph Hellwig ([1]), their were 
150 files using using 'pci_set_dma_mask()' ([2]). Many of them were good 
candidate for using 'dma_set_mask_and_coherent()' but this 
transformation can not easily be done by coccinelle because it depends 
on the way the code has been written.

So, I decided to hand modify and include the transformation in the many 
patches have sent to remove this deprecated API.
Up to now, it has never been an issue.

I *DO* know that it should have been a 2 steps process but this clean-up 
was too big for me (i.e. 150 files) and doing the job twice was 
discouraging.

My first motivation was to remove the deprecated API. Simplifying code 
and using 'dma_set_mask_and_coherent()' when applicable was just a bonus.

So, if desired, I can send a v2 without the additional transformation 
but I won't send 2 patches for that. The 'dma_set_mask_and_coherent()' 
transformation would be left apart, for whoever feels like cleaning it.

CJ


[1]: https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
[2]: https://elixir.bootlin.com/linux/v5.8/A/ident/pci_set_dma_mask


> 
> Zhu Yanjun
> 
> 
>>                  }
>>          } else if (id->driver_data & DEV_HAS_LARGEDESC) {
>>                  /* packet format 2: supports jumbo frames */
>> --
>> 2.30.2
>>
> 

