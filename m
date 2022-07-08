Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9798D56B628
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 12:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbiGHKAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 06:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiGHKAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 06:00:46 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCB483F09
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 03:00:45 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u15so12420364ejx.9
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 03:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lDZkMulA0ArMtCXDkNRa2O0tW33d8i9FvuSk/OZLXNk=;
        b=Kgojws7tE9MaCdXNC8uHK+GhmqwpBUhr3nPmgwImHR7/M+r6rpHNnZByvU1BFNDedK
         44VUaOoMbhUb5SBubTO4GuVc+PRMHa1nJfXTWXm7Jlgz2v/gackw12LSef6K9CqQpKWX
         76sKnsMflS2KYJ27hsSR5O3ts5QaQIz+EUcHzxBpKhy5IwwgOsmN1fl5KERNwCbrK0p6
         rVF10LliYCK4NkAhUyEGOkIyXAsx4ti/8FqS68xZ4xde22GqcTnTTI+cbh/zZiEzHpei
         cN5YxZvNwARsVfti1ozMaTStW5dWagiv5iHkMY/hTqtBX1a9YvX0hKnIWimaoLOoU3t/
         mKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lDZkMulA0ArMtCXDkNRa2O0tW33d8i9FvuSk/OZLXNk=;
        b=4faosNst+A3momcpyKOu2LJXIziWr/DfxX0cwZ27BK9RCky93gnvCMn9B9CkQXF7e0
         h2AVHqDnoES2EvSBlhJkxYl9TstwiReb0D5LeNKRUrvMirHUr8e1Otx737X74EbET4aj
         Ok6nYMRNDhO8r7Xjof584+iKF1c1gJLpEDGmRH8QTArzg0dDQ8JCMahDqyKWamoEZlsf
         DxsJ1jbmPuvxZmpLBJLNerzhsP7pTB72dsln6ijGlRvK0ydni2GdYihyQPeDdj6F1/AU
         ZDQ//dpmP2mNSBiieht4mBNEx7dBN8BWGRrdfBqBzJvRj/9+ND869ICN83u8TDLoCgOP
         N5uw==
X-Gm-Message-State: AJIora/MNc9nnsOpWbRJcu6i6D5AchzX6XhMWBOic9QSQRnLte4zKP6y
        bkd32rj0jWHX+CJ12Szq8dy5ZgH7CXisqFHKAwA=
X-Google-Smtp-Source: AGRyM1tqC2GQcMk+frzML2UJY2Dz61+OMkHZL8hOhE9lsohfqsgN6/gTTlJlKKnDk+IpShPmEbj0gAd1Afd4uyL8Brw=
X-Received: by 2002:a17:906:3f51:b0:712:3945:8c0d with SMTP id
 f17-20020a1709063f5100b0071239458c0dmr2730537ejj.302.1657274444205; Fri, 08
 Jul 2022 03:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com> <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf> <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
 <20220707223116.xc2ua4sznjhe6yqz@skbuf>
In-Reply-To: <20220707223116.xc2ua4sznjhe6yqz@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 8 Jul 2022 12:00:33 +0200
Message-ID: <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
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

On Fri, Jul 8, 2022 at 12:31 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
[...]
> > So LAN1 can see the ARP request from the ping on LAN2.
> > But I am not seeing Linux trying to send a reply.
>
> It won't reply, you either need a network namespace or a VRF to do
> loopback IP networking. A VRF is a bit more complicated to do, here's a
> netns setup:
>
> ip netns add ns0
> ip link set lan2 netns ns0
> ip -n ns0 link set lan2 up
> ip -n ns0 addr add 192.168.2.2/24 dev lan2
> ip netns exec ns0 tcpdump -i lan2 -e -n
> ping 192.168.2.2
This does indeed work!
That made me look at another selftest and indeed: most of the
local_termination.sh tests are passing (albeit after having to make
some changes to the selftest scripts, I'll provide patches for these
soon)

None (zero) of the tests from bridge_vlan_unaware.sh and only a single
test from bridge_vlan_aware.sh ("Externally learned FDB entry - ageing
& roaming") are passing for me on GSWIP.
Also most of the ethtool.sh tests are failing (ping always reports
"Destination Host Unreachable").
I guess most (or at least more) of these are supposed to pass? Do you
want me to open another thread for this or is it fine to reply here?

[...]
> I'm not familiar with OpenWrt, sorry, I don't know what netifd does.
netifd is the network configuration daemon, it takes the network
configuration (from OpenWrts configuration files/format) and sets up
the corresponding interfaces and manages things like pppoe.

> Also, it's curious that this works, are you sure that the ARP responses
> and ICMP replies actually exit through the Ethernet port? ethtool -S
> should show if the physical counters increment.
Since it works with your example and I got the first selftests to pass
I'll skip further investigation here

> > > I wonder, would it be possible to set up a debian chroot?
> >
> > I'm thinking of packaging the selftests as OpenWrt package and also
> > providing all needed dependencies as OpenWrt packages.
> > I think (or I hope, not sure yet) the ping interval is just a matter
> > of a busybox config option.
>
> I think it depends on busybox version. At least the latest one
> https://github.com/mirror/busybox/blob/master/networking/ping.c#L970
> seems to support fractions of a second as intervals, I didn't see any
> restriction to sub-second values. In any case, the iputils version
> certainly does work.
Yes, there's a duration library inside busybox which by default only
takes integer values (it can be configured to use floats though).
I pushed my work in progress OpenWrt package to a branch, making use
of the iputils version: [0]
Compressed initramfs size is below 10M and uncompressed at 22M. My
device under test has 128M of RAM and that seems to be enough to run
mausezahn as well as any other tool that was run so far. So I am not
particularly concerned about storage size (anything with 32M flash or
more will do - 16M could be a bit tight in the end but will still work
I guess).


Best regards,
Martin


[0] https://github.com/xdarklight/openwrt-packages/commits/wip-kernel-selftests-net-forwarding-20220707
