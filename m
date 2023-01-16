Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1836766CF6B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 20:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjAPTP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 14:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjAPTP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 14:15:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C625D16ADA;
        Mon, 16 Jan 2023 11:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hkNFVtbzzp0XpZsfx3emQeVOO5FVZGr7hZw/Jma4LVA=; b=UupanAH6GT+TSgnVN/G70/Kw+B
        jPITqiNGkh1JrRh4mlCwzBvLRsti1vU9cmXyJwxNBF6EbMEIaedOKbOf5aXZyJDsqzmkpMfvc18bl
        8hRllSvXxKlcUQMjMA0GqDTdHEauQuSd7+Q0vPKWYL/ZAaMVaTUKwmZj5F6tMVh5UQVW5Si47khOP
        D8HQcYo1QZAI0HVfnrpxtKXyWSt48mw3gp6ZHPKDTzQvP2OwOTqL8aFQ//OfBy5osBf0GYWPClAXX
        Mtxn6D6nH3BEvK5dwzHfSQICxaXXLSBafF1KyzaFFy3Pf9AGmpBag8BDGPNkJrPhHv5ISf8I/8uIO
        unUC1hPg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36150)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pHUwp-0005k4-0o; Mon, 16 Jan 2023 19:15:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pHUwl-0006Gj-Bh; Mon, 16 Jan 2023 19:15:07 +0000
Date:   Mon, 16 Jan 2023 19:15:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Message-ID: <Y8WiO+8mkD6TPIAQ@shell.armlinux.org.uk>
References: <87bkmy33ph.fsf@miraculix.mork.no>
 <Y8Vt9vfEa4w8HXHQ@shell.armlinux.org.uk>
 <875yd630cu.fsf@miraculix.mork.no>
 <871qnu2ztz.fsf@miraculix.mork.no>
 <Y8WNxAQ6C6NyUUn1@shell.armlinux.org.uk>
 <87pmbe1hu0.fsf@miraculix.mork.no>
 <87lem21hkq.fsf@miraculix.mork.no>
 <Y8WT6GwMqwi8rBe7@shell.armlinux.org.uk>
 <87a62i1ge4.fsf@miraculix.mork.no>
 <875yd61fg3.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875yd61fg3.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 07:50:52PM +0100, Bjørn Mork wrote:
> Made things fail with 2.5G, as expected I guess. But this actually works
> with 1G!
> 
> Except for an unexpected packet drop.  But at least there are packets
> coming through at 1G now.  This is the remote end of the link:
> 
> ns-enp3s0# ethtool -s enp3s0 autoneg off speed 1000 duplex full
> ns-enp3s0# ping  192.168.0.1
> PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
> 64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.544 ms
> 64 bytes from 192.168.0.1: icmp_seq=3 ttl=64 time=0.283 ms
> 64 bytes from 192.168.0.1: icmp_seq=4 ttl=64 time=0.261 ms
> 64 bytes from 192.168.0.1: icmp_seq=5 ttl=64 time=0.295 ms
> 64 bytes from 192.168.0.1: icmp_seq=6 ttl=64 time=0.273 ms
> 64 bytes from 192.168.0.1: icmp_seq=7 ttl=64 time=0.290 ms
> 64 bytes from 192.168.0.1: icmp_seq=8 ttl=64 time=0.266 ms
> 64 bytes from 192.168.0.1: icmp_seq=9 ttl=64 time=0.269 ms
> 64 bytes from 192.168.0.1: icmp_seq=10 ttl=64 time=0.270 ms
> 64 bytes from 192.168.0.1: icmp_seq=11 ttl=64 time=0.261 ms
> 64 bytes from 192.168.0.1: icmp_seq=12 ttl=64 time=0.261 ms
> 64 bytes from 192.168.0.1: icmp_seq=13 ttl=64 time=0.266 ms
> ^C
> --- 192.168.0.1 ping statistics ---
> 13 packets transmitted, 12 received, 7.69231% packet loss, time 12282ms
> rtt min/avg/max/mdev = 0.261/0.294/0.544/0.075 ms
> ns-enp3s0# ethtool enp3s0
> Settings for enp3s0:
>         Supported ports: [ TP ]
>         Supported link modes:   100baseT/Full
>                                 1000baseT/Full
>                                 10000baseT/Full
>                                 2500baseT/Full
>                                 5000baseT/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  1000baseT/Full
>         Advertised pause frame use: Symmetric
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Auto-negotiation: off
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         MDI-X: Unknown
>         Supports Wake-on: pg
>         Wake-on: g
>         Current message level: 0x00000005 (5)
>                                drv link
>         Link detected: yes
> .
> 
> The MT7986 end looks like this:
> 
> root@OpenWrt:/# [   55.659413] mtk_pcs_get_state: bm=0x81140, adv=0x1a0
> [   55.664380] mtk_pcs_get_state: bm=0x81140, adv=0x1a0
> [   58.779924] mtk_pcs_get_state: bm=0x81140, adv=0x1a0
> [   58.784884] mtk_pcs_get_state: bm=0x81140, adv=0x1a0
> [   58.789841] mtk_sgmii_select_pcs: id=1
> [   58.793581] mtk_pcs_config: interface=4
> [   58.797399] offset:0 0x81140
> [   58.797401] offset:4 0x4d544950
> [   58.800273] offset:8 0x1a0
> [   58.803397] offset:0x20 0x31120118

This looks like it's configured for 1000base-X at this point.

> [   58.806089] forcing AN
> [   58.811826] mtk_pcs_config: rgc3=0x0, advertise=0x1 (changed), link_timer=1600000,  sgm_mode=0x103, bmcr=0x1200, use_an=1
> [   58.822759] mtk_pcs_restart_an
> [   58.825800] mtk_pcs_get_state: bm=0x81140, adv=0xda014001
> [   58.831184] mtk_pcs_get_state: bm=0x2c1140, adv=0xda014001
> [   58.836649] mtk_pcs_link_up: interface=4
> [   58.840559] offset:0 0xac1140
> [   58.840561] offset:4 0x4d544950
> [   58.843512] offset:8 0xda014001
> [   58.846636] offset:0x20 0x3112011b

and here we've reconfigured it for SGMII mode - and we can see the
Mediatek PCS has set the ACK bit (bit 14) in its advertisement
register as one would expect.

> Now, if we only could figure out what the difference is between this and
> what we configure when the mode is changed from 2500base-x to sgmii.

Maybe there is something missing which we need to do on the Mediatek
side to properly switch between 2500base-X and SGMII.

It has a feel of a problem changing the underlying link speed between
3.125 and 1.25Gbps, which is done by the ANA_RGC3 register.

Hmm, maybe the PCS needs to be powered down to change the speed, in
other words, SGMII_PHYA_PWD needs to be set before the write to the
ANA_RGC3 register?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
