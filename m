Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB802F8C96
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 10:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAPJNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 04:13:38 -0500
Received: from thoth.sbs.de ([192.35.17.2]:56821 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbhAPJNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 04:13:37 -0500
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 10G9CPm5022645
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 Jan 2021 10:12:28 +0100
Received: from [167.87.253.56] ([167.87.253.56])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 10G9CLSN015701;
        Sat, 16 Jan 2021 10:12:22 +0100
Subject: Re: [PATCH net-next 1/1] stmmac: intel: change all EHL/TGL to auto
 detect phy addr
To:     Wong Vee Khee <vee.khee.wong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>
References: <20201106094341.4241-1-vee.khee.wong@intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <bf5170d1-62a9-b2dc-cb5a-d568830c947a@siemens.com>
Date:   Sat, 16 Jan 2021 10:12:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106094341.4241-1-vee.khee.wong@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.11.20 10:43, Wong Vee Khee wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Set all EHL/TGL phy_addr to -1 so that the driver will automatically
> detect it at run-time by probing all the possible 32 addresses.
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index b6e5e3e36b63..7c1353f37247 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -236,6 +236,7 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
>  	int ret;
>  	int i;
>  
> +	plat->phy_addr = -1;
>  	plat->clk_csr = 5;
>  	plat->has_gmac = 0;
>  	plat->has_gmac4 = 1;
> @@ -345,7 +346,6 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
>  			  struct plat_stmmacenet_data *plat)
>  {
>  	plat->bus_id = 1;
> -	plat->phy_addr = 0;
>  	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
>  
>  	plat->serdes_powerup = intel_serdes_powerup;
> @@ -362,7 +362,6 @@ static int ehl_rgmii_data(struct pci_dev *pdev,
>  			  struct plat_stmmacenet_data *plat)
>  {
>  	plat->bus_id = 1;
> -	plat->phy_addr = 0;
>  	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
>  
>  	return ehl_common_data(pdev, plat);
> @@ -376,7 +375,6 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
>  				struct plat_stmmacenet_data *plat)
>  {
>  	plat->bus_id = 2;
> -	plat->phy_addr = 1;
>  	return ehl_common_data(pdev, plat);
>  }
>  
> @@ -408,7 +406,6 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
>  				struct plat_stmmacenet_data *plat)
>  {
>  	plat->bus_id = 3;
> -	plat->phy_addr = 1;
>  	return ehl_common_data(pdev, plat);
>  }
>  
> @@ -450,7 +447,6 @@ static int tgl_sgmii_data(struct pci_dev *pdev,
>  			  struct plat_stmmacenet_data *plat)
>  {
>  	plat->bus_id = 1;
> -	plat->phy_addr = 0;
>  	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
>  	plat->serdes_powerup = intel_serdes_powerup;
>  	plat->serdes_powerdown = intel_serdes_powerdown;
> 

This fixes PHY detection on one of our EHL-based boards. Can this also
be applied to stable 5.10?

Thanks,
Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
