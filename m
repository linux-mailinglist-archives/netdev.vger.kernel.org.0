Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D82B97F9
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgKSQ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgKSQ2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:28:31 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DD7C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:28:30 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id i19so8742202ejx.9
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EQuGs1kHxRat/4F0h097dlBF9WHgBZbLLB3v3om/VOc=;
        b=dNLvbXweV1UY+TRvr/rf5G4SECRMCRIkwZlqw9widqSZhr1F8INXO0sWMIoHG9RyDd
         zF84wnmJ2dU96QNam2kPklPMl+ZFmdH5MQboRlzcemUX1E+iYPlxTcYYyBxx5A3L7y9J
         T5BEfvY9R2anAwx8sPu1u51lyFhpdmZ3trnldYwqRTxMczCz96lrfjKcjJcivl7qIkOE
         iguaHgc7env5FGu2lXwueIKoQXl0NgNTFKxZSJ3eK29pPHfrJFUmPFPLzOYwlWmqwiPw
         orDgMM0k0+XxZ0sXKGn6HODN9UpkcOtbADUvxi/dxKaTibs7APD3/Om5F096Krbub9Y5
         /Lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EQuGs1kHxRat/4F0h097dlBF9WHgBZbLLB3v3om/VOc=;
        b=RHTuhD05uKpBmszNBS4mTJ6SjuhvD95L82DOCmau/NNE+lWBRLy/+2gQ5FGRRDqyIc
         pUEadr7sHt5m73gXuqLD7+bUbSjdDncOkRQ2936MSWzEuQzzEawZJjK0ehcHeBl5umEV
         wj0TolEYsM6vhIm+mMh8mqjYWt/oD55zOer78KjlRNLyx7wfHvngLd8qZMDBv8bVGkmn
         edEfwr384miDYqSYy2Vd+HEvRfIxIoGj/E7pCwAeKiKNOE8hL+BE9tFUqhAZM5LQFwcP
         UgIfKpK0D6YYzoUiMxMaeAAqZ67uZFARsDcK+5IB/gQW5bwx1bWeKvjSgrCfiVWckvRX
         ydSg==
X-Gm-Message-State: AOAM530IpxwznU6/FxV+1EUJcJeCglw44gYYEgOKox5b7hpY2FvbZM1B
        Of8uGagikD8m8QGnMohb2ohqlGDHWkU=
X-Google-Smtp-Source: ABdhPJyyFykQWgz9fd42N/RSbjI7hoRXfXVcpbWLuZ0BuU9W25r6iHjfz7qVsWMJ2Hzv2LPpmi3R2w==
X-Received: by 2002:a17:906:b003:: with SMTP id v3mr30937879ejy.290.1605803309372;
        Thu, 19 Nov 2020 08:28:29 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id g7sm15692162edl.5.2020.11.19.08.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 08:28:28 -0800 (PST)
Date:   Thu, 19 Nov 2020 18:28:26 +0200
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
Message-ID: <20201119162826.urnhw4issw2kxens@skbuf>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
 <20201111164727.pqecvbnhk4qgantt@skbuf>
 <20201112105315.o5q3zqk4p57ddexs@ipetronik.com>
 <20201114181103.2eeh3eexcdnbcfj2@skbuf>
 <20201119153751.ix73o5h4n6dgv4az@ipetronik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201119153751.ix73o5h4n6dgv4az@ipetronik.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 04:37:51PM +0100, Markus Blöchl wrote:
> > There might be an entire discussion about how promiscuity does _not_
> > mean "deliver all packets to the CPU" that might be of interest to you:
> > https://lkml.org/lkml/2019/8/29/255
>
> If I glanced over this discussion correctly, it is about avoiding
> promiscuity under certain circumstances (while promiscuity was
> only requested for switching and not by userspace) because HW promiscuity
> is not needed in that particular case.
>
> As I currently see it, there are two common use cases for promiscuity:
>
> 1) Applying filtering, switching and other logic on the CPU.
>    This could be due to limited resources in the NIC, e.g. when there
>    are too many unicast addresses configured on that interface or
>    simply an unavailable hardware capability.
>
> 2) Sniffing the wire.
>
> The kernel uses IFF_PROMISC (or `__dev_set_promiscuity()`) for both,
> which obviously can be overkill in the first case.
> The question remains, what does IFF_PROMISC exactly mean for userspace
> (which, I guess, most often uses it for 2)?

And that discussion ended with the conclusion that promiscuity is never
enough to "sniff the wire".

> > > b) - The same as a)
> > >    - Additionally enumerate and disable all available offloading features
> >
> > If said offloading features have to do with the CPU not receiving some
> > frames any longer, and you _do_ want the CPU to see them, then obviously
> > said offloading features should be disabled. This includes not only VLAN
> > filtering, but also bridging offload, IP forwarding offload, etc.
> >
> > I'd say that (b) should be sufficient, but not future-proof in the sense
> > that new offloading features might come every day, and they would need
> > to be disabled on a case-by-case basis.
> >
> > For the forwarding offload, there would be no question whatsoever that
> > you'd need to turn it off, or add a mirroring rule towards the CPU, or
> > do _something_ user-visible, to get that traffic. But as for VLAN
> > filtering offload in particular, there's the (not negligible at all)
> > precedent created by the bridge driver, that Ido pointed out. That would
> > be a decision for the maintainers to make, if the Linux network stack
> > creates its own definition of promiscuity which openly contradicts IEEE's.
> > One might perhaps try to argue that the VLAN ID is an integral part of
> > the station's address (which is true if you look at it from the
> > perspective of an IEEE 802.1Q bridge), and therefore promiscuity should
> > apply on the VLAN ID too, not just the MAC address. Either way, that
> > should be made more clear than it currently is, once a decision is
> > taken.
>
> In that case, maybe new features which could alter user-visible behaviour
> should not be enabled by default?
> If I am not mistaken, bridging offload, IP forwarding offload and
> similar have to be enabled explicitly, at least.

Uhm, no? If L2 and L3 forwarding offload are supported by the hardware,
the way things work is that said driver simply monitors the user commands
and configures itself to seamlessly perform those operations in hardware.
There isn't a knob that says "I don't want to do bridging in hardware
between these two switchdev interfaces", if the driver implements bridging.

> I am not convinced that this definition would indeed contradict the
> IEEE standard. It might just be a stronger one with more guarantees.
> Assuming you have a very stupid NIC without any filtering or offloading
> capabilities, which would always forward all frames to the CPU.
> Would this NIC not comply to the standard?

I don't understand this.

> > > After those are answered, I am open to suggestions on how to fix this
> > > differently (if still needed).
> >
> > Turn off VLAN filtering, or get a commonly accepted definition of
> > promiscuity?
>
>
> Other Drivers
> =============
>
> So I tried to figure out what other existing hardware drivers do
> by grepping for drivers which do something on a change to
> NETIF_F_HW_VLAN_CTAG_FILTER.
>
> Here are the results of me trying to understand the drivers quickly.
> I hope it's somewhat close and helps:
>
> 1) aqc111
>    This controller has a HW register flag for promiscuous mode.
>    I am not sure what it does, but since this is another ASIX
>    device, the documentation from above should apply.
>
> 2) lan78xx
>    Here it began ...
>
> 3) ixgbe
>    This driver disables HW_VLAN_CTAG_FILTER if IFF_PROMISC is set.
>
> 4) ice
>    I don't know.
>
> 5) ocelot_net
>    This driver does not support promiscuous mode with the following
>    explanation:
> 	/* This doesn't handle promiscuous mode because the bridge core is
> 	 * setting IFF_PROMISC on all slave interfaces and all frames would be
> 	 * forwarded to the CPU port.
> 	 */
>    See the already mentioned discussion https://lkml.org/lkml/2019/8/29/255
>    for more.

The explanation for ocelot is bogus. Ocelot is a switch and it doesn't
implement IFF_PROMISC precisely because of that: a switch port is
promiscuous by definition. Also check out mlxsw_sp_set_rx_mode() in the
mlxsw driver. It is deliberately empty for the same reason.

> 6) liquidio
>    This driver also has a HW flag for promiscuous mode.
>    I don't know what it does, though.
>
> 7) mvpp2
>    This driver disables vid filtering if IFF_PROMISC is set.
>
> 8) efx
> 	/* Disable VLAN filtering by default.  It may be enforced if
> 	 * the feature is fixed (i.e. VLAN filters are required to
> 	 * receive VLAN tagged packets due to vPort restrictions).
> 	 */
>    I did not find a variant that really honors this feature.
>
> 9) ef100
>    I don't know.
>
> 10) mlx5
>    This driver sets a HW promisc flag, adds an `ANY` vlan filter rule
>    and ignores further changes to vlan filtering if IFF_PROMISC is set.
>
> 11) nfp
>    This driver uses a HW promisc flag.
>
> 12) atlantic
>    I don't know.
>
> 13) xlgmac
>    This one has an interesting comment in `xlgmac_set_promiscuous_mode`:
> 	/* Hardware will still perform VLAN filtering in promiscuous mode */
> 	if (enable) {
> 		xlgmac_disable_rx_vlan_filtering(pdata);
> 	} else {
> 		if (pdata->netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
> 			xlgmac_enable_rx_vlan_filtering(pdata);
> 	}
>
> 14) enetc
>    I think, the feature is overridden everytime in `set_rx_mode` as long
>    as IFF_PROMISC is set.

This one was added by me in 7070eea5e95a ("enetc: permit configuration
of rx-vlan-filter with ethtool"). I'll fully admit that I disabled VLAN
filtering when entering IFF_PROMISC out of stupidity, and the main goal
of that patch was something different anyway. I didn't even think of
checking the IEEE 802.3 standard, but then you had to ask :). I'm sure
many more are in the same situation, and it's what led to this chaos.
But I don't have any users that rely on this behavior of IFF_PROMISC,
and if we were to agree on a definition of promiscuity that does not
assume anything about VLAN filtering, I would be more than happy to
delete that code. In fact I've been waiting for this to reach a conclusion
so that I could do that.
