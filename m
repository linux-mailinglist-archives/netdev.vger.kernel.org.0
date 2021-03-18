Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D9B3406CF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCRN0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCRN0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:26:03 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB9CC06174A;
        Thu, 18 Mar 2021 06:26:02 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so3357433wmi.3;
        Thu, 18 Mar 2021 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tn903V/DZ3bhwc3O5vkyieGLvXdfPZU7y2pYkPz0YuQ=;
        b=QnQB6KwIrslc7thN0KjQxwacqIVgDz4nf1Mw/mWSWzRt8wzS22lWmfdKBTCYbHp9rW
         Qu2oOA5eOw4c7ctyerlcu3EfoWY4RauocxDhVCZw0yyv41Wld2lnMVpWYpN5BtG6bU7M
         1cXkzrYGOeYhtFkRoG84ZM1M5/YAgcSqTFR1pqW7TLna5+ZvxaCtdtBqu39OkXngCO9H
         gQ38mugjm2jc6U5tz0TqmRSHi6cy14hn1wNmuB9qvZy85hXKD1rJxxC5Bli/K2OyCgPh
         SFf3YkM2neKMcovP94yI2TIC9MX2hq6zpRxj/JWGP0WXxABOQ8ekxSV6QINee0j69zWX
         grBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tn903V/DZ3bhwc3O5vkyieGLvXdfPZU7y2pYkPz0YuQ=;
        b=ZdjDxLh18ppoAHwHdE/HmBesYexIBrkgZ9EDk2xX54HBR3PidoyfvaIDVXAK+Ct4X2
         hZ0xcbDcRWI4i0h5S8n3bn+IS+CJNBtxYfDonPZ9sFmxr/3iIHQ+fBAjhJwA+iTUQ+l7
         trFlhf+0IXTqe2mippbqRnnnQEyt/4hmLVCYPBwNv1//DLbWptVNAgOrehAz1vdQ+W8j
         pUm/97gf1j5qTbswyGwCEveiyK7gziTvTLXlChIm2EcoxVupJe2aIPS+lcGhRx4ijFK4
         J0LBBzpu14KMGPw4JS09YJzKTlFheR+AWmEOX0+JIXHa+554GvXWukVq6ARZrARAWXgf
         QR0A==
X-Gm-Message-State: AOAM533Cg5x1HSqLfdBLlWj/L3R0kzapBbK0I9nz7Zvh2zmja5rXGQ9l
        GkqE2tH75wkaqV9aL5VBJi8=
X-Google-Smtp-Source: ABdhPJyfN0WSzgknqqEqBL2HY6BYfc7/QTb10jfmJ3dFp117hTlN1bgJtqZul9cUO7yW3KrgE1nRLA==
X-Received: by 2002:a1c:498b:: with SMTP id w133mr3824751wma.134.1616073961339;
        Thu, 18 Mar 2021 06:26:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84? (p200300ea8f1fbb008d2c08cc6c7f1a84.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:8d2c:8cc:6c7f:1a84])
        by smtp.googlemail.com with ESMTPSA id u8sm3060529wrr.42.2021.03.18.06.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 06:26:00 -0700 (PDT)
To:     Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Message-ID: <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
Date:   Thu, 18 Mar 2021 14:25:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318090937.26465-1-vee.khee.wong@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.03.2021 10:09, Wong Vee Khee wrote:
> When using Clause-22 to probe for PHY devices such as the Marvell
> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
> which caused the PHY framework failed to attach the Marvell PHY
> driver.
> 
> Fixed this by adding a check of PHY ID equals to all zeroes.
> 

I was wondering whether we have, and may break, use cases where a PHY,
for whatever reason, reports PHY ID 0, but works with the genphy
driver. And indeed in swphy_read_reg() we return PHY ID 0, therefore
the patch may break the fixed phy.
Having said that I think your patch is ok, but we need a change of
the PHY ID reported by swphy_read_reg() first.
At a first glance changing the PHY ID to 0x00000001 in swphy_read_reg()
should be sufficient. This value shouldn't collide with any real world
PHY ID.

> Fixes: ee951005e95e ("net: phy: clean up get_phy_c22_id() invalid ID handling")
> Cc: stable@vger.kernel.org
> Reviewed-by: Voon Weifeng <voon.weifeng@intel.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
> ---
> v2 changelog:
>  - added fixes tag
>  - marked for net instead of net-next
> ---
>  drivers/net/phy/phy_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index cc38e326405a..c12c30254c11 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -809,8 +809,8 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
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

