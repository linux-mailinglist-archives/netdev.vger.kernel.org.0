Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A2C3DF110
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhHCPFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbhHCPFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:05:44 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2CBC061757;
        Tue,  3 Aug 2021 08:05:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hs10so28183504ejc.0;
        Tue, 03 Aug 2021 08:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0FQ7Uc64i2oRVeUtFLzokR1HqzuLG7+aDF/yA5eX4M=;
        b=coGMZnEccQZlJTls9FK4PV3Fnmm0Y5yzVVFAB8l4/Ff2aOyAmNbTHGTJ/gm89hYw0F
         OnwP6qBbeUa4GSa25hJLoWOsFUQEjIliSbxhOtptkdG/C4ePagilGevFk0n+bFuGpuMc
         ZIRibIY/+FiQ37xc7rQuokgT16s5ouV6cltQ/Edqxdrg/QbXjNFK5jWruR89cprhSxn/
         B/mWJ06h/1Xsj1elOKjMaWHjcPSCRZP/DRCdzUZ64y4r6PueI/yGTPoiOdAUB5gLCx+4
         6FTY+xds1q5wRG5UWz71S7ho9jo/eVLuBLL+1HqYv0ilg+bXVi/YHEUO88LJhSmZmWOY
         ylUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0FQ7Uc64i2oRVeUtFLzokR1HqzuLG7+aDF/yA5eX4M=;
        b=Moo4s1UeSMTZG0MK9+WmwUn2jYzNCP/YQUQM7UUQ1aa6AUOvkycgcm7vdC+P/v6usW
         1Qk7dYPzH3tbQ2PzRNE+adzwUcjCM4ligC8NnY+Qjc0ulCwJ1yabKjqd7k08n8oE8n91
         cbB3G00jDrxOAFpeJuNaBMM+iSNpKzlt38khv9Gn/z9aSL+ANxacuhZFNfRjv+NGrOFl
         ZpIo8frBWBe/LWBD+pE5w4HsWTMc0T0NBfrcwbIu1pq6LHoUMhWKsPY5KCJGeA9eeV6r
         CICzWKX+auSSaOa8cYg5/dn/UyHYr2Rss1HpSLrPZ8i0pJwaJOre43DIs+8//qH41hQn
         wsIA==
X-Gm-Message-State: AOAM533gTi4Y5q2uPtRxdPVAOGrj6MxxLX2vH4DcwYOKAih6rCqb4qem
        GUAD/UbbsbZS37W5dUjdW5Y=
X-Google-Smtp-Source: ABdhPJxP1WfDh/SKp57yUJkwWaSPOs717d15hTVJGJ9P7zfkIDZ+IovWwaIDCd2MVfHUUsu5WL89gQ==
X-Received: by 2002:a17:906:31cf:: with SMTP id f15mr21305332ejf.272.1628003131123;
        Tue, 03 Aug 2021 08:05:31 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id n2sm8407071edi.32.2021.08.03.08.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:05:30 -0700 (PDT)
Date:   Tue, 3 Aug 2021 18:05:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210803150529.o2whe4jw6arpdm7d@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
 <20210731150416.upe5nwkwvwajhwgg@skbuf>
 <YQXJHA+z+hXjxe6+@lunn.ch>
 <20210802213353.qu5j3gn4753xlj43@skbuf>
 <YQlWAHSTQ4K3/zet@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQlWAHSTQ4K3/zet@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 04:43:12PM +0200, Andrew Lunn wrote:
> There are good reasons to use an explicit phy-handle, and i would
> never block such code. However, implicit is historically how it was
> done. There are many DT blobs which assume it works. So implicit is
> not going away.
> 
> If you want to only support explicit in U-Boot, that is fine. I would
> suggest making this clear in the U-Boot documentation.

I am happy that Prasanna made it possible for OF-based descriptions of
the internal PHYs to be written for the lan937x generation. I did take a
look at the bindings that Prasanna proposed and I think they would work
with what DM_DSA can parse too. The work that Tim Harvey did was for
ksz9897, and it is slightly different: the MDIO controller node has a
compatible string of "microchip,ksz-mdio", and a parent container node
of "mdios".
https://source.denx.de/u-boot/u-boot/-/blob/master/arch/arm/dts/imx8mm-venice-gw7901.dts#L634
However, since the lan937x would probably have a different driver even
in U-Boot, 100% binding consistency between lan937x and ksz9897 is
probably not necessary, since some of that can boil down to driver
author choice too. As long as an OF based choice is available I'm
absolutely fine.
