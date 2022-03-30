Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C84C4ECD5F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiC3TnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiC3TnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:43:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B0613F5F;
        Wed, 30 Mar 2022 12:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0PR2zYdjHpnbzPpGDX73PfezrreUjmJPOTEhSKYO1Pw=; b=aP7MVBYYOC3fOr70nal+KO/51m
        fgs1qb4ZsYgXHfhoN5IOujYhXV8HWcqMADXtQLoZO8wpDxQqueubIhcTk1+HGj90A7mcMcxS8Z3ww
        f9EGTMCdpw4jZrLXAoG3bsz+Psqt1PfWmeEF/rWLvZV1V37RCkohiYgQaZGp+119J2IDuL13p9Nr9
        msUyKTtnZNkgwYcE1IrvgOp1J34tP1nmWz2VhM+607A28flKZjhPm4+hu7q5Bet2u9gMH4kz/yriC
        EL7MSFc1LV28ceElh9CZwmjb2X7USUzKVHkwA1IX9Lm9WX8wqHZl4SHgu0JZG/zDErpNCsJ7hw4eo
        jpx6RMiA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58030)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZeBj-0003ek-2P; Wed, 30 Mar 2022 20:41:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZeBf-0006uy-77; Wed, 30 Mar 2022 20:40:59 +0100
Date:   Wed, 30 Mar 2022 20:40:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/5] net: sfp: use hwmon_sanitize_name()
Message-ID: <YkSyS1g48TlB3XpB@shell.armlinux.org.uk>
References: <20220329160730.3265481-1-michael@walle.cc>
 <20220329160730.3265481-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329160730.3265481-4-michael@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 06:07:28PM +0200, Michael Walle wrote:
> Instead of open-coding the bad characters replacement in the hwmon name,
> use the new hwmon_sanitize_name().
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Assuming hwmon_sanitize_name() gets settled, then:

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> ---
>  drivers/net/phy/sfp.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 4dfb79807823..0d5dba30444d 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1289,7 +1289,7 @@ static const struct hwmon_chip_info sfp_hwmon_chip_info = {
>  static void sfp_hwmon_probe(struct work_struct *work)
>  {
>  	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
> -	int err, i;
> +	int err;
>  
>  	/* hwmon interface needs to access 16bit registers in atomic way to
>  	 * guarantee coherency of the diagnostic monitoring data. If it is not
> @@ -1317,16 +1317,12 @@ static void sfp_hwmon_probe(struct work_struct *work)
>  		return;
>  	}
>  
> -	sfp->hwmon_name = kstrdup(dev_name(sfp->dev), GFP_KERNEL);
> +	sfp->hwmon_name = hwmon_sanitize_name(dev_name(sfp->dev));
>  	if (!sfp->hwmon_name) {
>  		dev_err(sfp->dev, "out of memory for hwmon name\n");
>  		return;
>  	}
>  
> -	for (i = 0; sfp->hwmon_name[i]; i++)
> -		if (hwmon_is_bad_char(sfp->hwmon_name[i]))
> -			sfp->hwmon_name[i] = '_';
> -
>  	sfp->hwmon_dev = hwmon_device_register_with_info(sfp->dev,
>  							 sfp->hwmon_name, sfp,
>  							 &sfp_hwmon_chip_info,
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
