Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6012E21DEC8
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgGMRdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgGMRdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:33:23 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3BDC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:33:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so14397852edq.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWYYzIBy9iI/ckcqWn+YHJngwJMnR96F9OhWLOgt8lo=;
        b=uBRbITT/zET1/8+UYVWWkQ4Ha/3BCe69WDEffDTGCt//1AQhjLAH/7Z8xXv/XjjM9+
         hyh6QAxTdzblVD7PxQlJFSusFaN0MGIyqmq5H5iiYfGrFSIOyqL6h6xIH+JnhhrWGyqL
         joYKBfk44GN3Oe+sz3TNUfhSxopf+HOahLbU5Ee7t9RvvddKF0tBXPV5ODupOBhCv9vF
         BI+B/QVp2Odavme+4qqrt3mjFwRWtmxwfDA8snrqPtOuFv2Wc7uRxRAwISP++Exi9IWB
         y9Nsshq84jn0OypzHypk559ivVJ3d50UZlxiDg642aSPqxBbokj7fjBULqYeqqyzGl5s
         bPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWYYzIBy9iI/ckcqWn+YHJngwJMnR96F9OhWLOgt8lo=;
        b=sfnLBqN/8t4xzOnmKWneqgXZ0+oxRyJizfCKAVBPzW6oD5Qrm0a+tJw8A/oY35SFRF
         EckMkXNSwNGiipwFBLH98PumfvTDSgZJVKUzhJyL+N9jFgGKKf2KAG5y/Xx7790jS2TA
         8fAM9ZxvpVLgWFUn83snFTiVdWjcwx3BHWlrybi3Sz9ejXn74Ouiyfip2SyuCokHVlMS
         CgqMd5gmoSrhMEB9BdaZEK4ZfqOtzjT8lmkEDzijNoWJSHUbgYAuK/ZMW00jvIO4MqtB
         zyCVwFm3qCKiYJViLCPr2DRECER49fg3aSwSM6RXhMyUk2IDQUHgZRzQ/IKQBjiVt/Hj
         Pc+A==
X-Gm-Message-State: AOAM532fNqG7Lknr/LmNLDusrbKiWn9VjFG40jew/4q2QiBWthcPC7KZ
        1Jsv/itGS5o8WeQ3jCLYk3k=
X-Google-Smtp-Source: ABdhPJxgbvZbHgcFMYByNgltMgjkpaHxJyrQD0louGO7x6dwv3Tvy9w0MQdaY+HN5iE3uLS1qUluxQ==
X-Received: by 2002:a05:6402:b72:: with SMTP id cb18mr465356edb.352.1594661601579;
        Mon, 13 Jul 2020 10:33:21 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id sa10sm10418643ejb.79.2020.07.13.10.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:33:21 -0700 (PDT)
Date:   Mon, 13 Jul 2020 20:33:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to get
 rid of lockdep warnings
Message-ID: <20200713173319.zjmqjzqmjcxw6gyf@skbuf>
References: <20200713162443.2510682-1-olteanv@gmail.com>
 <20200713164728.GH1078057@lunn.ch>
 <20200713173049.wzo7e2rpbtfbwdxd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713173049.wzo7e2rpbtfbwdxd@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 08:30:49PM +0300, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Mon, Jul 13, 2020 at 06:47:28PM +0200, Andrew Lunn wrote:
> > > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > > index 743caabeaaa6..a951b2a7d79a 100644
> > > --- a/net/dsa/slave.c
> > > +++ b/net/dsa/slave.c
> > > @@ -1994,6 +1994,13 @@ int dsa_slave_create(struct dsa_port *port)
> > >  			   ret, slave_dev->name);
> > >  		goto out_phy;
> > >  	}
> > > +	rtnl_lock();
> > > +	ret = netdev_upper_dev_link(master, slave_dev, NULL);
> > > +	rtnl_unlock();
> > > +	if (ret) {
> > > +		unregister_netdevice(slave_dev);
> > > +		goto out_phy;
> > > +	}
> > 
> > Hi Vladimir
> > 
> > A common pattern we see in bugs is that the driver sets up something
> > critical after calling register_netdev(), not realising that that call
> > can go off and really start using the interface before it returns. So
> > in general, i like to have register_netdev() last, nothing after it.
> > 
> > Please could you move this before register_netdev().
> > 
> > Thanks
> > 	Andrew
> 
> It doesn't work after register_netdev(). The call to

I mean it doesn't work when netdev_upper_dev_link() is _before_
register_netdev().

> netdev_upper_dev_link() fails and no network interface gets probed. VLAN
> performs registration and linkage in the same order:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/8021q/vlan.c#n175
> 
> So I think this part is fine.
> 
> Thanks,
> -Vladimir
