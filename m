Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706DFB6CC1
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 21:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbfIRTjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 15:39:17 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36927 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfIRTjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 15:39:17 -0400
Received: by mail-ed1-f67.google.com with SMTP id r4so1055173edy.4
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 12:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WGySUKR094neLH0dhcIHKGeeELXGFfeoUamFliR5rvk=;
        b=cyeD7sDvQxTGtvTufpMlXi1k8pq+VnUukTj/0ZJuJy3x0oYcBa/qwofTWuGOj+a0ek
         O79FjUm1D1i613YbFFfHd8rSTZE3ojsQQSIdsNSAprgMQ4PVXVycoDI7Dl7oLlOn9cbw
         pRxJqCzyONUPSRgR5xSZy3AVIxwZ27uuRRrnTpDalUngJ49B/Z2W5agifCTUlum9eerP
         b7s0NNLJQFN9jZwhqRMAIsa/22uPDMOVYtaBo0lP772ALYGhWpUEu9YZ2uBW6N5/RZiF
         fRb1jWcFHmmoCq0dUgkEPE2P0WzF+w0+i8Cx0fMvSH2N5nCr7/a+lIVKV2ULQySuR5cZ
         vK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WGySUKR094neLH0dhcIHKGeeELXGFfeoUamFliR5rvk=;
        b=Lmb2BQrhVOgJEuJuoPbBY+mNzZsknaLxw02oNCiLuL9BBLmB7yjmDDEZBGNJfGg+he
         MtVU4L+abreNorj3G3m0bo8VP/L9zAD1NRFvkwfMhSquQbut36y66fyel8Fcfx/rGjRF
         MGugGlGXjwb7Xi+r62PX2HLL8HOVJ7wosWFWeCWdLbmr18OeI8q9mKkgYWIfcJW4wt0E
         eAX9/HSZ/vNBJGJ60yTr5BFYApxPgV6FOALUf+4UL4bTcENB47ZV7onwSbIlgH2p/K2/
         Bu4SNED0Ii+vxGKfRnvzBpoPGc4Ko3gZbkNnh+pHHx5kh/4Q1YyIrOBA7oglqlzXQmzZ
         WiAQ==
X-Gm-Message-State: APjAAAW1oEg7aPPGJ7Ax0i0bOvgr0KeNpRG3w9CZyHexV3z7QVXIO3U5
        PbZC+M+yeHIeuUvIP9jUrzElepfj9cuHFc1z2dI=
X-Google-Smtp-Source: APXvYqyaPraPvlpOlA2g7f7uGf9b9oEM11ufYm0augTgx1G2klZ5Sb37G4jYoplrYTaK5p0FxOFJF8NCgDi7cE8MQtw=
X-Received: by 2002:a17:906:5fc4:: with SMTP id k4mr11163804ejv.300.1568835554545;
 Wed, 18 Sep 2019 12:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com> <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
In-Reply-To: <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 18 Sep 2019 22:39:03 +0300
Message-ID: <CA+h21hrgODP1VrBrJG6Hy9AE3EqqmzPVtjkBAiNjkm+KkwZLHw@mail.gmail.com>
Subject: Re: dsa traffic priorization
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, 18 Sep 2019 at 20:42, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 9/18/19 7:36 AM, Vladimir Oltean wrote:
> > Hi Sascha,
> >
> > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >>
> >> Hi All,
> >>
> >> We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> >> regular network traffic on another port. The customer wants to configure two things
> >> on the switch: First Ethercat traffic shall be priorized over other network traffic
> >> (effectively prioritizing traffic based on port). Second the ethernet controller
> >> in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> >> port shall be rate limited.
> >>
> >
> > You probably already know this, but egress shaping will not drop
> > frames, just let them accumulate in the egress queue until something
> > else happens (e.g. queue occupancy threshold triggers pause frames, or
> > tail dropping is enabled, etc). Is this what you want? It sounds a bit
> > strange to me to configure egress shaping on the CPU port of a DSA
> > switch. That literally means you are buffering frames inside the
> > system. What about ingress policing?
>
> Indeed, but I suppose that depending on the switch architecture and/or
> nomenclature, configuring egress shaping amounts to determining ingress
> for the ports where the frame is going to be forwarded to.

Egress shaping in the switches I've played with has nothing to do with
the ingress port, unless that is used as a key for some sort for QoS
classification (aka selector for a traffic class).
Furthermore, shaping means queuing (which furthermore means delaying,
but not dropping except in extreme cases which are outside the scope
of shaping itself), while policing by definition means early dropping
(admission control). Like Dave Taht pointed out too, dropping might be
better for the system's overall latency.

>
> For instance Broadcom switches rarely if at all mention ingress because
> the frames have to originate from somewhere and be forwarded to other
> port(s), therefore, they will egress their original port (which for all
> practical purposes is the direct continuation of the ingress stage),
> where shaping happens, which immediately influences the ingress shaping
> of the destination port, which will egress the frame eventually because
> packets have to be delivered to the final port's egress queue anyway.
>

You lost me.
I have never heard of any shaping done inside the guts of a switch, so
'egress of an ingress port' and 'ingress of an egress port' makes no
sense to me.
I was talking about ingress policing at the front panel ports, for
their best-effort traffic. I think that is actually preferable to
egress shaping at the CPU port, since I don't think they would want
the EtherCAT traffic getting delayed.
Alternatively, maybe the DSA master port supports per-stream hardware
policing, although that is more exotic.

> >
> >> For reference the patch below configures the switch to their needs. Now the question
> >> is how this can be implemented in a way suitable for mainline. It looks like the per
> >> port priority mapping for VLAN tagged packets could be done via ip link add link ...
> >> ingress-qos-map QOS-MAP. How the default priority would be set is unclear to me.
> >>
> >
> > Technically, configuring a match-all rxnfc rule with ethtool would
> > count as 'default priority' - I have proposed that before. Now I'm not
> > entirely sure how intuitive it is, but I'm also interested in being
> > able to configure this.
>
> That does not sound too crazy from my perspective.
>

Ok, well at least that requires no user space modification, then.

> >
> >> The other part of the problem seems to be that the CPU port has no network device
> >> representation in Linux, so there's no interface to configure the egress limits via tc.
> >> This has been discussed before, but it seems there hasn't been any consensous regarding how
> >> we want to proceed?
>
> You have the DSA master network device which is on the other side of the
> switch,
> --
> Florian

Thanks,
-Vladimir
