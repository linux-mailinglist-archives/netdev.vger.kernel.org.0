Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0358F8F5
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiHKIXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbiHKIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:23:15 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9317D65654
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:23:14 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id q6-20020a05683033c600b0061d2f64df5dso12233232ott.13
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Z98a3HO107jt3OeR1OAEpJcXYk9jZSZvv6zasMuBAKQ=;
        b=BawQT+lzrupZ2m2iNWWHdklupztcU+x7Bl/DqPjYc2TnZyf/1uaqymbBCau9Gv4ziI
         iA72RRyESDD5fFNP+7OOVF6InyPNc3aX2WN4oEUS6uY+ZW/DDM7Nu10ueffp8NDw71DZ
         eiE0OuJ39O4ds9uZiPgl9uYVgQ2jvDVfjd9CMiH+xl6wpqJnzasvrkqHEjIogwMa06KH
         A2k4IWouV0lYhEQPunY4Da69z3rIAOD76iIzO7n7BXhWDGq4I/VzT6jUb9AgTa4kVgQR
         t2uOSd/R/uaYgCEuzfWAD4wwTP6oVk8fUGJo74A3f/ULOWD0xHkyVuGeAEs29xlDM4NY
         Garw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Z98a3HO107jt3OeR1OAEpJcXYk9jZSZvv6zasMuBAKQ=;
        b=dm8in+EKJuOfn2OSOf9aFDJHbrLkmbq3wE+AQEA3m8avYgLDCICQNoFiat8nKioe7a
         LfxUDu02tJw8pnv7UBOXZETmq5K/e6qxK5IS4zF6TFJdoUOdZMB40R3qS1fNoaMmdm5O
         +DNt8uz4KSDIFc3pKsaWowRhDx7nZDPqyATcv0MdbQPNjtwPXQ71oYhv8OqQ2Hu5aSmK
         KB5ZO6NjwDF6bLhMugX7trcJlCJv3xqgVvn2IBzf0OqrqbXCAu6kUy8UkVHnBMDk/eQu
         3kyaog1NWT3KMTjzz9iNwLuh+KSuWfr1YHMqjL1MkMW2i1nWxQnDgk58doiszaN75ki3
         HMug==
X-Gm-Message-State: ACgBeo2jLozS79yO84//FaAoVvi6xR+bIcB5OQC6UB+FIxKYuSX9exoZ
        9TBlkIFtkBwXXs93d8XhENeNJmCOunByczeZ8vw=
X-Google-Smtp-Source: AA6agR5sdeaB+4TVeyWEH6JwF8MYZdKQb3zvCq14GTXvBFjSAQH9tEH16gn87nrMY7d3io128HPZsA5YEI5vuWzjAsg=
X-Received: by 2002:a05:6830:630f:b0:61c:7c8b:ed18 with SMTP id
 cg15-20020a056830630f00b0061c7c8bed18mr11888806otb.168.1660206193912; Thu, 11
 Aug 2022 01:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220810082745.1466895-1-saproj@gmail.com> <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
 <20220810133531.wia2oznylkjrgje2@skbuf> <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
 <20220810193825.vq7rdgwx7xua5amj@skbuf>
In-Reply-To: <20220810193825.vq7rdgwx7xua5amj@skbuf>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Thu, 11 Aug 2022 11:23:02 +0300
Message-ID: <CABikg9wUtyNGJ+SvASGC==qezh2eghJ=SyM5hECYVguR3BmGQQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 at 22:38, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > The bug seems to have been introduced by commit 0abfd494deef ("net: dsa:
> > > use dedicated CPU port"), because, although before we'd be uselessly
> > > programming the port VLAN for a disabled port, now in doing so, we
> > > dereference a NULL pointer.
> >
> > The suggested fix with dsa_is_unused_port() works. I tested it on the
> > 'netdev/net.git' repo, see below. Should I submit it as a patch
> > (Fixes: 0abfd494deef)?
>
> Yes. See the section that talks about "git log -1 --pretty=fixes" in
> process/submitting-patches.rst for how the Fixes tag should actually
> look like.
>
> I thought about whether dsa_is_unused_port() is sufficient, since
> theoretically dsa_is_dsa_port() is also a possibility which isn't
> covered by the check. But I rechecked and it appears that the Marvell
> 6060 doesn't support cascade ports, so we should be fine with just that.

Great. I submitted a patch.

> > So I tested "dsa_is_unused_port()" and "switch@10" fixes with
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> > What I did after system boot-up:
> >
> > ~ # dmesg | grep mv88
> > [    7.187296] mv88e6060 92000090.mdio--1-mii:10: switch Marvell 88E6060 (B0) detected
> > [    8.325712] mv88e6060 92000090.mdio--1-mii:10: switch Marvell 88E6060 (B0) detected
> > [    9.190299] mv88e6060 92000090.mdio--1-mii:10 lan2 (uninitialized): PHY [dsa-0.0:02] driver [Generic PHY] (irq=POLL)
> >
> > ~ # ip a
> > 1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
> >     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> > 2: eth0: <BROADCAST,MULTICAST> mtu 1504 qdisc noop qlen 1000
> >     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
>
> The DSA master is super odd for starting with an all-zero MAC address.
> What driver handles this part? Normally, drivers are expected to work
> with a MAC address provided by the firmware (of_get_mac_address or
> other, perhaps proprietary, means) and fall back to eth_random_addr()
> if that is missing.

eth0 is handled by the CONFIG_ARM_MOXART_ETHER driver. By the way, I
had to change some code in it to make it work, and I am going to
submit a patch or two later.
The driver does not know its MAC address initially. On my hardware it
is stored in a flash memory chip, so I assign it using "ip link set
..." either manually or from an /etc/init.d script. A solution with
early MAC assignment in the moxart_mac_probe() function is doable. Do
you think I should implement it?

> > 3: lan2@eth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop qlen 1000
> >     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
>
> Here DSA inherits the MAC address of the master. It does this by default
> in dsa_slave_create() -> eth_hw_addr_inherit(). If the OF node for the
> DSA port has its own MAC address, that will have priority over the MAC
> address of the master.

I quickly tried setting a MAC address in the moxart_mac_probe()
function and DSA did inherit it. Looks like the way to go.

> > ~ # ip link set dev eth0 address 00:90:e8:00:10:03 up
>
> This shouldn't be necessary, neither assigning a MAC address nor putting
> the master up, see Documentation/networking/dsa/configuration.rst, the
> master comes up automatically.

Yes, it indeed does. Thanks.

> > ~ # ip a add 192.168.127.254/24 dev lan2
> >
> > ~ # ip link set dev lan2 address 00:90:e8:00:10:03 up
> > [   56.383801] DSA: failed to set STP state 3 (-95)
>
> errno 95 is EOPNOTSUPP, we shouldn't warn here, I'll submit a patch for
> that.

Great, I'll review it.

> > Is it correct for eth0 and lan2@eth0 to have the same MAC?
>
> It is not wrong, it's a configuration that many deployed DSA systems use.

Is it also not wrong with several lanN@eth0 interfaces? I'm asking it
because I will probably need to support hardware with more than one
port on the 6060.

> > I could not make it work with different MACs.
>
> That is a problem, and I believe it's a problem with the DSA master driver.
> See, the reason it should work is this. Switch ports don't really have a
> MAC address, since they forward everything and not really terminate anything.
> The MAC address of a switch port is a software construct which means
> that software L3 termination interfaces (of which we have one per port)
> should accept packets with some known MAC DA, and drop the rest, and
> everything should be fine.
>
> There are multiple kinds of DSA tags, but 6060 uses a trailer, and this
> will not shift the 'real' MAC DA of packets compared to where the DSA
> master expects to see them. So if the MAC address of the DSA master is A,
> the MAC address of lan2 is B, and you ping lan2 from the outside world,
> the DSA master will see packets with a MAC DA of B.
>
> So the DSA master sees packets with a MAC DA different from its own
> dev->dev_addr (A) and thinks it's within its right to drop them. Except
> that it isn't, because we do the following to prevent it:
>
> (1) in case the DSA master supports IFF_UNICAST_FLT, we call dev_uc_add()
>     from dsa_slave_set_mac_address() and from dsa_slave_open(), and this
>     informs it of our address B.
> (2) in case it doesn't support IFF_UNICAST_FLT, we just call
>     dsa_master_set_promiscuity() and that should keep it promiscuous and
>     it should accept packets regardless of MAC DA (that's the definition).
>
> So you should run some tcpdump and ethtool -S on the DSA master and see
> whether it receives any packets or it drops them. It's possible that
> tcpdump makes packets be accepted, since it puts the interface in
> promiscuous mode.

When I tried to make it work with different MAC addresses, I used
Wireshark and saw that ARP packets did not reach the interface unless
they were broadcast. I might have been a configuration issue rather
than driver issue. Thanks for the explanation! But I will happily
stick to the common MAC address solution if it is not wrong.
