Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDD91B6186
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgDWRCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgDWRCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:02:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2D5C09B042;
        Thu, 23 Apr 2020 10:02:54 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k1so7716579wrx.4;
        Thu, 23 Apr 2020 10:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OgOoFPMvziAtiUZxoE51wszbOZtCs8cBFEzsWONoXaQ=;
        b=fNLNNyipyEVINdAKv5TCJmwFHz02ABD9GsJ45feEgUSC3QzsDSJ/C24fKrp0btqSCW
         bD7q0I+D2qw88HV3LrvVGA+jkQuSd20SfXmhPJNdYOvvECzR+3lRimOKZdhvgKEPilcB
         0ySYrBYjp1Oxqyh7Y3rskjj07DRr0XvjV3hgoZWku9fXg8QTRuuyJAM5PxnZHglByWL2
         8AOKnuNZHCJq0LXMVnh1mLIS03knoIEnnbUf1L46MO6p3eoDTP8Ys1RbBbT1oVGGdSde
         4qWLJdVy22i5VT2+5yfhtpnz4jDWjefKGZ3eoCSl5RezIbj2HgHo/xugZL/dmEGTxD3q
         Frdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgOoFPMvziAtiUZxoE51wszbOZtCs8cBFEzsWONoXaQ=;
        b=lLBHWkuomg7Jb+xlTNC3UGJrVYCVIWe1UlofuF1xgDXaPtMMDtxFyKtPGegJPgjpWT
         jwvwq0IlV3VJeEng/vWlmImB1UA+vAOUOJTLi40PkEGtApniCTbvDkeb5tGdvTlKsmBE
         Hu6JpSVYRe/Qqbp4UrzA0nVQGSWhZ6PbLH+TbqMCsN9OdTjyjRUke5B29hNfXI6I4IcK
         fiKFObVyBSRBx1YvHQsfWm2h3Oc9sdXJDDfNGyebnf9NJcKQ78QvmvKswwHZ6OxgFb+K
         nZVC/7hl7Vx59h+6JxnZV3OVrOHX9PRy+q1Vs0FciVlw7ZEXVB58YE+fCya2I29UlGv5
         w0Bg==
X-Gm-Message-State: AGi0PubyRPA8QqEQHpA6nzs4cwLNYmqT8EPxJk7Og+92eSD2YGUt+TET
        mD2Kxiq4lVmzzCgai+9kci8x6hVY
X-Google-Smtp-Source: APiQypLNkmvGiFI2nuonYn40oI+/9YHa3LWpEYLJDmPDLMrDGbGo6niBfzx8atGWQ8hO+m50PuzLaw==
X-Received: by 2002:adf:ed46:: with SMTP id u6mr5623801wro.327.1587661372787;
        Thu, 23 Apr 2020 10:02:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c569:21dc:2ec:9a23? (p200300EA8F296000C56921DC02EC9A23.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c569:21dc:2ec:9a23])
        by smtp.googlemail.com with ESMTPSA id d13sm4300093wmb.39.2020.04.23.10.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 10:02:52 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: phy: DP83822: Fix WoL in config init to be
 disabled
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, afd@ti.com
References: <20200423163947.18313-1-dmurphy@ti.com>
 <20200423163947.18313-2-dmurphy@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <487889d0-d2e4-ddd4-b199-c621b2826601@gmail.com>
Date:   Thu, 23 Apr 2020 19:02:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423163947.18313-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.04.2020 18:39, Dan Murphy wrote:
> The WoL feature should be disabled when config_init is called and the
> feature should turned on or off  when set_wol is called.
> 
> In addition updated the calls to modify the registers to use the set_bit
> and clear_bit function calls.
> 
> Fixes: 3b427751a9d0 ("net: phy: DP83822 initial driver submission")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83822.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> index fe9aa3ad52a7..40fdfd043947 100644
> --- a/drivers/net/phy/dp83822.c
> +++ b/drivers/net/phy/dp83822.c
> @@ -137,16 +137,19 @@ static int dp83822_set_wol(struct phy_device *phydev,
>  			value &= ~DP83822_WOL_SECURE_ON;
>  		}
>  
> -		value |= (DP83822_WOL_EN | DP83822_WOL_INDICATION_SEL |
> -			  DP83822_WOL_CLR_INDICATION);
> -		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
> -			      value);
> +		/* Clear any pending WoL interrupt */
> +		phy_read(phydev, MII_DP83822_MISR2);
> +
> +		value |= DP83822_WOL_EN | DP83822_WOL_INDICATION_SEL |
> +			DP83822_WOL_CLR_INDICATION;
> +
> +		return phy_set_bits_mmd(phydev, DP83822_DEVADDR,
> +					MII_DP83822_WOL_CFG, value);

The switch to phy_set_bits_mmd() doesn't seem to be correct here.
So far bit DP83822_WOL_MAGIC_EN is cleared if WAKE_MAGIC isn't set.
Similar for bit DP83822_WOL_SECURE_ON. With your change they don't
get cleared any longer.

>  	} else {
> -		value = phy_read_mmd(phydev, DP83822_DEVADDR,
> -				     MII_DP83822_WOL_CFG);
> -		value &= ~DP83822_WOL_EN;
> -		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
> -			      value);
> +		value = DP83822_WOL_EN | DP83822_WOL_CLR_INDICATION;
> +
You clear one bit more than before. The reason for this may be worth a note
in the commit message.

> +		return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
> +					  MII_DP83822_WOL_CFG, value);
>  	}
>  
>  	return 0;
> @@ -258,12 +261,11 @@ static int dp83822_config_intr(struct phy_device *phydev)
>  
>  static int dp83822_config_init(struct phy_device *phydev)
>  {
> -	int value;
> -
> -	value = DP83822_WOL_MAGIC_EN | DP83822_WOL_SECURE_ON | DP83822_WOL_EN;
> +	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
> +		    DP83822_WOL_SECURE_ON;
>  
> -	return phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
> -	      value);
> +	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
> +				  MII_DP83822_WOL_CFG, value);
>  }
>  
>  static int dp83822_phy_reset(struct phy_device *phydev)
> 

