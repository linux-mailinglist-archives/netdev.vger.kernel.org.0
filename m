Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E0C14D23C
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 22:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgA2VBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 16:01:38 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53801 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgA2VBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 16:01:38 -0500
Received: by mail-wm1-f68.google.com with SMTP id s10so1309501wmh.3
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 13:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=upju4Aoo1MKcgQIxZkDXkv8rxQNRBvSX9mtO4AIxY4U=;
        b=bR/DeaweRgBhvv8N8Rcxdt+OIHbO3I7TiAbzA0DL8AvhcDmnymg/ZV/E4dVo+Iwd5e
         bfBEYEPjUrqTz6o6GqdLg0mqewjZbOV06ob/yYwxd4Q+AMve+FWjYnVYXOjThiz/S0nm
         kyPJyqjarVjHetVmR+hlKtFmiqFfMPQZiFF8MpbGgbcAOqS5O4UDan3wTql+QHjaenbM
         +Pui7wpOGbghqyLMpuzbMDrI/PmsyCW3kEYAUs3C2Z521YvXTPa2lyXuS1tsFiuduAez
         VT5/1Oieu0azmEvbt7YNs/6O0Zwd8hjuiOnrAkl3/soZUJ+CrJz+YnQpTHC5XhzTCnHk
         0TrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upju4Aoo1MKcgQIxZkDXkv8rxQNRBvSX9mtO4AIxY4U=;
        b=fHO2ASoNfsWFoozH6Q601Fh/Bt5axzN8qN1Q6g2bWml5pT7Oj9V9cW0cUHh90qkwcq
         Up6tjTNnqXynFihB0rLIoV4r/NbKJJEV902GfORSJNN5h2IKCSANWM4nDQL7zihvl1hd
         aChcW/boGTsRjWre8Y4SctcmOwaH5n6ED+BJtzPXx1Fc4bD9WhGgD4Y5DfCfBrcyRg55
         UcH7uuOj/osHoEmxp9n8LurluWgkXhya5J08jSt15PqB13lvl+xNufuiWg+qkb1t6I3E
         9hni04/gr2acLBjirCSv9rnmZk05b22ABlGcH75ff10+VTyB5Bt/aE4q1p3E+87+wcQZ
         0jhw==
X-Gm-Message-State: APjAAAWl0/+mKxj/vbSAPVv6TmAGoDZjl1lI2GAzigKk56E8wfuVcQrH
        ePBR/D2ggVQ2X5NZggtJ8fw=
X-Google-Smtp-Source: APXvYqwWBfP1oZDcOjitCko8+NxCayrBTaUzLk7tmZR1cO0PIvRzhEY8UsDgYpN94+0FmU5g3fscKA==
X-Received: by 2002:a1c:610a:: with SMTP id v10mr1093648wmb.44.1580331695491;
        Wed, 29 Jan 2020 13:01:35 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:a951:ef2a:8ef0:1f0a? (p200300EA8F296000A951EF2A8EF01F0A.dip0.t-ipconnect.de. [2003:ea:8f29:6000:a951:ef2a:8ef0:1f0a])
        by smtp.googlemail.com with ESMTPSA id j12sm4207605wrt.55.2020.01.29.13.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 13:01:35 -0800 (PST)
Subject: Re: [PATCH net v2] phy: avoid unnecessary link-up delay in polling
 mode
To:     Petr Oros <poros@redhat.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        ivecera@redhat.com
References: <20200129101308.74185-1-poros@redhat.com>
 <20200129121955.168731-1-poros@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
Date:   Wed, 29 Jan 2020 22:01:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200129121955.168731-1-poros@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.01.2020 13:19, Petr Oros wrote:
> commit 93c0970493c71f ("net: phy: consider latched link-down status in
> polling mode") removed double-read of latched link-state register for
> polling mode from genphy_update_link(). This added extra ~1s delay into
> sequence link down->up.
> Following scenario:
>  - After boot link goes up
>  - phy_start() is called triggering an aneg restart, hence link goes
>    down and link-down info is latched.
>  - After aneg has finished link goes up. In phy_state_machine is checked
>    link state but it is latched "link is down". The state machine is
>    scheduled after one second and there is detected "link is up". This
>    extra delay can be avoided when we keep link-state register double read
>    in case when link was down previously.
> 
> With this solution we don't miss a link-down event in polling mode and
> link-up is faster.
> 

I have a little problem to understand why it should be faster this way.
Let's take an example: aneg takes 3.5s
Current behavior:

T0: aneg is started, link goes down, link-down status is latched
    (phydev->link is still 1)
T0+1s: state machine runs, latched link-down is read,
       phydev->link goes down, state change PHY_UP to PHY_NOLINK
T0+2s: state machine runs, up-to-date link-down is read
T0+3s: state machine runs, up-to-date link-down is read
T0+4s: state machine runs, aneg is finished, up-to-date link-up is read,
       phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING

Your patch changes the behavior of T0+1s only. So it should make a
difference only if aneg takes less than 1s.
Can you explain, based on the given example, how your change is
supposed to improve this?

And on a side note: I wouldn't consider this change a fix, therefore
it would be material for net-next that is closed at the moment.

Heiner

> Changes in v2:
> - Fixed typos in phy_polling_mode() argument
> 
> Fixes: 93c0970493c71f ("net: phy: consider latched link-down status in polling mode")
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
>  drivers/net/phy/phy-c45.c    | 5 +++--
>  drivers/net/phy/phy_device.c | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index a1caeee1223617..bceb0dcdecbd61 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -239,9 +239,10 @@ int genphy_c45_read_link(struct phy_device *phydev)
>  
>  		/* The link state is latched low so that momentary link
>  		 * drops can be detected. Do not double-read the status
> -		 * in polling mode to detect such short link drops.
> +		 * in polling mode to detect such short link drops except
> +		 * the link was already down.
>  		 */
> -		if (!phy_polling_mode(phydev)) {
> +		if (!phy_polling_mode(phydev) || !phydev->link) {
>  			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
>  			if (val < 0)
>  				return val;
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 6a5056e0ae7757..05417419c484fa 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
>  
>  	/* The link state is latched low so that momentary link
>  	 * drops can be detected. Do not double-read the status
> -	 * in polling mode to detect such short link drops.
> +	 * in polling mode to detect such short link drops except
> +	 * the link was already down.
>  	 */
> -	if (!phy_polling_mode(phydev)) {
> +	if (!phy_polling_mode(phydev) || !phydev->link) {
>  		status = phy_read(phydev, MII_BMSR);
>  		if (status < 0)
>  			return status;
> 

