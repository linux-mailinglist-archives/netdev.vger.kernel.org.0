Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C5819ADA0
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgDAORy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:17:54 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:26188 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732205AbgDAORy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:17:54 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031EHLwk010045;
        Wed, 1 Apr 2020 16:17:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=Z6VNMqTZ2uwRu8WKkNLiLmvYTadoYga3ntG3YOu/TiU=;
 b=axZXezGT3396UNnC/EOneTFB4Ge+MsYYlB6WJYBw23fMIBAMstAdfT5iosNkfoeWrmiG
 QjiVjJU3hWbDM+udH6oMluKvd6ANYjoRN5Ep0qtF3yLSKjb4FRctObHLpUrzACjiX6j/
 xB7anIR2pyKMRB2LJEoK8ufv/H57M24T//zkoM/cohpHmJPMzjCU3QxdSx2zKW3lTcp2
 1qs9hBrYaFLVS3Uel2Hk3AqwX1q8m3L40579XlELlncXsvIuy1YVzRI+AtBUDOTWiqpn
 Rh8DqbHZUf8R5jzG1lFpvVykUHWDlKGkMaqPo1Mn9l1iQOsyAFN0oKxSWXR0EuPhmEsL CQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 301vkdx483-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 16:17:34 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C603910002A;
        Wed,  1 Apr 2020 16:17:30 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id AE0A32B0D50;
        Wed,  1 Apr 2020 16:17:30 +0200 (CEST)
Received: from lmecxl0912.tpe.st.com (10.75.127.49) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Wed, 1 Apr
 2020 16:17:23 +0200
Subject: Re: [PATCHv2 1/1] net: ethernet: stmmac: simplify phy modes
 management for stm32
To:     Christophe Roullier <christophe.roullier@st.com>,
        <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>
References: <20200316090907.18488-1-christophe.roullier@st.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <cb0a5dd3-02da-7d60-7069-a8ee080ad239@st.com>
Date:   Wed, 1 Apr 2020 16:17:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316090907.18488-1-christophe.roullier@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_01:2020-03-31,2020-03-31 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe

On 3/16/20 10:09 AM, Christophe Roullier wrote:
> No new feature, just to simplify stm32 part to be easier to use.
> Add by default all Ethernet clocks in DT, and activate or not in function
> of phy mode, clock frequency, if property "st,ext-phyclk" is set or not.
> Keep backward compatibility
> -----------------------------------------------------------------------
> |PHY_MODE | Normal | PHY wo crystal|   PHY wo crystal   |  No 125Mhz  |
> |         |        |      25MHz    |        50MHz       |  from PHY   |
> -----------------------------------------------------------------------
> |  MII    |	 -    |     eth-ck    |       n/a          |	    n/a  |
> |         |        | st,ext-phyclk |                    |             |
> -----------------------------------------------------------------------
> |  GMII   |	 -    |     eth-ck    |       n/a          |	    n/a  |
> |         |        | st,ext-phyclk |                    |             |
> -----------------------------------------------------------------------
> | RGMII   |	 -    |     eth-ck    |       n/a          |      eth-ck  |
> |         |        | st,ext-phyclk |                    |st,eth-clk-sel|
> |         |        |               |                    |       or     |
> |         |        |               |                    | st,ext-phyclk|
> ------------------------------------------------------------------------
> | RMII    |	 -    |     eth-ck    |      eth-ck        |	     n/a  |
> |         |        | st,ext-phyclk | st,eth-ref-clk-sel |              |
> |         |        |               | or st,ext-phyclk   |              |
> ------------------------------------------------------------------------
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> 
> ---

Acked-by: Alexandre TORGUE <alexandre.torgue@st.com>


>   .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 74 +++++++++++--------
>   1 file changed, 44 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> index b2dc99289687..5d4df4c5254e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> @@ -29,6 +29,11 @@
>   #define SYSCFG_PMCR_ETH_CLK_SEL		BIT(16)
>   #define SYSCFG_PMCR_ETH_REF_CLK_SEL	BIT(17)
>   
> +/* CLOCK feed to PHY*/
> +#define ETH_CK_F_25M	25000000
> +#define ETH_CK_F_50M	50000000
> +#define ETH_CK_F_125M	125000000
> +
>   /*  Ethernet PHY interface selection in register SYSCFG Configuration
>    *------------------------------------------
>    * src	 |BIT(23)| BIT(22)| BIT(21)|BIT(20)|
> @@ -58,33 +63,20 @@
>    *|         |        |      25MHz    |        50MHz       |                  |
>    * ---------------------------------------------------------------------------
>    *|  MII    |	 -   |     eth-ck    |	      n/a	  |	  n/a        |
> - *|         |        |		     |                    |		     |
> + *|         |        | st,ext-phyclk |                    |		     |
>    * ---------------------------------------------------------------------------
>    *|  GMII   |	 -   |     eth-ck    |	      n/a	  |	  n/a        |
> - *|         |        |               |                    |		     |
> + *|         |        | st,ext-phyclk |                    |		     |
>    * ---------------------------------------------------------------------------
> - *| RGMII   |	 -   |     eth-ck    |	      n/a	  |  eth-ck (no pin) |
> - *|         |        |               |                    |  st,eth-clk-sel  |
> + *| RGMII   |	 -   |     eth-ck    |	      n/a	  |      eth-ck      |
> + *|         |        | st,ext-phyclk |                    | st,eth-clk-sel or|
> + *|         |        |               |                    | st,ext-phyclk    |
>    * ---------------------------------------------------------------------------
>    *| RMII    |	 -   |     eth-ck    |	    eth-ck        |	  n/a        |
> - *|         |        |		     | st,eth-ref-clk-sel |		     |
> + *|         |        | st,ext-phyclk | st,eth-ref-clk-sel |		     |
> + *|         |        |               | or st,ext-phyclk   |		     |
>    * ---------------------------------------------------------------------------
>    *
> - * BIT(17) : set this bit in RMII mode when you have PHY without crystal 50MHz
> - * BIT(16) : set this bit in GMII/RGMII PHY when you do not want use 125Mhz
> - * from PHY
> - *-----------------------------------------------------
> - * src	 |         BIT(17)       |       BIT(16)      |
> - *-----------------------------------------------------
> - * MII   |           n/a	 |         n/a        |
> - *-----------------------------------------------------
> - * GMII  |           n/a         |   st,eth-clk-sel   |
> - *-----------------------------------------------------
> - * RGMII |           n/a         |   st,eth-clk-sel   |
> - *-----------------------------------------------------
> - * RMII  |   st,eth-ref-clk-sel	 |         n/a        |
> - *-----------------------------------------------------
> - *
>    */
>   
>   struct stm32_dwmac {
> @@ -93,6 +85,8 @@ struct stm32_dwmac {
>   	struct clk *clk_eth_ck;
>   	struct clk *clk_ethstp;
>   	struct clk *syscfg_clk;
> +	int ext_phyclk;
> +	int enable_eth_ck;
>   	int eth_clk_sel_reg;
>   	int eth_ref_clk_sel_reg;
>   	int irq_pwr_wakeup;
> @@ -155,14 +149,17 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
>   		ret = clk_prepare_enable(dwmac->syscfg_clk);
>   		if (ret)
>   			return ret;
> -		ret = clk_prepare_enable(dwmac->clk_eth_ck);
> -		if (ret) {
> -			clk_disable_unprepare(dwmac->syscfg_clk);
> -			return ret;
> +		if (dwmac->enable_eth_ck) {
> +			ret = clk_prepare_enable(dwmac->clk_eth_ck);
> +			if (ret) {
> +				clk_disable_unprepare(dwmac->syscfg_clk);
> +				return ret;
> +			}
>   		}
>   	} else {
>   		clk_disable_unprepare(dwmac->syscfg_clk);
> -		clk_disable_unprepare(dwmac->clk_eth_ck);
> +		if (dwmac->enable_eth_ck)
> +			clk_disable_unprepare(dwmac->clk_eth_ck);
>   	}
>   	return ret;
>   }
> @@ -170,24 +167,34 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
>   static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
>   {
>   	struct stm32_dwmac *dwmac = plat_dat->bsp_priv;
> -	u32 reg = dwmac->mode_reg;
> +	u32 reg = dwmac->mode_reg, clk_rate;
>   	int val;
>   
> +	clk_rate = clk_get_rate(dwmac->clk_eth_ck);
> +	dwmac->enable_eth_ck = false;
>   	switch (plat_dat->interface) {
>   	case PHY_INTERFACE_MODE_MII:
> +		if (clk_rate == ETH_CK_F_25M && dwmac->ext_phyclk)
> +			dwmac->enable_eth_ck = true;
>   		val = SYSCFG_PMCR_ETH_SEL_MII;
>   		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_MII\n");
>   		break;
>   	case PHY_INTERFACE_MODE_GMII:
>   		val = SYSCFG_PMCR_ETH_SEL_GMII;
> -		if (dwmac->eth_clk_sel_reg)
> +		if (clk_rate == ETH_CK_F_25M &&
> +		    (dwmac->eth_clk_sel_reg || dwmac->ext_phyclk)) {
> +			dwmac->enable_eth_ck = true;
>   			val |= SYSCFG_PMCR_ETH_CLK_SEL;
> +		}
>   		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_GMII\n");
>   		break;
>   	case PHY_INTERFACE_MODE_RMII:
>   		val = SYSCFG_PMCR_ETH_SEL_RMII;
> -		if (dwmac->eth_ref_clk_sel_reg)
> +		if ((clk_rate == ETH_CK_F_25M || clk_rate == ETH_CK_F_50M) &&
> +		    (dwmac->eth_ref_clk_sel_reg || dwmac->ext_phyclk)) {
> +			dwmac->enable_eth_ck = true;
>   			val |= SYSCFG_PMCR_ETH_REF_CLK_SEL;
> +		}
>   		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_RMII\n");
>   		break;
>   	case PHY_INTERFACE_MODE_RGMII:
> @@ -195,8 +202,11 @@ static int stm32mp1_set_mode(struct plat_stmmacenet_data *plat_dat)
>   	case PHY_INTERFACE_MODE_RGMII_RXID:
>   	case PHY_INTERFACE_MODE_RGMII_TXID:
>   		val = SYSCFG_PMCR_ETH_SEL_RGMII;
> -		if (dwmac->eth_clk_sel_reg)
> +		if ((clk_rate == ETH_CK_F_25M || clk_rate == ETH_CK_F_125M) &&
> +		    (dwmac->eth_clk_sel_reg || dwmac->ext_phyclk)) {
> +			dwmac->enable_eth_ck = true;
>   			val |= SYSCFG_PMCR_ETH_CLK_SEL;
> +		}
>   		pr_debug("SYSCFG init : PHY_INTERFACE_MODE_RGMII\n");
>   		break;
>   	default:
> @@ -294,6 +304,9 @@ static int stm32mp1_parse_data(struct stm32_dwmac *dwmac,
>   	struct device_node *np = dev->of_node;
>   	int err = 0;
>   
> +	/* Ethernet PHY have no crystal */
> +	dwmac->ext_phyclk = of_property_read_bool(np, "st,ext-phyclk");
> +
>   	/* Gigabit Ethernet 125MHz clock selection. */
>   	dwmac->eth_clk_sel_reg = of_property_read_bool(np, "st,eth-clk-sel");
>   
> @@ -431,7 +444,8 @@ static int stm32mp1_suspend(struct stm32_dwmac *dwmac)
>   
>   	clk_disable_unprepare(dwmac->clk_tx);
>   	clk_disable_unprepare(dwmac->syscfg_clk);
> -	clk_disable_unprepare(dwmac->clk_eth_ck);
> +	if (dwmac->enable_eth_ck)
> +		clk_disable_unprepare(dwmac->clk_eth_ck);
>   
>   	return ret;
>   }
> 
