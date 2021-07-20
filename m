Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7753D0216
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhGTShA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhGTSgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:36:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9B1C061574;
        Tue, 20 Jul 2021 12:17:29 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d2so27225936wrn.0;
        Tue, 20 Jul 2021 12:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LFqGuQYbSYic2u5N8WrZCaPn7mbJmQEzqnlwsrqQMX4=;
        b=UhK9ywLNoes0a0OAkeYCZgRAXjCKBRXKoqqwZe5IaOXAm5fwY4H3y7qiXpRXVhHNig
         9BKM7ANBxU2aXhwGWaoX0kRPS/MoamyuMTZpV/s2Yd4xHAEMNy/HJtlCtIfXEdK1f9Hc
         DE0uTtzN9cMussovlXPzY80ZF+4QCOlJsqEQPM1r8qkO/nEkHXIS14e1qvIPkJE80Rwm
         T2QPpI9vUuLW6AjAbxgIw7i2Kb0M/p2L2K4mBzdUw4n4DDnxYK6QNC6b4rBEax9vJDuv
         Emfz/knQrYlpklj+kVm3kfABMadEXMP9cVcVLtgc7nHI70Y1fUR+TVCCyQ316PxBYmJr
         MOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFqGuQYbSYic2u5N8WrZCaPn7mbJmQEzqnlwsrqQMX4=;
        b=irSSauyH9bFl9+1G+VubOyM2Awp6ViSQyW2wTuzJ1TWDeEppfc/lZi9CGMOpi8Nuwf
         1vF1b36Yis6nzerueUoQfUjXmSFXnTChh1CFi8Z4BkWR0y3JickfGx+pJRIx6Do7+9rF
         +gv6OsmYtpY9XPeQLGgWaTnSuiBzosm1fQp3JSXpDXRBnTWzrJWZs1YGEASsDpvyekEs
         0lfDvxvrhFeBmQMeyM0TqKsIrpDd+vjSnmyA7vhN5tcpCsCktWsJWxo98ypgd3Uwm9jB
         cEHOedlReAWaqkmBy77LYian3Yq6hg7shgWhxFyo/VCARLK3dePE7FmH42rQjZATnxJn
         AWDg==
X-Gm-Message-State: AOAM5316PPWJ2jXqhCkPU20R+3fvbneXSxg6gsMcdw6IQLMAbFjJSbsT
        75+mmyZWSAa11dOBJZh9Xqg=
X-Google-Smtp-Source: ABdhPJy+a+ZHYGK5P/t19qY9NtQHoOFb+K8U1RYR6/UCMmH3X3LIwo9CcBgUGVPM/p6ec/8dYYIEww==
X-Received: by 2002:adf:e7c8:: with SMTP id e8mr36982105wrn.303.1626808648022;
        Tue, 20 Jul 2021 12:17:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f3f:3d00:5da4:4158:494a:5076? (p200300ea8f3f3d005da44158494a5076.dip0.t-ipconnect.de. [2003:ea:8f3f:3d00:5da4:4158:494a:5076])
        by smtp.googlemail.com with ESMTPSA id w18sm26524024wrg.68.2021.07.20.12.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 12:17:27 -0700 (PDT)
Subject: Re: [PATCH net v3] r8169: Avoid duplicate sysfs entry creation error
To:     Andre Przywara <andre.przywara@arm.com>, nic_swsd@realtek.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
References: <20210720161740.5214-1-andre.przywara@arm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c5e8d932-b9f6-f05c-91ab-10d9cd6878fc@gmail.com>
Date:   Tue, 20 Jul 2021 21:17:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210720161740.5214-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.07.2021 18:17, Andre Przywara wrote:
> From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> 
> When registering the MDIO bus for a r8169 device, we use the PCI
> bus/device specifier as a (seemingly) unique device identifier.
> However the very same BDF number can be used on another PCI segment,
> which makes the driver fail probing:
> 
> [ 27.544136] r8169 0002:07:00.0: enabling device (0000 -> 0003)
> [ 27.559734] sysfs: cannot create duplicate filename '/class/mdio_bus/r8169-700'
> ....
> [ 27.684858] libphy: mii_bus r8169-700 failed to register
> [ 27.695602] r8169: probe of 0002:07:00.0 failed with error -22
> 
> Add the segment number to the device name to make it more unique.
> 
> This fixes operation on ARM N1SDP boards, with two boards connected
> together to form an SMP system, and all on-board devices showing up
> twice, just on different PCI segments. A similar issue would occur on
> large systems with many PCI slots and multiple RTL8169 NICs.
> 
> Fixes: f1e911d5d0dfd ("r8169: add basic phylib support")
> Signed-off-by: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
> [Andre: expand commit message, use pci_domain_nr()]
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Compile-tested on ARM, arm64, ppc64, sparc64, mips64, hppa, x86-64,
> i386. Tested on an AMD system with an on-board RTL8111 chip.
> 
> Changes v2 ... v3:
> - Resent with Fixes tag and proper net: annotation
> 
> Changes v1 ... v2:
> - use pci_domain_nr() wrapper to fix compilation on various arches
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index f744557c33a3..c7af5bc3b8af 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5084,7 +5084,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
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

Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
