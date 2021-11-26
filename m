Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D392D45EBAC
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376749AbhKZKgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377018AbhKZKeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 05:34:19 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B79C061784;
        Fri, 26 Nov 2021 02:21:10 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id o13so17501284wrs.12;
        Fri, 26 Nov 2021 02:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=yZ/tCit1NmMtiFas6Nxi4G9wPKK7nJJkoETrht0RK38=;
        b=OSTduz72gGcF+/TB3oTsc0dWxUQmTbPuv3bA2jRmjrsGzPvedTL6GnXWzPe0fdc1SV
         FUq8R1RxvUcaKvqEW5YmqpXpC5EVSjkYPJnDRgFgELe28S34AVKwSvuqiLKLag122Kl1
         WyoK6ZO+yY0P5X7d6xadqcVyckrU1VS8hVtbuPLITziuCSjQ3G8t6Mci4jqGQMtqTJcy
         Bevsfdzs130wDDKMQPp/B0J2ks6lxJlVkC2A4kygJp7VE+iIage7ZQ/usV4QsWOo81+Y
         8iHRNqs8vv45yH7Z4vbDa4FJQT1kLMFvIFBm7SZcqhcR4ZcNNuaMdHDPjmxUomuDu/SE
         TUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=yZ/tCit1NmMtiFas6Nxi4G9wPKK7nJJkoETrht0RK38=;
        b=ecwVGGSIu5SHwDVFqOGmdhB8d2aZ94njDwjpYs+IuKDNM70lz8Qd/Bzn/fotPvcb1Z
         xCIA4pnMIu8kTRpsn7HCOZCRXXT9Qe2x8gHkm4YBmnmoXWHs2D66o+NIN32al5AjWqaF
         PKInVKLe228kaU93Tz0iqJ3pzWFzXF0a03+kHnjO5zliykHclTsmR7dA3pDiCk/HLD9M
         49Q5xopv6eRWJWG49vI7oqu78zUbSBAsMLS0AAXpk63RFQtNQQcSP/aHF8rc3DNjoKa6
         +gsgrXwnxSwTu5K7oIBtPfH99yzDa+R4/ECkHV/LNd0KY3NvWicy+ihIlSmbFpDqT3Gf
         0COw==
X-Gm-Message-State: AOAM530bkXd37vYSGSsTMv+q44NKYNIqE+Pc5+HSbfieh9bWYYnziau0
        LtFBJdqAHnTt32hq+WWfdZ4=
X-Google-Smtp-Source: ABdhPJyeS+5pbpcOHAqvyN/g/r7R5Rkqo4J/Nr/TdC4nBezU/fWjN+afDxc5nAp6zdcpO6XyWzoXsQ==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr12900579wri.69.1637922069507;
        Fri, 26 Nov 2021 02:21:09 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:eda0:b7b0:4339:bfa2? (p200300ea8f1a0f00eda0b7b04339bfa2.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:eda0:b7b0:4339:bfa2])
        by smtp.googlemail.com with ESMTPSA id w15sm4967366wrk.77.2021.11.26.02.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 02:21:09 -0800 (PST)
Message-ID: <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
Date:   Fri, 26 Nov 2021 11:21:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Yinbo Zhu <zhuyinbo@loongson.cn>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
In-Reply-To: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.11.2021 10:45, Yinbo Zhu wrote:
> After module compilation, module alias mechanism will generate a ugly
> mdio modules alias configure if ethernet phy was selected, this patch
> is to fixup mdio alias garbled code.
> 
> In addition, that ugly alias configure will cause ethernet phy module
> doens't match udev, phy module auto-load is fail, but add this patch
> that it is well mdio driver alias configure match phy device uevent.
> 
I think Andrew asked you for an example already.
For which PHY's the driver isn't auto-loaded?

In addition your commit descriptions are hard to read, especially the
one for patch 2. Could you please try to change them to proper English?
Not being a native speaker myself ..

> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
> ---
> Change in v2:
> 		Add a MDIO_ANY_ID for considering some special phy device 
> 		which phy id doesn't be read from phy register.
> 
> 
>  include/linux/mod_devicetable.h |  2 ++
>  scripts/mod/file2alias.c        | 17 +----------------
>  2 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index ae2e75d..7bd23bf 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -595,6 +595,8 @@ struct platform_device_id {
>  	kernel_ulong_t driver_data;
>  };
>  
> +#define MDIO_ANY_ID (~0)
> +
>  #define MDIO_NAME_SIZE		32
>  #define MDIO_MODULE_PREFIX	"mdio:"
>  
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 49aba86..63f3149 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -1027,24 +1027,9 @@ static int do_platform_entry(const char *filename,
>  static int do_mdio_entry(const char *filename,
>  			 void *symval, char *alias)
>  {
> -	int i;
>  	DEF_FIELD(symval, mdio_device_id, phy_id);
> -	DEF_FIELD(symval, mdio_device_id, phy_id_mask);
> -
>  	alias += sprintf(alias, MDIO_MODULE_PREFIX);
> -
> -	for (i = 0; i < 32; i++) {
> -		if (!((phy_id_mask >> (31-i)) & 1))
> -			*(alias++) = '?';
> -		else if ((phy_id >> (31-i)) & 1)
> -			*(alias++) = '1';
> -		else
> -			*(alias++) = '0';
> -	}
> -
> -	/* Terminate the string */
> -	*alias = 0;
> -
> +	ADD(alias, "p", phy_id != MDIO_ANY_ID, phy_id);
>  	return 1;
>  }
>  
> 

