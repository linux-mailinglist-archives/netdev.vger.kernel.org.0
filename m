Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6DA2CAFE8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgLAWYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgLAWYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:24:30 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3ACC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 14:23:44 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id a16so7766837ejj.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 14:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K8WmZ3M06uWqy5r5OOjN+z0v2tjV/tGGlBiY/6cWnTE=;
        b=UZ6fRywzMXtOOSTB1Cb0/zhmJscoCaUmq7cSj/jrKer++aJiazvK1fMdgUHTm2erwj
         g61OsHVbiywHq6CPeUKZPoSZ/XXnxOYv9WHlg1Ym+ZF7iXFy2cBamrQ7X2ENINrM1JxI
         jM4oEKHBUMW6hClpL1zZEWrXI46ndNpNbOCyw+9SX5WU2+2pPNjD0amYFtUppdFRQAfk
         6pI3py2TAJvHoGrWhzEAVjRtLBHcZg+p3/nH0CpqQi/BJsVamPOw2HtIUcyHAw6kudTX
         DgLt0Vpu8jK5+neoGux+sz3o3/4Cyq2yq8KOuSXLwjsCfMmVsfNQj1lxSv3Ibu/HXrt4
         sYVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K8WmZ3M06uWqy5r5OOjN+z0v2tjV/tGGlBiY/6cWnTE=;
        b=EnL2XrlOfx0mvx57Plqgh0nbIRaNsSdRNwJFuN8mNkpb62X4eFMzuxc2tH0lfCU54M
         /pd3LcmteQxSF//EL1Cj6VSP08kRA5k7BbV3lOr1qlRlDHKB6c/YnrqnW4zC40FNw0zU
         qVS7RT87fmprHxZoU7Ufzha7KteJwnSWUXlibMOEKwnf8/+OCQLx81MIy9dd1lS0Qflu
         J1RpRKPJCete8Jmj3r9cNSTos8DPlveOWtWzJuLCX29B/oZCxZ95DoQZ6g9lE7hzaAPH
         cMCtVGGSnJzlXZF+6fNeGZpLaW4z6XljjlM6hsUb/tn4SpXIU45O0mMMepA3vo06rn6l
         qJuA==
X-Gm-Message-State: AOAM531NmK0tqB7V31U2IhiLcZaNcqp4gLdSBLX8dWsA8U75iKi+0pR4
        0DoQ+rS7Cri/oHXaYK0gOPA=
X-Google-Smtp-Source: ABdhPJyz6IEREylzyKi/m2VzkHwDg9qKML7WZvkaHJ2u/DhCOv1XTzdd5VG0qrEGuzla5Kz/B1cUtA==
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr601525ejd.180.1606861422939;
        Tue, 01 Dec 2020 14:23:42 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id a6sm534689edv.74.2020.12.01.14.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 14:23:42 -0800 (PST)
Date:   Wed, 2 Dec 2020 00:23:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201201222341.6lywc5qmcpafmp4u@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-3-tobias@waldekranz.com>
 <20201201140354.lnhwx3ix2ogtnngy@skbuf>
 <871rg98uqm.fsf@waldekranz.com>
 <20201201200423.mujxza7g7gsgntbg@skbuf>
 <87wny16vv1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wny16vv1.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 10:48:34PM +0100, Tobias Waldekranz wrote:
> On Tue, Dec 01, 2020 at 22:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Dec 01, 2020 at 03:29:53PM +0100, Tobias Waldekranz wrote:
> >> On Tue, Dec 01, 2020 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
> >> >> When a LAG joins a bridge, the DSA subsystem will treat that as each
> >> >> individual port joining the bridge. The driver may look at the port's
> >> >> LAG pointer to see if it is associated with any LAG, if that is
> >> >> required. This is analogue to how switchdev events are replicated out
> >> >> to all lower devices when reaching e.g. a LAG.
> >> >
> >> > Agree with the principle. But doesn't that mean that this code:
> >> >
> >> > static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
> >> > 					      unsigned long event, void *ptr)
> >> > {
> >> > 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> >> > 	int err;
> >> >
> >> > 	switch (event) {
> >> > 	case SWITCHDEV_PORT_OBJ_ADD:
> >> > 		err = switchdev_handle_port_obj_add(dev, ptr,
> >> > 						    dsa_slave_dev_check,
> >> > 						    dsa_slave_port_obj_add);
> >> > 		return notifier_from_errno(err);
> >> > 	case SWITCHDEV_PORT_OBJ_DEL:
> >> > 		err = switchdev_handle_port_obj_del(dev, ptr,
> >> > 						    dsa_slave_dev_check,
> >> > 						    dsa_slave_port_obj_del);
> >> > 		return notifier_from_errno(err);
> >> > 	case SWITCHDEV_PORT_ATTR_SET:
> >> > 		err = switchdev_handle_port_attr_set(dev, ptr,
> >> > 						     dsa_slave_dev_check,
> >> > 						     dsa_slave_port_attr_set);
> >> > 		return notifier_from_errno(err);
> >> > 	}
> >> >
> >> > 	return NOTIFY_DONE;
> >> > }
> >> >
> >> > should be replaced with something that also reacts to the case where
> >> > "dev" is a LAG? Like, for example, I imagine that a VLAN installed on a
> >> > bridge port that is a LAG should be propagated to the switch ports
> >> > beneath that LAG. Similarly for all bridge attributes.
> >>
> >> That is exactly what switchdev_handle_* does, no? It is this exact
> >> behavior that my statement about switchdev event replication references.
> >
> > I'm sorry, I don't mean to be overly obtuse, but _how_ does the current
> > code propagate a VLAN to a physical port located below a bond? Through
> > magic? The dsa_slave_dev_check is passed as a parameter to
> > switchdev_handle_port_obj_add _exactly_ because the code has needed so
> > far to match only on DSA interfaces and not on bonding interfaces. So
> > the code does not react to VLANs added on a bonding interface. Hence my
> > question.
>
> There is no magic involved, here is the relevant snippet from
> __switchdev_handle_port_obj_add:
>
> 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
> 	 * unsupported devices, another driver might be able to handle them. But
> 	 * propagate to the callers any hard errors.
> 	 *
> 	 * If the driver does its own bookkeeping of stacked ports, it's not
> 	 * necessary to go through this helper.
> 	 */
> 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
> 		if (netif_is_bridge_master(lower_dev))
> 			continue;
>
> 		err = __switchdev_handle_port_obj_add(lower_dev, port_obj_info,
> 						      check_cb, add_cb);
> 		if (err && err != -EOPNOTSUPP)
> 			return err;
> 	}
>

Oh wow, such an odd place to put that. Especially since the entire
reason why switchdev uses notifiers is that you as a switchdev driver
can now explicitly intercept and offload switchdev objects that the
bridge emitted towards a driver that was "not you", such as a vxlan
interface. I guess that's still what's happening now, just that it's
completely non-obvious since it's hidden behind an opaque function.

Very interesting, thanks, I didn't know that.

> > ip link del bond0
> > ip link add bond0 type bond mode 802.3ad
> > ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
> > ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
> > ip link del br0
> > ip link add br0 type bridge
> > ip link set bond0 master br0
> > ip link set swp0 master br0
> >
> > This should propagate the VLANs to swp1 and swp2 but doesn't:
> > bridge vlan add dev bond0 vid 100
>
> I ran through this on my setup and it is indeed propagated to all ports.
>
> Just a thought, when you rebased the ocelot specific stuff to v2, did
> you add the number of supported LAGs to ds->num_lags? If not, DSA will
> assume that the hardware does not support offloading.

Ah, yes, that makes sense and that's what was happening. So DSA does the
right thing and does not offload bridge attributes to these ports,
because bonding needs to be done in software, and therefore even
bridging on swp1 and swp2 needs to be done in software. So as far as DSA
is concerned, swp1 and swp2 are standalone ports. This reminds me that I
need to do more testing for switches that can't offload bonding, to make
sure that they do the right thing.
