Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77BBEC9BE4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 12:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbfJCKO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 06:14:27 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:13120 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbfJCKO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 06:14:27 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x93A1XYB005313;
        Thu, 3 Oct 2019 12:14:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=MsUZ3Un62yxRwQi4yRJRkjzgs7EZoNS0M8FD2ejbYXQ=;
 b=M/vTDOH5TOj+MW946TPa7I7ampt54o6A5s+fwy78xnkOuP9trvchBSwpPum37NKHXQCT
 Z5d1BO7+GjcnZT1HJe7IYddFTVwpQmc/e7hDPu6mRmxh65MbCNBxtb7ecNYejpCSWCnK
 RZp227FcBs3gKM2t7R+cQtT0BJqh8OMf5FVdgKzM2fBMp6Ym2lw6AChn7amXhuGltMwr
 aZJgJhVU5IyrDjd8kpQEC/+kiws2mXSMR0O+KFBt9kHEDrMa3VCKabkVOtbsxiZf2vAY
 195EWJWHufBGFZ5ybqBmivmDRZPj1kCdZxKVScGa4skfGCRlk9wLe5hNug9BPE8lRZ86 wA== 
Received: from beta.dmz-ap.st.com (beta.dmz-ap.st.com [138.198.100.35])
        by mx07-00178001.pphosted.com with ESMTP id 2vcem38uhm-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 03 Oct 2019 12:14:11 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id A616C22;
        Thu,  3 Oct 2019 10:14:07 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 05E2F2B5CD1;
        Thu,  3 Oct 2019 12:14:07 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.49) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Thu, 3 Oct
 2019 12:14:06 +0200
Subject: Re: [PATCH 2/5] net: ethernet: stmmac: fix warning when w=1 option is
 used during build
To:     Christophe Roullier <christophe.roullier@st.com>,
        <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>
References: <20190920053817.13754-1-christophe.roullier@st.com>
 <20190920053817.13754-3-christophe.roullier@st.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <3715b72a-4b7c-32f4-a037-94d2862ad07d@st.com>
Date:   Thu, 3 Oct 2019 12:14:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920053817.13754-3-christophe.roullier@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG4NODE3.st.com (10.75.127.12) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_04:2019-10-01,2019-10-03 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/20/19 7:38 AM, Christophe Roullier wrote:
> This patch fix the following warning:
> 
> warning: variable ‘ret’ set but not used [-Wunused-but-set-variable]
>    int val, ret;
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---

Acked-by: Alexandre TORGUE <alexandre.torgue@st.com>

>   drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> index 7e6619868cc1..167a5e99960a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> @@ -184,7 +184,7 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
>   {
>   	struct stm32_dwmac *dwmac = plat_dat->bsp_priv;
>   	u32 reg = dwmac->mode_reg;
> -	int val, ret;
> +	int val;
>   
>   	switch (plat_dat->interface) {
>   	case PHY_INTERFACE_MODE_MII:
> @@ -220,8 +220,8 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
>   	}
>   
>   	/* Need to update PMCCLRR (clear register) */
> -	ret = regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
> -			   dwmac->ops->syscfg_eth_mask);
> +	regmap_write(dwmac->regmap, reg + SYSCFG_PMCCLRR_OFFSET,
> +		     dwmac->ops->syscfg_eth_mask);
>   
>   	/* Update PMCSETR (set register) */
>   	return regmap_update_bits(dwmac->regmap, reg,
> 
