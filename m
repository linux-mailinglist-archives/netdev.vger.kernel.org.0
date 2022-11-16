Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F6C62CEAB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbiKPXXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiKPXXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:23:10 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD14A6712A;
        Wed, 16 Nov 2022 15:23:08 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id h24so123749qta.9;
        Wed, 16 Nov 2022 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6fdhWXXKqYZm2dNBHYZg05FEB22pSPIpNhWcLhju/XE=;
        b=KMfdKLzVbnm3xqiQYFA8gPejPAAgHQvg5JBr+NS2byD/y19Q5AiLkutyiC+SiTTujg
         Hx1wtNVv5+FpZBCkFbxued90nTR+KxrzYy3rvb876SP0aAdnpjjjgjb43gHZu5+8loQu
         2r0iGXIFre6eETRmQXR0hZPOjFvVQn13uTwjCi9T5NYEd/dtSddkIjNuCJKSLLaj9YsA
         g9MMs3vs58YzC/NSmgXjj2+1rNNy/dYVGRkBBoDRb7amYgaE9xr0Ui1kQvpnl38OHx+M
         4kdnJUL8wT0IfBCELC5kAtwjn5Bm/upuutOm26rxmc3qtwMeJhbAj2edgehGBKzspjHL
         YNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fdhWXXKqYZm2dNBHYZg05FEB22pSPIpNhWcLhju/XE=;
        b=01o7qq7ozPcrY/fudoRrWpQo55yJnhuVQ1l+h6bTYohx4O42VMx0J0G4wmGZzidPD1
         m8b0AEdq294Uvte2GFN55ywiS9nCLRSDNrtp8s5Zu6nc7lDvJli7f82NSPF89Cw+wKLG
         9GTrUq9mnST1mSf34NJPsC6lDk1/CF+ignm8TMiFrxgePAO9/1MJgrkxP7cIvRPq+3PL
         pvAj0ekssNpHE261lpFD9ud2QvFEBxVR5ih50o2HDP2VVhaInGDeZnjXsCg44YcNXmhl
         bACEPVYPHltKS4qFvpINGhyXC2ugEhRKH76o6yPs8XI/jDGVk/RMQbCQrJutG02Hh5hA
         KInQ==
X-Gm-Message-State: ANoB5pmePfbYIJaMEcz+cMz5LHBsaEmQXYB2Rs2l8JlXoqVhXdeYdBwt
        jCdH4onQ9rM7SX0BwPA0jIs=
X-Google-Smtp-Source: AA0mqf4Q122JZsY1FLteHfT94CU5Zg3RDzCcnKkJQSfu17ZoTwDVtV4AUtJ7LjrwzPshqMrZHsegKQ==
X-Received: by 2002:ac8:72d0:0:b0:3a5:9e38:9f4 with SMTP id o16-20020ac872d0000000b003a59e3809f4mr112138qtp.532.1668640986477;
        Wed, 16 Nov 2022 15:23:06 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c18-20020ac85192000000b0039c7b9522ecsm9529260qtn.35.2022.11.16.15.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 15:23:05 -0800 (PST)
Message-ID: <980ef04d-a303-4a69-a980-0c910571c835@gmail.com>
Date:   Wed, 16 Nov 2022 15:22:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     Xiaolei Wang <xiaolei.wang@windriver.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-2-xiaolei.wang@windriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221116144305.2317573-2-xiaolei.wang@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 06:43, Xiaolei Wang wrote:
> The external phy used by current mac interface
> is managed by another mac interface, so we should
> create a device link between phy dev and mac dev.
> 
> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
> ---
>   drivers/net/phy/phy.c | 20 ++++++++++++++++++++
>   include/linux/phy.h   |  1 +
>   2 files changed, 21 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e741d8aebffe..0ef6b69026c7 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -35,6 +35,7 @@
>   #include <net/netlink.h>
>   #include <net/genetlink.h>
>   #include <net/sock.h>
> +#include <linux/of_mdio.h>
>   
>   #define PHY_STATE_TIME	HZ
>   
> @@ -1535,3 +1536,22 @@ int phy_ethtool_nway_reset(struct net_device *ndev)
>   	return phy_restart_aneg(phydev);
>   }
>   EXPORT_SYMBOL(phy_ethtool_nway_reset);
> +
> +/**
> + * The external phy used by current mac interface is managed by
> + * another mac interface, so we should create a device link between
> + * phy dev and mac dev.
> + */
> +void phy_mac_link_add(struct device_node *phy_np, struct net_device *ndev)
> +{
> +	struct phy_device *phy_dev = of_phy_find_device(phy_np);
> +	struct device *dev = phy_dev ? &phy_dev->mdio.dev : NULL;
> +
> +	if (dev && ndev->dev.parent != dev)
> +		device_link_add(ndev->dev.parent, dev,
> +				DL_FLAG_PM_RUNTIME);

Where is the matching device_link_del()?
-- 
Florian

