Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451B831ADA0
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 19:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhBMS5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 13:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMS5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 13:57:04 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CD5C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 10:56:23 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id i8so4914854ejc.7
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 10:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vVfBFoEmDvbEtVLp21h6YGN7CeIhGZ/Is5acS3VE+W0=;
        b=DE+iUB43uu7d1ZcPfs/IgLrOAOaFmkML31b73r8W96mCn6fwPMIcqh2OYWgIq3Ws49
         AKizY6+pbQ6QVV3wa+Um7/lqig3q0l1q5l9+nDa4mYs1T6MtzDw5eqPnT5gE0ILecE/u
         q7vM8ZH793a8FgPSFswKwwYj2F84LgicNAj+c4ROkjfR5tsE4MiLy+BdwmKCHienuhmk
         2AZSSSmB1vh7qYTtRAjPYNynmN1cpCDUuOJSHRSDweG3wzdlH3UMAait7rBTKYueYuz4
         S/b6HgnW7IQ8pTXIa0/JGIkUuTMHnGBXcG5WLl3tWBoAgpaInmaN6X6dwy+bUxBnGv7Y
         OYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vVfBFoEmDvbEtVLp21h6YGN7CeIhGZ/Is5acS3VE+W0=;
        b=E/ADJDQ9GXAh/PmG8ziK5DF1XCcP+ZiUHU+uak6qF647oEfvcdQCLoidKu2La7CmW7
         IdR6nbHS0LAm9TLYYYru8OXgvjxRoDgQEGCaLsP45LV++w5vquNtJMp2KAb7HOUmIf0y
         FzdeNQ+KJLE7qcwhDDItfaPa0HgBYOb6+zS9lruRjw5QYroPFXi4bzEd+JgVaNZaS3p+
         ibw0RAt6qcMhfMUsyEJ8ZcG+mkGMROCyaj33e7COkOKVpIHqh7t2UuDsqGQo1dweWCv2
         cUPcnQvWubTQXtNSWm22rOFgtbMeJs9kLi3+1bXcZtoCSgbqXnzN/3nxR++g7J1LlYWU
         F2AA==
X-Gm-Message-State: AOAM530/ui0Tyw75Oly2aebUde1SUF+WYs08CnFOrETvrJ0Lx5bNI+dq
        JdEZaGGIFlcuhcvWRQ6pI6I=
X-Google-Smtp-Source: ABdhPJw7xvFsJnM6XkVeYosmdAd83BxbnmeN6ql9Q5Awv9UgkkR7/h3USXexxGvU+HqYbg/eNiEKOQ==
X-Received: by 2002:a17:906:68c1:: with SMTP id y1mr2371009ejr.289.1613242582636;
        Sat, 13 Feb 2021 10:56:22 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i18sm7517932edt.68.2021.02.13.10.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 10:56:21 -0800 (PST)
Date:   Sat, 13 Feb 2021 20:56:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210213185620.3lij467kne6cm4gk@skbuf>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213003641.gybb6gstjpkcwr6z@skbuf>
 <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
 <1d90da5ef82f27942c7f5a5d844fc29a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d90da5ef82f27942c7f5a5d844fc29a@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 06:09:13PM +0100, Michael Walle wrote:
> Am 2021-02-13 17:53, schrieb Michael Walle:
> > Am 2021-02-13 01:36, schrieb Vladimir Oltean:
> > But the Atheros PHY seems to have a problem with the SGMII link
> > if there is no autoneg.
> > No matter what I do, I can't get any traffic though if its not
> > gigabit on the copper side. Unfortunately, I don't have access
> > to an oscilloscope right now to see whats going on on the SGMII
> > link.
> 
> Scrap that. It will work if I set the speed/duplex mode in BMCR
> correctly. (I tried that before, but I shifted one bit. doh).
> 
> So that will work, but when will it be done? There is no
> callback to configure the PCS side of the PHY if a link up is
> detected.

That's interesting/odd, on VSC8514 there is no need to force the speed
of the system side to what was negotiated on media side. I took a quick
look through the AR8033 datasheet and there isn't any mentioning the
ability to program the SGMII link according to internal state as opposed
to register settings, but it's equally possible that I'm simply not
seeing it.

On the other hand, I never meant for the inband autoneg setting to only
be configurable both ways. I expect some PHYs are not able to operate
using noinband mode, and for those I guess you should simply return
-EINVAL, allowing the system designer to know that the configuration
will not work and why.

I think you could hook into .config_aneg_done, for the autoneg=true
case, and into .config_aneg for autoneg=false (I'm talking about autoneg
on media side here), but honestly I think the PHY is pretty broken for
requiring external coordination between the clause 28 and the clause 37
PCS. So unless there is a real need to configure noinband mode, I would
probably not bother.
