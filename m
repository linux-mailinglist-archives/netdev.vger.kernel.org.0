Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977572CACF9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbgLAUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbgLAUFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:05:07 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9F8C0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 12:04:26 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k4so5264734edl.0
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 12:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ye7YK5tMALm1/rqbmQSnFkawNMHZj2hGCtRHnPC2/34=;
        b=fHXWY8imxNAPr6v9V1xrypQw17zQ2lui/gnpeqs/xxx+Wfrd/2uf17++qHlbwM24gB
         zFfOWRDkDNPmElUc07EJRv5QPAJ70FpaUx+NjnaoE6lbqUqzfXK/72J15SxWJRr8yKjQ
         5NiMbuIeHrAD4jrQxoPkJgjVEc3OOHyp3W4SJLSEIvrwuH6h/1eyhHEbgSfVnqh6fczT
         L1gxUtKbxDhTIA/W9oKJxQ40eGpXAnMewoNktggoCg3rmO1s/kHqfxtIzJ1ZyJCfWZkk
         QRzpSPhzCJm8reEgws953V0kjx0+du1SjgFNt4sNNuvuCBIfwtFf1mQbneXBNuwuC0vO
         Qy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ye7YK5tMALm1/rqbmQSnFkawNMHZj2hGCtRHnPC2/34=;
        b=FA+0DMgxp/8EhIFjeWZ4FU3ajcwla5cTYAc1P4E7xuTT8QUwnqid7RQt2kwpNisWOd
         K174TZPuH4eS6pWZ+M7coVO5/KtVrDR7qzeznbgd1RkqgolY8AfZ39GESDaTpA+hdl1H
         s3zje5mJPWfELyyi07zpmqHwZtsoh40l6tSYJbHYrCpp6JwMWFjhUpz9dZaRvzWWwU1l
         FBRYKVbl0yR6Ht7u2Jiz0dR3JjAxy9i3PPlHAOR+XVivvFC6VmPaGX4vYJrzr/C40zZH
         rxPkqy23jbxhtnk6v7MIP2KmpvDphPlMOxZJL81mdH+xF/zE+bz24SY5/vWJGaIqxl42
         TRzQ==
X-Gm-Message-State: AOAM53004VQS8qgq3MXZK9N5i0WcCH4WSZZlup4eaPO64q4hDRGdGs/E
        j8Lr9lOlgr6NGXW7fbuUEuI=
X-Google-Smtp-Source: ABdhPJyTLK7JPpkHYjBOxRib8BXHMVOtUDTKFGIfpj994yVb45wuAP2iVc/EdtERKwgngWqCdHmAYg==
X-Received: by 2002:a50:cd0a:: with SMTP id z10mr4779568edi.223.1606853065336;
        Tue, 01 Dec 2020 12:04:25 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id d1sm331289eje.82.2020.12.01.12.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 12:04:24 -0800 (PST)
Date:   Tue, 1 Dec 2020 22:04:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201201200423.mujxza7g7gsgntbg@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-3-tobias@waldekranz.com>
 <20201201140354.lnhwx3ix2ogtnngy@skbuf>
 <871rg98uqm.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rg98uqm.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 03:29:53PM +0100, Tobias Waldekranz wrote:
> On Tue, Dec 01, 2020 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
> >> When a LAG joins a bridge, the DSA subsystem will treat that as each
> >> individual port joining the bridge. The driver may look at the port's
> >> LAG pointer to see if it is associated with any LAG, if that is
> >> required. This is analogue to how switchdev events are replicated out
> >> to all lower devices when reaching e.g. a LAG.
> >
> > Agree with the principle. But doesn't that mean that this code:
> >
> > static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
> > 					      unsigned long event, void *ptr)
> > {
> > 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
> > 	int err;
> >
> > 	switch (event) {
> > 	case SWITCHDEV_PORT_OBJ_ADD:
> > 		err = switchdev_handle_port_obj_add(dev, ptr,
> > 						    dsa_slave_dev_check,
> > 						    dsa_slave_port_obj_add);
> > 		return notifier_from_errno(err);
> > 	case SWITCHDEV_PORT_OBJ_DEL:
> > 		err = switchdev_handle_port_obj_del(dev, ptr,
> > 						    dsa_slave_dev_check,
> > 						    dsa_slave_port_obj_del);
> > 		return notifier_from_errno(err);
> > 	case SWITCHDEV_PORT_ATTR_SET:
> > 		err = switchdev_handle_port_attr_set(dev, ptr,
> > 						     dsa_slave_dev_check,
> > 						     dsa_slave_port_attr_set);
> > 		return notifier_from_errno(err);
> > 	}
> >
> > 	return NOTIFY_DONE;
> > }
> >
> > should be replaced with something that also reacts to the case where
> > "dev" is a LAG? Like, for example, I imagine that a VLAN installed on a
> > bridge port that is a LAG should be propagated to the switch ports
> > beneath that LAG. Similarly for all bridge attributes.
>
> That is exactly what switchdev_handle_* does, no? It is this exact
> behavior that my statement about switchdev event replication references.

I'm sorry, I don't mean to be overly obtuse, but _how_ does the current
code propagate a VLAN to a physical port located below a bond? Through
magic? The dsa_slave_dev_check is passed as a parameter to
switchdev_handle_port_obj_add _exactly_ because the code has needed so
far to match only on DSA interfaces and not on bonding interfaces. So
the code does not react to VLANs added on a bonding interface. Hence my
question.

ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
ip link set swp0 master br0

This should propagate the VLANs to swp1 and swp2 but doesn't:
bridge vlan add dev bond0 vid 100

It's perfectly acceptable to say that this patch set doesn't deal with
that. But your commit message seems to suggest that it's me who's
misunderstanding something.
