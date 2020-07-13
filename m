Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E45121DEEA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgGMRmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgGMRmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:42:32 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4009C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:42:31 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id rk21so18228494ejb.2
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BjgqlvfqIhsYsh2Wk/vWfk6RyWMFU7YZYcGt5BByfQs=;
        b=D+48bpMrO9sz74tQryGcLzokarzFr7Sj9Bv+6lQVhL6GyO6vxCN+E3E1VItvO0A5Tb
         l3oQizeAM6xvP/eM39o4GB5poqhFN8N7F65HN9szOSdBnyybIaAezZnwnzXB+Ij9XGsm
         DBS6Nn41tgRcb9O7DfYgqTOI+XFyqCXVcFsWH1Iuzn0dt0w74IAs1DLf6lxlI6QZHl1C
         KiuY6FOhSiM2bG7hkWZwhfy8EMkt1KJkttqPCOD6Lv8D9OqnoSijpedLZP16HBHHBIp7
         NSBW4C/bP+PntMcLC9TEV1iIErt0cMIkzdTPIblygjK6Zh+KGY/51/AAfpIp0vQrauFw
         Utng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BjgqlvfqIhsYsh2Wk/vWfk6RyWMFU7YZYcGt5BByfQs=;
        b=M4RVWOsrE4Or6Meq0ai8FX/UWenGzj0GyYmG7Uj/bRWcagYtof6M3/oWrg/9GnsF4u
         dAZwTJUF+F92egQyJPkC6KiAqfV1R0lCXoC4BBD4sy96x56ky7gPbaDUXAfImyssQuq6
         WLYXAWneuRSP/RdhijNRqoNxmn9q5mIpoRtAs39W5qaqGjzggXf2PLEHT3eOLNuVH2ur
         GF+Iw3MBieufezixl7iPkxBhaDPopwSryKqERnxFSKdJHfrTG1+x/vg4lx/Dg02LU/AH
         K1xmzdqosqBp5i1xzRGM75ZyMyrJ9gL2adzNccAZb8zk6t5Vf2Moaa45tYIeAjQs0oH9
         3E9Q==
X-Gm-Message-State: AOAM533lsEgXY1B897WgaqxvcPZGU9AE57ifmcy8JEJW4JXlSc/juwMo
        0kgugNC0PXnujIOSfpbk+Do=
X-Google-Smtp-Source: ABdhPJy8Rv+32eA8H5qyDQs6GHl4lXgzSH+4akByJ01tPNCasIrKzL3flNwwGWZ7k+zjWYQNKx8TCg==
X-Received: by 2002:a17:906:60d0:: with SMTP id f16mr781090ejk.17.1594662150409;
        Mon, 13 Jul 2020 10:42:30 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id o15sm11991672edv.55.2020.07.13.10.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:42:29 -0700 (PDT)
Date:   Mon, 13 Jul 2020 20:42:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to get
 rid of lockdep warnings
Message-ID: <20200713174227.p6owrtgyccxfbuj5@skbuf>
References: <20200713162443.2510682-1-olteanv@gmail.com>
 <20200713164728.GH1078057@lunn.ch>
 <20200713173049.wzo7e2rpbtfbwdxd@skbuf>
 <20200713173319.zjmqjzqmjcxw6gyf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713173319.zjmqjzqmjcxw6gyf@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 08:33:19PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 13, 2020 at 08:30:49PM +0300, Vladimir Oltean wrote:
> > Hi Andrew,
> > 
> > On Mon, Jul 13, 2020 at 06:47:28PM +0200, Andrew Lunn wrote:
> > > > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > > > index 743caabeaaa6..a951b2a7d79a 100644
> > > > --- a/net/dsa/slave.c
> > > > +++ b/net/dsa/slave.c
> > > > @@ -1994,6 +1994,13 @@ int dsa_slave_create(struct dsa_port *port)
> > > >  			   ret, slave_dev->name);
> > > >  		goto out_phy;
> > > >  	}
> > > > +	rtnl_lock();
> > > > +	ret = netdev_upper_dev_link(master, slave_dev, NULL);
> > > > +	rtnl_unlock();
> > > > +	if (ret) {
> > > > +		unregister_netdevice(slave_dev);
> > > > +		goto out_phy;
> > > > +	}
> > > 
> > > Hi Vladimir
> > > 
> > > A common pattern we see in bugs is that the driver sets up something
> > > critical after calling register_netdev(), not realising that that call
> > > can go off and really start using the interface before it returns. So
> > > in general, i like to have register_netdev() last, nothing after it.
> > > 
> > > Please could you move this before register_netdev().
> > > 
> > > Thanks
> > > 	Andrew
> > 
> > It doesn't work after register_netdev(). The call to
> 
> I mean it doesn't work when netdev_upper_dev_link() is _before_
> register_netdev().
> 
> > netdev_upper_dev_link() fails and no network interface gets probed. VLAN
> > performs registration and linkage in the same order:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/8021q/vlan.c#n175
> > 
> > So I think this part is fine.
> > 
> > Thanks,
> > -Vladimir

One difference from VLAN is that in that case, the entire
register_vlan_device() function runs under RTNL.
When those bugs that you talk about are found, who starts using the
network interface too early? User space or someone else? Would RTNL be
enough to avoid that?

Thanks,
-Vladimir
