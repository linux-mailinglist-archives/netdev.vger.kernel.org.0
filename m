Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BB732B43A
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbhCCEvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352990AbhCCEre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 23:47:34 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584A7C061794;
        Tue,  2 Mar 2021 20:35:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id a23so5597821pga.8;
        Tue, 02 Mar 2021 20:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y8OzdNWcBJeKdwlIFPut/1hYd9sV03/JrzIaxRse+uI=;
        b=THCBxVpcD3aRopK3ttdbigSxxusmLRIWHbTpyFVoMZSsBM8gcH8LvR4c6992soQ/DZ
         iznNLQftY/MgtwoK5RhY0XhhkeNntVMSLzst8M+AURW9LYZzQmFUsOIMbfrp5wptXOwl
         73IB30MPLjGTA43tZSJr56Lp0pl+SJG+SBYmtJgvoysLmmn0PSW5FB0L2HXnhwmce+l2
         YGT4eEUe43V71qSD74L6ypU8f0BqBmSpYtq7ejFHCgz9HCLMX4zxYxMkNlOwtjzkLEc3
         YTcPa08CUq/Me/6Ayht1Wl80YWa/cSfGHyfw57XBlP7vEc0hQdMvBY2WSm/d5R2/Nekt
         B3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y8OzdNWcBJeKdwlIFPut/1hYd9sV03/JrzIaxRse+uI=;
        b=U/9L7ZdD6iEYjEo9+dOsUd1DlL8OHp/Lw3s5Vu1uDEMR0Yc43pSMcUw4OvIqqtNA2M
         uDX4nJtighFJ9b0VWl3lT4fMMl1YJt5zflpmp2vhb4DWXhqe7okT0SFDmKdWF9ZuHIQg
         s4AsvHAiJSfNn/UJC5kD/6If9ZRfZzUUTIvgIt6sFQXKbCENtDvg/mMH+CCtRDG32ejt
         pSQ/Hy/0jMlzDF5i57itXNSi4hRsdd+XpXte+KtnupHKboLfrDG34VA+7kfwbj8uKumX
         tzeplWhTaHWpcGsyRyBxRZSeBydL524sM4F756dBcLXcWWivRKiappY01+afQbFOrvfZ
         pkGA==
X-Gm-Message-State: AOAM533q0yJrzfw6CDR3Tk9nOTtzHjLz2CK6TAA7o8MtO6myBgYId2KA
        CZGduEcg7L8NmizuSDLXCv8VS6IXook=
X-Google-Smtp-Source: ABdhPJyHCU6KFRshjWG+v5RZdB5zlhianADkLKAgvLVuxlaCRtcjxqWujQHcDBWm1jHraonpSVlkgA==
X-Received: by 2002:a63:e5e:: with SMTP id 30mr21855257pgo.181.1614746117042;
        Tue, 02 Mar 2021 20:35:17 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j125sm24139535pfd.27.2021.03.02.20.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 20:35:16 -0800 (PST)
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
To:     DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210224061205.23270-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d59284c9-1767-cefd-dff7-3e50cd67a84b@gmail.com>
Date:   Tue, 2 Mar 2021 20:35:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210224061205.23270-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/2021 10:12 PM, DENG Qingfang wrote:
> Use port isolation registers to configure bridge offloading.
> Remove the VLAN init, as we have proper CPU tag and bridge offloading
> support now.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> This is not tested, as I don't have a RTL8366RB board. And I think there
> is potential race condition in port_bridge_{join,leave}.
> 
>  drivers/net/dsa/rtl8366rb.c | 73 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a89093bc6c6a..9f6e2b361216 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -300,6 +300,12 @@
>  #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
>  #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
>  
> +/* Port isolation registers */
> +#define RTL8366RB_PORT_ISO_BASE		0x0F08
> +#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
> +#define RTL8366RB_PORT_ISO_EN		BIT(0)
> +#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
> +
>  /* bits 0..5 enable force when cleared */
>  #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
>  
> @@ -835,6 +841,15 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  	if (ret)
>  		return ret;
>  
> +	/* Isolate user ports */
> +	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
> +		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
> +				   RTL8366RB_PORT_ISO_EN |
> +				   BIT(RTL8366RB_PORT_NUM_CPU + 1));
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* Set up the "green ethernet" feature */
>  	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
>  				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
> @@ -963,10 +978,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  			return ret;
>  	}
>  
> -	ret = rtl8366_init_vlan(smi);
> -	if (ret)
> -		return ret;
> -
>  	ret = rtl8366rb_setup_cascaded_irq(smi);
>  	if (ret)
>  		dev_info(smi->dev, "no interrupt support\n");
> @@ -977,8 +988,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  		return -ENODEV;
>  	}
>  
> -	ds->configure_vlan_while_not_filtering = false;

If you have a configuration with ports that are part of a bridge with
VLAN filtering enabled, what happens to the standalone ports, are they a
member of a default VLAN entry still?
-- 
Florian
