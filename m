Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15D56B9769
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjCNOL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjCNOLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:11:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3862D77C87;
        Tue, 14 Mar 2023 07:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k1DEtHIhLxRnbG8lB4HWAB8Y4xPQZEX9Zid75ZjCTvk=; b=jpgpNy9fMP5h6PmZdKe/nnjsq0
        IkWVUgi0+aJ/1NUjaaXKN2XuBV9+7Vs+s4INIgb1twXhPzG1sbM92I3hbywBel/zjbffM16qbhWsm
        TsItyC5HwqtFhv2zyC2dzombosQ9YZsaGH528S6x4PRvAT0ywKiOIfEixy95orB4iFsdHTFcTjJfT
        z3sdKOC1euDOhf2uP9WwirTwMcqTbrqbxOgN3MstLse26dIszHjCPeS/N7QmQTo4I2mqJIHGvPOLO
        Nf/682DepH6jjWMPFFJuznI9I1Wx7Zo4vu0t4CowSuN10HwSgbDadC39GqQOi8PTusieTvqx/tCYW
        yLrkcxmA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55970)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pc5Mv-0005Cq-4c; Tue, 14 Mar 2023 14:11:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pc5Mr-0000QN-SX; Tue, 14 Mar 2023 14:11:10 +0000
Date:   Tue, 14 Mar 2023 14:11:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <ZBCAfUK+YkRq3wfK@shell.armlinux.org.uk>
References: <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
 <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
 <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
 <ZBA6gszARdJY26Mz@shell.armlinux.org.uk>
 <trinity-bc4bbf4e-812a-4682-ac8c-5178320467f5-1678788102813@3c-app-gmx-bap66>
 <ZBBIDqZaqdSfwu9g@shell.armlinux.org.uk>
 <trinity-99c1353c-98c3-4608-8079-9a818909e6c4-1678802351739@3c-app-gmx-bap50>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-99c1353c-98c3-4608-8079-9a818909e6c4-1678802351739@3c-app-gmx-bap50>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:59:11PM +0100, Frank Wunderlich wrote:
> Hi
> 
> very good...do not need the manual autoneg with the last Patch :)

Great news! Thanks for your patience.

> > Gesendet: Dienstag, 14. März 2023 um 11:10 Uhr
> > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> 
> > For 802.3z modes, MLO_AN_INBAND with Autoneg clear in the advertising mode
> > disables in-band negotiation. This is exactly how "ethtool -s ethX
> > autoneg off" works.
> 
> ok, this seems now correctly set.
> 
> > > > The patch below should result in ethtool reporting 2500baseT rather than
> > > > 2500baseX, and that an=1 should now be an=0. Please try it, and dump the
> > > > ethtool eth1 before asking for autoneg to be manually disabled, and also
> > > > report the kernel messages.
> 
> root@bpi-r3:~# ip link set eth1 up
> [   91.624075] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
> [   91.632485] mtk_soc_eth 15100000.ethernet eth1: major config 2500base-x
> [   91.639094] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/Unknown/Unknown/none adv=00,00000000,00008000,00006400 pause=00 link=0 an=0
> root@bpi-r3:~# [   95.808983] mtk_soc_eth 15100000.ethernet eth1: Link is Up - Unknown/Unknown - flow control off
> [   95.817706] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
>
> root@bpi-r3:~# ethtool eth1
> Settings for eth1:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   2500baseT/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: No
>         Supported FEC modes: Not reported
>         Advertised link modes:  2500baseT/Full
>         Advertised pause frame use: Symmetric Receive-only
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: Unknown!
>         Duplex: Unknown! (255)
>         Auto-negotiation: off
>         Port: FIBRE
>         PHYAD: 0
>         Transceiver: internal
>         Current message level: 0x000000ff (255)
>                                drv probe link timer ifdown ifup rx_err tx_err
>         Link detected: yes 
> 
> root@bpi-r3:~# dmesg | grep -i 'sfp\|eth1'
> [    0.000000] Linux version 6.3.0-rc1-bpi-r3-sfp13 (frank@frank-G5) (aarch64-linux-gnu-gcc (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #2 SMP Tue Mar 143
> [    1.658048] sfp sfp-1: Host maximum power 1.0W
> [    1.663128] sfp sfp-2: Host maximum power 1.0W
> [    1.812401] mtk_soc_eth 15100000.ethernet eth1: mediatek frame engine at 0xffffffc00af80000, irq 123
> [    2.001796] sfp sfp-1: module OEM              SFP-2.5G-T       rev 1.0  sn SK2301110008     dc 230110
> [    2.011307] mtk_soc_eth 15100000.ethernet eth1: optical SFP: interfaces=[mac=2-4,21-22, sfp=22]
> [    2.020000] mtk_soc_eth 15100000.ethernet eth1: optical SFP: chosen 2500base-x interface
> [    2.028080] mtk_soc_eth 15100000.ethernet eth1: requesting link mode inband/2500base-x with support 00,00000000,00008000,00006400
> [   91.624075] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
> [   91.632485] mtk_soc_eth 15100000.ethernet eth1: major config 2500base-x
> [   91.639094] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/Unknown/Unknown/none adv=00,00000000,00008000,00006400 pause=00 link=0 an=0
> [   95.808983] mtk_soc_eth 15100000.ethernet eth1: Link is Up - Unknown/Unknown - flow control off
> [   95.817706] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> 
> so you can see the link-up comes directly after the interface up
> 
> does the ethtool-output look like expected? i see speed/duplex is set as supported/advertised but not active
> 
>         Supported link modes:   2500baseT/Full
>         Advertised link modes:  2500baseT/Full
> vs.
>         Speed: Unknown!
>         Duplex: Unknown! (255) 

Yes, and I think that's reasonable given that the PHY is inaccessible,
and therefore we have no way to know what the PHY is actually doing.

> imho ETHTOOL_LINK_MODE_2500baseT_Full_BIT sets only the supported which intersected with the advertised from the other side maximum should be taken as actual mode...so this part seems not correctly working at the moment.

... except we don't know what "the other side" is doing because we
need to read that from the PHY in the SFP.

> the "Supported ports: [ FIBRE ]" is also misleading for copper sfp, but imho all SFP are shown like this.

... unless they have a PHY we can access.

> full log if needed:
> https://pastebin.com/6yWe4Kyi
> 
> next step:
> is it possible to have pause for rate adaption (handling rx pause frames correctly)?

That's certainly the next issue to sort out. I'll send a patch when I've
sorted that out.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
