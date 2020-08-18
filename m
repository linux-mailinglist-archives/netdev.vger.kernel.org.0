Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2E2488E9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgHRPPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:15:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727877AbgHRPPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 11:15:52 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A038779F2590DCA4521A;
        Tue, 18 Aug 2020 23:15:46 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 23:15:44 +0800
Subject: Re: [PATCH] net: stmmac: Fix signedness bug in
 stmmac_probe_config_dt()
To:     Andreas Schwab <schwab@linux-m68k.org>
References: <20200818143952.50752-1-yuehaibing@huawei.com>
 <87ft8katwz.fsf@igel.home>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>, <ajayg@nvidia.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <e8c4e539-d230-2add-6840-ebe1097b8130@huawei.com>
Date:   Tue, 18 Aug 2020 23:15:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <87ft8katwz.fsf@igel.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/18 22:51, Andreas Schwab wrote:
> On Aug 18 2020, YueHaibing wrote:
> 
>> The "plat->phy_interface" variable is an enum and in this context GCC
>> will treat it as an unsigned int so the error handling is never
>> triggered.
>>
>> Fixes: b9f0b2f634c0 ("net: stmmac: platform: fix probe for ACPI devices")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> index f32317fa75c8..b5b558b02e7d 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> @@ -413,7 +413,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
>>  	}
>>  
>>  	plat->phy_interface = device_get_phy_mode(&pdev->dev);
>> -	if (plat->phy_interface < 0)
>> +	if ((int)plat->phy_interface < 0)
>>  		return ERR_PTR(plat->phy_interface);
> 
> I don't think the conversion to long when passed to ERR_PTR will produce
> a negative value either (if long is wider than unsigned int).

Thanks, will respin.
> 
> Andreas.
> 

