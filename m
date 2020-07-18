Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC0B224A90
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgGRKNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgGRKNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 06:13:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E3EC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 03:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bk98XQb9/fe0ROMPSd2CvdtylhQmkJ0bV/NDgJ1V1tM=; b=qzbCzKsPHd5RpJj51GYfXhYFi
        RKtYOkwo4EaY8G1BiR9wGLp+G73yoMW7fEr+SBCIdmfJ6RxF+54jgEbRM1YrBjyXKDDXsZMki2nIV
        DlCGRf/bsVM/my0NNEXHiufwh7LyYvse2Zak9+fUvl6EZsCE6YwKy87mmIVO6wM0Mwy7KNwVlBYZw
        40T50Vxd8tLtNGeHgUkYKNVQhgZyHtM+dZM84YK8JGylVENKhTnYBcJ2lwdzDyfOr0vvaJuGw180S
        nQICWcPofcX48LLZaMEsmjTMSXhBQgH9dXO+LNRxcMUxLfrVaeb7qYCqDnfES4JE2g3zwmEa31Dt0
        b/BX6kaNw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41022)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwjq2-0001WR-Dx; Sat, 18 Jul 2020 11:13:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwjpz-0002rF-Te; Sat, 18 Jul 2020 11:12:59 +0100
Date:   Sat, 18 Jul 2020 11:12:59 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Martin Rowe <martin.p.rowe@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
Message-ID: <20200718101259.GO1551@shell.armlinux.org.uk>
References: <20200712132554.GS1551@shell.armlinux.org.uk>
 <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk>
 <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
 <20200717185119.GL1551@shell.armlinux.org.uk>
 <20200717194237.GE1339445@lunn.ch>
 <20200717212605.GM1551@shell.armlinux.org.uk>
 <CAOAjy5Q-OdMhSG-EKAnAgwoQzF+C6zuYD9=a9Rm4zVVVWfMf6w@mail.gmail.com>
 <20200718085028.GN1551@shell.armlinux.org.uk>
 <CAOAjy5SewXHQVnywzin-2LiqWyPcjTvG9zzaiVRtwfCG=jU1Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAjy5SewXHQVnywzin-2LiqWyPcjTvG9zzaiVRtwfCG=jU1Kw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 09:43:47AM +0000, Martin Rowe wrote:
> On Sat, 18 Jul 2020 at 08:50, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > Sorry, it should have been ``managed = "in-band-status";'' rather than
> > just "in-band".
> 
> Below are the outputs with "in-band-status". It functions the same as
> not reverting the patch; interface comes up, when bridged the two
> physical machines connected can ping each other, but nothing can tx or
> rx from the GT 8K.

Okay, on top of those changes, please also add this:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 17883e8712e0..2e361bbf3b4f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -676,6 +676,9 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_reg_lock(chip);
+	if (mode == MLO_AN_INBAND && chip->info->ops->port_set_link)
+		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
+
 	/* FIXME: should we force the link down here - but if we do, how
 	 * do we restore the link force/unforce state? The driver layering
 	 * gets in the way.
@@ -692,6 +695,9 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 	if (err > 0)
 		err = 0;
 
+	if (mode == MLO_AN_INBAND && chip->info->ops->port_set_link)
+		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
+
 err_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
