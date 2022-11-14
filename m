Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FD162896E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbiKNTeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbiKNTeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:34:06 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E77BF57
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:34:03 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n17so3478268pgh.9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sqCcwjU6jrHD7BOQ5BmFZNLAACRJ7TMsxbk7lp8LzNM=;
        b=S3T+Fs1xDzx84loabiB7BC9DuGQP6kpae2AZViOP1KJOoatADL2nEMH3a+EYHi/5WW
         KUt9ID0n6cqI4Kta9vv7zJSbv6tbwEmMjzRb/vhOGFlBhc8zWuDPud14LGea4ZGDKaWR
         mBU2uT6MQplEX8Yh8FyRJ/9evMZaIgf3Wu2N09S6AKjleoYXzUdwWBvDDPE3Ugy1tsSE
         yY1WSaaQ0n5Ms/uz03QiQsNfjamNoD9k17a3LC8t1KVsd91pUeC3ZjMWooniA43hsb4/
         8QB5Phudoz1s5fnTMkJGxAC8/BuR6MCdpJDgc+T6vcVIGJl6Qm9lS48PRfH7P6371SmE
         4SLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sqCcwjU6jrHD7BOQ5BmFZNLAACRJ7TMsxbk7lp8LzNM=;
        b=R1hDzUh3ZJnVoIbNmjwqaxuPuZboU9kOkgDRrob0hQ6CqGXX3T2FzBbQaJ7e59t4np
         Ehov9Z4Bo1NgOs6RG1b2oc5TYrOgk3P+2z/6ZB5Xw+MASQZm/IeNBNNFh17KocZnSYC+
         GCq8jyuYSpNJwt2ZZdg8bFTaOlcw6XKjKuns85wIljMmw5sZcYFzmokgEoNSoe/Nz/BC
         tBhEtVoXYKCgO/Z6joTyJXRyWbTiIew9hyt5oFDYhP8BL52+z/JchSt8G18sY6nYiuy2
         PEMb21PPZh6lRSGn3yyxPOv17wkbBWf0GYUU18jF1hhjpO58ixVZ36x7NEQTcPKCn8ij
         IQaw==
X-Gm-Message-State: ANoB5pl9q+cRKnnbM4k+kVoSc1psY24aWbkg+/Q5+05pXnm5O+8HZ+M3
        /+ifEfC43Ytk2l8Q6r4BQ8LCb0ypd63qxxXoL+mZaLjq8AyX9Q==
X-Google-Smtp-Source: AA0mqf7p2x4Y2iBlAQuSKzh6GeKwIGS9PDIkpiwjuHfHFkddlPKGyhs44kMMWyXy3FQqxfPsMPz15GTmX4U0pNOyyNA=
X-Received: by 2002:a63:1720:0:b0:46f:f93b:ddc8 with SMTP id
 x32-20020a631720000000b0046ff93bddc8mr12480308pgl.389.1668454442372; Mon, 14
 Nov 2022 11:34:02 -0800 (PST)
MIME-Version: 1.0
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com> <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com> <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
In-Reply-To: <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 14 Nov 2022 11:33:49 -0800
Message-ID: <CAJ+vNU1-zoug5CoN4=Ut1AL-8ykqfWKGTvJBkFPajR_Z1OCURQ@mail.gmail.com>
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

On Fri, Nov 11, 2022 at 2:38 PM Sean Anderson <sean.anderson@seco.com> wrote:
>
> On 11/11/22 17:14, Tim Harvey wrote:
> > On Fri, Nov 11, 2022 at 1:54 PM Sean Anderson <sean.anderson@seco.com> wrote:
> >>
> >> On 11/11/22 16:20, Tim Harvey wrote:
> >> > On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
> >> >>
> >> >> On 11/11/22 15:57, Sean Anderson wrote:
> >> >> > Hi Tim,
> >> >> >
> >> >> > On 11/11/22 15:44, Tim Harvey wrote:
> >> >> >> Greetings,
> >> >> >>
> >> >> >> I've noticed some recent commits that appear to add rate adaptation support:
> >> >> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
> >> >> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
> >> >> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
> >> >> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
> >> >> >> 0c3e10cb4423 net: phy: Add support for rate matching
> >> >> >>
> >> >> >> I have a board with an AQR113C PHY over XFI that functions properly at
> >> >> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
> >> >> >>
> >> >> >> Should I expect this to work now at those lower rates
> >> >> >
> >> >> > Yes.
> >> >
> >> > Sean,
> >> >
> >> > Good to hear - thank you for your work on this feature!
> >> >
> >> >> >
> >> >> >> and if so what kind of debug information or testing can I provide?
> >> >> >
> >> >> > Please send
> >> >> >
> >> >> > - Your test procedure (how do you select 1G?)
> >> >> > - Device tree node for the interface
> >> >> > - Output of ethtool (on both ends if possible).
> >> >> > - Kernel logs with debug enabled for drivers/phylink.c
> >> >>
> >> >> Sorry, this should be drivers/net/phy/phylink.c
> >> >>
> >> >> >
> >> >> > That should be enough to get us started.
> >> >> >
> >> >> > --Sean
> >> >>
> >> >
> >> > I'm currently testing by bringing up the network interface while
> >> > connected to a 10gbe switch, verifying link and traffic, then forcing
> >> > the switch port to 1000mbps.
> >> >
> >> > The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
> >> >
> >> > #include "cn9130.dtsi" /* include SoC device tree */
> >> >
> >> > &cp0_xmdio {
> >> >         pinctrl-names = "default";
> >> >         pinctrl-0 = <&cp0_xsmi_pins>;
> >> >         status = "okay";
> >> >
> >> >         phy1: ethernet-phy@8 {
> >> >                 compatible = "ethernet-phy-ieee802.3-c45";
> >> >                 reg = <8>;
> >> >         };
> >> > };
> >> >
> >> > &cp0_ethernet {
> >> >         status = "okay";
> >> > };
> >> >
> >> > /* 10GbE XFI AQR113C */
> >> > &cp0_eth0 {
> >> >         status = "okay";
> >> >         phy = <&phy1>;
> >> >         phy-mode = "10gbase-r";
> >> >         phys = <&cp0_comphy4 0>;
> >> > };
> >> >
> >> > Here are some logs with debug enabled in drivers/net/phy/phylink.c and
> >> > some additional debug in mvpp2.c and aquantia_main.c:
> >> > # ifconfig eth0 192.168.1.22
> >> > [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
> >> > speed=-1 26:10gbase-r
> >> > [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
> >> > [    8.898165] aqr107_resume
> >> > [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
> >> > duplex=255 speed=-1 26:10gbase-r 0:
> >> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
> >> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
> >> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
> >> > supported 00000000,00018000,000e706f advertising
> >> > 00000000,00018000,000e706f
> >> > [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
> >> > [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
> >> > phy/10gbase-r link mode
> >> > [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
> >> > [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> >> > mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
> >> > pause=00 link=0 an=0
> >> > [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
> >> > [    8.976267] aqr107_resume
> >> > [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
> >> > 10gbase-r/10Gbps/Full/none/off
> >> > [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
> >> > duplex=1 speed=10000 26:10gbase-r
> >> > [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
> >> > [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> >> > - flow control off
> >> > [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> >> > [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
> >> > 10gbase-r/10Gbps/Full/none/off
> >> > [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
> >> > duplex=1 speed=10000 26:10gbase-r
> >> >
> >> > # ethtool eth0
> >> > Settings for eth0:
> >> >         Supported ports: [ ]
> >> >         Supported link modes:   10baseT/Half 10baseT/Full
> >> >                                 100baseT/Half 100baseT/Full
> >>
> >> 10/100 half duplex aren't achievable with rate matching (and we avoid
> >> turning them on), so they must be coming from somewhere else. I wonder
> >> if this is because PHY_INTERFACE_MODE_SGMII is set in
> >> supported_interfaces.
> >>
> >> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
> >> should support it. I'm not sure if the aquantia driver is set up for it.
> >
> > This appears to trigger an issue from mvpp2:
> > mvpp2 f2000000.ethernet eth0: validation of usxgmii with support
> > 00000000,00018000,000e706f and advertisement
> > 00000000,00018000,000e706f failed: -EINVAL
>
> Ah, I forgot this was a separate phy mode. Disregard this.
>
> >>
> >> >                                 1000baseT/Full
> >> >                                 10000baseT/Full
> >> >                                 1000baseKX/Full
> >> >                                 10000baseKX4/Full
> >> >                                 10000baseKR/Full
> >> >                                 2500baseT/Full
> >> >                                 5000baseT/Full
> >> >         Supported pause frame use: Symmetric Receive-only
> >> >         Supports auto-negotiation: Yes
> >> >         Supported FEC modes: Not reported
> >> >         Advertised link modes:  10baseT/Half 10baseT/Full
> >> >                                 100baseT/Half 100baseT/Full
> >> >                                 1000baseT/Full
> >> >                                 10000baseT/Full
> >> >                                 1000baseKX/Full
> >> >                                 10000baseKX4/Full
> >> >                                 10000baseKR/Full
> >> >                                 2500baseT/Full
> >> >                                 5000baseT/Full
> >> >         Advertised pause frame use: Symmetric Receive-only
> >> >         Advertised auto-negotiation: Yes
> >> >         Advertised FEC modes: Not reported
> >> >         Link partner advertised link modes:  100baseT/Half 100baseT/Full
> >> >                                              1000baseT/Half 1000baseT/Full
> >> >                                              10000baseT/Full
> >> >                                              2500baseT/Full
> >> >                                              5000baseT/Full
> >> >         Link partner advertised pause frame use: No
> >> >         Link partner advertised auto-negotiation: Yes
> >> >         Link partner advertised FEC modes: Not reported
> >> >         Speed: 10000Mb/s
> >> >         Duplex: Full
> >> >         Port: Twisted Pair
> >> >         PHYAD: 8
> >> >         Transceiver: external
> >> >         Auto-negotiation: on
> >> >         MDI-X: Unknown
> >> >         Link detected: yes
> >> > # ping 192.168.1.146 -c5
> >> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
> >> > 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
> >> > 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
> >> > 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
> >> > 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
> >> > 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
> >> >
> >> > --- 192.168.1.146 ping statistics ---
> >> > 5 packets transmitted, 5 packets received, 0% packet loss
> >> > round-trip min/avg/max = 0.267/0.416/0.991 ms
> >> > # # force switch port to 1G
> >> > [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
> >> > 10gbase-r/Unknown/Unknown/none/off
> >> > [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
> >> > [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
> >> > [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
> >> > duplex=255 speed=-1 26:10gbase-r
> >> > [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
> >>
> >> Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
> >> the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
> >> send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
> >> and the vendor provisioning registers (dev 4, reg 0xc440 through
> >> 0xc449).
> >
> > yes, this is what I've been looking at as well. When forced to 1000m
> > the register shows a phy type of 11 which according to the aqr113
> > datasheet is XFI 5G:
> > aqr107_read_status STATUS=0x00001258 (type=11) state=4:running an=1
> > link=1 duplex=1 speed=1000 interface=0
>
> That's pretty strange. Seems like it's rate adapting from 5g instead of
> 10g. Is SERDES Mode in the Global System Configuration For 1G register
> set to XFI?

1E.31C=0x0106:
  Rate Adaptation Method: 2=Pause Rate Adaptation
  SERDES Mode: 6=XFI/2 (XFI 5G)

Tim
