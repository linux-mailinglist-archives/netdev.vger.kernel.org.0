Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAD14967FD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 23:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiAUWty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 17:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiAUWty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 17:49:54 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD32C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:49:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ka4so3903301ejc.11
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=P6gqHv3otn5akYIX5An8ozu/4ZVB3bQK4xXrOnt7dxA=;
        b=DK0zG+etXdL2babBL2oNuAmz3fVb81QXSw6MLqvlZbLlbBaWxGLVIwavmErFXwWhDf
         JxoV7RGp1VPGVMhMAi/fYDIckJayAaurThl5ujd6bD7JWdKmSvLRReStUaGJJvK7Urbo
         Rjc4kVTNJywTNsURI4gu4k5SiOs+0MaACxEzGj6IEmjhB+ndkjmVQ8xWTw9qDAzOaWDY
         LAdgORAhvVPmEca3GRgAr00ohiX5gghae61HG4DOJIk/2ZYWNHGT0sBzxwaD5sOLduGh
         8uE/GG9wX8ycdnI2ddk2bBSCtzIz93lw1OxhKBVfGKsOVxn2ZdLYllv748c/MaiRudam
         1TlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=P6gqHv3otn5akYIX5An8ozu/4ZVB3bQK4xXrOnt7dxA=;
        b=W45tHg9v5XEdKHDZk26Lo9YgjpbT8EV6sqeUHfLcgAxu44jZsI0ByppOM2dlcvijGB
         qfQAdxKh7kG3JJw8oV6w5iu4NxfnK01cHhfhQ+/GtsvdE2E5B9F00LliTOcy+dNqPTPK
         FeIoDySu8CCWM2CfQhxlChnb1fAzoPmclhBs08uQV5ggKA0Xlk1ieLElkU6Dk3zPgti1
         7k37QiU12s0KTynOoCEHfkh2mnRKZMq8Sir956oYYz6k9U4MJNuy68MuhB0W8nFU/KSf
         iRo+F2YX3WjLDImgXNCnh1OFsJ/uxoTpXm0OPK7vQuHsg8y9h10hEAgRYOYTHrWWlvoe
         mtnQ==
X-Gm-Message-State: AOAM531tylvI4xGwNK2KZHe9SqXW1UgrZFQhPtOMb8p9HmFOQyE711Kk
        Tb/v77fm4xhIBOCbzDxB/dI=
X-Google-Smtp-Source: ABdhPJygV4RV+co6TlF0OYP9kzMI/3rst0Qs2w1PA50ujjpIz5vqz7Ku+pDmtPn7Wqf39QPJ5Bp2EQ==
X-Received: by 2002:a17:906:9746:: with SMTP id o6mr4803792ejy.112.1642805392067;
        Fri, 21 Jan 2022 14:49:52 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id p11sm3050557eds.38.2022.01.21.14.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 14:49:51 -0800 (PST)
Date:   Sat, 22 Jan 2022 00:49:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220121224949.xb3ra3qohlvoldol@skbuf>
References: <87v8ynbylk.fsf@bang-olufsen.dk>
 <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch>
 <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 06:51:14PM -0300, Luiz Angelo Daros de Luca wrote:
> The code is from the OpenWrt tree.
> https://github.com/openwrt/openwrt/tree/master/target/linux/ramips/files/drivers/net/ethernet/ralink
> 
> I only patched it to accept Jumbo Frames (it was dropping incoming
> packets with MTU 1508)
> https://patchwork.ozlabs.org/project/openwrt/list/?series=279773
> 
> > If that DSA
> > master is a DSA switch itself, could you please unroll the chain all the
> > way with more links to drivers? No matter whether upstream or downstream,
> > just what you use.
> 
> OpenWrt (soc mt7620a) eth0 (mtk_eth_soc) connected to internal SoC
> MT7530 switch port 6 (, mediatek,mt7620-gsw).
> MT7530 port 5 connected to RTL8367S port 7 (RGMII).
> 
> The internal SoC switch is behaving as an unmanaged switch, with no
> vlans. It would be just extra overhead to have it working as a DSA
> switch, specially
> as those two switches tags are not compatible. I still have the
> swconfig driver installed but I was only using it for some debugging
> (checking metrics). I think that the state the bootloader leaves that
> switchis enough to make it forward packets to the Realtek switch. In
> device-tree conf, I'm directly using that eth0 as the CPU port.

There could be value in managing the internal switch with DSA too, for
example in a situation like this:

 +-------------------------------------------------+
 |  SoC                                            |
 |                                                 |
 |  +----------------+--------+---------------+    |
 |  |                |        |               |    |
 |  | Internal       |        |               |    |
 |  |  switch        +--------+               |    |
 |  | (dsa,member = <0 0>;)                   |    |
 |  | +-------+ +-------+ +-------+ +-------+ |    |
 |  | |       | |       | |       | |       | |    |
 |  | | sw0p0 | | sw0p1 | | sw0p2 | | sw0p3 | |    |
 |  | |       | |       | |       | |       | |    |
 +--+-+-------+-+-------+-+-------+-+-------+-+----+

 +----+--------+------------------+
 |    |        |                  |
 |    +--------+                  |
 | External switch                |
 | (dsa,member = <1 0>;)          |
 |  +-------+ +-------+ +-------+ |
 |  |       | |       | |       | |
 |  | sw1p0 | | sw1p1 | | sw1p2 | |
 |  |       | |       | |       | |
 +--+-------+-+-------+-+-------+-+

where you'd create a bridge spanning all of sw0p1, sw0p2, sw0p3, sw1p0,
sw1p1, sw1p2. Forwarding between the internal and the external switch is
done in software, and that deals with the "impedance matching" between
the tagging protocols too - first the packet is stripped of the DSA tag
of the ingress switch, then the DSA tag of the egress switch is added.
With a transparent internal switch (no driver), ports sw0p1, sw0p2,
sw0p3 are dead, since if you'd connect them to a PHY, they'd spit out
DSA-tagged packets from the external switch.

> > I hate to guess, but since both you and Arınç have mentioned the
> > mt7620a/mt7621 SoCs,
> 
> Sorry for the incomplete answer. If it helps, this is my device
> https://github.com/luizluca/openwrt/blob/tplink_c5v4_dsa/target/linux/ramips/dts/mt7620a_tplink_archer-c5-v4.dts
> 
> I try to keep my remote branch updated, although it has some dirty changes:
> https://github.com/luizluca/openwrt/tree/tplink_c5v4_dsa
> 
> > I'd guess that the top-most DSA driver in both cases is "mediatek,eth-mac" (drivers/net/ethernet/mediatek/mtk_eth_soc.c).
> 
> Not in my case. The driver I use also supports mt7621 but the upstream
> driver skipped the mt7620a support.
> 
> > If so, this would confirm my suspicions, since it sets its vlan_features
> > to include NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Please confirm that
> > master->vlan_features contains these 2 bits.
> 
> Yes.

Ok. See the discussion with Lino Sanfilippo here:
https://lore.kernel.org/netdev/YPAzZXaC%2FEn3s4ly@lunn.ch/
Basically, the moving parts of this mechanism are:

- when the DSA master doesn't understand DSA tags, the transmit
  checksums must be calculated in software.

- this is already supported, we just need to make sure that the DSA
  slave->features does not include any checksum offload bits
  (NETIF_F_HW_CSUM, NETIF_F_IP_CSUM, NETIF_F_IPV6_CSUM), otherwise that
  will be delegated to the device driver. The place that checks that
  condition and calculates the checksum in software is validate_xmit_skb() ->
  skb_csum_hwoffload_help().

- the checksum is evaluated on the skb before the DSA tag is even
  inserted, and is preserved when DSA inserts the header, and is
  therefore still correct by the time the skb reaches the DSA master
  driver. A DSA-unaware master doesn't have to do anything for this
  packet, the IP header checksum will still be correct despite the
  hardware not recognizing the IP header.

- the way DSA populates slave->features is by inheriting master->vlan_features
  (vlan_features means "netdev features which are inheritable by VLAN
  upper interfaces"). This directly makes or breaks what happens in
  validate_xmit_skb() on a DSA slave interface.

- the problem occurs when the DSA master puts checksum offload bits in
  both dev->features and dev->vlan_features. The master thinks this
  means: "I can offload IP checksumming for myself and for VLAN upper
  interfaces (I can recognize the IP header past the VLAN header)."
  Little does it know that DSA assumes this means it can also offload
  checksumming in the presence of switch tags.

So just stop inheriting NETIF_F_HW_CSUM and friends from
master->vlan_features, right?

Well, you can't help but wonder a bit how come it's 2022 and we could
still have an obvious omission like that? And at the same time: but why
does the mt7530 DSA driver work with the same DSA master, but not rtl8365mb?
The answer to both, I think, is "some DSA masters do understand a
particular DSA switch tag, particularly the one from the same vendor".
So if we stop inheriting the checksum offload bits from vlan_features,
we introduce a performance regression for those.

We should instead ask the DSA master "for this DSA tagging protocol,
what netdev features can DSA inherit"? Because of the variability per
tagging protocol, this probably needs to be done through a new netdev
operation, I don't know of any cleaner way.
The complicated part is that we'd need to correctly identify the pairs
of DSA master drivers and tagging protocols where some features can be
safely inherited. Then, it's not too clear whether we want this new ndo
to cover other functionality as well, or if netdev features are enough.

So the sad news for you is that this is pretty much "net-next" material,
even if it fixes what is essentially a design shortcoming. If we're
quick, we could start doing this right as net-next reopens, and that
would give other developers maximum opportunity to fix up the
performance regressions caused by lack of TX checksumming.

> > > Oh, this DSA driver still does not implement vlan nor bridge offload.
> > > Maybe it would matter.
> >
> > It doesn't matter. The vlan_features is a confusing name for what it
> > really does here. I'll explain in a bit once you clarify the other
> > things I asked for.
> 
> That is good news as we can deal with it independently. I wish to
> focus on that afterwards.
> 
> Regards,
> 
> Luiz
