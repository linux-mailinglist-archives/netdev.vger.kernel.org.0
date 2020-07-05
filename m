Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C40214F8C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgGEUqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgGEUql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:46:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8E4C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:46:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f2so14524598plr.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8fHalzuFbxhtFhTMEYCEmd4Gg+v/Uji4N2EwSMY2D2Y=;
        b=ZJPduT76pPVSt6chwJr4EGWNeYXaQUsiqLZnqy2m23dBJXOcqGxLyWk/7wST8BgHUq
         Fg4MhHxewvN5Ib2+NpEGtFkBELVpKBDmAoVUYGSVxQ8E6uk4/kDYShlb23PYaAYoFlC2
         pee1nBjW04pcWKLbyzqJ6v1wyDl30dX11c2kta4f1GHHZkifxFXkt5Zfh8QVkMsb4Jvw
         /5TmixyrhR/ccQW0xDZDZZ30V2rh9DGnEWCxwcvdwTB8vaJn5+JENCNgdkmnQLXvAR6g
         aM5HCy22nYNyGwI1nEWZS2Z/lU7ZeGhOgMHE8y/JlnxWWt6YaqvB8lqueFKeYqsKZ+3r
         wysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8fHalzuFbxhtFhTMEYCEmd4Gg+v/Uji4N2EwSMY2D2Y=;
        b=DjUotoJgK8khkvjXt+kW7d1BjqZRYq836XQidTPgpvL+7HKw9vvkbNDmylo13/v0KE
         mIzDU4o+bQURpnJA/CBTdfTMcZIofmPmBIi35y+0zaTwW4xjh0vRgoWHWVVIAaxkeRSh
         MJczAe+uh8krjqhRSTz8vNVE8FjZXtgfczU6Xfjy/H4NYIolbfJbV9/G6V6vYW/E2RB5
         RmsWxPw8TiPuNC5A7Bj+2cIvZsiQndia29UPyFF/+1imDBOWfDXkTWrpMqm6WG1sKXvM
         +frJV2LGvs1yTzV7OnK+vAheIDmhVtgStbHpfHML2keJGyqHX1VIopO0T9YCkIu0aUZf
         uejQ==
X-Gm-Message-State: AOAM533Id5W/ldT0yAI7mLIegVq38sqpnTyJpPksH+QnG9yBUaWOLh+9
        9lw29gLxdt8igEqBF8nRYTU=
X-Google-Smtp-Source: ABdhPJxdYGCKPYyrbH+E6q9xAaL5xCxBGw9t+9FF+c7k0ogBAwZVgROtyoXLfyOeoPwhBq+t2usZgA==
X-Received: by 2002:a17:902:e783:: with SMTP id cp3mr37384540plb.265.1593982001399;
        Sun, 05 Jul 2020 13:46:41 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id h7sm17438329pfq.15.2020.07.05.13.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:46:40 -0700 (PDT)
Subject: Re: [PATCH net-next 6/7] net: phy: cavium: Improve __iomem mess
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-7-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a277a07b-9dd0-c211-e02e-a3be850f9325@gmail.com>
Date:   Sun, 5 Jul 2020 13:46:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705182921.887441-7-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> The MIPS low level register access functions seem to be missing
> __iomem annotation. This cases lots of sparse warnings, when code

s/cases/causes/g

> casts off the __iomem. Make the Cavium MDIO drivers cleaner by pushing
> the casts lower down into the helpers, allow the drivers to work as
> normal, with __iomem.
> 
> bus->register_base is now an void *, rather than a u64. So forming the
> mii_bus->id string cannot use %llx any more. Use %px, so this kernel
> address is still exposed to user space, as it was before.
> 
> Cc: Sunil Goutham <sgoutham@marvell.com>
> Cc: Robert Richter <rrichter@marvell.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
