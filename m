Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03EA332051
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhCIIPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:15:23 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58641 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhCIIPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:15:19 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EF0DD5C0152;
        Tue,  9 Mar 2021 03:15:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 09 Mar 2021 03:15:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/avSBi
        upZQmCrCBgUarTrqPFs8/GDiFc9quyDJ1J+tE=; b=tWPFPJOsjWjCGj3D8pH8tx
        cggHiGGPsy/gL23b15ax+E0Cx+RAfaOnK7t2UpeoibJhfhQeFikH2+JXjJ/E3y9+
        6BSpGqxJYLl+hjDr2UGPFW4PcijoY6s+U5USYElcj1ltmbuUlsq71AAKNjbOCqwz
        HIS6rRojF6ygnZOlWN8cMje72km5N0asjJuK7RwRRGY2goAdDo5xhMFB8x4cjLwt
        oOJN7q+9aIogZRsX+HPsGEL19gfgRN1L9xalgKCsvhyasJwEXVL/p1QQNndbSxM0
        KIaGuu5xiufEatpNIa7Ockpcx1r98aLNXk3BXjvEi00079WFgczoCH8QCW7IUiDw
        ==
X-ME-Sender: <xms:li5HYFy8S31oAQyuQEVYV_mfSdMxqNxxfVEXKU8h3V5J-mUmaiF4uQ>
    <xme:li5HYFT3Pxk-F5Z8cb69g_SqJm-tigMN5Qm-7OtSb0SP5rSKxRGfLzYs22XmlSwCM
    94aOFHxONz7DyU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudduhedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:li5HYPUeQgkGZT9zru60J9K--NZjUtCysp1kggR6n38Fr7yYZ58esg>
    <xmx:li5HYHi4tp0yoPwMelpQDVeT6IkTIvdAD81ujhR2NvpVw5sK9srg_w>
    <xmx:li5HYHAfbKtqddmOQU_HmkA2C6wylMHKCzHVXZRACDqvF1nU5oCA0A>
    <xmx:li5HYJ3w0Oy25X7cIDRZdk9dsgqAHimJFJ_eR9s1R7leRHPTorpwFQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E605424005A;
        Tue,  9 Mar 2021 03:15:17 -0500 (EST)
Date:   Tue, 9 Mar 2021 10:15:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] ipv6: fix suspecious RCU usage warning
Message-ID: <YEcukkO7bsKYVqEZ@shredder.lan>
References: <20210308192113.2721435-1-weiwan@google.com>
 <0d18e982-93de-5b88-b3a5-efb6ebd200f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d18e982-93de-5b88-b3a5-efb6ebd200f2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 07:47:31PM -0700, David Ahern wrote:
> [ cc Ido and Petr ]
> 
> On 3/8/21 12:21 PM, Wei Wang wrote:
> > diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> > index 7bc057aee40b..48956b144689 100644
> > --- a/include/net/nexthop.h
> > +++ b/include/net/nexthop.h
> > @@ -410,31 +410,39 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
> >  int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
> >  		       struct netlink_ext_ack *extack);
> >  
> > -static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
> > +static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh,
> > +					      bool bh_disabled)
> 
> Hi Wei: I would prefer not to have a second argument to nexthop_fib6_nh
> for 1 code path, and a control path at that.
> 
> >  {
> >  	struct nh_info *nhi;
> >  
> >  	if (nh->is_group) {
> >  		struct nh_group *nh_grp;
> >  
> > -		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> > +		if (bh_disabled)
> > +			nh_grp = rcu_dereference_bh_rtnl(nh->nh_grp);
> > +		else
> > +			nh_grp = rcu_dereference_rtnl(nh->nh_grp);
> >  		nh = nexthop_mpath_select(nh_grp, 0);
> >  		if (!nh)
> >  			return NULL;
> >  	}
> >  
> > -	nhi = rcu_dereference_rtnl(nh->nh_info);
> > +	if (bh_disabled)
> > +		nhi = rcu_dereference_bh_rtnl(nh->nh_info);
> > +	else
> > +		nhi = rcu_dereference_rtnl(nh->nh_info);
> >  	if (nhi->family == AF_INET6)
> >  		return &nhi->fib6_nh;
> >  
> >  	return NULL;
> >  }
> >  
> 
> I am wary of duplicating code, but this helper is simple enough that it
> should be ok with proper documentation.
> 
> Ido/Petr: I think your resilient hashing patch set touches this helper.
> How ugly does it get to have a second version?

It actually doesn't touch this helper. Looks fine to me:

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index ba94868a21d5..6df9c12546fd 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -496,6 +496,26 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 	return NULL;
 }
 
+static inline struct fib6_nh *nexthop_fib6_nh_bh(struct nexthop *nh)
+{
+	struct nh_info *nhi;
+
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_bh(nh->nh_grp);
+		nh = nexthop_mpath_select(nh_grp, 0);
+		if (!nh)
+			return NULL;
+	}
+
+	nhi = rcu_dereference_bh(nh->nh_info);
+	if (nhi->family == AF_INET6)
+		return &nhi->fib6_nh;
+
+	return NULL;
+}
+
 static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
 {
 	struct fib6_nh *fib6_nh;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ef9d022e693f..679699e953f1 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2486,7 +2486,7 @@ static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
 	const struct net_device *dev;
 
 	if (rt->nh)
-		fib6_nh = nexthop_fib6_nh(rt->nh);
+		fib6_nh = nexthop_fib6_nh_bh(rt->nh);
 
 	seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
