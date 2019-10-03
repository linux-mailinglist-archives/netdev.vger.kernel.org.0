Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0B8C9BE1
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 12:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbfJCKOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 06:14:14 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:9188 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725827AbfJCKOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 06:14:14 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x93A2J55020727;
        Thu, 3 Oct 2019 12:13:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=8P9lBIH2EjtLoqWh8kEKBgTx+oCkp2//ut7kNrzMBMk=;
 b=XKSPLhchexVTwVYLQfaQQ7XE/rbyZ+1lGE0yi9GgsbCUhbXrzjgQxC/vNeDxLR9xADiF
 ZNONUjtVSutevwzTUNA6nBY60SkHPHXirVtWbDI3YkYGqF2+/dYG6aD06fmizCYgJC7D
 IXKNiPKUpxd8pDMzFhXJGJF+zNeywHyDQIqf2NKk201DZXnGxhOE2oebMX41euUbY3g6
 yDeUI0ws1BsAXjhfRwb/8hjoudqEzFUQ6DxhQimwgM2aJXe6wS50sjdrsNc2hRlSbuoI
 3waLwDfyJJ/CD2qa1fZVenUFQHDekOGzhykjgFBOjQp/E6i2WKZGrxwQ+9Wd8OyuPRXs BQ== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx08-00178001.pphosted.com with ESMTP id 2v9vnam10h-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 03 Oct 2019 12:13:55 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 3532D23;
        Thu,  3 Oct 2019 10:13:45 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2155C2B5CB3;
        Thu,  3 Oct 2019 12:13:45 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.49) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu, 3 Oct
 2019 12:13:44 +0200
Subject: Re: [PATCH 1/5] net: ethernet: stmmac: Add support for syscfg clock
To:     Christophe Roullier <christophe.roullier@st.com>,
        <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>
References: <20190920053817.13754-1-christophe.roullier@st.com>
 <20190920053817.13754-2-christophe.roullier@st.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <7032bc93-cfb3-4538-1de5-bd901a3fc8c5@st.com>
Date:   Thu, 3 Oct 2019 12:13:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920053817.13754-2-christophe.roullier@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG6NODE3.st.com (10.75.127.18) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_04:2019-10-01,2019-10-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/20/19 7:38 AM, Christophe Roullier wrote:
> Add optional support for syscfg clock in dwmac-stm32.c
> Now Syscfg clock is activated automatically when syscfg
> registers are used
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>   .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 36 +++++++++++++------
>   1 file changed, 25 insertions(+), 11 deletions(-)

Acked-by: Alexandre TORGUE <alexandre.torgue@st.com>

> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> index 4ef041bdf6a1..7e6619868cc1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> @@ -152,23 +152,32 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
>   	int ret = 0;
>   
>   	if (prepare) {
> -		ret = clk_prepare_enable(dwmac->syscfg_clk);
> -		if (ret)
> -			return ret;
> -
> +		if (dwmac->syscfg_clk) {
> +			ret = clk_prepare_enable(dwmac->syscfg_clk);
> +			if (ret)
> +				return ret;
> +		}
>   		if (dwmac->clk_eth_ck) {
>   			ret = clk_prepare_enable(dwmac->clk_eth_ck);
>   			if (ret) {
> -				clk_disable_unprepare(dwmac->syscfg_clk);
> +				if (dwmac->syscfg_clk)
> +					goto unprepare_syscfg;
>   				return ret;
>   			}
>   		}
>   	} else {
> -		clk_disable_unprepare(dwmac->syscfg_clk);
> +		if (dwmac->syscfg_clk)
> +			clk_disable_unprepare(dwmac->syscfg_clk);
> +
>   		if (dwmac->clk_eth_ck)
>   			clk_disable_unprepare(dwmac->clk_eth_ck);
>   	}
>   	return ret;
> +
> +unprepare_syscfg:
> +	clk_disable_unprepare(dwmac->syscfg_clk);
> +
> +	return ret;
>   }
>   
>   static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
> @@ -296,7 +305,7 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
>   {
>   	struct platform_device *pdev = to_platform_device(dev);
>   	struct device_node *np = dev->of_node;
> -	int err = 0;
> +	int err;
>   
>   	/* Gigabit Ethernet 125MHz clock selection. */
>   	dwmac->eth_clk_sel_reg = of_property_read_bool(np, "st,eth-clk-sel");
> @@ -320,13 +329,17 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
>   		return PTR_ERR(dwmac->clk_ethstp);
>   	}
>   
> -	/*  Clock for sysconfig */
> +	/*  Optional Clock for sysconfig */
>   	dwmac->syscfg_clk = devm_clk_get(dev, "syscfg-clk");
>   	if (IS_ERR(dwmac->syscfg_clk)) {
> -		dev_err(dev, "No syscfg clock provided...\n");
> -		return PTR_ERR(dwmac->syscfg_clk);
> +		err = PTR_ERR(dwmac->syscfg_clk);
> +		if (err != -ENOENT)
> +			return err;
> +		dwmac->syscfg_clk = NULL;
>   	}
>   
> +	err = 0;
> +
>   	/* Get IRQ information early to have an ability to ask for deferred
>   	 * probe if needed before we went too far with resource allocation.
>   	 */
> @@ -436,7 +449,8 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
>   		return ret;
>   
>   	clk_disable_unprepare(dwmac->clk_tx);
> -	clk_disable_unprepare(dwmac->syscfg_clk);
> +	if (dwmac->syscfg_clk)
> +		clk_disable_unprepare(dwmac->syscfg_clk);
>   	if (dwmac->clk_eth_ck)
>   		clk_disable_unprepare(dwmac->clk_eth_ck);
>   
> 
