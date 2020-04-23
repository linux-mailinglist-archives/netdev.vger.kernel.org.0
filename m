Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0901B65B6
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 22:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgDWUr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 16:47:28 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:54261 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 16:47:28 -0400
Received: from [192.168.42.210] ([93.22.149.4])
        by mwinf5d27 with ME
        id WLnQ2200T05vvQD03LnRRT; Thu, 23 Apr 2020 22:47:26 +0200
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 23 Apr 2020 22:47:26 +0200
X-ME-IP: 93.22.149.4
Subject: Re: [PATCH] ipw2x00: Remove a memory allocation failure log message
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200423075825.18206-1-christophe.jaillet@wanadoo.fr>
 <5868418d-88b0-3694-2942-5988ab15bdcb@cogentembedded.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <3c80ef48-57a8-b414-6cf1-6c255a46f6be@wanadoo.fr>
Date:   Thu, 23 Apr 2020 22:47:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5868418d-88b0-3694-2942-5988ab15bdcb@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 23/04/2020 à 11:46, Sergei Shtylyov a écrit :
> Hello!
>
> On 23.04.2020 10:58, Christophe JAILLET wrote:
>
>> Axe a memory allocation failure log message. This message is useless and
>> incorrect (vmalloc is not used here for the memory allocation)
>>
>> This has been like that since the very beginning of this driver in
>> commit 43f66a6ce8da ("Add ipw2200 wireless driver.")
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c 
>> b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>> index 60b5e08dd6df..30c4f041f565 100644
>> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>> @@ -3770,10 +3770,9 @@ static int ipw_queue_tx_init(struct ipw_priv 
>> *priv,
>>       struct pci_dev *dev = priv->pci_dev;
>>         q->txb = kmalloc_array(count, sizeof(q->txb[0]), GFP_KERNEL);
>> -    if (!q->txb) {
>> -        IPW_ERROR("vmalloc for auxiliary BD structures failed\n");
>> +    if (!q->txb)
>>           return -ENOMEM;
>> -    }
>> +
>
>    No need for this extra empty line.


That's right, sorry about that.

Can it be fixed when/if the patch is applied, or should I send a V2?
If a V2 is required, should kcalloc be used, as pointed out by Joe Perches?
(personally, If the code works fine as-is, I don't think it is required, 
but it can't hurt)

CJ

>
>>         q->bd =
>>           pci_alloc_consistent(dev, sizeof(q->bd[0]) * count, 
>> &q->q.dma_addr);
>
> MBR, Sergei
>
>

