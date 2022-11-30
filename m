Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F4163D870
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiK3Opg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiK3Opf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:45:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FB32EF53;
        Wed, 30 Nov 2022 06:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669819533; x=1701355533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7OXz1JQfXpxmshc7RVji/7ppQefNBiE4Gk2wpXgkYeI=;
  b=KzMTndQ8DAnZtTITE5++As5d2aA1Nhip9QtpyKVqw4SXNAMuwvhkt7ye
   eD/lxVQXleqcKA4dEUUytI7Q0q8Cs8uPD9U2CVn75XimnGqIAM9ahhNfb
   nI+b6BltGiY8ORRIlgpHXU9vH/uYaW3M5K+q7KhyTNXcG5ny6ZptfGwHi
   YQYp55t1U2bwtaDB3RQS5uxDKXKayAiQYAW3sffMlNixIfQka9qqhNfzV
   eDPLc/KBGJPoOUSU92hmg1yu/S31Rqq2jtQKmfKX02idyZww27+LZQ+Si
   a+rEXl8njIv77GA9iLH9R1paWU6hvxF5ZeXARuL9IgWadTmHIPwIUZ2Xx
   A==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191147978"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 07:45:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 07:45:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 30 Nov 2022 07:45:31 -0700
Date:   Wed, 30 Nov 2022 15:50:34 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: Re: [PATCH v3 net-next] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Message-ID: <20221130145034.rmput7zdhwevo2p7@soft-dev3-1>
References: <20221129101653.6921-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221129101653.6921-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/29/2022 15:46, Divya Koppera wrote:

Hi Divya,

> Handle the NULL pointer case
> 
> Fixes New smatch warnings:
> drivers/net/phy/micrel.c:2613 lan8814_ptp_probe_once() warn: passing zero to 'PTR_ERR'
> 
> Fixes Old smatch warnings:
> drivers/net/phy/micrel.c:1750 ksz886x_cable_test_get_status() error:
> uninitialized symbol 'ret'.

Shouldn't you split this patch in 2 different patches, as you fix 2
issues.
Also any reason why you target net-next and not net? Because I can
see the blamed patches on net branch.

> 
> vim +/PTR_ERR +2613 drivers/net/phy/micrel.c
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Fixes: 21b688dabecb ("net: phy: micrel: Cable Diag feature for lan8814 phy")
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v2 -> v3:
> - Changed subject line from net to net-next
> - Removed config check for ptp and clock configuration
>   instead added null check for ptp_clock
> - Fixed one more warning related to initialisaton.
> 
> v1 -> v2:
> - Handled NULL pointer case
> - Changed subject line with net-next to net
> ---
>  drivers/net/phy/micrel.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 26ce0c5defcd..3703e2fafbd4 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -2088,7 +2088,8 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
>  	const struct kszphy_type *type = phydev->drv->driver_data;
>  	unsigned long pair_mask = type->pair_mask;
>  	int retries = 20;
> -	int pair, ret;
> +	int ret = 0;
> +	int pair;
>  
>  	*finished = false;
>  
> @@ -2970,12 +2971,13 @@ static int lan8814_config_intr(struct phy_device *phydev)
>  
>  static void lan8814_ptp_init(struct phy_device *phydev)
>  {
> +	struct lan8814_shared_priv *shared_priv = phydev->shared->priv;
>  	struct kszphy_priv *priv = phydev->priv;
>  	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
>  	u32 temp;
>  
> -	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> -	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> +	/* Check if PHC support is missing at the configuration level */
> +	if (!shared_priv->ptp_clock)
>  		return;
>  
>  	lanphy_write_page_reg(phydev, 5, TSU_HARD_RESET, TSU_HARD_RESET_);
> @@ -3016,10 +3018,6 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
>  {
>  	struct lan8814_shared_priv *shared = phydev->shared->priv;
>  
> -	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> -	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> -		return 0;
> -
>  	/* Initialise shared lock for clock*/
>  	mutex_init(&shared->shared_lock);
>  
> @@ -3039,12 +3037,16 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
>  
>  	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
>  					       &phydev->mdio.dev);
> -	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
> +	if (IS_ERR(shared->ptp_clock)) {
>  		phydev_err(phydev, "ptp_clock_register failed %lu\n",
>  			   PTR_ERR(shared->ptp_clock));
>  		return -EINVAL;
>  	}
>  
> +	/* Check if PHC support is missing at the configuration level */
> +	if (!shared->ptp_clock)
> +		return 0;
> +
>  	phydev_dbg(phydev, "successfully registered ptp clock\n");
>  
>  	shared->phydev = phydev;
> -- 
> 2.17.1
> 

-- 
/Horatiu
