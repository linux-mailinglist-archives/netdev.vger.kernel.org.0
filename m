Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CEC31A97B
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhBMB0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMB0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:26:46 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79206C0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:26:06 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id n10so750972pgl.10
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xmXCa4C38cKT7LC1TpReePlpIFPT9Sv2aTdmiURYn/Q=;
        b=Q6ppK7wdUqjdFZ0Ki3ocVRAlGGXFmU6jR2yG9oXFfO6Ffe4u3MERQFop4oaIj5GakY
         AJlNCXDBf+HpMFrjX42Pk0j7iAaXyULudQAWzHwOOKhC9QL7DbB3KacXUzmo1MUOJdy4
         Yw46T2jjfMhgkxr3FL70DNrlTozlhshQACWnjODomiKLf7knUfRqO6eoA/7cxRdB3rJc
         3oU4229hHBcuefnouZkgZI1mgkouW8RGyxrDEBOKOrqk/y9TbZa6Dbv6BGHC1LUhofT3
         8AUhHzxwGcZtyatoSIFMq/8XUrROvkHeQSX6qrzb/5vtdup1A5t0bXg1Ntq7z06aHEO4
         ZKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xmXCa4C38cKT7LC1TpReePlpIFPT9Sv2aTdmiURYn/Q=;
        b=Fmvagf5L79RGFrGaBcYVZbX5rpTNsuyDjfEjy/5X78XutQ9cYSj2yHPaLYSEOxN6Tw
         zqedgq//2SoSc0kbPoW1FbC2hF6YFftQmh4tjCM9DeoWBB7Z10JfxTT+EfSy+3Goo2M4
         lfp8FvZIU6Bkdfz5ijXMknG77LeQXpu0S3zkny9i1oovi/ixryMp3SSE/Dcq6YJqUf1V
         DwXyZNc7YYh7EkzXM7Ov1jBQwQWgq+JJaTk3JzH7nGcZO1tbBG7z2tbz10PMyle5moVF
         IXxfU/dUY3xnylckqCfF8+PmCMn2pEtDo/tiGQprmT/ZtWOuWACL5KYYOZS/3VNcrYat
         F30g==
X-Gm-Message-State: AOAM532R+waRbNikVgwKR1+vay020Q8KHR3FK5f8pPnbwn9pxeXTDkY4
        71rCzM/3syx/IBX5p9t4Gcd0qcqaSNk=
X-Google-Smtp-Source: ABdhPJz6aq884+puuV3zPOG2D9PIp9rUNTy/2YOf066AAQHfjqZru0CHavaZSWF89WkJtUDqk1o43A==
X-Received: by 2002:aa7:8184:0:b029:1e5:1e7a:bcc0 with SMTP id g4-20020aa781840000b02901e51e7abcc0mr5511441pfi.73.1613179565389;
        Fri, 12 Feb 2021 17:26:05 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 141sm9623300pfa.65.2021.02.12.17.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:26:04 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: Set proper
 1000BaseX/SGMII interface mode for BCM54616S
To:     Robert Hancock <robert.hancock@calian.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20210213002825.2557444-1-robert.hancock@calian.com>
 <20210213002825.2557444-2-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <87f06cb4-3bee-3ccb-bb21-ce6943e75336@gmail.com>
Date:   Fri, 12 Feb 2021 17:26:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213002825.2557444-2-robert.hancock@calian.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 4:28 PM, 'Robert Hancock' via BCM-KERNEL-FEEDBACK-LIST,PDL
wrote:
> The default configuration for the BCM54616S PHY may not match the desired
> mode when using 1000BaseX or SGMII interface modes, such as when it is on
> an SFP module. Add code to explicitly set the correct mode using
> programming sequences provided by Bel-Fuse:
> 
> https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-05-series.pdf
> https://www.belfuse.com/resources/datasheets/powersolutions/ds-bps-sfp-1gbt-06-series.pdf
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/phy/broadcom.c | 83 ++++++++++++++++++++++++++++++++------
>  include/linux/brcmphy.h    |  4 ++
>  2 files changed, 75 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 0472b3470c59..78542580f2b2 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -64,6 +64,63 @@ static int bcm54612e_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int bcm54616s_config_init(struct phy_device *phydev)
> +{
> +	int rc, val;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_SGMII ||
> +	    phydev->interface == PHY_INTERFACE_MODE_1000BASEX) {

Can you reverse the condition so as to save a level of identation?

> +		/* Ensure proper interface mode is selected. */
> +		/* Disable RGMII mode */
> +		val = bcm54xx_auxctl_read(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC);
> +		if (val < 0)
> +			return val;
> +		val &= ~MII_BCM54XX_AUXCTL_SHDWSEL_MISC_RGMII_EN;
> +		rc = bcm54xx_auxctl_write(phydev, MII_BCM54XX_AUXCTL_SHDWSEL_MISC,
> +					  val);
> +		if (rc < 0)
> +			return rc;

I don't think this write is making it through since you are not setting
MII_BCM54XX_AUXCTL_MISC_WREN in val, I know this is an annoying detail,
and we could probably fold that to be within bcm54xx_auxctl_write()
directly, similarly to what bcm_phy_write_shadow() does.

The reset of the sequence and changes looks fine to me.
-- 
Florian
