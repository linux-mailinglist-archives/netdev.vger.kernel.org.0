Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7AF33EB29
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhCQIPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhCQIPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 04:15:18 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDC1C06174A;
        Wed, 17 Mar 2021 01:15:17 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 12so917050wmf.5;
        Wed, 17 Mar 2021 01:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2C2nS2FuL5jIhqAY/uOCR718M7JpaJd6K5UxD7QBZ0c=;
        b=gKEcCTAzqvl6UcV0JWtxYfgS4mkNy0j7CKcuoZN0yc1FuCnS7UWDHaH9tUkIbPWw8S
         PpWTOg/bdzs8nexa2qdaE4CwxflXq8MOZ0fUIqJRjktExHNx5L+73lmykE64Bx2iU1pw
         jqSR6Hzcmd95d8FUroe/k5CvPz5IdtNDSgA/qi0Nqa+2AFSoE2eCC++keWgca+yhdKZF
         KD8KLfVtPkPGKPmqo+n7ksyh9WFH5pqf+nGP5mUzc3gymPo3yUvOQo/MFVrfCvBUgx3A
         GmH7VSxJx0RNhcec/1D8osxwGFnCzouAYDOTwKzmLvzTTbvX/7tuwGUFntIhTgZfj9NY
         2fuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2C2nS2FuL5jIhqAY/uOCR718M7JpaJd6K5UxD7QBZ0c=;
        b=IEApST4Z2fEgoSRxE0VBp236IUuOlqEG2qrCnq9Vlt+48O/nCWfP0g+u3//B2wNDRp
         1nQnxA5ow/q3odR0flVbtK6oT5LiF3EM8ns1+BxXXk4OJpK5h7CsA/ojMTHC8hU0Oafo
         wX9GIhAOaOZYpXLXfova3sUfPuSYo5prTFUaTYZYl+MZ12TNp4c2YWbKuQ2/SCULC/sk
         fe5XbUyBi1OsMcoqXcU+RdWIujS7Toi90Y/XUPDLQYuHfcNSXo/k5PfjDrOYS1ir4Q5W
         9Ri/7VWqFPmBxmgeTyDwFNdJOON5s6aBGEK7RpImF06aEAQdu0bNYcUr5X4D488r1p8o
         /J1g==
X-Gm-Message-State: AOAM532p85Oq9/yTSnRV8Zptpy+wV8OoTgu7sp2xHPdA8kl/ZyplFxWO
        t3XZjP3OAi6xyXqdXxGYNiQ=
X-Google-Smtp-Source: ABdhPJzX4WCDwk6IxuS01Nm/yXC+ACwGHPPl9kypRe2EEfWymsCJ9UtVYQFLKhDE/japhuJA+VrwPw==
X-Received: by 2002:a1c:a916:: with SMTP id s22mr2568037wme.82.1615968914088;
        Wed, 17 Mar 2021 01:15:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:c04c:c4a7:d0c5:8ae7? (p200300ea8f1fbb00c04cc4a7d0c58ae7.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:c04c:c4a7:d0c5:8ae7])
        by smtp.googlemail.com with ESMTPSA id s84sm1694787wme.11.2021.03.17.01.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 01:15:13 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] net: phy: fix invalid phy id when probe
 using C22
To:     Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Weifeng <voon.weifeng@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210316085748.3017-1-vee.khee.wong@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eba4f81c-adc0-61d1-8cb9-4c0c5995bc49@gmail.com>
Date:   Wed, 17 Mar 2021 09:15:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210316085748.3017-1-vee.khee.wong@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.03.2021 09:57, Wong Vee Khee wrote:
> When using Clause-22 to probe for PHY devices such as the Marvell
> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
> which caused the PHY framework failed to attach the Marvell PHY
> driver.
> 

The issue occurs with a MAC driver that sets MDIO bus capability
flag MDIOBUS_C22_C45, like stmmac? Or what is the affected MAC
driver?

And if you state it's a fix, a Fixes tag would be needed.

> Fixed this by adding a check of PHY ID equals to all zeroes.
> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Voon Weifeng <voon.weifeng@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
>  drivers/net/phy/phy_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index a009d1769b08..f1afc00fcba2 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -820,8 +820,8 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
>  
>  	*phy_id |= phy_reg;
>  
> -	/* If the phy_id is mostly Fs, there is no device there */
> -	if ((*phy_id & 0x1fffffff) == 0x1fffffff)
> +	/* If the phy_id is mostly Fs or all zeroes, there is no device there */
> +	if (((*phy_id & 0x1fffffff) == 0x1fffffff) || (*phy_id == 0))
>  		return -ENODEV;
>  
>  	return 0;
> 

