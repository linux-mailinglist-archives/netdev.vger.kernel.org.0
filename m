Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87544070B8
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 19:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhIJR6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 13:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbhIJR6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 13:58:38 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705F1C061574
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 10:57:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id e21so5830674ejz.12
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 10:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aX6xqhZ707tbGJ4dJhvsaHDVvLSBtZnsf82sgv9JTBE=;
        b=e8dqCD++kfgjO/ZfD7noIv3I98a8DHOcjxH2jMyHZm8Ju4ZQPeHNeTd/m/WEVjVHCt
         XC8fF3cd6nFBZkg2HrNCbCOrZw9sbW69z+Lfi4vavSpO0VIuARgTxo9ZTzMnboResf83
         Xn0RsZyWNEcnIorWdw+SIT2PJOu3BWZeKELGM9h/zabeMoSYWTmz85kXHmS0kCoEdrsq
         97Sb8gTJ9rdRSQf4fsR40Qc4TwC4DfKD61AeuU8MT2nX9chCEu7I3HeVioAaycv1EoaC
         XlK+zy/r7OW0Oc4xCZ2KnO+VUqCaCIFWX8pZOi25tBypaXHS8dzgxMB2RnuKIsacQ6IF
         MEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aX6xqhZ707tbGJ4dJhvsaHDVvLSBtZnsf82sgv9JTBE=;
        b=xeFMxphDPaEKhmh/cxcDNmir4/WrSDJtmnv4AqcgiZC2tov0HWKPA6RYrw00oZlEug
         GqzZXwj8cTohxzAA4E40a+RD0TOXKp0dN05b8YCiw4oV35BKCF862jGZ4JFezQAU9SV1
         3zLZb3lNxeR+4QCyT8wwsXJtbrWrmR0VuDu32eQ34ikX50WtlJBadG2ZTLpkChLbPNhF
         2nlIIotQeCD6OgssWaLLsJa+E4SIZLAI49NW0K+AzJWuyBcI0JFOUH9ZNNEhGSf3PFF6
         w/oS4XX7ujjdS3HJWVRod+v6Bc4g2++LWk8IwAYGFLiRnmqIcPrmIB9wWA2sCj17njEx
         5vmg==
X-Gm-Message-State: AOAM531FtbieraCP+pbQLv7yjz5eJt3+NyJo8nH+PQz+4qGy6sK/mjzU
        soecqlZRE9tszmCQS8yj0Dk=
X-Google-Smtp-Source: ABdhPJwur6z4bkjttjJWDFoRlAWsSu83ySi5vPllCKZfFLVGEyij+4zF2DNWujCoyI6pxUua+EIFDg==
X-Received: by 2002:a17:906:3159:: with SMTP id e25mr10491022eje.549.1631296645922;
        Fri, 10 Sep 2021 10:57:25 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id dh16sm2869088edb.63.2021.09.10.10.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 10:57:25 -0700 (PDT)
Date:   Fri, 10 Sep 2021 20:57:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
Message-ID: <20210910175724.tc2tyxihsetvvsjd@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-6-linus.walleij@linaro.org>
 <20210830224626.dvtvlizztfaazhlf@skbuf>
 <CACRpkdb7yhraJNH=b=mv=bE7p6Q_k-Yy0M9YT9QctKC1GLhVEw@mail.gmail.com>
 <20210908201032.nzej3btytfhfta2u@skbuf>
 <CACRpkdbgq5o3au1LHUM9Ep2B3syB+r-3=vBan1obL5Z4cekBqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbgq5o3au1LHUM9Ep2B3syB+r-3=vBan1obL5Z4cekBqA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 03:59:18PM +0200, Linus Walleij wrote:
> On Wed, Sep 8, 2021 at 10:10 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > Your interpretation seems correct (I can't think of anything else being meant),
> > but I don't know why you say "duh" about the update of STP state
> > resulting in the port losing its dynamic L2 entries. Sure, it makes
> > sense, but many other vendors do not do that automatically, and DSA
> > calls .port_fast_age whenever the STP state transitions from a value
> > capable of learning (LEARNING, FORWARDING) to one incapable of learning
> > (DISABLED, BLOCKING, LISTENING).
> >
> > To prove/disprove, it would be interesting to implement port STP states,
> > without implementing .port_fast_age, force a port down and then back up,
> > and then run "bridge fdb" and see whether it is true that STP state
> > changes also lead to FDB flushing but at a hardware level (whether there
> > is any 'self' entry being reported).
>
> I have been looking into this.
>
> What makes RTL8366RB so confusing is a compulsive use of FIDs.

It's not confusing, it's great, and I'm glad that you're around and
willing to spend some time so we can discuss this.

> For example Linux DSA has:
>
> ds->ops->port_stp_state_set(ds, port, state);
>
> This is pretty straight forward. The vendor RTL8366RB API however has this:
>
> int32 rtl8368s_setAsicSpanningTreeStatus(enum PORTID port, enum
> FIDVALUE fid, enum SPTSTATE state)
>
> So this is set per FID instead of per VID.

It's per {port,FID} actually. It is useful in case you want to support
MSTP (STP per VLAN, your port is BLOCKING in one VLAN but FORWARDING in
another)

> I also looked into proper FDB support and there is the same problem.
> For example I want to implement:
>
> static int rtl8366rb_port_fdb_add(struct dsa_switch *ds, int port,
>                   const unsigned char *addr, u16 vid)
>
> But the FDB static (also autolearn) entries has this format:
>
> struct l2tb_macstatic_st{
>     ether_addr_t     mac;
>     uint16     fid:3;
>     uint16     reserved1:13;
>     uint16     mbr:8;
>     uint16     reserved2:4;
>     uint16    block:1;
>     uint16     auth:1;
>     uint16     swst:1;
>     uint16     ipmulti:1;
>     uint16     reserved3;
> };
>
> (swst indicates a static entry ipmulti a multicast entry, mbr is apparently
> for S-VLAN, which I'm not familiar with.)
>
> So again using a FID rather than port or VID in the database.
>
> I am starting to wonder whether I should just associate 1-1 the FID:s
> with the 6 ports (0..5) to simplify things. Or one FID per defined VID
> until they run out, as atleast OpenWRT connects VLAN1 to all ports on
> a bridge.

No, don't rush it/hack it. A FID is basically the domain in which your
L2 lookup table will find a destination MAC address.

When every port has a unique FID and they are under the same bridge, one
port will never be able to find an L2 lookup table entry learned on
another port, because that other port has learned it in another FID.
That's not what you want.

On the other hand, when a port is standalone, you very much want packets
received from that port to go _only_ towards the CPU [ via flooding ],
and have no temptation at all to even try to forward that packet towards
another switch port. So standalone ports should not have the same FID as
ports that are in a bridge.

As for bridges, what FID to use?

Well, in the case of a VLAN-unaware bridge, you can configure all ports
of that bridge to use the same FID. So the FDB lookup will find entries
learned on ports that are members of the same bridge, but not entries
learned on ports that are members of other bridges.

In the case of a VLAN-aware bridge, you have two choices.

You can do the same thing as in the case of VLAN-unaware bridges, and
this will turn your switch into an 802.1Q bridge with Shared VLAN
Learning (SVL). This means that a packet will effectively be forwarded
only based on MAC DA, the VLAN ID will be ignored when performing the
FDB lookup (because the FDB lookup in your hw is actually per FID, and
we made a 1:1 association between the FID and the _bridge_, not the
_bridge_VLAN_). So you can never have two stations with the same MAC
address in different VLANs, that would confuse your hardware.

The second approach is to associate every {bridge, VLAN} pair with a
different hardware FID. This will turn your switch into an 802.1Q
Independent VLAN Learning (IVL) bridge, so you can have multiple
stations attached to the same bridge, having the same MAC address, but
they are in different VLANs, so your hardware will keep separate FDB
entries for them and they will not overlap (if your bridge was SVL,
there would be a single FDB entry for both stations, and it would bounce
from one port to another).

So in both cases, VLAN 1 of bridge br0 maps to a different FID compared
to VLAN 1 of bridge br1. That is the point. The difference is that:

- with SVL, VLAN 1, 2, 3, 4 .... of br0 all map to the same FID.
- with IVL, VLAN 1, 2, 3, 4 ... of br0 map to different FIDs.

The obvious limitation to the second approach is the number of VLANs you
can support, it is limited by the number of hardware FIDs. In your
switch, that seems to be 8, so not a lot.

So IMO, I would go for a SVL approach.

What I would do is start with these patches:
https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/

I will resubmit them (actually slightly modified variants) during the
first weeks of the next kernel development cycle.

Check out what changes in the .port_fdb_add function prototype, and see
how you can map that new "bridge_num" argument to a FID. Also check out
how other drivers make use of FIDs (search for FID_STANDALONE and
FID_BRIDGED in the mt7530 driver). That driver only performs FDB
isolation between standalone ports and bridged ports, but not between
one bridge and another. So the FIDs are underutilized.
