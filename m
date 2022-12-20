Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6761F6522DF
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiLTOkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiLTOkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:40:24 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DB719295
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:40:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a1so2750232edf.5
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A7DJYvj0HJSXvqOrQKOJ+BEkXu6V/urJKQru7403AWQ=;
        b=FntIJglrfbDgSa/cnD38uy0eMlafshp/sR6gGn1IEgAlQ7hmjj3F6TVW5SZAvBs6wN
         ezJBzAIQwVuq5oC7O3ee2mYHlAcZA2AjIEwCqmVpXKiI9/OUwk6FiWQJIQcZLLCxsOUf
         l91GOcNynrGL/sw5lSvnuLz1XLveTMjWamkW3l2ueksh9tYa43/qqw8mzfL2dKQQzNdG
         SuTRMiXDInFaWErZzstpb7on3R3EYwaKsDjbdPt14/0mjHOHrrEHMhkQIG1EoNNkspVd
         NQW6ZXCIjy7949zzZDSwR8MhAPAkgcQBU65rbi+oHC5ViMMQy3bFVr4/2E2MBucHfIag
         3ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7DJYvj0HJSXvqOrQKOJ+BEkXu6V/urJKQru7403AWQ=;
        b=ch8GD4h3I+t2WQfthjXVFu1paxiK5oz+CyNAslKHFb4B5+uPal32wzRknOOi/d+L5t
         TYfoD+Weia33hA8JM4l/KnaRL77wbUit3LnOCCiAzGCaBh7Rwm7i8FITPzDr76TAOctz
         PmUYVvQ4DHSyBm5OrWoQgblcAdwhm7RGmsB+CJhvHXuekVjoDVy15wJ5Zg2y+4vswAT5
         NlfNRVUjVawtSSZVcUKNsfWwwmAMGWeu7W/WhJYe7UZYKkA+VZYjtX+onCCDzeUtcMek
         fD0fv1dKd4fuZLv3b4KxREVOnNSLPuOgN9nbTUHVBNmSsGf5UkmHsoRSJklT8+gbDZnf
         OGUg==
X-Gm-Message-State: ANoB5pkdI0MBf/anmCiF8WtuTcou27o2Fw7xOFwRigA8SV/ylUimg+8V
        2jB+OWSlAiY17CpffWHbLbY=
X-Google-Smtp-Source: AA0mqf4AIxfjNluJcHMNXG/JH5ybmd6gRx6GK6UgTM3qILw7Lt3+2hC1yexrHJqYoi6jP+vhe8EzFg==
X-Received: by 2002:aa7:cf0c:0:b0:470:410a:8ea7 with SMTP id a12-20020aa7cf0c000000b00470410a8ea7mr41905490edy.18.1671547219254;
        Tue, 20 Dec 2022 06:40:19 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8e2:dc00:f0bd:8bdf:7b38:7c14? (dynamic-2a01-0c23-b8e2-dc00-f0bd-8bdf-7b38-7c14.c23.pool.telefonica.de. [2a01:c23:b8e2:dc00:f0bd:8bdf:7b38:7c14])
        by smtp.googlemail.com with ESMTPSA id e2-20020a50ec82000000b0045723aa48ccsm5683273edr.93.2022.12.20.06.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 06:40:18 -0800 (PST)
Message-ID: <7ac42bd4-3088-5bd5-dcfc-c1e74466abb5@gmail.com>
Date:   Tue, 20 Dec 2022 15:40:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        netdev@vger.kernel.org
Cc:     pabeni@redhat.com, woojung.huh@microchip.com, davem@davemloft.net,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <9235D6609DB808459E95D78E17F2E43D408987FF@CHN-SV-EXMX02.mchp-main.com>
 <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 1/3] net: phy: add EXPORT_SYMBOL to
 phy_disable_interrupts()
In-Reply-To: <20221220131921.806365-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.12.2022 14:19, Enguerrand de Ribaucourt wrote:
> It seems EXPORT_SYMBOL was forgotten when phy_disable_interrupts() was
> made non static. For consistency with the other exported functions in
> this file, EXPORT_SYMBOL should be used.
> 
No, it wasn't forgotten. It's intentional. The function is supposed to
be used within phylib only.

None of the phylib maintainers was on the addressee list of your patch.
Seems you didn't check with get_maintainers.pl.

You should explain your use case to the phylib maintainers. Maybe lan78xx
uses phylib in a wrong way, maybe an extension to phylib is needed.
Best start with explaining why lan78xx_link_status_change() needs to
fiddle with the PHY interrupt. It would help be helpful to understand
what "chip" refers to in the comment. The MAC, or the PHY?
Does the lan78xx code assume that a specific PHY is used, and the
functionality would actually belong to the respective PHY driver?

> Fixes: 3dd4ef1bdbac ("net: phy: make phy_disable_interrupts() non-static")
> Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
> ---
>  drivers/net/phy/phy.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e5b6cb1a77f9..33250da76466 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -992,6 +992,7 @@ int phy_disable_interrupts(struct phy_device *phydev)
>  	/* Disable PHY interrupts */
>  	return phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
>  }
> +EXPORT_SYMBOL(phy_disable_interrupts);
>  
>  /**
>   * phy_interrupt - PHY interrupt handler

