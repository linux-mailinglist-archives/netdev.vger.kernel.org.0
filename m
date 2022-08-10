Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89558F343
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 21:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiHJTic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 15:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiHJTib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 15:38:31 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145F79ECF
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:38:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z20so18481872edb.9
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 12:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=dbxd6xCfQPO+sV9sJG6xEK8lCuC4pf3lC0GjkJBMtp0=;
        b=Bdvee1JDvmzZ7qC/WRmIP8wcf1/KN4PwGqmJ1MqG2Gn/++9RBxoBcUwNCh+kMzFzXV
         T/13h5DDLQU4jr8URNlY/BVF+tw7wKMwwJ3gFucim6zt970yuo63AvfINmHnZEosejkK
         b/L4w6dD3GHp2ssw337PUtaO4rAYRg8MOP+IpzFKzo8hBci2aMaSA2AgwBUuoJuzVXz6
         aYCasQjYniFhSl0iNl3Os3Goh63WphKdgTTZkKg6Suk89A0hrZ3EMkmZwew/FoKy8Mty
         vhA7BW2UgAhoT4Lo3ykxBt2tZQW8jWFvt9Doa8P5rMaG8DxChNmU6vgZUQeQj6xtM9zZ
         L/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=dbxd6xCfQPO+sV9sJG6xEK8lCuC4pf3lC0GjkJBMtp0=;
        b=8CNqibxwBE3DqhzA50pgxhAnBbMRo026p7+7G1ZZBd68AlzG70ToITwF1eT9K06bY3
         WDhd5FXhMKNPxSbWVd3r9MXkXIpQWzQlwmb64f1eSd/9Ey0NTao99G0YyHR/cyE6+gqK
         euIx+KLg9PMD62Y5Ws2gpaB+j//tDPCrW/JAPsAfYAOu5F2WYUj/zIYjwePAoQOV+EEr
         sNsh/YGwMPvzCaZ06/tCrpYf1HWzX9U4MiFIpVH5lcbrLmmg/44QCT2QSuoFW+s8g0QY
         axYWJZ6OzYCZeLcMH644gOKEc3/xLtocz0dyfzWo23pKKruTRXt5UqyoOqYs0QXt7snd
         6Xog==
X-Gm-Message-State: ACgBeo0NL6D5TrGsSuGZ5Ph/mBdUNHphpr5+4n/fVVBaI62vUo59Ivjo
        vidkc3RR3c/8NBDSVbVDznYbJe9PZnY=
X-Google-Smtp-Source: AA6agR5nTMExnwM7rKa8OBVOZUOW0RdQaOUJDKazbxKSLxJcHP6thIV2b2tfVbhDw0pDukt6fv2V2g==
X-Received: by 2002:aa7:da93:0:b0:43d:1d9d:1e5 with SMTP id q19-20020aa7da93000000b0043d1d9d01e5mr28464422eds.55.1660160308624;
        Wed, 10 Aug 2022 12:38:28 -0700 (PDT)
Received: from skbuf ([188.27.185.133])
        by smtp.gmail.com with ESMTPSA id ec33-20020a0564020d6100b004418c7d633bsm2784077edb.18.2022.08.10.12.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 12:38:27 -0700 (PDT)
Date:   Wed, 10 Aug 2022 22:38:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
Message-ID: <20220810193825.vq7rdgwx7xua5amj@skbuf>
References: <20220810082745.1466895-1-saproj@gmail.com>
 <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
 <20220810133531.wia2oznylkjrgje2@skbuf>
 <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 06:56:25PM +0300, Sergei Antonov wrote:
> > reg = <16> for switch@0? Something is wrong, probably switch@0.
> 
> Thanks for noticing it.
> In my case the device addresses are:
>   PHY Registers - 0x10-0x14
>   Switch Core Registers - 0x18-0x1D
>   Switch Global Registers - 0x1F
> I renamed switch@0 to switch@10 and made reg hexadecimal for clarity:
> "reg = <0x10>". It works, see below for more information on testing.
> Should I leave it like so?

Should be fine like that. I think Marvell switches tend to have this
habit of occupying multiple PHY addresses, and our DT bindings want to
see the first one.

> > The bug seems to have been introduced by commit 0abfd494deef ("net: dsa:
> > use dedicated CPU port"), because, although before we'd be uselessly
> > programming the port VLAN for a disabled port, now in doing so, we
> > dereference a NULL pointer.
> 
> The suggested fix with dsa_is_unused_port() works. I tested it on the
> 'netdev/net.git' repo, see below. Should I submit it as a patch
> (Fixes: 0abfd494deef)?

Yes. See the section that talks about "git log -1 --pretty=fixes" in
process/submitting-patches.rst for how the Fixes tag should actually
look like.

I thought about whether dsa_is_unused_port() is sufficient, since
theoretically dsa_is_dsa_port() is also a possibility which isn't
covered by the check. But I rechecked and it appears that the Marvell
6060 doesn't support cascade ports, so we should be fine with just that.

> So I tested "dsa_is_unused_port()" and "switch@10" fixes with
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> What I did after system boot-up:
> 
> ~ # dmesg | grep mv88
> [    7.187296] mv88e6060 92000090.mdio--1-mii:10: switch Marvell 88E6060 (B0) detected
> [    8.325712] mv88e6060 92000090.mdio--1-mii:10: switch Marvell 88E6060 (B0) detected
> [    9.190299] mv88e6060 92000090.mdio--1-mii:10 lan2 (uninitialized): PHY [dsa-0.0:02] driver [Generic PHY] (irq=POLL)
> 
> ~ # ip a
> 1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: eth0: <BROADCAST,MULTICAST> mtu 1504 qdisc noop qlen 1000
>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff

The DSA master is super odd for starting with an all-zero MAC address.
What driver handles this part? Normally, drivers are expected to work
with a MAC address provided by the firmware (of_get_mac_address or
other, perhaps proprietary, means) and fall back to eth_random_addr()
if that is missing.

> 3: lan2@eth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop qlen 1000
>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff

Here DSA inherits the MAC address of the master. It does this by default
in dsa_slave_create() -> eth_hw_addr_inherit(). If the OF node for the
DSA port has its own MAC address, that will have priority over the MAC
address of the master.

> ~ # ip link set dev eth0 address 00:90:e8:00:10:03 up

This shouldn't be necessary, neither assigning a MAC address nor putting
the master up, see Documentation/networking/dsa/configuration.rst, the
master comes up automatically.

> ~ # ip a add 192.168.127.254/24 dev lan2
> 
> ~ # ip link set dev lan2 address 00:90:e8:00:10:03 up
> [   56.383801] DSA: failed to set STP state 3 (-95)

errno 95 is EOPNOTSUPP, we shouldn't warn here, I'll submit a patch for
that.

> [   56.385491] mv88e6060 92000090.mdio--1-mii:10 lan2: configuring for phy/gmii link mode
> [   58.694319] mv88e6060 92000090.mdio--1-mii:10 lan2: Link is Up - 100Mbps/Full - flow control off

The link was negotiated without flow control, so you can't test flow
control under these conditions. This depends upon what the internal PHY
of the mv88e6060 is advertising, and what the link partner is advertising.
What is advertised is a subset of what is supported (and resolved by
linkmode_resolve_pause).

I'm a bit uncertain as to what happens when the 6060 driver doesn't
validate the phylink supported mask at all (it doesn't populate the
mac_capabilities structure and it doesn't implement ds->ops->phylink_validate)
but I think what happens is that whatever the PHY supports isn't further
reduced in any way by the MAC side of things.

> [   58.699244] IPv6: ADDRCONF(NETDEV_CHANGE): lan2: link becomes ready
> 
> ~ # ip a
> 1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
>     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc pfifo_fast qlen 1000
>     link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
>     inet6 fe80::290:e8ff:fe00:1003/64 scope link
>        valid_lft forever preferred_lft forever
> 3: lan2@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue qlen 1000
>     link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
>     inet 192.168.127.254/24 scope global lan2
>        valid_lft forever preferred_lft forever
>     inet6 fe80::290:e8ff:fe00:1003/64 scope link
>        valid_lft forever preferred_lft forever
> 
> Ping, ssh, scp work.
> 
> Is it correct for eth0 and lan2@eth0 to have the same MAC?

It is not wrong, it's a configuration that many deployed DSA systems use.

> I could not make it work with different MACs.

That is a problem, and I believe it's a problem with the DSA master driver.
See, the reason it should work is this. Switch ports don't really have a
MAC address, since they forward everything and not really terminate anything.
The MAC address of a switch port is a software construct which means
that software L3 termination interfaces (of which we have one per port)
should accept packets with some known MAC DA, and drop the rest, and
everything should be fine.

There are multiple kinds of DSA tags, but 6060 uses a trailer, and this
will not shift the 'real' MAC DA of packets compared to where the DSA
master expects to see them. So if the MAC address of the DSA master is A,
the MAC address of lan2 is B, and you ping lan2 from the outside world,
the DSA master will see packets with a MAC DA of B.

So the DSA master sees packets with a MAC DA different from its own
dev->dev_addr (A) and thinks it's within its right to drop them. Except
that it isn't, because we do the following to prevent it:

(1) in case the DSA master supports IFF_UNICAST_FLT, we call dev_uc_add()
    from dsa_slave_set_mac_address() and from dsa_slave_open(), and this
    informs it of our address B.
(2) in case it doesn't support IFF_UNICAST_FLT, we just call
    dsa_master_set_promiscuity() and that should keep it promiscuous and
    it should accept packets regardless of MAC DA (that's the definition).

So you should run some tcpdump and ethtool -S on the DSA master and see
whether it receives any packets or it drops them. It's possible that
tcpdump makes packets be accepted, since it puts the interface in
promiscuous mode.

> I don't know how to test flow control. Ping, ssh, scp work even with
> mv88e6060_setup_addr() code removed. Of course, if MAC SA plays some
> role in other scenarios, let it be :).

I think it's best to leave alone things you don't really care about.
The address in mv88e6060_setup_addr() should have nothing to do with
what you really seem to want to know, just with flow control.
