Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33430100357
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKRLBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:01:46 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35898 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRLBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:01:46 -0500
Received: by mail-ed1-f67.google.com with SMTP id f7so13152873edq.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 03:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n4p66o6shAzxc3EfvASnPrOC5vuqGyYdywBM6tT72Fg=;
        b=jnMVbEm2G3VI4WHJo8oOfA6/ZNJ9z/yC3JdnFVv6PMMLfsTO8P3XP1SQL7Y6u1j9i5
         d8nKQzWrCeN1AhvZO+JGA99xFDWU9mLRYmkH4B4LofbnFILmI5bHTScGOkwgzA23XvTz
         pnudVTU2VZpUlcXm/QUMTVaB18jJfTsN/0l3CGXc/e4rjrQJrU94o+dnUe3pwOUwzlmW
         CX1P4NmC2e+opPWnG8UFwqKml314mORg+XoABUcNhV5Z0aIKILssiz2NWqgP8OPnXnkr
         tg9XIDkrTwivEwjHzmNs0iYRh9dmroj9u3nS5tGxXuw4XEl6ULmrA0/G2llwuEGY9Ex5
         MPxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n4p66o6shAzxc3EfvASnPrOC5vuqGyYdywBM6tT72Fg=;
        b=cQtOVSAHdDyxGpR4QfcYnyxR+PDm6LI7yhgCtOiWVIpTEfWtBdlKxeC4rmE0/09An+
         kTOx2JL4ae7W6BfW2vpJHTU0MCHZZpDlobQLhC6zDLdn2UhD1T3lE3BlYecHfSSmSWXf
         PEv0NyOK91X8SB0cvAX2q8Qb8dpGrxYPCaMbNB/AhfecKy75XkP3C0GgR/WxGLpKq/Du
         0BW+1N4ScA3V3h7QsbZSaP4of1xzKrNuf4DZ3bhK+8i/fMpVvX0tVR7Qid90CNDhLRsc
         x1nEXJldtd1yRiiFDel0xPm6cf7n18qJVarETczNxvo0mnxmOfxwQ22dHqrL1Zo6RTql
         4Rcw==
X-Gm-Message-State: APjAAAXEuu3JDB00Me3JqKecaqFoZikgPqP6kCagBZKfFWMYcjcTWSn6
        CKHr7J3iCrWuq3u19h4AiKPTV+TLJZmPR9lqRR0=
X-Google-Smtp-Source: APXvYqzGkPSexzDZp5gsq9KDbSyyWu7yE8VGCb6SW05MDwhEFskG3QcwnLMwRt7GonzUQ+/kZh5R5M+M04qrlAp23iQ=
X-Received: by 2002:a17:906:1d19:: with SMTP id n25mr25151511ejh.151.1574074903975;
 Mon, 18 Nov 2019 03:01:43 -0800 (PST)
MIME-Version: 1.0
References: <20191117211407.9473-1-olteanv@gmail.com> <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
In-Reply-To: <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 18 Nov 2019 13:01:32 +0200
Message-ID: <CA+h21hoTFBszBhQyFFsFHmBDRFR2ct+gx=XkKTTjkLL82evajg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: tag_8021q: Allow DSA tags and VLAN
 filtering simultaneously
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Nov 2019 at 06:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 11/17/2019 1:14 PM, Vladimir Oltean wrote:
> > There are very good reasons to want this (see documentation reference to
> > br_if.c), and there are also very good reasons for not enabling it by
> > default. So a devlink param named best_effort_vlan_filtering, currently
> > driver-specific and exported only by sja1105, is used to configure this.
> >
> > In practice, this is perhaps the way that most users are going to use
> > the switch in. Best-effort untagged traffic can be bridged with any net
> > device in the system or terminated locally, and VLAN-tagged streams are
> > forwarded autonomously in a time-sensitive manner according to their
> > PCP (they need not transit the CPU). For those cases where the CPU needs
> > to terminate some VLAN-tagged traffic, using the DSA master is still an
> > option.
> >
> > A complication while implementing this was the fact that
> > __netif_receive_skb_core calls __vlan_hwaccel_clear_tag right before
> > passing the skb to the DSA packet_type handler. This means that the
> > tagger does not see the VLAN tag in the skb, nor in the skb meta data.
> > The patch that starting zeroing the skb VLAN tag is:
> >
> >   commit d4b812dea4a236f729526facf97df1a9d18e191c
> >   Author: Eric Dumazet <edumazet@google.com>
> >   Date:   Thu Jul 18 07:19:26 2013 -0700
> >
> >       vlan: mask vlan prio bits
> >
> >       In commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e
> >       ("vlan: don't deliver frames for unknown vlans to protocols")
> >       Florian made sure we set pkt_type to PACKET_OTHERHOST
> >       if the vlan id is set and we could find a vlan device for this
> >       particular id.
> >
> >       But we also have a problem if prio bits are set.
> >
> >       Steinar reported an issue on a router receiving IPv6 frames with a
> >       vlan tag of 4000 (id 0, prio 2), and tunneled into a sit device,
> >       because skb->vlan_tci is set.
> >
> >       Forwarded frame is completely corrupted : We can see (8100:4000)
> >       being inserted in the middle of IPv6 source address :
> >
> >       16:48:00.780413 IP6 2001:16d8:8100:4000:ee1c:0:9d9:bc87 >
> >       9f94:4d95:2001:67c:29f4::: ICMP6, unknown icmp6 type (0), length 64
> >              0x0000:  0000 0029 8000 c7c3 7103 0001 a0ae e651
> >              0x0010:  0000 0000 ccce 0b00 0000 0000 1011 1213
> >              0x0020:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
> >              0x0030:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
> >
> >       It seems we are not really ready to properly cope with this right now.
> >
> >       We can probably do better in future kernels :
> >       vlan_get_ingress_priority() should be a netdev property instead of
> >       a per vlan_dev one.
> >
> >       For stable kernels, lets clear vlan_tci to fix the bugs.
> >
> >       Reported-by: Steinar H. Gunderson <sesse@google.com>
> >       Signed-off-by: Eric Dumazet <edumazet@google.com>
> >       Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > The patch doesn't say why "we are not really ready to properly cope with
> > this right now", and hence why the best solution is to remove the VLAN
> > tag from skb's that don't have a local VLAN sub-interface interested in
> > them. And I have no idea either.
> >
> > But the above patch has a loophole: if the VLAN tag is not
> > hw-accelerated, it isn't removed from the skb if there is no VLAN
> > sub-interface interested in it (our case). So we are hooking into the
> > .ndo_fix_features callback of the DSA master and clearing the rxvlan
> > offload feature, so the DSA tagger will always see the VLAN as part of
> > the skb data. This is symmetrical with the ETH_P_DSA_8021Q case and does
> > not need special treatment in the tagger. But perhaps the workaround is
> > brittle and might break if not understood well enough.
> >
> > The disabling of the rxvlan feature of the DSA master is unconditional.
> > The reasoning is that at first sight, no DSA master with regular frame
> > parsing abilities could be able to locate the VLAN tag with any of the
> > existing taggers anyway, and therefore, adding a property in dsa_switch
> > to control the rxvlan feature of the master would seem like useless
> > boilerplate.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
>
> [snip]
>
> > +best_effort_vlan_filtering
> > +                     [DEVICE, DRIVER-SPECIFIC]
> > +                     Allow plain ETH_P_8021Q headers to be used as DSA tags.
> > +                     Benefits:
> > +                     - Can terminate untagged traffic over switch net
> > +                       devices even when enslaved to a bridge with
> > +                       vlan_filtering=1.
> > +                     - Can do QoS based on VLAN PCP for autonomously
> > +                       forwarded frames.
> > +                     Drawbacks:
> > +                     - User cannot change pvid via 'bridge' commands. This
> > +                       would break source port identification on RX for
> > +                       untagged traffic.
> > +                     - User cannot use VLANs in range 1024-3071. If the
> > +                       switch receives frames with such VIDs, it will
> > +                       misinterpret them as DSA tags.
> > +                     - Cannot terminate VLAN-tagged traffic on local device.
> > +                       There is no way to deduce the source port from these.
> > +                       One could still use the DSA master though.
>
> Could we use QinQ to possibly solve these problems and would that work
> for your switch? I do not really mind being restricted to not being able
> to change the default_pvid or have a reduced VLAN range, but being able
> to test VLAN tags terminated on DSA slave network devices is a valuable
> thing to do.
> --
> Florian

Hi Florian,

Unfortunately the sja1105 supports only detecting double-tagged
frames. It doesn't have the concept of pushing/popping an S-tag on top
of frames detected as having a C-tag. A workaround would be to lie to
it about the C-tag EtherType, so it will push an S-tag unconditionally
(thinking VLAN-tagged frames are untagged, therefore pushing the
802.1ad pvid), but then you lose VLAN filtering based on the C-tag. To
be fair I don't completely understand the Linux abstraction of a
bridge with vlan_protocol 802.1ad either. It seems to me like such a
bridge would ignore the C-tag and treat those frames as untagged,
basically operating only at the S-tag level very similar to the
workaround I would have to do in sja1105. But a correct implementation
would have to do VLAN filtering based on the C-tag, and _in addition_
push an 802.1ad unique pvid (C-tag).
But I digress. The sja1105 doesn't support stacked VLANs so that is
part of the reason why I made dsa_8021q more flexible (just functions
that can be called from other drivers/taggers) and less tied to
sja1105. I would be happy to see this tagger getting used with stacked
VLANs as long as the hardware permits it.

Hope this helps,
-Vladimir
