Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D67FF33B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 11:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfD3JoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 05:44:15 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:47520 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726012AbfD3JoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 05:44:15 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3U9fBrl026129;
        Tue, 30 Apr 2019 11:43:56 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=9fdnpUZsMrLx27j+EXtChHalN5BDYMsqjBIsFWxPcmw=;
 b=ZqHMHuYgQyWHe3g0kaxkVFNRld5iXUv7r9FiUdq2gqatSxjKpUoCUzZIra3rDBj9xFmd
 KtZbQ1IMwjZPfK6LufOQQ0eBa0OfNDo91qgTJ66BVVVZEsQJMQzDjv58kVSGfXtFTguq
 dxQcGL6FdtONfM7l0s0KvsYn8MS9otouy6wlYMCoqpYCcSS90DQLbTuS2elDWYlXQ98z
 pZoqkDFQ9oLvqL7VIgsUbZPK9IPLERS8zVRAQM4jGgH4sBpchZGJet/4nuPBxuQobTDi
 2W2IQHw1InI+EHw4JfT4jmK0AIdM9dCqw4yQblsJQwut6CMLpe9E/AZggYj2GJV6/PKK qA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2s61r0d53h-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 30 Apr 2019 11:43:56 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0CDCE34;
        Tue, 30 Apr 2019 09:43:54 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 8F07115E8;
        Tue, 30 Apr 2019 09:43:54 +0000 (GMT)
Received: from [10.48.0.204] (10.75.127.50) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 30 Apr
 2019 11:43:54 +0200
Subject: Re: [PATCH 2/6] net: stmmac: fix csr_clk can't be zero issue
To:     biao huang <biao.huang@mediatek.com>
CC:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <jianguo.zhang@mediatek.com>
References: <1556433009-25759-1-git-send-email-biao.huang@mediatek.com>
 <1556433009-25759-3-git-send-email-biao.huang@mediatek.com>
 <24f4b268-aa7f-e1f7-59fc-2bc163eb8277@st.com>
 <1556525353.24897.30.camel@mhfsdcap03>
 <738b37cd-4719-9257-18fc-aab1dc7424f4@st.com>
 <1556615745.24897.40.camel@mhfsdcap03>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <11036b11-e862-2c99-2345-901ac6276e02@st.com>
Date:   Tue, 30 Apr 2019 11:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556615745.24897.40.camel@mhfsdcap03>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG6NODE1.st.com (10.75.127.16) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/19 11:15 AM, biao huang wrote:
> On Mon, 2019-04-29 at 10:26 +0200, Alexandre Torgue wrote:
>>
>> On 4/29/19 10:09 AM, biao huang wrote:
>>> Hi,
>>>
>>> On Mon, 2019-04-29 at 09:18 +0200, Alexandre Torgue wrote:
>>>> Hi
>>>>
>>>> On 4/28/19 8:30 AM, Biao Huang wrote:
>>>>> The specific clk_csr value can be zero, and
>>>>> stmmac_clk is necessary for MDC clock which can be set dynamically.
>>>>> So, change the condition from plat->clk_csr to plat->stmmac_clk to
>>>>> fix clk_csr can't be zero issue.
>>>>>
>>>>> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
>>>>> ---
>>>>>     drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> index 818ad88..9e89b94 100644
>>>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>>> @@ -4376,7 +4376,7 @@ int stmmac_dvr_probe(struct device *device,
>>>>>     	 * set the MDC clock dynamically according to the csr actual
>>>>>     	 * clock input.
>>>>>     	 */
>>>>> -	if (!priv->plat->clk_csr)
>>>>> +	if (priv->plat->stmmac_clk)
>>>>>     		stmmac_clk_csr_set(priv);
>>>>>     	else
>>>>>     		priv->clk_csr = priv->plat->clk_csr;
>>>>>
>>>>
>>>> So, as soon as stmmac_clk will be declared, it is no longer possible to
>>>> fix a CSR through the device tree ?
>>>
>>> let's focus on the condition:
>>> 1. clk_csr may be zero, it should not be the condition. or the clk_csr =
>>> 0 will jump to the wrong block.
>>> 2. Since stmmac_clk_csr_set will get_clk_rate from stmmac_clk,
>>> the plat->stmmac_clk is a more proper condition.
>>>
>>
>> Ok, but here you remove one possibility: stmmac_clk and clk_csr defined.
>> no ?
>>
>> Other way could be the following code + initialize priv->plat->clk_csr
>> with a non null value before read it in device tree (in stmmac_platform).
>>
>> if (priv->plat->clk_csr >= 0)
>> 	priv->clk_csr = priv->plat->clk_csr;
>> else
>> 	stmmac_clk_csr_set(priv);
>>
>>
>>> In some case, it's impossible to get the clk rate of stmmac_clk,
>>> so it's better to remain the clk_csr flow.
>>>
> Agree.
> 
> Maybe we should initialize plat->clk_csr to -1
> in stmmac_probe_config_dt:
> 
> plat->clk_csr = -1;
> /* Get clk_csr from device tree */
> of_property_read_u32(np, "clk_csr", &plat->clk_csr);
> 
> Then the condition can write as you proposed:
> if (priv->plat->clk_csr >= 0)
>   	priv->clk_csr = priv->plat->clk_csr;
> else
>   	stmmac_clk_csr_set(priv);
>

Yes, I agree.
Thanks
Alex


>>>
>>>
> 
> 
