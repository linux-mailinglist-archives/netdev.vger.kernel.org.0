Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4181B63746
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGINtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:49:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50978 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725947AbfGINtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:49:19 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5E58C7DF4F8011129D08;
        Tue,  9 Jul 2019 21:49:06 +0800 (CST)
Received: from [127.0.0.1] (10.65.87.206) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 21:48:56 +0800
Subject: Re: [PATCH v2 05/10] net: hisilicon: HI13X1_GMAX need dreq reset at
 first
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
 <1562643071-46811-6-git-send-email-xiaojiangfeng@huawei.com>
 <890c48d1-76b8-5aea-e175-aa7d9967acd2@cogentembedded.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <101b8c68-75f5-00a7-9845-e59c0467768c@huawei.com>
Date:   Tue, 9 Jul 2019 21:48:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <890c48d1-76b8-5aea-e175-aa7d9967acd2@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.87.206]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/9 17:35, Sergei Shtylyov wrote:
> Hello!
> 
> On 09.07.2019 6:31, Jiangfeng Xiao wrote:
> 
>> HI13X1_GMAC delete request for soft reset at first,
>> otherwise, the subsequent initialization will not
>> take effect.
>>
>> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hip04_eth.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
>> index fe61b01..19d8cfd 100644
>> --- a/drivers/net/ethernet/hisilicon/hip04_eth.c
>> +++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
> [...]
>> @@ -853,6 +867,15 @@ static int hip04_mac_probe(struct platform_device *pdev)
>>           goto init_fail;
>>       }
>>   +#if defined(CONFIG_HI13X1_GMAC)
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +    priv->sysctrl_base = devm_ioremap_resource(d, res);
> 
>    There's devm_platform_ioremap_resource() now.

Thank you for your review, Great issue, which makes my code more concise.

I will fix it in v3. Or submit a patch to modify it separately, if maintainer
applies this patch series.

