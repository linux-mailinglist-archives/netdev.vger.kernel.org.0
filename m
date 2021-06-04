Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B85D39B927
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFDMqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhFDMqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 08:46:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDE3C06174A;
        Fri,  4 Jun 2021 05:44:31 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a20so9241304wrc.0;
        Fri, 04 Jun 2021 05:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/12nwO3ie3OTdib3qXezH/jT1RQGJcozWN5BM57J+po=;
        b=UviSW5rNe92MuYqyqt/LtS4wMTRnXl3d1a1nre3vInz5T//KV31NfRoRxV5iQVQV5J
         JvLr2W1cMCFd0s6NA9A/QXcVCUmI1hUeF3ZBYz4p97fcF90vvz1Y5zZ1u//Xpyoar3V6
         zlP791VCdV4fEFowLUjoFkLmOiEp2C1wyYcO99jn7t6EoF8ZdG0x22K5zdXpgTjB1Fe6
         8AG/WDB6wjbAjNMoHQt5GDBx1H/2dkUTZLu3kUvOIW7ee2BL8XJ07mPene3KQ/u3KG1c
         TMr1muH25P4Q/Jg45gLD+sqKsopD5O5NFZNSVzmhZ9wf6nYN6vtfpjVrk9rZEx3oMfw7
         JUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/12nwO3ie3OTdib3qXezH/jT1RQGJcozWN5BM57J+po=;
        b=ocPw/akbuG4C2Pbzq9X+8urMad6LGY4JPmHWEnODOGhtLnuOsDg1YzF+sLxvH82UuM
         jNzcTgM4LRUXryUeZNgfMZz9IfkklM4v/H+6sDD3XC61soywIYxZ7bS0GAQF4susmp4G
         bidISLiT+4Y1bb2KhLOow3pjVqbgN+L7m9KzsdWPQYYB+4A6qTBaRKzGmU22zf8XOU68
         lZBpncLdTknJe3OhNVRCrdU2FrgVXpHJnNu3DlQUHpbiQQS75c8NtsVVle5hpKteayJz
         ucsEIb56CWkf1sblOfycuSkxYCj/o3RetKVXy6Wuod9JPRrO5fPa/BNbJK7HLi5hSVbs
         7jjQ==
X-Gm-Message-State: AOAM532r1lUQfAf72wXumACdChMBzIgbUjQdzFn5RIZMKVfyuIUcSx0L
        EYMBCkLl7J0SY7S0yvecGgDKeZbMq8w=
X-Google-Smtp-Source: ABdhPJzUp08w/6NppKYok6VvXHCjdh5tbR2/6BA/0t3kWPf28/q++aL2zXcPbZnp4FqiRBV2SIGXgw==
X-Received: by 2002:adf:de84:: with SMTP id w4mr3741299wrl.167.1622810669814;
        Fri, 04 Jun 2021 05:44:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:e88b:5ff5:6dda:b362? (p200300ea8f2f0c00e88b5ff56ddab362.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:e88b:5ff5:6dda:b362])
        by smtp.googlemail.com with ESMTPSA id q3sm6543358wrr.43.2021.06.04.05.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 05:44:29 -0700 (PDT)
Subject: Re: [PATCH net-next] net: enetc: use get/put_unaligned() for mac
 address handling
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210604123018.24940-1-michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <db1964cd-df60-08a2-1a66-8a8df7f14fef@gmail.com>
Date:   Fri, 4 Jun 2021 14:44:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604123018.24940-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2021 14:30, Michael Walle wrote:
> The supplied buffer for the MAC address might not be aligned. Thus
> doing a 32bit (or 16bit) access could be on an unaligned address. For
> now, enetc is only used on aarch64 which can do unaligned accesses, thus
> there is no error. In any case, be correct and use the get/put_unaligned()
> helpers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 31274325159a..a96d2acb5e11 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>  /* Copyright 2017-2019 NXP */
>  
> +#include <asm/unaligned.h>
>  #include <linux/mdio.h>
>  #include <linux/module.h>
>  #include <linux/fsl/enetc_mdio.h>
> @@ -17,15 +18,15 @@ static void enetc_pf_get_primary_mac_addr(struct enetc_hw *hw, int si, u8 *addr)
>  	u32 upper = __raw_readl(hw->port + ENETC_PSIPMAR0(si));
>  	u16 lower = __raw_readw(hw->port + ENETC_PSIPMAR1(si));
>  
> -	*(u32 *)addr = upper;
> -	*(u16 *)(addr + 4) = lower;
> +	put_unaligned(upper, (u32 *)addr);
> +	put_unaligned(lower, (u16 *)(addr + 4));

I think you want to write little endian, therefore on a BE platform
this code may be wrong. Better use put_unaligned_le32?
By using these versions of the unaligned helpers you could also
remove the pointer cast.

>  }
>  
>  static void enetc_pf_set_primary_mac_addr(struct enetc_hw *hw, int si,
>  					  const u8 *addr)
>  {
> -	u32 upper = *(const u32 *)addr;
> -	u16 lower = *(const u16 *)(addr + 4);
> +	u32 upper = get_unaligned((const u32 *)addr);
> +	u16 lower = get_unaligned((const u16 *)(addr + 4));
>  
>  	__raw_writel(upper, hw->port + ENETC_PSIPMAR0(si));
>  	__raw_writew(lower, hw->port + ENETC_PSIPMAR1(si));
> 

