Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2432231A4D3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhBLS4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhBLS4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:56:52 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B32C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 10:56:11 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cv23so138066pjb.5
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 10:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XrDbqWR//21E1kByq2QvGJS3oBgO8Xpv8m2V3dV+4Ps=;
        b=Kp9spoEkeYdaDfA7AwldqwMUigC78eZ/F09S+TC8P+I3ryBxf4YSQqoXyfs/zI3cXr
         6esjNQZjeozuomuXTYY4zAp6WtK6bLdAc7hy5OjkYGfg+4alX75OgsOur8h+k+gF4Sg8
         6JQQ6cQOPtK8tcDgyiZaWQvCF6uncBvYkQ/Ezj894udIPrIaD6KAlDjAge5MNWSoutYO
         wY3p3h3iD8L6/JcpTuwSw8ZYPsdPQ8+sjaYKV/iPiLrtraJDGEwNQgLxbw7uq8+mWAwv
         1lQZSW8ZawvPwPIZ1U5QwdZd/w4Cqi7rz5cpEgpyqS3ycTaoJ8jaxm/g8GFE6i8Tw3Cr
         bU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XrDbqWR//21E1kByq2QvGJS3oBgO8Xpv8m2V3dV+4Ps=;
        b=lhFBq2G87eyi8WObK/lI9izqrTPNKAkTUJX5DgL9gPwUhg7JiHSZ//InqiXObz21TP
         xmteD8PMK8z54e3diBWw2lhvhpCicPcJYmbtVsh/9E1LHtdUVWKYzx5VQX8yDNbsHePS
         In1RHZJDvPAiPEZJcaBBVgIAC+CjiViN0gsZC7X267j/n3EnJHWT2rp+EsyWRqcD+cxS
         igEnhaYN5pKH++vzeCsLuTMjLxvOHuIsX34L3Rugk9QfVniQnsqk5C14kLt3bmWnoz+S
         miffM9hSoXHAuKxD2H6t0iRnPuEQvsC2L7/kJIKfnM29KCKU20Pt8VeJkbCpdu4gAty+
         4+lg==
X-Gm-Message-State: AOAM530JA67ycKk2gPES3olY6E/zBEUi6UfBqsnDiIv99GCpHZE/NmeC
        JKYR6vk0zUnGeaB88oyNwXQnGLw2Iz8=
X-Google-Smtp-Source: ABdhPJwf+CJGQpGxAJRkCptQmjn7zVc5SBuId8UHcJpo9neXdDybL3OYq/mdIM+s5GkB1BUUGfyaIA==
X-Received: by 2002:a17:902:f1c2:b029:e2:fb7d:7e58 with SMTP id e2-20020a170902f1c2b02900e2fb7d7e58mr4072227plc.54.1613156170943;
        Fri, 12 Feb 2021 10:56:10 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p8sm9917078pgi.21.2021.02.12.10.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:56:10 -0800 (PST)
Subject: Re: [PATCH 4/4] amd-xgbe: Fix network fluctuations when using 1G
 BELFUSE SFP
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com
References: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
 <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4af6960f-ed25-16f4-df47-bd018bc44a9c@gmail.com>
Date:   Fri, 12 Feb 2021 10:56:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212180010.221129-5-Shyam-sundar.S-k@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 10:00 AM, Shyam Sundar S K wrote:
> Frequent link up/down events can happen when a Bel Fuse SFP part is
> connected to the amd-xgbe device. Try to avoid the frequent link
> issues by resetting the PHY as documented in Bel Fuse SFP datasheets.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> ---
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 1bb468ac9635..e328fd9bd294 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -922,6 +922,12 @@ static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
>  	if ((phy_id & 0xfffffff0) != 0x03625d10)
>  		return false;
>  
> +	/* Reset PHY - wait for self-clearing reset bit to clear */
> +	reg = phy_read(phy_data->phydev, 0x00);
> +	phy_write(phy_data->phydev, 0x00, reg | 0x8000);
> +	read_poll_timeout(phy_read, reg, !(reg & 0x8000) || reg < 0,
> +			  10000, 50000, true, phy_data->phydev, 0x0);

Can you use the standard register definitions from include/linux/mii.h
here? You are doing a software reset of the PHY through the BMCR.RESET
register, so you might as well make that clear.

> +
>  	/* Disable RGMII mode */
>  	phy_write(phy_data->phydev, 0x18, 0x7007);
>  	reg = phy_read(phy_data->phydev, 0x18);
> 

-- 
Florian
