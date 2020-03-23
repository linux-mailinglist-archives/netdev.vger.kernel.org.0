Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6B018EE70
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 04:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgCWDTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 23:19:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34318 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgCWDTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 23:19:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id z15so15188851wrl.1;
        Sun, 22 Mar 2020 20:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VYjOnw4JRlmf/F2mqTP3BcxXE5fQSq0zqEnwZ+i7Jnk=;
        b=ewQCxULR3yNz7BraH8Y0xuNyjzZy0TiIj9Y5qJli9nMlI7bnQiJXCZSZqba5VLDwsU
         2u94/nEPnLhMmhlOfdxrueUGpRHcwXqrbcs9vCCoccfliqVBDboAhVoNxOh4VDOVOgeU
         o6F5CK28xNxA90Mg79SWOib9JcJ05+CH338GjAADOwX9RKtiRiZaLqSGyOxgE2DbGz1M
         04GpZO071BdC7fMAE6Rmt+AuNxCQH5XvwZbbsMr09HrTxr7clK1l8jq7JCEEDcTR/yiJ
         vTg16cW/5I+Da7M9PjeC9xLtfxViN4LltJ0rNjbZS8GiCnzMhLReLxe5vV5JNwGSalQy
         8yOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VYjOnw4JRlmf/F2mqTP3BcxXE5fQSq0zqEnwZ+i7Jnk=;
        b=tJgVg/8lZoq+ffLzv04WeSFaqf4DHvxp6bgEtSKkVdp26mH4KBvxaV7X7Ji4OtvbtE
         rwghVozYI6sKDSGe3zbT9gjfZqnFkkqlRoVxIB87nvHLYxmtHucrLQvDmh5FSd45Whgm
         JRqQMyWISlniDJOTSj9vos9Rl3r/BL59Hf9bfD/eirDQoQ5EAreV+eMhjfrrFbpA2w8D
         UacrML/BEXl9KjMFtSyK7TwPeF2jwJmk2V/NIzvhipVgcPH5IWWkKT5FRDeCg8ZeSnRI
         rovK8ksczoLa5zC+QH6PvYS3npAJzrS91FJQeAROsx5ALO2b7EeEZ2dqF8Lu9NCGrciC
         o4Ow==
X-Gm-Message-State: ANhLgQ20dld9riw5e2ejrZgeizmmQfG+ja5ynx0QB/D1SwC+7qscC+G8
        stAsnZ/5g7lCgZQ1HeoVLiiZHlW2
X-Google-Smtp-Source: ADFU+vtPttvqaE3eT/iH3rNbd6AldOat2Nf4zCDArjsulC9RI9rNKxE0rfewUDcgJtgfBkxrk+N2/A==
X-Received: by 2002:adf:fc82:: with SMTP id g2mr28090305wrr.117.1584933559486;
        Sun, 22 Mar 2020 20:19:19 -0700 (PDT)
Received: from [10.230.186.223] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y11sm21263778wrd.65.2020.03.22.20.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 20:19:18 -0700 (PDT)
Subject: Re: [PATCH net-next v6 07/10] net: phy: introduce
 phy_read_poll_timeout macro
To:     Dejin Zheng <zhengdejin5@gmail.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
 <20200323025633.6069-8-zhengdejin5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <f2772f58-a5f1-7a8d-c98a-8c901b434397@gmail.com>
Date:   Sun, 22 Mar 2020 20:19:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323025633.6069-8-zhengdejin5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/2020 7:56 PM, Dejin Zheng wrote:
> it is sometimes necessary to poll a phy register by phy_read()
> function until its value satisfies some condition. introduce
> phy_read_poll_timeout() macros that do this.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v5 -> v6:
> 	- no changed.
> v4 -> v5:
> 	- no changed.
> v3 -> v4:
> 	- deal with precedence issues for parameter cond.
> v2 -> v3:
> 	- modify the parameter order of newly added functions.
> 	  phy_read_poll_timeout(val, cond, sleep_us, timeout_us, \
> 				phydev, regnum)
> 				||
> 				\/
> 	  phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
> 				timeout_us)
> v1 -> v2:
> 	- pass a phydev and a regnum to replace args... parameter in
> 	  the phy_read_poll_timeout(), and also handle the
> 	  phy_read() function's return error.
>  
>  include/linux/phy.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 42a5ec9288d5..f2e0aea13a2f 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -714,6 +714,19 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
>  	return mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, regnum);
>  }
>  
> +#define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, timeout_us) \
> +({ \
> +	int ret = 0; \
> +	ret = read_poll_timeout(phy_read, val, (cond) || val < 0, sleep_us, \
> +				timeout_us, phydev, regnum); \
> +	if (val <  0) \
> +		ret = val; \
> +	if (ret) \
> +		phydev_err(phydev, "%s failed: %d\n", __func__, ret); \> +	ret; \

Those variable names are likely going to be clashing with existing
variables within a function, I would recommend you prefix with double
underscores: __ret, __val to avoid any variable re-declaration or shadowing.
-- 
Florian
