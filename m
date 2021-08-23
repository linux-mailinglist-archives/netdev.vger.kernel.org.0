Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84DD3F4285
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 02:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhHWAUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 20:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbhHWAUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 20:20:38 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33902C061575;
        Sun, 22 Aug 2021 17:19:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id n12so23490743edx.8;
        Sun, 22 Aug 2021 17:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Zvyi8qDXA1aeE7s7jV5FzFTbtIh5vYTdFv2oFGAnm0k=;
        b=EwlOqtP5XMiGNgrrRJ9diTOojvM1TPvZlDhyBVaG8lsRyWbKfeu9npzkMtisTKfS50
         vXk8QTd4KbvuJZvATHGJAaulo4LgT4rUbl2QBu1vXVHXJ7ZRS3MoGBaJhO0Dj1FChJsb
         GAz9t7mhU1d88aDnO9belAyWaz9nnfqotaW58N4xwEOoJsB3eYwdA6e22YrnwQaseQh6
         b12LS6DTB5RmIKwsDFudEkG4UU2Xvv3XhAe311cs74MaerK/aMXBs9rrO+EkVDQdAkZl
         5vvlIdTyx1kGAc7J2ttvnPHjI5uCU2khUPiXuR5wqyA/fo0KVSc5hWUvR2szOwQYcgwG
         7L2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Zvyi8qDXA1aeE7s7jV5FzFTbtIh5vYTdFv2oFGAnm0k=;
        b=k41OrMyNro2VijPw9i/B31j1UMlYw36BLDHE5fzE8VTZpXSMShdhzH2s/LtUVarIiz
         VqcqOiwD4FSzMG/mWpRDctjh3u1AEG8CFG00w1C8lsOK6qJfNXqSp/fvWYyAhjV4BCPV
         /d/Rv5/oKQmrWUObTN88Qx3dsouZe8JyDou3S+eeByImPH1n2cjLlNCVOwROn3EVt9be
         uOQHdyD4U6MQVum+X/OV4Atz+nn9cKwEIbT7zOxvvlCaaGQWaBZFLzQNzoSt4sl9E08e
         Vusc5zYkD35d0GQrCOZV6HcrLWBR+W34R61azxXdv43IEUBh1y7akZQynnZZV/s8nFoM
         eEKg==
X-Gm-Message-State: AOAM531B+w1XmU06OwzWxT86t3YX1WXdKeXRb9fmAgZ1P9B+2jNdEmFO
        MjIJbMJteCKo+8TWxm0Ndu4=
X-Google-Smtp-Source: ABdhPJx1suXJ7fE+r+qAGn06ZxAi36jqOmisLKVqlGwbDQwgSGdLN+DPjm+B+3wubR2ytuWr+XXoFw==
X-Received: by 2002:a05:6402:70c:: with SMTP id w12mr33555097edx.288.1629677994763;
        Sun, 22 Aug 2021 17:19:54 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id g11sm8153740edt.85.2021.08.22.17.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 17:19:54 -0700 (PDT)
Date:   Mon, 23 Aug 2021 03:19:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20210823001953.rsss4fvnvkcqtebj@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf>
 <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 11:56:04PM +0000, Alvin Šipraga wrote:
> > I'm not going to lie, the realtek_smi_ops VLAN methods seem highly
> > cryptic to me. Why do you do the same thing from .enable_vlan4k as from
> > .enable_vlan? What are these supposed to do in the first place?
> > Or to quote from rtl8366_vlan_add: "what's with this 4k business?"
>
> I think realtek-smi was written with rtl8366rb.c in mind, which appears
> to have different control registers for VLAN and VLAN4k modes, whatever
> that's supposed to mean. Since the RTL8365MB doesn't distinguish between
> the two, I just route one to the other. The approach is one of caution,
> since I don't want to break the other driver (I don't have hardware to
> test for regressions). Maybe Linus can chime in?

You don't _have_ to use the rtl8366 ops for VLAN, especially if they
don't make sense, do you?

> > Also, stupid question: what do you need the VLAN ops for if you haven't
> > implemented .port_bridge_join and .port_bridge_leave? How have you
> > tested them?
>
> I have to admit that I am also in some doubt about that. To illustrate,
> this is a typical configuration I have been testing:
>
>                                br0
>                                 +
>                                 |
>                +----------+-----+-----+----------+
>                |          |           |          |
> (DHCP)         +          +           +          +      (static IP)
>   wan0      brwan0       swp2        swp3     brpriv0      priv0
>    |           + 1 P u    + 1 P u     + 1 P u    +           +
>    |           |          |           | 2        | 2 P u     |
>    |           |          |           |          |           |
>    +-----------+          +           +          +-----------+
>                          LAN         PRIV
>
>           n P u
>           ^ ^ ^
>           | | |
>           | | `--- Egress Untagged
>           | `----- Port VLAN ID (PVID)
>           `------- VLAN ID n

What are priv0 and wan0? Are they local interfaces of your board, put in
loopback with switch ports? Are they external devices?

What does DHCP mean? Is there a server there, or does it mean that the
wan0 interface gets IP over DHCP? Where is the DHCP server? Why is "DHCP"
relevant?

>
> In this configuration, priv0 is used to communicate directly with the
> PRIV device over VLAN2. PRIV can also access the wider LAN by
> transmitting untagged frames. My understanding was that the VLAN
> configuration is necessary for e.g. packets to be untagged properly on
> swp2 egress.

swp2 egresses packets only in VLAN 1. In your example, how would any
packet become tagged in VLAN 1? VLAN 1 is a pvid on all ports which are
members of it.

> But are you suggesting that this is being done in software
> already? I.e. we are sending untagged frames from CPU->switch without
> any VLAN tag?

With the exception of ports with the TX_FWD_OFFLOAD feature where the
VLAN is always left in the packet, the bridge will pop the VLAN ID on
transmission if that VLAN is configured as egress-untagged in the
software VLAN database corresponding to the destination bridge port.
See br_handle_vlan:

	/* If the skb will be sent using forwarding offload, the assumption is
	 * that the switchdev will inject the packet into hardware together
	 * with the bridge VLAN, so that it can be forwarded according to that
	 * VLAN. The switchdev should deal with popping the VLAN header in
	 * hardware on each egress port as appropriate. So only strip the VLAN
	 * header if forwarding offload is not being used.
	 */
	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
	    !br_switchdev_frame_uses_tx_fwd_offload(skb))
		__vlan_hwaccel_clear_tag(skb);

>
> In case you think the VLAN ops are unnecessary given that
> .port_bridge_{join,leave} aren't implemented, do you think they should
> be removed in their entirety from the current patch?

I don't think it's a matter of whether _I_ think that they are
unnecessary. Are they necessary? Are these code paths really exercised?
What happens if you delete them? These are unanswered questions.


My best guess is: you have a problem with transmitting VLAN-tagged
packets on a port, even if that port doesn't offload the bridge
forwarding process. You keep transmitting the packet to the switch as
VLAN-tagged and the switch keeps stripping the tag. You need the VLAN
ops to configure the VLAN 2 as egress-tagged on the port, so the switch
will leave it alone.
It all has to do with the KEEP bit from the xmit DSA header. The switch
has VLAN ingress filtering disabled but is not VLAN-unaware. A standalone
port (one which does not offload a Linux bridge) is expected to be
completely VLAN-unaware and not inject or strip any VLAN header from any
packet, at least not in any user-visible manner. It should behave just
like any other network interface. Packet in, packet out, and the skb
that the network stack sees, after stripping the DSA tag, should look
like the packet that was on the wire (and similarly in the reverse direction).
