Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44283344FD
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 18:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhCJRT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 12:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhCJRTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 12:19:52 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24A6C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 09:19:52 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p21so11822501pgl.12
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 09:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R5xTic7oJ1rT0FasCzvBYP7dmF6+zw+es64ddyv5g3c=;
        b=nESwBe7dPPDSAXh2dUD49IJkGOXwe4CGCXevUqMegXk6UpigyJBR8iYsuCxtmHl640
         dL3C7X+lygfqp5KWxUis2B+briFivJIiudehfYqVggpKmSEPowTM3fz8YRXgdEt9dlKI
         Gmzc4CmHKKc8r48pJuXhUPhsqPlF4qMY6iFbJ0MqT/XYK1VhTztKPoOQGVMYWKE3pOyf
         3Welc+7LS7ITC/RZ3P5EfyMlKCO/ffom+XakWEy/2x660xVQuK6TJICQb9pzZF2XtTbx
         wpjIwnwWNf9gmYgpeyjMHdiCWYf16MPOB1rfaQAdwayiVrxkOcux/1CqHaZ572rERjzU
         Cxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R5xTic7oJ1rT0FasCzvBYP7dmF6+zw+es64ddyv5g3c=;
        b=rvyXLonAUPsfWS0pjcFL2NyFO92cBrhWUApaIs57wltjOu5rJLDc5ZukgDEEdSAhYB
         2sN20eOBnWdJazU6GHTUEx7SBCcBI41gdRlQBKFis8lHuDXl25jhRzg34wELJa29O/yY
         4IKC9iOqRNBfrua6zCr/FAhhVFy+w4gA37bt0CXrZWb7v1jK7xs9/9n8jrbsb81J2RFk
         xMUHuOGZpWhs1LK+Mwef/wU4WzgX3Sz17rACv8sfHj8LKm3OWvn10L+9veBOFoX/hemV
         vDMU3ln6VIxkEc6P7uoJuTC8I13DPIoroXvb8ZHTlwhpgnlxWZQtcE8UrQrAq6SnKMWg
         livA==
X-Gm-Message-State: AOAM53161Un9oK3gKxJCs/fXVVIYA57XH685+NBu4xAVI0NxN0By73cC
        mg03HjEPCwnwTaBDV8MSoRs=
X-Google-Smtp-Source: ABdhPJw8OfqIiO0l/xboykiOOahI3bjSgfEvtNsEjYJqq7l2D4IqXL7pHmMu1N7KJI622H2mDmxbHQ==
X-Received: by 2002:aa7:96bc:0:b029:1f6:9937:fe43 with SMTP id g28-20020aa796bc0000b02901f69937fe43mr3773587pfk.68.1615396792129;
        Wed, 10 Mar 2021 09:19:52 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id il6sm8389pjb.56.2021.03.10.09.19.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 09:19:51 -0800 (PST)
Subject: Re: [PATCH] net: dsa: bcm_sf2: setup BCM4908 internal crossbar
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210310115951.14565-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dafc2ec7-871b-3ddc-d094-400055e81e4c@gmail.com>
Date:   Wed, 10 Mar 2021 09:19:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310115951.14565-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 3:59 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> On some SoCs (e.g. BCM4908, BCM631[345]8) SF2 has an integrated
> crossbar. It allows connecting its selected external ports to internal
> ports. It's used by vendors to handle custom Ethernet setups.
> 
> BCM4908 has following 3x2 crossbar. On Asus GT-AC5300 rgmii is used for
> connecting external BCM53134S switch. GPHY4 is usually used for WAN
> port. More fancy devices use SerDes for 2.5 Gbps Ethernet.
> 
>               ┌──────────┐
> SerDes ─── 0 ─┤          │
>               │   3x2    ├─ 0 ─── switch port 7
>  GPHY4 ─── 1 ─┤          │
>               │ crossbar ├─ 1 ─── runner (accelerator)
>  rgmii ─── 2 ─┤          │
>               └──────────┘
> 
> Use setup data based on DT info to configure BCM4908's switch port 7.
> Right now only GPHY and rgmii variants are supported. Handling SerDes
> can be implemented later.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/dsa/bcm_sf2.c      | 41 ++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/bcm_sf2.h      |  1 +
>  drivers/net/dsa/bcm_sf2_regs.h |  7 ++++++
>  3 files changed, 49 insertions(+)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 8f50e91d4004..b4b36408f069 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -432,6 +432,40 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
>  	return 0;
>  }
>  
> +static void bcm_sf2_crossbar_setup(struct bcm_sf2_priv *priv)
> +{
> +	struct device *dev = priv->dev->ds->dev;
> +	int shift;
> +	u32 mask;
> +	u32 reg;
> +	int i;
> +
> +	reg = 0;

I believe you need to do a read/modify/write here otherwise you are
clobbering the other settings for the p_wan_link_status and
p_wan_link_sel bits.

> +	switch (priv->type) {
> +	case BCM4908_DEVICE_ID:
> +		shift = CROSSBAR_BCM4908_INT_P7 * priv->num_crossbar_int_ports;
> +		if (priv->int_phy_mask & BIT(7))
> +			reg |= CROSSBAR_BCM4908_EXT_GPHY4 << shift;
> +		else if (0) /* FIXME */
> +			reg |= CROSSBAR_BCM4908_EXT_SERDES << shift;
> +		else

Maybe what you can do is change bcm_sf2_identify_ports() such that when
the 'phy-interface' property is retrieved from Device Tree, we also
store the 'mode' variable into the per-port structure
(bcm_sf2_port_status) and when you call bcm_sf2_crossbar_setup() for
each port that has been setup, and you update the logic to look like this:

if (priv->int_phy_mask & BIT(7))
	reg |= CROSSBAR_BCM4908_EXT_GPHY4 << shift;
else if (phy_interface_mode_is_rgmii(mode))
	reg |= CROSSBAR_BCM4908_EXT_RGMII

and we add support for SerDes when we get to that point. This would also
allow you to detect if an invalid configuration is specified via Device
Tree.
	
Other than that, this looks good to me, thanks!
-- 
Florian
