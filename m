Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591AE48937E
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 09:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbiAJIfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 03:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241234AbiAJIeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 03:34:13 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B9EC034001;
        Mon, 10 Jan 2022 00:34:11 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id x4so31864wru.7;
        Mon, 10 Jan 2022 00:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=lNSsss1h/FFXNSnH/IYCrMAKhkL6jn0IjV56jnSpNjw=;
        b=G+oL7HjsCA8HwbuU5Nj0cTjleO+YGLfdlyITGBNb9tIjhcDgnoAQNNyiBEmF7eEIU1
         qYCG15MJyH6LOY3PO9wRyV3bb62PIODTamp80vKdfbAM9lLO0jsGeI13C9vFK+ysdi8u
         g2FUrjxrRJguJbqX2eWeUcOgKrOEQv6ORG3Qb8PuPA2v9lYrD3gue/pKxXYMKY1VxfUs
         V/MlOCuKWccweq/7k0AALmWzLxtkniUVDKz9CHMj7LvZbISWResVSf5PDKt1clc1NUjI
         tme2LhqGlJzMQCVdSF5LwRBSxpNWJUisc5251R89ikOPAoaK/ZLM0GK7bMlhCizRj/ej
         SJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=lNSsss1h/FFXNSnH/IYCrMAKhkL6jn0IjV56jnSpNjw=;
        b=dRalgIqT7fgtHMOHJgFWM0qqj3Xxv+Va9dxKOWJGHc5HPPYyRVq1e3R7qOa4AhMeDz
         PW7Xu+MHAdBzxjpVPDqM7A3Fwe+/z9G3uDFCrWx1lSqCAniGK9/YLyHmO3TXAHEF6c2e
         oJbGM4/c4c0a85g8Vp6zJMkx8clA7+lqBaBtsHrR3HAbziGdm+hZdSn4leJK+rCgUSEF
         wP8/mArVg3FtLhitKEJSZu9zLPLxDvIhZfl1eGqGU2PJ9ss3GQtQDUhHiwQwidSEaD84
         Ufmu/3xNShT/2Pv38pKyqIEER3u+qPFlB1uOo5c2vHC38t75ivsJ6kbLrJQoPvfsg3B1
         PTyA==
X-Gm-Message-State: AOAM533i5YQd5jxGQI0t5HrJSQsgpbs6WzqDBQJcJK8pLj2OZ8Cw5jrH
        5+WD55thi+yaWOSlPTicTEM=
X-Google-Smtp-Source: ABdhPJxcjmVutcCJGty+DYcanfxkNrNlA8eX+3YH2QlNCkZrpXCKnWq/8af/cHsLU98mtwXnuvZ0Dw==
X-Received: by 2002:adf:df85:: with SMTP id z5mr10545614wrl.85.1641803650539;
        Mon, 10 Jan 2022 00:34:10 -0800 (PST)
Received: from ?IPV6:2003:ea:8f2f:5b00:7dd9:1304:f7a3:5cd1? (p200300ea8f2f5b007dd91304f7a35cd1.dip0.t-ipconnect.de. [2003:ea:8f2f:5b00:7dd9:1304:f7a3:5cd1])
        by smtp.googlemail.com with ESMTPSA id z22sm6570532wmp.40.2022.01.10.00.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 00:34:10 -0800 (PST)
Message-ID: <1be1444c-b1f7-b7d6-adaa-78960c381161@gmail.com>
Date:   Mon, 10 Jan 2022 09:34:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
 <20220110062117.17540-2-mohammad.athari.ismail@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
 loopback
In-Reply-To: <20220110062117.17540-2-mohammad.athari.ismail@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.2022 07:21, Mohammad Athari Bin Ismail wrote:
> Existing genphy_loopback() is not applicable for Marvell PHY. So,
> adding Marvell specific PHY loopback operation by only setting(enable) or
> clearing(disable) BMCR_LOOPBACK bit.
> 
> Tested working on Marvell 88E1510.
> 
With this change you'd basically revert the original change and loose
its functionality. Did you check the Marvell datasheets?
At least for few versions I found that you may have to configure
bits 0..2 in MAC Specific Control Register 2 (page 2, register 21)
instead of BMCR.


> Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> ---
>  drivers/net/phy/marvell.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 4fcfca4e1702..2a73a959b48b 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -1932,6 +1932,12 @@ static void marvell_get_stats(struct phy_device *phydev,
>  		data[i] = marvell_get_stat(phydev, i);
>  }
>  
> +static int marvell_loopback(struct phy_device *phydev, bool enable)
> +{
> +	return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> +			  enable ? BMCR_LOOPBACK : 0);
> +}
> +
>  static int marvell_vct5_wait_complete(struct phy_device *phydev)
>  {
>  	int i;
> @@ -3078,7 +3084,7 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_sset_count = marvell_get_sset_count,
>  		.get_strings = marvell_get_strings,
>  		.get_stats = marvell_get_stats,
> -		.set_loopback = genphy_loopback,
> +		.set_loopback = marvell_loopback,
>  		.get_tunable = m88e1011_get_tunable,
>  		.set_tunable = m88e1011_set_tunable,
>  		.cable_test_start = marvell_vct7_cable_test_start,

