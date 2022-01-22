Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD31496DE3
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 21:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiAVUMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 15:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiAVUMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 15:12:40 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A3CC06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 12:12:40 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id p37so12073169pfh.4
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 12:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I2brbOqQKbQwT5a05Y5Xrk2836KZMhFr4L3SJA7PnzQ=;
        b=W86n1xn43vN1rVj3ugzi351xvkwPDnlbqLC23Gl8RHzhc228Ga6a5MLcqqVmLqqJIy
         4CUu5cl0WLr/vJj1sgEcBG8u4UY20/yDUJOVsjLtc4wWRJY3pWz4ys3b6X86e1GbHFPs
         ATpWRpq25+ovz2d4SwnKXQujD2rPNurWZVCoNtP3dc3Y/V7gtAaEQyqeirtXZyznKL5A
         ISuUyLcvqPFqCjdl5nj/nzk2iMcIk5XlNp5kMAUfKqfJq0RRJqIOH2ztcBmPzFdSE6Dl
         X+/cw2l+/DKxitT+E28+AEFfKL4TicH3q4n5jzjvHVGHMwCzwZ4/scEhyUzLQRipr0J0
         lW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I2brbOqQKbQwT5a05Y5Xrk2836KZMhFr4L3SJA7PnzQ=;
        b=niABsxPNq9uJ7/+eVlyHkuPEbfAogIMI6Wxm7I5rGVjNL8jQb229ywjtT22GCuUiW/
         bThHEx9Tu3TwQ+gRhMYhQ0YpSJ409r5Y/SQeItfxxDX3lnxZVddtKsW8DPRjEjRLpvw1
         gGn/CoElrsi3BeIZtZ7tVwieKAz9uV8cRcUwIvLjcn57v3DYB3rUAK1vuOGtJX/T5tHq
         CoxIruAMPruVnBV6K+MOq7w/Z4ohmX3aXNndt94vqzUymI0YR0aoyRWU9BOyIu4Kj5Qu
         FTuRy2Qq4wNAnJX/tqEwEar0Do3tASlqfNpdDHk4VK4jpvt6PrfK58VZv9UVidoc3TNP
         SwzQ==
X-Gm-Message-State: AOAM532wRiVF1IT8TcrvUkeup4mP7igROGbyJz84Keg1ehEIVJmq+cE7
        vBB2PZkJlfS+VFCIIhnqanX/BQWR8N6mxvrT9xM=
X-Google-Smtp-Source: ABdhPJzxMtglWMX57CCNxUmrvnCz8YixuzC3ePUbd64iYiagMf83bvMtRg0P0iLv+6q2mbFm8O5bkQj9kk+qoKClPZg=
X-Received: by 2002:a05:6a00:b90:b0:4c5:ee92:1230 with SMTP id
 g16-20020a056a000b9000b004c5ee921230mr8356682pfj.21.1642882359903; Sat, 22
 Jan 2022 12:12:39 -0800 (PST)
MIME-Version: 1.0
References: <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
 <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
 <20220121020627.spli3diixw7uxurr@skbuf> <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf> <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
In-Reply-To: <20220121224949.xb3ra3qohlvoldol@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 22 Jan 2022 17:12:28 -0300
Message-ID: <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The internal SoC switch is behaving as an unmanaged switch, with no
> > vlans. It would be just extra overhead to have it working as a DSA
> > switch, specially
> > as those two switches tags are not compatible. I still have the
> > swconfig driver installed but I was only using it for some debugging
> > (checking metrics). I think that the state the bootloader leaves that
> > switchis enough to make it forward packets to the Realtek switch. In
> > device-tree conf, I'm directly using that eth0 as the CPU port.
>
> There could be value in managing the internal switch with DSA too, for
> example in a situation like this:
>
>  +-------------------------------------------------+
>  |  SoC                                            |
>  |                                                 |
>  |  +----------------+--------+---------------+    |
>  |  |                |        |               |    |
>  |  | Internal       |        |               |    |
>  |  |  switch        +--------+               |    |
>  |  | (dsa,member =3D <0 0>;)                   |    |
>  |  | +-------+ +-------+ +-------+ +-------+ |    |
>  |  | |       | |       | |       | |       | |    |
>  |  | | sw0p0 | | sw0p1 | | sw0p2 | | sw0p3 | |    |
>  |  | |       | |       | |       | |       | |    |
>  +--+-+-------+-+-------+-+-------+-+-------+-+----+
>
>  +----+--------+------------------+
>  |    |        |                  |
>  |    +--------+                  |
>  | External switch                |
>  | (dsa,member =3D <1 0>;)          |
>  |  +-------+ +-------+ +-------+ |
>  |  |       | |       | |       | |
>  |  | sw1p0 | | sw1p1 | | sw1p2 | |
>  |  |       | |       | |       | |
>  +--+-------+-+-------+-+-------+-+
>
> where you'd create a bridge spanning all of sw0p1, sw0p2, sw0p3, sw1p0,
> sw1p1, sw1p2. Forwarding between the internal and the external switch is
> done in software, and that deals with the "impedance matching" between
> the tagging protocols too - first the packet is stripped of the DSA tag
> of the ingress switch, then the DSA tag of the egress switch is added.
> With a transparent internal switch (no driver), ports sw0p1, sw0p2,
> sw0p3 are dead, since if you'd connect them to a PHY, they'd spit out
> DSA-tagged packets from the external switch.

Oh, any other internal switch ports are physically not in use.  Those
ports are 10/100. I think that in my device, some of its pins are even
used as GPIO.
And the offload issue will remain as the HW will not be able to
offload the second layer of DSA tag.

> > > I hate to guess, but since both you and Ar=C4=B1n=C3=A7 have mentione=
d the
> > > mt7620a/mt7621 SoCs,
> >
> > Sorry for the incomplete answer. If it helps, this is my device
> > https://github.com/luizluca/openwrt/blob/tplink_c5v4_dsa/target/linux/r=
amips/dts/mt7620a_tplink_archer-c5-v4.dts
> >
> > I try to keep my remote branch updated, although it has some dirty chan=
ges:
> > https://github.com/luizluca/openwrt/tree/tplink_c5v4_dsa
> >
> > > I'd guess that the top-most DSA driver in both cases is "mediatek,eth=
-mac" (drivers/net/ethernet/mediatek/mtk_eth_soc.c).
> >
> > Not in my case. The driver I use also supports mt7621 but the upstream
> > driver skipped the mt7620a support.
> >
> > > If so, this would confirm my suspicions, since it sets its vlan_featu=
res
> > > to include NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Please confirm that
> > > master->vlan_features contains these 2 bits.
> >
> > Yes.
>
> Ok. See the discussion with Lino Sanfilippo here:
> https://lore.kernel.org/netdev/YPAzZXaC%2FEn3s4ly@lunn.ch/
> Basically, the moving parts of this mechanism are:
>
> - when the DSA master doesn't understand DSA tags, the transmit
>   checksums must be calculated in software.
>
> - this is already supported, we just need to make sure that the DSA
>   slave->features does not include any checksum offload bits
>   (NETIF_F_HW_CSUM, NETIF_F_IP_CSUM, NETIF_F_IPV6_CSUM), otherwise that
>   will be delegated to the device driver. The place that checks that
>   condition and calculates the checksum in software is validate_xmit_skb(=
) ->
>   skb_csum_hwoffload_help().
>
> - the checksum is evaluated on the skb before the DSA tag is even
>   inserted, and is preserved when DSA inserts the header, and is
>   therefore still correct by the time the skb reaches the DSA master
>   driver. A DSA-unaware master doesn't have to do anything for this
>   packet, the IP header checksum will still be correct despite the
>   hardware not recognizing the IP header.
>
> - the way DSA populates slave->features is by inheriting master->vlan_fea=
tures
>   (vlan_features means "netdev features which are inheritable by VLAN
>   upper interfaces"). This directly makes or breaks what happens in
>   validate_xmit_skb() on a DSA slave interface.
>
> - the problem occurs when the DSA master puts checksum offload bits in
>   both dev->features and dev->vlan_features. The master thinks this
>   means: "I can offload IP checksumming for myself and for VLAN upper
>   interfaces (I can recognize the IP header past the VLAN header)."
>   Little does it know that DSA assumes this means it can also offload
>   checksumming in the presence of switch tags.
>
> So just stop inheriting NETIF_F_HW_CSUM and friends from
> master->vlan_features, right?
>
> Well, you can't help but wonder a bit how come it's 2022 and we could
> still have an obvious omission like that? And at the same time: but why
> does the mt7530 DSA driver work with the same DSA master, but not rtl8365=
mb?
> The answer to both, I think, is "some DSA masters do understand a
> particular DSA switch tag, particularly the one from the same vendor".
> So if we stop inheriting the checksum offload bits from vlan_features,
> we introduce a performance regression for those.
>
> We should instead ask the DSA master "for this DSA tagging protocol,
> what netdev features can DSA inherit"? Because of the variability per
> tagging protocol, this probably needs to be done through a new netdev
> operation, I don't know of any cleaner way.
> The complicated part is that we'd need to correctly identify the pairs
> of DSA master drivers and tagging protocols where some features can be
> safely inherited. Then, it's not too clear whether we want this new ndo
> to cover other functionality as well, or if netdev features are enough.

I'm new to DSA but I think that a solution like that might not scale
well. For every possible master network driver, it needs to know if
its offload feature will handle every different tag.
Imagining that both new offload HW and new switch tags will still
appear in the kernel, it might be untreatable.

I know dsa properties are not the solution for everything (and I'm
still adapting to where that border is) but, in this case, it is a
device specific arrangement between the ethernet device and the
switch. Wouldn't it be better to allow the
one writing the device-tree description inform if a master feature
cannot be copied to slave devices?

I checked DSA doc again and it says:

"Since tagging protocols in category 1 and 2 break software (and most
often also hardware) packet dissection on the DSA master, features
such as RPS (Receive Packet Steering) on the DSA master would be
broken. The DSA framework deals with this by hooking into the flow
dissector and shifting the offset at which the IP header is to be
found in the tagged frame as seen by the DSA master. This behavior is
automatic based on the overhead value of the tagging protocol. If not
all packets are of equal size, the tagger can implement the
flow_dissect method of the struct dsa_device_ops and override this
default behavior by specifying the correct offset incurred by each
individual RX packet. Tail taggers do not cause issues to the flow
dissector."

It makes me think that it is the master network driver that does not
implement that IP header location shift. Anyway, I believe it also
depends on HW capabilities to inform that shift, right?

I'm trying to think as a DSA newbie (which is exactly what I am).
Differently from an isolated ethernet driver, with DSA, the system
does have control of "something" after the offload should be applied:
the dsa switch. Can't we have a generic way to send a packet to the
switch and make it bounce back to the CPU (passing through the offload
engine)? Would it work if I set the destination port as the CPU port?
This way, we could simply detect if the offload worked and disable
those features that did not work. It could work with a generic
implementation or, if needed, a specialized optional ds_switch_ops
function just to setup that temporary lookback forwarding rule.

> So the sad news for you is that this is pretty much "net-next" material,
> even if it fixes what is essentially a design shortcoming. If we're
> quick, we could start doing this right as net-next reopens, and that
> would give other developers maximum opportunity to fix up the
> performance regressions caused by lack of TX checksumming.

No problem. I'm already playing the long game. I'm just trying to fix
a device I own using my free time and I don't have any manager with
impossible deadlines.
However, any solution with a performance regression would break the
kernel API. I would rather add a new device-tree option :-)

> > > > Oh, this DSA driver still does not implement vlan nor bridge offloa=
d.
> > > > Maybe it would matter.
> > >
> > > It doesn't matter. The vlan_features is a confusing name for what it
> > > really does here. I'll explain in a bit once you clarify the other
> > > things I asked for.
> >
> > That is good news as we can deal with it independently. I wish to
> > focus on that afterwards.
> >
> > Regards,
> >
> > Luiz
