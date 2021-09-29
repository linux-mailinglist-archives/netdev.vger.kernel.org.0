Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2777541CE96
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbhI2V7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344070AbhI2V7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:59:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF82CC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:57:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r18so13862418edv.12
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RQ6oWtIdivv9Y3Twj9sQ1ktdjhUXvsk4+BP39o5daXU=;
        b=ZZe2zPyJdRIR9wXu4JELZ+bXAkcocoy2MMWupmiTBUadzU+fYNzxPe429GqufUNkoM
         c4hZCVIfFI/K5q6hXpY0gnL5EzqYJA111m1VwkFxqN5hZheyCvF+h4y9NjxC2FT80C0v
         EtcfZQs+WkqiRVv+namXw2zEWnruk0mRUHVD5FmyARVWIFMhpYhoV4FB2/CQNqAWafY4
         DDLZOhGAHpdvDn+TSVMu5F10A0zwprJ/Fi8Bd+QMMHMl0l31kKAG6Yq/fxaXEf634kO/
         6kBTiknY5U+Hdjbl3xUIPfwxVfQ6mn7Zs0LwGiYL+Buh1hX3dDnrJtYHjaN0jafhUml9
         777A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RQ6oWtIdivv9Y3Twj9sQ1ktdjhUXvsk4+BP39o5daXU=;
        b=TqMA/tgmOW7tCu6hieGjxXs5Q2kJoPiwASSXH0PmD/045FRXeEjtkbGvxORiX5qRx9
         39PCVMkVYwn8D7BLP5SaOO0DOOwye7bA9ssWQ5tzWFR9VKbsUlc4+OIAWBSs20y7Hbfl
         P3Lyb6Kb4IyflZc0+cyhbS/bit6nPucd5ZhrARYMsD6DWMcSj3lNMpa3CNKiXlrG7kVN
         fLbZ2pIEG203VnTNbwcfVI/4kOYNwXsq3jojLo5P4Vd+mDnFUt0252Y0q/EL3G2FWCcz
         WOvk3Lvj+Sz87VevFYHKr6G0BUCjSySkD7+qkXtF62hvK2MHnTomnJAmBJJTJ3Al1Uo6
         JYFA==
X-Gm-Message-State: AOAM530udQsFR7mYV3fMuzF/dgqjykUj6/QrjgmrZqOzTe3kk6lohgal
        GDiklq1hZ9KcBD8cXxdfu90=
X-Google-Smtp-Source: ABdhPJw134+G/gX/2aKHqQ2fcBsTr8dXSPjvDfXNMgE1caJmMYOZkBd2gfs0fek/SHBOS1VE+zwl4A==
X-Received: by 2002:a50:da0a:: with SMTP id z10mr2763366edj.298.1632952671266;
        Wed, 29 Sep 2021 14:57:51 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id g10sm544635ejj.44.2021.09.29.14.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:57:50 -0700 (PDT)
Date:   Thu, 30 Sep 2021 00:57:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 2/4 v4] net: dsa: rtl8366rb: Support flood
 control
Message-ID: <20210929215749.55mti6y66m4m75hj@skbuf>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-3-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929210349.130099-3-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:03:47PM +0200, Linus Walleij wrote:
> Now that we have implemented bridge flag handling we can easily
> support flood control as well so let's do it.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v3->v4:
> - No changes, rebased on the other patches.
> ChangeLog v2->v3:
> - Move the UNMC under the multicast setting as it is related to
>   multicast to unknown address.
> - Add some more registers from the API, unfortunately we don't
>   know how to make use of them.
> - Use tabs for indentation in copypaste bug.
> - Since we don't know how to make the elaborate storm control
>   work just mention flood control in the message.
> ChangeLog v1->v2:
> - New patch
> ---
>  drivers/net/dsa/rtl8366rb.c | 55 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index b3056064b937..52e750ea790e 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -164,6 +164,26 @@
>   */
>  #define RTL8366RB_VLAN_INGRESS_CTRL2_REG	0x037f
>  
> +/* Storm registers are for flood control
> + *
> + * 02e2 and 02e3 are defined in the header for the RTL8366RB API
> + * but there are no usage examples. The implementation only activates
> + * the filter per port in the CTRL registers.

The "filter" word bothers me a bit.
Are these settings applied on ingress or on egress? If you have
RTL8366RB_STORM_BC_CTRL == BIT(0) | BIT(1), and a broadcast packet is
received on port 2, then

(a) is it received or dropped?
(b) is it forwarded to port 0 and 1?
(c) is it forwarded to port 3?

> + */
> +#define RTL8366RB_STORM_FILTERING_1_REG		0x02e2
> +#define RTL8366RB_STORM_FILTERING_PERIOD_BIT	BIT(0)
> +#define RTL8366RB_STORM_FILTERING_PERIOD_MSK	GENMASK(1, 0)
> +#define RTL8366RB_STORM_FILTERING_COUNT_BIT	BIT(1)
> +#define RTL8366RB_STORM_FILTERING_COUNT_MSK	GENMASK(3, 2)
> +#define RTL8366RB_STORM_FILTERING_BC_BIT	BIT(5)
> +#define RTL8366RB_STORM_FILTERING_2_REG		0x02e3
> +#define RTL8366RB_STORM_FILTERING_MC_BIT	BIT(0)
> +#define RTL8366RB_STORM_FILTERING_UNDA_BIT	BIT(5)
> +#define RTL8366RB_STORM_BC_CTRL			0x03e0
> +#define RTL8366RB_STORM_MC_CTRL			0x03e1
> +#define RTL8366RB_STORM_UNDA_CTRL		0x03e2
> +#define RTL8366RB_STORM_UNMC_CTRL		0x03e3
> +
>  /* LED control registers */
>  #define RTL8366RB_LED_BLINKRATE_REG		0x0430
>  #define RTL8366RB_LED_BLINKRATE_MASK		0x0007
> @@ -1282,8 +1302,8 @@ rtl8366rb_port_pre_bridge_flags(struct dsa_switch *ds, int port,
>  				struct switchdev_brport_flags flags,
>  				struct netlink_ext_ack *extack)
>  {
> -	/* We support enabling/disabling learning */
> -	if (flags.mask & ~(BR_LEARNING))
> +	if (flags.mask & ~(BR_LEARNING | BR_BCAST_FLOOD |
> +			   BR_MCAST_FLOOD | BR_FLOOD))
>  		return -EINVAL;
>  
>  	return 0;
> @@ -1305,6 +1325,37 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
>  			return ret;
>  	}
>  
> +	if (flags.mask & BR_BCAST_FLOOD) {
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_BC_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_BCAST_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (flags.mask & BR_MCAST_FLOOD) {
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_MC_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_MCAST_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +		/* UNMC = Unknown multicast address */
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNMC_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (flags.mask & BR_FLOOD) {
> +		/* UNDA = Unknown destination address */
> +		ret = regmap_update_bits(smi->map, RTL8366RB_STORM_UNDA_CTRL,
> +					 BIT(port),
> +					 (flags.val & BR_FLOOD) ? BIT(port) : 0);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.31.1
> 

