Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A712C222D54
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGPU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgGPU60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:58:26 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB031C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:58:25 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g20so5801724edm.4
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 13:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GWYEdg4PEOUXQ0SMrmJ5N1az4UdtMabxMEImgxfdEFg=;
        b=sKIpj/1o81yOcNUGunf9KPIhPyqE7+s1swaXJreFFEE6QX7H6fpyny7nL+PsvstBls
         atM7jEle629gBCVFNg/pV4Xv1+rVUGuc+/UlAwhtQPOPVmPXQ9WXWMm21YfmOgdc3L9t
         ZJWCVa76j5iCwzEMSRs5vfgVxAAJPXyP5TcE+0C7gP485RJg2MGT46F8FMoilD7GQO2z
         fswW4EKFACATK+dANPzUpf++XbMeSEWdK8Cvto0M0DC4bNbKN0jss1TVgHUoIptrHIDn
         cGJ+sgsjgwtpg2R64HN/dQPXbmMk8DWeZ4XPvE0F5g22I24CMtAkgv8FLBHaWVwVlbmN
         gdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GWYEdg4PEOUXQ0SMrmJ5N1az4UdtMabxMEImgxfdEFg=;
        b=J1Z6FkpdBMAabV+4FAPTysHnvvctYEFM/e52tU3ozpmXBkXnfI7k8ZL7jw0y7G6BMy
         gNDcnEEYkcZ2y/f16RzJIlKAkd6Tzcqsy1mL8u16APpDqLYEG3PwAxXR9uITVi4Qfjwr
         vcBAD9h21hwIF1hdKEoqgEDWLr27OjnMBvvwsf65BhzsPDVwuJhTLv0N8eeT9/01ffRf
         C1N+qNR+wN6sZkrOE5GcZwGJ6y4h1/tz5tcJaojqpbJJSfCBCDGVZm54lHbD7bRTH0zQ
         RtehbW54izpIV0WQAvnvywKSe6uzAygdfmfNPMG1+uCTPwpwYidL4PopgMvnH/ef6a7Y
         DHEg==
X-Gm-Message-State: AOAM530cKD178chxkOkgFAADK8+2XblxHlYfeRxYEVPNoapQFwDwjjQA
        Squ783bSBod0rc42QupmpKs=
X-Google-Smtp-Source: ABdhPJz75KUt8adLvpJ/LkRWs6q48K6d1LQ0hrtcA3X6VBsbna/ou7uCycArMlgi1dWiuxiKpYZ+jQ==
X-Received: by 2002:aa7:da58:: with SMTP id w24mr6285307eds.385.1594933104378;
        Thu, 16 Jul 2020 13:58:24 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id o17sm6035295ejb.105.2020.07.16.13.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:58:23 -0700 (PDT)
Date:   Thu, 16 Jul 2020 23:58:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc
Subject: Re: [PATCH net-next] net: phy: continue searching for C45 MMDs even
 if first returned ffff:ffff
Message-ID: <20200716205821.vhnq5tbxzxnkfuou@skbuf>
References: <20200712164815.1763532-1-olteanv@gmail.com>
 <20200716201210.GE1308244@lunn.ch>
 <20200716205137.goazvzvhie5s7ttl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716205137.goazvzvhie5s7ttl@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 11:51:37PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 16, 2020 at 10:12:10PM +0200, Andrew Lunn wrote:
> > > Then the rest of the code just carried on thinking "ok, MMD 1 (PMA/PMD)
> > > says that there are 31 devices in that package, each having a device id
> > > of ffff:ffff, that's perfectly fine, let's go ahead and probe this PHY
> > > device".
> > 
> > With a device ID of ffff:ffff, what PHY driver was getting loaded?
> > 
> 
> You mean ffff:fffe.

Sorry, I was wrong to correct you here. ffff:fffe was the
devices-in-package register, the phy id was ffff:ffff. Doesn't change
the rest of the answer though.

> No PHY driver. I am driving this PCS locally from within
> drivers/net/dsa/ocelot/felix_vsc9959.c. I call get_phy_device at the
> address where I know a PCS is present, for the simple reason that I like
> an extra validation that my internal MDIO reads/writes are going
> somewhere. I've had situations in the past where the PCS was working
> because the bootloader had initialized it, however the internal MDIO
> reads/writes from Linux were broken. So, the fact that get_phy_device
> can read the PHY ID correctly is giving me some assurance.
> 
> > > - MDIO_DEVS1=0x008a, MDIO_DEVS2=0x0000,
> > > - MDIO_DEVID1=0x0083, MDIO_DEVID2=0xe400
> > 
> > Now that we have valid IDs, is the same driver getting loaded? Do this
> > ID adding somewhere?
> > 
> 
> Not applicable, see above.
> 
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> >     Andrew
> 
> Thanks,
> -Vladimir
