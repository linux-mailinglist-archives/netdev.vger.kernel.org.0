Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B30400719
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351080AbhICUt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351052AbhICUt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:49:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E557C061575;
        Fri,  3 Sep 2021 13:48:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i6so609904edu.1;
        Fri, 03 Sep 2021 13:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jhRNr0iOROYYKruATBYmBX4u8KwXp0Az/NpG3T4a+BE=;
        b=eF1CRXdE3zFFPRPXxphywHfGqjBMnfA/tCp2Vgf5uk+45JIvOKANVPSjT2flp+FMF9
         SdOlecFev9P2ZjWqjKgykf0zKOO4VinAX7K1aQR343ui+UnADrfjlvcNX0MQDWvHBB89
         GdISAjmjD5Ru9V7CZuXOETPe+yH0WAJ7ZGMYRgSXatzCGi/O0GGsWN/+Qd73AOFIDkkV
         nrKImHVGU0SMtcd1OQ68jhD1FC7VhPy2twlqZQi5WZR7vcDGRMnW3C2lzklMH5NDfnOe
         ql6ZRErNsP+YCGN/O+sr7LrVDWI9KfRhb+wljnoDeNeQdkU3o4DfbP1ODjbvsM6JXAQi
         /KzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jhRNr0iOROYYKruATBYmBX4u8KwXp0Az/NpG3T4a+BE=;
        b=bTECW3YIn5wNQ4o/wlj+/v6QYdbHmNP6YkUPLUjZkkUCBseQnpbwRe7noCxf9DpXdL
         gfCoUrr02ekb9VLlK2ROA2aAOBZikjCH17kHQz2j/YGw85UcXQzXJLcHEgoE+xOVqFUH
         2jz2mrzB45Tv/i6MniwXx3rPYiUKv7lD0QZdHjJkejXxVaIkqKf3pDJ2rtQhu67tXEXL
         SAUpQw6SW5qbS2xkDX4VhaEAzj1/7Tl5WmjK3IdZjo+6ei4icR4I5IJU+V0Mmh5EM2wS
         pMIPXHplEcQSAjg9lvjspSR0KPYyizELPIxSzaFvcbsXTX4+Nw11c75sxzM1g2JClwH1
         8AsA==
X-Gm-Message-State: AOAM530veLIGWoPrr+JBXBojdhTFw97r0C62yHAsa72gUKeEDgYzJUnZ
        W0Xk3TNDGYPEMJMj1NHEREE=
X-Google-Smtp-Source: ABdhPJyIAPKnrFEq1VwnVKULV1n8RWA6yeCeNyAWAEKWHcyjcAhSknkRyU30iZ7Tp4FkU+FkV6cRzw==
X-Received: by 2002:aa7:d455:: with SMTP id q21mr866712edr.5.1630702104907;
        Fri, 03 Sep 2021 13:48:24 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id g9sm108214ejo.60.2021.09.03.13.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 13:48:24 -0700 (PDT)
Date:   Fri, 3 Sep 2021 23:48:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20210903204822.cachpb2uh53rilzt@skbuf>
References: <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
 <YTFX7n9qj2cUh0Ap@lunn.ch>
 <20210902232607.v7uglvpqi5hyoudq@skbuf>
 <20210903000419.GR22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903000419.GR22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 01:04:19AM +0100, Russell King (Oracle) wrote:
> Removing a lock and then running the kernel is a down right stupid
> way to test to see if a lock is necessary.
> 
> That approach is like having built a iron bridge, covered it in paint,
> then you remove most the bolts, and then test to see whether it's safe
> for vehicles to travel over it by riding your bicycle across it and
> declaring it safe.
> 
> Sorry, but if you think "remove lock, run kernel, if it works fine
> the lock is unnecessary" is a valid approach, then you've just
> disqualified yourself from discussing this topic any further.
> Locking is done by knowing the code and code analysis, not by
> playing "does the code fail if I remove it" games. I am utterly
> shocked that you think that this is a valid approach.

... and this is exactly why you will no longer get any attention from me
on this topic. Good luck.
