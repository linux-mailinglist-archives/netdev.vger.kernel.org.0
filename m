Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973311B8236
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 00:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgDXWuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 18:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgDXWuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 18:50:54 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2103C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 15:50:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so13149567wmc.5
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8BEWtePU0v+uCkRcc3GIp/GMZ9QgxqSp8s6Ot/Xv/J8=;
        b=gE6QfX8jdwHdzM2OKoa61axS+BEzh2mnzlBOQiaMSUx6+mcARvAE63aFVlvmDDdY3e
         4oSJ8POMDh7O/Fk0JxCs+xSn60sb1Z+HWcFu4UxQ4H4hJ0vf/8WmX8jzoO/p15XF2NAe
         qIOosX0VqZ2XlrPwUXPEnvEZCIOnpFn8KnjTq36hK/BpD9IGvGuHlFqyFpJ4ob/ZlTnp
         CI2ew0Igx+0qCy7Ws7+xejiww+yHAxqiDAXwEZNfEdRqOGhYGHQXop0yXADsuSQT08Bj
         WuBnEngk5SmBMzLNR6o4N2QjclSSbZyOcmz7q4AlidrrsIIhDrfKnffqHD10HQ0Bim84
         pWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8BEWtePU0v+uCkRcc3GIp/GMZ9QgxqSp8s6Ot/Xv/J8=;
        b=D+w14AUWrZeQIQgHB/idnd92dLCx8vSgm0giEJewrdVGwurUq7MyYZuBox7Ag/OWpT
         g5eDiB/efKsOfAklFoO0OsMhHG5kl96kgQ6Eyf6BHPpiLeksUcJgXj4k4biiPAvRD407
         lURrDmTpUjBMz5hF/VJFChwDdIkWwau3TzID5zlkLL1MOknK2CrvDsRpN6S7N7grnzri
         amcRi2+R3GuLc1SayZo0PGsqWdcQCqueL8ivsIHaV9zWIZvsn2oDW+SJ5xcWRC7IZPCz
         BpJaHq+p4jjjSJCee2yYF74Ua6LxG283Hshbg1GJ/cMhNghf3zu6k3o3ULimAWfq65/y
         FXaw==
X-Gm-Message-State: AGi0PubTZCI5ENQPVTeE/W7n4l7DHOG/j150Hkgx3VLsLAIud/u/yTD6
        lsjZrVXO8R8gqbaFR9H0aovbw7YC
X-Google-Smtp-Source: APiQypKSKb4f+JqrpmRZK6KQvjMLL5I49S+UcN/Tau4eDG7d6B4rjLXGXF7IhNdcajcET5SiA3J5bQ==
X-Received: by 2002:a1c:2392:: with SMTP id j140mr12516372wmj.136.1587768650953;
        Fri, 24 Apr 2020 15:50:50 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r18sm7038927wrj.70.2020.04.24.15.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 15:50:50 -0700 (PDT)
Subject: Re: [RFC PATCH dpss_eth] Don't initialise ports with no PHY
To:     Darren Stevens <darren@stevens-zone.net>, madalin.bacur@nxp.com,
        netdev@vger.kernel.org
Cc:     oss@buserror.net, chzigotzky@xenosoft.de,
        linuxppc-dev@lists.ozlabs.org
References: <20200424232938.1a85d353@Cyrus.lan>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b6d84c65-a75a-a64d-463f-b0646862e322@gmail.com>
Date:   Fri, 24 Apr 2020 15:50:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424232938.1a85d353@Cyrus.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/24/2020 3:29 PM, Darren Stevens wrote:
> Since cbb961ca271e ("Use random MAC address when none is given")
> Varisys Cyrus P5020 boards have been listing 5 ethernet ports instead of
> the 2 the board has.This is because we were preventing the adding of the
> unused ports by not suppling them a MAC address, which this patch now
> supplies.
> 
> Prevent them from appearing in the net devices list by checking for a
> 'status="disabled"' entry during probe and skipping the port if we find
> it. 
> 
> Signed-off-by: Darren Stevens <Darren@stevens-zone.net>
> 
> ---
> 
>  drivers/net/ethernet/freescale/fman/mac.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index 43427c5..c9ed411 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -606,6 +606,7 @@ static int mac_probe(struct platform_device *_of_dev)
>  	struct resource		 res;
>  	struct mac_priv_s	*priv;
>  	const u8		*mac_addr;
> +	const char 		*prop;
>  	u32			 val;
>  	u8			fman_id;
>  	phy_interface_t          phy_if;
> @@ -628,6 +629,16 @@ static int mac_probe(struct platform_device *_of_dev)
>  	mac_dev->priv = priv;
>  	priv->dev = dev;
>  
> +	/* check for disabled devices and skip them, as now a missing
> +	 * MAC address will be replaced with a Random one rather than
> +	 * disabling the port
> +	 */
> +	prop = of_get_property(mac_node, "status", NULL);
> +	if (prop && !strncmp(prop, "disabled", 8) {
> +		err = -ENODEV;
> +		goto _return
> +	}

There is a sorter version: of_device_is_available(mac_node) which will
do the same thing.

> +
>  	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
>  		setup_dtsec(mac_dev);
>  		priv->internal_phy_node = of_parse_phandle(mac_node,
> 

-- 
Florian
