Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9358C1E7245
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 03:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404468AbgE2B4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 21:56:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390018AbgE2B4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 21:56:13 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B273461E77528AE2947B;
        Fri, 29 May 2020 09:56:10 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 29 May 2020
 09:56:01 +0800
Subject: Re: [PATCH 02/12] net: hns3: Destroy a mutex after initialisation
 failure in hclge_init_ad_dev()
To:     Markus Elfring <Markus.Elfring@web.de>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
References: <913bb77c-6190-9ce7-a46d-906998866073@web.de>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <9c50ab14-c5c7-129f-0e51-d40a4c552fd8@huawei.com>
Date:   Fri, 29 May 2020 09:56:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <913bb77c-6190-9ce7-a46d-906998866073@web.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/5/29 2:42, Markus Elfring wrote:
>> Add a mutex destroy call in hclge_init_ae_dev() when fails.
> 
> How do you think about a wording variant like the following?
> 
>     Change description:
>     The function “mutex_init” was called before a call of
>     the function “hclge_pci_init”.
>     But the function “mutex_destroy” was not called after initialisation
>     steps failed.
>     Thus add the missed function call for the completion of
>     the exception handling.
> 

It looks better. I will try to improve the skill of patch description
and make as many as people can understand the patch.

Thanks for help.

> 
> Would you like to add the tag “Fixes” to the commit message?
> 

Since it seems not a very urgent issue, so i send it to the -next
and make it as a code optimization.

Thanks:)

> 
> …
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -10108,6 +10108,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
>>   	pci_release_regions(pdev);
>>   	pci_disable_device(pdev);
>>   out:
>> +	mutex_destroy(&hdev->vport_lock);
>>   	return ret;
>>   }
> 
> How do you think about to use the label “destroy_mutex” instead?

Will use label 'destroy_mutex‘ instead if there is another patch need to 
modify this code, which is more readable.

Thanks for your comments.

> 
> Regards,
> Markus
> 
> 

