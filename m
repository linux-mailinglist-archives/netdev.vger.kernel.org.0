Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B3562643F
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiKKWOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiKKWOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:14:31 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C34B997
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:14:29 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q71so5407384pgq.8
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 14:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i6sG4bA6GTNM79T1f4Ju0qs+MKQYNmlNc48Vwf5ZGew=;
        b=e4+YP7bD8QJT06JlS/Dp1MaObAAjF/sBO+Foc0UCO1XWHI1rzIOg0np/0/N3/pv3ki
         XB2LUGzi7iUCZRuTAU9ZWUjyD0zy1f8gT8OY5newa4APU+3wi5wHDkG4uRkbXJHS1a8q
         e531JDBzpUJQ3iqWTpsSI33alRQSisfZuCAUDRTNT8MQRk/6bTXPMleuxxZGqgnVEDJX
         UOew21F/xKFb+wkISWtSqOh+mKItcT9yYbdYNs/U89rwiQ2aHycDvXNqP3frhSc07DFP
         ySrZfE7RrWj+k23HCKTY/Hf/i4SndvgSHW9/vOYu1sCbFhHRTcxeqShni1N/GOM1vlj9
         tW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6sG4bA6GTNM79T1f4Ju0qs+MKQYNmlNc48Vwf5ZGew=;
        b=X7WSiDBra3VwBMs+q4eMjiThKbtz4mo6BD6DfpZ04BnsmfhdvtsyArOYiMa4jWyagH
         Mj9KT+t4juBd+PeFonr3/tOndvXvR/xxU9kUCmKHBUinQukyl4AAfj9zRIlP/abvOtOy
         BQaKW/+msv7WZ5HeI+qXhq73gvcJUVs6iZ/z18o76g2zLc60eu6lzRG4VWY/KYPisOPl
         qwf1qBUfLJ7sJCh6jvqKAwGsb6BrcLybgzhzSVolFjcrmcDUxrdgzD9alS1mWTMiU550
         aYbK67CbOjGf8Bm4oBY6/SBozauL5ntA+JvjRoOXGpZjH2lutHrZyrr4HzQQWJezdcEe
         EpLg==
X-Gm-Message-State: ANoB5pm1rhqHQaO1adY8CP69J+E9onf7cL0k1hr0OI7lMRKj9mXbPvzx
        CDJogLxyf4lWTJUZL5DI9rIEZfyAl6PvYOasQSxIfKJNc49h5Q==
X-Google-Smtp-Source: AA0mqf4Ob6z0hObQzb9l2MAGisx8sX2vgAfHHrBNFK3/sgxU3uUP+fTBRRQcM3WUWw2zFJfb8QTtYXI5fCGQ3LSmzqA=
X-Received: by 2002:a05:6a02:30a:b0:46f:6f55:dd44 with SMTP id
 bn10-20020a056a02030a00b0046f6f55dd44mr3455098pgb.252.1668204869206; Fri, 11
 Nov 2022 14:14:29 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com> <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com> <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
In-Reply-To: <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 11 Nov 2022 14:14:16 -0800
Message-ID: <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
Subject: Re: status of rate adaptation
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 1:54 PM Sean Anderson <sean.anderson@seco.com> wrote:
>
> On 11/11/22 16:20, Tim Harvey wrote:
> > On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
> >>
> >> On 11/11/22 15:57, Sean Anderson wrote:
> >> > Hi Tim,
> >> >
> >> > On 11/11/22 15:44, Tim Harvey wrote:
> >> >> Greetings,
> >> >>
> >> >> I've noticed some recent commits that appear to add rate adaptation support:
> >> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
> >> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
> >> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
> >> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
> >> >> 0c3e10cb4423 net: phy: Add support for rate matching
> >> >>
> >> >> I have a board with an AQR113C PHY over XFI that functions properly at
> >> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
> >> >>
> >> >> Should I expect this to work now at those lower rates
> >> >
> >> > Yes.
> >
> > Sean,
> >
> > Good to hear - thank you for your work on this feature!
> >
> >> >
> >> >> and if so what kind of debug information or testing can I provide?
> >> >
> >> > Please send
> >> >
> >> > - Your test procedure (how do you select 1G?)
> >> > - Device tree node for the interface
> >> > - Output of ethtool (on both ends if possible).
> >> > - Kernel logs with debug enabled for drivers/phylink.c
> >>
> >> Sorry, this should be drivers/net/phy/phylink.c
> >>
> >> >
> >> > That should be enough to get us started.
> >> >
> >> > --Sean
> >>
> >
> > I'm currently testing by bringing up the network interface while
> > connected to a 10gbe switch, verifying link and traffic, then forcing
> > the switch port to 1000mbps.
> >
> > The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
> >
> > #include "cn9130.dtsi" /* include SoC device tree */
> >
> > &cp0_xmdio {
> >         pinctrl-names = "default";
> >         pinctrl-0 = <&cp0_xsmi_pins>;
> >         status = "okay";
> >
> >         phy1: ethernet-phy@8 {
> >                 compatible = "ethernet-phy-ieee802.3-c45";
> >                 reg = <8>;
> >         };
> > };
> >
> > &cp0_ethernet {
> >         status = "okay";
> > };
> >
> > /* 10GbE XFI AQR113C */
> > &cp0_eth0 {
> >         status = "okay";
> >         phy = <&phy1>;
> >         phy-mode = "10gbase-r";
> >         phys = <&cp0_comphy4 0>;
> > };
> >
> > Here are some logs with debug enabled in drivers/net/phy/phylink.c and
> > some additional debug in mvpp2.c and aquantia_main.c:
> > # ifconfig eth0 192.168.1.22
> > [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
> > speed=-1 26:10gbase-r
> > [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
> > [    8.898165] aqr107_resume
> > [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
> > duplex=255 speed=-1 26:10gbase-r 0:
> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
> > supported 00000000,00018000,000e706f advertising
> > 00000000,00018000,000e706f
> > [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
> > [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
> > phy/10gbase-r link mode
> > [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
> > [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> > mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
> > pause=00 link=0 an=0
> > [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
> > [    8.976267] aqr107_resume
> > [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
> > 10gbase-r/10Gbps/Full/none/off
> > [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
> > duplex=1 speed=10000 26:10gbase-r
> > [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
> > [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> > - flow control off
> > [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
> > 10gbase-r/10Gbps/Full/none/off
> > [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
> > duplex=1 speed=10000 26:10gbase-r
> >
> > # ethtool eth0
> > Settings for eth0:
> >         Supported ports: [ ]
> >         Supported link modes:   10baseT/Half 10baseT/Full
> >                                 100baseT/Half 100baseT/Full
>
> 10/100 half duplex aren't achievable with rate matching (and we avoid
> turning them on), so they must be coming from somewhere else. I wonder
> if this is because PHY_INTERFACE_MODE_SGMII is set in
> supported_interfaces.
>
> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
> should support it. I'm not sure if the aquantia driver is set up for it.

This appears to trigger an issue from mvpp2:
mvpp2 f2000000.ethernet eth0: validation of usxgmii with support
00000000,00018000,000e706f and advertisement
00000000,00018000,000e706f failed: -EINVAL

>
> >                                 1000baseT/Full
> >                                 10000baseT/Full
> >                                 1000baseKX/Full
> >                                 10000baseKX4/Full
> >                                 10000baseKR/Full
> >                                 2500baseT/Full
> >                                 5000baseT/Full
> >         Supported pause frame use: Symmetric Receive-only
> >         Supports auto-negotiation: Yes
> >         Supported FEC modes: Not reported
> >         Advertised link modes:  10baseT/Half 10baseT/Full
> >                                 100baseT/Half 100baseT/Full
> >                                 1000baseT/Full
> >                                 10000baseT/Full
> >                                 1000baseKX/Full
> >                                 10000baseKX4/Full
> >                                 10000baseKR/Full
> >                                 2500baseT/Full
> >                                 5000baseT/Full
> >         Advertised pause frame use: Symmetric Receive-only
> >         Advertised auto-negotiation: Yes
> >         Advertised FEC modes: Not reported
> >         Link partner advertised link modes:  100baseT/Half 100baseT/Full
> >                                              1000baseT/Half 1000baseT/Full
> >                                              10000baseT/Full
> >                                              2500baseT/Full
> >                                              5000baseT/Full
> >         Link partner advertised pause frame use: No
> >         Link partner advertised auto-negotiation: Yes
> >         Link partner advertised FEC modes: Not reported
> >         Speed: 10000Mb/s
> >         Duplex: Full
> >         Port: Twisted Pair
> >         PHYAD: 8
> >         Transceiver: external
> >         Auto-negotiation: on
> >         MDI-X: Unknown
> >         Link detected: yes
> > # ping 192.168.1.146 -c5
> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
> > 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
> > 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
> > 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
> > 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
> > 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
> >
> > --- 192.168.1.146 ping statistics ---
> > 5 packets transmitted, 5 packets received, 0% packet loss
> > round-trip min/avg/max = 0.267/0.416/0.991 ms
> > # # force switch port to 1G
> > [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
> > 10gbase-r/Unknown/Unknown/none/off
> > [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
> > [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
> > [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
> > duplex=255 speed=-1 26:10gbase-r
> > [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
>
> Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
> the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
> send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
> and the vendor provisioning registers (dev 4, reg 0xc440 through
> 0xc449).

yes, this is what I've been looking at as well. When forced to 1000m
the register shows a phy type of 11 which according to the aqr113
datasheet is XFI 5G:
aqr107_read_status STATUS=0x00001258 (type=11) state=4:running an=1
link=1 duplex=1 speed=1000 interface=0

>
> It's possible that your firmware doesn't support rate adaptation... I'm
> not sure what we can do about that.
>

I will enquire with my Aquantia FAE to see what they say about rate
adaptation support

Something interesting is that when I configured the xmdio node with an
interrupt I ended up in a mode where 5g,2.5g and 1g all worked for at
least 1 test. There was something wrong with my interrupt
configuration (i'm not clear if the AQR113C's interrupt should be
IRQ_TYPE_LEVEL_LOW, IRQ_TYPE_EDGE_FALLING or something different).

While I can't reliably reproduce this and I believe I was on the 6.0
kernel at the time without the rate adaptation support a debug log
when I was in this mode shows the following:
[   27.700221] aqr107_config_init state=1 an=1 link=0 duplex=255
speed=-1 26:10gbase-r
[   27.709694] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
[   27.716457] aqr107_resume
[   27.723551] aqr107_get_rate_matching state=1 an=1 link=0 duplex=255
speed=-1 26:10gbase-r 0:
[   27.733075] mvpp2 f2000000.ethernet eth0: PHY
[f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=40)
[   27.752939] mvpp2 f2000000.ethernet eth0: configuring for
phy/10gbase-r link mode
[   27.760508] aqr107_resume
[   27.769781] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
speed=10000 26:10gbase-r
[   32.670293] aqr107_read_status state=5 an=1 link=1 duplex=1 speed=10000 0:
[   32.678642] aqr107_read_rate state=5 an=1 link=1 duplex=1 speed=10000 0:
[   32.686405] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
speed=10000 0:
[   32.686628] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
- flow control off
[   32.702981] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
^^^ 10gbe link; ping ok
# force port to 1Gbe
[  945.918132] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
speed=10000 26:10gbase-r
[  945.918193] mvpp2_port_isr 10gbase-r
[  945.919186] mvpp2_port_disable 10gbase-r
[  945.935304] mvpp2 f2000000.ethernet eth0: Link is Down
 [  949.509595] aqr107_read_status state=5 an=1 link=1 duplex=1
speed=1000 26:10gbase-r
[  949.518562] aqr107_read_rate state=5 an=1 link=1 duplex=1
speed=1000 26:10gbase-r
[  949.527112] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
speed=1000 26:10gbase-r
[  949.527166] mvpp2_port_isr 10gbase-r
[  949.527176] mvpp2_port_enable 10gbase-r
[  949.527306] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -
flow control off
^^^ 1gbe link; ping ok
# force port to 2.5Gbe
[ 1024.518112] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
speed=1000 26:10gbase-r
[ 1024.518187] mvpp2_port_isr 10gbase-r
[ 1024.532897] mvpp2_port_disable 10gbase-r
[ 1024.536880] mvpp2 f2000000.ethernet eth0: Link is Down
[ 1029.295136] aqr107_read_status state=5 an=1 link=1 duplex=1
speed=2500 26:10gbase-r
[ 1029.304070] aqr107_read_rate state=5 an=1 link=1 duplex=1
speed=2500 26:10gbase-r
[ 1029.312611] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
speed=2500 26:10gbase-r
[ 1029.312638] mvpp2_port_isr 10gbase-r
[ 1029.325584] mvpp2_port_enable 10gbase-r
[ 1029.329564] mvpp2 f2000000.ethernet eth0: Link is Up - 2.5Gbps/Full
- flow control off
^^^ 2.5gbe link; ping ok
# force port to 5gbe
[ 1060.401209] aqr107_link_change_notify state=5 an=1 link=0 duplex=1
speed=2500 26:10gbase-r
[ 1060.401272] mvpp2_port_isr 10gbase-r
[ 1060.402274] mvpp2_port_disable 10gbase-r
[ 1060.419006] mvpp2 f2000000.ethernet eth0: Link is Down
[ 1065.167937] aqr107_read_status state=5 an=1 link=1 duplex=1
speed=5000 26:10gbase-r
[ 1065.176865] aqr107_read_rate state=5 an=1 link=1 duplex=1
speed=5000 26:10gbase-r
[ 1065.185415] aqr107_link_change_notify state=4 an=1 link=1 duplex=1
speed=5000 26:10gbase-r
[ 1065.185456] mvpp2_port_isr 10gbase-r
[ 1065.185474] mvpp2_port_enable 10gbase-r
[ 1065.185597] mvpp2 f2000000.ethernet eth0: Link is Up - 5Gbps/Full -
flow control off
^^^ 5gpbe link; ping ok

Thanks,

Tim

> --Sean
>
> > [  197.472504] mvpp2 f2000000.ethernet eth0: major config
> > [  197.472614] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> > mode=phy//1Gbps/Full/pause adv=00000000,00000000,00000000 pause=00
> > link=1 an=0
> > [  197.479561] aqr107_link_change_notify state=4:running an=1 link=1
> > duplex=1 speed=1000 0:
> > [  197.484972] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -
> > flow control off
> > # ethtool eth0
> > Settings for eth0:
> >         Supported ports: [ ]
> >         Supported link modes:   10baseT/Half 10baseT/Full
> >                                 100baseT/Half 100baseT/Full
> >                                 1000baseT/Full
> >                                 10000baseT/Full
> >                                 1000baseKX/Full
> >                                 10000baseKX4/Full
> >                                 10000baseKR/Full
> >                                 2500baseT/Full
> >                                 5000baseT/Full
> >         Supported pause frame use: Symmetric Receive-only
> >         Supports auto-negotiation: Yes
> >         Supported FEC modes: Not reported
> >         Advertised link modes:  10baseT/Half 10baseT/Full
> >                                 100baseT/Half 100baseT/Full
> >                                 1000baseT/Full
> >                                 10000baseT/Full
> >                                 1000baseKX/Full
> >                                 10000baseKX4/Full
> >                                 10000baseKR/Full
> >                                 2500baseT/Full
> >                                 5000baseT/Full
> >         Advertised pause frame use: Symmetric Receive-only
> >         Advertised auto-negotiation: Yes
> >         Advertised FEC modes: Not reported
> >         Link partner advertised link modes:  1000baseT/Half 1000baseT/Full
> >         Link partner advertised pause frame use: No
> >         Link partner advertised auto-negotiation: Yes
> >         Link partner advertised FEC modes: Not reported
> >         Speed: 1000Mb/s
> >         Duplex: Full
> >         Port: Twisted Pair
> >         PHYAD: 8
> >         Transceiver: external
> >         Auto-negotiation: on
> >         MDI-X: Unknown
> >         Link detected: yes
> > # ping 192.168.1.146 -c5
> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
> >
> > --- 192.168.1.146 ping statistics ---
> > 5 packets transmitted, 0 packets received, 100% packet loss
> >
> > Best Regards,
> >
> > Tim
