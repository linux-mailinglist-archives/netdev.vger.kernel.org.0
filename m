Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B416A2B2F7C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgKNSLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:11:07 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DA1C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:11:06 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so18515437ejb.7
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zaB/PwjMirxVRG99vMWet+hDGI/K4ZKsf22g1Z1GAi8=;
        b=C9aZoBjXf/tBhmMmMT5OddY2q+z1dMVuR8gr5odh5efF04DWGSraLWWzEy5YySn0aJ
         YUhJzeDHTQJ1JXxaA3+icg/aLbpd0Xg/0BZKTvE+25d7vdpRRF/k5lQ7kCzwUkFWNSq9
         t/NWU8XUJa1dtHDt6WIdsKmgw5oCWVbI7ElJDIdcNNN0iR1GFrHTtsbEnFIFOMMdxiyz
         lsRjujvln65IH9fPnuXt14f0PmaV9rUUp4RMp8wD2rxhV7hN0Mfd9EgaJwY+ZMQa8jkr
         5xVhsPdZpqZ9qzOvjrFr66OQHrCuJbdOMQTPeFv6l6t1ai0cqO20CqBWSyiG1MSID7mg
         HMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zaB/PwjMirxVRG99vMWet+hDGI/K4ZKsf22g1Z1GAi8=;
        b=qs5NjrQvM5UsY824mpcQEBbGtRriuoUqTyH5srU8S3oElRiwy5glXWPZ3s/QngkY7m
         QFMoUN0MglPMcVgwPckTxQ/Zm0oV8dMmDr0l5RT9CdxFXoMWD2+guo48QXlz+n7KgBz7
         AJEGwzdMT7rcijzAlYlv1GvEbz43yfYQKLMlil+A590XTvAzlOUDOsj1RZADEehAppol
         eXzHGXB72Zijld+LWSNWtTrzbhJMQj++/WbQMWM0lncMktgCfMknxINVxfLY0yh1PQ62
         1zVhfuCMkkCFnv+lpiCE1+Nf1jfwBKN2mcChrMxre3rtbtvCFJkx/ikm3T5TiSp1Kbro
         je1A==
X-Gm-Message-State: AOAM533CrCFylUX1mXXrYgmLK43aIre3MyResnK2yJZuot2qT+YvLbWx
        GVAr61VH3DzXu4ZWRx5rKBs=
X-Google-Smtp-Source: ABdhPJyAPwzARTULeiUCF5Q06wXT+gOl2Qp0ICWqPT5QjpArH98xf8+6dYuUu6/SdaJUXtBBLdUdQQ==
X-Received: by 2002:a17:906:4944:: with SMTP id f4mr7394526ejt.231.1605377465144;
        Sat, 14 Nov 2020 10:11:05 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 65sm4764262edi.91.2020.11.14.10.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 10:11:04 -0800 (PST)
Date:   Sat, 14 Nov 2020 20:11:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201114181103.2eeh3eexcdnbcfj2@skbuf>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
 <20201111164727.pqecvbnhk4qgantt@skbuf>
 <20201112105315.o5q3zqk4p57ddexs@ipetronik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201112105315.o5q3zqk4p57ddexs@ipetronik.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 11:53:15AM +0100, Markus Blöchl wrote:
> From what I can see, most other drivers use a special hardware register
> flag to enable promiscuous mode, which overrules all other filters.

Yes, but it may not mean what you think.

> e.g. from the ASIX AX88178 datasheet:
>
>   PRO:  PACKET_TYPE_PROMISCUOUS.
>     1: All frames received by the ASIC are forwarded up toward the host.
>     0: Disabled (default).

See, that's one definition of promiscuity that is really strange, and
not backed by any standards body that I know of (if you know otherwise,
please speak up).

> It is just so that the lan78xx controllers don't have this explicit flag.

Which is not surprising, at least under that description. Others may be
inclined to call that behavior "packet trapping" when applying it to
e.g. an Ethernet switch.

There might be an entire discussion about how promiscuity does _not_
mean "deliver all packets to the CPU" that might be of interest to you:
https://lkml.org/lkml/2019/8/29/255

> But since my change is more controversial than I anticipated, I would like
> to take a step back and ask some general questions first:
>
> We used to connect something akin to a port mirror to a lan7800 NIC
> (and a few others) in order to record and debug some VLAN heavy traffic.
> On older kernel versions putting the interface into promiscuous mode
> and opening and binding an AF_PACKET socket (or just throwing tcpdump
> or libpcap at it) was sufficient.
> After a kernel upgrade the same setup missed most of the traffic.
> Does this qualify as a regression? Why not?

If something used to work but no longer does, that's what a regression
is. But fixing it depends on whether it should have worked like that in
the first place or not. That we don't know.

> Should there be a documented and future proof way to receive *all*
> valid ethernet frames from an interface?

Yes, there should.

> This could be something like:
>
> a) - Bring up the interface
>    - Put the interface into promiscuous mode

This one would be necessary in order to not drop packets with unknown
addresses, not more.

>    - Open, bind and read a raw AF_PACKET socket with ETH_P_ALL
>    - Patch up the 801.1Q headers if required.

What do you mean by "patching up"? Are you talking about the fact that
packets are untagged by the stack in the receive path anyway, and the
VLAN header would need to be reconstructed?
https://patchwork.ozlabs.org/project/netdev/patch/e06dbb47-2d1c-03ca-4cd7-cc958b6a939e@gmail.com/

>
> b) - The same as a)
>    - Additionally enumerate and disable all available offloading features

If said offloading features have to do with the CPU not receiving some
frames any longer, and you _do_ want the CPU to see them, then obviously
said offloading features should be disabled. This includes not only VLAN
filtering, but also bridging offload, IP forwarding offload, etc.

I'd say that (b) should be sufficient, but not future-proof in the sense
that new offloading features might come every day, and they would need
to be disabled on a case-by-case basis.

For the forwarding offload, there would be no question whatsoever that
you'd need to turn it off, or add a mirroring rule towards the CPU, or
do _something_ user-visible, to get that traffic. But as for VLAN
filtering offload in particular, there's the (not negligible at all)
precedent created by the bridge driver, that Ido pointed out. That would
be a decision for the maintainers to make, if the Linux network stack
creates its own definition of promiscuity which openly contradicts IEEE's.
One might perhaps try to argue that the VLAN ID is an integral part of
the station's address (which is true if you look at it from the
perspective of an IEEE 802.1Q bridge), and therefore promiscuity should
apply on the VLAN ID too, not just the MAC address. Either way, that
should be made more clear than it currently is, once a decision is
taken.

> c) - Use libpcap / Do whatever libpcap does (like with TPACKET)
>    In this case you need to help me convince the tcpdump folks that this
>    is a bug on their side... ;-)

Well, that assumes that today, tcpdump can always capture all traffic on
all types of interfaces, something which is already false (see bridging
offload / IP forwarding offload). There, it was even argued that you'd
better be 100% sure that you want to see all received traffic, as the
interfaces can be very high-speed, and not even a mirroring rule might
guarantee reception of 100% of the traffic. That's why things like sFlow
/ tc-sample exist.

> d) - Read the controller datasheet
>    - Read the kernel documentation
>    - Read your kernels and drivers sources
>    - Do whatever might be necessary

Yes, in general reading is helpful, but I'm not quite sure where you're
going with this?

> e) - No, there is no guaranteed way to to this

No, there should be a way to achieve that through some sort of
configuration.

> Any opinions on these questions?

My 2 cents have just been shared.

> After those are answered, I am open to suggestions on how to fix this
> differently (if still needed).

Turn off VLAN filtering, or get a commonly accepted definition of
promiscuity?
