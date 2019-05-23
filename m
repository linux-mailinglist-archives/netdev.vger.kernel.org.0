Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48BB27438
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfEWCCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:02:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42816 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWCCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:02:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id 13so2305130pfw.9
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+vpnVJp0NiyRjpHWQ4kAVBHmvzewdxwEW3b4fls4XgU=;
        b=Ti5pOY9O3SUxocM0AfGlaWfhn/7vTMfwIDFjTxJF/EXas2350Lvu/D2uS9bKKXj6+Q
         l6ZHG/xcUnEWeV72TG1X5hXzYQ2G8uYML6VIssr5OZoj4C02xOC7WI1/e26czkabBpbP
         ixjXQOHHfoZ8Z44OcIqctILc9dyW5EXA0Y99+NMKK5NyNB+ceYrUzLnRqd15K797iuML
         dQmON782BWu42nHIf12gGFWKsWnv+ZM/m1mSHGv6+seIqhw/+QgKY2c8XDKhoF8KreKC
         mqMddBd2OP379erny45bxB9SpUxF3QR1xEPm5qAWHbg2atMiyPkqVswOcrrH8Xx5NhC9
         vRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+vpnVJp0NiyRjpHWQ4kAVBHmvzewdxwEW3b4fls4XgU=;
        b=Bd/9/RnD3qQCJVJ+DSyDAWO0IXQiRzn375afnSs2nOf9aPa8v0hDxCaA4/RATdf5mS
         NeU6XUM4iiwRbqOS4+L5+pnnHKck+SaJSorG8qF1uVIyveGmcUhA2gazYTxMMUUudyjg
         3/QbK00IDt9I6fgEe4YWYeAoZp/aBn7SiEUbGJqbTWHMOenfkIRM82g5zthvx6Xn/rD8
         DYNvDFpb3wbGfTy/7Mi72nyjjgQ8ChJV4/XhjW6aGK30WB/gCpJWISJ3WQteqN5TlNNy
         4GvTlrzaCqTtCfSpo2WcWayiRvf9uSXpPn2BF1BOMvsJiLvLxpHx0+rGppROmbZJP0bl
         VHbA==
X-Gm-Message-State: APjAAAWwhEiLSa44uK07wVIlKty08Bxd9BhxNufQr3My/9HWyz6Zr+MN
        LYf6fRkJ5N1jWi8shytTqQc=
X-Google-Smtp-Source: APXvYqx6Tr4CPmqcntOBOVeRDeO2nv7bChQIz3pOqoP7KiV7504sI/KB+WXRglT80RWheAHfc1vwXQ==
X-Received: by 2002:a17:90a:35c:: with SMTP id 28mr148346pjf.110.1558576939326;
        Wed, 22 May 2019 19:02:19 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o2sm8253067pgq.50.2019.05.22.19.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:02:18 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of
 a netdev
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-3-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <03871bd5-f285-140b-0c32-4e809ca938b5@gmail.com>
Date:   Wed, 22 May 2019 19:02:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-3-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> A prerequisite for PHYLIB to work in the absence of a struct net_device
> is to not access pointers to it.
> 
> Changes are needed in the following areas:
> 
>  - Printing: In some places netdev_err was replaced with phydev_err.
> 
>  - Incrementing reference count to the parent MDIO bus driver: If there
>    is no net device, then the reference count should definitely be
>    incremented since there is no chance that it was an Ethernet driver
>    who registered the MDIO bus.
> 
>  - Sysfs links are not created in case there is no attached_dev.
> 
>  - No netif_carrier_off is done if there is no attached_dev.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
