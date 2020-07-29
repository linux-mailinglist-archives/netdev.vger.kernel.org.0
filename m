Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652192327BC
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 00:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgG2Wxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 18:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgG2Wxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 18:53:34 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82101C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 15:53:34 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id a21so25971836ejj.10
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 15:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pasaJLCwCKlDq6v4qFn8ZPm5KXhK+QvJ+OJGjfvNLHo=;
        b=USeNOknD18VaoijYd+kr8LEZxJTer7FtohghT6aRYDhuUuV+uCZeEyiWeAkoWGImTw
         scCCWJ9faCnINxBawAD24I/k+t3luhmluMZY8TN4FBLc+IdyjQWYW5SHx5qq/k4fxFEz
         WG/1Fc01WFOrGTrGyO9KTFNHPhqCcNL2ttbwsWwJzSd3L/0QXGpDVSuVH61pMy6dP3u3
         O/DVQyMrkmrQ5gcBJmpwMYulQ9HGruK9c/sVpYPjS708M8jo/DFqwqOmW+k7CBy1K7hX
         J8/kMGuU6FBZD5v38XXqeovhY2DGNh+cdnn+9NNtPAI3B5dE6r4c7UO/BDvUmp71DU/5
         DYMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pasaJLCwCKlDq6v4qFn8ZPm5KXhK+QvJ+OJGjfvNLHo=;
        b=lasMqf95yTyOKVie1iUYmXVNLjYDgA1uGn2VccpPUbNf5IQK8ZHkIlJHfg/V5aysFk
         Pj6+/iU5V813NZ+F/enu1xg+EI5O1ZOLRU37pqNa+Huq7wWfTykI8XlDS0QFGSY2l2yj
         33lAIBHemKrfdGj56TbxhgU/AEHojP32hSLASk+XYyGzN9zRttYhOGs0CDkkTp9Z/50W
         EzEO2dTevxzPkeW6y1YEyKST7WgwaUfAJUkpN+/HGytC3HoVpTqt2xSM40CNAEJgVWfR
         Zw6G9p+7Yy9Y9j+t+NAqi97O9UCwetnJDoSmnlWlapU3rydGEqaa/EqpKrl1awdKoFNZ
         lbKw==
X-Gm-Message-State: AOAM532W+n84jdSFTaqN+7L7WZxV2NTo9TAnZzjzqpR0hi0FClh1KQ8h
        uSbKIVmszmw3nUKdHPawbCo=
X-Google-Smtp-Source: ABdhPJxdqnyTQtbr3MRCl1igHqVZklD+SdZEd1WnxJKwPuukdXwcRbcbCCKJaMVROk4NPn9gAPduZg==
X-Received: by 2002:a17:906:24d0:: with SMTP id f16mr543191ejb.325.1596063213238;
        Wed, 29 Jul 2020 15:53:33 -0700 (PDT)
Received: from skbuf ([188.25.95.40])
        by smtp.gmail.com with ESMTPSA id cc9sm3442084edb.14.2020.07.29.15.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 15:53:32 -0700 (PDT)
Date:   Thu, 30 Jul 2020 01:53:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200729225330.3nnlpfvnbi3akdcv@skbuf>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200729132832.GA1551@shell.armlinux.org.uk>
 <20200729220748.GW1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729220748.GW1605@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 11:07:48PM +0100, Russell King - ARM Linux admin wrote:
> 
> The way PHY PTP support is handled is _really_ not nice.
> 
> If we have a phylib driver that supports timestamping, and a MAC driver
> that also supports timestamping, then what we end up with is very
> messed up.
> 
> 1. The SIOCGHWTSTAMP/SIOCSHWTSTAMP calls are directed through
>    ndo_do_ioctl().  The MAC driver gets first call on whether to
>    intercept these or not.  See dev_ifsioc().
> 
> 2. The ethtool ETHTOOL_GET_TS_INFO call, however, is given to the
>    PHY in preference to the MAC driver - there is no way for the MAC
>    driver to gain preference.  See __ethtool_get_ts_info().
> 
> So, if we have this situation (and yes, I do), then the SIOC*HWTSTAMP
> calls get implemented by the MAC driver, and takes effect at the MAC
> driver, while the ethtool ETHTOOL_GET_TS_INFO call returns results
> from the PHY driver.
> 
> That means the MAC driver's timestamping will be controllable from
> userspace, but userspace sees the abilities of the PHY driver's
> timestamping, and potentially directed to the wrong PTP clock
> instance.
> 
> What I see elsewhere in ethtool is that the MAC has the ability to
> override the phylib provided functionality - for example,
> __ethtool_get_sset_count(), __ethtool_get_strings(), and
> ethtool_get_phy_stats().  Would it be possible to do the same in
>  __ethtool_get_ts_info(), so at least a MAC driver can then decide
> whether to propagate the ethtool request to phylib or not, just like
> it can do with the SIOC*HWTSTAMP ioctls?  Essentially, reversing the
> order of:
> 
>         if (phy_has_tsinfo(phydev))
>                 return phy_ts_info(phydev, info);
>         if (ops->get_ts_info)
>                 return ops->get_ts_info(dev, info);
> 
> ?
> 
> Thanks.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

When we were discussing this in the other thread:
https://www.spinics.net/lists/netdev/msg669699.html
what I proposed was to introduce a NETIF_F_PHY_HWTSTAMP net_device flag
that could get set when the driver is capable of doing the right thing
with PHY timestamping. Then ethtool could look at that flag.
Additionally, if we could make this flag configurable as a netdev
feature with ethtool, then you could turn it off and even if you have an
attached PTP PHY, you'll use the PHC of the MAC.
You're free to leave your thoughts in that thread.

Thanks,
-Vladimir
