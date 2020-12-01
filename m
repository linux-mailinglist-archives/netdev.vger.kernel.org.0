Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A012CAF22
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbgLAVtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730191AbgLAVtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:49:18 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841CEC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 13:48:37 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id j205so7644186lfj.6
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=mJ7Brq/ZADLrblvEcQ6/k7Wt2IK0S8Ci4tZ8/OKGLrI=;
        b=NzmN63AmZ96qinBLMS/uguxWfJjp69rZmsAjH48tjrd3Te+CeiaVzbOvUNTcs5100b
         pCbgzGMbQLwNd2A8gBOU/ZJcMkjelnkdsgOZWXH4TdYzEGrMDgQhCTGluGI0u9/VYxfh
         Ol81/PdutN9TACXRsZYS/zPcXaEYKEG3ABzLPfC29DB++ozKb7Rg8faVhUFccSMxy6gq
         Dy8nRoi8nELYHD4vgKw8SSmnbc2JoLJ/zvtds8s0pHpXKXEi1Fpg31Cm5VNe/9t2DoQZ
         dDsrIZVnSh+kcTCy7lO+mDyI8wPhkLWtD7Uhcay2fo/Zz245DgQ/RPHBE0QhUnA/OrKD
         vCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mJ7Brq/ZADLrblvEcQ6/k7Wt2IK0S8Ci4tZ8/OKGLrI=;
        b=Wyh9CdXAKloXNZxeggiOhDqoeQiTPyJOtcEgEX3yRyfpH+iugPTd1cbuKY3NRUK0CP
         CjqwdQLx40Cz5UamNXNOwpaQxApMQqkAlKUNZ2CwCEg7oOey6EFcv0UNMH1MmGA9IOAP
         31TMrFqnqhk+N506L8Xot7gJxdNkkvbAHawwQjiS9Lb4/jyomLkrQ133Jn0YC5457ZJD
         7sAEPMVOSqknfdaa0iw9NqDbexuNOmwxYVaEm6SnqEKKUqCYakIZfX4Uofx0E2SrSpIi
         kphkKQ5HrsYCNtTG0v0c7V3z/EKOkU43ihEh4YJtFijywYaYJ1tQMmYbBFZPU9vDT8jQ
         ls1w==
X-Gm-Message-State: AOAM5328QbyeyUOicFiXvQveFgRmmPnufUr20+yF2BnR17ixBkwKy82I
        YbPOovoCjE7YSoj1KvmTNlWVxhXpKJXq0BeX
X-Google-Smtp-Source: ABdhPJyndwx/DQL5TwLgpTwgmqv61d2DKMRG2APKaSe+fi6c843Vt8a6/STpqz38JJMnRhesZLNGZw==
X-Received: by 2002:a19:ef01:: with SMTP id n1mr2132486lfh.9.1606859315655;
        Tue, 01 Dec 2020 13:48:35 -0800 (PST)
Received: from wkz-x280 (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id m62sm109141lfd.233.2020.12.01.13.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 13:48:34 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201201200423.mujxza7g7gsgntbg@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com> <20201130140610.4018-3-tobias@waldekranz.com> <20201201140354.lnhwx3ix2ogtnngy@skbuf> <871rg98uqm.fsf@waldekranz.com> <20201201200423.mujxza7g7gsgntbg@skbuf>
Date:   Tue, 01 Dec 2020 22:48:34 +0100
Message-ID: <87wny16vv1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 22:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Dec 01, 2020 at 03:29:53PM +0100, Tobias Waldekranz wrote:
>> On Tue, Dec 01, 2020 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Mon, Nov 30, 2020 at 03:06:08PM +0100, Tobias Waldekranz wrote:
>> >> When a LAG joins a bridge, the DSA subsystem will treat that as each
>> >> individual port joining the bridge. The driver may look at the port's
>> >> LAG pointer to see if it is associated with any LAG, if that is
>> >> required. This is analogue to how switchdev events are replicated out
>> >> to all lower devices when reaching e.g. a LAG.
>> >
>> > Agree with the principle. But doesn't that mean that this code:
>> >
>> > static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
>> > 					      unsigned long event, void *ptr)
>> > {
>> > 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
>> > 	int err;
>> >
>> > 	switch (event) {
>> > 	case SWITCHDEV_PORT_OBJ_ADD:
>> > 		err = switchdev_handle_port_obj_add(dev, ptr,
>> > 						    dsa_slave_dev_check,
>> > 						    dsa_slave_port_obj_add);
>> > 		return notifier_from_errno(err);
>> > 	case SWITCHDEV_PORT_OBJ_DEL:
>> > 		err = switchdev_handle_port_obj_del(dev, ptr,
>> > 						    dsa_slave_dev_check,
>> > 						    dsa_slave_port_obj_del);
>> > 		return notifier_from_errno(err);
>> > 	case SWITCHDEV_PORT_ATTR_SET:
>> > 		err = switchdev_handle_port_attr_set(dev, ptr,
>> > 						     dsa_slave_dev_check,
>> > 						     dsa_slave_port_attr_set);
>> > 		return notifier_from_errno(err);
>> > 	}
>> >
>> > 	return NOTIFY_DONE;
>> > }
>> >
>> > should be replaced with something that also reacts to the case where
>> > "dev" is a LAG? Like, for example, I imagine that a VLAN installed on a
>> > bridge port that is a LAG should be propagated to the switch ports
>> > beneath that LAG. Similarly for all bridge attributes.
>>
>> That is exactly what switchdev_handle_* does, no? It is this exact
>> behavior that my statement about switchdev event replication references.
>
> I'm sorry, I don't mean to be overly obtuse, but _how_ does the current
> code propagate a VLAN to a physical port located below a bond? Through
> magic? The dsa_slave_dev_check is passed as a parameter to
> switchdev_handle_port_obj_add _exactly_ because the code has needed so
> far to match only on DSA interfaces and not on bonding interfaces. So
> the code does not react to VLANs added on a bonding interface. Hence my
> question.

There is no magic involved, here is the relevant snippet from
__switchdev_handle_port_obj_add:

	/* Switch ports might be stacked under e.g. a LAG. Ignore the
	 * unsupported devices, another driver might be able to handle them. But
	 * propagate to the callers any hard errors.
	 *
	 * If the driver does its own bookkeeping of stacked ports, it's not
	 * necessary to go through this helper.
	 */
	netdev_for_each_lower_dev(dev, lower_dev, iter) {
		if (netif_is_bridge_master(lower_dev))
			continue;

		err = __switchdev_handle_port_obj_add(lower_dev, port_obj_info,
						      check_cb, add_cb);
		if (err && err != -EOPNOTSUPP)
			return err;
	}


> ip link del bond0
> ip link add bond0 type bond mode 802.3ad
> ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
> ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
> ip link del br0
> ip link add br0 type bridge
> ip link set bond0 master br0
> ip link set swp0 master br0
>
> This should propagate the VLANs to swp1 and swp2 but doesn't:
> bridge vlan add dev bond0 vid 100

I ran through this on my setup and it is indeed propagated to all ports.

Just a thought, when you rebased the ocelot specific stuff to v2, did
you add the number of supported LAGs to ds->num_lags? If not, DSA will
assume that the hardware does not support offloading.

> It's perfectly acceptable to say that this patch set doesn't deal with
> that. But your commit message seems to suggest that it's me who's
> misunderstanding something.

I understand, that is why I explicitly mentioned the lack of static FDB
support for example. But it absolutely should deal with the full list I
specified, so thanks for testing it.
