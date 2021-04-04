Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C089E353828
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhDDM6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 08:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhDDM63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 08:58:29 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612A7C061756;
        Sun,  4 Apr 2021 05:58:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id o19so9967539edc.3;
        Sun, 04 Apr 2021 05:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ay9dt9s+rxe7/URKnqqWaJeeSbzYzuIksXL2L2LVjNQ=;
        b=Jvak9k8nNNVLT9LAYa4z8166l+W02ZeGsWYjzOVYzcphx8RkXEb29qxrUPxm1D96Mx
         4QQOMHppKQlvplvcjHvFydvToarvMXcErPy3us8vKENqkRU2qyDsB2cJ/VXCSydK4h2a
         XH5L6GfzJZkL0jKMxOwKRz+mgCG0/r8dWYhNNdVzTnONyvDLfBilceypoTSxxXnktwdC
         jYZJL9Q4yvACiXkfNemgSfPYIp6zvxL8rJvo7HBswD43AbPELrtzTHhxK26yZifTbsAx
         mvoFdlRwsQXuVydo0/Uwn62gywqOrQWtW0ZYvbElaWV6vL9ViPvTyYUBUO2JmeXPGo4m
         mT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ay9dt9s+rxe7/URKnqqWaJeeSbzYzuIksXL2L2LVjNQ=;
        b=Mjl+zXZuNjuIvIFrjYjlAlJ1nZztCjllVsp0YArfOPXSoYUQEKOINvIeuB5R0ixMNS
         N45KtlZ0p2V39TUmHgCPTFapjijsulRxGEdxqHKPA/3uOySzuGV6WXogBKGS4El4tjED
         Dw+050d+IWr5RchBbNY6LOQOLNJhZJxcXTtbqY3D3C6oWY+cmX3p1Bm8ikRuXrX/jxjZ
         N7znL5zBcG6DmOl/sX+NL1Bd8iTqsDj2lJiVHW2rK6DBIDalh/x+lTJImCebw0zhgf9x
         sSN0tK7/G/R9j5kAqolTcW87FHhmG1TgfWkVHTnwMIMYGh+0XWEj/STg8vVzWLwAOwrw
         xUqQ==
X-Gm-Message-State: AOAM53361oe2t9t4VzZZ3eid1sZWG3EKgv1kAr+B/lGp4LPLIYSCGgoJ
        eL8ud7TFeSOSmC0wrtsI5Nw=
X-Google-Smtp-Source: ABdhPJyOrZmCwxPKnAcnjqfpM5XQRpIy2A3RIqUxDaSkVjCUofI8UcnEP5sdQKOUvi1tNGsjm05Kuw==
X-Received: by 2002:a05:6402:3592:: with SMTP id y18mr25566610edc.360.1617541103947;
        Sun, 04 Apr 2021 05:58:23 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id p24sm8634745edt.5.2021.04.04.05.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 05:58:23 -0700 (PDT)
Date:   Sun, 4 Apr 2021 15:58:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and
 MLD packets
Message-ID: <20210404125822.yr6tsrxxvskkvuq6@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de>
 <YGiAjngOfDVWz/D7@lunn.ch>
 <f4856601-4219-09c7-2933-2161afd03abe@rempel-privat.de>
 <20210404000204.kujappopdi3aqjsn@skbuf>
 <ab493cae-e8a5-e03a-3929-649e9ff46816@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab493cae-e8a5-e03a-3929-649e9ff46816@rempel-privat.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 07:35:26AM +0200, Oleksij Rempel wrote:
> Am 04.04.21 um 02:02 schrieb Vladimir Oltean:
> > On Sat, Apr 03, 2021 at 07:14:56PM +0200, Oleksij Rempel wrote:
> >> Am 03.04.21 um 16:49 schrieb Andrew Lunn:
> >>>> @@ -31,6 +96,13 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
> >>>>  	__le16 *phdr;
> >>>>  	u16 hdr;
> >>>>
> >>>> +	if (dp->stp_state == BR_STATE_BLOCKING) {
> >>>> +		/* TODO: should we reflect it in the stats? */
> >>>> +		netdev_warn_once(dev, "%s:%i dropping blocking packet\n",
> >>>> +				 __func__, __LINE__);
> >>>> +		return NULL;
> >>>> +	}
> >>>> +
> >>>>  	phdr = skb_push(skb, AR9331_HDR_LEN);
> >>>>
> >>>>  	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
> >>>
> >>> Hi Oleksij
> >>>
> >>> This change does not seem to fit with what this patch is doing.
> >>
> >> done
> >>
> >>> I also think it is wrong. You still need BPDU to pass through a
> >>> blocked port, otherwise spanning tree protocol will be unstable.
> >>
> >> We need a better filter, otherwise, in case of software based STP, we are leaking packages on
> >> blocked port. For example DHCP do trigger lots of spam in the kernel log.
> >
> > I have no idea whatsoever what 'software based STP' is, if you have
> > hardware-accelerated forwarding.
> 
> I do not mean hardware-accelerated forwarding, i mean
> hardware-accelerated STP port state helpers.

Still no clue what you mean, sorry.

> >> I'll drop STP patch for now, it will be better to make a generic soft STP for all switches without
> >> HW offloading. For example ksz9477 is doing SW based STP in similar way.
> >
> > How about we discuss first about what your switch is not doing properly?
> > Have you debugged more than just watching the bridge change port states?
> > As Andrew said, a port needs to accept and send link-local frames
> > regardless of the STP state. In the BLOCKING state it must send no other
> > frames and have address learning disabled. Is this what's happening, is
> > the switch forwarding frames towards a BLOCKING port?
> 
> The switch is not forwarding BPDU frame to the CPU port. So, the linux
> bridge will stack by cycling different state of the port where loop was
> detected.

The switch should not be 'forwarding' BPDU frames to the CPU port, it
should be 'trapping' them. The difference is subtle but important. Often
times switches have an Access Control List which allows them to steal
packets from the normal FDB-based forwarding path. It is probably the
case that your switch needs to be told to treat STP BPDUs specially and
not just 'forward' them.
To confirm whether I'm right or wrong, if you disable STP and send a
packet with MAC DA 01:80:c2:00:00:00 to the switch, will it flood it
towards all ports or will it only send them to the CPU?
