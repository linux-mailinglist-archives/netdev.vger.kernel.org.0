Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C536832AA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjAaQaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjAaQ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:29:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8207469D
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sFXuLGOEebu2EysP2AEljcF9ZzhWDW6krmbWCC5a8i4=; b=v9wZP0yVoRylSSiWQodgK1STOD
        wPrA9PgFkGRcHLaa/6Lgle1kdg1ib5EMQEBRc/ek/baFp6EC2gNgh+HrlyShDjF9Xe0/wL2FeSvaD
        J7yX2VyvHaComO4Gkae82kA4lVVICrYMC8sp3ebcX21i3rW/KmcISzwrmoSCD5NjaAQkG8Nc7Elaw
        iZnt1DsSNhcg3Oo0T38lRJDT0C2UtMAKul7gD3KRcwRtoxSwOyW0E55AAh2fHo6SuzBhRx9Vp6DBt
        lJ2IYFVzmESHFrYsDhndgvyCzuF91mq9+T2tcw1uSNrmkxIbki4eSvKHpxg0pqNEBprCehRyRzT5S
        BTH+mi9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36376)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pMtVM-00068x-2C; Tue, 31 Jan 2023 16:29:07 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pMtVI-0004E6-K3; Tue, 31 Jan 2023 16:29:04 +0000
Date:   Tue, 31 Jan 2023 16:29:04 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Keller Jacob E <jacob.e.keller@intel.com>
Subject: Re: PHY firmware update method
Message-ID: <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
References: <YzQ96z73MneBIfvZ@lunn.ch>
 <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch>
 <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch>
 <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch>
 <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
 <Y9BCrtlXXGO5WOKN@lunn.ch>
 <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 05:10:08PM +0100, Michael Walle wrote:
> Am 2023-01-24 21:42, schrieb Andrew Lunn:
> > One device being slow to probe will slow down the probe of that
> > bus. But probe of other busses should be unaffected. I _guess_ it
> > might have a global affect on EPROBE_DEFER, the next cycle could be
> > delayed?  Probably a question for GregKH, or reading the code.
> > 
> > If it going to be really slow, then i would suggest making use of
> > devlink and it being a user initiated operation.
> 
> One concern which raised internally was that you'll always do
> the update (unconditionally) if there is a newer version. You seem
> to make life easier for the user, because the update just runs
> automatically. OTHO, what if a user doesn't want to update (for
> whatever reason) to the particular version in linux-firmware.git.
> I'm undecided on that.

On one hand, the user should always be asked whether they want to
upgrade the firmware on their systems, but there is the argument
about whether a user has sufficient information to make an informed
choice about it.

Then there's the problem that a newer firmware might introduce a
bug, but the user wants to use an older version (which is something
I do with some WiFi setups, and it becomes a pain when linux-firmware
is maintained by the distro, but you don't want to use that provided
version.

I really don't like the idea of the kernel automatically updating
non-volatile firmware - that sounds to me like a recipe for all
sorts of disasters.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
