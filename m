Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EDC192D24
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgCYPok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:44:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38943 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbgCYPoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:44:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id p10so3732715wrt.6
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mNoeeQyH3GwMaiviNuKoKHtpKld1yIibA1p6eXnfVsY=;
        b=SANqT1Wtd+4Ad7zWwHaMWfGVAQJpDP06zjkgM7wFdMeGKsPLtwXdSbqtVHtPfrBHVQ
         xmautZqkDtZQ7GUDq5j2gNoew/j2WIa92PHn89V47HlQXSGIhqijtsv7i1yS+x4A2cOW
         buV5dRx1dg2ySWRZIQmKxlVQHkanTuIK/uO64LKyO8J6nyo5GkCaskhPTV4uPofxMhZk
         +1fzLkvIX3gYeyIL/fHqippOhry0LwP0pX5KwFdLBxnDOLAI184NUxTFzC5svjvtoBB3
         t44aH32tmCWVtdi4AaSLHWXHxb0HUP6sIYoaQeQOyKqaDjyO4FUrTJJnHllaJK3uy52R
         xpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mNoeeQyH3GwMaiviNuKoKHtpKld1yIibA1p6eXnfVsY=;
        b=jCfGC56tCC63thrJ0dk2cFxidJmZ8qwNNc4RUpDDJ+Yv2etxdAxkrrwNfYWBZwfLn1
         CFWqBV4ZFzJ9oSfTeE4lnNXamjmtw7omhhdh+x+f+DPpLSjxlLjhsNLC9qAPr8eGT+f1
         DuT3Zz55R4TKloanwgwxwMyKgC3kn1P2tnQttJt4EDt/8D5R6I7TDINjb05Hr9hxuLdE
         5S6Er9JjBMgQ+MRFVG8dzFUf50s+X4xgTy4AgAa0S84iuTQ2S+r8KCbeP0hYWuwFYPAG
         RSv7kuXOda5xHs1fecvLduFwVb2d52DM+wxFxNKlH8dBfp74K9kg0AKQdo2LEPNn6MgC
         9mLA==
X-Gm-Message-State: ANhLgQ0gVO7QGyLzgj3OFyx48SDInLWNXtSS0gfg0KBkbQeE8oaIsYJ7
        a1b0hZL+DbS6OA0Gyef4su3yf4kG
X-Google-Smtp-Source: ADFU+vt/Lf7+m4LAgr/4reJEK/+X4njLh/ex4OSXoYPw45Ux9+oz2SOoMC2VUP/CvpRuPCPriQ8Oig==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr4303308wre.372.1585151076647;
        Wed, 25 Mar 2020 08:44:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:f4a0:1b38:2faf:56e9? (p200300EA8F296000F4A01B382FAF56E9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f4a0:1b38:2faf:56e9])
        by smtp.googlemail.com with ESMTPSA id y11sm34586957wrd.65.2020.03.25.08.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:44:35 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 02/10] net: phy: bcm7xx: Add jumbo frame
 configuration to PHY
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-3-olteanv@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ec070d0f-3712-8663-f39f-124b7f802450@gmail.com>
Date:   Wed, 25 Mar 2020 16:44:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325152209.3428-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2020 16:22, Vladimir Oltean wrote:
> From: Murali Krishna Policharla <murali.policharla@broadcom.com>
> 
> Add API to configure jumbo frame settings in PHY during initial PHY
> configuration.
> 
> Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/bcm-phy-lib.c | 28 ++++++++++++++++++++++++++++
>  drivers/net/phy/bcm-phy-lib.h |  1 +
>  drivers/net/phy/bcm7xxx.c     |  4 ++++
>  include/linux/brcmphy.h       |  1 +
>  4 files changed, 34 insertions(+)
> 
> diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
> index e0d3310957ff..a26c80e13b43 100644
> --- a/drivers/net/phy/bcm-phy-lib.c
> +++ b/drivers/net/phy/bcm-phy-lib.c
> @@ -423,6 +423,34 @@ int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL_GPL(bcm_phy_28nm_a0b0_afe_config_init);
>  
> +int bcm_phy_enable_jumbo(struct phy_device *phydev)
> +{
> +	int val = 0, ret = 0;
> +
> +	ret = phy_write(phydev, MII_BCM54XX_AUX_CTL,
> +			MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
> +	if (ret < 0)
> +		return ret;
> +
> +	val = phy_read(phydev, MII_BCM54XX_AUX_CTL);
> +
> +	/* Enable extended length packet reception */
> +	val |= MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN;
> +	ret = phy_write(phydev, MII_BCM54XX_AUX_CTL, val);
> +

There are different helpers already in bcm-phy-lib,
e.g. bcm54xx_auxctl_read. Also bcm_phy_write_misc()
has has quite something in common with your new function.
It would be good if a helper could be used here.

> +	if (ret < 0)
> +		return ret;
> +
> +	val = phy_read(phydev, MII_BCM54XX_ECR);
> +
> +	/* Enable 10K byte packet length reception */
> +	val |= BIT(0);
> +	ret =  phy_write(phydev, MII_BCM54XX_ECR, val);
> +

Why not use phy_set_bits() ?

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(bcm_phy_enable_jumbo);
> +
>  MODULE_DESCRIPTION("Broadcom PHY Library");
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Broadcom Corporation");
> diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
> index c86fb9d1240c..129df819be8c 100644
> --- a/drivers/net/phy/bcm-phy-lib.h
> +++ b/drivers/net/phy/bcm-phy-lib.h
> @@ -65,5 +65,6 @@ void bcm_phy_get_stats(struct phy_device *phydev, u64 *shadow,
>  		       struct ethtool_stats *stats, u64 *data);
>  void bcm_phy_r_rc_cal_reset(struct phy_device *phydev);
>  int bcm_phy_28nm_a0b0_afe_config_init(struct phy_device *phydev);
> +int bcm_phy_enable_jumbo(struct phy_device *phydev);
>  
>  #endif /* _LINUX_BCM_PHY_LIB_H */
> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
> index af8eabe7a6d4..692048d86ab1 100644
> --- a/drivers/net/phy/bcm7xxx.c
> +++ b/drivers/net/phy/bcm7xxx.c
> @@ -178,6 +178,10 @@ static int bcm7xxx_28nm_config_init(struct phy_device *phydev)
>  		break;
>  	}
>  
> +	if (ret)
> +		return ret;
> +
> +	ret =  bcm_phy_enable_jumbo(phydev);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> index b475e7f20d28..19bd86019e93 100644
> --- a/include/linux/brcmphy.h
> +++ b/include/linux/brcmphy.h
> @@ -119,6 +119,7 @@
>  #define MII_BCM54XX_AUXCTL_SHDWSEL_AUXCTL	0x00
>  #define MII_BCM54XX_AUXCTL_ACTL_TX_6DB		0x0400
>  #define MII_BCM54XX_AUXCTL_ACTL_SMDSP_ENA	0x0800
> +#define MII_BCM54XX_AUXCTL_ACTL_EXT_PKT_LEN	0x4000
>  
>  #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC			0x07
>  #define MII_BCM54XX_AUXCTL_SHDWSEL_MISC_WIRESPEED_EN	0x0010
> 

