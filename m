Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FC35692E9
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiGFT5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiGFT5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:57:53 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782AD193D2
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 12:57:52 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id m16so5105669edb.11
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 12:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XlNr6Nw/sJWKPTdQvuhZ578EcwNIuIcY3oSNAQx9aU4=;
        b=Za3aDd6D9KPWHRpMnl0bsNtd53IPFrAnSiLGI1ZW/L/hXRtWQGaltw8qPju9zsMsRD
         CXOfzHjwPlX9Dh0CU00r/9ZSRv9TTpBuimij/Bd+PWFBAovv68N6Qf+qYSaprALe0vvf
         2XPory2huGSLYaa/Ac3nfo50mWa4Vt5Dg6UXc1lhZp3G4YzGwXnZ3kYwTUxuOSCWRwOQ
         96sYr9SIve9keXi9a7HHdfoRZKI0LsqmtSBV5v4W05FdnLnYj4kHT5b+3qvZ3Ex/5XKO
         5hk/WI7wdyu6UiJmqU6UzUlgZVm14YQOI1zrlPMeSHLMi5NLLGew1WP6QkNytTyRPlXQ
         Qt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XlNr6Nw/sJWKPTdQvuhZ578EcwNIuIcY3oSNAQx9aU4=;
        b=rKt6JqrDEpSKlHbYGWsCdg5kPm7Lq5rEpqt5kaAbqxyFZsiq4JjpPOt50Aay1CaTRh
         rOZo8UxfzKtF5AJljGkYO2quuk3MilxONO55V67clpLDyhfB9pr/PF3v4z6jm5/mrKlf
         XR2z1yzjktNH/gmbcrUDwSm7iMxSzKkZUgOGCd6QOuulsXc7JmPgDe3VhZs6M3OT8LBP
         Ij6OrvyFQ0esv/bLBXhuZM+AxuHivFbchRF+5xUC5/j8TtmbvMXaeFmuQWt1htHNIdQ5
         0S/1ekPNUkdrjhw8yj/pqH3r9U/Fb0D3602/hxP/GbGwggJLdbYAuweSp8i+nnyjVIOt
         24LQ==
X-Gm-Message-State: AJIora/2c6SMyawT5jbhxjuFElwfYwkHPRguEinnYWwXn/Yy7eSZ/Dj5
        03v46tj0uJBc7Sf5Um7vIzCQT1ibwLGDj6sC9ds=
X-Google-Smtp-Source: AGRyM1vdIwSBUYUVDDxfpP2Wfos1ES2IcF9eX/4mwvxt2zsYHEKixdXXs+X9mGvMpt3auV1SwRwAMOtkpF+0p91JdwE=
X-Received: by 2002:aa7:d955:0:b0:43a:7241:4cf9 with SMTP id
 l21-20020aa7d955000000b0043a72414cf9mr17398338eds.247.1657137471004; Wed, 06
 Jul 2022 12:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com> <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
In-Reply-To: <20220706164552.odxhoyupwbmgvtv3@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 6 Jul 2022 21:57:40 +0200
Message-ID: <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
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

Hi Vladimir,

On Wed, Jul 6, 2022 at 6:45 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
[...]
> Somehow we should do something to make sure that the OpenWRT devices are
> able to run the selftests, because there's a large number of DSA switches
> intended for that segment and we should all be onboard (easily).
I could work on this on the OpenWrt side.
But this would require me to get any test working at all...

I am struggling with not seeing any ping responses.
Instead of adding VLANs and others to the mix I started with seemingly
simple commands while connecting an Ethernet cable between lan1 and
lan2 and another cable between lan3 and lan4:
1) give each port a unique MAC address, which is not the default on my
device under test
ip link set dev lan1 address 6a:88:f1:99:e1:81
ip link set dev lan2 address 6a:88:f1:99:e1:82
ip link set dev lan3 address 6a:88:f1:99:e1:83
ip link set dev lan4 address 6a:88:f1:99:e1:84

2) set up IP addresses on LAN1 and LAN2
ip addr add 192.168.2.1/24 brd + dev lan1
ip addr add 192.168.2.2/24 brd + dev lan2

3) bring up the interfaces
ip link set up dev lan1
ip link set up dev lan2

4) start tcpdump on LAN1
tcpdump -i lan1 &

5) start ping from LAN2 to LAN1
ping -I lan2 192.168.2.1

result:
PING 192.168.2.1 (192.168.2.1): 56 data bytes
20:02:01.522977 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length 46
20:02:02.569234 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length 46
20:02:03.609132 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length 46
20:02:05.524200 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length 46
20:02:06.569226 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length 46
...repeats...

So LAN1 can see the ARP request from the ping on LAN2.
But I am not seeing Linux trying to send a reply.

I already verified that nftables doesn't have any rules active (if it
was I think it would rather result in tcpdump not seeing the who-has
request):
# nft list tables
#

# grep "" /proc/sys/net/ipv4/icmp_echo_ignore_*
/proc/sys/net/ipv4/icmp_echo_ignore_all:0
/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts:1

# ps | grep netif
3014 root      1308 S    grep netif
#

To make things worse: if I let OpenWrt's netifd configure LAN1 and
LAN2 as single ports with above IP addresses ping works.
Something is odd and I am not sure how to find out what's wrong.

> I wonder, would it be possible to set up a debian chroot?
I'm thinking of packaging the selftests as OpenWrt package and also
providing all needed dependencies as OpenWrt packages.
I think (or I hope, not sure yet) the ping interval is just a matter
of a busybox config option.


Best regards,
Martin
