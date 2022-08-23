Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319AD59ED6C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiHWUhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiHWUhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:37:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A1C2F3A3;
        Tue, 23 Aug 2022 13:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=h7bVSo3RxduKI3NSbDP/jVbPUT5zs3AvFIl+Q7vuYRI=; b=AAw4O1N3U1N/LWtzrcU2taT9iH
        upcQUSIOhCDLN7B18tyVplfKAgk5Pjva1YvOy9XBtPBpM0rvZcJEXGT46lzRY4yIgmyK1AI7h1/0+
        vOfdPm0GgbjK6Hwu9jjNe6XyQBoQe+QhJE5Y2xgoYpft1tuuUtKD54rAJ2DeAqAL0PsNfHLA72bEO
        5Iey56kBjBNN1BPJpjN5LEkL8GTka6Z8GGA6ZEIF/MR8jUKAzT32kox6mUJzLWwhB+7ngQKDLHNgm
        mRKEwD8FpN3HNJYQYoKMBHbdv//Bwerrx1WMQly9ayzSzFfDo5XR2+j4H8PYQkqE5hZFC3JwOZwy+
        MFMvhZeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33902)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQaNR-0003Z7-9J; Tue, 23 Aug 2022 21:19:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQaNM-0003RN-DQ; Tue, 23 Aug 2022 21:19:52 +0100
Date:   Tue, 23 Aug 2022 21:19:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, Frank <Frank.Sae@motor-comm.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.4] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <YwU2aFOKaMGVLWq7@shell.armlinux.org.uk>
References: <20220817112554.383-1-Frank.Sae@motor-comm.com>
 <20220822202147.4be904de@kernel.org>
 <YwTguA0azox3j5vi@lunn.ch>
 <20220823113712.4c530516@kernel.org>
 <YwUiQgSGBhbvk7T6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwUiQgSGBhbvk7T6@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 08:53:54PM +0200, Andrew Lunn wrote:
> > > The user could of changed the pause settings, which are going to be
> > > ignored here. Also, you should not assume the MAC can actually do
> > > asymmetric pause, not all can. phydev->advertising will be set to only
> > > include what the MAC can actually do.
>  
> > Interesting. Just to confirm - regardless of the two-sided design..
> > -edness.. IIUC my question has merit and we need v5?
> 
> Yes, phydev->advertising should be take into account.

It's worth pointing out that there is a helper for this -
linkmode_adv_to_mii_adv_x().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
