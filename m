Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C88F46BCC2
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhLGNor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbhLGNoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:44:46 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623D2C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 05:41:16 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r11so56813909edd.9
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 05:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kD38agzOoUxvYHqK9sORgQftUZ/quYz29pUj8Un3LS8=;
        b=dqIPXW5sBVKMYOZZzCq1PkoZ73IsUjFMc8L7GBJOEzzeHC0ZWlnwyhUzbKJgGTf7yh
         k4ugZH19/d0YXrcVcPxchDxnjZhYZgH4RXP7c14M3JvzuMRK1NzrcFWMGGMjs5qjYXqb
         Ad2IYlKRojstGqktHRUraE/8PqbEIVyzPTsptYjBnVLKLV+ScP2cXrBBZB3k0/NnXNBA
         nX/6669i36KsR6DpXK4VsNbJs+L08yzmmXmNM9z1zSVlIrfKG8ESwPmnnTl5zGyVkHMr
         DrRiIdzjb8OVBx6BN36iimSlIsyHXLuDhmGnU537jZHau7+pDOcQPsJeAEh6DVj+dOpU
         SELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kD38agzOoUxvYHqK9sORgQftUZ/quYz29pUj8Un3LS8=;
        b=lcSATn9iPVr+LgdkHpFV/ZuEccdA3u5Mr5TzvxCymAqz8mx3uLzaspCTjwQpRPB8EX
         fNd7QTDv2QZCvn8uDHU7i6oprjjLigp4sEG2EfSIh7Mbl3m9HCJF1lN1JJG+p21cz7FD
         UKt88v3EKhkuaWafeEqfwKPjyPgGJUlWOt1nTizZ2S99I7OBUuMrfy0Qkg5b04/t0NA5
         ZarqO/XTVXRS7AibwKAwBJQ43QiJaz44ZQW3TjJCsC8BC5TdDvKfNFgRhEupTo4PGRu8
         Z2VQfsU/C9j0pDSynTh44/v2kiWKbzZJHHpZRdQ3jKn5LufjBbcoOWpeiOCYlbwrk+Rf
         2vhQ==
X-Gm-Message-State: AOAM530lRRPKuPQSU+wDtgl14wMTPm+y7LRrr20+/YGz4/v1vduJ3O+u
        byJrGp2kLcu2RDwJLDj+j/bwsbEkiFFgeZXR
X-Google-Smtp-Source: ABdhPJwSnzBXKAqEivvuu6NzEYJjHotGIg3GbTNEKnqwnbWaqKMomNqmNv70c5vx1HIG3SHJ5/3fxA==
X-Received: by 2002:a17:906:390:: with SMTP id b16mr51521703eja.522.1638884474992;
        Tue, 07 Dec 2021 05:41:14 -0800 (PST)
Received: from [192.168.2.218] (78-22-137-109.access.telenet.be. [78.22.137.109])
        by smtp.gmail.com with ESMTPSA id sh33sm8912160ejc.56.2021.12.07.05.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 05:41:14 -0800 (PST)
Message-ID: <27d544f7-9eef-b74a-47d1-bf05718b3abf@mind.be>
Date:   Tue, 7 Dec 2021 14:41:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: fix "don't use PHY_DETECT on
 internal PHY's"
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org
References: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
From:   Maarten Zanders <maarten.zanders@mind.be>
In-Reply-To: <E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 11:32, Russell King (Oracle) wrote:
> This commit fixes a misunderstanding in commit 4a3e0aeddf09 ("net: dsa:
> mv88e6xxx: don't use PHY_DETECT on internal PHY's").
> 
> For Marvell DSA switches with the PHY_DETECT bit (for non-6250 family
> devices), controls whether the PPU polls the PHY to retrieve the link,
> speed, duplex and pause status to update the port configuration. This
> applies for both internal and external PHYs.
> 
> For some switches such as 88E6352 and 88E6390X, PHY_DETECT has an
> additional function of enabling auto-media mode between the internal
> PHY and SERDES blocks depending on which first gains link.
> 
> The original intention of commit 5d5b231da7ac (net: dsa: mv88e6xxx: use
> PHY_DETECT in mac_link_up/mac_link_down) was to allow this bit to be
> used to detect when this propagation is enabled, and allow software to
> update the port configuration. This has found to be necessary for some
> switches which do not automatically propagate status from the SERDES to
> the port, which includes the 88E6390. However, commit 4a3e0aeddf09
> ("net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's") breaks
> this assumption.
> 
> Maarten Zanders has confirmed that the issue he was addressing was for
> an 88E6250 switch, which does not have a PHY_DETECT bit in bit 12, but
> instead a link status bit. Therefore, mv88e6xxx_port_ppu_updates() does
> not report correctly.
> 
> This patch resolves the above issues by reverting Maarten's change and
> instead making mv88e6xxx_port_ppu_updates() indicate whether the port
> is internal for the 88E6250 family of switches.
> 
>    Yes, you're right, I'm targeting the 6250 family. And yes, your
>    suggestion would solve my case and is a better implementation for
>    the other devices (as far as I can see).
> 
> Fixes: 4a3e0aeddf09 ("net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Tested-by: Maarten Zanders <maarten.zanders@mind.be>

Thanks Russell
