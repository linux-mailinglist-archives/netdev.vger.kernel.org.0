Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BE0373389
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 03:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhEEBTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 21:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhEEBTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 21:19:12 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12D8C061574;
        Tue,  4 May 2021 18:18:15 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n25so12631649edr.5;
        Tue, 04 May 2021 18:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hWxpXq/F/UtvTk8yx3LMbiZP1vZG7S4bzKSOJwj04Jk=;
        b=iR9V6VlvJW7uzXLQUHkbjk/Xfq6uavpv22FUKFmMvzuwkXkW8hfjYDZystOsWcwdJJ
         xEMf+p127fkEGKuPJXxllzfDtEs7wbic4fA6rYi9y0YxJAyPx3qkU0pttC/n6y3fXnMo
         QElrLP084xvmE04lqH1RT/SwP02kqO8r2D6gTC/YpSwrmhVjTivFpq5n9eVcjn7iIvsl
         clS3WONM0PGrHZM+BQ/MCLStnIEZ7yVQKRZ2s9EuCqoXPISj5eQe3DncYsY5UAK3OK2y
         ztyR3fGVxXF0gEUhit+RKVo/9MHU5fsOnC3Tx38k4j6il9jfqIQmR/KBMHsnUvbiFMbW
         P5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hWxpXq/F/UtvTk8yx3LMbiZP1vZG7S4bzKSOJwj04Jk=;
        b=nDjc1MJ08Xa6KXe5cT77M5jZKDp5gao8Oz7HLk6YyPr2JdMLriGj5wFwHoEAho8egQ
         3EhbMmfpc44Xmdc07RVU+ZzQW7nUbz4zdU8zAdCd0QnfI/Qe92Z9l7CIgtsjeclpFdup
         PsqlTWFCvGgCg7TCLrTxFlzjo4lPnc2Tk5Gs1eE4Y+tLFVIlB9pOK4aUpcR65wRE1Dol
         T1Lnv+8B9aJM7RnFSiSSB7fRbVrVSvPPqXNJfzHscSEWc3HrguNI7M+ax6e60H9wjAIe
         zmvzcJ288W8D3I3pxRUiTly3RvFZ7pLZp9wr/bD/1PJU9NJHeK5qsUl6pGdHz6G6XBNn
         0HFw==
X-Gm-Message-State: AOAM5334cu02hvmlh+rkFmjELBcFKrBT4lO0Ccw3XYmqoQLzk0NC6DA0
        SvCdvMgRmGhgQspw+UPbLbg=
X-Google-Smtp-Source: ABdhPJxrPXRslVkZKAEqSWinzLatVFrEwpAvNQObwOrwJT9GualSRJaVwbQmvFo7YVUXN4rybLbaAA==
X-Received: by 2002:a05:6402:17b0:: with SMTP id j16mr28765604edy.97.1620177494579;
        Tue, 04 May 2021 18:18:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id 16sm2177870ejw.0.2021.05.04.18.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 18:18:14 -0700 (PDT)
Date:   Wed, 5 May 2021 03:17:20 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 20/20] net: phy: add qca8k driver for
 qca8k switch internal PHY
Message-ID: <YJHyIN7XbaluQwwL@Ansuel-xps.localdomain>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-20-ansuelsmth@gmail.com>
 <YJHwyPbklFgHVP3r@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHwyPbklFgHVP3r@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 03:11:36AM +0200, Andrew Lunn wrote:
> > +/* QCA specific MII registers access function */
> > +static void qca8k_phy_dbg_write(struct mii_bus *bus, int phy_addr, u16 dbg_addr, u16 dbg_data)
> > +{
> > +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> > +	bus->write(bus, phy_addr, MII_ATH_DBG_ADDR, dbg_addr);
> > +	bus->write(bus, phy_addr, MII_ATH_DBG_DATA, dbg_data);
> > +	mutex_unlock(&bus->mdio_lock);
> > +}
> 
> What are you locking against here?
> 
>      Andrew

Added the locking if in the future it will be used outside the
config_init function but since it's used only there, yes, I can drop the
useless lock.

