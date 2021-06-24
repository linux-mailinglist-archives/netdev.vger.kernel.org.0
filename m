Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA073B35EC
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhFXSnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbhFXSnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:43:52 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470E7C061574;
        Thu, 24 Jun 2021 11:41:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i24so9946553edx.4;
        Thu, 24 Jun 2021 11:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FqeVLsZbI+b7YMNFAgaFj21i7SM7xU+D1QxAYv/hv9E=;
        b=O+DFNT4ShO+03GG0VF0Zm8jfSJNDh2NpS2sx5CDivncDZJ6rY9f3sgx+6q/6oC13Gv
         8T1v8SNGcuziOpR+wqR3n3vpBZbMwi09et4eAD4kd5mOl9hjx+yRILqvrHOCRfDDLqVT
         bRDFAYSl5pjhTjuysAR8qekrmg9KgrDks2OMRvt1YxvDcEMrSkzzFItj5nTkl6171kD3
         brbdBd+Q1RaVxXlDwDRF6vEldI0HpkG2lZ5BP14PKhfRcTDhtNEU8KsZ98zWvuMowMgl
         F1diY9yB3dWWicVp7hgF5zpobwCU6YFFoPeQzkR9oRskYKJZ1qG4OV+9/OwlYzR4snyA
         gK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FqeVLsZbI+b7YMNFAgaFj21i7SM7xU+D1QxAYv/hv9E=;
        b=Oy7XHYCkhIgyROU2oLbgCSeIpvjvYjC8SOi3BCj2800uK8UGuh4ykd1W9qSHwz4W4b
         lGFwTnBdv353f9LBi4POq4kTitidpEO7qgrbyGFCkkPyQbm281NJ34pLg5P7FOvaXLU/
         RaGkWvg6v1eUb2BPpwTdKAPLVZfMfSZHGZNxkN5UtuJoVeAYYuRNJ1R/yFBpC9NPRebr
         ogp/PsJ8J3PgRDeevoRmVAPK1M9nQVkLnEVc4JFG27Ub7xvPLtSrDhAQXups3o6k4rF6
         IwqlTEfhFEcsk0EAp11gAOEJCTDpv4z1aEEefH/RMjv5UawJlUzTBub+Vfemu1le4KQf
         wwQQ==
X-Gm-Message-State: AOAM530KdBKE7A0mjIvMotDgghufJurEjjPnrswWvLoNaQdbvenkYNLR
        ApLbOccuC+HR6E6pddyFmII=
X-Google-Smtp-Source: ABdhPJzi3PKyfCY+DvBFjP2sN7A1iP+R1dKr1Awa9cmDiqkiZfR6l6B/vpRHHMPC5duU4KL52fYbiA==
X-Received: by 2002:a05:6402:2551:: with SMTP id l17mr9131824edb.15.1624560089913;
        Thu, 24 Jun 2021 11:41:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:108e:1fbd:e1c9:8645? (p200300ea8f293800108e1fbde1c98645.dip0.t-ipconnect.de. [2003:ea:8f29:3800:108e:1fbd:e1c9:8645])
        by smtp.googlemail.com with ESMTPSA id b19sm2366380edd.10.2021.06.24.11.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 11:41:29 -0700 (PDT)
To:     Andre Przywara <andre.przywara@arm.com>, nic_swsd@realtek.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
References: <20210624154945.19177-1-andre.przywara@arm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] r8169: Avoid duplicate sysfs entry creation error
Message-ID: <bb2e4938-0a7c-1b02-25f5-5615d3a1b1c7@gmail.com>
Date:   Thu, 24 Jun 2021 20:41:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624154945.19177-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.06.2021 17:49, Andre Przywara wrote:
> From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> 
> When registering the MDIO bus for a r8169 device, we use the PCI B/D/F
> specifier as a (seemingly) unique device identifier.
> However the very same BDF number can be used on another PCI segment,
> which makes the driver fail probing:
> 
> [ 27.544136] r8169 0002:07:00.0: enabling device (0000 -> 0003)
> [ 27.559734] sysfs: cannot create duplicate filename '/class/mdio_bus/r8169-700'
> ....…
> [ 27.684858] libphy: mii_bus r8169-700 failed to register
> [ 27.695602] r8169: probe of 0002:07:00.0 failed with error -22
> 
> Add the segment number to the device name to make it more unique.
> 
> This fixes operation on an ARM N1SDP board, where two boards might be
> connected together to form an SMP system, and all on-board devices show
> up twice, just on different PCI segments.
> 
> Signed-off-by: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> [Andre: expand commit message, use pci_domain_nr()]
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Now compile-tested on ARM, arm64, ppc64, sparc64, mips64, hppa, x86-64,
> i386.
> 
Good. Patch is missing the net vs. net-next annotation, therefore the
remaining question is whether to treat this as a fix. Seems nobody but
you was affected so far, therefore handling it as an improvement should
be fine as well.

If you need this change on previous kernel versions:
Add net annotation and add a Fixes tag (I think when driver was switched
to phylib with 4.19). Else add a net-next annotation.

See the following link for details:
https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

> Changes v1 ... v2:
> - use pci_domain_nr() wrapper to fix compilation on various arches
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2c89cde7da1e..5f7f0db7c502 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5086,7 +5086,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->priv = tp;
>  	new_bus->parent = &pdev->dev;
>  	new_bus->irq[0] = PHY_MAC_INTERRUPT;
> -	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
> +	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
> +		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
>  
>  	new_bus->read = r8169_mdio_read_reg;
>  	new_bus->write = r8169_mdio_write_reg;
> 

