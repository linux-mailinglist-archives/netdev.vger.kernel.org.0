Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29643214FD7
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgGEVR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgGEVR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:17:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB49C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:17:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id lx13so21825763ejb.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+KlogzoLpfjPSjxyTIJl8g+wIr07EY8VR27s60YTCnQ=;
        b=Qk79OiUs2ZqVEmEaNBIVqGe81soNOerwAN/6VZMOGCm6ti4blKtIHzrsLroSG4lZGS
         74HJbSHc0QdVkY4ioUPFFjHsLl2gmENgXJ3VNRxE2K1NavHfEO6AcziwmrLKiXZCzctn
         +Kxn2qZomW5NnuY57Knei738eX/dUMQQTiqwGGAN+z93XdinvMa25F+4cxiqNBqFga9+
         OhFysSlEFMTNxnCScrfa8ZbzXarKi1wDE5io4fUkRLplxNh0M/sVU0DRDhplIEKrghya
         8ANIZtkxLEaBRVzfi5o4g0FuYOm27caCkgYZ9hWIUAtBeFKMMGhh0eZapbayOi5pP8nX
         899A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+KlogzoLpfjPSjxyTIJl8g+wIr07EY8VR27s60YTCnQ=;
        b=cTTFdPcAbZvISek7W0EP5vsvJYC2r3YeduBgQZRydbVYWzHKBKtpnXI8jS40HV5PbP
         tVdNvrZEsTg5z3yvj2FrI8kLbekPRlzTfPT8lg7MIxpWj8vxaIdV0F/OuOZjz9LZEzHR
         cte4vmLaT9VICnEBSxOykIApbDQ3c54DoNnkaII8KKR2K1FT9NcPNp2vpLznbk9mozri
         EqX8KIr7Xdl0pbzk6P45z29ppP3jYQOHdheUi8By6ihwsdzLL96H5U423nvDrG9NAhBM
         nLmELp1ke4No5oIgRLrY/+rnlIN0PWdaQzVT4f+aWO1OZlwghadFuMZcMnJE0OLJgwFt
         sbGQ==
X-Gm-Message-State: AOAM5324+3VBR/YbWdveR2rxVQ04H5Y9kdukSfjEHT2d+QBbFhzT9HtK
        BmwZEUGlQqVMY5jbyarhK+Y=
X-Google-Smtp-Source: ABdhPJxwzahCCJ1+pMePi6D9LT+PDVVqQGRL/c3gzhbLRsTtiADGAoOQlLsC7whpauUkZ2m0N27TVQ==
X-Received: by 2002:a17:906:1c4b:: with SMTP id l11mr39811175ejg.307.1593983875026;
        Sun, 05 Jul 2020 14:17:55 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bq8sm11645453ejb.103.2020.07.05.14.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 14:17:54 -0700 (PDT)
Date:   Mon, 6 Jul 2020 00:17:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH v3 net-next 4/6] net: dsa: felix: set proper pause frame
 timers based on link speed
Message-ID: <20200705211752.f2jczckp3rgh5hwh@skbuf>
References: <20200705161626.3797968-1-olteanv@gmail.com>
 <20200705161626.3797968-5-olteanv@gmail.com>
 <3b84975f-5990-b4d7-7c4c-df42459172d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b84975f-5990-b4d7-7c4c-df42459172d2@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, Jul 05, 2020 at 02:09:30PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/5/2020 9:16 AM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > state->speed holds a value of 10, 100, 1000 or 2500, but
> > SYS_MAC_FC_CFG_FC_LINK_SPEED expects a value in the range 0, 1, 2 or 3.
> > 
> > So set the correct speed encoding into this register.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Did you want to provide a Fixes: tag for this change?
> -- 
> Florian

I am not really sure how fine-grained this really is. Some testing with
dedicated testing equipment was done even with the old values, and I
don't remember that it raised any eyebrows at the time. I would prefer
to not use the "Fixes:" tag here, just to be on the safe side.

Thanks,
-Vladimir
