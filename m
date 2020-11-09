Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14FF2AB444
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgKIKDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgKIKDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:03:04 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D73C0613CF;
        Mon,  9 Nov 2020 02:03:04 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id ay21so8076785edb.2;
        Mon, 09 Nov 2020 02:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lq1EVF4b0inxzqXCcvQULCE2t/AsJKaH6qjbOpBxRK8=;
        b=XUi4cv9W7zhbNsQftYBbWs4ISImdmhCeh+gETox8tMYaIbSD6tEsQRFmMDkx4fJaQj
         CMYOamEDUutzTYChBFIjz7KOjH97bCIlpmNQAGsDD/22CFF6M4ZHKXEVeGvRb8IUprMi
         Ex2c9HkNW85WlicdEWrJ8R3qJ8s2XzChMHh+ak/Y7WGIx64Cil619rDqCSrnBZJoTmRL
         iijmzZZM1LMMvBQtR0VGGTRaPXZiML1XhzHAfrxjdUveaJdaxm0AnuY3CkW7VSGi/3Oc
         grarNj8ggtzQH5tVCZl87dlDlNS0wpixk734O7OZdiZvDiMzTrQTp4Lh1wXb3Bxb+F/Y
         HxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lq1EVF4b0inxzqXCcvQULCE2t/AsJKaH6qjbOpBxRK8=;
        b=JImzIJgbKhIuhygSdKAXJDmFn61v78LKsBvCAe44BSug0bSXhbm/76hhZ1Ksgw/32l
         12OG7b7TfcU2KLT1JSwm/V5wJqUCAejfi26ihPL3mq9FnpZTJ2qm/7SRkP/e5MZlc27G
         bKMHuqLCNAGCVM6WPBifj7MDNbRm4ng50BBqsICx1asoVI78Jv+cOJ5UzG/EKuzRH+vE
         5MZEUuLuQlGW5amLjBhw8levAJrG5Eu1hF9z8kxAwb0FuJtPgwzk94W6IbVOrra9q9q/
         nrZ9/WaC8YfrXPrkjBOzIisSKI5JlzfHaBkaPqi2PaiYpmZyjwsCkFu/gF4aORaXVTcF
         Kv1Q==
X-Gm-Message-State: AOAM531EzjlsVKR8uhg5T/qBdhC3VgXSftGAGAm54EFp5gwoAAUYdW3w
        U13CRP7AO717vMmvazeNeuU=
X-Google-Smtp-Source: ABdhPJyBhjSkzXNVeoAl7lkWw7dvZ/K1mGNkJoF/aTEumq9Rc4GX1n1N3/wFTlgPgESkWy8uGkEY3Q==
X-Received: by 2002:a50:950e:: with SMTP id u14mr14307123eda.260.1604916182809;
        Mon, 09 Nov 2020 02:03:02 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l16sm8328543ejd.70.2020.11.09.02.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 02:03:02 -0800 (PST)
Date:   Mon, 9 Nov 2020 12:03:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201109100300.dgwce4nvddhgvzti@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <20201108235939.GC1417181@lunn.ch>
 <20201109003028.melbgstk4pilxksl@skbuf>
 <87y2jbt0hq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2jbt0hq.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 09:09:37AM +0100, Tobias Waldekranz wrote:
> On Mon, Nov 09, 2020 at 02:30, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Nov 09, 2020 at 12:59:39AM +0100, Andrew Lunn wrote:
> >> We also need to make sure the static entries get removed correctly
> >> when a host moves. The mv88e6xxx will not replace a static entry with
> >> a dynamically learned one. It will probably rise an ATU violation
> >> interrupt that frames have come in the wrong port.
> >
> > This is a good one. Currently every implementer of .port_fdb_add assumes
> > a static entry is what we want, but that is not the case here. We want
> > an entry that can expire or the switch can move it to a different port
> > when there is evidence that it's wrong. Should we add more arguments to
> > the API?
>
> I don't think that would help. You would essentially be trading one
> situation where station moves causes loss of traffic for another
> one. But now you have also increased the background load of an already
> choked resource, the MDIO bus.

In practice, DSA switches are already very demanding of their management
interface throughput, for PTP and things like that. I do expect that if
you spent any significant amount of time with DSA, you already know the
ins and outs of your MDIO/SPI/I2C controller and it would already be
optimized for efficiency. But ok, we can add this to the list of cons.

> At least on mv88e6xxx, your only option to allow the hardware to move
> the station to another port autonomously is to add the entry as a
> dynamically learnt one. However, since the switch does not perform any
> SA learning on the CPU port in this world, the entry would have to be
> refreshed by software, otherwise it would just age out.
>
> Then you run in to this situation:
>
> A and B are communicating.
>
>        br0
>   .----'|'----.
>   |     |     |
> swp0  swp1  wlan0
>   |           |
>   A           B
>
> The switch's FDB:
> A: swp0
> B: cpu0 (due to this patchset)
>
> Now B roams to an AP somewhere behind swp1 and continues to communicate
> with A.
>
>        br0
>   .----'|'----.
>   |     |     |
> swp0  swp1  wlan0
>   |     |
>   A     B
>
> The switch's FDB:
> A: swp0
> B: swp1
>
> But br0 sees none of this, so at whatever interval we choose we will
> refresh the FDB, moving the station back to the cpu:
>
> A: swp0
> B: cpu0

No, br0 should see some traffic from station B. Not the unicast traffic
towards station A, of course (because that has already been learnt to go
towards swp0), but some broadcast ARP, or some multicast ND. This is the
big assumption behind any solution: that the stations are not silent and
make their presence known somehow.

> So now you have traded the issue of having to wait for the hardware to
> age out its entry, to the issue of having to wait for br0 to age out its
> entry. Right?

That's the thing.
The software bridge will never expire its entry in br_fdb_update if
traffic is continuously coming in. fdb->updated will just keep getting
larger and larger after each incoming packet. But the hardware bridge is
not aware of this traffic. So:
- if the hardware bridge has a dynamic entry installed (one that's
  subject to ageing), that entry will eventually expire within 5 minutes
  when its software equivalent won't. Then no switchdev event will ever
  come back to update the hardware bridge, since from the software's
  perspective it was never supposed to expire. It's as if we _do_ want
  the entry to be static. But:
- if the hardware bridge has a static entry installed, then that entry
  might become wrong and cause connectivity loss until the software
  bridge figures it out.
It's what Andrew described as a 'hybrid' entry. We would want a 'static'
entry (one that doesn't age out based on a timer) that is 'weak' (can be
overridden when traffic comes in on a different port). I'm not sure
either that such thing exists.

So for now, static entries are the best we've got. Let's re-run the
simulation knowing that we're working with static addresses towards the
CPU, to see how bad things are.

 AP 1:
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
       |                                                       ^        ^
       |                                                       |        |
       |                                                       |        |
       |                                                    Client A  Client B
       |
       |
       |
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 AP 2

- br0 of AP 1 will lean that Clients A and B are reachable via wlan0.
  The DSA switch will snoop these and add static entries towards the CPU
  port.
- the hardware fdb of the DSA switch, as well as br0 on AP 2, will learn
  that Clients A and B are reachable through swp0, because of our
  assumption of non-silent stations. There are no static entries
  involved on AP 2 for now.

Client B disconnects from AP 1 and roams to AP 2.

 AP 1:
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
       |                                                            ^
       |                                                            |
       |                                                         Client A
       |
       |
       |                                                         Client B
       |                                                            |
       |                                                            v
 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
 +------------+ +------------+ +------------+ +------------+ +------------+
 +------------------------------------------------------------------------+
 |                                          br0                           |
 +------------------------------------------------------------------------+
 AP 2

- br0 of AP 1 still knows that Client A is reachable via wlan0 (no change)
- In the general case, br0 of AP 1 will _NOT_ know that Client B has
  left wlan0. So there is still a static entry for Client B towards the
  CPU port.
- Right now, any attempt from Client A to directly address Client B via
  unicast would result, if the FDB were to be consulted, in packet
  drops, because the switch on AP 1 would say 'wait a minute, I'm
  receiving a packet for Client B from the CPU port, but Client B is
  reachable via the CPU port!'. Luckily for us, the switches that we're
  working with are not looking up the FDB for CPU injected traffic,
  remember? So I don't think this is a problem. So unicast packets would
  be delivered to anywhere that the software bridge wanted to. Right
  now, even the software bridge has a wrong impression of where Client B
  is.
- remember the assumption that Client B is not silent at startup. So
  some broadcast packets with Client B's source MAC address will reach
  the Ethernet segment. The hardware switch on AP 1 will have no problem
  accepting these packets, since they are broadcast/multicast. They will
  reach the software bridge. At this point, the software bridge finally
  learns the new destination for Client B, and it emits a new
  SWITCHDEV_FDB_ADD_TO_DEVICE event. Today we ignore that, because
  added_by_user will be false. That's what we do wrong/incomplete in
  this RFC patch set. We should keep track of static addresses installed
  on the CPU port, and if we ever receive a !added_by_user notification
  on a DSA switch port for one of those addresses, we should update the
  hardware FDB of the DSA switch on AP 1.

So there you have it, it's not that bad. More work needs to be done, but
IMO it's still workable.

But now maybe it makes more sense to treat the switches that perform
hardware SA learning on the CPU port separately, after I've digested
this a bit.
