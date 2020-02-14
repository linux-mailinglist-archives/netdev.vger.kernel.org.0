Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52FD15EACE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392736AbgBNRQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:16:09 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37524 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390425AbgBNRQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:16:07 -0500
Received: by mail-ed1-f68.google.com with SMTP id t7so381808edr.4;
        Fri, 14 Feb 2020 09:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+TQaiejN2oJWkvYEyn08fAwxJfSRMe4srFaIp4RWV5Q=;
        b=oYLPl5qBYmO1vBuRlYsixTkkJW6FWJLFmxAwB1o1VnXY4DHfk8GvEarNEbfMQ/uszw
         djdSQyjEQJOYpzwAt7k3HF0QZ2zI7Ks5n3/V4QuCzu/Ryhi4Zk0VY8QdGS3+s0aEPtmG
         MvN22umgGn+1FoZaMcAM5UyXHsSRC4rJ54VmXrQ1PxbXHBsE+5dLMs/exSoFF4azmK+Q
         tTbyyyJsk0nxgukBQ9lhC9pSiwK6KlqnjSywLkz0lP+b9qxbQen2bnhGmVfP6S3XBgwj
         o4WtWsomcFn/CoyRIRnVUFQSqhSxn/8KBtEpuCAx0S0GWM6BxO6UWIzeBDhiJDNWJ0Ai
         lT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+TQaiejN2oJWkvYEyn08fAwxJfSRMe4srFaIp4RWV5Q=;
        b=Or4zPsXH1xG6r6qIW1tZVbarxQBgnlNkDiM4/M5dDiMawbIYTmAes0V5kMfkmdQqZw
         MM193Lupx5cqEJrmlaOyLsqvXkmGsTHJbude6+s4mrtuGHXyWcPkYzVjp8TPW3P9QqgO
         JyMCfMHqKeN9iDWYy9xAgEwb09boYoFFzeekkxHa0lN7z2XiAqK21A1kkGrbDYbz3zEu
         crFZmEB9b/qs8ToTWcU/omSgv2GN/nCf49DbkdDWBxp7SwjQejl2wfOLiQJI77GT27Q1
         GiGMXXVeGco1H4d1RLlFIfc/cAYKzFauVncKpRzaUpmqmMwvARiPI0hAAx3uly+SDj+A
         Zq8A==
X-Gm-Message-State: APjAAAXIo+62TbCk/rjzTqFq/Sb3NqKBw8bZ8tj9ay6/Bn9+Q6ObBwEg
        9rFHWtBWCsjQ0InJ7GzYzJv1b46uQ9knmBtzfo2T1En4
X-Google-Smtp-Source: APXvYqycb3Z4H8Wemp8qMTqfZ0sCEaV8Lc9arsL+tB8jQfxNHQ9YsIhHn5tU9xN5JGvOrWZ6wh8W8hVtPo/Osi4IerA=
X-Received: by 2002:aa7:d3cb:: with SMTP id o11mr3715602edr.145.1581700565704;
 Fri, 14 Feb 2020 09:16:05 -0800 (PST)
MIME-Version: 1.0
References: <20200213191015.7150-1-f.fainelli@gmail.com> <CA+h21hqVWc6Tis12oJsfgXtsW2mJr0qUFu28G3qjMf-sOJWAwg@mail.gmail.com>
 <ab4e0ce1-dd48-8c1b-8753-a400dfcb38ec@gmail.com>
In-Reply-To: <ab4e0ce1-dd48-8c1b-8753-a400dfcb38ec@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 14 Feb 2020 19:15:54 +0200
Message-ID: <CA+h21hr5U-E9En+R1C7bhh2+DpS9i0qTBHsnAk=pLeamcqTHMg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: b53: Ensure the default VID is untagged
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 at 19:08, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 2/14/2020 2:36 AM, Vladimir Oltean wrote:
> > Hi Florian,
> >
> > On Thu, 13 Feb 2020 at 21:10, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> We need to ensure that the default VID is untagged otherwise the switch
> >> will be sending frames tagged frames and the results can be problematic.
> >> This is especially true with b53 switches that use VID 0 as their
> >> default VLAN since VID 0 has a special meaning.
> >>
> >> Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
> >> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >>  drivers/net/dsa/b53/b53_common.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> >> index 449a22172e07..f25c43b300d4 100644
> >> --- a/drivers/net/dsa/b53/b53_common.c
> >> +++ b/drivers/net/dsa/b53/b53_common.c
> >> @@ -1366,6 +1366,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
> >>
> >>                 b53_get_vlan_entry(dev, vid, vl);
> >>
> >> +               if (vid == b53_default_pvid(dev))
> >> +                       untagged = true;
> >> +
> >>                 vl->members |= BIT(port);
> >>                 if (untagged && !dsa_is_cpu_port(ds, port))
> >>                         vl->untag |= BIT(port);
> >> --
> >> 2.17.1
> >>
> >
> > Don't you mean to force untagged egress only for the pvid value of 0?
>
> The default VID (0 for most switches, 1 for 5325/65) is configured as
> pvid during b53_configure_vlan() so when we get a call to port_vlan_add
> with VID == 0 this is coming exclusively from
> dsa_slave_vlan_rx_add_vid() since the bridge will never program a VID <
> 1. When dsa_slave_vlan_rx_add_vid() calls us, we do not have any VLAN
> flags set in the object.
> --
> Florian

Exactly. So the only case you need to guard against is when vid == 0
&& vid == b53_default_pvid(dev) - basically the 8021q module messing
with your untagged (pvid-tagged) traffic. So both have to be zero in
order to interfere. If vid is 0 but the b53_default_pvid is 1 - no
problem. If vid is 1 and the b53_default_pvid is 1, again no problem.
At least that's what you described in the previous patch. No?

-Vladimir
