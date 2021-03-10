Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5AC334973
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCJVHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhCJVHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 16:07:11 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741BDC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 13:07:11 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id l19so36057wmh.1
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 13:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kKUg/AkwvmXDt506NgxUb0MutrChVhIS6JwVpnoB+hE=;
        b=ZBLXSGmVrTpZ3R4nvv6/WjdWC7vUkC8rxCeYzfREY98/ZusMKSIjVZHCWW98i4AtBp
         Z1y5mmQjAT3Jefb+uOCWY1vOvXsgcERXvmojqWV6khETbqCWThB4BAQ4C/2qUEJjGKFO
         roQWVjSgxa/GhEk3npQ61pbDFLO25Q94K+CN+nFEO6D7RfdFeyrqKlbWzLpIaX96gE2u
         q0yTSFz/JAgAeOEHV8ne6qfV2My0OBHbgf+oNzFoPlc4thnMBHvz+97j1yVZfuciU9L/
         5G6332B8/OLg4t271dJBDf9+XVxO5rlp825ufBH15iW9bWIoePRlfjO4qaMmLYysHH8i
         8kKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kKUg/AkwvmXDt506NgxUb0MutrChVhIS6JwVpnoB+hE=;
        b=jz8GkbMPwtwOwPFKEeTTbsPUwGXbdjSPDD1ZkeYOcPsRn33XfZXD8+k4BMsGZmTbt8
         nUIh0zzRRCABGHaA9aN5p8+TT9+PwEeqU+D1LGTc9p8dKAFnrxiVxy8RyCxT2mqypxsl
         mEqXWMbm/bQMoP5UOa2IhRmpYqS5zg26PtK9TlOkI2G/fuBY6jUVu5zXLwHxf9jKJZ9W
         ChMcWBDn/xv+VvhOyG+YDPmMTxTHc0RmibKIzYRaD+Hb4wqHfo5A07R2b2+gerRapFJt
         rau4sDKFcksxoICAfQuPnAvk31Gx+8qc5AjXaV4tsw/rdFl3TMciUBwI1VH3EbgIxFEB
         lotw==
X-Gm-Message-State: AOAM531Z7taakSXEE9E5hua4V3sxXa4FA8jI/8rqxjiXgAuvXHA7/2wG
        A0ZLR/lPh6ttOmr+agpirKdRZEROa3AOBw==
X-Google-Smtp-Source: ABdhPJzPjnmUHIhZhUyiNfnFTRNDlblOVOyJMB9jWmsKyksGNkbfQM/9I9nMvan9O9cfEZ6UKYXdTA==
X-Received: by 2002:a05:600c:224e:: with SMTP id a14mr5041825wmm.57.1615410430055;
        Wed, 10 Mar 2021 13:07:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:1d99:917d:ce16:eefa? (p200300ea8f1fbb001d99917dce16eefa.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:1d99:917d:ce16:eefa])
        by smtp.googlemail.com with ESMTPSA id h25sm737089wml.32.2021.03.10.13.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 13:07:09 -0800 (PST)
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, kuba@kernel.org, davem@davemloft.net
References: <20210310204106.2767772-1-f.fainelli@gmail.com>
 <20210310204106.2767772-3-f.fainelli@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 2/3] net: phy: broadcom: Only set BMCR.PDOWN to
 suspend
Message-ID: <d2dec3e9-146a-1e07-5eb5-690b972c3315@gmail.com>
Date:   Wed, 10 Mar 2021 22:07:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210310204106.2767772-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2021 21:41, Florian Fainelli wrote:
> B50212E PHYs have been observed to get into an incorrect state with the
> visible effect of having both activity and link LEDs flashing
> alternatively instead of being turned off as intended when
> genphy_suspend() was issued. The BCM54810 is a similar design and
> equally suffers from that issue.
> 
> The datasheet is not particularly clear whether a read/modify/write
> sequence is acceptable and only indicates that BMCR.PDOWN=1 should be
> utilized to enter the power down mode. When this was done the PHYs were
> always measured to have power levels that match the expectations and
> LEDs powered off.
> 
> Fixes: fe26821fa614 ("net: phy: broadcom: Wire suspend/resume for BCM54810")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/phy/broadcom.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index b8eb736fb456..b33ffd44f799 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -388,6 +388,21 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int bcm54xx_suspend(struct phy_device *phydev)
> +{
> +	/* We cannot perform a read/modify/write like what genphy_suspend()
> +	 * does because depending on the time we can observe the PHY having
> +	 * both of its LEDs flashing indicating that it is in an incorrect
> +	 * state and not powered down as expected.
> +	 *
> +	 * There is not a clear indication in the datasheet whether a
> +	 * read/modify/write would be acceptable, but a blind write to the
> +	 * register has been proven to be functional unlike the
> +	 * Read/Modify/Write.
> +	 */
> +	return phy_write(phydev, MII_BMCR, BMCR_PDOWN);

This clears all other bits in MII_BMCR, incl. ANENABLE and the ones used in
forced mode. So you have to rely on somebody calling genphy_config_aneg()
to sync the register bits with the values cached in struct phy_device
on resume. Typically the phylib state machine takes care, but do we have
to consider use cases where this is not the case?

Heiner

> +}
> +
>  static int bcm54xx_resume(struct phy_device *phydev)
>  {
>  	int ret;
> @@ -778,7 +793,7 @@ static struct phy_driver broadcom_drivers[] = {
>  	.config_aneg    = bcm5481_config_aneg,
>  	.config_intr    = bcm_phy_config_intr,
>  	.handle_interrupt = bcm_phy_handle_interrupt,
> -	.suspend	= genphy_suspend,
> +	.suspend	= bcm54xx_suspend,
>  	.resume		= bcm54xx_resume,
>  }, {
>  	.phy_id         = PHY_ID_BCM54811,
> 

