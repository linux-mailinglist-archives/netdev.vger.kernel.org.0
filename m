Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FA74DDF5A
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiCRQwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiCRQwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:52:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 998E9F461E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647622258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Z1CIOHDJ+f7FQCPqjiJgBzhbbMjP9ZnnZh3xPcl+EI=;
        b=E2jzoJpcVetze67YQhPQI6rI83KSwriPIPD0pZYAtSDERyygnMRMM3RoIlnDIM5WDSf1aZ
        /M5JJuZdM4UUU8kR18PRDMUToHbctF3em7IArkvqo38RD+TfFgdvYuug0xwhnDaHeqEDvr
        no3sGZaQsO+tWO9gu0BEsKIWTc/o2rg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-NyjeWNj3PT-5reHHM5Gjzw-1; Fri, 18 Mar 2022 12:50:57 -0400
X-MC-Unique: NyjeWNj3PT-5reHHM5Gjzw-1
Received: by mail-wm1-f70.google.com with SMTP id c62-20020a1c3541000000b003815245c642so6061968wma.6
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3Z1CIOHDJ+f7FQCPqjiJgBzhbbMjP9ZnnZh3xPcl+EI=;
        b=NsIjLk644YTXCd/NTkN9x9963XG0UvvN6BWIY56ml5CZ41R2epvXaARB20k9FPu/po
         gGv7TtEE6hYZC/4+Gd2hBYjgbmb98lFTQLDlhj5JyMGfOxsN9SEZ4rcJBTe7TWm8Bj9x
         RMAuVkw+tSSnanEUK0kas56Nohiwl/cPHhufhKaILs6w3gV+mY/cM3n+M7hEtnhq+VYq
         vRR5xET9aLNGQpgrHhEopVM1l+RQXpVZxmJhtOg8UWibi2AxOqhA0VwhBHfh8E7KMu9M
         SDRB1lybocSnBvz/ufTeoxe3AtJoOO2UhrrqZ+mngst4ys3KJKNgWCOcgNns7nP8r31r
         YHpQ==
X-Gm-Message-State: AOAM531FC+00odEXNajFbKT8cnhBkX6oiXqY3Wavup23DxtmzBuXL7Eo
        CgkZX9jo7TxmIGO5zj2c8IEfuUOB/19IsT/mCyhwNKI4d7k1ZpXeOsPovGhthwgfhZl7nv+xlee
        PBAt0p+asY1cI6nH3
X-Received: by 2002:a5d:5607:0:b0:203:fb6f:3c88 with SMTP id l7-20020a5d5607000000b00203fb6f3c88mr1588930wrv.261.1647622256140;
        Fri, 18 Mar 2022 09:50:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxl1Ah3iz5yoQkKgzcKRswE4UgA4QMsJIJbBeCr4zyyBOd1YzE13bkMMmoKhyfXo5Udgwk6Bg==
X-Received: by 2002:a5d:5607:0:b0:203:fb6f:3c88 with SMTP id l7-20020a5d5607000000b00203fb6f3c88mr1588917wrv.261.1647622255809;
        Fri, 18 Mar 2022 09:50:55 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm6657601wrv.10.2022.03.18.09.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:50:55 -0700 (PDT)
Message-ID: <0cf800e8bb28116fce7466cacbabde395abfac4f.camel@redhat.com>
Subject: Re: [PATCH v2] ipv6: acquire write lock for addr_list in
 dev_forward_change
From:   Paolo Abeni <pabeni@redhat.com>
To:     Niels Dossche <dossche.niels@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 18 Mar 2022 17:50:54 +0100
In-Reply-To: <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
References: <20220317155637.29733-1-dossche.niels@gmail.com>
         <7bd311d0846269f331a1d401c493f5511491d0df.camel@redhat.com>
         <a24b13ea10ca898bb003300084039b459d553f6d.camel@redhat.com>
         <13558e3e0ed23097f04bb90b43c261062dca9107.camel@redhat.com>
         <f8b7e306-916d-a3e7-5755-b71d6b118489@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-18 at 16:45 +0100, Niels Dossche wrote:
> On 18/03/2022 16:42, Paolo Abeni wrote:
> > On Fri, 2022-03-18 at 13:48 +0100, Paolo Abeni wrote:
> > > On Fri, 2022-03-18 at 10:13 +0100, Paolo Abeni wrote:
> > > > On Thu, 2022-03-17 at 16:56 +0100, Niels Dossche wrote:
> > > > > No path towards dev_forward_change (common ancestor of paths
> > > > > is in
> > > > > addrconf_fixup_forwarding) acquires idev->lock for idev-
> > > > > >addr_list.
> > > > > We need to hold the lock during the whole loop in
> > > > > dev_forward_change.
> > > > > __ipv6_dev_ac_{inc,dec} both acquire the write lock on idev-
> > > > > >lock in
> > > > > their function body. Since addrconf_{join,leave}_anycast call
> > > > > to
> > > > > __ipv6_dev_ac_inc and __ipv6_dev_ac_dec respectively, we need
> > > > > to move
> > > > > the responsibility of locking upwards.
> > > > > 
> > > > > This patch moves the locking up. For __ipv6_dev_ac_dec, there
> > > > > is one
> > > > > place where the caller can directly acquire the idev->lock,
> > > > > that is in
> > > > > ipv6_dev_ac_dec. The other caller is addrconf_leave_anycast,
> > > > > which now
> > > > > needs to be called under idev->lock, and thus it becomes the
> > > > > responsibility of the callers of addrconf_leave_anycast to
> > > > > hold that
> > > > > lock. For __ipv6_dev_ac_inc, there are also 2 callers, one is
> > > > > ipv6_sock_ac_join, which can acquire the lock during the call
> > > > > to
> > > > > __ipv6_dev_ac_inc. The other caller is addrconf_join_anycast,
> > > > > which now
> > > > > needs to be called under idev->lock, and thus it becomes the
> > > > > responsibility of the callers of addrconf_join_anycast to
> > > > > hold that
> > > > > lock.
> > > > > 
> > > > > Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> > > > > ---
> > > > > 
> > > > > Changes in v2:
> > > > >  - Move the locking upwards
> > > > > 
> > > > >  net/ipv6/addrconf.c | 21 ++++++++++++++++-----
> > > > >  net/ipv6/anycast.c  | 37 ++++++++++++++++-------------------
> > > > > --
> > > > >  2 files changed, 32 insertions(+), 26 deletions(-)
> > > > > 
> > > > > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > > > > index f908e2fd30b2..69e9f81e2045 100644
> > > > > --- a/net/ipv6/addrconf.c
> > > > > +++ b/net/ipv6/addrconf.c
> > > > > @@ -818,6 +818,7 @@ static void dev_forward_change(struct
> > > > > inet6_dev *idev)
> > > > >  		}
> > > > >  	}
> > > > >  
> > > > > +	write_lock_bh(&idev->lock);
> > > > >  	list_for_each_entry(ifa, &idev->addr_list, if_list)
> > > > > {
> > > > >  		if (ifa->flags&IFA_F_TENTATIVE)
> > > > >  			continue;
> > > > > @@ -826,6 +827,7 @@ static void dev_forward_change(struct
> > > > > inet6_dev *idev)
> > > > >  		else
> > > > >  			addrconf_leave_anycast(ifa);
> > > > >  	}
> > > > > +	write_unlock_bh(&idev->lock);
> > > > >  	inet6_netconf_notify_devconf(dev_net(dev),
> > > > > RTM_NEWNETCONF,
> > > > >  				     NETCONFA_FORWARDING,
> > > > >  				     dev->ifindex, &idev-
> > > > > >cnf);
> > > > > @@ -2191,7 +2193,7 @@ void addrconf_leave_solict(struct
> > > > > inet6_dev *idev, const struct in6_addr *addr)
> > > > >  	__ipv6_dev_mc_dec(idev, &maddr);
> > > > >  }
> > > > >  
> > > > > -/* caller must hold RTNL */
> > > > > +/* caller must hold RTNL and write lock idev->lock */
> > > > >  static void addrconf_join_anycast(struct inet6_ifaddr *ifp)
> > > > >  {
> > > > >  	struct in6_addr addr;
> > > > > @@ -2204,7 +2206,7 @@ static void
> > > > > addrconf_join_anycast(struct inet6_ifaddr *ifp)
> > > > >  	__ipv6_dev_ac_inc(ifp->idev, &addr);
> > > > >  }
> > > > >  
> > > > > -/* caller must hold RTNL */
> > > > > +/* caller must hold RTNL and write lock idev->lock */
> > > > >  static void addrconf_leave_anycast(struct inet6_ifaddr *ifp)
> > > > >  {
> > > > >  	struct in6_addr addr;
> > > > > @@ -3857,8 +3859,11 @@ static int addrconf_ifdown(struct
> > > > > net_device *dev, bool unregister)
> > > > >  			__ipv6_ifa_notify(RTM_DELADDR, ifa);
> > > > > 			inet6addr_notifier_call_chain(NETDEV_DOWN, ifa);
> > > > >  		} else {
> > > > > -			if (idev->cnf.forwarding)
> > > > > +			if (idev->cnf.forwarding) {
> > > > > +				write_lock_bh(&idev->lock);
> > > > >  				addrconf_leave_anycast(ifa);
> > > > > +				write_unlock_bh(&idev-
> > > > > >lock);
> > > > > +			}
> > > > >  			addrconf_leave_solict(ifa->idev,
> > > > > &ifa->addr);
> > > > >  		}
> > > > >  
> > > > > @@ -6136,16 +6141,22 @@ static void __ipv6_ifa_notify(int
> > > > > event, struct inet6_ifaddr *ifp)
> > > > >  				&ifp->addr, ifp->idev->dev-
> > > > > >name);
> > > > >  		}
> > > > >  
> > > > > -		if (ifp->idev->cnf.forwarding)
> > > > > +		if (ifp->idev->cnf.forwarding) {
> > > > > +			write_lock_bh(&ifp->idev->lock);
> > > > >  			addrconf_join_anycast(ifp);
> > > > > +			write_unlock_bh(&ifp->idev->lock);
> > > > > +		}
> > > > >  		if (!ipv6_addr_any(&ifp->peer_addr))
> > > > >  			addrconf_prefix_route(&ifp-
> > > > > >peer_addr, 128,
> > > > >  					      ifp-
> > > > > >rt_priority, ifp->idev->dev,
> > > > >  					      0, 0,
> > > > > GFP_ATOMIC);
> > > > >  		break;
> > > > >  	case RTM_DELADDR:
> > > > > -		if (ifp->idev->cnf.forwarding)
> > > > > +		if (ifp->idev->cnf.forwarding) {
> > > > > +			write_lock_bh(&ifp->idev->lock);
> > > > >  			addrconf_leave_anycast(ifp);
> > > > > +			write_unlock_bh(&ifp->idev->lock);
> > > > > +		}
> > > > >  		addrconf_leave_solict(ifp->idev, &ifp-
> > > > > >addr);
> > > > >  		if (!ipv6_addr_any(&ifp->peer_addr)) {
> > > > >  			struct fib6_info *rt;
> > > > > diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
> > > > > index dacdea7fcb62..f3017ed6f005 100644
> > > > > --- a/net/ipv6/anycast.c
> > > > > +++ b/net/ipv6/anycast.c
> > > > > @@ -136,7 +136,9 @@ int ipv6_sock_ac_join(struct sock *sk,
> > > > > int ifindex, const struct in6_addr *addr)
> > > > >  			goto error;
> > > > >  	}
> > > > >  
> > > > > +	write_lock_bh(&idev->lock);
> > > > >  	err = __ipv6_dev_ac_inc(idev, addr);
> > > > > +	write_unlock_bh(&idev->lock);
> > > > 
> > > > I feat this is problematic, due this call chain:
> > > > 
> > > >  __ipv6_dev_ac_inc() -> addrconf_join_solict() ->
> > > > ipv6_dev_mc_inc ->
> > > > __ipv6_dev_mc_inc -> mutex_lock(&idev->mc_lock);
> > > > 
> > > > The latter call requires process context.
> > > > 
> > > > One alternarive (likely very hackish way) to solve this could
> > > > be:
> > > > - adding another list entry  into struct inet6_dev, rtnl
> > > > protected.
> > > 
> > > Typo above: the new field should be added to 'struct
> > > inet6_ifaddr'.
> > > 
> > > > - traverse addr_list under idev->lock and add each entry with
> > > > forwarding on to into a tmp list (e.g. tmp_join) using the
> > > > field above;
> > > > add the entries with forwarding off into another tmp list (e.g.
> > > > tmp_leave), still using the same field.
> > > 
> > > Again confusing text above, sorry. As the forwarding flag is per
> > > device, all the addr entries will land into the same tmp list.
> > > 
> > > It's probably better if I sketch up some code...
> > 
> > For the records, I mean something alongside the following -
> > completely
> > not tested:
> > ---
> > diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> > index 4cfdef6ca4f6..2df3c98b9e55 100644
> > --- a/include/net/if_inet6.h
> > +++ b/include/net/if_inet6.h
> > @@ -64,6 +64,7 @@ struct inet6_ifaddr {
> >  
> >  	struct hlist_node	addr_lst;
> >  	struct list_head	if_list;
> > +	struct list_head	if_list_aux;
> >  
> >  	struct list_head	tmp_list;
> >  	struct inet6_ifaddr	*ifpub;
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index b22504176588..27d1081b693e 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -797,6 +797,7 @@ static void dev_forward_change(struct inet6_dev
> > *idev)
> >  {
> >  	struct net_device *dev;
> >  	struct inet6_ifaddr *ifa;
> > +	LIST_HEAD(tmp);
> >  
> >  	if (!idev)
> >  		return;
> > @@ -815,9 +816,17 @@ static void dev_forward_change(struct
> > inet6_dev *idev)
> >  		}
> >  	}
> >  
> > +	rcu_read_lock();
> >  	list_for_each_entry(ifa, &idev->addr_list, if_list) {
> >  		if (ifa->flags&IFA_F_TENTATIVE)
> >  			continue;
> > +		list_add_tail(&ifa->if_list_aux, &tmp);
> > +	}
> > +	rcu_read_unlock();
> > +
> > +	while (!list_empty(&tmp)) {
> > +		ifa = list_first_entry(&tmp, struct inet6_ifaddr,
> > if_list_aux);
> > +		list_del(&ifa->if_list_aux);
> >  		if (idev->cnf.forwarding)
> >  			addrconf_join_anycast(ifa);
> >  		else
> > 
> 
> I see, nice small change.
> Only thing I notice is that list_for_each_entry_rcu should be used
> instead of list_for_each_entry inside the rcu lock, right?

Yes you are right. Or you can replace rcu_read_lock() with
write_lock_bh(&idev->lock).

Probably we need some commend nearby if_list_aux definition alike "used
to safely traverse the idev address list in process context, see
dev_forward_change"

Cheers,

Paolo

 

