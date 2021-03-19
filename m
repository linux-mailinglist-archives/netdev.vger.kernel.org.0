Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6F63416D0
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 08:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhCSHlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 03:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbhCSHkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 03:40:53 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C385BC06174A;
        Fri, 19 Mar 2021 00:40:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so4550124wmc.0;
        Fri, 19 Mar 2021 00:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MFOtFpKu091LQNgJ4z32DJVrKzARq3yiufp0Zl1ZyGU=;
        b=OhbCqEK0eIKZg3IxvxZO9Q+D68KsZDtsQxLO+r6u08LA6onIVKZMHP4ozrfyCQEPyX
         XKHsMx8PsaaUhfeLYxO1HG6JD8mEJtOJFhFmQDdmgUG9Lmb7bY86g5NJXiMq1OG8yJIU
         cFzc2HNoq75Cd8bWBj0z59IR0PWD8FgG6HXKpqu7q8LUe5anCrCqjiAocVW5nmGMU+lt
         xMrSfv+OugcZcQEimSwHPqqh9mLpSXzcJksFnKyyT7w34+uvW4RRVWlTYN8BC/iXtl5J
         wE2OXyNvxFktjJYbRrVFi58suS+SplKuNfkEY/i5YWKcm7e/Mkb39rJ4T2TE/tDyfHNB
         xdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MFOtFpKu091LQNgJ4z32DJVrKzARq3yiufp0Zl1ZyGU=;
        b=tPe9NCIcifZzX8GWjJLv5T39D8nxViDYH34RUjceok8ev/w9OCg4dEzospdW4zVoW3
         qkCz1f4mJMTSXvFigrmtzOeqblQD3dsFdltcEWr7Tx3zVTymbSiOLTmevntEL+vBl6g2
         tdTo4Nibyl4Iswihssg1W++oXrswbjTgMxA/fluM1s6uW+J+8L6/pwMnY6e1BzX6e1La
         3D8KJtEZyv2KWcocwiI7w4Nc05x5iD/lzEh2/aJm/hKBgkf945jzPXfhLvc4aU3jBCuB
         LE13ekRp5bRa9DxBsaAM6ixqlU7g8ZIeHC4htw+QrwtrTvbT2jsOV0ElHT706191DgPj
         cJxw==
X-Gm-Message-State: AOAM5301b6iGn2Z9Ng1gz0xhbbGk7f0T6e7CqoDXHyKTw8WHVw72TF6R
        AqjUgDkcq3/2h2f6Vyjfqg2jYFEsa1bHJg==
X-Google-Smtp-Source: ABdhPJxuPwXY9UzcCTiP7xMU87paMgTChDHL8+QYxxowmfnfkd46zbDQ6v3Xn/+L0quCqT+pyyytmw==
X-Received: by 2002:a1c:541a:: with SMTP id i26mr2367511wmb.75.1616139651436;
        Fri, 19 Mar 2021 00:40:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:fd2c:a424:dc3d:ffa1? (p200300ea8f1fbb00fd2ca424dc3dffa1.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:fd2c:a424:dc3d:ffa1])
        by smtp.googlemail.com with ESMTPSA id j16sm11064656wmi.2.2021.03.19.00.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 00:40:50 -0700 (PDT)
To:     Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Message-ID: <3f7f68d0-6bbd-baa0-5de8-1e8a0a50a04d@gmail.com>
Date:   Fri, 19 Mar 2021 08:40:45 +0100
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

+ the authors of 0cc8fecf041d ("net: phy: Allow mdio buses to auto-probe c45 devices")

In case of MDIOBUS_C22_C45 we probe c22 first, and then c45.
This causes problems with c45 PHY's that have rudimentary c22 support
and return 0 when reading the c22 PHY ID registers.

Is there a specific reason why c22 is probed first? Reversing the order
would solve the issue we speak about here.
c45-probing of c22-only PHY's shouldn't return false positives
(at least at a first glance).
