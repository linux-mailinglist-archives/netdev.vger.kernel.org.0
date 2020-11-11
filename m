Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEFA2AF178
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgKKNES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:04:18 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60116 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgKKNEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:04:16 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0ABD3iW3040367;
        Wed, 11 Nov 2020 07:03:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605099824;
        bh=/PXRJzYw61Pq2KpKYYbLbZH+T1+XvaMgs9xPK++lcdE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=WDZ7SzwO88vGOKRFs5JjZMqCQlxwsPhJEIiQ53fgnFxhRcVJnOMyvnQv3uMl/6R8w
         PlvTyYLI64zKUya4mJBVb/uJlVf2p0pWk3e4BdHnzHV5ZxuZBG1k+yMboyCi9jWxBR
         7oaThlr7xcnYbQOZr+TJqSKPeHTr/CsF26iBtrWc=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0ABD3iRU007907
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 07:03:44 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 11
 Nov 2020 07:03:44 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 11 Nov 2020 07:03:44 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0ABD3fk6026860;
        Wed, 11 Nov 2020 07:03:42 -0600
Subject: Re: [PATCH] net/ethernet: update ret when ptp_clock is ERROR
To:     Richard Cochran <richardcochran@gmail.com>,
        Wang Qing <wangqing@vivo.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1604649411-24886-1-git-send-email-wangqing@vivo.com>
 <20201107150803.GD9653@hoboy.vegasvil.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <fbe087bc-5453-00cc-65d4-8c660e6587ed@ti.com>
Date:   Wed, 11 Nov 2020 15:03:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201107150803.GD9653@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/11/2020 17:08, Richard Cochran wrote:
> On Fri, Nov 06, 2020 at 03:56:45PM +0800, Wang Qing wrote:
>> We always have to update the value of ret, otherwise the
>>   error value may be the previous one.
>>
>> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> 

Following Richard's comments:

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

> 
>> ---
>>   drivers/net/ethernet/ti/am65-cpts.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
>> index 75056c1..b77ff61
>> --- a/drivers/net/ethernet/ti/am65-cpts.c
>> +++ b/drivers/net/ethernet/ti/am65-cpts.c
>> @@ -1001,8 +1001,7 @@ struct am65_cpts *am65_cpts_create(struct device *dev, void __iomem *regs,
>>   	if (IS_ERR_OR_NULL(cpts->ptp_clock)) {
>>   		dev_err(dev, "Failed to register ptp clk %ld\n",
>>   			PTR_ERR(cpts->ptp_clock));
>> -		if (!cpts->ptp_clock)
>> -			ret = -ENODEV;
>> +		ret = cpts->ptp_clock ? cpts->ptp_clock : (-ENODEV);
>>   		goto refclk_disable;
>>   	}
>>   	cpts->phc_index = ptp_clock_index(cpts->ptp_clock);
>> -- 
>> 2.7.4
>>

-- 
Best regards,
grygorii
