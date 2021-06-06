Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E6D39D108
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 21:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFFT3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 15:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhFFT3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 15:29:41 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C62C061766;
        Sun,  6 Jun 2021 12:27:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ci15so22890661ejc.10;
        Sun, 06 Jun 2021 12:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kwLpsaMsWkVJ1T6oWouZGFmodFghrfNy99oCZ6B0+9E=;
        b=C7akB2sPGu1EiioFGAgI41M8ZBhH2uKJmGxHhb7xXPL2e+KXXTlOxkw2CIT1/etfqn
         J+lqMeUBc+mKOktRjtEIqTgkWYH0dugO1VhgIcVk3hahRUwi6rkl+4Jt2LuovSa8tg+g
         cfY90a0jSk9TTFgtMVtjVj534e1m3cEOmJvBibQKgta3O9OO6YXr+Dp42v0adi7C44RD
         mW8CSmMSIiTaaUHu3PBfzyCX+9kOZuv6qJD0S3JSrdlXrNMlBNzMDWUE2VicqtSlIJoP
         H3jAsNvwq1nXRnMM5lOpdHfYTVxZl7L8Cj893rQKaDAvqlsVenkba4k1lpgEw5KCBbgS
         aJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kwLpsaMsWkVJ1T6oWouZGFmodFghrfNy99oCZ6B0+9E=;
        b=qcbeRU7do5c7i7o+jC2+uxfTQi7C/t/+6b9FKpRZmPj0gwX5gi/Aoi/Tw4OR6o5rMl
         j+eBg0bgn1cchYzLR087HoRJPsOltxQzEARwhCOO0BnAxsK4q1luTQk521qkvITD6lvL
         i8bPj/hvRgPhpy2EjRpQ7hUiLc7Yzfxh9/uZ6hOjaFN7W9Tl48vV+vXvER3QDyXpo56c
         nkghPTtFX8UhzV0E6+ZbxWUOOAWD6f+Ck8pfX1VApDZUjFnIrKYzqpEDKDSCpamKkWhN
         yiYL+ZRidFC7kWJ10LvGshLuK0eJ9gyo176GwnoIkgAawCYQ4/8j5+sI8Y5mt1k36IpF
         MUhQ==
X-Gm-Message-State: AOAM532m9BidQ+NtMV8rGvfJxzpLIlnw/R2oa0ZaeupqdziHH/aGW/FI
        DcEEmX2HpdWEl5VyKets3Zxmez+6+oI=
X-Google-Smtp-Source: ABdhPJwH8zBLnSLh+iddO3nGrS8cECnQkS+FXxsA7Xnq1yx+v8nbdlaos8yvRMbgunNZk1znzZ3oeQ==
X-Received: by 2002:a17:906:8041:: with SMTP id x1mr14399177ejw.81.1623007669700;
        Sun, 06 Jun 2021 12:27:49 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id v1sm5561146ejw.117.2021.06.06.12.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 12:27:49 -0700 (PDT)
Date:   Sun, 6 Jun 2021 22:27:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
Message-ID: <20210606192748.3txhzfzhoxsp3czp@skbuf>
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch>
 <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
 <20210606005335.iuqi4yelxr5irmqg@skbuf>
 <9f07737c-f80b-6bd1-584a-a81a265d73eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f07737c-f80b-6bd1-584a-a81a265d73eb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 02:09:24PM +0100, Matthew Hagan wrote:
> On 06/06/2021 01:53, Vladimir Oltean wrote:
> 
> > It is a bit unconventional for the upstream Broadcom switch, which is a
> > DSA master of its own, to insert a VLAN ID of zero out of the blue,
> > especially if it operates in standalone mode. Supposedly sw0 and sw1 are
> > not under a bridge net device, are they?
> 
> sw0 and sw1 are brought up but otherwise left unconfigured. The bridge
> consists of the user ports only (wanN and swNpN). A side note here is that
> your "net: dsa: don't set skb->offload_fwd_mark when not offloading the
> bridge" patch is also in use. Would setting up a bridge for sw0/sw1 not
> have implications for receiving unknown frames on one port, that have been
> sent from another port of the same switch? Since unknown frames will go to
> the CPU, dp->bridge_dev would return the bridge name, setting
> offload_fwd_mark=1 thus preventing those frames being sent back out
> sw0/sw1 to its other ports.

What you have is called "cross-chip bridging for disjoint DSA trees" and
has some level of support since this series:
http://patchwork.ozlabs.org/project/netdev/cover/20200510163743.18032-1-olteanv@gmail.com/

What you can/should do is:

create a bridge between sw0 and sw1 (say br1)
create another bridge between wanN and swNpM (say br0)

Here's the secret:

- the br1 bridge only performs hardware acceleration for forwarding
  between the 2 QCA switches. The Broadcom switch is still able to
  understand enough (aka the destination MAC) of the packets coming from
  the QCA switches, even if they are DSA tagged, in order to perform L2
  forwarding to the other port or to the CPU port. And because br0 != br1,
  what you mentioned above for skb->offload_fwd_mark does not actually
  matter - there are only 2 ports in br1, and both are part of the same
  hardware domain, so the software bridge doesn't need to forward any
  packet. As for br0, by the time the packets from swNpM reach the
  software bridge, there is no longer any indication that they were
  originally processed by the Broadcom ports as DSA masters, so there is
  no problem forwarding them in software to the other Broadcom ports
  (not DSA masters).
- the br0 bridge, in the presence of br1, doesn't have to do software
  forwarding of packets between the 2 QCA switches - br1 handles it. But
  even if br1 did not exist, it still could. How?
  nbp_switchdev_allowed_egress() will happily forward packets between
  ports with different offload_fwd_mark values. These are derived from:

  nbp_switchdev_mark_set
  -> dev_get_port_parent_id
     -> devlink_compat_switch_id_get
        -> &devlink_port->attrs.switch_id

  populated by &devlink_port->attrs.switch_id based on dst->index.

  Otherwise said, the devlink switch id is equal to the DSA switch tree
  index.

  But you already set the dsa,member properties properly (i.e. each QCA
  switch is in its own tree with a unique index):

    switch@10 {
        compatible = "qca,qca8337";
        dsa,member = <1 0>;
    };

    switch@10 {
        compatible = "qca,qca8337";
        dsa,member = <2 0>;
    };

  So there is in fact no problem.

The "net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge"
patch was not accepted yet, am I right?
https://patchwork.kernel.org/project/netdevbpf/patch/20210318231829.3892920-15-olteanv@gmail.com/
Why are you using RFC patches instead of asking for them to be submitted
properly? :)

Regardless of that patch being present or not (which affects a different
use case which I cannot see how it relates to this), I think there is a bug:

if the DSA master sets skb->offload_fwd_mark = true, and then the DSA
tagger gets to process that same skb, and it wants to indicate it is a
standalone / non-offloading port, currently it will simply not set
skb->offload_fwd_mark = true. But not setting it to true is different
than always setting skb->offload_fwd_mark to true or false - it just
works because we assume that skb->offload_fwd_mark is initially false,
which is obv not true if the DSA master had already set it to true.
So if there is a provable bug caused by this, we might need a patch
which sets skb->offload_fwd_mark = false in dsa_switch_rcv(), right
before the call to cpu_dp->rcv(), in order to satisfy the taggers'
expectation that we do indeed start from a blank slate.
Does that make sense?

> >
> > If I'm not mistaken, this patch should solve your problem?
> >
> > -----------------------------[ cut here ]-----------------------------
> > diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> > index 3ca6b394dd5f..d6655b516bd8 100644
> > --- a/drivers/net/dsa/b53/b53_common.c
> > +++ b/drivers/net/dsa/b53/b53_common.c
> > @@ -1462,6 +1462,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
> >  	struct b53_device *dev = ds->priv;
> >  	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> >  	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> > +	bool really_untagged = false;
> >  	struct b53_vlan *vl;
> >  	int err;
> >  
> > @@ -1474,10 +1475,10 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
> >  	b53_get_vlan_entry(dev, vlan->vid, vl);
> >  
> >  	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
> > -		untagged = true;
> > +		really_untagged = true;
> >  
> >  	vl->members |= BIT(port);
> > -	if (untagged && !dsa_is_cpu_port(ds, port))
> > +	if (really_untagged || (untagged && !dsa_is_cpu_port(ds, port)))
> >  		vl->untag |= BIT(port);
> >  	else
> >  		vl->untag &= ~BIT(port);
> > -----------------------------[ cut here ]-----------------------------
> >
> This does seem to sort the issue as well in this case. Thanks!

I'm sure Florian will explain some of the additional constraints around
why we might want the Broadcom switches to send untagged packets as
tagged with VID 0 towards the CPU, so the patch might suffer some
changes until submitted proper. At the very least, the same configuration
needs to work regardless of the value of CONFIG_VLAN_8021Q.
Currently, the default VLAN configuration done by b53_configure_vlan()
is overwritten by:

vlan_device_event (the "adding VLAN 0 to HW filter on device %s" message)
-> vlan_vid_add
   -> ...
      -> dsa_slave_vlan_rx_add_vid
         -> dsa_port_vlan_add
            -> ...
               -> b53_vlan_add

so my point is that it is not robust to only fix the case where this
chain of events happens, because CONFIG_VLAN_8021Q is entirely optional,
and if it is not enabled, nobody will add VID 0 to the RX filter of the
net devices, so the configuration of VID 0 on the Broadcom ports will be
left as it is done by the switch initialization code, and that code
should produce the same results.
