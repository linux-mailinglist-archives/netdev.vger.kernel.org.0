Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC4350672
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhCaSfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbhCaSfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:35:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB06C061574;
        Wed, 31 Mar 2021 11:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0vZ+YaBhujkG/DFgqzNwjOQqJ1o921OtGFpttV4YyFA=; b=jklEy7gQzb5vBp/1CFBQ5AVcq
        /oFYyKdRqN9Rl+OvtwuysRz00/kEMHBShFHUsGGdF6cv5bavqD8FBjFZbBUgo5WUM6UCu/SPhIA1p
        SGUzcjKnGFwjwGzSb/iamfyr3bWWB52b9QrHpaqfCSMxyR90aJcCub2HVf3gI0EtA8QIV1aKywy0+
        JTcnlbLL/gqf+aVyfidB7rrJ6p12jy0v4bSxF3rUcgv36NJtY6UacgW1H5Cn3eVETp/fKPFZlG/I3
        fcdShUHEjsWtCUnPJDMZYhnugIFpVpjc1u0x+SakX9nc191u2htTCF8rsAC77XHu/jBGO4PsDVzhJ
        yoy/TpGIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51982)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lRfgc-0002AN-Hp; Wed, 31 Mar 2021 19:35:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lRfga-000489-Ja; Wed, 31 Mar 2021 19:35:24 +0100
Date:   Wed, 31 Mar 2021 19:35:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     danilokrummrich@dk-develop.de
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <20210331183524.GV1463@shell.armlinux.org.uk>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 07:58:33PM +0200, danilokrummrich@dk-develop.de wrote:
> For this cited change the only thing happening is that if get_phy_device()
> already failed for probing with is_c45==false (C22 devices) it tries to
> probe with is_c45==true (C45 devices) which then either results into actual
> C45 frame transfers or indirect accesses by calling mdiobus_c45_*() functions.

Please explain why and how a PHY may not appear to be present using
C22 frames to read the ID registers, but does appear to be present
when using C22 frames to the C45 indirect registers - and summarise
which PHYs have this behaviour.

It seems very odd that any PHY would only implement C45 indirect
registers in the C22 register space.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
