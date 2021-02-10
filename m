Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68CD316C62
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhBJRSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbhBJRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 12:17:34 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8777BC061574;
        Wed, 10 Feb 2021 09:16:55 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o15so644794wmq.5;
        Wed, 10 Feb 2021 09:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RA9CDNSEEauXhCymBDWu4axIOomevevEY3Q56lZOy/U=;
        b=u2cPGeeY3fJLnWXLrSI8WCVcGLtJaZtfh0eL/0hJqGYoz3Jtk6zhnIwnehGZZfh6GL
         GAVuMprlpbgY6na+v3IxscZh7McgCBQAomXi9FKVMJ92M2zMCPzbXpOlyFSAVhGE4jdv
         mv+ZZSxqe6zqUwK9P4kiC7HRRJpnwHc3fdkC5zL5NSqlfNrPPoCOFQveFP61TFD3WtCu
         JQwl99awZaKAtTULRgOF0qSrPc9TOp6yJV2HYBNkcr9g9XiurT8OOkAvYlqhIE9IA18K
         49BRAgRnXxIdFx57TZA1CgrjQFLc8XlWNohUDiRnTMgAx63xVonF7SbGp7BjWiMX+uyV
         AXrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RA9CDNSEEauXhCymBDWu4axIOomevevEY3Q56lZOy/U=;
        b=JFMKtzOfMIQD462yto/drzp/GWWU3/sVgUtkIphsRmknBOyYXGoJ/AB1jbmlZKANDX
         G3gxBSSHjAmMkk+LGf4/JRTG8c/l77quGd+53c543LIvgLKFtCpXnzqAnJhVEKZYCeZT
         mZJjXSTW9fhflfZBBZyAOg6UPZtgQPR35pVPEhJ1nd3cQyt8yEuxhfG1VrOkoYjX8ZPS
         ez+YPaI9wH5Ah78bqx8aHV3tvdMdiUbq2AHRdRHwyeiqbXVOUAqdkyDDgY5NlTgoGHEI
         iL6OuIhfmIfV5ppNwNk5Zze1Fh0EtmVNA+yFshyZ3qZPi2RHV2IR8GCEQKrxPx4x9obt
         xQlQ==
X-Gm-Message-State: AOAM533xRwULMWw2IbFUUZHYCBLHMZxLkChxyfbc90lLii25S+jZUjbm
        9w1SLmcqvLLBTNX2c9ZshO4=
X-Google-Smtp-Source: ABdhPJzvVCxXtKQUtA7Qu/282IUEkq13AYfvyvP+fN1wJm0yjo3FxR1lR5YHmSio0lnP62E8kxQZjA==
X-Received: by 2002:a05:600c:4c19:: with SMTP id d25mr3824959wmp.181.1612977414250;
        Wed, 10 Feb 2021 09:16:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id u7sm3788761wrt.67.2021.02.10.09.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 09:16:53 -0800 (PST)
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210210164746.26336-1-michael@walle.cc>
 <20210210164746.26336-6-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 5/9] net: phy: icplus: split IP101A/G driver
Message-ID: <56a7715b-24c6-fdda-d5ff-fe81be7b309a@gmail.com>
Date:   Wed, 10 Feb 2021 18:16:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210164746.26336-6-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.2021 17:47, Michael Walle wrote:
> Unfortunately, the IP101A and IP101G share the same PHY identifier.
> While most of the functions are somewhat backwards compatible, there is
> for example the APS_EN bit on the IP101A but on the IP101G this bit
> reserved. Also, the IP101G has many more functionalities.
> 
> Deduce the model by accessing the page select register which - according
> to the datasheet - is not available on the IP101A. If this register is
> writable, assume we have an IP101G.
> 
> Split the combined IP101A/G driver into two separate drivers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> Changes since v1:
>  - use match_phy_device() as suggested by Heiner
> 
> Andrew, I've dropped your Reviewed-by because of this.
> 
>  drivers/net/phy/icplus.c | 69 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
> index 036bac628b11..1bc9baa9048f 100644
> --- a/drivers/net/phy/icplus.c
> +++ b/drivers/net/phy/icplus.c
> @@ -44,6 +44,8 @@ MODULE_LICENSE("GPL");
>  #define IP101A_G_IRQ_DUPLEX_CHANGE	BIT(1)
>  #define IP101A_G_IRQ_LINK_CHANGE	BIT(0)
>  
> +#define IP101G_PAGE_CONTROL				0x14
> +#define IP101G_PAGE_CONTROL_MASK			GENMASK(4, 0)
>  #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
>  #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
>  
> @@ -301,6 +303,58 @@ static irqreturn_t ip101a_g_handle_interrupt(struct phy_device *phydev)
>  	return IRQ_HANDLED;
>  }
>  
> +static int ip101a_g_has_page_register(struct phy_device *phydev)
> +{
> +	int oldval, val, ret;
> +
> +	oldval = phy_read(phydev, IP101G_PAGE_CONTROL);
> +	if (oldval < 0)
> +		return oldval;
> +
> +	ret = phy_write(phydev, IP101G_PAGE_CONTROL, 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	val = phy_read(phydev, IP101G_PAGE_CONTROL);
> +	if (val < 0)
> +		return val;
> +
> +	ret = phy_write(phydev, IP101G_PAGE_CONTROL, oldval);
> +	if (ret)
> +		return ret;
> +
> +	return val == IP101G_PAGE_CONTROL_MASK;
> +}
> +
> +static int ip101a_g_match_phy_device(struct phy_device *phydev, bool ip101a)
> +{
> +	int ret;
> +
> +	if (phydev->phy_id != IP101A_PHY_ID)
> +		return 0;
> +
> +	/* The IP101A and the IP101G share the same PHY identifier.The IP101G
> +	 * seems to be a successor of the IP101A and implements more functions.
> +	 * Amongst other things there is a page select register, which is not
> +	 * available on the IP101A. Use this to distinguish these two.
> +	 */
> +	ret = ip101a_g_has_page_register(phydev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return (ip101a) ? !ret : ret;

Simpler would be: return ip101a == !ret;

> +}
> +
> +static int ip101a_match_phy_device(struct phy_device *phydev)
> +{
> +	return ip101a_g_match_phy_device(phydev, true);
> +}
> +
> +static int ip101g_match_phy_device(struct phy_device *phydev)
> +{
> +	return ip101a_g_match_phy_device(phydev, false);
> +}
> +
>  static struct phy_driver icplus_driver[] = {
>  {
>  	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
> @@ -320,8 +374,19 @@ static struct phy_driver icplus_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> -	PHY_ID_MATCH_EXACT(IP101A_PHY_ID),
> -	.name		= "ICPlus IP101A/G",
> +	.name		= "ICPlus IP101A",
> +	.match_phy_device = ip101a_match_phy_device,
> +	/* PHY_BASIC_FEATURES */

These comments have once been automatically added as part of
a change in phy_driver structure. For new drivers they don't
make too much sense.

> +	.probe		= ip101a_g_probe,
> +	.config_intr	= ip101a_g_config_intr,
> +	.handle_interrupt = ip101a_g_handle_interrupt,
> +	.config_init	= ip101a_g_config_init,
> +	.soft_reset	= genphy_soft_reset,
> +	.suspend	= genphy_suspend,
> +	.resume		= genphy_resume,
> +}, {
> +	.name		= "ICPlus IP101G",
> +	.match_phy_device = ip101g_match_phy_device,
>  	/* PHY_BASIC_FEATURES */
>  	.probe		= ip101a_g_probe,
>  	.config_intr	= ip101a_g_config_intr,
> 

