Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529A7284936
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 11:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFJUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 05:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 05:20:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E227C061755;
        Tue,  6 Oct 2020 02:20:21 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id h24so10003668ejg.9;
        Tue, 06 Oct 2020 02:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QEFUhgHBOGUBmIFPYBdTtbDlyFkBZQsVm2M2SQfag20=;
        b=X6JDQ/+vK4NlW0uam0kIo5dDU2yaW14FFvDo8fgi1nqM/ySY7cCfb6NuRjgHeB9A8e
         PUMOYnojSuM39wr96UMhnfv5H9xKanhTGvgg55kzrH39mqDrLoJaVYi7FDSY/dh7hcO/
         9I8Tqb4D9Nko2ZdU0EfGGWP8mnEN6EkpWrqIyVpMMsLlJfkigv7vuURTc0YFPHHgMCrP
         PTBSVEUCv3tg+jO4a3tNBJmFub0fSgyZdYw+YLmGfky2ZGFnAv9aqAB5cZIBVtmGJL+U
         Q56iGL7gvhOs/kKCDSgBelnBleN1cLIRj5CZXiTF0WNIkNpYx7Xo7jVs2Y8THtfu+yKy
         VlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QEFUhgHBOGUBmIFPYBdTtbDlyFkBZQsVm2M2SQfag20=;
        b=U8/7NEk6ONS5/JmrFedzACCf+ubxjjpTVove3IFZStxQFLfsJpoYP6Kc+OdlEfIgKk
         4uJpcq4oEByNKpZV6X0mWalo2QmPWP2wAUIqKIdVZhLiuQEd+5Qm2w7IlCQK6Y9mukU8
         fujXmBmOd8FkkIxOscrToBIC5kIH3AH1XYH0wO/PHI7jsvcO5ZvrRMJ83qwxfMjPyocC
         dXYzf4Ih42DMMP4iInztLnICnBiy6T/Od/IscOoq8Rtcorp0+niwQfj1e76q8Y4Ld7P0
         UqAiSLW+Ed6NvI/Z4EAibdQTuXBAoRG1jX+ewgc4gaUhTAaugrmQi59rdz+Ju9N+5SEJ
         dpxg==
X-Gm-Message-State: AOAM530jxThgeCnoDsvodJZlYOJrgMXopLPiJeQs0WutxfKaqCGlfrZa
        4RcBwPhIUELDlqVNXHSqWFY=
X-Google-Smtp-Source: ABdhPJztHMPHPpGnKB7qzmaUOockFNekVz54rqjcEM3VR9d4csUbvGcMyZEtJGtOifqKXe1if8keBA==
X-Received: by 2002:a17:906:249a:: with SMTP id e26mr4162116ejb.484.1601976019077;
        Tue, 06 Oct 2020 02:20:19 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id h22sm1707064ejc.80.2020.10.06.02.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 02:20:18 -0700 (PDT)
Date:   Tue, 6 Oct 2020 12:20:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201006092017.znfuwvye25vsu4z7@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfgj997g.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 08:09:39AM +0200, Kurt Kanzenbach wrote:
> On Sun Oct 04 2020, Vladimir Oltean wrote:
> > I don't think this works.
> >
> > ip link add br0 type bridge vlan_filtering 1
> > ip link set swp0 master br0
> > bridge vlan add dev swp0 vid 100
> > ip link set br0 type bridge vlan_filtering 0
> > bridge vlan del dev swp0 vid 100
> > ip link set br0 type bridge vlan_filtering 1
> >
> > The expectation would be that swp0 blocks vid 100 now, but with your
> > scheme it doesn't (it is not unapplied, and not unqueued either, because
> > it was never queued in the first place).
> 
> Yes, that's correct. So, I think we have to queue not only the addition
> of VLANs, but rather the "action" itself such as add or del. And then
> apply all pending actions whenever vlan_filtering is set.

Please remind me why you have to queue a VLAN addition/removal and can't
do it straight away? Is it because of private VID 2 and 3, which need to
be deleted first then re-added from the bridge VLAN group?

> >> +static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
> >> +				      struct net_device *br)
> >> +{
> >> +	struct hellcreek *hellcreek = ds->priv;
> >> +	int i;
> >> +
> >> +	dev_dbg(hellcreek->dev, "Port %d joins a bridge\n", port);
> >> +
> >> +	/* Configure port's vid to all other ports as egress untagged */
> >> +	for (i = 0; i < ds->num_ports; ++i) {
> >> +		if (!dsa_is_user_port(ds, i))
> >> +			continue;
> >> +
> >> +		if (i == port)
> >> +			continue;
> >> +
> >> +		hellcreek_apply_vlan(hellcreek, i, port, false, true);
> >> +	}
> >
> > I think this is buggy when joining a VLAN filtering bridge. Your ports
> > will pass frames with VID=2 with no problem, even without the user
> > specifying 'bridge vlan add dev swp0 vid 2', and that's an issue. My
> > understanding is that VLANs 1, 2, 3 stop having any sort of special
> > meaning when the upper bridge has vlan_filtering=1.
> 
> Yes, that understanding is correct. So, what happens is when a port is
> joining a VLAN filtering bridge is:
> 
> |root@tsn:~# ip link add name br0 type bridge
> |root@tsn:~# ip link set dev br0 type bridge vlan_filtering 1
> |root@tsn:~# ip link set dev lan0 master br0
> |[  209.375055] br0: port 1(lan0) entered blocking state
> |[  209.380073] br0: port 1(lan0) entered disabled state
> |[  209.385340] hellcreek ff240000.switch: Port 2 joins a bridge
> |[  209.391584] hellcreek ff240000.switch: Apply VLAN: port=3 vid=2 pvid=0 untagged=1
> |[  209.399439] device lan0 entered promiscuous mode
> |[  209.404043] device eth0 entered promiscuous mode
> |[  209.409204] hellcreek ff240000.switch: Enable VLAN filtering on port 2
> |[  209.415716] hellcreek ff240000.switch: Unapply VLAN: port=2 vid=2
> |[  209.421840] hellcreek ff240000.switch: Unapply VLAN: port=0 vid=2

Now I understand even less. If the entire purpose of
hellcreek_setup_vlan_membership is to isolate lan0 from lan1, then why
do you even bother to install vid 2 to port=3 (lan1) when joining a
bridge, be it vlan_filtering or not? In bridged mode, they don't need
a unique pvid, it only complicates the implementation. They can have the
pvid from the bridge VLAN group.

> |[  209.428170] hellcreek ff240000.switch: Apply queued VLANs: port2
> |[  209.434158] hellcreek ff240000.switch: Apply VLAN: port=2 vid=0 pvid=0 untagged=0
> |[  209.441649] hellcreek ff240000.switch: Clear queued VLANs: port2
> |[  209.447920] hellcreek ff240000.switch: Apply queued VLANs: port0
> |[  209.453910] hellcreek ff240000.switch: Apply VLAN: port=0 vid=0 pvid=0 untagged=0
> |[  209.461402] hellcreek ff240000.switch: Clear queued VLANs: port0
> |[  209.467620] hellcreek ff240000.switch: VLAN prepare for port 2
> |[  209.473476] hellcreek ff240000.switch: VLAN prepare for port 0
> |[  209.479534] hellcreek ff240000.switch: Add VLANs (1 -- 1) on port 2, untagged, PVID
> |[  209.487164] hellcreek ff240000.switch: Apply VLAN: port=2 vid=1 pvid=1 untagged=1
> |[  209.494659] hellcreek ff240000.switch: Add VLANs (1 -- 1) on port 0, untagged, no PVID
> |[  209.502794] hellcreek ff240000.switch: Apply VLAN: port=0 vid=1 pvid=0 untagged=1
> |root@tsn:~# bridge vlan show

This is by no means a good indicator for anything. It shows the bridge
VLAN groups, not the hardware database.

> |port    vlan ids
> |lan0     1 PVID Egress Untagged
> |
> |br0      1 PVID Egress Untagged
> 
> ... which looks correct to me. The VLAN 2 is unapplied as expected. Or?

Ok, it gets applied in .port_bridge_join and unapplied in .port_vlan_filtering,
which is a convoluted way of doing nothing.

> >
> > And how do you deal with the case where swp1 and swp2 are bridged and
> > have the VLAN 3 installed via 'bridge vlan', but swp3 isn't bridged?
> > Will swp1/swp2 communicate with swp3? If yes, that's a problem.
> 
> There is no swp3. Currently there are only two ports and either they are
> bridged or not.

So this answers my question of whether the tunnel port is a user port or
not, ok.

How about other hardware revisions? Is this going to be a 2-port switch
forever? Your solution will indeed work for 2 ports (as long as you
address the other feedback from v5 w.r.t. declaring the ports as "always
filtering" and rejecting invalid 8021q uppers, which I don't see here),
but it will not scale for 3 ports, due to the fact that the bridge can
install a VLAN on a lan2 port, without knowing that it is in fact the
private pvid of lan1 or lan0.

> >> +static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
> >> +			       const struct hellcreek_fdb_entry *entry)
> >> +{
> >> +	dev_dbg(hellcreek->dev, "Delete FDB entry: MAC=%pM!\n", entry->mac);
> >> +
> >
> > Do these dev_dbg statements bring much value at all, even to you?
> 
> Yes, they do. See the log snippet above.
> 

If you want to dump the hardware database you can look at the devlink
regions that Andrew added very recently. Much more reliable than
following the order of operations in the log.

> >> +static const struct hellcreek_platform_data de1soc_r1_pdata = {
> >> +	.num_ports	 = 4,
> >> +	.is_100_mbits	 = 1,
> >> +	.qbv_support	 = 1,
> >> +	.qbv_on_cpu_port = 1,
> >
> > Why does this matter?
> 
> Because Qbv on the CPU port is a feature and not all switch variants
> have that. It will matter as soon as TAPRIO is implemented.

How do you plan to install a tc-taprio qdisc on the CPU port?
