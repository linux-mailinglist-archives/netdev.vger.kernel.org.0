Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518E7266417
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgIKQaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgIKQar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:30:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C9DC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:30:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id i26so14557194ejb.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yp3u69y5IrrYYzukUb5ypWMerlcQOUgOSGYUMQiQqT4=;
        b=ZmNHSuyOILKIQ4wSkzRSdT6LqY9aql0SykmZvEI9nvK37SAfdK9xfdIcAAmvqFVOaE
         LI1HDED2949IXPbBbscV9rBCqQHndD1pnQ3qDjI5sB9X6i2Llx721fa6+QiHhvsyOHel
         laCg1evE9Pz5AKD1zrqUnTYS5O6NF4Y9JWkuFXfmDgt+8BQX0wVLkt6EpEPB23NOt+QF
         O3MktgJnZvjXgNteOM/FFW178nuto02eN/eo0hW1Fcxnf3TLB35rCq8JAzYKxBY7uL2f
         1/xeaMjSs5JQO+hhcoqgpM7i9w7Gb3leXFtadzDogwQr1x1zD34VTsH3d5TVReGVq2Fk
         mAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yp3u69y5IrrYYzukUb5ypWMerlcQOUgOSGYUMQiQqT4=;
        b=WSgkb2GiAk1S4UonjyWAxk11vkHTPXjspqNTInSjLuklFEAqJBLind8qWv8Y4J0B+L
         oKIAQyf/pf7pgk5AqT9HIZjdzEmxiaayebKLH3YKuUTBKul9la0RT2/yW6WJwVmpR2Y1
         oeuoOCeWX1zL5kCNBc9XG54W87Ow0OXqL9OKa6gN55OL4Y/IPlPvjfKuBeeH+33ww8cy
         +Uqr7dp3HB9kPm8Q8SJv8wptrvnGZJql2MwRHe4ju8YPZEr/ZzByPPsNTCmJpj+DvsQu
         T/KmAeHdNTwWHoVQlYqTLSDx13b+VpfRwSz583buNVolpk+GKRTvV0XbWBudpdtGV5Lv
         /WEQ==
X-Gm-Message-State: AOAM5335M1r6xMGorLRjwZS76eWSVHJgR/xvLjDdnCvspIZADJyhKI7T
        hZanj4zheF2930XTFdnVskwVgDi4EQY=
X-Google-Smtp-Source: ABdhPJx8G92wkeHcMmjsqXr29w40wHX8mwq8WOkKTAsaM7J3Yu4zI7xvZQHhuF3zxgyvg+Or7LrqOQ==
X-Received: by 2002:a17:906:88d:: with SMTP id n13mr2897163eje.75.1599841845310;
        Fri, 11 Sep 2020 09:30:45 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id q27sm1822182ejd.74.2020.09.11.09.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 09:30:44 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:30:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: VLAN filtering with DSA
Message-ID: <20200911163042.u5xegcsfpwzh6zkf@skbuf>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <a5e0a066-0193-beca-7773-5933d48696e8@gmail.com>
 <20200911132058.GA3154432@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911132058.GA3154432@shredder>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 04:20:58PM +0300, Ido Schimmel wrote:
> On Thu, Sep 10, 2020 at 11:41:04AM -0700, Florian Fainelli wrote:
> > +Ido,
> >
> > On 9/10/2020 8:07 AM, Vladimir Oltean wrote:
> > > Florian, can you please reiterate what is the problem with calling
> > > vlan_vid_add() with a VLAN that is installed by the bridge?
> > >
> > > The effect of vlan_vid_add(), to my knowledge, is that the network
> > > interface should add this VLAN to its filtering table, and not drop it.
> > > So why return -EBUSY?
>
> Can you clarify when you return -EBUSY? At least in mlxsw we return an
> error in case we have a VLAN-aware bridge taking care of some VLAN and
> then user space tries to install a VLAN upper with the same VLAN on the
> same port. See more below.
>

In the original post Message-ID: <20200910150738.mwhh2i6j2qgacqev@skbuf>
I had copied this piece of code:

static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
				     u16 vid)
{
	...

	/* Check for a possible bridge VLAN entry now since there is no
	 * need to emulate the switchdev prepare + commit phase.
	 */
	if (dp->bridge_dev) {
		...
		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
		 * device, respectively the VID is not found, returning
		 * 0 means success, which is a failure for us here.
		 */
		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
		if (ret == 0)
			return -EBUSY;
	}
}

> > Most of this was based on discussions we had with Ido and him explaining to
> > me how they were doing it in mlxsw.
> >
> > AFAIR the other case which is that you already have a 802.1Q upper, and then
> > you add the switch port to the bridge is permitted and the bridge would
> > inherit the VLAN into its local database.
>
> If you have swp1 and swp1.10, you can put swp1 in a VLAN-aware bridge
> and swp1.10 in a VLAN-unaware bridge. If you add VLAN 10 as part of the
> VLAN-aware bridge on swp1, traffic tagged with this VLAN will still be
> injected into the stack via swp1.10.
>
> I'm not sure what is the use case for such a configuration and we reject
> it in mlxsw.

Maybe the problem has to do with the fact that Florian took the
.ndo_vlan_rx_add_vid() callback as a shortcut for deducing that there is
an 8021q upper interface.

Currently there are other places in the network stack that don't really
work with a network interface that has problems with an interface that
has "rx-vlan-filter: on" in ethtool -k. See this discussion with Jiri on
the use of tc-vlan:

https://www.spinics.net/lists/netdev/msg645931.html

So, even though today .ndo_vlan_rx_add_vid() is only called from 8021q,
maybe we should dispel the myth that it's specific to 8021q somehow.

Maybe DSA should start tracking its upper interfaces, after all? Not
convinced though.

Thanks,
-Vladimir
