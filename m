Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 949A816261C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 13:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgBRM3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 07:29:30 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45906 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgBRM3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 07:29:30 -0500
Received: by mail-ed1-f66.google.com with SMTP id v28so24576724edw.12
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 04:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZmBbRIxCiaXc+kfSoiHUrxp9r4P+BSqBK22CsveBs7Q=;
        b=ROq+F5lhhRUxdiaLnYUa9FMbWrLhLM/tqt97Omf3xwWmYR0kYXCHhUi0a23r62CRq9
         aNR1Yk+lG+d9rInJCDTXo7viD+XQYPKaabLSws2gE8sO8/U+wleMHzNiqQpt6SvXliKJ
         OhzG4Kb9ZcKLDOEvr1dljx/sQKJPl6VVeBzH8aIt2g0wMjhmZHTrux3xzolrStAKRSC4
         x4Wt7rXUxsukCBWQMrIGFfrkTDRyKXkCYRPKpyqOcAeI/bn3EU7gLf9VI7bKfOr4TrBM
         koXJ7h6YAeF/GQk3M1YzkHY168iTG1g/zbS/724VZfyvU5OHOkdUgrC5WTNgw9OCflNo
         8NfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZmBbRIxCiaXc+kfSoiHUrxp9r4P+BSqBK22CsveBs7Q=;
        b=Vh4WPEWQR1hDD6hybGfBSa1Px9vgSjVpCqeu4fOj+F5Hl/Lx5g4uvO8t78w94TIRYi
         5rhTWUB10Ddb/u1/r+pt8YnnAdZuzIkTbqmvUynZZffKtjENx4ex7/ZqDDDZOAHT6Nqr
         Aqkzc3yG4igR43emu6rwLO253rHW7y/j9zQjCg3EzOBp/wzrgtavgkZnWJBlGsfO+94M
         irbALEPqJETzKaCd4dMgOWUMTE8B7aIlJiusozMEllGIxDYO6ZNKLLW0SPcr4cfCcjGp
         l6E1x4nDzOisuKHH22lhd1WLWUMdXeaVD0WQLN3HppZOe8EjNsH+MssHYQCGgs0MT61W
         iefw==
X-Gm-Message-State: APjAAAVMk5XD3MXf6flueTKpj6sLxQyy8by91pPgDxjmEdSHwhKhyWhh
        0/BkZ7ibGr5pDF8qmSJOLjW01le1e+BkXWtqPuc=
X-Google-Smtp-Source: APXvYqz+Tk2zBtqDUqVExZ4Pm9feWCgxA8RfaGoLxYaFZ+cxNbpAd5snK5Yq7C/4eqC4WDlnkh3DGDas+63mXwAXQNY=
X-Received: by 2002:a17:907:2636:: with SMTP id aq22mr3692165ejc.176.1582028966045;
 Tue, 18 Feb 2020 04:29:26 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
In-Reply-To: <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 18 Feb 2020 14:29:15 +0200
Message-ID: <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
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

Hi Allan,

On Tue, 18 Feb 2020 at 13:32, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> On 17.02.2020 17:00, Vladimir Oltean wrote:
> >EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> >From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> >The Ocelot switches have what is, in my opinion, a design flaw: their
> >DSA header is in front of the Ethernet header, which means that they
> >subvert the DSA master's RX filter, which for all practical purposes,
> >either needs to be in promiscuous mode, or the OCELOT_TAG_PREFIX_LONG
> >needs to be used for extraction, which makes the switch add a fake DMAC
> >of ff:ff:ff:ff:ff:ff so that the DSA master accepts the frame.
> >
> >The issue with this design, of course, is that the CPU will be spammed
> >with frames that it doesn't want to respond to, and there isn't any
> >hardware offload in place by default to drop them.
> In the case of Ocelot, the NPI port is expected to be connected back to
> back to the CPU, meaning that it should not matter what DMAC is set.
>

You are omitting the fact that the host Ethernet port has an RX filter
as well. By default it should drop frames that aren't broadcast or
aren't sent to a destination MAC equal to its configured MAC address.
Most DSA switches add their tag _after_ the Ethernet header. This
makes the DMAC and SMAC seen by the front-panel port of the switch be
the same as the DMAC and SMAC seen by the host port. Combined with the
fact that DSA sets up switch port MAC addresses to be inherited from
the host port, RX filtering 'just works'.

> It was also my understanding that this is how you have connected this.
>

Yup.

> I'm not able to see why this would cause spamming.
>

With the Ocelot switch adding just the tag on extraction, the host
port would interpret random garbage as the DMAC (basically first 6
bytes of the extraction header whose format is detailed in
net/dsa/tag_ocelot.c.
So it would drop basically all packets, unless by pure chance, the
first 6 bytes of the extraction header form a pattern that is equal to
the MAC address configured on the host port (highly unlikely).
With the Ocelot switches, the host port should really be
unconditionally put in promiscuous mode. DSA doesn't support
specifying this yet, because no other switch has needed this.
Another workaround (the one currently used now) is to use this long
prefix format, which makes the Ocelot switch add some fake DMAC and
SMAC before the extraction header, such that the frames will pass
through any host port RX filter.
Using either one of the 2 workarounds (promiscuous mode or long
prefix), the advantage and the disadvantage is the same: the host port
can no longer drop frames in hardware for unknown DMACs (either
because it doesn't know where the real DMAC is, or because it is told
not to drop them).
The disadvantage is that a mechanism that worked implicitly so far for
every other DSA switch does not work for Ocelot. Of course it causes
spamming only if you send traffic towards a DMAC that is irrelevant to
the CPU.

> >What is being done in the VSC7514 Ocelot driver is a process of
> >selective whitelisting. The "MAC address" of each Ocelot switch net
> >device, with all VLANs installed on that port, is being added as a FDB
> >entry towards PGID_CPU.
> >
> >PGID_CPU is is a multicast set containing only BIT(cpu). I don't know
> >why it was chosen to be a multicast PGID (59) and not simply the unicast
> >one of this port, but it doesn't matter. The point is that the the CPU
> >port is special, and frames are "copied" to the CPU, disregarding the
> >source masks (third PGID lookup), if BIT(cpu) is found to be set in the
> >destination masks (first PGID lookup).
> >
> >Frames that match the FDB will go to PGID_CPU by virtue of the DEST_IDX
> >from the respective MAC table entry, and frames that don't will go to
> >PGID_UC or PGID_MC, by virtue of the FLD_UNICAST, FLD_BROADCAST etc
> >settings for flooding. And that is where the distinction is made:
> >flooded frames will be subject to the third PGID lookup, while frames
> >that are whitelisted to the PGID_CPU by the MAC table aren't.
> >
> >So we can use this mechanism to simulate an RX filter, given that we are
> >subverting the DSA master's implicit one, as mentioned in the first
> >paragraph. But this has some limitations:
> >
> >- In Ocelot each net device has its own MAC address. When simulating
> >  this with MAC table entries, it will practically result in having N
> >  MAC addresses for each of the N front-panel ports (because FDB entries
> >  are not per source port). A bit strange, I think.
> >
> >- In DSA we don't have the infrastructure in place to support this
> >  whitelisting mechanism. Calling .port_fdb_add on the CPU port for each
> >  slave net device dev_addr isn't, in itself, hard. The problem is with
> >  the VLANs that this port is part of. We would need to keep a duplicate
> >  list of the VLANs from the bridge, plus the ones added from 8021q, for
> >  each port. And we would need reference counting on each MAC address,
> >  such that when a front-panel port changes its MAC address and we need
> >  to delete the old FDB entry, we don't actually delete it if the other
> >  front-panel ports are still using it. Not to mention that this FDB
> >  entry would have to be added on the whole net of upstream DSA switches.
> >
> >- Cascading a different DSA switch that has tags before the Ethernet
> >  header would not possibly work if we rely on the whitelisting
> >  mechanism exclusively.
> >
> >So... it's complicated. What this patch does is to simply allow frames
> >to be flooded to the CPU, which is anyway what the Ocelot driver is
> >doing after removing the bridge from the net devices, see this snippet
> >from ocelot_bridge_stp_state_set:
> >
> >    /* Apply FWD mask. The loop is needed to add/remove the current port as
> >     * a source for the other ports.
> >     */
> >    for (p = 0; p < ocelot->num_phys_ports; p++) {
> >            if (p == ocelot->cpu || (ocelot->bridge_fwd_mask & BIT(p))) {
> >                    (...)
> >            } else {
> >                    /* Only the CPU port, this is compatible with link
> >                     * aggregation.
> >                     */
> >                    ocelot_write_rix(ocelot,
> >                                     BIT(ocelot->cpu),
> >                                     ANA_PGID_PGID, PGID_SRC + p);
> >            }
> >
> >Otherwise said, the ocelot driver itself is already not self-coherent,
> >since immediately after probe time, and immediately after removal from a
> >bridge, it behaves in different ways, although the front panel ports are
> >standalone in both cases.
> Maybe you found a bug, maybe you have different expectations.
>
> The idea is that after probe time all the ports must behave as NIC
> devices. No forwarding are being done, and all traffic is copied to the
> CPU.
>

Yup.

> When a port is added to the bridge, the given ports-bit must be set in
> the PGID_SRC.
>

Yup.

> As I read the code, this seems to be done right. If you believe you have
> found a bug regarding this then please clarify this a bit.
>

Writing BIT(ocelot->cpu) into PGID_SRC + p is only done from
ocelot_bridge_stp_state_set. That function does not get called at
probe time. So BIT(ocelot->cpu) is not present in PGID_SRC + p at
probe time.

> >While standalone traffic _does_ work for the Felix DSA wrapper after
> >enslaving and removing the ports from a bridge, this patch makes
> >standalone traffic work at probe time too, with the caveat that even
> >irrelevant frames will get processed by software, making it more
> >susceptible to potential denial of service.
> >
> >Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >---
> > drivers/net/ethernet/mscc/ocelot.c | 12 ++++++++++++
> > 1 file changed, 12 insertions(+)
> >
> >diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> >index 86d543ab1ab9..94d39ccea017 100644
> >--- a/drivers/net/ethernet/mscc/ocelot.c
> >+++ b/drivers/net/ethernet/mscc/ocelot.c
> >@@ -2297,6 +2297,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
> >                         enum ocelot_tag_prefix injection,
> >                         enum ocelot_tag_prefix extraction)
> > {
> >+       int port;
> >+
> >+       for (port = 0; port < ocelot->num_phys_ports; port++) {
> >+               /* Disable old CPU port and enable new one */
> >+               ocelot_rmw_rix(ocelot, 0, BIT(ocelot->cpu),
> >+                              ANA_PGID_PGID, PGID_SRC + port);
> I do not understand why you have an "old" CPU. The ocelot->cpu field is
> not initialized at this point (at least not in case of Ocelot).
>
> Are you trying to move the NPI port?
>

Yes, that's what this function does. It sets the NPI port. It should
be able to work even if called multiple times (even though the felix
and ocelot drivers both call it exactly one time).
But I can (and will) remove/simplify the logic for the "old" CPU port.
I had the patch formatted already, and I didn't want to change it
because I was lazy to re-test after the changes.

> >+               if (port == cpu)
> >+                       continue;
> >+               ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
> >+                              ANA_PGID_PGID, PGID_SRC + port);
> So you want all ports to be able to forward traffic to your CPU port,
> regardless of if these ports are member of a bridge...
>

Yes.

> I have read through this several times, and I'm still not convinced I
> understood it.
>
> Can you please provide a specific example of how things are being
> forwarded (wrongly), and describe how you would like them to be
> forwarded.

Be there 4 net devices: swp0, swp1, swp2, swp3.
At probe time, the following doesn't work on the Felix DSA driver:
ip addr add 192.168.1.1/24 dev swp0
ping 192.168.1.2
But if I do this:
ip link add dev br0 type bridge
ip link set dev swp0 master br0
ip link set dev swp0 nomaster
ping 192.168.1.2
Then it works, because the code path from ocelot_bridge_stp_state_set
that puts the CPU port in the forwarding mask of the other ports gets
executed on the "bridge leave" action.
The whole point is to have the same behavior at probe time as after
removing the ports from the bridge.

The code with ocelot_mact_learn towards PGID_CPU for the MAC addresses
of the switch port netdevices is all bypassed in Felix DSA. Even if it
weren't, it isn't the best solution.
On your switch, this test would probably work exactly because of that
ocelot_mact_learn. But try to receive packets sent at any other
unicast DMAC immediately after probe time, and you should see them in
tcpdump but won't.

>
> /Allan
>

Regards,
-Vladimir
