Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4908A583562
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiG0WoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 18:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiG0WoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 18:44:15 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E25C9E9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 15:44:14 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z22so156691edd.6
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 15:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uK/c4yP0CDPWYkVPOsZtJed/YO3LVgTypPooIY5zOmA=;
        b=ROoC+INn6rrOJzHtE9jo8wcg+5JnXbMQYfmlgRiFL/C+I73bdrdSwUNBeuzfT/g1dB
         XxrvfpoWirj089A1EF0yNSysW9L2WxRRlEhC+QzRKBJwTojsWfhARXKzBr7W/AM+Q+Bz
         zaADlFiHaRGSo4i7D/nIrqYIiLBd7PzlApCrmGVQLHqJR6xo+m3HIQYqFRoHMDw+DeP9
         L/PHfuoUq8FBxml2gEkv0XQK7HO4YaToTYntjHRSHbdJD8egEVITHclfjk3bw48NsrMS
         8YqVGWlCCg8+R4c/bIP5OQSyxFg9hLfinOf4hVSGN/czwQpN6fmbuq2Ah4NadKC9Q/vJ
         BxtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uK/c4yP0CDPWYkVPOsZtJed/YO3LVgTypPooIY5zOmA=;
        b=VsjpEGaRTLsE16LBu98r8Gz9UTWnWy8/kFDVb+tw7xa1aVOXTyhDMyHR4wCZYxo7IP
         bozRApEJYO7KnKLsEi5SyEW3uJtLhSjE/tQRvkZdvl47F/TwDNyxEW2v8AOAE57cJNy/
         48pfKzTttogL/ltN3sx1UZHcuxRF7u/NFkWmN4ekLszhNeLArdFM0m6yFzCH17D/66kz
         noL95aYerqEu5cfYkwVUhoTQehndZkHuIMdkkPixRISVlDT+geraeLX8KOZUt1Uj3UQV
         53NuXCnwjbs8aA5d4wPdmHUgE/+QgdaRW4+HIguhDbcA/bMtpYaRe6jXFDW+gXTkeLzZ
         qo2Q==
X-Gm-Message-State: AJIora/JDkRvzx6zYa9Z3ann5DmdYfGcIoc7Ob3/wuXYSmGSF6dLyRBW
        KinxlghrrJHIqTzb+T3JMMU=
X-Google-Smtp-Source: AGRyM1tlGoBxahqRsun2dEfLfF3vsrmt67SZfmF8/O++JaoiHpWi6WQnOB0+K3qxA4dCm8cnsKlUdg==
X-Received: by 2002:a05:6402:11cb:b0:43c:c7a3:ff86 with SMTP id j11-20020a05640211cb00b0043cc7a3ff86mr3567030edw.383.1658961852221;
        Wed, 27 Jul 2022 15:44:12 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id r15-20020aa7da0f000000b0043ac761db43sm10944839eds.55.2022.07.27.15.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 15:44:11 -0700 (PDT)
Date:   Thu, 28 Jul 2022 01:44:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>, f.fainelli@gmail.com,
        Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: net: dsa: lantiq_gswip: getting the first selftests to pass
Message-ID: <20220727224409.jhdw3hqfta4eg4pi@skbuf>
References: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
 <CAFBinCDX5XRyMyOd-+c_Zkn6dawtBpQ9DaPkA4FDC5agL-t8CA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Wed, Jul 27, 2022 at 10:36:55PM +0200, Martin Blumenstingl wrote:
> Hello,
> 
> there are some pending issues with the Lantiq GSWIP driver.
> Vladimir suggested to get the kernel selftests to pass in a first step.
> I am starting with
> tools/testing/selftests/drivers/net/dsa/local_termination.sh as my
> understanding is that this contains the most basic tests and should be
> the first step.

I don't think I've said local_termination.sh contains the most basic
tests. Some tests are basic, but not all are.

> The good news is that not all tests are broken!

Looking at the tests which fail, I think the gswip driver is in a pretty
good state functionally speaking.

> There are eight tests which are not passing. Those eight can be split
> into two groups of four, because it's the same four tests that are
> failing for "standalone" and "bridge" interfaces:
> - Unicast IPv4 to unknown MAC address
> - Unicast IPv4 to unknown MAC address, allmulti
> - Multicast IPv4 to unknown group
> - Multicast IPv6 to unknown group
> 
> What they all have in common is the fact that we're expecting that no
> packets are received. But in reality packets are received. I manually
> confirmed this by examining the tcpdump file which is generated by the
> selftests.
> 
> Vladimir suggested in [0]:
> > [...] we'll need to make smaller steps, like disable address
> > learning on standalone ports, isolate FDBs, maybe offload the bridge TX
> > forwarding process (in order to populate the "Force no learning" bit in
> > tag_gswip.c properly), and only then will the local_termination test
> > also pass [...]
> 
> Based on the failing tests I am wondering which step would be a good
> one to start with.
> Is this problem that the selftests are seeing a flooding issue? In
> that case I suspect that the "interesting behavior" (of the GSWIP's
> flooding behavior) that Vladimir described in [1] would be a starting
> point.

It has to do with that, yes. What I said there is that the switch
doesn't autonomously flood unknown packets from one bridged port to
another, but instead, sends them to the CPU and lets the CPU do it.

While that is perfectly respectable from a correctness point of view,
it is also not optimal if you consider performance. The selftests here
try to capture the fact that the switch doesn't send unknown packets to
the CPU. And in this case the driver sends them by construction.

So the absolute first step would be to control the bridge port flags
(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD) and start
with good defaults for standalone mode (also set skb->offload_fwd_mark
when appropriate in the tagging protocol driver). I think you can use
bridge_vlan_aware.sh and bridge_vlan_unaware.sh as starting points to
check that these flags still work fine after you've offloaded them to
hardware.

When flooding a packet to find its destination can be achieved without
involving the CPU (*), the next thing will be to simply disable flooding
packets of all kind to the CPU (except broadcast). That's when you'll
enjoy watching how all the local_termination.sh selftests fail, and
you'll be making them pass again, one by one.

> 
> Full local_termination.sh selftest output:
> TEST: lan2: Unicast IPv4 to primary MAC address                 [ OK ]

For this to pass, the driver must properly respond to a port_fdb_add()
on the CPU port, with the MAC address of the $swp1 user port's net device,
offloaded in the DSA_DB_PORT corresponding to $swp1.

In turn, for DSA to even consider passing you FDB entries in DSA_DB_PORT,
you must make dsa_switch_supports_uc_filtering() return true.

(if you don't know what the words here mean, I've updated the documentation at
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/Documentation/networking/dsa/dsa.rst)

> TEST: lan2: Unicast IPv4 to macvlan MAC address                 [ OK ]

If the above passes, this should pass too. There's nothing different
from the driver's perspective, it's just that port_fdb_add() will be
called on the CPU port with a MAC address that isn't the MAC address of
any user port, but rather one added by the macvlan driver using dev_uc_add().

> TEST: lan2: Unicast IPv4 to unknown MAC address                 [FAIL]
>         reception succeeded, but should have failed

So this test should now pass after you've reworked the entire driver,
essentially. The point is that when flooding is disabled on the CPU port,
packets will be sent there only if they match an entry from the FDB.
Nobody will call port_fdb_add() for the address tested here.

> TEST: lan2: Unicast IPv4 to unknown MAC address, promisc        [ OK ]

Now this passes because the expectation of promiscuous ports is to
receive all packets regardless of MAC DA, that's the definition of
promiscuity. The driver currently already floods to the CPU, so why
wouldn't this pass.

Here, what we actually want to capture is that dsa_slave_manage_host_flood(),
which responds to changes in the IFF_PROMISC flag on a user port, does
actually notify the driver via a call to port_set_host_flood() for that
user port. Through this method, the driver is responsible for turning
flooding towards the CPU port(s) on or off, from the user port given as
argument. If CPU flood control does not depend on user port, then you'll
have to keep CPU flooding enabled as long as any user port wants it.

> TEST: lan2: Unicast IPv4 to unknown MAC address, allmulti       [FAIL]
>         reception succeeded, but should have failed

So I won't repeat why reception of unnecessary packets succeeds, because
the reason is always the same - the driver doesn't dynamically adapt to
all the indications DSA is giving it.

Here, the test captures the fact that IFF_ALLMULTI should enable host
flooding just for unknown multicast, while IFF_PROMISC should allow both
unicast and multicast. The packet was unicast, so IFF_ALLMULTI shouldn't
allow it.

> TEST: lan2: Multicast IPv4 to joined group                      [ OK ]

Here, I used a trivial program I found online to emit a IP_ADD_MEMBERSHIP
setsockopt, to trigger the kernel code that calls dev_mc_add() on the
net device. It seems to not be possible by design to join an IP
multicast group using a dedicated command in a similar way to how you'd
add an FDB entry on a port; instead the kernel joins the multicast group
for as long as the user application persists, and leaves the group afterwards.

As you can probably guess, dev_mc_add() calls made by modules outside
DSA are translated by dsa_slave_set_rx_mode() into a port_mdb_add() on
the CPU port, with DSA_DB_PORT.

If the gswip driver doesn't implement port_mdb_add() but rather treats
multicast as broadcast (by sending it to the CPU), naturally this test
"passes" in the sense that it thinks the driver reacted properly to what
was asked.

> TEST: lan2: Multicast IPv4 to unknown group                     [FAIL]
>         reception succeeded, but should have failed

This tests packet delivery to a multicast address for which dev_mc_add()
wasn't called.

> TEST: lan2: Multicast IPv4 to unknown group, promisc            [ OK ]
> TEST: lan2: Multicast IPv4 to unknown group, allmulti           [ OK ]
> TEST: lan2: Multicast IPv6 to joined group                      [ OK ]

No driver change needed between IPv4 and IPv6 multicast, the addresses
offloaded via switchdev are the L2 translations anyway (01:00:5e:xx:xx:xx
for IPv4 and 33:33:xx:xx:xx:xx for IPv6), so multiple IP addresses will
map to the same MAC address. Side note, the reason why I had to fork
mtools was to add support for IPV6_ADD_MEMBERSHIP, otherwise the
principles are more or less the same.

> TEST: lan2: Multicast IPv6 to unknown group                     [FAIL]
>         reception succeeded, but should have failed
> TEST: lan2: Multicast IPv6 to unknown group, promisc            [ OK ]
> TEST: lan2: Multicast IPv6 to unknown group, allmulti           [ OK ]
> TEST: br0: Unicast IPv4 to primary MAC address                  [ OK ]

Here is where things get interesting. I'm going to take a pause and
explain that the bridge related selftests fail in the same way for me
too, and that the fixes should go to the bridge driver rather than to
DSA.

The problem is that DSA treats IFF_PROMISC as "enable host flooding for
this port", and the bridge puts its ports in IFF_PROMISC mode by reflex.
So in theory, the patches here don't really capture anything relevant as
long as that keeps being the case. Regardless of whether an address is
present in the hardware FDB or not, the IFF_PROMISC triggered by the
bridge keeps host flooding enabled, which makes us receive more than we
need.

I've published a patch set here explaining how I think this would need
to be solved.
https://patchwork.kernel.org/project/netdevbpf/cover/20220408200337.718067-1-vladimir.oltean@nxp.com/
I'd probably do things a bit differently when revisiting.

> TEST: br0: Unicast IPv4 to macvlan MAC address                  [ OK ]

There is even more bridge driver rework to do here. What this test
captures is a macvlan interface on top of a bridge on top of a DSA user
port. Earlier I said that macvlan uses dev_uc_add() towards its lower
interface - the bridge - to ensure its RX filter doesn't drop required
packets. But if the net device doesn't support IFF_UNICAST_FLT (and the
bridge doesn't), dev_uc_add() falls back to putting the interface in
promiscuous mode. And the bridge has this crazy interpretation of what
promiscuous mode means, which is hard to reason about. So eventually,
even though the higher and upper layers of the bridge do what's expected,
we still end up with DSA in promiscuous mode, and hence receiving
packets irrespective of MAC DA. This is why this test really passes
(the promiscuity masks the presence of the macvlan address in the FDB),
and will continue to mask it for as long as the bridge doesn't implement
IFF_UNICAST_FLT.

> TEST: br0: Unicast IPv4 to unknown MAC address                  [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Unicast IPv4 to unknown MAC address, promisc         [ OK ]
> TEST: br0: Unicast IPv4 to unknown MAC address, allmulti        [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Multicast IPv4 to joined group                       [ OK ]

Just one more small comment to make.
The addresses in the "br0" tests are also notified through port_mdb_add(),
but they use DSA_DB_BRIDGE since they come to DSA via switchdev rather
than via dev_mc_add() - they came _to_the_bridge_ via dev_mc_add().
DSA drivers are expect to offload these multicast entries to a different
database than the port_mdb_add() I've described above. This is a
database that is active only while $swp1 is part of a bridge, while
DSA_DB_PORT is active only while $swp1 is standalone.

> TEST: br0: Multicast IPv4 to unknown group                      [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Multicast IPv4 to unknown group, promisc             [ OK ]
> TEST: br0: Multicast IPv4 to unknown group, allmulti            [ OK ]
> TEST: br0: Multicast IPv6 to joined group                       [ OK ]
> TEST: br0: Multicast IPv6 to unknown group                      [FAIL]
>         reception succeeded, but should have failed
> TEST: br0: Multicast IPv6 to unknown group, promisc             [ OK ]
> TEST: br0: Multicast IPv6 to unknown group, allmulti            [ OK ]
> 
> 
> Thank you!
> Best regards,
> Martin
> 
> [0] https://lore.kernel.org/netdev/20220706210651.ozvjcwwp2hquzmhn@skbuf/
> [1] https://lore.kernel.org/netdev/20220702185652.dpzrxuitacqp6m3t@skbuf/

