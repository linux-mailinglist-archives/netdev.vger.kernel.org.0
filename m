Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D132A1D3E4C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgENT7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727918AbgENT7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:59:17 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998B5C061A0C;
        Thu, 14 May 2020 12:59:16 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l17so270517wrr.4;
        Thu, 14 May 2020 12:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GX62db5RbtdxmRE1tpvcuQzwPjxV9Q6SgfpCbAoUODQ=;
        b=h3ybH72xJL+TMk9/Kq+QSS6x1TuTMFCBzjRWb8B1CMTkGGw8bw46eLR12XInmwA4Is
         Jz/TUUSgUINXr3nR/ATcmRV16vXdyX3CFUehDpkSKDKEMj0xNzyq40lvzPvanaAMLZai
         2zDQRMdjQgIse/SbbnKRN1M2y4q1id+TNgqhblFaCIe1llJUuk9i1dHNrRQnj0NtP1xT
         ESzMGktRPymxjICSFIl8NX2gvW1qioMrvpVBTSCU1TaUVJqjwTm+SSBRJrngPZBgGdWu
         Mr15L/JRwzCKkz+a5pBRKanfa1AYOzvKtGnvzR+Z1I2ifROlcpLuyAcTiW8UaKydgKwV
         M1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GX62db5RbtdxmRE1tpvcuQzwPjxV9Q6SgfpCbAoUODQ=;
        b=bFnOBCybZb4BWxZbSYo/pO+Uqfmz+oZpc5XJ/X/1pYPRnRJuFlJrHxGUu/F7fPR/Z3
         Tg09jUWa7zUvU1ao539A+mHnqkc9n8UonGaBjjZnn87oSdiJc03zO1mpLTh77+qAp5b8
         rcVEozxm8dHcXcU9koONjy58VigZT1+ldmvIlJyjjaXyK5IuUen0JrdEtZrIYophSES8
         6D/JFUei1/G5W0MAx1Knx0WmnuOfTj6o84wkAv8te60+jImwFEQoFHRSe59mFwsJNvAL
         zR3uasomACRcdPpitAUBorPWwZ5TiISD0zVZ0g0eMIzOj8ErgiPImQTpCWz8dZ/jIRO3
         8fgg==
X-Gm-Message-State: AOAM532rAkOXBifRCj78vmkWeankBIazUN4W91MqbuVma/5/nR0tjx5Z
        YvIN5yIiDyolp/4HlJBVRcML1qC0
X-Google-Smtp-Source: ABdhPJwo3PfdvoWHAOvcwLzyEDtL9tV8gOiTHS6goTXvcE5JmeWn0CxmE4ZZbxoHG39ZHJVQ9PZ+RQ==
X-Received: by 2002:a5d:4008:: with SMTP id n8mr138181wrp.82.1589486355078;
        Thu, 14 May 2020 12:59:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:44a3:4c94:7927:e2e6? (p200300EA8F28520044A34C947927E2E6.dip0.t-ipconnect.de. [2003:ea:8f28:5200:44a3:4c94:7927:e2e6])
        by smtp.googlemail.com with ESMTPSA id p10sm33814wrn.10.2020.05.14.12.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 12:59:14 -0700 (PDT)
Subject: Re: [PATCH] net: phy: Fix c45 no phy detected logic
To:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
References: <20200514170025.1379981-1-jeremy.linton@arm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e1826c60-736f-d496-4c4f-7229efee018b@gmail.com>
Date:   Thu, 14 May 2020 21:59:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514170025.1379981-1-jeremy.linton@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.05.2020 19:00, Jeremy Linton wrote:
> The commit "disregard Clause 22 registers present bit..." clears
> the low bit of the devices_in_package data which is being used
> in get_phy_c45_ids() to determine if a phy/register is responding
> correctly. That check is against 0x1FFFFFFF, but since the low
> bit is always cleared, the check can never be true. This leads to
> detecting c45 phy devices where none exist.
> 
> Lets fix this by also clearing the low bit in the mask to 0x1FFFFFFE.
> This allows us to continue to autoprobe standards compliant devices
> without also gaining a large number of bogus ones.
> 
> Fixes: 3b5e74e0afe3 ("net: phy: disregard "Clause 22 registers present" bit in get_phy_c45_devs_in_pkg")
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  drivers/net/phy/phy_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index ac2784192472..b93d984d35cc 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -723,7 +723,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  		if (phy_reg < 0)
>  			return -EIO;
>  
> -		if ((*devs & 0x1fffffff) == 0x1fffffff) {
> +		if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
>  			/*  If mostly Fs, there is no device there,

Looks good to me, it would just be good to extend the comment and explain
why we exclude bit 0 here.


>  			 *  then let's continue to probe more, as some
>  			 *  10G PHYs have zero Devices In package,
> @@ -733,7 +733,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  			if (phy_reg < 0)
>  				return -EIO;
>  			/* no device there, let's get out of here */
> -			if ((*devs & 0x1fffffff) == 0x1fffffff) {
> +			if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
>  				*phy_id = 0xffffffff;
>  				return 0;
>  			} else {
> 

