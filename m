Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E539121DEC6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgGMRay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMRax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:30:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CFDC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:30:53 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so18165680ejq.6
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ufgH+KIQF4ucHcXcObqHa1HMkHrbW/Rw46J/1QnrK4=;
        b=ShX2vGdDu7Ry0EfBR8vrXAlvo9ZqOIYfPHz6DhZCVz0blafK8OIG+Mp4B/0iM3W3eP
         +Ot1/KQE3UNi7KU4l1zy2QzunghJ2J5pEssnKK4dFcQs8LX8WS1BbGScVz9UuJOz0doc
         H3iQo9fl+6lOE9tL2i7IFVdGWB+194quc79WkJjfP3M4Do6dz+Qm6Pak3Dv1HvcgfTEf
         xhwvgY6OXs/1c4k463VR0YXbQBvfzrDuvFVx8NiJv1QsHWDnUbd/S6JB+hLc/acxvz1E
         jCpHADFxyI1MoSSy9tJnG5Rjvn/75Ous45JVUXwI3LL/pKettOJWVu87DLB6+ALuzbHF
         pkoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ufgH+KIQF4ucHcXcObqHa1HMkHrbW/Rw46J/1QnrK4=;
        b=twcda6lK0cnJHeTugO+Twp+K1eGfIrDr+k/W88AIkqaHV+HTE7PzZCFTCu4LEYH6Bv
         P1ugoJfHemTeO1BqwstTw1VR0CNdnSDk5jIDo8zyEkO/OTLTi1i96m2jKBqUueYhd8K8
         N+P3JoGLUHqc2pEh84dALfkXLLtHJRgnppbz2EwB8jKcQq5FJEKrjdyAJIz0/ghMrZVq
         zQxInaVcu1p0nPrKOrZ+WTnJpi71RsJ8xIxo96MZ+VTqoxNboweByhIHvSmMvYow+CcB
         hEpAl0Icbx6NlFALbgBbPqXnO6oH260HuaSDnNeRCSeQXyUPjCOUw4bFWr8Babu97BS0
         IlHw==
X-Gm-Message-State: AOAM531eTKvSmNIzNPKES4+P4IKcNvmfPI6JucDdY1rrIMCop9wGDrWb
        OeWMv0DinAXcDd/Aq0dtNfM=
X-Google-Smtp-Source: ABdhPJzYJ6ED6aSAWJB7+t4bKiToHxOGHwdrsVwO1RtcUILsRvPNK82sw4ZeaZG3XIh9GqrocUYinA==
X-Received: by 2002:a17:906:4a17:: with SMTP id w23mr817349eju.360.1594661451847;
        Mon, 13 Jul 2020 10:30:51 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x19sm11631083eds.43.2020.07.13.10.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:30:51 -0700 (PDT)
Date:   Mon, 13 Jul 2020 20:30:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to get
 rid of lockdep warnings
Message-ID: <20200713173049.wzo7e2rpbtfbwdxd@skbuf>
References: <20200713162443.2510682-1-olteanv@gmail.com>
 <20200713164728.GH1078057@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713164728.GH1078057@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Jul 13, 2020 at 06:47:28PM +0200, Andrew Lunn wrote:
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 743caabeaaa6..a951b2a7d79a 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -1994,6 +1994,13 @@ int dsa_slave_create(struct dsa_port *port)
> >  			   ret, slave_dev->name);
> >  		goto out_phy;
> >  	}
> > +	rtnl_lock();
> > +	ret = netdev_upper_dev_link(master, slave_dev, NULL);
> > +	rtnl_unlock();
> > +	if (ret) {
> > +		unregister_netdevice(slave_dev);
> > +		goto out_phy;
> > +	}
> 
> Hi Vladimir
> 
> A common pattern we see in bugs is that the driver sets up something
> critical after calling register_netdev(), not realising that that call
> can go off and really start using the interface before it returns. So
> in general, i like to have register_netdev() last, nothing after it.
> 
> Please could you move this before register_netdev().
> 
> Thanks
> 	Andrew

It doesn't work after register_netdev(). The call to
netdev_upper_dev_link() fails and no network interface gets probed. VLAN
performs registration and linkage in the same order:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/8021q/vlan.c#n175

So I think this part is fine.

Thanks,
-Vladimir
