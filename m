Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7674263E6EF
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLABL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiLABLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:11:25 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F4089312
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 17:11:24 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id h28so416249pfq.9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 17:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h5GpMbr1ifYGmUyLpQeTyM6dmzOMIAQU0i82vdmZb1o=;
        b=xK3Y+C+zBFxpinb59m+U/sQ3pVR5hvasnD862QselClAkCWtqU9fuAg/NB8EJmfRnj
         L5dI6M/4DLxqPg8N65uqerSIMh3Cm55JS5EMdCuP847nmvXai9Is6CKav28vzbWsS+nm
         G/iUGCredX+XQM4Y5c9stcNte6pq7y5BMzoqz6MWUEsUIbdgFqdP5xXVERdsFHcffkB/
         WR4v1ec/tFvyg5mB7Y4BxDaRT7EqRuFJ7Eb9mjVE6ALIMPUw7CREJUeUAvR9hCaTHJ6q
         yRG9UeexHIVDewAMUA25BRGTta1BvF+NXIbG+AJr7CfJZ64rh91X15nhfhrdchXuXleX
         Qicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h5GpMbr1ifYGmUyLpQeTyM6dmzOMIAQU0i82vdmZb1o=;
        b=KLGmXvXwYt3/X4aCCZ6lTnLR7I4AZ/Qfv+Dimmud1JrGk5WA2d4hhpWAaHP8e4AB8T
         fV9ldYFrREGaQn+vMehcAh/ELY90fgwGyOLqr8qUjJ/wPBqGQTTIhW76Exa3D6VtrpKd
         OvHGf69Znhkprpb+04vXx+SrXw4louEER+CJwbnQ813P0Id32ShMsbMV55UMHqs0Xw93
         FgDhb99McTqe1QsS7ziADQFEIZTFzc3YE15pKh/BCSJNQc+4J0cRinvHfzLIz+T4VxRK
         Ps5pu0Yaz2ypAjH9Tq5bgb59IvAHbhVc6oh/O6sSRDxXb4297LN95tUWxuNVDu7/eLEN
         E7cw==
X-Gm-Message-State: ANoB5pmEPgoKQBKmm68yRB7Mz+x8KsjSIiJ6XF+SRanYXcZF9Ao+ugOM
        1Xc82h4aZOHSyCD1PsRQYXWkFYx6PmPH/o5gv8fBWoYhQk0=
X-Google-Smtp-Source: AA0mqf63Al0DnI5QDSx+P1JZAHWmaSPd8tr4hPfLhRQugDSXgGn64IfmaX17WzKMZRlZcEO1mK43Jifla0gw0xh+59I=
X-Received: by 2002:a63:ed46:0:b0:476:e11d:8d51 with SMTP id
 m6-20020a63ed46000000b00476e11d8d51mr41336813pgk.252.1669857083953; Wed, 30
 Nov 2022 17:11:23 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com> <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com> <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com> <CAJ+vNU1-zoug5CoN4=Ut1AL-8ykqfWKGTvJBkFPajR_Z1OCURQ@mail.gmail.com>
 <CAJ+vNU2pzk4c5yg1mfw=6m-+z1j3-0ydkvw-uMgYKJC28Dhf+g@mail.gmail.com>
 <af134bf0-d15e-2415-264b-a70766957734@seco.com> <CAJ+vNU2zJuujdU-epsm30C+VCBVNHWVs9CML7FUYni5VUTiJkw@mail.gmail.com>
 <8ba08f04-978c-6a0e-6ecb-ec88da971723@seco.com>
In-Reply-To: <8ba08f04-978c-6a0e-6ecb-ec88da971723@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Wed, 30 Nov 2022 17:11:12 -0800
Message-ID: <CAJ+vNU14oUjGW0BF19DGYXoqz+GGwOTbRjOyg1q3bR_pneP-Xw@mail.gmail.com>
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

On Mon, Nov 28, 2022 at 11:58 AM Sean Anderson <sean.anderson@seco.com> wrote:
>
> Hi Tim,
>
> On 11/17/22 18:42, Tim Harvey wrote:
> > On Thu, Nov 17, 2022 at 7:38 AM Sean Anderson <sean.anderson@seco.com> wrote:
> >>
> >> On 11/16/22 17:37, Tim Harvey wrote:
> >> > On Mon, Nov 14, 2022 at 11:33 AM Tim Harvey <tharvey@gateworks.com> wrote:
> >> >>
> >> >> On Fri, Nov 11, 2022 at 2:38 PM Sean Anderson <sean.anderson@seco.com> wrote:
> >> >> >
> >> >> > On 11/11/22 17:14, Tim Harvey wrote:
> >> >> > > On Fri, Nov 11, 2022 at 1:54 PM Sean Anderson <sean.anderson@seco.com> wrote:
> >> >> > >>
> >> >> > >> On 11/11/22 16:20, Tim Harvey wrote:
> >> >> > >> > On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
> >> >> > >> >>
> >> >> > >> >> On 11/11/22 15:57, Sean Anderson wrote:
> >> >> > >> >> > Hi Tim,
> >> >> > >> >> >
> >> >> > >> >> > On 11/11/22 15:44, Tim Harvey wrote:
> >> >> > >> >> >> Greetings,
> >> >> > >> >> >>
> >> >> > >> >> >> I've noticed some recent commits that appear to add rate adaptation support:
> >> >> > >> >> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
> >> >> > >> >> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
> >> >> > >> >> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
> >> >> > >> >> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
> >> >> > >> >> >> 0c3e10cb4423 net: phy: Add support for rate matching
> >> >> > >> >> >>
> >> >> > >> >> >> I have a board with an AQR113C PHY over XFI that functions properly at
> >> >> > >> >> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
> >> >> > >> >> >>
> >> >> > >> >> >> Should I expect this to work now at those lower rates
> >> >> > >> >> >
> >> >> > >> >> > Yes.
> >> >> > >> >
> >> >> > >> > Sean,
> >> >> > >> >
> >> >> > >> > Good to hear - thank you for your work on this feature!
> >> >> > >> >
> >> >> > >> >> >
> >> >> > >> >> >> and if so what kind of debug information or testing can I provide?
> >> >> > >> >> >
> >> >> > >> >> > Please send
> >> >> > >> >> >
> >> >> > >> >> > - Your test procedure (how do you select 1G?)
> >> >> > >> >> > - Device tree node for the interface
> >> >> > >> >> > - Output of ethtool (on both ends if possible).
> >> >> > >> >> > - Kernel logs with debug enabled for drivers/phylink.c
> >> >> > >> >>
> >> >> > >> >> Sorry, this should be drivers/net/phy/phylink.c
> >> >> > >> >>
> >> >> > >> >> >
> >> >> > >> >> > That should be enough to get us started.
> >> >> > >> >> >
> >> >> > >> >> > --Sean
> >> >> > >> >>
> >> >> > >> >
> >> >> > >> > I'm currently testing by bringing up the network interface while
> >> >> > >> > connected to a 10gbe switch, verifying link and traffic, then forcing
> >> >> > >> > the switch port to 1000mbps.
> >> >> > >> >
> >> >> > >> > The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
> >> >> > >> >
> >> >> > >> > #include "cn9130.dtsi" /* include SoC device tree */
> >> >> > >> >
> >> >> > >> > &cp0_xmdio {
> >> >> > >> >         pinctrl-names = "default";
> >> >> > >> >         pinctrl-0 = <&cp0_xsmi_pins>;
> >> >> > >> >         status = "okay";
> >> >> > >> >
> >> >> > >> >         phy1: ethernet-phy@8 {
> >> >> > >> >                 compatible = "ethernet-phy-ieee802.3-c45";
> >> >> > >> >                 reg = <8>;
> >> >> > >> >         };
> >> >> > >> > };
> >> >> > >> >
> >> >> > >> > &cp0_ethernet {
> >> >> > >> >         status = "okay";
> >> >> > >> > };
> >> >> > >> >
> >> >> > >> > /* 10GbE XFI AQR113C */
> >> >> > >> > &cp0_eth0 {
> >> >> > >> >         status = "okay";
> >> >> > >> >         phy = <&phy1>;
> >> >> > >> >         phy-mode = "10gbase-r";
> >> >> > >> >         phys = <&cp0_comphy4 0>;
> >> >> > >> > };
> >> >> > >> >
> >> >> > >> > Here are some logs with debug enabled in drivers/net/phy/phylink.c and
> >> >> > >> > some additional debug in mvpp2.c and aquantia_main.c:
> >> >> > >> > # ifconfig eth0 192.168.1.22
> >> >> > >> > [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
> >> >> > >> > speed=-1 26:10gbase-r
> >> >> > >> > [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
> >> >> > >> > [    8.898165] aqr107_resume
> >> >> > >> > [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
> >> >> > >> > duplex=255 speed=-1 26:10gbase-r 0:
> >> >> > >> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
> >> >> > >> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
> >> >> > >> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
> >> >> > >> > supported 00000000,00018000,000e706f advertising
> >> >> > >> > 00000000,00018000,000e706f
> >> >> > >> > [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
> >> >> > >> > [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
> >> >> > >> > phy/10gbase-r link mode
> >> >> > >> > [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
> >> >> > >> > [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> >> >> > >> > mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
> >> >> > >> > pause=00 link=0 an=0
> >> >> > >> > [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
> >> >> > >> > [    8.976267] aqr107_resume
> >> >> > >> > [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
> >> >> > >> > 10gbase-r/10Gbps/Full/none/off
> >> >> > >> > [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
> >> >> > >> > duplex=1 speed=10000 26:10gbase-r
> >> >> > >> > [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
> >> >> > >> > [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> >> >> > >> > - flow control off
> >> >> > >> > [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> >> >> > >> > [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
> >> >> > >> > 10gbase-r/10Gbps/Full/none/off
> >> >> > >> > [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
> >> >> > >> > duplex=1 speed=10000 26:10gbase-r
> >> >> > >> >
> >> >> > >> > # ethtool eth0
> >> >> > >> > Settings for eth0:
> >> >> > >> >         Supported ports: [ ]
> >> >> > >> >         Supported link modes:   10baseT/Half 10baseT/Full
> >> >> > >> >                                 100baseT/Half 100baseT/Full
> >> >> > >>
> >> >> > >> 10/100 half duplex aren't achievable with rate matching (and we avoid
> >> >> > >> turning them on), so they must be coming from somewhere else. I wonder
> >> >> > >> if this is because PHY_INTERFACE_MODE_SGMII is set in
> >> >> > >> supported_interfaces.
> >> >> > >>
> >> >> > >> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
> >> >> > >> should support it. I'm not sure if the aquantia driver is set up for it.
> >> >> > >
> >> >> > > This appears to trigger an issue from mvpp2:
> >> >> > > mvpp2 f2000000.ethernet eth0: validation of usxgmii with support
> >> >> > > 00000000,00018000,000e706f and advertisement
> >> >> > > 00000000,00018000,000e706f failed: -EINVAL
> >> >> >
> >> >> > Ah, I forgot this was a separate phy mode. Disregard this.
> >> >> >
> >> >> > >>
> >> >> > >> >                                 1000baseT/Full
> >> >> > >> >                                 10000baseT/Full
> >> >> > >> >                                 1000baseKX/Full
> >> >> > >> >                                 10000baseKX4/Full
> >> >> > >> >                                 10000baseKR/Full
> >> >> > >> >                                 2500baseT/Full
> >> >> > >> >                                 5000baseT/Full
> >> >> > >> >         Supported pause frame use: Symmetric Receive-only
> >> >> > >> >         Supports auto-negotiation: Yes
> >> >> > >> >         Supported FEC modes: Not reported
> >> >> > >> >         Advertised link modes:  10baseT/Half 10baseT/Full
> >> >> > >> >                                 100baseT/Half 100baseT/Full
> >> >> > >> >                                 1000baseT/Full
> >> >> > >> >                                 10000baseT/Full
> >> >> > >> >                                 1000baseKX/Full
> >> >> > >> >                                 10000baseKX4/Full
> >> >> > >> >                                 10000baseKR/Full
> >> >> > >> >                                 2500baseT/Full
> >> >> > >> >                                 5000baseT/Full
> >> >> > >> >         Advertised pause frame use: Symmetric Receive-only
> >> >> > >> >         Advertised auto-negotiation: Yes
> >> >> > >> >         Advertised FEC modes: Not reported
> >> >> > >> >         Link partner advertised link modes:  100baseT/Half 100baseT/Full
> >> >> > >> >                                              1000baseT/Half 1000baseT/Full
> >> >> > >> >                                              10000baseT/Full
> >> >> > >> >                                              2500baseT/Full
> >> >> > >> >                                              5000baseT/Full
> >> >> > >> >         Link partner advertised pause frame use: No
> >> >> > >> >         Link partner advertised auto-negotiation: Yes
> >> >> > >> >         Link partner advertised FEC modes: Not reported
> >> >> > >> >         Speed: 10000Mb/s
> >> >> > >> >         Duplex: Full
> >> >> > >> >         Port: Twisted Pair
> >> >> > >> >         PHYAD: 8
> >> >> > >> >         Transceiver: external
> >> >> > >> >         Auto-negotiation: on
> >> >> > >> >         MDI-X: Unknown
> >> >> > >> >         Link detected: yes
> >> >> > >> > # ping 192.168.1.146 -c5
> >> >> > >> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
> >> >> > >> > 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
> >> >> > >> > 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
> >> >> > >> > 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
> >> >> > >> > 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
> >> >> > >> > 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
> >> >> > >> >
> >> >> > >> > --- 192.168.1.146 ping statistics ---
> >> >> > >> > 5 packets transmitted, 5 packets received, 0% packet loss
> >> >> > >> > round-trip min/avg/max = 0.267/0.416/0.991 ms
> >> >> > >> > # # force switch port to 1G
> >> >> > >> > [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
> >> >> > >> > 10gbase-r/Unknown/Unknown/none/off
> >> >> > >> > [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
> >> >> > >> > [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
> >> >> > >> > [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
> >> >> > >> > duplex=255 speed=-1 26:10gbase-r
> >> >> > >> > [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
> >> >> > >>
> >> >> > >> Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
> >> >> > >> the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
> >> >> > >> send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
> >> >> > >> and the vendor provisioning registers (dev 4, reg 0xc440 through
> >> >> > >> 0xc449).
> >> >> > >
> >> >> > > yes, this is what I've been looking at as well. When forced to 1000m
> >> >> > > the register shows a phy type of 11 which according to the aqr113
> >> >> > > datasheet is XFI 5G:
> >> >> > > aqr107_read_status STATUS=0x00001258 (type=11) state=4:running an=1
> >> >> > > link=1 duplex=1 speed=1000 interface=0
> >> >> >
> >> >> > That's pretty strange. Seems like it's rate adapting from 5g instead of
> >> >> > 10g. Is SERDES Mode in the Global System Configuration For 1G register
> >> >> > set to XFI?
> >> >>
> >> >> 1E.31C=0x0106:
> >> >>   Rate Adaptation Method: 2=Pause Rate Adaptation
> >> >>   SERDES Mode: 6=XFI/2 (XFI 5G)
> >> >>
> >> >
> >> > The SERDES mode here is not valid and it seems to always be set to
> >> > XFI/2 unless I init/use the AQR113 in U-Boot. If I manually set SERDES
> >> > Mode to 0 (XFI) in the driver I find that all rates
> >> > 10g,5g,2.5g,1g,100m work fine both in Linux 6.0 and in Linux 6.1-rc5.
> >> > I'm still trying to understand why I would need to set SERDES Mode
> >> > manually (vs the XFI mode specific firmware setting this) but I am
> >> > unclear what the rate adaptation in 6.1 provides in this case. Is it
> >> > that perhaps the AQR113 is handling rate adaptation internally and
> >> > that's why the non 10gbe rates are working on 6.0?
> >>
> >> The changes in 6.1 are
> >>
> >> - We now always enable pause frame reception when doing rate adaptation.
> >>   This is necessary for rate adaptation to work, but wasn't done
> >>   automatically before.
> >> - We advertise lower speed modes which are enabled with rate adaptation,
> >>   even if we would not otherwise be able to support them.
> >>
> >> I'm not sure why you'd have XFI/2 selected in 6.1 if it isn't selected
> >> in 6.0.
> >
> > Sean,
> >
> > Thanks for the explanation. The issue I had which resulted in the
> > wrong SERDES mode was simply that I was using the wrong aquantia
> > firmware. They customize the firmware to default registers like SERDES
> > mode specifically for customers and I was unknowingly using the
> > firmware for XFI/2 instead of XFI.
> >
> > I suppose it would be worth putting something in the aquantia driver
> > that verifies SERDES mode matches the phy-mode from dt to throw an
> > error.
> >
> > Best Regards,
> >
> > Tim
>
> Can you test the following series to see if it fixes your problem:
>
> https://lore.kernel.org/netdev/20221128195409.100873-1-sean.anderson@seco.com/
>
> --Sean

Sean,

I believe the discussion is still ongoing regarding this being the
correct approach but that series does in fact resolve the issue I had
where my firmware was provisioned for something not compatible with
the SERDES link I needed.

Best Regards,

Tim
