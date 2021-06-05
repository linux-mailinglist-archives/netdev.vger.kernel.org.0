Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F1639C7FB
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhFEL5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 07:57:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3072 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbhFEL5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:57:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxydF6Dq9zWgl9;
        Sat,  5 Jun 2021 19:50:57 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 19:55:44 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 19:55:44 +0800
Subject: Re: [PATCH net-next] net: lantiq: Use
 devm_platform_get_and_ioremap_resource()
To:     Hauke Mehrtens <hauke@hauke-m.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
References: <20210605092647.2374125-1-yangyingliang@huawei.com>
 <a66836af-99a4-9bc1-3c0c-6cb9bb1cc4d9@hauke-m.de>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <0a76bc60-4ce3-e8ec-10b5-56faaf65b58e@huawei.com>
Date:   Sat, 5 Jun 2021 19:55:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a66836af-99a4-9bc1-3c0c-6cb9bb1cc4d9@hauke-m.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/6/5 18:58, Hauke Mehrtens wrote:
> On 6/5/21 11:26 AM, Yang Yingliang wrote:
>> Use devm_platform_get_and_ioremap_resource() to simplify
>> code.
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/ethernet/lantiq_xrx200.c | 8 +-------
>>   1 file changed, 1 insertion(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c 
>> b/drivers/net/ethernet/lantiq_xrx200.c
>> index 36dc3e5f6218..003df49e40b1 100644
>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>> @@ -456,13 +456,7 @@ static int xrx200_probe(struct platform_device 
>> *pdev)
>>       net_dev->max_mtu = XRX200_DMA_DATA_LEN;
>>         /* load the memory ranges */
>> -    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -    if (!res) {
>> -        dev_err(dev, "failed to get resources\n");
>> -        return -ENOENT;
>> -    }
>> -
>> -    priv->pmac_reg = devm_ioremap_resource(dev, res);
>> +    priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, 
>> &res);
>
> res is not used anywhere else, you can provide NULL instead of res and 
> remove the variable.
>
> priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
OK, thanks for your suggestion.
>
>>       if (IS_ERR(priv->pmac_reg))
>>           return PTR_ERR(priv->pmac_reg);
>>
>
