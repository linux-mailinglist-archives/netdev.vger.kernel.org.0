Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE1D626378
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiKKVUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKKVUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:20:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1C25BD69
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:20:34 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y4so5192310plb.2
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1RqZHZFW1i3TNhtikjTx0ZSI4cCQRT3pa2sYxQ3IpiM=;
        b=77QQ8PKaglzXRtKs5idGky/0cE87/3W+vDR00cTRGFE+GOUm8am9ihVZxlPfaoHTb3
         lUgb07ZcHR2xylIPp+YYmn2vrfKSKxnifbLhynitn1M+TunMHp15PCXOBAwgm/KBthAM
         lfCRv0E4gNYyBCGn7Z+vPka3hkAzVxouXiy2HYRNV6u0cAb/H4d/YICgO0S2BDmiKaLc
         FwBfwcKxf93VlMmCeksDQBnlFPOTfFTzWtcW6/G5Epn2Ktf8om8JtpMfcuZ5bmryTgKJ
         zr9xpWyx7Z69vtwRF5m9t/VXEMMC/LoyQIVtktEBhdABlmUnbkLGQTpEcNPGlslBm12x
         IUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1RqZHZFW1i3TNhtikjTx0ZSI4cCQRT3pa2sYxQ3IpiM=;
        b=DG4TyAcAbz7uz3d38LkKm3Xp0ZBRs3giihpwFb+OpcPzXOAC4tpX6VmTulyeB139xO
         AzNFGomH3DoFwal+JdB+Wkd3nTdg9r87mwAanIixrFc09W+tAat5RcsYkyutMcVfUE1F
         VwtENTKk8Z/jHTIpTqeXCEeAptbo4Ovpuw6FwYTimmTLw5IVV9kaLgAu23A1JuO3tk6k
         O+BzrEwW/PSwYFCX1cY0TiOFhmrTeNAgrFON5PZnBhSogekQQpncQOB/4Ap2loFD4NYr
         icd32TSWOtyji36A1FVRVgzQCCQCNkgH+rtBuo/vvUjVJItyRcUW3YceM2rSwh6/URLf
         bt/A==
X-Gm-Message-State: ANoB5pkfnRTe8DvEA/XXM/uIn86P2ng0RM/iAPeVJq+wYKeVkKLSNiw/
        oDPPKC19xo8uefvt3oCyrYRm1YLcJkO4QvMIU7Ra6x6t3LdyOg==
X-Google-Smtp-Source: AA0mqf4YM8NrKcBDD5C3Od1RNc8gIeEDdq6CwyMJqM6HYN5KjsFzX0IXo5eOi4hyVG4sYPR76DV3tHzuFb5WhJ6wFAQ=
X-Received: by 2002:a17:902:7449:b0:186:de87:7ffd with SMTP id
 e9-20020a170902744900b00186de877ffdmr4155828plt.94.1668201634242; Fri, 11 Nov
 2022 13:20:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com> <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
In-Reply-To: <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 11 Nov 2022 13:20:21 -0800
Message-ID: <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
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

On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
>
> On 11/11/22 15:57, Sean Anderson wrote:
> > Hi Tim,
> >
> > On 11/11/22 15:44, Tim Harvey wrote:
> >> Greetings,
> >>
> >> I've noticed some recent commits that appear to add rate adaptation support:
> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
> >> 0c3e10cb4423 net: phy: Add support for rate matching
> >>
> >> I have a board with an AQR113C PHY over XFI that functions properly at
> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
> >>
> >> Should I expect this to work now at those lower rates
> >
> > Yes.

Sean,

Good to hear - thank you for your work on this feature!

> >
> >> and if so what kind of debug information or testing can I provide?
> >
> > Please send
> >
> > - Your test procedure (how do you select 1G?)
> > - Device tree node for the interface
> > - Output of ethtool (on both ends if possible).
> > - Kernel logs with debug enabled for drivers/phylink.c
>
> Sorry, this should be drivers/net/phy/phylink.c
>
> >
> > That should be enough to get us started.
> >
> > --Sean
>

I'm currently testing by bringing up the network interface while
connected to a 10gbe switch, verifying link and traffic, then forcing
the switch port to 1000mbps.

The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:

#include "cn9130.dtsi" /* include SoC device tree */

&cp0_xmdio {
        pinctrl-names = "default";
        pinctrl-0 = <&cp0_xsmi_pins>;
        status = "okay";

        phy1: ethernet-phy@8 {
                compatible = "ethernet-phy-ieee802.3-c45";
                reg = <8>;
        };
};

&cp0_ethernet {
        status = "okay";
};

/* 10GbE XFI AQR113C */
&cp0_eth0 {
        status = "okay";
        phy = <&phy1>;
        phy-mode = "10gbase-r";
        phys = <&cp0_comphy4 0>;
};

Here are some logs with debug enabled in drivers/net/phy/phylink.c and
some additional debug in mvpp2.c and aquantia_main.c:
# ifconfig eth0 192.168.1.22
[    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
speed=-1 26:10gbase-r
[    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
[    8.898165] aqr107_resume
[    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
duplex=255 speed=-1 26:10gbase-r 0:
[    8.911932] mvpp2 f2000000.ethernet eth0: PHY
[f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
[    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
supported 00000000,00018000,000e706f advertising
00000000,00018000,000e706f
[    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
[    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
phy/10gbase-r link mode
[    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
[    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
pause=00 link=0 an=0
[    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
[    8.976267] aqr107_resume
[    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
10gbase-r/10Gbps/Full/none/off
[    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
duplex=1 speed=10000 26:10gbase-r
[   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
[   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
- flow control off
[   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
10gbase-r/10Gbps/Full/none/off
[   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
duplex=1 speed=10000 26:10gbase-r

# ethtool eth0
Settings for eth0:
        Supported ports: [ ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKX4/Full
                                10000baseKR/Full
                                2500baseT/Full
                                5000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKX4/Full
                                10000baseKR/Full
                                2500baseT/Full
                                5000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  100baseT/Half 100baseT/Full
                                             1000baseT/Half 1000baseT/Full
                                             10000baseT/Full
                                             2500baseT/Full
                                             5000baseT/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 10000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 8
        Transceiver: external
        Auto-negotiation: on
        MDI-X: Unknown
        Link detected: yes
# ping 192.168.1.146 -c5
PING 192.168.1.146 (192.168.1.146): 56 data bytes
64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms

--- 192.168.1.146 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 0.267/0.416/0.991 ms
# # force switch port to 1G
[  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
10gbase-r/Unknown/Unknown/none/off
[  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
[  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
[  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
duplex=255 speed=-1 26:10gbase-r
[  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
[  197.472504] mvpp2 f2000000.ethernet eth0: major config
[  197.472614] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
mode=phy//1Gbps/Full/pause adv=00000000,00000000,00000000 pause=00
link=1 an=0
[  197.479561] aqr107_link_change_notify state=4:running an=1 link=1
duplex=1 speed=1000 0:
[  197.484972] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -
flow control off
# ethtool eth0
Settings for eth0:
        Supported ports: [ ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKX4/Full
                                10000baseKR/Full
                                2500baseT/Full
                                5000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKX4/Full
                                10000baseKR/Full
                                2500baseT/Full
                                5000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  1000baseT/Half 1000baseT/Full
        Link partner advertised pause frame use: No
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 8
        Transceiver: external
        Auto-negotiation: on
        MDI-X: Unknown
        Link detected: yes
# ping 192.168.1.146 -c5
PING 192.168.1.146 (192.168.1.146): 56 data bytes

--- 192.168.1.146 ping statistics ---
5 packets transmitted, 0 packets received, 100% packet loss

Best Regards,

Tim
