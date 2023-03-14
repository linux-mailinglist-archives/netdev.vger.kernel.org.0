Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BC26B8E42
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCNJMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCNJMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:12:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEC762D85;
        Tue, 14 Mar 2023 02:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=872ImSCZ3X8e4qu5m2YVUu1socM3dn7WUGYc6th1yyE=; b=oZCUQ6RZqX5bITahefVtYNcr9g
        pBvHbwrbB93xvLWVpfEBQ/9/ATKvE+9ZzWGCLaq+R3csBz7L6IzaSKCPKqWlZI27R6dNZnA1OajzT
        92FKFrUmfnkSPNsDbDyIMkg4/FGu4G0mWsMjf9VSJndeAnSRc1emweBpAE5My21NrNhP9qKo+nGyX
        c2iumqGRHGIq0rlzEjBDK9wYSP5cTezwITtU7bsTWlj/Fl/TbKncSY0c1PNxjhhfBenmp9kx4m9rl
        jb70mzceeP10ur8rXUMjlUTM6uRdai7RNURcIOSRwwAww/np9dkJg7LS+xGll9TvCpdXGhc8JxXTb
        MdTTh5qw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34654)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pc0hy-0004kr-V5; Tue, 14 Mar 2023 09:12:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pc0hu-0000D2-D9; Tue, 14 Mar 2023 09:12:34 +0000
Date:   Tue, 14 Mar 2023 09:12:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Re: Re: Re: Re: [PATCH net-next v12 08/18] net: ethernet:
 mtk_eth_soc: fix 1000Base-X and 2500Base-X modes
Message-ID: <ZBA6gszARdJY26Mz@shell.armlinux.org.uk>
References: <trinity-79e9f0b8-a267-4bf9-a3d4-1ec691eb5238-1678536337569@3c-app-gmx-bs24>
 <ZAzd1A0SAKZK0hF5@shell.armlinux.org.uk>
 <4B891976-C29E-4D98-B604-3AC4507D3661@public-files.de>
 <ZAzk71mTxgV/pRxC@shell.armlinux.org.uk>
 <trinity-8577978d-1c11-4f6d-ae11-aef37e8b78b0-1678624836722@3c-app-gmx-bap51>
 <ZA4wlQ8P48aDhDly@shell.armlinux.org.uk>
 <ZA8B/kI0fLx4gkQm@shell.armlinux.org.uk>
 <trinity-93681801-f99c-40e2-9fbd-45888b3069aa-1678732740564@3c-app-gmx-bs66>
 <ZA+qTyQ3n6YiURkQ@shell.armlinux.org.uk>
 <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-e2c457f1-c897-45f1-907a-8ea3664b7512-1678783872771@3c-app-gmx-bap66>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:51:12AM +0100, Frank Wunderlich wrote:
> Hi,
> 
> at least the error-message is gone, and interface gets up when i call ethtoo to switch off autoneg.
> 
> root@bpi-r3:~# dmesg | grep -i 'sfp\|eth1'
> [    1.991838] sfp sfp-1: module OEM              SFP-2.5G-T       rev 1.0  sn SK2301110008     dc 230110  
> [    2.001352] mtk_soc_eth 15100000.ethernet eth1: optical SFP: interfaces=[mac=2-4,21-22, sfp=22]
> [    2.010059] mtk_soc_eth 15100000.ethernet eth1: optical SFP: chosen 2500base-x interface
> [    2.018145] mtk_soc_eth 15100000.ethernet eth1: requesting link mode inband/2500base-x with support 00,00000000,00000000,0000e400
> [   34.385814] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/2500base-x link mode
> [   34.394259] mtk_soc_eth 15100000.ethernet eth1: major config 2500base-x
> [   34.400860] mtk_soc_eth 15100000.ethernet eth1: phylink_mac_config: mode=inband/2500base-x/Unknown/Unknown/none adv=00,00000000,00000000,0000e400 pause=04 link=0 an=1

Looking good - apart from that pesky an=1 (which isn't used by the PCS
driver, and I've been thinking of killing it off anyway.) Until such
time that happens, we really ought to set that correctly, which means
an extra bit is needed in phylink_sfp_set_config(). However, this
should not affect anything.

> root@bpi-r3:~# 
> root@bpi-r3:~# ethtool -s eth1 autoneg off
> root@bpi-r3:~# [  131.031902] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 2.5Gbps/Full - flow control off
> [  131.040366] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> 
> full log here:
> https://pastebin.com/yDC7PuM2
> 
> i see that an is still 1..maybe because of the fixed value here?
> 
> https://elixir.bootlin.com/linux/v6.3-rc1/source/drivers/net/phy/phylink.c#L3038

Not sure what that line has to do with it - this is what the above
points to:

        phylink_sfp_set_config(pl, MLO_AN_INBAND, pl->sfp_support, &config);

Anyway, the important thing is the Autoneg bit in the advertising mask
is now zero, which is what we want. That should set the PCS to disable
negotiation when in 2500baseX mode, the same as ethtool -s eth1 autoneg
off.

So I think the question becomes - what was the state that ethtool was
reporting before asking ethtool to set autoneg off, and why does that
make a difference.

> and yes, module seems to do rate adaption (it is labeled with 100M/1G/2.5G), i tried it on a 1G-Port and link came up (with workaround patch from daniel),
> traffic "works" but in tx-direction with massive retransmitts (i guess because pause-frames are ignored - pause was 00).

We'll see about addressing that later once we've got the module working
at 2.5G. However, thanks for the information.

The patch below should result in ethtool reporting 2500baseT rather than
2500baseX, and that an=1 should now be an=0. Please try it, and dump the
ethtool eth1 before asking for autoneg to be manually disabled, and also
report the kernel messages.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
