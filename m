Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2EC210590E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKUSHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:07:40 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43563 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUSHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:07:40 -0500
Received: by mail-ed1-f67.google.com with SMTP id w6so3583555edx.10
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 10:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qlhOOdy5zxkL6iBOuGaGQVy3yynKjjB5Jod1tMccjnM=;
        b=tXTJoLIqm0TDqaShrEI7kt5ePQMA/xVMow6zam90Tjz/kBvOJ3n/uBjY4ErHqF6HGo
         hr8CNJhYBh9S4KiTAXWjwmYePIc+9d1IosDRzwx669gJiXZxnWccTIK98NzYHWjrTZlO
         vzJVIvbf3cK3XHf2osVQIaOWAWkgjbB5zDwdAJoHl4LJKOq/d6t9BC1+SXhduPmhJdU6
         j6Tsccs0NyZ1e6I8ct8J/HduR6EKMcd81ir1wS8UcISetNf56jMnZDpuG0m+B25a7HM4
         +wFi38Hd2dMcNnwcA968et6pR07Yh+nulCO3hp6fBVpv/aXmOv4QXeWeuTzAgKZdD7XT
         XSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qlhOOdy5zxkL6iBOuGaGQVy3yynKjjB5Jod1tMccjnM=;
        b=BjkQ2MvX9AhjbTSiusfK3IuU5GHGi1WulZYbGLsNMd6IM/WyoAp+aq4cqo6aMh4eN4
         NTYCzOknrnH9CT+noPQFDPOpgiDBLPn0KeuhH5oZ+lLOrB3CNkix62viU5a3o20/vNOE
         abAHI2pWXXT31f2NnvBjA1gb0kN9fHOrf2O2L4ORfIQxYnVRNz8bDjeXu6uP3nQu9Hf1
         j2VOXs5SiEk3nc25yMx+jueFNyq/SKKroTz/eECTsowcYWkX84eSFfLK/wUPqzUPLFfo
         Zv7xn0FYamlYZLrsTgJQuWSUSBr0t3KvrvwZIrXlHaIz8Nnqu9dkC2BXp4frSntM+4Uc
         jPhA==
X-Gm-Message-State: APjAAAXL+ILHRCGw92roQjTwX5NlKFXsfe7+aP5lLPPpVjNjEgpIzq27
        fwEBZBtCZ/6nXwdvKVW/THn9CAFNmoGNH+f8ZA8a9Q==
X-Google-Smtp-Source: APXvYqwoYRRTfYh6QQGMj/vnMNkg7KLuMn3o7fgk4QoJwSzMF+8sSzwziEf05KmrCLsgPEBjTuZiwVLlkNouVrnKVGw=
X-Received: by 2002:a17:906:24d4:: with SMTP id f20mr15916828ejb.182.1574359657752;
 Thu, 21 Nov 2019 10:07:37 -0800 (PST)
MIME-Version: 1.0
References: <20191117211407.9473-1-olteanv@gmail.com> <78f47c04-0758-50f6-ad59-2893849e7dea@gmail.com>
 <CA+h21hpWXj9bFHg4sec2=8KEaXJ2sN4pvyftL4muBCEwrCzEDQ@mail.gmail.com> <50186dc9-88e1-12f4-f8c8-894e48a1eae9@gmail.com>
In-Reply-To: <50186dc9-88e1-12f4-f8c8-894e48a1eae9@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 21 Nov 2019 20:07:26 +0200
Message-ID: <CA+h21hq6y3aSFQjZQOOx55WQ1q3Cw_r1D72=ij6hkqTtMUhqEg@mail.gmail.com>
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

On Thu, 21 Nov 2019 at 19:37, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 11/21/19 2:29 AM, Vladimir Oltean wrote:
> > On Mon, 18 Nov 2019 at 06:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> On 11/17/2019 1:14 PM, Vladimir Oltean wrote:
> >> [snip]
> >>
> >>> +best_effort_vlan_filtering
> >
> > [snip]
> >
> >>> +                     - Cannot terminate VLAN-tagged traffic on local device.
> >>> +                       There is no way to deduce the source port from these.
> >>> +                       One could still use the DSA master though.
> >>
> >> Could we use QinQ to possibly solve these problems and would that work
> >> for your switch? I do not really mind being restricted to not being able
> >> to change the default_pvid or have a reduced VLAN range, but being able
> >> to test VLAN tags terminated on DSA slave network devices is a valuable
> >> thing to do.
> >> --
> >> Florian
> >
> > I took another look at the hardware manual and there exists a feature
> > called the Retagging Table whose purpose I did not understand
> > originally. It can do classification on frames with a given { ingress
> > port mask, egress port mask, vlan id }, and clone them towards a given
> > list of destination ports with a new VID. The table only has space for
> > 32 entries though. I think I can use it to keep the CPU copied to all
> > non-pvid VLANs received on the front-panel ports. The CPU will still
> > see a pvid-tagged frame for each of those, but with the PCP from the
> > original frame. The result is that VLAN filtering is still performed
> > correctly (non-member VIDs of the front-panel ports are dropped), but
> > the tag is consumed by DSA and sockets still see those frames as
> > untagged. To me that's fine except for the fact that the CPU will now
> > be spammed by offloaded flows even if the switch learns the
> > destination to be a front-panel. Just wanted to hear your opinion
> > before attempting to prototype this.
>
> That seems like a good idea to me. Back to your RFC patch here, instead
> of introducing a "best effort vlan filtering" configuration knob, how
> about just restricting the possible VID range when vlan_filtering=1
> through the port_vlan_prepare() callback to exclude the problematic
> dsa_tag_8021q VID ranges used for port discrimination?
> --
> Florian

Ugh. I'll have to think about that. The "best effort" vlan_filtering
is a good enough approximation for probably lots of use cases, but if
you just want STP and PTP on your switch (aka traffic that this switch
doesn't need VLANs to decode) and you otherwise need the more advanced
VLAN features (your own pvid, more than 32 VLANs, independent VLAN
learning), then plain vlan_filtering is clearly the better option and
the "best effort" compromises only bring insanity to it.

By the way, I _think_ it's actually possible to retag frames towards
the CPU without even creating clones, but this is very poorly
documented. I really need to experiment a bit.

Thanks,
-Vladimir
