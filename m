Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5E7162798
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgBROCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:02:21 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:46245 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgBROCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:02:21 -0500
Received: by mail-ed1-f65.google.com with SMTP id p14so16770212edy.13
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 06:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWtzCA/ZYfMPHMklTDUQXbccXiZzLT49q/V2CNuTAPA=;
        b=H2bByViDCphnZdYwUcovsy7f4F5gfCdDYAbkLWeutQ0DYOrb+RFH0ZCdNrbVYYawVV
         t23rpguMWgb+sJa3GxrrW/blAMYx6QMaJv7pQIvHCzbm0KEmS3561UYSbmf2m3wfTmvB
         EiVTW9Wxba3BnBfKuw6KBNt7W+ak+Ip3GUOi2BUZVRjrqyLwhz/ylKqUwxiscL4YpUH+
         DloGwaVXgjMXgp56qq9RPmN9ksddayxWTxQHfaS55lbpYYewjv/MmtbSW/hwjOOR2YWL
         TeyobCLpIKFprtow4D0RT11M9wYlVK28dKzzUOJStVZQXZhIsVlNKyG0n7ZzwfzFw+V6
         CWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWtzCA/ZYfMPHMklTDUQXbccXiZzLT49q/V2CNuTAPA=;
        b=rTPhjeMOtj/gS/ab7jNlEtBdP2Dgg1hoxSjjK0NS6Kebd6vp9orBRR1GC3fW2mQW9J
         CuLLodhlUmY+DSiGXbxnZa83vUGsrc5rYMSNoUmEDuDy87b0OkZ2tZc4aGCtEtGQ7UQt
         U62TuKg/hhp5ZIJcp9K0qEjISmQIYVNkKYicuf8mGi78jFjPQYWmnbXQXRhlkGLDm8uZ
         ZvN14itRVy8op/dofWy0l7tlo1QpMl0UPvi9JKapcemFNPLBVPx0c5R831hsb4DwPWty
         hpBOaVjLvQ5a8KTeQe2IcoTcaobiqTT8m7AKuoeFg0o6zlmqjkaLMakdcaROOLkbAC18
         qjzg==
X-Gm-Message-State: APjAAAUBvb6TEWtBssbtedcyTDXbII6cptZGptKKDtqAUtQODQvf20P3
        rjURW+19I3gFhvN2E2A4gEj9lmBJp264ufJKHjPfOLPH
X-Google-Smtp-Source: APXvYqy36oV/AFlXGULRoO07lTQemKa8yhHb1gdDKr8I3suzJmEMpXjA6ZG9iP1kqIHmzS5WeuEIixksxrcVhNGAUSI=
X-Received: by 2002:a05:6402:3132:: with SMTP id dd18mr19383816edb.118.1582034538970;
 Tue, 18 Feb 2020 06:02:18 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com> <20200218134850.yor4rs72b6cjfddz@lx-anielsen.microsemi.net>
In-Reply-To: <20200218134850.yor4rs72b6cjfddz@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 18 Feb 2020 16:02:08 +0200
Message-ID: <CA+h21hpj+ARUZN5kkiponTCN_W1xaNDTpNB4u4xdiAGP5QqmfA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 at 15:48, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> On 18.02.2020 14:29, Vladimir Oltean wrote:
> >> >diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> >> >index 86d543ab1ab9..94d39ccea017 100644
> >> >--- a/drivers/net/ethernet/mscc/ocelot.c
> >> >+++ b/drivers/net/ethernet/mscc/ocelot.c
> >> >@@ -2297,6 +2297,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
> >> >                         enum ocelot_tag_prefix injection,
> >> >                         enum ocelot_tag_prefix extraction)
> >> > {
> >> >+       int port;
> >> >+
> >> >+       for (port = 0; port < ocelot->num_phys_ports; port++) {
> >> >+               /* Disable old CPU port and enable new one */
> >> >+               ocelot_rmw_rix(ocelot, 0, BIT(ocelot->cpu),
> >> >+                              ANA_PGID_PGID, PGID_SRC + port);
> >> I do not understand why you have an "old" CPU. The ocelot->cpu field is
> >> not initialized at this point (at least not in case of Ocelot).
> >>
> >> Are you trying to move the NPI port?
> >>
> >
> >Yes, that's what this function does. It sets the NPI port. It should
> >be able to work even if called multiple times (even though the felix
> >and ocelot drivers both call it exactly one time).
> >But I can (and will) remove/simplify the logic for the "old" CPU port.
> >I had the patch formatted already, and I didn't want to change it
> >because I was lazy to re-test after the changes.
> >
> >> >+               if (port == cpu)
> >> >+                       continue;
> >> >+               ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
> >> >+                              ANA_PGID_PGID, PGID_SRC + port);
> >> So you want all ports to be able to forward traffic to your CPU port,
> >> regardless of if these ports are member of a bridge...
> >>
> >
> >Yes.
> >
> >> I have read through this several times, and I'm still not convinced I
> >> understood it.
> >>
> >> Can you please provide a specific example of how things are being
> >> forwarded (wrongly), and describe how you would like them to be
> >> forwarded.
> >
> >Be there 4 net devices: swp0, swp1, swp2, swp3.
> >At probe time, the following doesn't work on the Felix DSA driver:
> >ip addr add 192.168.1.1/24 dev swp0
> >ping 192.168.1.2
> This does work with Ocelot, without your patch. I would like to
> understand why this does not work in your case.
>
> Is it in RX or TX you have the problem.
>

The problem is on RX.

> Is it with the broadcast ARP, or is it the following unicast packet?
>

For the unicast packet.

> >But if I do this:
> >ip link add dev br0 type bridge
> >ip link set dev swp0 master br0
> >ip link set dev swp0 nomaster
> >ping 192.168.1.2
> >Then it works, because the code path from ocelot_bridge_stp_state_set
> >that puts the CPU port in the forwarding mask of the other ports gets
> >executed on the "bridge leave" action.
> >The whole point is to have the same behavior at probe time as after
> >removing the ports from the bridge.
> This does sound like a bug, but I still do not agree in the solution.
>
> >The code with ocelot_mact_learn towards PGID_CPU for the MAC addresses
> >of the switch port netdevices is all bypassed in Felix DSA. Even if it
> >weren't, it isn't the best solution.
> >On your switch, this test would probably work exactly because of that
> >ocelot_mact_learn.
> So I guess it is the reception of the unicast packet which is causing
> problems.
>
> >But try to receive packets sent at any other unicast DMAC immediately
> >after probe time, and you should see them in tcpdump but won't.
> That is true - this is because we have no way of implementing promisc
> mode, which still allow us to HW offload of the switching. We discussed
> this before.
>
> Long story short, it sounds like you have an issue because the
> Felix/DSA driver behave differently than the Ocelot. Could you try to do
> your fix such that it only impact Felix and does not change the Ocelot
> behavioral.

It looks like you disagree with having BIT(ocelot->cpu) in PGID_SRC +
p (the forwarding matrix) and just want to rely on whitelisting
towards PGID_CPU*?
But you already have that logic present in your driver, it's just not
called from a useful place for Felix.
So it logically follows that we should remove these lines from
ocelot_bridge_stp_state_set, no?

            } else {
                    /* Only the CPU port, this is compatible with link
                     * aggregation.
                     */
                    ocelot_write_rix(ocelot,
                                     BIT(ocelot->cpu),
                                     ANA_PGID_PGID, PGID_SRC + p);

*I admit that I have no idea why it works for you, and why the frames
learned towards PGID_CPU are forwarded to the CPU _despite_
BIT(ocelot->cpu) not being present in PGID_SRC + p.

>
> /Allan
>
