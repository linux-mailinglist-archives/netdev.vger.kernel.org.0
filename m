Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C3315813
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhBIUvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbhBIUlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:41:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC81C061D7D;
        Tue,  9 Feb 2021 12:03:33 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j21so4715282wmj.0;
        Tue, 09 Feb 2021 12:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FoYK3y10ctekenhelipPCy41KdN9ge4kiy1j5pEZXLw=;
        b=HMfndgWGrWMGy8RaSKT37wbq03RbZzqlph/TOTwab64sLwa0lgi8GwHmvk3MKt9B45
         4bB5Jq029HFtqLZz9ykNAdLxWkNofceRGXj0B1Nt2JJdnLsnkDP2+Ktr+60hMPkv4ixY
         9fG+3pOquCkWq9FsDWJ2+dy+BLhVkhMDY9OtX1h3UsIte18rfISsUt+jX0TKxq4N1Wi/
         ypRGvEwx33PBSdrFbxFqayQGNGT2EgvtZI5eGwTTjsIilaUtS08EI54MbfK0B2OlCqjd
         6D36OPdz16p++vAO4BOO9RGmGyBmG6+vyfxbTFT+61LKv7rjUNhSeWXhB3v1t5R0J0fS
         +XPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FoYK3y10ctekenhelipPCy41KdN9ge4kiy1j5pEZXLw=;
        b=p43XBaJpq3HIdJULfwD6QnPTPC/jD7umYiyAkCc4ud/JSOFHoRNXVguMnPkddmW5Ss
         mh3vEanZzdfx7YHQN5edrwV2rHSiNcm18mng6xMLpUeDtgv6tMtsQX8OWBsJFiCPFOLP
         DNxgIwpE3ynXuEJTyivcbsqSoanbe57qbGxi+KEh+nbxLxe89AQ19O2ZgKuZxZWxwU2c
         0sTUyE6xQ8yQtJIGVMDd3ww1x/HW1RiSSxV7hwwIhPdj3P9hnqDMmNe1mOzMPYFbgImB
         YHVXEzKQUMKOk7g354DAF6icCIUyDOGRowOT9OGRv+O55Z4XqZD3/co/QtLCDB9OO8sQ
         KtJQ==
X-Gm-Message-State: AOAM532HRVc8J/XGEXzKqlPjjXFM/vf1Y7h2JhUn5Yl+myA+zZdbteWM
        yWGiRG8rz+z578l3CpQ8aI4=
X-Google-Smtp-Source: ABdhPJz5OlEcAcggpLfAl4VV5ssEWmy3CP/KlCueOmAIJTpPkr2Ukj3pis4ID9oEvKpAVoyN8/BhSA==
X-Received: by 2002:a1c:2d8a:: with SMTP id t132mr4876062wmt.119.1612901012414;
        Tue, 09 Feb 2021 12:03:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:d8e6:4a8a:b30f:47d8? (p200300ea8f1fad00d8e64a8ab30f47d8.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:d8e6:4a8a:b30f:47d8])
        by smtp.googlemail.com with ESMTPSA id j40sm5670486wmp.47.2021.02.09.12.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 12:03:31 -0800 (PST)
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-6-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 5/9] net: phy: icplus: add IP101A/IP101G model
 detection
Message-ID: <4645b902-aab4-c4d8-a5a9-1fbaf0ca67f6@gmail.com>
Date:   Tue, 9 Feb 2021 21:03:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209164051.18156-6-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.2021 17:40, Michael Walle wrote:
> Unfortunately, the IP101A and IP101G share the same PHY identifier.
> While most of the functions are somewhat backwards compatible, there is
> for example the APS_EN bit on the IP101A but on the IP101G this bit
> reserved. Also, the IP101G has many more functionalities.
> 
> Deduce the model by accessing the page select register which - according
> to the datasheet - is not available on the IP101A. If this register is
> writable, assume we have an IP101G.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/phy/icplus.c | 43 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
> index 036bac628b11..189a9a34ed5f 100644
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
> @@ -61,8 +63,14 @@ enum ip101gr_sel_intr32 {
>  	IP101GR_SEL_INTR32_RXER,
>  };
>  
> +enum ip101_model {
> +	IP101A,
> +	IP101G,
> +};
> +
>  struct ip101a_g_phy_priv {
>  	enum ip101gr_sel_intr32 sel_intr32;
> +	enum ip101_model model;
>  };
>  
>  static int ip175c_config_init(struct phy_device *phydev)
> @@ -175,6 +183,39 @@ static int ip175c_config_aneg(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +/* The IP101A and the IP101G share the same PHY identifier.The IP101G seems to
> + * be a successor of the IP101A and implements more functions. Amongst other
> + * things a page select register, which is not available on the IP101. Use this
> + * to distinguish these two.
> + */
> +static int ip101a_g_detect_model(struct phy_device *phydev)
> +{
> +	struct ip101a_g_phy_priv *priv = phydev->priv;
> +	int oldval, ret;
> +
> +	oldval = phy_read(phydev, IP101G_PAGE_CONTROL);
> +	if (oldval < 0)
> +		return oldval;
> +
> +	ret = phy_write(phydev, IP101G_PAGE_CONTROL, 0xffff);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_read(phydev, IP101G_PAGE_CONTROL);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret == IP101G_PAGE_CONTROL_MASK)
> +		priv->model = IP101G;
> +	else
> +		priv->model = IP101A;
> +
> +	phydev_dbg(phydev, "Detected %s\n",
> +		   priv->model == IP101G ? "IP101G" : "IP101A");
> +
> +	return phy_write(phydev, IP101G_PAGE_CONTROL, oldval);
> +}
> +
>  static int ip101a_g_probe(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
> @@ -203,7 +244,7 @@ static int ip101a_g_probe(struct phy_device *phydev)
>  
>  	phydev->priv = priv;
>  
> -	return 0;
> +	return ip101a_g_detect_model(phydev);
>  }
>  
>  static int ip101a_g_config_init(struct phy_device *phydev)
> 

You could also implement the match_phy_device callback. Then you can
have separate PHY drivers for IP101A/IP101G. Would be cleaner I think.
See the Realtek PHY driver for an example.
