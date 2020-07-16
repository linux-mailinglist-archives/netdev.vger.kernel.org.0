Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8449D222D3E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGPUvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgGPUvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:51:42 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A1FC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:51:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a1so5764993edt.10
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LqIal0XWLlJ7PxRCcOGJ7oEZ6zUa2iuaBaMwAEJjLpE=;
        b=dkAH6jmW4U3yCMoDSAbZarmnuWW02YxIKsvoF9ggMhOzCy67I05sJ+xTgHiJ+DjEms
         WKM6ZbbSTrLxVxN/ZmhGekGeMBA8tZTw4hi6ZLW2+yPT0a+ai62HiQo8OFD+CkHkgaab
         uJtiVxuqUXZgs6L7FXAINJehnTBjifyJDpRTL4y2GenQ/thr9zwEp2y3AOJJDxSiPF0n
         261EP+inEh4pAwyYZ7r+/ORy4So6Kfw5lkOVovLQrJEmWCP/bAq+RbVWZ29WLdo3gq41
         fO+OMQvdd9soUHWgxUGqik2Jb0VnMaEA5/h3AIIAqy27wVUuhNvmiyNJPiQpxCqnYUyI
         hyaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LqIal0XWLlJ7PxRCcOGJ7oEZ6zUa2iuaBaMwAEJjLpE=;
        b=XEhEXHUWXrNA6BGdS0qHlVYY7aBKt3RvNwUj3IBABPNsbtlJKNee32g9MRtk6COICB
         9Bb4Cen1Jke06dPJMwlnqW+rtS7+ycLFQ8vhHK+h3XS5jalW5R/jQm5dS1VZBMMONKQi
         rWHMvnMmYifsfqHbH1kKDjOE9vaPRhIkR40YJCkO7TBUjf7woPj92bzAbiYpeOjUchhC
         c/3XhBjp0CeJ/6+5UomamQ8NSx6jCJFXNsvLnpPg54vzTHLUDRYwzX5KHY33PS2NoxcQ
         0rg+HPxyOdHSP6chL9obB3Gb0BAwXKK9A7Y8t6EylZ+o0Opd8cSDDjUoMev7WvuSVvat
         SH9w==
X-Gm-Message-State: AOAM533DdoSyN9VC+DDQ/U4De+TCUMRtn2RDwKxxSvAcLovo0fqQcVK/
        PZAZE/9b9zlAHSoC1JJJFhk=
X-Google-Smtp-Source: ABdhPJzawIZKIVIdWhqXw0BJMWbQl2Qpy2rJQpGOTco3yKxaQULY6KB0JCX+NBrY0VPFBQfIMC01Lw==
X-Received: by 2002:a50:fb95:: with SMTP id e21mr6421126edq.245.1594932700487;
        Thu, 16 Jul 2020 13:51:40 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id da20sm6385407edb.27.2020.07.16.13.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:51:40 -0700 (PDT)
Date:   Thu, 16 Jul 2020 23:51:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc
Subject: Re: [PATCH net-next] net: phy: continue searching for C45 MMDs even
 if first returned ffff:ffff
Message-ID: <20200716205137.goazvzvhie5s7ttl@skbuf>
References: <20200712164815.1763532-1-olteanv@gmail.com>
 <20200716201210.GE1308244@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716201210.GE1308244@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 10:12:10PM +0200, Andrew Lunn wrote:
> > Then the rest of the code just carried on thinking "ok, MMD 1 (PMA/PMD)
> > says that there are 31 devices in that package, each having a device id
> > of ffff:ffff, that's perfectly fine, let's go ahead and probe this PHY
> > device".
> 
> With a device ID of ffff:ffff, what PHY driver was getting loaded?
> 

You mean ffff:fffe.
No PHY driver. I am driving this PCS locally from within
drivers/net/dsa/ocelot/felix_vsc9959.c. I call get_phy_device at the
address where I know a PCS is present, for the simple reason that I like
an extra validation that my internal MDIO reads/writes are going
somewhere. I've had situations in the past where the PCS was working
because the bootloader had initialized it, however the internal MDIO
reads/writes from Linux were broken. So, the fact that get_phy_device
can read the PHY ID correctly is giving me some assurance.

> > - MDIO_DEVS1=0x008a, MDIO_DEVS2=0x0000,
> > - MDIO_DEVID1=0x0083, MDIO_DEVID2=0xe400
> 
> Now that we have valid IDs, is the same driver getting loaded? Do this
> ID adding somewhere?
> 

Not applicable, see above.

> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew

Thanks,
-Vladimir
