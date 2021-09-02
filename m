Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12ABE3FF7C5
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbhIBXW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhIBXW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:22:57 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1E2C061575;
        Thu,  2 Sep 2021 16:21:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j1so2437875pjv.3;
        Thu, 02 Sep 2021 16:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w3ELMaiMGVzeiZKVnEuy5c21O8XgJn0C7FUAaHWvY8s=;
        b=Wqh6m5RVpa25LZOyLKGm39QPCKMNJDJyPf5zhT5SVgJFXbOikfe3YSzq+IsWsx84/6
         fKPm9jq10do4vGlYItOS0IrxMhany9VGTHnn7B4EdLD02IDWuKd3CAZeSAWWtb7BVhhS
         RaV1qL/JOqAiwOMFzMs5/3+Ri2lZPB4pDeAqPCa38EqoD+YMoh9RyvbYhFX0FnJIvXC9
         VyEarvmu+klboxhMbJemVNx+dDFrsrRs3RLjaYN41vHHKm42+dNsO2RYs+xVC9vbQNIk
         aTsEGPsl2ty9C7FgvsflcXVGPE5oR/yCHzG/jAPvzjViiYHpiay1EVxJ4sv5qVZPA2pW
         gsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w3ELMaiMGVzeiZKVnEuy5c21O8XgJn0C7FUAaHWvY8s=;
        b=SkyJ4T4rnyuiNO8WNxdf91gfASsiXslfqZgjZQC60dt2EuN9COOVi1QlwIlCcH06ta
         Vn2TnKRsCTzvCXx/qc8p7GO/Bw5f+jMHZ9vRYlyv62+KevItT+D6XS8oifBw93880gQk
         2KK4Usg9SND4pTmVZVEvqc4NPDhKyn8g1mcqYDwtD8kL3QZAy2jEEdPg5qRYKphKXWeH
         Se/tSX54lCdJ713LWufJM0smFa+cI3d8UHQ8sON+Ss/9fCP+VGnWkIPMnJ52R/4rmgYa
         xIlR3gm5UTy7jDiI+bmu5mSeklsneh/qJvEs6IT31p8GL6t+CyDdS8aLKWPOz+TeZB2d
         dKxQ==
X-Gm-Message-State: AOAM531UKYe2FnOc/L/Fl2hRXDSmBbUQ7/pTXtPf2ZMajdnRklZgb9TZ
        Za5rDF/e2yZleN32SSBKERk=
X-Google-Smtp-Source: ABdhPJyVuLtRy7L0zvj34GfyBCTPkCciUiow6O7iiDm4EbFZrjfiX4O/MtNUdvwZmOMWVUQ5VSvmLQ==
X-Received: by 2002:a17:90a:4618:: with SMTP id w24mr613243pjg.168.1630624918056;
        Thu, 02 Sep 2021 16:21:58 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm2787125pfr.134.2021.09.02.16.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 16:21:57 -0700 (PDT)
Message-ID: <c6cd675b-d770-fe11-bc71-a6b7cefd01e6@gmail.com>
Date:   Thu, 2 Sep 2021 16:21:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [RFC PATCH net-next 2/3] net: dsa: destroy the phylink instance
 on any error in dsa_slave_phy_setup
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901225053.1205571-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2021 3:50 PM, Vladimir Oltean wrote:
> DSA supports connecting to a phy-handle, and has a fallback to a non-OF
> based method of connecting to an internal PHY on the switch's own MDIO
> bus, if no phy-handle and no fixed-link nodes were present.
> 
> The -ENODEV error code from the first attempt (phylink_of_phy_connect)
> is what triggers the second attempt (phylink_connect_phy).
> 
> However, when the first attempt returns a different error code than
> -ENODEV, this results in an unbalance of calls to phylink_create and
> phylink_destroy by the time we exit the function. The phylink instance
> has leaked.
> 
> There are many other error codes that can be returned by
> phylink_of_phy_connect. For example, phylink_validate returns -EINVAL.
> So this is a practical issue too.
> 
> Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
