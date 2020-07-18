Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FEA2249F8
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgGRIug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgGRIug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 04:50:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59A8C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 01:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I/RY/Qc0GVTDwCqmJDQOwitPYRLZmqiXXd8D0D6geh8=; b=CHgPEYJbrqMVWrEW62KRX9bT4
        bxnrZuozCxorAzyJaNWerSFOZ7vcBU9A+Rwf8giNTo7PPtrYuqdsSxQxnNsbENXYjDYnYcYyX8yLz
        B82AA15dVe9aFmP7jwGMGQPINg9GFXbc4Tuo+oFA9P2mNmK3QJC7x7DiPjVJa0JaPHEJFzTMrUJ9W
        r2msTRzG/682Q4t3IV8tOQuWscckQaJf3akgFriNcvAeJ9a4nt5hbF51KWGXOaocOV8kxE731KHlt
        D4jM730IYiTnJTKIDJIf+1QmUJ4iBRCqB5CNzbc7rMGtF6RHj3sfvHbsYBNckW+6esmB0i9AtXaRl
        7r01bc6Bg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40996)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwiYC-0001Ss-6U; Sat, 18 Jul 2020 09:50:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwiY8-0002nr-Pj; Sat, 18 Jul 2020 09:50:28 +0100
Date:   Sat, 18 Jul 2020 09:50:28 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200718085028.GN1551@shell.armlinux.org.uk>
References: <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk>
 <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk>
 <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk>
 <20200717194237.GE1339445@lunn.ch>
 <20200717212605.GM1551@shell.armlinux.org.uk>
 <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 02:37:41AM +0000, Martin Rowe wrote:
> On Fri, 17 Jul 2020 at 21:26, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > Both ends really need to agree, and I'd suggest cp1_eth2 needs to drop
> > the fixed-link stanza and instead use ``managed = "in-band";'' to be
> > in agreement with the configuration at the switch.
> >
> > Martin, can you modify
> > arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts to test
> > that please?
> 
> eth2 now doesn't come up

Sorry, it should have been ``managed = "in-band-status";'' rather than
just "in-band".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
