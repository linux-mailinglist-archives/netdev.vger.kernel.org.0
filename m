Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3508131B138
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhBNQ3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhBNQ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 11:29:06 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B84BC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:28:26 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id jt13so7490111ejb.0
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lbZ7cKpOiaJr9c2oGS86iikEgp9Woa8Yz6dWQQQt7Nc=;
        b=bqKQAMlOrD2HIw1MySB6f5A8Mub9tSuLxQc3iRYEOBOIbLOjuNCR6DMpkpnf0hGBc1
         Vcj8FH1X6jSEdoK4biAI3cM46oE8bzP/v4/eYppsRsTJwTCaB4H69LEfO7nIfvM8Fxtc
         BuYB5o4xLO4gur0GMLHpOIZcIth1usAjwNCoJSUaXPiVYtNEmMjroxMwyRcVO3gsltQq
         YI06GAMxy+abI290A0zIAX7aE1U8IQYp1NTHbkquBkKdSvUULWCXW+0OAbuEaNClAbYd
         C1TJrmZXCmxRaIR8MVHkDwcNS2/ZGbjadDzJllFxsRxzaOrvgh6CQN5jCdK5GIUdUn1L
         qDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lbZ7cKpOiaJr9c2oGS86iikEgp9Woa8Yz6dWQQQt7Nc=;
        b=Sf0qKRBh69cbXkmvHzYablq18CbeO7F5+wGYftl6h2RfM/MaesIAC/zXkUONkEKsbo
         TguwXoi10TJD1QiMkZ2a0vOgshXYfQiDSHEE/GfaCVCrztNY4bKx3LqrO9NMUPCTbHsh
         QGQrybGcwswctBTDo+VjgciYzBff4tC6d8I7v3L6BYvH4/bxftvd6yaDydbBrNE5ZOns
         v0cvFUcro++3pyngux3wJhGlnOLEbR7N9Q9SGEZ5UUkwhJlL1VTJ35iNl/Se2/9S5sUt
         oL1E3DA3mGRGn+g0PieDxVft8dmaaSU8zdisqDXJFKv4RxkwoarP4ZF2JLJ3PD0kqQhf
         LwgA==
X-Gm-Message-State: AOAM531mPHYaLPF+I890XArQGB6qobPr6jwDs6Mqyp3LCUUyB+OJ8cdv
        uEPcrjicAtsTw1lS1eruHdg=
X-Google-Smtp-Source: ABdhPJxWBMLuBM1Jy/hQEBow4v9iwI4aqH+Uzmj2OLR/71pFb4yBAAdM41KALBgw0oiCT69PGINJwA==
X-Received: by 2002:a17:906:1956:: with SMTP id b22mr12632089eje.114.1613320104970;
        Sun, 14 Feb 2021 08:28:24 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm9295638eja.81.2021.02.14.08.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 08:28:24 -0800 (PST)
Date:   Sun, 14 Feb 2021 18:28:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next 0/4] Software fallback for bridging in DSA
Message-ID: <20210214162822.opken4nrk5hthlri@skbuf>
References: <20210214155326.1783266-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210214155326.1783266-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 05:53:22PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As was discussed here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20201202091356.24075-3-tobias@waldekranz.com/
> 
> it is desirable to not reject a LAG interface (bonding, team) even if
> the switch isn't able to offload bridging towards that link aggregation
> group. At least the DSA setups I have are not that unbalanced between
> the horsepower of the CPU and the horsepower of the switch such that
> software forwarding to be completely impractical.
> 
> This series makes all switch drivers theoretically able to do the right
> thing when they are configured in a way similar to this (credits to
> Tobias Waldekranz for the drawing):
> 
>       br0
>      /   \
>   team0   \
>    / \     \
> swp0 swp1  swp2
> 
> although in practice there is one more prerequisite: for software
> fallback mode, they need to disable address learning. It is preferable
> that they do this by implementing the .port_pre_bridge_join and
> .port_bridge_join methods.

Sadly there is some false marketing on my part here and this series is
probably not enough for the above configuration to work in software.
I have to confess that I tested with software bridging, and with
software LAG, but not with both at the same time. I sent this series way
too quickly and I should probably spend more time on it. Sorry to
everyone copied for the noise.
