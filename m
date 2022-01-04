Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A43484900
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 20:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiADTxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 14:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiADTxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 14:53:44 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F14DC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 11:53:44 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id t26so78310182wrb.4
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 11:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z0Uhcf3wpqU1I6Qm7gNJzDOXeWTEJXqtF5s9xsAUgjc=;
        b=Y/m5KJymBfJQQ3eyL6PVm+OQrAvNgwHjp2roFMkU9SMK96iNLyOPUDwBQBQj5zMrrB
         DliZoHoBqaq/RyYEohvd1GI6iVT1MYC8rKE4CGa4qI1IkDvNkaaYOh4GGgsPZz6QiNDm
         UitpVT/wdX6LtZ0qR2nO7Vx/g1niSyrnK5wKHgJpwSJyZmw0mKn9gCmPn5ape0u1F+zX
         XW4AW8ASTSR8ucZz+TDw4b8JI1JiJ1rwySAlJidkGmcbRw/4U3peCyBLk3kP3SoLUd8z
         kjQNBCvmBUJ2GzsvArw1fCoXVLI72TxwzkoIPoilGH+0nGukku1Gc5j4EQWdUZuos7ja
         gSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z0Uhcf3wpqU1I6Qm7gNJzDOXeWTEJXqtF5s9xsAUgjc=;
        b=s7WeYehi/Bp+OtDfZptIaRivQHgt9r6VEJA7iD8GIZ2+br73lGaZGT1UbqsNtj57a+
         iarIAv4JsMXxyne5uHxWHenzlYUVUC2spJn7xmxdbMlnPN7kvASUtN1Gtbk98hBBVMa9
         cLvYayMUGfRvBtTHkWCfuUSGvtk+Bsk25DZhgzqIP4U6y83I3jrrN3Rq4UeoHSnrnviu
         ettfL41ARBuD/u+wnsuO9IJOgu54WPQOtbAG4YmHx0AQ0icroSz2ohNdmh2HjCRi8GBc
         AtJE24V9gJLJSeKAH2OvR99Rm5KocD93PcBPnE6UwgtD7LR6187/4GltW3AXJgFxn1Ws
         SwzA==
X-Gm-Message-State: AOAM532bIsTzj7ylosb9ELsAef/gMUdJJMWNLPV/h8QtDcNDV92JxwR+
        lMdo2aB6cqLIA1BMczdsNxWICD9WvIo=
X-Google-Smtp-Source: ABdhPJzKEXTpmxJSSBs2+KMamNZt+HG/tCwtDbymAYHiYbx1bNO42rs11RU77/zKXDJmYEkEKGixJQ==
X-Received: by 2002:a05:6000:118a:: with SMTP id g10mr42184820wrx.533.1641326023125;
        Tue, 04 Jan 2022 11:53:43 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id c11sm422360wmq.48.2022.01.04.11.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 11:53:42 -0800 (PST)
Date:   Tue, 4 Jan 2022 20:53:41 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next] net: gemini: allow any RGMII interface mode
Message-ID: <YdSlxW8mi+Xa4zlr@Red>
References: <E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1n4mpT-002PLd-Ha@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, Jan 04, 2022 at 04:38:31PM +0000, Russell King (Oracle) a écrit :
> The four RGMII interface modes take care of the required RGMII delay
> configuration at the PHY and should not be limited by the network MAC
> driver. Sadly, gemini was only permitting RGMII mode with no delays,
> which would require the required delay to be inserted via PCB tracking
> or by the MAC.
> 
> However, there are designs that require the PHY to add the delay, which
> is impossible without Gemini permitting the other three PHY interface
> modes. Fix the driver to allow these.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/cortina/gemini.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks!
