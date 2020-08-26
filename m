Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8988252CA7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 13:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgHZLm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 07:42:29 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51332 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbgHZLgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 07:36:38 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07QBZkhU113534;
        Wed, 26 Aug 2020 06:35:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598441746;
        bh=0LOBTae5LVOqEvJt5NeIXC/6mhs4gclws8Dqb6hNMc0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=XD+94RGFu+OmnY20drv9quP2co+tnu3m2UwT+WU3xs7qdpEscV8Q1Fa/WCyz6B8nz
         TjSHFUAieNEjzVmln+GNOXk2KhEIm9FcK3tkHasUGzZ8ZI/SZgyAxNnTNGPZS4TlMA
         hYX2V4OYsHu7IFPsSPO4jsCicDxgiq4KidkckvFQ=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07QBZkYx125424;
        Wed, 26 Aug 2020 06:35:46 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 26
 Aug 2020 06:35:46 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 26 Aug 2020 06:35:46 -0500
Received: from [10.250.68.181] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07QBZkES010512;
        Wed, 26 Aug 2020 06:35:46 -0500
Subject: Re: [PATCH v2] net: dp83869: Fix RGMII internal delay configuration
To:     Daniel Gorsulowski <daniel.gorsulowski@esd.eu>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
References: <20200826050014.428639-1-daniel.gorsulowski@esd.eu>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <a7f527da-f28c-7a8b-3b62-acc9663cb44c@ti.com>
Date:   Wed, 26 Aug 2020 06:35:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200826050014.428639-1-daniel.gorsulowski@esd.eu>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 8/26/20 12:00 AM, Daniel Gorsulowski wrote:
> The RGMII control register at 0x32 indicates the states for the bits
> RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:
>
>    RGMII Transmit/Receive Clock Delay
>      0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
>      0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.
>
> This commit fixes the inversed behavior of these bits
>
> Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
> Signed-off-by: Daniel Gorsulowski <daniel.gorsulowski@esd.eu>
> ---
> v2: fixed indentation and commit style
>
>   drivers/net/phy/dp83869.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index 58103152c601..6b98d74b5102 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -427,18 +427,18 @@ static int dp83869_config_init(struct phy_device *phydev)
>   			return ret;
>   
>   		val = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL);
> -		val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN |
> -			 DP83869_RGMII_RX_CLK_DELAY_EN);
> +		val |= (DP83869_RGMII_TX_CLK_DELAY_EN |
> +			DP83869_RGMII_RX_CLK_DELAY_EN);
>   
>   		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> -			val |= (DP83869_RGMII_TX_CLK_DELAY_EN |
> -				DP83869_RGMII_RX_CLK_DELAY_EN);
> +			val &= ~(DP83869_RGMII_TX_CLK_DELAY_EN |
> +				 DP83869_RGMII_RX_CLK_DELAY_EN);
>   
>   		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> -			val |= DP83869_RGMII_TX_CLK_DELAY_EN;
> +			val &= ~DP83869_RGMII_TX_CLK_DELAY_EN;
>   
>   		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> -			val |= DP83869_RGMII_RX_CLK_DELAY_EN;
> +			val &= ~DP83869_RGMII_RX_CLK_DELAY_EN;
>   
>   		ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIICTL,
>   				    val);

With the exception on bot knowing what net tree this goes to via the subject

Acked-by: Dan Murphy <dmurphy@ti.com>

