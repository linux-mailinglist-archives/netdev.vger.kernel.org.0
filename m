Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0358D358FF7
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhDHWqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbhDHWqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:46:33 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CECAC061760;
        Thu,  8 Apr 2021 15:46:20 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id bx20so3123276edb.12;
        Thu, 08 Apr 2021 15:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oAeXxEdVlznuiPjvchmS6RIRpHke1PU0HYUnkTGypso=;
        b=JuSjNgq7hyche6rTysSqRfv22oC866jtESS9MuITNIHHQNgolbO5c+6x4J8vTGBKFO
         R7KmRnjOqRbSPO+rbdTNCgsUfQVXrZ3PUK75SZDOKWgc+Hvx35FYFj0iEqiZ94gnBCVw
         GDRuzw7+kuvXUlKLPNapidv46BxXsrjOXwqD1mNEj919S9CuD42y1UCQ4iBYdY79Og5o
         ICSRSQTbCoLTmq7o2qEpLhzAyVZOpnHdD1RGtHTm7r0KmTjEyFWvuCxtn1FnfwQIHp/V
         5ytL1zlrOsN5mSRc6RyTORFHvFHZHo+4jx7qGY8bf+UAFOxo83CoFEps7Cz3EyT/lAWy
         Vcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oAeXxEdVlznuiPjvchmS6RIRpHke1PU0HYUnkTGypso=;
        b=l5hYNDfS2AhCf14Xajx/h3JXW+Duu9bnszMbFYqvsCQbyv6w2WUEPWS6WaaaFXWuYi
         2S665yBoATR0OCEaAm6gx8bhYuCwIM8b4fy5uf47rmc545JOmurMAtXg1qvfeyHrljNC
         3GJd8vV9NWrYWh3f/QBn7beRmo4RijTmD8znTHoRINH521QQqU8EBp3JYxWU6BzKbHOb
         vDVgJv5wvJlO4PFoV0eGosSTaLTjf4oGPe5ZJu54nhg5TUV1X5qWv5QkHP6OHmqvXFfl
         vY/gqKdbZaU0iqxU+xfMZwCm8p+vGlpieSinmHnrOi1UZJzoGHGONL5jdELfytsm1XtR
         I62A==
X-Gm-Message-State: AOAM5302Nr9JiT7FluJpN6LAUm3uTwSdSCNdh6+skpdfKa+SMjhIRj2N
        HKS/NPcKMrVVA16NBHg1Uus=
X-Google-Smtp-Source: ABdhPJzGfeW4yc8tC/zigJemFnDb0zZZDVYrcQrCrJKbgEdNEYGIRv4n2bIY7oKOD9oeS4iIPQ56RQ==
X-Received: by 2002:aa7:c950:: with SMTP id h16mr14330826edt.381.1617921978972;
        Thu, 08 Apr 2021 15:46:18 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm374237edv.61.2021.04.08.15.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 15:46:18 -0700 (PDT)
Date:   Fri, 9 Apr 2021 01:46:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: dsa: lantiq_gswip: Don't use PHY auto
 polling
Message-ID: <20210408224617.crnllsf7eedxr6cp@skbuf>
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
 <20210408183828.1907807-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408183828.1907807-2-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 08:38:27PM +0200, Martin Blumenstingl wrote:
> PHY auto polling on the GSWIP hardware can be used so link changes
> (speed, link up/down, etc.) can be detected automatically. Internally
> GSWIP reads the PHY's registers for this functionality. Based on this
> automatic detection GSWIP can also automatically re-configure it's port
> settings. Unfortunately this auto polling (and configuration) mechanism
> seems to cause various issues observed by different people on different
> devices:
> - FritzBox 7360v2: the two Gbit/s ports (connected to the two internal
>   PHY11G instances) are working fine but the two Fast Ethernet ports
>   (using an AR8030 RMII PHY) are completely dead (neither RX nor TX are
>   received). It turns out that the AR8030 PHY sets the BMSR_ESTATEN bit
>   as well as the ESTATUS_1000_TFULL and ESTATUS_1000_XFULL bits. This
>   makes the PHY auto polling state machine (rightfully?) think that the
>   established link speed (when the other side is Gbit/s capable) is
>   1Gbit/s.

Why do you say "rightfully"? The PHY is gigabit capable, and it reports
that via the Extended Status register. This is one of the reasons why
the "advertising" and "supported" link modes are separate concepts,
because even though you support gigabit, you don't advertise it because
you are in RMII mode.

How does turning off the auto polling feature help circumvent the
Atheros PHY reporting "issue"? Do we even know that is the problem, or
is it simply a guess on your part based on something that looked strange?

> - None of the Ethernet ports on the Zyxel P-2812HNU-F1 (two are
>   connected to the internal PHY11G GPHYs while the other three are
>   external RGMII PHYs) are working. Neither RX nor TX traffic was
>   observed. It is not clear which part of the PHY auto polling state-
>   machine caused this.

Great.

> - FritzBox 7412 (only one LAN port which is connected to one of the
>   internal GPHYs running in PHY22F / Fast Ethernet mode) was seeing
>   random disconnects (link down events could be seen). Sometimes all
>   traffic would stop after such disconnect. It is not clear which part
>   of the PHY auto polling state-machine cauased this.
> - TP-Link TD-W9980 (two ports are connected to the internal GPHYs
>   running in PHY11G / Gbit/s mode, the other two are external RGMII
>   PHYs) was affected by similar issues as the FritzBox 7412 just without
>   the "link down" events
> 
> Switch to software based configuration instead of PHY auto polling (and
> letting the GSWIP hardware configure the ports automatically) for the
> following link parameters:
> - link up/down
> - link speed
> - full/half duplex
> - flow control (RX / TX pause)

What does the auto polling feature consist of, exactly? Is there some
sort of microcontroller accessing the MDIO bus simultaneously with
Linux?

> After a big round of manual testing by various people (who helped test
> this on OpenWrt) it turns out that this fixes all reported issues.
> 
> Additionally it can be considered more future proof because any
> "quirk" which is implemented for a PHY on the driver side can now be
> used with the GSWIP hardware as well because Linux is in control of the
> link parameters.
> 
> As a nice side-effect this also solves a problem where fixed-links were
> not supported previously because we were relying on the PHY auto polling
> mechanism, which cannot work for fixed-links as there's no PHY from
> where it can read the registers. Configuring the link settings on the
> GSWIP ports means that we now use the settings from device-tree also for
> ports with fixed-links.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Fixes: 3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock")
> Cc: stable@vger.kernel.org
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
