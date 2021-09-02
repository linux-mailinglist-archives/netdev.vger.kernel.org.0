Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299A03FF5BA
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347516AbhIBVkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347504AbhIBVkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:40:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6117DC061575;
        Thu,  2 Sep 2021 14:39:53 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a25so7659496ejv.6;
        Thu, 02 Sep 2021 14:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rJvxkAdulhUIdsF56GSXZaZ2YTND6rH8sRZViBhGwXM=;
        b=W3geKo1Vb1L/9hENc90Sj9M2USsm7CePZlJOW+NzzDK8mela7xGMKirtjwnIkTPGz1
         ucwum7W1aq9RcqhYRgDHBRN1Y4uSCKOJyoP/qNbWqR0n3ag84qZa8Y+qqxsZpiV8uyjx
         fO9ackgr4EpeArJBrnouwql+PxK0/7gfBWH3sCrFRjfF0LI52vqC1WpzJ2174OZpzcDd
         Y8wV7Dos3vluJMMS22u2XSLKV5k5eStlUe8WPVbmB9DfKUu9v7dtY5UgfBVAzdmInoOB
         vcC3UgdnR++d52Dhbrd7qe0xY+f1qrDoXFiTEmNWFKgcdIiqg41XWl159JV9ku+wo7Zo
         +4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rJvxkAdulhUIdsF56GSXZaZ2YTND6rH8sRZViBhGwXM=;
        b=HN0su0KpkEPewlxrWknjABV1dAW4MMntZjZWSK0npJsll44Rc1w+fOs8zFQkXMKH87
         hIcweuBhmh4c8YrX/sBq2zOuu0mAiunWq+HbuXxjHO5s+WxTT/v5oQmMotq900IVAV8h
         Is19M9zbMmlQs6n6TQuoOrlh03EJhAUfD/iJNRH+lkaR7e25v/HXpmrj+UswSFDqGiiA
         0JSMVPtg7Ij5HlUBc36kH0LQpjsG8FI64OhFnnI3SuyJzQU01amRB3iNsb+ei7gRa+vA
         pLKTSPknhx+ZUgwjrH8alRz4PjOE17lA4LPpUZuSIprmrj35pqlzNk2xxfEHdCyDvqB0
         +6iw==
X-Gm-Message-State: AOAM533qyI+Jr7aySm68gj6YcTh2AyU78puwpwUyEsTYj2WN5IAizCS3
        y11Jk1ZbyqtOWHa8DpJgVEA=
X-Google-Smtp-Source: ABdhPJxch9BdEmh3kM7HmUjX6pd5YrlDsZ5r6cYV+Z4PmOQUJfWXZGMStEqYqIcF2VC9zRY8LCLNZA==
X-Received: by 2002:a17:906:1913:: with SMTP id a19mr311273eje.390.1630618791999;
        Thu, 02 Sep 2021 14:39:51 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id n2sm1929918edi.32.2021.09.02.14.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:39:51 -0700 (PDT)
Date:   Fri, 3 Sep 2021 00:39:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902213949.r3q5764wykqgjm4z@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902213303.GO22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 10:33:03PM +0100, Russell King (Oracle) wrote:
> That's probably an unreliable indicator. DPAA2 has weirdness in the
> way it can dynamically create and destroy network interfaces, which
> does lead to problems with the rtnl lock. I've been carrying a patch
> from NXP for this for almost two years now, which NXP still haven't
> submitted:
> 
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=cex7&id=a600f2ee50223e9bcdcf86b65b4c427c0fd425a4
> 
> ... and I've no idea why that patch never made mainline. I need it
> to avoid the stated deadlock on SolidRun Honeycomb platforms when
> creating additional network interfaces for the SFP cages in userspace.

Ah, nice, I've copied that broken logic for the dpaa2-switch too:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d52ef12f7d6c016f3b249db95af33f725e3dd065

So why don't you send the patch? I can send it too if you want to, one
for the switch and one for the DPNI driver.
