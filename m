Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFB53A5609
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 04:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhFMCL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 22:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhFMCL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 22:11:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAE6C061574;
        Sat, 12 Jun 2021 19:09:11 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k15so7745648pfp.6;
        Sat, 12 Jun 2021 19:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u225z9WmMsmtjisK38l0djPGdNbouvVawbID4V+uJlk=;
        b=InmVdy8J8+vB3d5WqxRTau5K44soILUWWF3aZT4wrqTrHcYk06ZENUsRNx5dZ86LLn
         8h/RCmsUMSjcupADqs18r/FNVbjwFoytRmDmwF/PgActxh6giR7TBjP9yWu6PCTxmqU0
         SH1gaDvoNzec8mpWkU4h9OnSa5WTesFbysM8Ij8RMZAIcz9mcP5LIqzoDuqblY7B5IHK
         wi7NhtfZxHsXbjPZeYzDMYjELvEVJOq894l36qbHTPcX5QCtKt64zGHlUWyBMG9mobIm
         pUfncVgGkicW0Cq7y+TX423/qo3VnH2iSNBZVBG4/X8KTKXHgSasLWuxRMGsYAFTonQV
         sFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u225z9WmMsmtjisK38l0djPGdNbouvVawbID4V+uJlk=;
        b=SPJ3E+5WuceMbRw71+eSi4m7LXi0ZFknp9lpqUI/yr+aXymU6fOvuOVD0pnh5XOZ6Y
         vgCc857eekWPcO88XcG9OqmiJgz0C98gldyzBH/gEFEtwtJ7UCwTCr92fyCxS4hIi9Oe
         4ZArdCm8S1Cp3KiZdT5HCMIaUiNSzPjSCQqhidzDlOyUjA8eEvru4ni3TUQhwH02NWls
         MkH6ql+kpqrf4W8OwByvoFC1sHXKcQvq93PK5orBZD3uaQtlhOXsqXsgJhGUNZ/FBajz
         CpQ7W7sxrnDsOT0kr6KZhE6l8sFkgdm8zRAehXzCJwH3pDI8bYaO7q7qfKndpILiVz45
         WdGg==
X-Gm-Message-State: AOAM532w8bLibYbPYpzA9ck1C5DiuWFiGw1qxX+1/u+y1l2403aqYT0Q
        IV1PqAZOY6QkCkIxq5+mtw98BtnVDFY=
X-Google-Smtp-Source: ABdhPJwWxtyYT14HdgJtHfIDw3W8HLQ8uROXsExVzxL3nH7MVPND/LpXyBFqZkMCukvhHvQ2Zxq8qA==
X-Received: by 2002:a62:ea1a:0:b029:2ec:9146:30be with SMTP id t26-20020a62ea1a0000b02902ec914630bemr15447887pfh.29.1623550151371;
        Sat, 12 Jun 2021 19:09:11 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o20sm8142917pjq.4.2021.06.12.19.09.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 19:09:10 -0700 (PDT)
Subject: Re: [PATCH net-next v4 7/9] net: dsa: microchip: ksz8795: add LINK_MD
 register support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-8-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <adf52a87-7467-1d88-006d-d820a0cc3a96@gmail.com>
Date:   Sat, 12 Jun 2021 19:09:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611071527.9333-8-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 12:15 AM, Oleksij Rempel wrote:
> From: Oleksij Rempel <linux@rempel-privat.de>
> 
> Add mapping for LINK_MD register to enable cable testing functionality.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
