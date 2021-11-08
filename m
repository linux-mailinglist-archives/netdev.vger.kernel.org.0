Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43226449808
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbhKHPWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhKHPWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:22:01 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C6CC061570;
        Mon,  8 Nov 2021 07:19:16 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d24so27536245wra.0;
        Mon, 08 Nov 2021 07:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0UgxhSO3VS7lE1Qbtzz6PCS/79bXIcN+v+cxY6Q5rY=;
        b=N5ABK3F+wUiTUnqjYz/5cQ3pFlpJ4ZWKrIfVL543NKoSYE+u6GEsSTW21HaChwCmzQ
         MZSycOqdEng49+sTPNdda4tPrs45AimAOyhGUpJL93G86x9nW7I8D7qQC4TI2xeTnBRN
         LSfm7zDUcysmBizo7rTGzP4Gck+JRNBDBjpFDOIt9rl4XNxbfY+I+3o89Tf7HqZVi/HU
         MdBTLbATJD2ojiROC/X76x0XIJ4gzkytkSR3sK4ZDfjPhPyfw/cWx47XnjVL8sQWWNa8
         FIivBpgav0R90YNFEikDx2XB/lhUMTYWTQ/6mvFeZxq+8bQRBXfFofr1LlBleIv9q+PD
         CzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0UgxhSO3VS7lE1Qbtzz6PCS/79bXIcN+v+cxY6Q5rY=;
        b=fodOS3dS7sHN0xGdzJtwNQ/vGUlOctZylD+00mQqHnfv0oA8s82z/4FRxOO5sPBYrx
         ygTgzvUwX2YOXae5WSH9EQvPGT/3onEa8eIeZPgo+C6GjGl1pHk5fTj06JsZEprjVGNR
         oOCIG4JWo6Rb2aIvYloJZjmGjWMats5irze28CS8obxnEBTsYjENTWfmOuHKXliaMHBr
         ADmvbYetJ5udjIHTYOdkd/oCnFdTFcVRLytN+UeyOBRyHoJeKeCU2Bsf4YNxnjy0VEt9
         I64a80AWQCq3ysXjqffKGbSVzMyY8UPfdU6SszF07Wnft2I8LR/5ovRdd52WNbm8jCID
         8Z8Q==
X-Gm-Message-State: AOAM5320qlxcoA42iZjgDPuYVqz72VK8eF1OzxyZJQ30GHCIX4YbgcX5
        htoAzGeyjq17r0FRS9JwUMMQDxSlUOo=
X-Google-Smtp-Source: ABdhPJx6wEJ0HyH3ODXf3R+ZN2UrMGtNivD7rCHS5b+2JhAR5DIP+vLbo2e1Y2BugcI3M8vNI0UjSA==
X-Received: by 2002:adf:dc0e:: with SMTP id t14mr541769wri.277.1636384754971;
        Mon, 08 Nov 2021 07:19:14 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id e18sm16976074wrs.48.2021.11.08.07.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 07:19:14 -0800 (PST)
Date:   Mon, 8 Nov 2021 16:19:12 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/5] leds: trigger: add offload-phy-activity
 trigger
Message-ID: <YYk/8IIhCYUZFcy4@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-4-ansuelsmth@gmail.com>
 <YYkxfRrJ8ERaTr5x@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYkxfRrJ8ERaTr5x@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 03:17:33PM +0100, Andrew Lunn wrote:
> On Mon, Nov 08, 2021 at 01:24:58AM +0100, Ansuel Smith wrote:
> > Add Offload Trigger for PHY Activity. This special trigger is used to
> > configure and expose the different HW trigger that are provided by the
> > PHY. Each offload trigger can be configured by sysfs and on trigger
> > activation the offload mode is enabled.
> > 
> > This currently implement these hw triggers:
> >   - blink_tx: Blink LED on tx packet receive
> >   - blink_rx: Blink LED on rx packet receive
> >   - blink_collision: Blink LED on collision detection
> 
> When did you last see a collision? Do you really have a 1/2 duplex
> link? Just because the PHY can, does not mean we should support
> it. Lets restrict this to the most useful modes.
>

Ok will drop this. In my case (qca8k) I also never see a device using it
so I agree on the fact that should be dropped.

> >   - link_10m: Keep LED on with 10m link speed
> >   - link_100m: Keep LED on with 100m link speed
> >   - link_1000m: Keep LED on with 1000m link speed
> >   - half_duplex: Keep LED on with half duplex link
> >   - full_duplex: Keep LED on with full duplex link
> >   - linkup_over: Keep LED on with link speed and blink on rx/tx traffic
> >   - power_on_reset: Keep LED on with switch reset
> 
> >   - blink_2hz: Set blink speed at 2hz for every blink event
> >   - blink_4hz: Set blink speed at 4hz for every blink event
> >   - blink_8hz: Set blink speed at 8hz for every blink event
> 
> These seems like attributes, not blink modes. They need to be
> specified somehow differently, or not at all. Do we really need them?
> 

Sorry I didn't update the commit. In sysfs they are exposed as option
like the power_on_reset and linkup_over. So they are option on how the
LED behave on the event.

> >   - blink_auto: Set blink speed at 2hz for 10m link speed,
> >       4hz for 100m and 8hz for 1000m
> 
> Another attribute, and one i've not seen any other PHY do.
> 

Yes we can consider dropping this but I think the other 3 should be
keeped.

> 	Andrew

-- 
	Ansuel
