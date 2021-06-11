Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8663A3952
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 03:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhFKBhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 21:37:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9069 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFKBhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 21:37:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1Ncb3Cw7zYsDk;
        Fri, 11 Jun 2021 09:32:15 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 09:35:06 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 09:35:05 +0800
Subject: Re: [PATCH net-next] net: mdio: mscc-miim: Use
 devm_platform_get_and_ioremap_resource()
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
References: <20210610091154.4141911-1-yangyingliang@huawei.com>
 <YMI3VsR/jnVVhmsh@lunn.ch>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <fd9cbc9c-478e-85c8-62ec-58a8baf4333c@huawei.com>
Date:   Fri, 11 Jun 2021 09:35:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YMI3VsR/jnVVhmsh@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2021/6/11 0:01, Andrew Lunn wrote:
>> -	dev->regs = devm_ioremap_resource(&pdev->dev, res);
>> +	dev->regs = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
>>   	if (IS_ERR(dev->regs)) {
> Here, only dev->regs is considered.
>
>>   		dev_err(&pdev->dev, "Unable to map MIIM registers\n");
>>   		return PTR_ERR(dev->regs);
>>   	}
>
>
>> +	dev->phy_regs = devm_platform_get_and_ioremap_resource(pdev, 1, &res);
>> +	if (res && IS_ERR(dev->phy_regs)) {
> Here you look at both res and dev->phy_regs.
>
> This seems inconsistent. Can devm_platform_get_and_ioremap_resource()
> return success despite res being NULL?
No, if res is NULL, devm_platform_get_and_ioremap_resource() returns failed.
But, before this patch, if the internal phy res is NULL, it doesn't 
return error
code, so I checked the res to make sure it doesn't change the origin 
code logic.

Thanks,
Yang
>
>         Andrew
> .
