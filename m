Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0146DDFF
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbhLHWJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhLHWJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 17:09:39 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B526EC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 14:06:07 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so5371830pju.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 14:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fXnyobYWfm3TXwjKnM30gF+F+ARNY2zYw7bKmh2A8DI=;
        b=fQfpMFGRV4CxqF8q3tjn4DyJQlG5j9bqn2Kjr9jl2DsPv1YKwqdGBxO5sfHuZNQZcV
         cCak1puQ5Uh4p7+4TiBP3Q4ns4UKHefrNDoVBFh6hmCg3QCXGIJywDxRAdHHsPJs7ECj
         3it+DwhMVEQwEhM90E9eSDYgJ6vbOhEIWoSvO8zNgk54Atex3dRhsfccLm1Z8Mm5Foln
         rWbw8gULMRCv87REMif31jl2b+NnWws4fc0L1uV5LC5++TPggxilPOkJtOgXALm97ynX
         5xM0Xun2JXWhuzTIgKDPAEmZPR3vmQmo17selrv9SZ/yD4XpwtAgyOppvezN+p1Tsx6V
         pWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fXnyobYWfm3TXwjKnM30gF+F+ARNY2zYw7bKmh2A8DI=;
        b=1EigfeX7VyrhW04irVN2SMTgRdGOqFOpoR3hpEEzucoFrUIp08BYxOOCcRss6tEkAl
         64NIOgyYbILnxQ3KeTsS9prnMlNbLmcKGX2cirdu73HHM29tqMDNXZCEJFWCdrQPVXML
         MmGMy5aWu3WmvUuxSa8r6GAZaob1b5dVbG77Nv/y1LkaUUrKRifOJ7+EpTvQhUXNHSYu
         Vcg19167geYzr9W50TiDAGmIau+guz+kAWap+555ofWe5bxiNTHze1Ewd61RVIrI0JZD
         b+yR+bUNtG8wCjmrT19n7J6FBf2EAyfLVogUX8C/RBnb8n9H3Q1nkxjXwVsZBc6C8Af9
         VVHg==
X-Gm-Message-State: AOAM530bmQfKceamzYVs3Eilfa9Lp9zvhd2kZEDTNrKCc1cmM4bbYEwz
        ibEpeIkAtekOuf3OGOYewYk=
X-Google-Smtp-Source: ABdhPJxsYH6nGvntTVz7hG0ZtP0GMtuWNXxOY+mJ6mNWbFhzv53FpiFNsXQBVTcUbxzJdQRywbg30g==
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id w3-20020a170902d70300b00144e012d550mr61602171ply.38.1639001167156;
        Wed, 08 Dec 2021 14:06:07 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s2sm3451102pgr.11.2021.12.08.14.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 14:06:06 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: prefer 1000baseT over 1000baseKX
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a797568b-d569-da92-d4b4-7707f1e3447b@gmail.com>
Date:   Wed, 8 Dec 2021 14:06:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <E1muvFO-00F6jY-1K@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 3:36 AM, Russell King (Oracle) wrote:
> The PHY settings table is supposed to be sorted by descending match
> priority - in other words, earlier entries are preferred over later
> entries.
> 
> The order of 1000baseKX/Full and 1000baseT/Full is such that we
> prefer 1000baseKX/Full over 1000baseT/Full, but 1000baseKX/Full is
> a lot rarer than 1000baseT/Full, and thus is much less likely to
> be preferred.
> 
> This causes phylink problems - it means a fixed link specifying a
> speed of 1G and full duplex gets an ethtool linkmode of 1000baseKX/Full
> rather than 1000baseT/Full as would be expected - and since we offer
> userspace a software emulation of a conventional copper PHY, we want
> to offer copper modes in preference to anything else. However, we do
> still want to allow the rarer modes as well.
> 
> Hence, let's reorder these two modes to prefer copper.
> 
> Tested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reported-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
