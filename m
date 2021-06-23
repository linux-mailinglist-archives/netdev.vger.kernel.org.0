Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B673B2165
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWTuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWTun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 15:50:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EA7C061574;
        Wed, 23 Jun 2021 12:48:25 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a11so3894822wrt.13;
        Wed, 23 Jun 2021 12:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KX8dDc5fpk9Kie+XkJJwJofB6xMasuroCY1CbSLZ0uE=;
        b=ftnP+Unqlszu2rTiEVn5ytUZ4nKAHZROAMkfC2AlqtyywoO5eZvihbq5etUZOD9JQT
         2mGKsqL/25gg9smeWjhdmDJresRr/Ci9E+2NGofFRueWVdCMBXnw6b1jVA+yE4PkbglJ
         hYQwpUoDTVzsdi5sTXsCD3MOGhzH8iVyIsmkykmDUrMdDnKpV9FmX07+7ehXDThfuRfL
         t8YOeB3jumMDe2yF+EBJQsrdcq90IHqoNveRxGXJXE09PPg1AGunHkIYb+Qj1OOOh6Bl
         gkrszhaqu1AkOxJCDz+HeXZRSa0NVo6hb6jwf8bEeJVEBo2JQWlJ76kPKuz0STTMstgP
         CH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KX8dDc5fpk9Kie+XkJJwJofB6xMasuroCY1CbSLZ0uE=;
        b=HB/r9nHtBrcygL/CpUzGobT6MFTVG/qS5LA9Iv0v11zFc0z7genYCrLdM3268iPXCH
         jy5vy2pbYHYyHw7HeNhplYP3KFyFHC0fraEhBKsGig8EqhS135i7kY+ehZHsGNvNFN3J
         DYceu9LEB/I6tLKj7/E+aiW48/jtL5wuWS1Z/5/7RyZQ+dt7PPmZBT47T91qaGEMw2eu
         bzqdzq+R77Npp/8tG4FlpaiMdYoNq0+jdjeJWMQJD6xpxBTAvZzFG1IIjTXIp7FZJkDv
         oP0acjaeN/UVjWD+0n0NEEFSQfygfspF0e1QSkMnivWoTKlcl/mI3rQ4YIiAsinZJlUc
         SAPQ==
X-Gm-Message-State: AOAM5339wVLBdkMXTs1gSN9hMvNV/GmmpHdA9flQ0Mkgk1GoWlIT7040
        G8RIFA24DWqvNOWBDPxeSa0=
X-Google-Smtp-Source: ABdhPJwd8ha6mq7oKaNT3T7zwk7D8mRrd8zKGofLVszDjg7uFN3bGJdTdh9nYZVZ0DnzbhgwFaDD+g==
X-Received: by 2002:a05:6000:188a:: with SMTP id a10mr2102496wri.210.1624477704269;
        Wed, 23 Jun 2021 12:48:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:4902:ce4c:d883:c087? (p200300ea8f2938004902ce4cd883c087.dip0.t-ipconnect.de. [2003:ea:8f29:3800:4902:ce4c:d883:c087])
        by smtp.googlemail.com with ESMTPSA id v16sm1017937wrr.6.2021.06.23.12.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 12:48:23 -0700 (PDT)
Subject: Re: [PATCH] r8169: Avoid duplicate sysfs entry creation error
To:     Andre Przywara <andre.przywara@arm.com>, nic_swsd@realtek.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>
References: <20210622125206.1437-1-andre.przywara@arm.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1c26684c-d3eb-92b9-b93f-4dd02b47603e@gmail.com>
Date:   Wed, 23 Jun 2021 21:48:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622125206.1437-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.06.2021 14:52, Andre Przywara wrote:
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
> [Andre: expand commit message]
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2c89cde7da1e..209dee295ce2 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5086,7 +5086,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->priv = tp;
>  	new_bus->parent = &pdev->dev;
>  	new_bus->irq[0] = PHY_MAC_INTERRUPT;
> -	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
> +	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
> +		 pdev->bus->domain_nr, pci_dev_id(pdev));
>  
I think you saw the error mail from kernel test robot.
You have to use pci_domain_nr() instead of member domain_nr directly.

>  	new_bus->read = r8169_mdio_read_reg;
>  	new_bus->write = r8169_mdio_write_reg;
> 

