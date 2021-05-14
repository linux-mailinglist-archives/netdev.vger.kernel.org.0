Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FC1381413
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhENXIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:08:15 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80DBC06174A;
        Fri, 14 May 2021 16:07:03 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id di13so342060edb.2;
        Fri, 14 May 2021 16:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FByqF0c3I3+KZiJjq4VOafu2X3oZBAK8FocGFJktVR8=;
        b=SkAjQXrU7Zu2LFjEC0wfEcraxocPb4VZBSDiphrIBgwXWfM2l/p89/gMoAqwtKEIk1
         qygiXIr+5IT11PWPviABMFRklx6aCOIEuLOeDz0yTV0S/irvrkt35RuLSDuRL7+JcNw5
         v0MspceUkm8VgBQCHFfWSoYg9V9i1Oz7djSjGLTxwkQOKiQpo02uLqOBt8javeLANlV1
         5CNnEg9zPxhpfI2en2wf2YTcFR1AO26kW4M8I2rexXnfl7iWsbuLcSYUH8w7ZpwNub2g
         Qbaxr5IPBNJLWfYKauG6gHy9YwL3gIwTexSaSQYnE3nLbFN0cH+hRWvkFTmFCkMiUY11
         CAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FByqF0c3I3+KZiJjq4VOafu2X3oZBAK8FocGFJktVR8=;
        b=aW7MTw/Z3TLhBXrhQUPaoqxVxVYNVZ1bgIQ8NNAZwtIM1Nb5RxXG0k15PxSjhJmyl3
         kojzy/hwVJTXd6v618chXbGY1vk10sHRvMVttW5yxuKXP1UEcIYLsSO9BOBJ8YeXDseX
         3X+sIIgukFKJFQmsSUJwa4PdOL4QTlkGvPj0b43xAkLmRqcltR6iQ63ydSIaHS8PPZv9
         hknuOfcX2DTJ5EieT+DLP97O4H0kVpW8tZA/628YvDBR0G9sUTmnPrKZPYKLj9hrvo9y
         yIcKcnoR96OzDxXdK5TW8JyHiCSojGPHMLzbWUmw+8b9wMC+59C/PchFFb1ZtQXFuYiz
         ehfQ==
X-Gm-Message-State: AOAM53103FePBQ/ynuf4xeZP28jYUclpVLGQ3vjtjX0dhs5Dd2+M+EUB
        CAO+P7kHb5pN0xugxKS+LJ1fUhMgUFpJCw==
X-Google-Smtp-Source: ABdhPJzuMGMrdrVFxx08bwzxWACY6Q+PtzanMlNhNCGyBVaDexUbzJrhfb7lMjHaSy1Ga8QT1Kr2lA==
X-Received: by 2002:a05:6402:4383:: with SMTP id o3mr58546981edc.333.1621033622467;
        Fri, 14 May 2021 16:07:02 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id j8sm5397593edq.67.2021.05.14.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 16:07:02 -0700 (PDT)
Date:   Sat, 15 May 2021 01:07:02 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 02/25] net: dsa: qca8k: use iopoll macro for
 qca8k_busy_wait
Message-ID: <YJ8Clibm/95FOz4D@Ansuel-xps.localdomain>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
 <20210514210015.18142-3-ansuelsmth@gmail.com>
 <20210514225225.GI12395@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514225225.GI12395@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 11:52:25PM +0100, Russell King (Oracle) wrote:
> On Fri, May 14, 2021 at 10:59:52PM +0200, Ansuel Smith wrote:
> > Use iopoll macro instead of while loop.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> This doesn't look quite right to me.
> 
> >  static int
> >  qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
> >  {
> > -	unsigned long timeout;
> > -
> > -	timeout = jiffies + msecs_to_jiffies(20);
> > +	u32 val;
> 
> val is unsigned here.
> 
> > +	/* Check if qca8k_read has failed for a different reason
> > +	 * before returning -ETIMEDOUT
> > +	 */
> > +	if (ret < 0 && val < 0)
> 
> but here you are checking it for a negative number - this will always be
> false, making the conditional code unreachable. Either the test is wrong,
> or the type of val is wrong. Please resolve.
>

I know this is wrong and I will fix.
Anyway I tested this and I checked if with u32 a negative value was
actually provided and to my surprise the value was correctly returned.
Any idea why?

> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
