Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968F6193E1F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgCZLpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:45:06 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32912 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgCZLpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:45:06 -0400
Received: by mail-ed1-f66.google.com with SMTP id z65so6474616ede.0
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mnAgrNsl9TtuLNSumAhTp47m7iv21ewR1qWnv6t8I9M=;
        b=UXyqEZZW/BlvhlBAP/vj7nH3XAnSH2pHHHoWVuHr+uEr9RekFjwsR6WVebQqwtGjgb
         36FXBn7y89u/fTTLRLz25kDjshEsLMsWwTcqIZQE2a4soMrobMjiyt9cYEiWiXTLiYw0
         iJIAHlziUZ1JZ3hjTvCvfQUfn6hmXGTJo4CWTUd1PT4EaKiKD9jlLs3N/C+3AGsOho+j
         fherYFlNreKow19HPyWZ9cbK8EDdBZ0siJSF+lfgQXYSFtZLgEjt6LcAqnaHljjvonMJ
         YUmAkZs9AEbH4Rk5cC5OW9Mq8n0MDtIgXdkgC1mvp/H7SeX6CnyOBw8EmzkuU8RZWdrW
         BVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mnAgrNsl9TtuLNSumAhTp47m7iv21ewR1qWnv6t8I9M=;
        b=LSFD8QdV3rJ07B7elMqz/K8BjjcTKLiFC8supFOpwb4pP53Oi2VD0Br/v8o9Iyk4zy
         HBkwaHLRLSbFgikN0hmphJRSj3xsPRMJ7+KkIHuyKGuJHm0WwEnfm0+K5bLjOMQej/6q
         Bhm7pQZ3jen2VBeZif4xvh3DEbgsNn7KEXimlyxhS6d3yYhp+SiExCYqX+LCvUV08I4y
         v27oohca7SJingoP5Jkdryz/QsCFIDsymcAyo3a7J+r/p6xA0FkkRvrA692mCtkVT01m
         HdSQ0D1brzYj/aslkOIsCxwFdX/vF7/UzwKwV7Y1sRJ/BWabBaiiLp+t1LAtay+y/gBu
         d1lQ==
X-Gm-Message-State: ANhLgQ2eNPmnubkh706n1UfwMu8I4eVYPvAKugdBXguD2biKz6IzxxO5
        OVGuW0ItrsfjrPq7tBbltgvWkQe1McIdgJyvKV0=
X-Google-Smtp-Source: ADFU+vt1UrV41ZlDCTPpWPkf16gCIrOOrMUnqDMR2Y1aPddYfhFthMbru+AkUVqUHpv7ZybIXzDT733nv64ZjxkEzeM=
X-Received: by 2002:a50:9b07:: with SMTP id o7mr7814062edi.139.1585223102822;
 Thu, 26 Mar 2020 04:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter> <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter>
In-Reply-To: <20200326113542.GA1383155@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 13:44:51 +0200
Message-ID: <CA+h21hqSWKSc-AD0fTA0XXsqmPdF_LCvKrksWEe8DGhdLm=AWQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 at 13:35, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
> > Hi Ido,
> >
> > On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > Hi Vladimir,
> > >
> > > On Wed, Mar 25, 2020 at 05:22:09PM +0200, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > In the initial attempt to add MTU configuration for DSA:
> > > >
> > > > https://patchwork.ozlabs.org/cover/1199868/
> > > >
> > > > Florian raised a concern about the bridge MTU normalization logic (when
> > > > you bridge an interface with MTU 9000 and one with MTU 1500). His
> > > > expectation was that the bridge would automatically change the MTU of
> > > > all its slave ports to the minimum MTU, if those slaves are part of the
> > > > same hardware bridge. However, it doesn't do that, and for good reason,
> > > > I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
> > > > bridge net device itself, and not that of any slave port.  If it were to
> > > > modify the MTU of the slave ports, the effect would be that the user
> > > > wouldn't be able to increase the MTU of any bridge slave port as long as
> > > > it was part of the bridge, which would be a bit annoying to say the
> > > > least.
> > > >
> > > > The idea behind this behavior is that normal termination from Linux over
> > > > the L2 forwarding domain described by DSA should happen over the bridge
> > > > net device, which _is_ properly limited by the minimum MTU. And
> > > > termination over individual slave device is possible even if those are
> > > > bridged. But that is not "forwarding", so there's no reason to do
> > > > normalization there, since only a single interface sees that packet.
> > > >
> > > > The real problem is with the offloaded data path, where of course, the
> > > > bridge net device MTU is ignored. So a packet received on an interface
> > > > with MTU 9000 would still be forwarded to an interface with MTU 1500.
> > > > And that is exactly what this patch is trying to prevent from happening.
> > >
> > > How is that different from the software data path where the CPU needs to
> > > forward the packet between port A with MTU X and port B with MTU X/2 ?
> > >
> > > I don't really understand what problem you are trying to solve here. It
> > > seems like the user did some misconfiguration and now you're introducing
> > > a policy to mitigate it? If so, it should be something the user can
> > > disable. It also seems like something that can be easily handled by a
> > > user space application. You get netlink notifications for all these
> > > operations.
> > >
> >
> > Actually I think the problem can be better understood if I explain
> > what the switches I'm dealing with look like.
> > None of them really has a 'MTU' register. They perform length-based
> > admission control on RX.
>
> IIUC, by that you mean that these switches only perform length-based
> filtering on RX, but not on TX?
>

Yes.

> > At this moment in time I don't think anybody wants to introduce an MRU
> > knob in iproute2, so we're adjusting that maximum ingress length
> > through the MTU. But it becomes an inverted problem, since the 'MTU'
> > needs to be controlled for all possible sources of traffic that are
> > going to egress on this port, in order for the real MTU on the port
> > itself to be observed.
>
> Looking at your example from the changelog:
>
> ip link set dev sw0p0 master br0
> ip link set dev sw0p1 mtu 1400
> ip link set dev sw0p1 master br0
>
> Without your patch, after these commands sw0p0 has an MTU of 1500 and
> sw0p1 has an MTU of 1400. Are you saying that a frame with a length of
> 1450 bytes received on sw0p0 will be able to egress sw0p1 (assuming it
> should be forwarded there)?
>

Yes.

> If so, then I think I understand the problem. However, I don't think
> such code belongs in the bridge driver as this restriction does not
> apply to all switches.

How do Mellanox switches deal with this?

> Also, I think that having the kernel change MTU
> of port A following MTU change of port B is a bit surprising and not
> intuitive.
>

It already changes the MTU of br0, this just goes along the same path.

> I think you should be more explicit about it. Did you consider listening
> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
> unsupported configurations with an appropriate extack message? If you
> can't veto (in order not to break user space), you can still emit an
> extack message.

I suppose that is an alternative approach. This would be done from the
DSA core then? But instead of veto, just do the normalization thing.

Thanks,
-Vladimir
